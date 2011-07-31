import codeanticode.gsvideo.*;

//Translator tr;
GSPipeline cam;
//PImage store;
//Deconstructor a;
PGraphics result;
int W = 360;
int H = 288;
int matrix[];

boolean check = true;

import codeanticode.gsvideo.*;



void init() {
  /// to make a frame not displayable, you can 
  // use frame.removeNotify() 
  frame.removeNotify(); 
 
  frame.setUndecorated(true); 
 
  // addNotify, here i am not sure if you have  
  // to add notify again.                                                  
  frame.addNotify(); 
  super.init();
}

void setup(){

	//store = loadImage("screen.png");
	//a = new Deconstructor(store);
	size(W,H,P2D);
	//cam = new GSCapture(this,720,576,"v4lsrc");
	//result = createGraphics(width,height,P2D);
	//aspectratiocrop aspect-ratio=16/9
	cam = new GSPipeline(this,"dv1394src ! dvdemux ! ffdec_dvvideo ! ffmpegcolorspace ! aspectratiocrop aspect-ratio=5/4 ! ffvideoscale, method=6 ! video/x-raw-rgb ,width = "+ W +",height = "+ H +", bpp=32, depth=24");
	
	frameRate(15);
	noStroke();
	stroke(255,25);
	noSmooth();
}

void draw(){
	readCam();
}

void readCam(){
	if (cam.available() == true) {
		try{
			cam.read();
			image(cam,0,0);
		}catch(java.lang.NullPointerException e){
			println("weird error! @ "+frameCount);
		}
	}
}

void keyPressed(){
	if(key == ' '){
		check=!check;
	}

}
