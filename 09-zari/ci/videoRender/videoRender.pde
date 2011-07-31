/**
 * Loop. 
 * Built-in video library replaced with gsvideo by Andres Colubri
 * 
 * Move the cursor across the screen to draw. 
 * Shows how to load and play a QuickTime movie file.  
 */

import codeanticode.gsvideo.*;

GSMovie myMovie;

int matrix[];
PGraphics temp;

Recorder r;
boolean rec = true;

int W = 360;
int H = 288;
Corner c[] = new Corner[4];

boolean gotImage = false;

void setup() {
	size(W, H, P2D);
	background(0);
	// Load and play the video in a loop
	temp = createGraphics(W,H,P2D);
	//che = loadImage("screen.png");
	loadMatrix();
	frameRate(15);

	//makeCheckImage();
	/*
		textureMode(NORMALIZED);
		ellipseMode(CENTER);
		noStroke();

		c[0] = new Corner(10.0,10.0,0.0,0.0);
		c[1] = new Corner(width-10.0,10.0,1.0,0.0);
		c[2] = new Corner(width-10.0,height-10.0,1.0,1.0);
		c[3] = new Corner(10.0,height-10.0,0.0,1.0);
	*/
	myMovie = new GSMovie(this, "order.mp4");
	myMovie.loop();

	if(rec)
		r = new Recorder("out","disorder.mp4");

	println("setup done, matrix got len.: "+matrix.length);
}

void movieEvent(GSMovie myMovie) {
	myMovie.read();
	gotImage = true;
}

/*
void makeCheckImage(){

	che.loadPixels();
	for(int y = 0;y<H;y++){
		for(int x = 0;x<W;x++){
			che.pixels[matrix[y*W+x]] = che.pixels[y*W+x];

		}
	}

	temp.save("checker.png");


}*/

void loadMatrix(){
	String[] tmp = loadStrings("matix"+W+"x"+H+".txt");
	matrix = new int[tmp.length];

	for(int y = 0;y<H;y++){
		for(int x = 0;x<W;x++){
			matrix[y*W+x] = parseInt(tmp[y*W+x]);
		}
	}

}

void draw() {

	//background(0);

	if(gotImage){

		temp.beginDraw();
		temp.image(myMovie,0,0);
		temp.endDraw();


		temp.loadPixels();
		for(int y = 0;y<H;y++){
			for(int x = 0;x<W;x++){
				temp.pixels[y*W+x] = myMovie.pixels[matrix[y*W+x]];

			}
		}


		image(temp,0,0,width,height);


		if(rec)
			r.add();
	}
	gotImage = false;


	/*
		beginShape();
		texture(temp);
		for(int i =0 ;i<c.length;i++){
			c[i].draw();
		}
		endShape();
		*/
}

void mouseReleased(){
	for(int i =0 ;i<c.length;i++){
		c[i].over = false;
	}
}

void keyPressed(){
	if(key == 'q'){
		r.finish();
		exit();

	}

}


class Corner{
	boolean over;
	float x,y,u,v;

	Corner(float _x,float _y,float _u, float _v){
		x=_x;
		y=_y;
		u=_u;
		v=_v;
	}

	void draw(){
		if(abs(mouseX-x)<15&&abs(mouseY-y)<15&&mousePressed)
			over = true;


		vertex(x,y,u,v);

		if(over){
			x = mouseX;
			y = mouseY;
			ellipse(x,y,15,15);
		}
	}


}
