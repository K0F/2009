
import point2line.*;

Car bug;
PGraphics pneus;


void setup(){

	size(640,480,P2D);


	pneus=createGraphics(width,height,P2D);

	pneus.beginDraw();
	pneus.background(#cccccc);
	pneus.endDraw();

	bug = new Car();
	//noSmooth();

}


void draw(){


	background(pneus);

	bug.draw();




}


class Car{


	PImage skin;
	PGraphics model;
	Vect2 loc,vel,acc,setrv,mom,bok;

	float posXm,posYm;
	float mass = 10.0;

	float heading;
	float speed = 0;
	float theta;

	float r;
	float maxforce = 10.0;    // Maximum steering force
	float maxSpeed = 3.0;    // Maximum speed

	float stress1,stress2;
	boolean stressed = false;

	boolean accelerating,breaking,steeringL,steeringR;

	Car(){

		skin = loadImage("bug.png");

		model = createGraphics(skin.width,skin.height,P2D);

		model.loadPixels();
		skin.loadPixels();

		for(int i =0;i<model.pixels.length;i++){
			if(skin.pixels[i]!=-240388)
				model.pixels[i] = skin.pixels[i];
		}


		imageMode(CENTER);

		acc = new Vect2(0,0);
		vel = new Vect2(0,0);
		setrv = new Vect2(0,0);
		bok = new Vect2(0,0);
		mom = new Vect2(0,0);
		loc = new Vect2(width/2,height/2);


	}

	void update() {
		borders();

		posXm = loc.x;
		posYm = loc.y;






		mom = new Vect2((posXm-loc.x-vel.x)/2.0,(posYm-loc.y-vel.y)/2.0);
		//mom.rotate(vel.angle());
		//println(mom.angle());
		//if(mom.angle()<PI){
		bok = new Vect2(0,(mom.magnitude()*heading*pow(vel.magnitude(),1.5)));
		//}else{
		//bok = new Vect2(0,(mom.magnitude()*-heading));

		//}
		bok.rotate(mom.angle());


		vel.add(acc);
		mom.add(bok.scaled(1));
		loc.add(vel);

		setrv = bok;
		//	setrv.rotate(mom.scaled(-mass).angle());






		// Reset accelertion to 0 each cycle
		acc = new Vect2(0,0);
	}



	void draw(){

		stress1 = vel.magnitude();

		if(bok.magnitude()>5){
			stressed = true;
		}else{
			stressed = false;
		}

		update();

		theta = vel.angle() + PI/2;
		
		
		
		vel.rotate(radians(heading*(vel.magnitude()/2.0)* pow(bok.scaled(0.5).magnitude()*mom.magnitude(),0.1) ));
		
		//acc.rotate(radians(theta));
		heading=constrain(heading,-10,10);
		heading+=(0-heading)/(20);
		vel.scale(0.99);

		if(vel.magnitude()>maxSpeed){
			vel.setMagnitude(maxSpeed);
		}

		if(setrv.magnitude()>100.0){
			setrv.setMagnitude(maxSpeed);
		}

		if(breaking){
			stressed = true;
		}

		pushMatrix();
		translate(loc.x,loc.y);
		rotate(theta);
		if(stressed){
			
			doSmyk();
		}
		image(model,0,0);
		popMatrix();

		if(accelerating)doAccelerate();
		if(breaking)doBrake();
		if(steeringL)steerL();
		if(steeringR)steerR();

		//acc.rotateZ(theta);

		stress2 = stress1;
		

		stroke(0);
		line(loc.x,loc.y,loc.x+setrv.x,loc.y+setrv.y);


	}
	void borders() {
		if (loc.x < -r) loc.x = width+r;
		if (loc.y < -r) loc.y = height+r;
		if (loc.x > width+r) loc.x = -r;
		if (loc.y > height+r) loc.y = -r;
	}
	void doAccelerate(){
		Vect2 tmp = new Vect2(0.1,0);
		tmp.rotate(vel.angle());
		acc.add(tmp);

	}

	void doBrake(){
		bug.vel.scale(0.97);
	}

	void steerL(){
		bug.heading+=.13;

	}

	void steerR(){
		bug.heading-=.13;

	}

	void doSmyk(){
		pneus.beginDraw();
		pneus.pushMatrix();
		pneus.translate(loc.x,loc.y);
		pneus.rotate(theta);
		
		pneus.strokeWeight(1.5);
		pneus.stroke(0,20);
		
		pneus.line(-5,-5,-5,-2);
		pneus.line(5,-5,5,-2);
		pneus.line(-5,5,-5,2);
		pneus.line(5,5,5,2);
		
		pneus.popMatrix();
		pneus.endDraw();


	}

}

void keyPressed(){
	if(keyCode==UP){
		bug.accelerating=true;
	}

	if(keyCode==DOWN){
		bug.breaking=true;

	}

	if(keyCode==RIGHT){
		bug.steeringL=true;

	}

	if(keyCode==LEFT){
		bug.steeringR=true;

	}


}


void keyReleased(){
	if(keyCode==UP){
		bug.accelerating=false;
	}

	if(keyCode==DOWN){
		bug.breaking=false;

	}

	if(keyCode==RIGHT){
		bug.steeringL=false;

	}

	if(keyCode==LEFT){
		bug.steeringR=false;

	}


}
