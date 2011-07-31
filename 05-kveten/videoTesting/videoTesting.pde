/**
 * Loop. 
 * Built-in video library replaced with gsvideo by Andres Colubri
 * 
 * Move the cursor across the screen to draw. 
 * Shows how to load and play a QuickTime movie file.  
 */
import jmcvideo.*;

JMCMovie m2;
Recorder r;


boolean rec  = true;
int x=0,y=0;

float tres = 5;
float lastval = 0;
int framer = 0;
boolean newf = true;

void setup() {
	size(13*50, 2*30, P3D);
	background(0);
	frameRate(29);
	// Load and play the video in a loop
	m2 = new JMCMovie(this, "test2.avi");
	m2.mute() ;

	r = new Recorder("out","raw.mp4");

	m2.play();
	//m2.pause();

}




void draw() {




	image(m2, x, y);
	framer++;

}

void move(){

	x+=m2.width;
	if(x>=width&&y==0){
		x=0;
		y+=m2.height;
	}else if(x>=width-m2.width){
		x=0;
		y+=m2.height;
	
	}

	if(y>=height){
		if(rec)
			r.add();
		x=0;
		y=0;

	}

}

void keyPressed(){

	if(key=='q'){
		if(rec)
			r.finish();
		exit();
	}else{
		move();
	}

}
