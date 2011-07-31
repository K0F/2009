int ID;
float X,Y;
float STEP = 10;


Ci c[] = new Ci[300];
Signal s;

void setup(){
	size(300,300,OPENGL);
	background(0);


	for(int i =0;i<c.length;i++)
		c[i] = new Ci();
	stroke(255);

	
	s = new Signal();
}


void draw(){

	background(0);

	for(int i =0;i<c.length;i++)
		c[i].display();

	s.display();

}

void mousePressed(){

	s.nextStep();
}

class Signal{

	int pos;
	int level = 0;

	Signal(){

		pos = (int)random(width/STEP);

	}

	void nextStep(){

		level+=1;
		pos = (int)random(width/STEP);
		println(pos+"::"+level+"::"+level*(int)(width/STEP)+pos);

	}

	void display(){

		//noStroke();
		pushStyle();
		fill(255,0,0);
		rect(c[level*(int)(width/STEP)+pos].x,c[level*(int)(width/STEP)+pos].y,2,2);
		popStyle();
	}



}

class Ci{

	float decision = 0.5;
	int nexts[] = new int[2];
	boolean deciding = false;
	float x,y;


	Ci(){
		int id = ID;
		ID++;

		x=X;
		X+=STEP;
		y=Y;

		if(X>=width){
			Y+=STEP;
			X=0;
		}

		nexts[0] = id+(int)(width/STEP);
		nexts[1] = id+(int)(width/STEP)+1;
		decision = random(1000)*0.001;

	}

	void display(){
		if(deciding){
			fill(255);
		}else{
			noFill();
		}
		rect(x,y,2,2);
	}


	boolean decide(){
		if(decision >0.5){
			return true;
		}else{
			return false;
		}

	}



}
