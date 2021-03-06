// layer set
int[] LAYERS = {2,4,16,32,4,1};

// sigmoidal slope
float SLOPE = 2.0;

//learning constant 0.296875 : 1.0
float SPEED = 1/(64.0*64.0);;
float TEACHSPEED = 1/(64.0*64.0*10);//0.0296875;//0.64;

int TEACHROUNDS = 64;

// noise ?
boolean STOCHAIST = true;
// so how much (1/x) ?
float NOISEAMOUNT = 10000.0;

//inputs
float IN[] = new float[LAYERS[0]];

int CURRENT = 0;

float tarvals[];

// brain class
Mozek m;

// x,y
float GRAPX = 0;
float GRAPY = 0;
float GRAPSTEP = 10;

// global id register
int register = 0;


float result[];
float smoothing[];

PImage in;
int SCALE = 1;

Recorder r;
boolean rec = true;

void setup(){
	in = loadImage("input.png");

	size(SCALE*in.width,SCALE*in.height,OPENGL);
	background(255);
	stroke(0);



	tarvals =new float[in.pixels.length];
	smoothing =new float[in.pixels.length];

	result = new float[in.pixels.length];

	IN[0] = 0.5;
	IN[1] = 0.5;


	tarvals[0] = 0.5;//random(0,100)*0.01;
	for(int i = 1 ;i<tarvals.length;i++){
		tarvals[i] = tarvals[i-1]+random(-100,100)*0.0005;
		tarvals[i] = constrain(tarvals[i],0.1,0.9);
		smoothing[i] = 0;
	}

	m = new Mozek();

	if(rec)
		r = new Recorder("out","brainEye2.mp4");
}

void draw(){
	fill(255,15);
	noStroke();
	rect(0,0,width,height);
	noFill();
	//noStroke(0);

/*
	for(int y =0;y<in.height;y++){

		for(int x =0;x<in.width;x++){
			int i = y*in.width+x;
			IN[0] = norm(x,0,in.width);
			IN[1] = norm(y,0,in.height);

			result[i] = m.k[LAYERS.length-1][0].val;
			smoothing[i] += (result[i]-smoothing[i])/4.0;


			if(frameCount<TEACHROUNDS)
				teach(brightness(in.pixels[i]),255,TEACHSPEED);
			m.act();



		}

	}



	for(int x =0;x<in.width;x++){
		for(int y =0;y<in.height;y++){
			int i = y*in.width+x;
			IN[0] = norm(x,0,in.width);
			IN[1] = norm(y,0,in.height);

			result[i] = m.k[LAYERS.length-1][0].val;
			smoothing[i] += (result[i]-smoothing[i])/4.0;


			if(frameCount<TEACHROUNDS)
				teach(brightness(in.pixels[i]),255,TEACHSPEED);
			m.act();



		}

	}


	for(int y =in.height-1;y>=0;y--){

		for(int x = in.width-1;x>=0;x--){
			int i = y*in.width+x;
			IN[0] = norm(x,0,in.width);
			IN[1] = norm(y,0,in.height);

			result[i] = m.k[LAYERS.length-1][0].val;
			smoothing[i] += (result[i]-smoothing[i])/4.0;

			fill(smoothing[i]*255);
			rect(x*SCALE,y*SCALE,SCALE,SCALE);

			if(frameCount<TEACHROUNDS)
				teach(brightness(in.pixels[i]),255,TEACHSPEED);
			m.act();
		}

	}

*/

	for(int x = in.width-1;x>=0;x--){
		for(int y =in.height-1;y>=0;y--){
			int i = y*in.width+x;
			IN[0] = norm(x,0,in.width);
			IN[1] = norm(y,0,in.height);

			result[i] = m.k[LAYERS.length-1][0].val;
			smoothing[i] += (result[i]-smoothing[i])/2.0;

			fill(smoothing[i]*255);
			rect(x*SCALE,y*SCALE,SCALE,SCALE);

			if(frameCount<TEACHROUNDS)
				teach2(brightness(in.pixels[i]),255,TEACHSPEED);
			m.act();
		}
	}

	if(rec)
		r.add();
	//interact();

	//illustrate(10,10);
}

