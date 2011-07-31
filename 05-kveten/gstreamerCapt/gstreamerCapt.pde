/**
 * Getting Started with Capture.
 * 
 * GSVideo version by Andres Colubri. 
 * 
 * Reading and displaying an image from an attached Capture device. 
 */ 
import codeanticode.gsvideo.*;

GSCapture cam;
Recorder r;
boolean rec  = false;

//float qa [][] = new float[320][240];

int w = 32*2;
int h = 24*2;
int X=0,Y=0;

int inter = 1;

void setup() {
	size(w*10, h*6,P3D);


	//float qa [][] = new float[width][height];
	/*
	// List functionality still not ready on Linux
	String[] cameras = GSCapture.list();

	if (cameras.length == 0)
{
	  println("There are no cameras available for capture.");
	  exit();
} else {
	  println("Available cameras:");
	  for (int i = 0; i < cameras.length; i++)
	    println(cameras[i]);
	  cam = new GSCapture(this, 320, 240, cameras[0]);
}

	However, different cameras can be selected by using their device file:
	cam = new GSCapture(this, 640, 480, "/dev/video0");
	cam = new GSCapture(this, 640, 480, "/dev/video1");
	etc.
	*/
	cam = new GSCapture(this,640,480);
	background(0);

	//tint(255,90);

	r = new Recorder("vid","tick60_3.mp4");
	//tint(255,90);
}

void draw() {
	if (cam.available() == true) {
		try{
		cam.read();

		
		cam.filter(GRAY);

		}catch(java.lang.NullPointerException e){
			println("weird error! @ "+frameCount);
		}


		X+=w;
		if(X>=width){
			Y+=h;
			X=0;
		}

		if(Y>=height){

			if(rec)
				r.add();

			Y=0;
			X=0;

		}
		
		
	int xx = (int)(((int)random(width/w))*w);
	int yy = (int)(((int)random(height/h))*h);

	if(cam!=null)
		image(cam, xx, yy,w,h);
	}

	// The following does the same, and is faster when just drawing the image
	// without any additional resizing, transformations, or tint.
	//set(0, 0, cam);




}

void keyPressed(){
	if(key=='q'){
		if(rec)
			r.finish();
		exit();

	}else if(key == 'r'){
		rec = !rec;
		if(rec)println("recording on");
		if(!rec)println("recording off");
	}

}
