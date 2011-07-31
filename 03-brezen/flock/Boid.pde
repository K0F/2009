// Flow Field Following
// Daniel Shiffman <http://www.shiffman.net>
// The Nature of Code, Spring 2009

class Boid {

	// The usual stuff
	PVector loc;
	PVector vel;
	PVector acc;
	float r;
	float maxforce;    // Maximum steering force
	float maxspeed;    // Maximum speed
	Gif anim;
	PApplet parent;
	int desync,time = 0;
	
	Boid(PApplet _p,Gif _anim, PVector l, float ms, float mf) {
		parent = _p;
		if(rec){
			anim = new Gif(parent,"bird.gif");
		}else{
			anim = new Gif(parent,"birdR.gif");
		}
		
		//anim.setDelay(1500);
		loc = l.get();
		r = 3.0f;
		desync = (int)random(20);
		maxspeed = ms;
		maxforce = mf;
		acc = new PVector(0,0);
		vel = new PVector(0,0);
	}

	public void run() {
		if(time==desync)
			anim.play();
			
		time++;
	
		update();
		borders();
		render();
	}


	// Implementing Reynolds' flow field following algorithm
	// http://www.red3d.com/cwr/steer/FlowFollow.html
	void follow(FlowField f) {

		// Look ahead
		PVector ahead = vel.get();
		ahead.normalize();
		ahead.mult(32); // Arbitrarily look 32 pixels ahead
		PVector lookup = PVector.add(loc,ahead);

		// Draw in debug mode
		if (debug) {
			stroke(0);
			line(loc.x,loc.y,lookup.x,lookup.y);
			fill(0);
			ellipse(lookup.x,lookup.y,3,3);
		}

		// What is the vector at that spot in the flow field?
		PVector desired = f.lookup(lookup);
		// Scale it up by maxspeed
		desired.mult(maxspeed);
		// Steering is desired minus velocity
		PVector steer = PVector.sub(desired, vel);
		steer.limit(maxforce);  // Limit to maximum steering force
		acc.add(steer);
	}

	// Method to update location
	void update() {
		// Update velocity
		vel.add(acc);
		// Limit speed
		vel.limit(maxspeed);
		loc.add(vel);
		// Reset accelertion to 0 each cycle
		acc.mult(0);
	}

	void render() {
		// Draw a triangle rotated in the direction of velocity
		float theta = vel.heading2D() + PApplet.radians(90);
		fill(175);
		stroke(0);
		pushMatrix();
		translate(loc.x,loc.y);
		rotate(theta+PI/2.0);
		//tint(255,150);
		image(anim,-8,-8,anim.width/2,anim.height/2);
		popMatrix();
		
		stroke(0,30);
		
			line(loc.x,loc.y,loc.x,height);
		
	}

	// Wraparound
	void borders() {
		if (loc.x < -r) loc.x = width+r;
		if (loc.y < -r) loc.y = height+r;
		if (loc.x > width+r) loc.x = -r;
		if (loc.y > height+r) loc.y = -r;
	}

}



