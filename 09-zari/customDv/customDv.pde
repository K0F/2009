import codeanticode.gsvideo.*;

GSPipeline pipe;

void setup()
{
	size(320, 240,P2D);


	pipe = new GSPipeline(this,"dv1394src ! dvdemux ! ffdec_dvvideo ! ffdeinterlace ! ffmpegcolorspace ! videoscale  ! video/x-raw-rgb ,width = 100, bpp=32, depth=24 ");

	frameRate(25);
	println("pipe created!");

	background(255);
}

void draw() {
	if (pipe.available() == true) {
		// println("got frame!");
		pipe.read();
		image(pipe, 0, 0);
	}


}
