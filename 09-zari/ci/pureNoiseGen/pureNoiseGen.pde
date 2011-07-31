
Recorder r;

void setup(){
	size(360,288,P2D);
	r = new Recorder("out","pureNoise.mp4");
}


void draw(){

	loadPixels();
	for(int i =0;i<pixels.length;i++){
	pixels[i] = color(random(255));
	}
	r.add();
	
	if(frameCount>(25*60)){
	r.finish();
	exit();
		
	}



}
