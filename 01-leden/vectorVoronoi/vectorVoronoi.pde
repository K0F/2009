PVector p[];
float rota = 0;

void setup(){
	
	size(300,300,P3D);
	p = new PVector[3];
	
	for(int i =0;i<p.length;i++){
		p[i] = new PVector(random(width),random(height),random(width));	
	}
	noFill();
	stroke(0);
	
}

void draw(){
	background(255);
	
	pushMatrix();
	translate(0,0,-width*2);
	
	pushMatrix();
	
	translate(width/2.0,height/2.0,width/2.0);
	
	pushMatrix();
	
	rotateY(rota);
	rota += 0.01;
	
	pushMatrix();
	
	translate(-width/2.0,-height/2.0,-width/2.0);
		stroke(0);
	for(int i = 0;i<p.length;i++){
		line(p[i].x,p[i].y,p[i].z,0,0,0);
	}
	stroke(255,0,0);
	PVector temp = (p[1]);
	temp.sub(p[0]);
	line(temp.x,temp.y,temp.z,0,0,0);
	
	popMatrix();
		
	popMatrix();
	
	
	popMatrix();
		
	
	popMatrix();
	
	
}
