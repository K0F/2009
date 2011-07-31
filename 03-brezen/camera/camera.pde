
import processing.opengl.*;

float factor = 100;

void setup(){
	size(600,400,OPENGL);
	background(255);

	camera(width/2,height/2,-100,width/2,height/2,0,0,1,0);

	noFill();
	stroke(0,25);
	//ortho(-width, width, -height, height, -50, 50);
	//ortho(0, width, 0, height, -10, 10);
	//ortho(-width/2, width/2, -height/2, height/2, -10, 10);
	//smooth();
	noSmooth();
}


void draw(){
	background(255);

	//ortho(-width/2, width/2, -height/2, height/2, -10, 10);

	
	
	//frustum(-width/2, width/2, -height/2, height/2, -1000, 20.0);

	pushMatrix();
	

	camera(sin(frameCount/302.0)*width/2+width/2,sin(frameCount/3000.3)*height/2+height/2,-100,width/2,height/2,0,0,1,0);
	


	
	//lights();

	pushMatrix();


	translate(width/2, height/2, 0);
	for(int i = 0;i<50;i+=1){
	rotateY(radians(i+frameCount/40.0));
	rotateX(radians(i/PI));
	rotateZ(radians(frameCount/(i+33.3)));
	noFill();
	pushMatrix();
	translate(noise(i*0.01+frameCount*0.01)*factor,noise(i*0.0133+frameCount*0.0133)*factor,noise(i*0.021+frameCount*0.01)*factor);
	box(100-i);
	popMatrix();
	fill(0,15);
	rect((100-i)*.5,100,50,50);
	rect((100-i)*.5,-100,5,-50);
	}
	popMatrix();

	popMatrix();
}

