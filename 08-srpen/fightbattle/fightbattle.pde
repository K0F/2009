import saito.objloader.*;
import processing.opengl.*;
//import processing.opengl.*;
//import com.bulletphysics.dynamics.*;

boolean up,down,left,right;

Letadlo spitfire;

void setup(){
	size(640,480,OPENGL);
	spitfire = new Letadlo(this);
}

void draw(){
	background(0);
	
	pushMatrix();
	translate(width/2,height/2,-mouseY);
	pushMatrix();
	translate(spitfire.loc.x,spitfire.loc.y,spitfire.loc.z);
	rotateY(radians(mouseX));
	spitfire.draw();
	popMatrix();
	
	popMatrix();
}


class Letadlo{

	OBJModel model;

	PVector vel;
	PVector loc;
	PVector acc;
	PVector head;

	float mass = 10.0;
	float maxspeed = 3.0;
	float maxforce = 1.0;

	PApplet parent;

	Letadlo(PApplet _parent){
		parent = _parent;
		model = new OBJModel(parent);
		model.load("spitfire2.obj");
		model.drawMode(POLYGON);
		//model.enableTexture();

		loc = new PVector(0,0,0);
		vel = new PVector(0,0,0);
		acc = new PVector(0,0,0);
		head = new PVector(0,1,0);

	}

	void update() {
		
		if(up){
		head.add(0,-0.10,0);
		
		}
		
		if(down){
		head.add(0,0.1,0);
		}
		
		// Update velocity
		vel.add(acc);
		// Limit speed
		vel.limit(maxspeed);
		loc.add(vel);
		// Reset accelertion to 0 each cycle
		acc.mult(0);
	}

	// A method that calculates a steering vector towards a target
	// Takes a second argument, if true, it slows down as it approaches the target
	PVector steer(PVector target, boolean slowdown) {
		PVector steer;  // The steering vector
		PVector desired = PVector.sub(target,loc);  // A vector pointing from the location to the target
		float d = desired.mag(); // Distance from the target is the magnitude of the vector
		// If the distance is greater than 0, calc steering (otherwise return zero vector)
		if (d > 0) {
			// Normalize desired
			desired.normalize();
			// Two options for desired vector magnitude (1 -- based on distance, 2 -- maxspeed)
			if ((slowdown) && (d < 100.0f)) desired.mult(maxspeed*(d/100.0f)); // This damping is somewhat arbitrary
			else desired.mult(maxspeed);
			// Steering = Desired minus Velocity
			steer = PVector.sub(desired,vel);
			steer.limit(maxforce);  // Limit to maximum steering force
		} else {
			steer = new PVector(0,0, -100);
		}
		return steer;
	}

	void draw(){
		update();
		noStroke();
		
		pushMatrix();

		rotateX(atan2(head.z-loc.z,head.x-loc.x));	
		rotateY(atan2(head.y-loc.y,head.x-loc.x));

		model.draw();
		
		popMatrix();
		


	}






}
