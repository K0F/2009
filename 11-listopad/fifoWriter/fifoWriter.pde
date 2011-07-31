byte[] data;

import codeanticode.gsvideo.*;

GSPipeline pipe;
void setup(){
	size(300,300);
	
	data = new byte[width*height];
	
	
	println(data.length);
	
	pipe = new GSPipeline(this, "ximagesrc name=fifoWriter ! queue ! videorate ! video/x-raw-yuv,framerate=25/1 ! xvidenc ! queue ! avimux ! queue ! filesink location=/tmp/tmp");



}



void draw(){

	background(0);
	stroke(255);
	
	int y = (int)random(height);
	
	line(0,y,width,y);
	
	loadPixels();
	
	for(int i =0;i<pixels.length;i++)
	data[i] = (byte)pixels[i];
	
	saveBytes("/tmp/tmp",data);


}
