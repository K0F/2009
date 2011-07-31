
import processing.opengl.*;

int num = 500;
Objectron o[];

Recorder r;
boolean rec= false;

void setup(){
	size(720,576,OPENGL);
	background(0);

	stroke(255);
	noFill();
	o = new Objectron[num];

	if(rec)
		r = new Recorder("out","flocking.mp4");


	for(int i = 0;i<num;i++)
		o[i] = new Objectron();
}

void draw(){


	fill(0,53);
	rect(0,0,width,height);
	noFill();


	//background(0);

	for(int i = 0;i<num;i++)
		o[i].run();

	pushStyle();
	noFill();
	stroke(0,200);
	strokeWeight(12);
	rect(0,0,width,height);
	popStyle();
	
	if(rec)
		r.add();

}

void keyPressed(){

	if(key=='q'){
		if(rec)
			r.finish();
		exit();
	}

}


class Objectron{
	PVector pos,vel,up;
	float speed = 2.1;
	float rat = 80;
	float ts = 10.0;

	int deaf = 100;
	boolean mono = false;
	int timer = 0;

	Objectron(){
		create();
	}


	void create(){
		pos = new PVector(random(width),random(height));
		vel = new PVector(random(-10,10),random(-10,10));
		up = new PVector(0,-1);

	}

	void calculate(){
		if(!mono)
			for(int i = 0;i<o.length;i++){
				float quo = dist(pos.x,pos.y,o[i].pos.x,o[i].pos.y);

				PVector tmp = o[i].vel;

				if(quo<rat/2&&!mono){
					mono = true;
					vel.add(random(-30,30)/100.0,random(-30,30)/100.0,0);
					deaf = (int)(random(10,300)/10.0);
					timer = 0;
				}

				if(quo<rat&&!mono){


					vel.add(tmp.x/map(quo,0,rat,100,3),tmp.y/map(quo,0,rat,100,3),0);
					//add((tmp.x-vel.x)/map(quo,0,rat*3,10000,1000),(tmp.y-vel.y)/map(quo,0,rat*3,10000,1000),0);
					//	line(o[i].pos.x,o[i].pos.y,pos.x,pos.y);
				}



			}

		if(mono){

			stroke(255,120);
			timer++;
			if(timer>deaf){
				mono = false;
				timer = 0;
			}
		}else{

			stroke(255,125);
		}

		vel.limit(5);


	}

	void run(){




		//if(out())create();
		/*
				if(vel.x<0){
					vel.add(cos(-PVector.angleBetween(vel,up))/(vel.mag()+0.1)*3.0,sin(-PVector.angleBetween(vel,up))/(vel.mag()+0.1)*3.0,0);
				}else{
					vel.add(cos(PVector.angleBetween(vel,up))/(vel.mag()+0.1)*3.0,sin(PVector.angleBetween(vel,up))/(vel.mag()+0.1)*3.0,0);
				}
		*/		
		calculate();

		pos.x += vel.x/speed;
		pos.y += vel.y/speed;

		bordr();

		pushMatrix();
		translate(pos.x,pos.y);

		pushMatrix();
		if(vel.x<0){
			rotate(-PVector.angleBetween(vel,up));
		}else{
			rotate(PVector.angleBetween(vel,up));
		}

		//rect(-3,-3,6,6);
		triangle(-2,-2,2,-2,0,-3-(vel.mag()+0.1));


		popMatrix();
		popMatrix();
	}

	boolean out(){
		boolean answr = false;
		if(pos.x<0||pos.x>width||pos.y<0||pos.y>height)
			answr = true;

		return answr;
	}

	void bordr(){
		if(pos.x<0)pos.x=width;
		if(pos.x>width)pos.x=0;

		if(pos.y<0)pos.y=height;
		if(pos.y>height)pos.y=0;


	}



	//rotate vector declaration
	PVector rotateV(PVector v, float ang){
		PVector axis=new PVector(0,0,-1);
		PVector vnorm = new PVector(v.x,v.y,v.z);
		float _parallel = axis.dot(v);
		axis.mult(_parallel);

		PVector parallel = axis;
		parallel.sub(v);
		PVector perp = parallel;
		PVector Cross = v.cross(axis);

		Cross.mult(sin(-ang));
		perp.mult(cos(-ang ));
		Cross.add(perp);
		parallel.add(Cross);

		PVector result = parallel;
		return result;
	}


}
