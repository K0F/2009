

Valve valve[];
int num = 30;

void setup(){
	size(300,200,P3D);
	background(0);
	
	PFont a = new PFont();
	a = createFont(a.list()[85],15);
	textFont(a);
	textMode(SCREEN);
	
	//println(a.list());

	valve = new Valve[num];

	for(int i =0;i<num;i++){
		valve[i] = new Valve(i);
	}

}

void draw(){
	background(0);
		
	for(int i =0;i<valve.length;i++){
		valve[i].run();
	}

}

class Valve{
	int id;
	float x,y;
	int local;
	
	Valve(int _id){
		id=_id;
		this.setup();
	}

	void setup(){
		x = random(width);
		y = random(height);
	}
	
	void move(){
		x++;
		x=x%width;
	}
	
	void run(){
		move();
		
		pushStyle();
		
		stroke(255);
		noFill();
		rectMode(CENTER);
		rect(x,y,3,3);
		text(id,x,y);
		popStyle();
	}
}

