import point2line.*;
import processing.opengl.*;

//Vect2 normalizedVelocity = vel.normalized();
Synchronid[] s;
int pocet = 4000;
int ID = 0;

Recorder r;
boolean rec = false;

void setup(){
	size(320,240,OPENGL);
	background(0);
	frameRate(50);
	frame.setAlwaysOnTop(true);

	s = new Synchronid[pocet];

	for(int i =0;i<pocet;i++){
		s[i] = new Synchronid();
	}

	if(rec)
		r =  new Recorder("out","syncAsync.mp4");
}

void draw(){
	background(0);

	stroke(255,30);
	strokeWeight(1);

	for(int i =0;i<pocet;i++){
		s[i].draw();
	}

	stroke(0);
	strokeWeight(10);
	noFill();
	rect(0,0,width,height);

	if(rec)
		r.add();
}                               

void keyPressed(){
	if(key=='q'){
		if(rec)
			r.finish();
	}

	exit();
}

class Synchronid{

	Vect2 vel;
	float x,y,unit;
	int id;

	Synchronid(){

		vel = new Vect2(width,0);
		x = (ID/(pocet+0.0))*width;
		y= height/3.0;
		unit = 100+ID/PI;//random(100,1000);
		id=ID;
		ID++;
	}

	void draw(){

		vel.rotate(PI*frameCount/unit/(mouseY*30.0+4.0));
		unit = 100+(id*mouseX/PI);

		pushMatrix();
		translate(x,y);
		line(vel.x,vel.y,0,0);
		popMatrix();
	}
}
