

int LAYERS[] = {8,8,16,3,16,8,8};
Neuron n[][];

float TEACHSPEED = 255.0*50.0*8.0;
float SPEED = 2.0;

float GRAPY = 0;
float GRAPX = 0;
float GRAPSTEP = 10;

float IN[];

int graph[];
int graph2[];

int register = 0;

int q = 0;

PGraphics gr;

void setup(){
	size(255,255,OPENGL);
	background(0);
	stroke(255);


	//init neurons

	n = new Neuron[LAYERS.length][0];
	IN = new float[LAYERS[0]];

	gr = createGraphics(width,32,JAVA2D);

	for(int i = 0;i < LAYERS.length;i++){

		for(int t = 0;t < LAYERS[i];t++){

			n[i] = (Neuron[])expand(n[i],n[i].length+1);
			n[i][n[i].length-1] = new Neuron(i);
			GRAPX+=GRAPSTEP;
		}

		if(i==0){


			n[i] = (Neuron[])expand(n[i],n[i].length+1);
			n[i][n[i].length-1] = new Neuron(i,0);

			GRAPX+=GRAPSTEP;
			n[i] = (Neuron[])expand(n[i],n[i].length+1);
			n[i][n[i].length-1] = new Neuron(i,1);
			GRAPX+=GRAPSTEP;

		}

		GRAPY+=GRAPSTEP;
		GRAPX=0;

	}

	for(int i = 0;i < LAYERS.length;i++){
		for(int t = 0;t < LAYERS[i];t++){
			fillIns(i,t);
		}
	}




	//graphing
	graph = new int[width];
	graph[0] = 127;

	for(int i =1;i<width;i++){
		graph[i] = graph[i-1]+(int)random(-6,6);
		graph[i] = constrain(graph[i],0,height);

	}

	textFont(createFont("Veranda",9));
	fill(255);
}


//functions


void inputting(){

	String pos = nf(parseInt(binary(q)),8)+"";


	for(int i = 0;i<IN.length;i++){
		int w = parseInt(pos.charAt(i))-48;
		IN[i] = w;


	}



}

void act(){
	for(int i = 0;i < LAYERS.length;i++){
		for(int t = 0;t < LAYERS[i];t++){
			n[i][t].act();
		}
	}

}

void fillIns(int l,int _n){

	if(l!=0){
		n[l][_n].ins = getIns2(l-1);
		n[l][_n].initW();
	}
}

int[] getIns2(int lay){

	int vse[] = new int[n[lay].length];
	for(int i =0;i<vse.length;i++){
		vse[i] = i;
	}
	return vse;

}


void illustrate(float x,float y){

	pushMatrix();
	translate(x,y);
	for(int i =0;i<n.length;i++){

		for(int t =0;t<n[i].length;t++){

			Neuron tmp = n[i][t];
			noFill();
			stroke(tmp.val*255);
			rect(tmp.x,tmp.y,2,2);

			if(i!=0){
				//for(int q = 0;q<n[i][t].ins.length;q++){
				//	Neuron kdo = n[tmp.layer-1][tmp.ins[q]];
				//	stroke(255,50);
				//	line(tmp.x,tmp.y,kdo.x,kdo.y);
				//}
			}
		}
	}
	popMatrix();

}

//////////////////////////

void draw(){

	background(0);

	float y = map(mouseY,0,height,0,2);

	stroke(255);
	if(frameCount%100==0)q++;
	if(q>=width)q=0;
	if(q==0){
		resetGr();
	}

	for(int i =1;i<width;i++){

	}


	line(q,0,q,height);

	inputting();
	act();

	for(int i =0;i<LAYERS[LAYERS.length-1];i++){
		String pos = nf(parseInt(binary(graph[q])),8)+"";
		float w = parseInt(pos.charAt(i))-48;
		backProp(w,1.0,i,1);

	}



	drawGr();
	illustrate(10,10);
	image(gr,0,height-32);

	fill(255);
	text(nf(parseInt(binary(graph[q])),8),q+2,10);
	text(nf(parseInt(binary(q)),8),q+2,20);



	for(int i =1;i<width;i++){

		stroke(255);
		line(i,graph[i],i,graph[i]+1);
	}



}

