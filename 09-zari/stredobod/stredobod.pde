
Recorder r;
boolean rec = false;

boolean enough = false;
float speed = 220.0;
float GX = 0;
float GY = 0;
float step = 30;

Bod b[] = new Bod[0];



void setup(){

	size(400,300,OPENGL);

	if(rec){
		r = new Recorder("out","stredobod.mp4");

	}

	int g = 0;
	while(!enough){
		b = (Bod[])expand(b,b.length+1);
		b[b.length-1] = new Bod(g);
		g++;
	}

	fill(255,35);
	noStroke();
	rectMode(CENTER);

	background(0);
}


void draw(){
	background(0);

	stepper(200);

	

	if(rec)
		r.add();
	
	reset();


}

void reset(){
	for(int i =0;i<b.length;i++){
			b[i].redef(random(-10,100));
		}
	
	
}

void stepper(int st){

	for(int e = 0;e<st;e++){

		for(int i =0;i<b.length;i++){
			b[i].compute();
		}



		for(int i =0;i<b.length;i++){
			b[i].update();
			b[i].draw();
		}

	}

}

void keyPressed(){
	if(key == 'q'){
		if(rec)
			r.finish();

		exit();

	}


}

class Bod{

	float x,y,tx,ty,bx,by;
	float r = 5.0;
	int id;

	Bod(int _id){
		id = _id;
		bx = tx = x = GX;
		by = ty = y = GY;

		GX+=step;

		if(GX>width){
			GY +=step;
			GX = 0;
		}

		if(GY>height){
			enough = true;
		}
	}
	
	
	Bod(int _id,float _r){
		r = _r;
		id = _id;
		bx = tx = x = GX;
		by = ty = y = GY;

		GX+=step;

		if(GX>width){
			GY +=step;
			GX = 0;
		}

		if(GY>height){
			enough = true;
		}
	}
	
	void redef(float _r){
	
		r += _r/200.0;
		tx = x = bx;
		ty = y = by;
		
	
	}

	void draw(){
		rect(x,y,2,2);
		
		/*
		pushStyle();
		stroke(255,1);
		noFill();
		ellipse(x,y,r*2,r*2);
		popStyle();

		*/
	}

	void compute(){

		int react = 0;
		for(int i =0;i < b.length;i++){
			if(id!=i){
				if(react>7){
					break;
				}
				if(dist(b[i].tx,b[i].ty,tx,ty)<r){
					tx += ( b[i].x - x ) / speed;
					ty += ( b[i].y - y ) / speed;
					react++;
				}
			}
		}

	}

	void update(){

		x=tx;
		y=ty;

	}



}
