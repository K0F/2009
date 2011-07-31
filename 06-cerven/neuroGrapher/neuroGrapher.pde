// layer set
int[] LAYERS = {16,16,16,8};

// sigmoidal slope
float SLOPE = 2.0;

//learning constant 0.296875 : 1.0
float SPEED = 1.2;//0.19;
float TEACHSPEED = 1000.25;//0.25;//SPEED/0.296875;//0.64;

// noise ?
boolean STOCHAIST = false;
// so how much (1/x) ?
float NOISEAMOUNT = 10000.0;

//inputs
float IN[] = new float[LAYERS[0]];

int CURRENT = 0;

int tarvals[];

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

boolean learning = true;

void setup(){


	size(255,200,P3D);
	background(255);
	stroke(0);

	tarvals =new int[width];
	smoothing =new float[width];

	result = new float[width];

	tarvals[0] = 128;//random(0,100)*0.01;
	for(int i = 1 ;i<tarvals.length;i++){
		tarvals[i] = tarvals[i-1]+(int)random(-3,3);
		tarvals[i] = constrain(tarvals[i],1,255);
		smoothing[i] = 0;
	}

	m = new Mozek();

	//println(nf(parseInt(binary(200)),8));

}




void draw(){
	background(255);

	/*
	fill(255,15);
	noStroke();
	rect(0,0,width,height);
	noFill();
	stroke(0);

	*/
	int i = (frameCount%width);

	//for(int i =0;i<width;i++){
	String a = ""+nf(parseInt(binary(tarvals[i])),8);

	IN[0] = parseInt(""+a.charAt(0));
	IN[1] = parseInt(""+a.charAt(1));


	IN[2] = parseInt(""+a.charAt(2));
	IN[3] = parseInt(""+a.charAt(3));

	IN[4] = parseInt(""+a.charAt(4));
	IN[5] = parseInt(""+a.charAt(5));

	IN[6] = parseInt(""+a.charAt(6));
	IN[7] = parseInt(""+a.charAt(7));

	a = ""+nf(parseInt(binary(i)),8);

	IN[8] = parseInt(""+a.charAt(0));
	IN[9] = parseInt(""+a.charAt(1));

	IN[10] = parseInt(""+a.charAt(2));
	IN[11] = parseInt(""+a.charAt(3));

	IN[12] = parseInt(""+a.charAt(4));
	IN[13] = parseInt(""+a.charAt(5));

	IN[14] = parseInt(""+a.charAt(6));
	IN[15] = parseInt(""+a.charAt(7));



	String res = "";

	for(int er = 0;er<m.k[LAYERS.length-1].length;er++){
		if(m.k[LAYERS.length-1][er].val>=0.0){
			res += "1";
		}else{
			res += "0";

		}
	}


	result[i] = unbinary(res);



	smoothing[i] += (result[i]-smoothing[i])/2.0;

	stroke(255,0,0);
	rect(i,tarvals[i],2,2);

	
	 res = ""+nf(parseInt(binary(tarvals[i])),8);

	if(learning){

		for(int b = 0;b<LAYERS[LAYERS.length-1];b++){

			teach(parseInt(""+res.charAt(b)),1,TEACHSPEED);

		}
		//m.act();

	}

	m.act();


	//}


	//m.act();
	//interact();



	for( i = 0;i<result.length;i++){
		stroke(0);
		line(i,smoothing[i],i,smoothing[i]+1);

	}

	illustrate(10,10);

}

void mousePressed(){

	tarvals[0] = 128;//random(0,100)*0.01;
	for(int i = 1 ;i<tarvals.length;i++){
		tarvals[i] = tarvals[i-1]+(int)random(-3,3);
		tarvals[i] = constrain(tarvals[i],1,255);
		//smoothing[i] = 0;
	}


}

void keyPressed(){

	if(key == ' '){
		learning = !learning;
		println("learning: "+learning);

	}else if(key == 'w'){
		for(int i = 0;i<LAYERS.length;i++){

			for(int l = 0;l<LAYERS[i];l++){
				println(m.k[i][l].w[0]);
			}
		}
	}
}

void interact(){
	mapping();
}

void mapping(){

	float spmin = 0.0;

	float spmax = 1;

	float tmin = 0;
	float tmax = 1;

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
					stroke(0,5);
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

			for(int q = 0;q<temp.w.length;q++){
				//m.k[i-1][q].val -= (target-m.k[i-1][q].val)*(rate/m.k[i-1].length);
				//m.k[i-1][t].w[q] += TEACHSPEED*((derivative(map(m.k[i-1][q].val-target,-1,1,0,1),1,SLOPE))-m.k[i-1][q].val);
				temp.w[q] += ((derivative(map(m.k[i-1][temp.ins[q]].val-target,-1,1,0,1),1,SLOPE))-temp.w[q])/TEACHSPEED;
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

	return(float)(1.0-(sigmoid2(input,norm,slope)*(1.0-sigmoid2(input,norm,slope)))*4.0);
}
