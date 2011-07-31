import codeanticode.gsvideo.*;
import imageadjuster.*;

//Translator tr;
GSPipeline cam;
ImageAdjuster adjust;
Recorder r;

//PImage store;
//Deconstructor a;
PGraphics result;
int W = 320;
int H = 240;
int matrix[];

PImage temp;


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
	adjust = new ImageAdjuster(this);
	//cam = new GSCapture(this,720,576,"v4lsrc");
	//result = createGraphics(width,height,P2D);
	//aspectratiocrop aspect-ratio=16/9
	//aspectratiocrop aspect-ratio=5/4 !
	cam = new GSPipeline(this,"v4l2src ! ffmpegcolorspace ! videoscale ! video/x-raw-rgb ,width = "+ W +",height = "+ H +", bpp=32, depth=24");
	r = new Recorder("out","movingSomething.mp4");
	frameRate(15);
	noStroke();
	stroke(255,25);
	noSmooth();

	readCam();
}

void draw(){


}

void keyPressed(){

	if(key==' '){
		readCam();
		r.add();
	}else if(key =='q'){
		r.finish();
		exit();

	}

}

void readCam(){
	if (cam.available() == true) {
		try{
			cam.read();
			//temp = cam;

			//temp.filter(GRAY);
			cam.filter(GRAY);

			adjust.brightness(cam,0, 0, width,height, 0.1);
			adjust.contrast(cam,0, 0, width,height, 2);
			//temp.filter(BLUR,5);
			//adjust.contrast(cam,0,0,width,height,3);
			//adjust.contrast(temp,0,0,width,height,3);

			//temp.filter(BLUR,3);

			//temp.filter(GRAY);

			//cam.filter(GRAY);


			image(cam,0,0);
			cam.filter(BLUR,2);
			blend(cam, 0, 0, width, height, 0, 0, width, height, OVERLAY);




		}catch(java.lang.NullPointerException e){
			println("weird error! @ "+frameCount);
		}
	}
}

