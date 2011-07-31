
int GLOBX = 0;
int GLOBID = 0;
int GLOBSTEP = 3;

NP[] neurons;

int W = 16;
int H = 40;

float IN[] = new float[W];

int counter =1;
String tmp = "";
int imgNo = 0;

PGraphics graphing;
float graph[] = new float [480];
float graph2[] = new float [480];

color globcol = #FFCC00;

void setup(){
	size(480,240,OPENGL);
	background(0);


	//imageMode(CENTER);
	neurons = new NP[W*H];


	recycle();

	for(int i = 0 ; i<graph.length ; i++){
		graph[i] = 0;
		graph2[i] = 0;

	}

	for(int metalay = 0;metalay < H;metalay++){
		for(int metamember = 0;metamember < W;metamember++){
			//println("neuron no. "+GLOBID+" created");
			neurons[GLOBID] = new NP(metalay);

		}
	}

	for(int i = 0 ; i<neurons.length ; i++){
		neurons[i].postSet();
	}

	for(int i =0;i<IN.length;i++)
		IN[i] = random(1,1001)*0.001;

	for(int i = 0 ; i<neurons.length ; i++){
		neurons[i].refresh();
		fill(map(neurons[i].val,0,1,0,255));
		neurons[i].disp();

	}

	for(int i = 0 ; i<neurons.length ; i++){
		neurons[i].compute();
	}

	stroke(255);
	noFill();

	noSmooth();
	textFont(createFont("Veranda",9));

}

void recycle(){



	graphing = createGraphics(width,height,P2D);
	//graphing.colorMode(ARGB);
	graphing.beginDraw();
	graphing.noStroke();
	graphing.noSmooth();
	graphing.endDraw();

}

void drawTo(){

	graphing.beginDraw();
	graphing.stroke(0,20);
	graphing.line(counter,0,counter,height);
	graphing.endDraw();

	
	

	graphing.beginDraw();
	graphing.pushMatrix();
	//graphing.translate(0,graph[graph.length-1]-50);
	for(int i =0;i<graph.length;i++){
		graph[i] += (map(unbinary(tmp),0,65536,0,255)-graph[i])/(i*2.0);
		globcol = lerpColor(#ff0000,#00ff00,norm(graph2[i]-graph[i],-4,4));
		graphing.stroke(255,40);
		
		if(i%20==0){
			graphing.line(counter-1,map(graph2[i],255,0,10,height-10),counter,map(graph[i],255,0,10,height-10));
		//
	}
		pushMatrix();
		
		if(i%20==0){
		stroke(255,50);
		}else{
		stroke(255,10);
		
		}
		translate(counter,map(graph[i],255,0,10,height-10));
		rotate(atan2(graph2[i]-graph[i],1));
		line(-20,0,-40,0);
		line(20,0,40,0);
		popMatrix();
	
		graphing.stroke(globcol,20);
		graphing.point(counter,map(graph[i],255,0,10,height-10));

		graph2[i]=graph[i];
	}
	
	graphing.popMatrix();
	graphing.endDraw();

	graphing.beginDraw();

	for(int i =0;i<W;i++){
		if(parseInt(tmp.charAt(i)-48)==1){
			graphing.stroke(#FF0000,100);
		}else{
			graphing.stroke(0,20);


		}
		graphing.line(counter,height-i*2,counter,height-i*2-1);

	}
	graphing.endDraw();


	/*

	for(int i =0;i<graph.length;i++){
		graph[i] += (unbinary(tmp)-graph[i])/(i*2.0);

		graphing[in].beginDraw();
		graphing[in].stroke(255,100);
		if(i%20==0)
			graphing[in].line(counter-1,map(graph2[i],255,0,10,height-10),counter,map(graph[i],255,0,10,height-10));
		//

		graphing[in].stroke(255,10);
		graphing[in].point(counter,map(graph[i],255,0,10,height-10));
		graphing[in].endDraw();
		graph2[i]=graph[i];
}*/
}

void draw(){
	background(0);



	image(graphing,0,0);


	for(int i =0;i<IN.length;i++)
		IN[i] = random(500,1000)*0.001;

	pushMatrix();
	translate(5,5);
	for(int i = 0 ; i<neurons.length ; i++){
		neurons[i].refresh();
		stroke(map(neurons[i].val,0.5,1,0,255));
		neurons[i].disp();

	}
	popMatrix();




	for(int i = 0 ; i<neurons.length ; i++){
		neurons[i].compute();
	}

	tmp = "";

	NP[] last = getLayerMembers(H-1);

	for(int i = 0 ; i<last.length ; i++){
		if(last[i].val>0.5){
			tmp+="1";
		}else{
			tmp+="0";
		}
	}


	drawTo();




	stroke(255);

	counter ++;
	if(counter>width){
		counter=1;
	}



	pushStyle();
	fill(255);
	text(tmp+" = "+unbinary(tmp),330,10);
	popStyle();



}

class NP{

	int x,y;
	int layer,id;
	int ins[] = new int[0];
	float w[] = new float[0];
	float val = 0;
	float nextval;
	float speeds[] = new float[0];

	NP(int _layer){
		layer = _layer;
		id = GLOBID;
		GLOBID++;


		y = GLOBSTEP*layer;


		if(id!=0){
			if(layer==neurons[id-1].layer){
				GLOBX+=GLOBSTEP;
			}else{
				GLOBX=0;
			}
		}
		x = GLOBX;
	}

	void postSet(){
		if(layer>0){
			NP[] tmp = getLayerMembers(layer-1);

			for(int i =0;i<tmp.length;i++){
				ins = (int[])expand(ins,ins.length+1);
				ins[ins.length-1] = tmp[i].id;
				w = (float[])expand(w,w.length+1);
				w[w.length-1] = random(1,1001)*0.001;
				speeds = (float[])expand(speeds,speeds.length+1);
				speeds[speeds.length-1] = random(1.1,width/10.0);

			}
		}
	}

	void sum(){
		float soucet = 0.0;


		for(int i =0;i<ins.length;i++){
			soucet += sigmoidal(neurons[ins[i]].val * w[i],0.4,1.3);
		}

		soucet/=(W+0.0);
		nextval = soucet;
	}

	void refresh(){
		if(layer == 0){
			val = IN[id];
		}else{
			sum();
		}

	}

	void compute(){
		val = nextval;//(nextval-val)/2.0;
		for(int i =0;i<w.length;i++)
			w[i] = 0.5*(sin(frameCount/speeds[i])+1.0);
	}

	void disp(){
		rect(x,y,2,2);
	}

}

void mousePressed(){
	
	//graphing.save("cosi.png");

}

void keyPressed(){
	if(key==' '){
		globcol = color(random(255),random(255),11);
	}

}

NP[] getLayerMembers(int _lay){
	//println("getting members of"+ _lay);
	NP[] temp = new NP[0];

	for(int i = 0;i < neurons.length;i++){
		if(neurons[i].layer==_lay){
			temp = (NP[])expand(temp,temp.length+1);
			temp[temp.length-1] = neurons[i];
		}

	}
	return temp;
}


float sigmoidal(float x, float norm, float slope) {
	x = (x / norm * 2 - 1) * 5 * slope;
	return (float) (1.0/( 1.0 + Math.pow( Math.E ,(-1.0 * x ))));
}


float derivative(float input,float norm,float slope){

	return(float)(1.0-(sigmoidal(input,norm,slope)*(1.0-sigmoidal(input,norm,slope)))*4.0);
}
