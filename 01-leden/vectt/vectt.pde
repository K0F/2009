PVector p1, p2, p3;


boolean bFirst = true;

void setup()
{
	size(400, 400,P3D);
	noFill();
	p1 = new PVector(random(width), random(height),random(width));
	p2 = new PVector(random(width), random(height),random(width));
}

void draw(){
	background(255);

	// Draw main vector
	stroke(0);
	// strokeWeight(3);

	pushMatrix();
	translate(0,0,-width);
	
	pushMatrix();
	translate(width/2,height/2,width/2);

	pushMatrix();
	rotateY(frameCount/50.0);

	pushMatrix();
	box(width);
	popMatrix();

	pushMatrix();

	translate(-width/2,-height/2,-width/2);
	line(p1.x, p1.y,p1.z, p2.x, p2.y,p2.z);
	p3 = new PVector(lerp(p1.x,p2.x,0.5),lerp(p1.y,p2.y,0.5),
	lerp(p1.z,p2.z,0.5));
	
	pushMatrix();
	translate(p3.x,p3.y,p3.z);
	box(10);
	popMatrix();
		
	// Compute perpendicular vector: (y, -x)
	PVector perp = new PVector(p2.y-p1.y,p1.x-p2.x,p3.z-p1.z);
	// Length 1
	perp.normalize();
	// Length to n pixels
	perp.mult(100);  // Put 10 for 10 pixels
	// Move to p1
	//perp.add();
	// Draw it
	stroke(#AA2244);
	//strokeWeight(1);
	line(p3.x, p3.y,p3.z, perp.x, perp.y,perp.z);
	
	popMatrix();
	popMatrix();
	popMatrix();
	popMatrix();
}

void mousePressed(){
	p1 = new PVector(random(width), random(height),random(width));
	p2 = new PVector(random(width), random(height),random(width));
}