void backProp(float target,float top,int iid,float rate){
	target = norm(target,0,top);

	Neuron temp = n[LAYERS.length-1][iid];// = n[i][idd];

	for(int p = LAYERS.length-2;p>0;p--){

		int next= 0;
		float topp = 0.0;

		for(int q = 0;q<temp.w.length;q++){
			//m.k[i-1][q].val -= (target-m.k[i-1][q].val)*(rate/m.k[i-1].length);
			//m.k[i-1][t].w[q] += TEACHSPEED*((derivative(map(m.k[i-1][q].val-target,-1,1,0,1),1,SLOPE))-m.k[i-1][q].val);
			if(topp<(derivative(map(n[temp.layer-1][temp.ins[q]].val-temp.val,-1,1,0,width),width,4.0))){
				topp = (derivative(map(n[temp.layer-1][temp.ins[q]].val-temp.val,-1,1,0,width),width,4.0));
				next = q;
			}

			temp.w[q] += ((derivative(map(n[temp.layer-1][temp.ins[q]].val-target,-1,1,0,width),width,4.0))-temp.w[q])/TEACHSPEED;
		}

		temp = n[p][next];
	}

	/*

	for(int i = LAYERS.length-2;i>0;i--){
	for(int t = 0;t<LAYERS[i];t++){


	temp = n[i][t];

	for(int q = 0;q<temp.w.length;q++){
		//m.k[i-1][q].val -= (target-m.k[i-1][q].val)*(rate/m.k[i-1].length);
		//m.k[i-1][t].w[q] += TEACHSPEED*((derivative(map(m.k[i-1][q].val-target,-1,1,0,1),1,SLOPE))-m.k[i-1][q].val);
		temp.w[q] += ((derivative(target-map(n[i-1][temp.ins[q]].val,-1,1,0,1),1.0,4.0))-temp.w[q])/TEACHSPEED;
}

	//m.k[i-1][closest].val += (1.0-m.k[i-1][closest].val)*rate;


}
}*/

}

void drawGr(){
	gr.beginDraw();
	//gr.background(0);

	for(int i =0;i<IN.length;i++){

		if((nf(parseInt(binary(graph[q])),8).charAt(i)+"").equals("1")){
			gr.stroke(#ff0000);

		}else{
			gr.stroke(0);


		}
		gr.line(q,i*2,q,i*2+1);

		if((nf(parseInt(binary(q)),8).charAt(i)+"").equals("1")){
			gr.stroke(#ffcc00);
		}else{
			gr.stroke(0);


		}
		gr.line(q,i*2+16,q,i*2+17);

	}
	gr.endDraw();

}

void resetGr(){
	//	gr.beginDraw();
	//	gr.background(0);
	//	gr.endDraw();
	//gr = createGraphics(width,32,JAVA2D);
}


void mousePressed(){

	for(int i =1;i<width;i++){
		graph[i] = graph[i-1]+(int)random(-4,4);
		graph[i] = constrain(graph[i],0,height);
	}
}

class Neuron{

	float x,y;

	float val;
	int id;
	int[] ins;
	float[] w;
	boolean active;
	int layer;
	//Mozek parent;

	Neuron(int _layer){
		id = register;
		register++;
		//parent = _parent;

		// prvni / posledni / jine?
		layer = _layer;

		ins = new int[0];
		val = 0;//random(0,100)*0.01;
		active = true;

		x = GRAPX;
		y = GRAPY;

		if(layer==0){
			val = IN[id];
		}

	}

	Neuron(int _layer,float _val){
		id = register;
		register++;
		//parent = _parent;

		// prvni / posledni / jine?
		layer = _layer;

		ins = new int[0];
		val = _val;
		x = GRAPX;
		y = GRAPY;

	}

	void initW(){
		w = new float[ins.length];
		for(int i =0;i<w.length;i++){
			w[i] = random(0,100)*0.01;
		}

	}

	void act(){
		//if(!learning)
		refresh();


	}

	void refresh(){
		if(layer>0){
			//if(learning){
			float soucet = 0;

			for(int i = 0;i<ins.length;i++){
				w[i] = constrain(w[i],0,1);
				//if(parent.k[layer-1][ins[i]].active)
				soucet += n[layer-1][ins[i]].val*w[i];
			}


			val += (sigmoid2(soucet,ins.length/2.0,2.0)-val)/SPEED;
			val = constrain(val,0,1);
			//}

		}else{
			val = IN[id];
		}

	}

	void stochaist(float kolik){

		val += random(-100,100)/kolik;
		val = constrain(val,0.0,1.0);

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
