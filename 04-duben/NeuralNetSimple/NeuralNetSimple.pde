
Neuron n [];
Monitor m;
int num = 620;

boolean visible = false;

boolean tc []= {true,false,true,false,true,false,true,false,true,false};

void setup(){
	size(300,400,OPENGL);
	background(0);

	n = new Neuron[num];
	m = new Monitor();

	for(int i = 0;i<n.length;i++){
		n[i] = new Neuron(i,5,random(10,width-10),random(20,height-20));

	}

	textFont(createFont("Veranda",9));

	fill(255);
	rectMode(CENTER);

}

void draw(){

	background(0);

	for(int i = 0; i < n.length; i++){
		if(visible){
			n[i].compute();
		}else{
			n[i].act();

		}
	}

	m.act();

}

void keyPressed(){

	if(key==' ')
	visible=!visible;

}

class Neuron{

	boolean state = true;
	int ins[];
	float weights[];
	int id;
	float treshold = 0,sum,lastSum;
	float x,y;
	int nn;


	Neuron(int _id, int _nn,float _x,float _y){
		id=_id;
		x=_x;
		y=_y;
		nn = _nn;

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

			int temp = (int)random(n.length);

			if(temp==id||!other(temp)){
				while(temp==id||!other(temp)){
					temp=(temp+1)%(ins.length);
				}
			}

			ins[i] = temp;
			weights[i] = random(-100,100)/10.0;

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

		sum += (lastSum-sum)/10.5;

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
			stroke(255,map(weights[i],-5,10,0,30));
			line(n[ins[i]].x,n[ins[i]].y,x,y);
			
			float distA = dist(n[ins[(i+1)%ins.length]].x,n[ins[i]].y,x,y);
			float distB = dist(n[ins[i]].x,n[ins[i]].y,x,y);
					
	
		}

		
		if(state){
			fill(255,0,0,map(sum,-10,10,0,255));
		}else{
			fill(255,map(sum,-10,10,0,255));
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

	Monitor(){
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

			int temp = (int)random(n.length);

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


		run++;

		stroke(255,0,0,200);
		float perc = 0;
		int right = 0;

		for(int i = 0; i < ins.length; i++){
			senz[i] = n[ins[i]].state;
			if(senz[i]){
				fill(255);
				vals[i]+=3;
			}else{
				fill(0);
			}

			line(i*10+width/2.0-(tc.length*10/2.0),10,n[ins[i]].x,n[ins[i]].y);
			rect(i*10+width/2.0-(tc.length*10/2.0),10,10,10);


			if(tc[i]){
				fill(255);

			}else{
				fill(0);
			}

			rect(i*10+width/2.0-(tc.length*10/2.0),height-10,10,10);

			fill(255,vals[i]);
			rect(i*10+width/2.0-(tc.length*10/2.0),height-20,10,10);

			if(senz[i]=tc[i]){
				feedback(ins[i],10.0,num*10);

			}else{

				feedback(ins[i],-10.0,num*10);

			}

		}

		if(run>200){
			run=0;
			tc = new boolean[10];

			for(int i = 0; i < tc.length; i++)
			{
				if(random(500.0)>250.0){
					tc[i]=false;
				}else{
					tc[i]=true;
				}
				vals[i] = 0;
			}

		}




		fill(255);
		text("+"+happy+"/ -"+sad,10,10);


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


			n[current].weights[top]+=(target-n[current].weights[top])/(rate+map(e,0,depth,0,rate*10.0));
			current = next;

		}
	}




}



