// Learning Processing
// Daniel Shiffman
// http://www.learningprocessing.com

// Example 15-13: Sharpen with convolution
/*
 int xstart = constrain(mouseX-w/2,0,img.width); 
  int ystart = constrain(mouseY-w/2,0,img.height);
  int xend = constrain(mouseX + w/2,0,img.width);
  int yend = constrain(mouseY + w/2,0,img.height);
  */

boolean rec = true;
Recorder r;

int xstart = 0;
int ystart = 0;
int xend;
int yend;

PImage img;
PGraphics g;
int w = 80;
// The convolution matrix for a "sharpen" effect stored as a 3 x 3 two-dimensional array.
float[][] matrix = { { -.01, -.1, -.01 } ,
                     { -.1, 1.44, -.1 } ,
                     { -.01, -.1, -.01 } } ;
float calib = 0;
float[][] matrix2 = { { -.01+calib, -.1+calib, -.01+calib } ,
                      { -.1+calib, 1.44+calib, -.1+calib } ,
                      { -.01+calib, -.1+calib, -.01+calib } } ;

int matrixsize = 3;

void setup() {
	img = loadImage( "bratri.png" );
	xend = img.width;
	yend = img.height;
	g = createGraphics(img.width,img.height,JAVA2D);
	g.beginDraw();
	g.image(img,0,0);
	g.endDraw();

	r = new Recorder("out","convlutionOne.mp4");

	size(img.width,img.height);
}

void draw() {

	// We're only going to process a portion of the image
	// so let's set the whole image as the background first
	//image(img,0,0);

	// In this example we are only processing a section of the image-an 80 x 80 rectangle around the mouse location.




	if(frameCount%10==0){
		if(rec){
			r.add();

		}
		//g.filter(INVERT);
		g.filter(BLUR,4);

	}
	
	for
	
	g.loadPixels();
	g.beginDraw();
	PImage tmp = (PImage)g;
	// Begin our loop for every pixel
	for (int x = xstart; x < xend; x++ ) {
		for (int y = ystart; y < yend; y++ ) {
			// Each pixel location (x,y) gets passed into a function called convolution()
			// The convolution() function returns a new color to be displayed.
			color c = convolution2(x,y,matrix2,matrixsize,tmp);
			int loc = x + y*img.width;
			g.pixels[loc] = c;
		}
	}
	g.updatePixels();
	g.endDraw();

	image(g,0,0);




	// rect(xstart,ystart,w,w);
}

void keyReleased(){
	if(key=='q'){
		if(rec){
			r.finish();

		}
		exit();
	}

}

void mousePressed(){



	// loadPixels();
	if(frameCount%10==0)
		g.filter(BLUR,2.0);

	g.loadPixels();
	g.beginDraw();
	// Begin our loop for every pixel
	for (int x = xstart; x < xend; x++ ) {
		for (int y = ystart; y < yend; y++ ) {
			// Each pixel location (x,y) gets passed into a function called convolution()
			// The convolution() function returns a new color to be displayed.
			color c = convolution(x,y,matrix,matrixsize,(PImage)g);
			int loc = x + y*img.width;
			g.pixels[loc] = c;
		}
	}
	g.updatePixels();
	g.endDraw();



	stroke(0);
	noFill();

}

color convolution(int x, int y, float[][] matrix, int matrixsize, PImage img) {
	float rtotal = 0.0;
	float gtotal = 0.0;
	float btotal = 0.0;
	int offset = matrixsize / 2;

	// Loop through convolution matrix
	for (int i = 0; i < matrixsize; i++ ) {
		for (int j = 0; j < matrixsize; j++ ) {

			// What pixel are we testing
			int xloc = x + i-offset;
			int yloc = y + j-offset;
			int loc = xloc + img.width*yloc;

			// Make sure we haven't walked off the edge of the pixel array
			// It is often good when looking at neighboring pixels to make sure we have not gone off the edge of the pixel array by accident.
			loc = constrain(loc,0,img.pixels.length-1);

			// Calculate the convolution
			// We sum all the neighboring pixels multiplied by the values in the convolution matrix.
			rtotal += (red(img.pixels[loc]) * matrix[i][j]);
			gtotal += (green(img.pixels[loc]) * matrix[i][j]);
			btotal += (blue(img.pixels[loc]) * matrix[i][j]);
		}
	}

	// Make sure RGB is within range
	rtotal = constrain(rtotal,0,255);
	gtotal = constrain(gtotal,0,255);
	btotal = constrain(btotal,0,255);

	// Return the resulting color
	return color(rtotal,gtotal,btotal);
}

color convolution2(int x, int y, float[][] matrix, int matrixsize, PImage img) {
	float rtotal = 0.0;
	float gtotal = 0.0;
	float btotal = 0.0;
	int offset = matrixsize / 2;

	// Loop through convolution matrix
	for (int i = 0; i < matrixsize; i++ ) {
		for (int j = 0; j < matrixsize; j++ ) {

			// What pixel are we testing
			int xloc = x + i-offset;
			int yloc = y + j-offset;
			int loc = xloc + img.width*yloc;

			// Make sure we haven't walked off the edge of the pixel array
			// It is often good when looking at neighboring pixels to make sure we have not gone off the edge of the pixel array by accident.
			loc = constrain(loc,0,img.pixels.length-1);

			// Calculate the convolution
			// We sum all the neighboring pixels multiplied by the values in the convolution matrix.
			rtotal += (red(img.pixels[loc]) * matrix2[i][j]);
			gtotal += (green(img.pixels[loc]) * matrix2[i][j]);
			btotal += (blue(img.pixels[loc]) * matrix2[i][j]);
		}
	}

	// Make sure RGB is within range
	rtotal = constrain(rtotal,0,255);
	gtotal = constrain(gtotal,0,255);
	btotal = constrain(btotal,0,255);

	// Return the resulting color
	return color(rtotal,gtotal,btotal);
}

