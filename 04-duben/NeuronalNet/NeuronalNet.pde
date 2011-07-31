int num = 64*64*64;
int cntr = 0;
Neuron n[];
Monitor m;
Recorder r;

boolean rec = true;
boolean obr = false;

PImage img;
PGraphics input;


/////////////////////////////////////////////////// >> SETUP

void setup(){
	size(128*2,64*2,OPENGL);

	n = new Neuron[num];

	generateIn();

	for(int i =0;i<num;i++){
		n[i] = new Neuron(i,30,0.0);
	}

	m = new Monitor(64,16);

	if(rec)
		r = new Recorder ("out","ai.mp4");

	stroke(255);
	noFill();
	rectMode(CENTER);

}



/////////////////////////////////////////////////// >> LOOP

void draw(){
	background(0);

	noFill();
	for(int i =0;i<num;i++){
		n[i].compute();
	}

	m.act();


	if(rec)
		r.add();
}


/////////////////////////////////////////////////// >> FUNCT

void generateIn(){
	obr=!obr;
	if(obr){
		img = loadImage("input.png");
	}else{
		img = loadImage("input2.png");

	}
	input = createGraphics(img.width,img.height,JAVA2D);
	input.beginDraw();
	input.image(img,0,0);
	input.endDraw();

	input.loadPixels();

}

void mousePressed(){
	generateIn();

}

void keyPressed(){
	if(key=='q'){

		if(rec)
			r.finish();
		exit();
	}
}

/////////////////////////////////////////////////// >> NEURON

class Neuron{

	float weight,trigger,x,y;
	int id,ins[],out,in;
	float sum = 0;
	float mods[];
	boolean bang = true;


	/////////////////////////////////////////////////// >> construct

	Neuron(int _id,int _in,float _trigger){
		id=_id;
		in = _in;

		trigger = _trigger;
		

		/*
				if(cntr<input.pixels.length){

					weight = input.pixels[cntr];
					cntr ++;

				}else{
				
				if(id<input.pixels.length){
			weight = (int)((brightness(input.pixels[id])/255.0)-0.5);//random(255);
		}else{
		*/
				
		weight = random(0.1,10.0);
				
				
		//}

		x = 0;//random(width);
		y = 0;//random(height/2.0);

		ins = new int[(int)random(in-2)+1];
		mods = new float[ins.length];


		for(int i =0;i<ins.length;i++){
			ins[i] = -1;
			mods[i] = random(-1000.0,1000.0)/500.0;
		}

		for(int i =0;i<ins.length;i++){

			int a = (int)random(num);
			int counter = 0;

			if(a==id||!checkValidity(a)){
				while(a==id||!checkValidity(a)){
					counter ++;
					a = (int)random(num);
					if(counter>100)
						return;
				}
			}

			ins[i] = a;

		}

		int _out = (int)random(num);

		int c = 0;

		if(_out==id){
			while(_out==id){
				c++;
				_out = (int)random(num);
				if(c>1000)
					return;
			}
		}

		out =_out;
		//println(id+" created");

	}


	/////////////////////////////////////////////////// >> validity

	boolean checkValidity(int number){
		boolean answr = true;
		for(int i = 0;i<ins.length;i++){
			if(number==ins[i])
				answr = false;
		}
		return answr;

	}


	/////////////////////////////////////////////////// >> noise

	void noiseMe(float kolik){
		for(int i =0;i<ins.length;i++){
			mods[i]+=random(-kolik,kolik)/100000.0;
			mods[i] = constrain(mods[i],-2.0,2.0);
		}

	}


	/////////////////////////////////////////////////// >> compute

	void compute(){

		noiseMe(10000.0);

		weight = constrain(weight,-10,10);

		float sum2 = 0;

		for(int i =0;i<ins.length;i++){
			if(n[ins[i]].bang)
				sum2+=n[ins[i]].weight*mods[i];
		}

		sum+=(sum2-sum)/8.0;

		
		if (sum > trigger*(in+0.0)){
			bang = true;
		}else{
			bang = false;

		}



	}


	/////////////////////////////////////////////////// >> act

