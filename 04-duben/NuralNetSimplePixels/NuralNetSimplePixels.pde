
/*
She is dancing I am dreaming,.
my first, yet imperfect, artificial neural network is learning the shapes of my crappy hand written letter 'A'.. as well as she is teaching me how the neural net actually works.
The movements is caused by changes in her node-weights and gives quite good illustration of her (quite weak) functionality.

Enjoy the neural dance. 

*/

Neuron n [];
Monitor m;
int num;

boolean rec = true;

Recorder r;

int nextOne = 0;
PImage img,imgs[];

boolean visible = true;

boolean tc [];//= {true,false,true,false,true,false,true,false,true,false};

void setup(){
	size(576,320,OPENGL);
	background(0);


	img = loadImage("a.png");


	imgs = new PImage[9];
	for(int i = 1; i < 10; i++){

		imgs[i-1] = loadImage("a00"+i+".png");

	}
	tc= new boolean[img.pixels.length];

	for(int i = 0; i < tc.length; i++){
		if(brightness(img.pixels[i])>127){
			tc[i] = true;
		}else{
			tc[i] = false;
		}
	}

	num = 2000;
	n = new Neuron[num];
	m = new Monitor(3.0);

	for(int i = 0;i<n.length;i++){
		n[i] = new Neuron(i,5,random(width/2.0-15,width/2.0+15)+40,map(i,0,num,70,height-5), 30.0);

	}

	textFont(createFont("Veranda",9));

	fill(255);
	rectMode(CENTER);

	if(rec)
		r= new Recorder("out","learningNN.avi");

}

void draw(){

	background(0);

	for(int i = 0; i < n.length; i++){
		if(!visible){
			n[i].compute();
		}else{
			n[i].act();

		}
	}

	m.act();

	if(rec)
		r.add();

}

void keyPressed(){

	if(key==' '){
		visible=!visible;
	}else if(key=='q'){
		if(rec)
			r.finish();
		exit();
	}else if(keyCode==ENTER){
	saveFrame("frame-####.png");
	}
}

class Neuron{

	boolean state = true;
	int ins[];
	float weights[];
	int id;
	float treshold = 0,sum,lastSum;
	float x,y,rate;
	int nn;


	Neuron(int _id, int _nn,float _x,float _y,float _rate){
		id=_id;
		x=_x;
		y=_y;
		nn = _nn;
		rate = _rate;

		nn=constrain(nn,1,n.length-2);

		reset();
	}

	void reset(){

		ins = new int[nn];
		weights = new float[ins.length];

		for(int i = 0; i < ins.length; i++){
			ins[i] = -1;
		}

		for(int i = 0; i < ins.length; i++){

			int temp = (int)random(id-nn-1,id+100*nn+1);

			if(temp==id||!other(temp)||temp==n.length-1){
				while(temp==id||!other(temp)||temp==n.length-1){
					temp = (int)random(id-nn-1,id+100*nn+1);//=(temp+1)%(ins.length);

					temp = constrain(temp,id-nn-1,n.length-1);
				}
			}
			
			
					temp = constrain(temp,0,n.length-1);


			ins[i] = temp;
			weights[i] = random(-10,10)/10.0;

		}

	}

	boolean other(int in){
		boolean ans = true;

		for(int i = 0; i < ins.length; i++)
		{
			if(in==ins[i])
				ans = false;
		}
		return ans;

	}


	void compute(){
		lastSum = 0;
		for(int i = 0; i < ins.length; i++){
			if(n[ins[i]].state)
				lastSum+=weights[i];
		}

		lastSum/=ins.length+0.0;

		sum += (lastSum-sum)/rate;

		
		x+=((map(sum,-3,3,15,width-15)+40)-x)/40.0;
		
		if(sum > treshold){
			state = true;
		}else{
			state = false;
		}


		addNoise(0.05);

	}

	void setActive(){
		state = true;
	}

	void addNoise(float we){
		treshold+=random(-we,we)/1000.0;
		treshold=constrain(treshold,-1,1);
	}

