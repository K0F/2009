import krister.Ess.*;
import codeanticode.gsvideo.*;


AudioStream myStream;
Reverb myReverb;
LowPass myLowPass;
Normalize myNormalize;
float[] streamBuffer;
Envelope myEnvelope;
GSPipeline cam;

int x = 0;
int y  = 0;

void setup() {
	size(320/2,240/2,P2D);

	frameRate(25);

	cam = new GSPipeline(this, "v4l2src ! queue2 ! ffvideoscale !"+"video/x-raw-rgb,width="+(width)+",height="+(height));

	Ess.start(this);
	myStream=new AudioStream();
	myStream.sampleRate(44100);
	myStream.bufferSize(width*2);
	streamBuffer=new float[myStream.size];

	/*
	fillAudioBuffer();
	*/
	//myReverb=new Reverb();

	//myReverb.filter(myStream,0,myStream.frames(4000));
	// apply a low pass filter
	//myLowPass=new LowPass(160,39,32);
	//myLowPass.filter(myStream);

	// normalize
	myNormalize=new Normalize();

	myNormalize.filter(myStream);

	//EPoint[] env=new EPoint[3];
	//env[0]=new EPoint(0,0);
	//env[1]=new EPoint(.25,1);
	//env[2]=new EPoint(2,0);

	//myEnvelope=new Envelope(env);

	//myEnvelope.filter(myStream);
	myStream.start();

}

void fillAudioBuffer(){


	for(int Y=0; Y<height; Y++) {
		if(Y%2==0){
			for(int X=0; X<width; X++) {

				streamBuffer[Y*width+X] = map(brightness(cam.pixels[Y*width+X]),0,255,-0.9,0.9);
			}

		}else{
			for(int X=width-1; X>=0; X--) {

				streamBuffer[Y*width+X] = map(brightness(cam.pixels[Y*width+X]),0,255,-0.9,0.9);
			}
		}
	}
	
	

	//myLowPass=new LowPass(220,-80,4);

	//myLowPass.filter(myStream);
}

void fillAudioBufferL(){
	loadPixels();

	int cnt =0;
	for(int X=0; X<width; X++) {
		streamBuffer[cnt] = map(brightness(pixels[y*width+X]),0,255,-0.9,0.9);
		cnt++;
	}
	
	for(int X=width-1; X>=0; X--) {
		streamBuffer[cnt] = map(brightness(pixels[y*width+X]),0,255,-0.9,0.9);
		cnt++;
}

	//y=(int)((sin(frameCount/30.0)+1.0)*height/2.0);// width/3;//mouseY;
	y=height/2;//y%height;

}

void draw() {
	if (cam.available() == true){
		cam.read();
		set(0,0,cam);
		fillAudioBufferL();

	}
	
	
	stroke(#ff0000);
	line(0,height/2,width,height/2);

}

void audioStreamWrite(AudioStream theStream) {
	System.arraycopy(streamBuffer,0,myStream.buffer,0,streamBuffer.length);
}

void keyReleased(){


	int mod= keyCode-49;
	mod = constrain(mod,2,8);
	myStream.sampleRate(44100/mod);
	myStream.start();


}

public void stop() {
	Ess.stop();
	super.stop();
}