	void act(){

		compute();


		if(bang){
			stroke(255,0,0);
			//fill(255,0,0,25);
		}else{
			stroke(map(sum/in,-2,0,0,255),100);
			//noFill();
		}
		rect(x,y,weight/25.0,weight/25.0);
		stroke(255,20);
		for(int i =0;i<ins.length;i++){
			if(mods[i]>0.98&&n[ins[i]].bang)
				line(x,y,n[ins[i]].x,n[ins[i]].y);

		}
		//stroke(255,0,0,155);
		//line(x,y,n[out].x,n[out].y);

	}

}


/////////////////////////////////////////////////// >> MONITOR

class Monitor{

	int w,h,x,y;
	int no[];
	float val[];
	float diff[];

	float rate = 3.0;


	/////////////////////////////////////////////////// >> construct

	Monitor(int _x,int _y){
		x=_x;
		y=_y;
		w=input.width;
		h=input.height;

		no = new int[w*h];
		val = new float[w*h];
		diff = new float[input.width*input.height];


		for(int i =0;i<no.length;i++){
			no[i] = -1;

			int q = (int)random(num);
			if(!checkValidity(q)){

				int counter = 0;

				while(!checkValidity(q)){
					counter ++;
					q = (int)random(num);
					if(counter>100)
						return;
				}


			}

			no[i] = q;

		}

	}


	/////////////////////////////////////////////////// >> act

	void act(){

		for(int i =0;i<val.length;i++){
			val[i] = n[no[i]].sum;
		}

		noStroke();
		for(int X =0;X<w;X++){
			for(int Y =0;Y<h;Y++){
				diff[Y*h+X] = abs(brightness(input.pixels[Y*h+X])-map(val[Y*h+X],-2,2,0,255));
				fill(map(val[Y*h+X],-2,2,0,255));
				rect(x+X,y+Y,1,1);

			}
		}

		for(int i =0;i<val.length;i++){
			diff[i] = abs(brightness(input.pixels[i])-map(val[i],-2,2,0,255));
			feedback(i,map(diff[i],255,0,-2.0,2.0),30);
		}

		noFill();
		
		for(int X =0;X<w;X++){
			for(int Y =0;Y<h;Y++){
				stroke(diff[Y*h+X]);
				rect(w+x+X,y+Y,1,1);

			}
		}


	}

	/*	int[] trace(int ina){
			int[] res = new int[0];

			res = (int[])expand(res,res.length+1);
			res[res.length-1] = n[no[i]].id;

			for(int i = 0;i<n[no[i]])

				return res;
		}*/


	/////////////////////////////////////////////////// >> feedback

	void feedback(int qq,float target,int depth){


		int current = qq;
		int next = 0;

		for(int e = 0;e<depth;e++){

			float mm = -2.0;
			int top = 0;

			for(int i =0;i<n[current].ins.length;i++){

				if(mm<n[current].mods[i]){
					mm = n[current].mods[i]*n[n[current].ins[i]].weight;
					top = i;
					next = n[current].ins[top];
				}
			}


			n[current].mods[top]+=(target-n[current].mods[top])/rate;
			current = next;

		}
	}
	
	void feedback2(int qq,float target,int depth){


		int current = qq;
		int next = 0;

		for(int e = 0;e<depth;e++){

			float mm = -2.0;
			int top = 0;

			for(int i =0;i<n[current].ins.length;i++){

				if(mm<n[current].mods[i]){
					mm = n[current].mods[i]*n[n[current].ins[i]].weight;
					top = i;
					next = n[current].ins[top];
				}
				
				n[current].mods[i]+=(target-n[current].mods[i])/(rate*(abs(n[current].mods[i]-n[current].mods[top])));
			}


			n[current].mods[top]+=(target-n[current].mods[top])/rate;
			current = next;

		}
	}


	/////////////////////////////////////////////////// >> validity


	boolean checkValidity(int number){
		boolean answr = true;
		for(int i = 0;i<val.length;i++){
			if(number==val[i])
				answr = false;
		}
		return answr;

	}

}