	void act()  {

		compute();


		for(int i = 0; i < ins.length; i++){
			stroke(255,map(weights[i],-3,3,2,25));
			line(n[ins[i]].x,n[ins[i]].y,x,y);

			//float distA = dist(n[ins[(i+1)%ins.length]].x,n[ins[i]].y,x,y);
			//float distB = dist(n[ins[i]].x,n[ins[i]].y,x,y);


		}


		if(state){
			fill(255,0,0,map(sum,-5,5,0,100));
		}else{
			fill(255,map(sum,-5,5,0,100));
		}
		rect(x,y,3,3);




	}


}

void mousePressed(){
	for(int i =0;i<n.length;i++)
		n[i].reset();

}

class Monitor{
	boolean senz[];
	int ins[];
	float rate = 20.0;
	int run;
	boolean rightResult = true;
	int vals[];

	int happy = 0,sad = 0;

	Monitor(float _rate){
		rate = _rate;
		senz = new boolean[tc.length];
		initial();

	}

	void initial(){
		ins = new int[senz.length];

		vals = new int[senz.length];


		for(int i = 0; i < ins.length; i++){
			ins[i] = -1;
			vals[i] = 0;
		}

		for(int i = 0; i < ins.length; i++){

			int temp = (int)random(tc.length+1);

			if(!other(temp)){
				while(!other(temp)){
					temp=(temp+1)%(ins.length);
				}
			}

			ins[i] = temp;


		}


		run = 0;
	}

	boolean other(int in){
		boolean ans = true;

		for(int i = 0; i < ins.length; i++)
		{
			if(in==ins[i])
				ans = false;
		}
		return ans;

	}


	void act(){


		int XX=0,YY=0;

		run++;

		//stroke(255,0,0,200);
		noStroke();
		float perc = 0;
		int right = 0;
		
		stroke(255,15);
		noFill();
		
		rect(width/2.0+40-1,15+16-2,36,36);
		rect(width/2.0-1,15+16-2,36,36);
		rect(width/2.0-40-1,15+16-2,36,36);
		
		
		for(int i = 0; i < ins.length; i++){
			senz[i] = n[ins[i]].state;
			if(senz[i]){
				fill(255);
				vals[i]+=3;
			}else{
				fill(0);
			}

			line(XX*2+width/2.0-(img.width)+40,15+YY*2,n[ins[i]].x,n[ins[i]].y);


			if(XX>=img.width){
				XX=0;
				YY++;
			}

			rect(XX*2+width/2.0-(img.width)+40,15+YY*2,2,2);


			if(tc[i]){
				fill(255);

			}else{
				fill(0);
			}

			rect(XX*2+width/2.0-(img.width)-40,15+YY*2,2,2);

			fill(255,vals[i]);
			rect(XX*2+width/2.0-(img.width),15+YY*2,2,2);

			if(senz[i]=tc[i]){
				feedback(ins[i],10.0,num);

			}else{

				feedback(ins[i],-10.0,num);

			}

			XX++;

		}


		if(run>200){
			run=0;

			img = imgs[nextOne%imgs.length];
			nextOne ++;

			img.updatePixels();
			tc= new boolean[img.pixels.length];

			for(int i = 0; i < tc.length; i++){
				if(brightness(img.pixels[i])>127){
					tc[i] = true;
				}else{
					tc[i] = false;
				}
				vals[i] = 0;
			}



		}




		fill(255,255*(sin(frameCount/30.0)+1));
		text("learning ..",10,10);


	}

	void feedback(int qq,float target,int depth){


		int current = qq;
		int next = 0;

		for(int e = 0;e<depth;e++){

			float mm = -2.0;
			int top = 0;

			for(int i =0;i<n[current].ins.length;i++){

				if(mm<n[current].weights[i]){
					mm = n[current].weights[i];
					top = i;
					next = n[current].ins[top];
				}
			}


			n[current].weights[top]+=(target-n[current].weights[top])/(rate+map(e,0,depth,0,rate*2.0));
			current = next;

		}
	}




}



