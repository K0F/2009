
import gifAnimation.*;
import processing.opengl.*;
import codeanticode.gsvideo.*;
import supercollider.*;

boolean debug = false;

//PFont f;
Recorder r;
GSCapture cam;
Gif anima;

boolean rec = false;
boolean ive = false;

int num = 120;

Synth synth[] = new Synth[num];


// Flowfield object
FlowField flowfield;
// An ArrayList of boids
ArrayList boids;

float tresh = 0.5;
int cntr = 1;

int W=720,H=576/2;
color[] c,ac;
int bordr =10;
int rut = 30;
int dx = 1,dy =1;
boolean first = true;

boolean gotnew = false;
boolean getNew = true;
boolean cc = false;

int tii = 500;

void setup() {
	size(720, 376,OPENGL);
	noSmooth();
	frameRate(30);
	//f = createFont("Arial", 8 ,true);

	if(rec)
		r = new Recorder("out","crowCrowd5.mp4");

	flowfield = new FlowField(16);
	boids = new ArrayList();

	anima = new Gif(this,"bird.gif");
	
	for(int i = 0;i<synth.length;i++){
		synth[i] = new Synth("simpleSynth");
		synth[i].set("freq", i);
		synth[i].set("amp", 1/(num+1.0));
		synth[i].create();
	}

	for (int i = 0; i < num; i++) {
		boids.add(new Boid(this,anima,new PVector(random(width),random(height)),random(2,5),random(0.1f,0.5f)));
	}
	noSmooth();

	if(ive){
		cam = new GSCapture(this, 720/2,576/2, "v4lsrc");
		//W = cam.width;
		//H = cam.height;
		c = new color[W*H];
		ac = new color[W*H];
		println(W+":"+H);
	}
	noFill();

	background(0);
}

void draw() {
	if(ive){
		camcyc();
	}else{
		background(#222222);
	}
	//background(255);
	//fill(21,33,45,125);
	//noStroke();
	//rect(-1,-1,width+2,height+2);

	// Display the flowfield in "debug" mode
	if (debug) flowfield.display();
	// Tell all the boids to follow the flow field
	for (int i = 0; i < boids.size(); i++) {
		Boid b = (Boid) boids.get(i);
		b.follow(flowfield);
		b.run();
		synth[i].set("freq",map(b.loc.y,0,height,1220,10));
		//synth[i].set("amp",((0.5*(sin((b.time+b.desync)/(i+1.0))+1.0))*0.02));
	}

	if(frameCount%tii==0){
		flowfield.init();                                                   
		tii = (int)random(20,800);
	}

	// Instructions
	if(rec)
		r.add();

}


void keyPressed() {
	if(key==' '){
		debug = !debug;
	}else if(key=='q'){
		if(rec)
			r.finish();

		if(ive){
			cam.stop();
			cam.dispose();
		}
		
		for(int i  =0;i<synth.length;i++){
			synth[i].free();		
		}
		
		exit();
	}
}

// Make a new flowfield
void mousePressed() {
	flowfield.init();
}



void camcyc(){
	noFill();
	gotnew = true;

	if(cc){
		getNew = true;

	}

	if (cam.available()) {
		cam.read();

		//	gotnew = true;


	}

	if(getNew){


		if(first){
			c = cam.pixels;
			first = false;
		}else{
			c = cam.pixels;
		}

		for(int y = 0 ; y<H ;y+=dy){

			for(int x= 0 ; x<W ;x+=dx){
				stroke(ac[y*W+x]);
				point(x,y);
				if(gotnew){
					ac[y*W+x]=lerpColor(ac[y*W+x],color(brightness(c[y*W+x])),tresh);
				}
			}



		}
		//				r.add();
		//println("capture on frame :"+frameCount);
		//getNew = false;

	}

	if(cc){
		fill(0);
		rect(width-20,20,10,10);
	}
	//image(cam, 0, 0);
	// The following does the same, and is faster when just drawing the image
	// without any additional resizing, transformations, or tint.
	//set(160, 100, cam);


}