void keyPressed(){

	if(key=='q'){
		if(rec)
			r.finish();
		exit();
	}

}

void mousePressed(){
	tarvals[0] = 0.5;//random(0,100)*0.01;
	for(int i = 1 ;i<tarvals.length;i++){
		tarvals[i] = tarvals[i-1]+random(-100,100)*0.0005;
		tarvals[i] = constrain(tarvals[i],0.1,0.9);
	}
}

void interact(){
	mapping();
}

void mapping(){

	float spmin = 0.18;

	float spmax = 0.22;

	float tmin = 0.6;
	float tmax = 0.7;

	SPEED = map(mouseX,0,width,spmin,spmax);
	TEACHSPEED = map(height-mouseY,0,height,tmin,tmax);

	if(mousePressed){
		println("X:"+map(mouseX,0,width,spmin,spmax));

		println("Y:"+map(height-mouseY,0,height,tmin,tmax)+"\n");

	}
}

void illustrate(float x,float y){

	pushMatrix();
	translate(x,y);
	for(int i =0;i<m.k.length;i++){

		for(int t =0;t<m.k[i].length;t++){

			Keuron tmp = m.k[i][t];
			stroke(map(tmp.val,0,1,255,0));
			rect(tmp.x,tmp.y,2,2);

			if(i!=0){
				for(int q = 0;q<m.k[i][t].ins.length;q++){
					Keuron kdo = m.k[tmp.layer-1][tmp.ins[q]];
					stroke(0,15);
					line(tmp.x,tmp.y,kdo.x,kdo.y);
				}
			}
		}
	}
	popMatrix();

}

void teach(float target,float top,float rate){

	target = norm(target,0,top);

	Keuron temp;

	for(int i = LAYERS.length-1;i>0;i--){
		for(int t = 0;t<LAYERS[i];t++){


			temp = m.k[i][t];

			int closest = 0;
			float less = 10.;

			for(int q = 0;q<LAYERS[temp.layer-1];q++){
				if(abs(m.k[i-1][q].val-target)<less){
					less = abs(m.k[i-1][q].val-target);
					closest = q;
				}
				//m.k[i-1][q].val -= (target-m.k[i-1][q].val)*(rate/m.k[i-1].length);
				m.k[i-1][q].val += TEACHSPEED*((derivative(map(m.k[i-1][q].val-target,-1,1,0,1),1,SLOPE))-m.k[i-1][q].val);
			}

			//m.k[i-1][closest].val += (1.0-m.k[i-1][closest].val)*rate;


		}
	}
}


void teach2(float target,float top,float rate){

	target = norm(target,0,top);

	Keuron temp;

	for(int i = LAYERS.length-1;i>0;i--){
		for(int t = 0;t<LAYERS[i];t++){

			temp = m.k[i][t];

			for(int q = 0;q<LAYERS[temp.layer-1];q++){				
				//m.k[i-1][q].val -= (target-m.k[i-1][q].val)*(rate/m.k[i-1].length);
				temp.w[q] += TEACHSPEED * ( abs(m.k[i-1][q].val-target ) - (temp.w[q]) );
			}

			//m.k[i-1][closest].val += (1.0-m.k[i-1][closest].val)*rate;
		}
	}
}



// toxi's

public float sigmoid(float x, float normV, float sharpness) {
	x=(x/normV*2-1)*5*sharpness;
	return 1.0f / (1.0f + (float)Math.exp(-x));
}


public double sigmoid(double x, double normV, double sharpness) {
	x=(x/normV*2-1)*5*sharpness;
	return 1.0 / (1.0 + Math.exp(-x));
}

// kof mod

float sigmoid2(float x, float norm, float slope) {
	x = (x / norm * 2 - 1) * 5 * slope;
	return (float) (1.0/( 1.0 + Math.pow( Math.E ,(-1.0 * x ))));
}


float derivative(float input,float norm,float slope){
	input = sigmoid2(input,norm,slope);
	return(float)(1.0-(input*(1.0-input))*4.0);
}
