import ddf.minim.analysis.*;
import ddf.minim.*;

Minim minim;
AudioInput in;
FFT fftLog;

float vals[];
float speed = 1.0;

boolean flicker = false;

void setup()
{
	size(1678, 1048, OPENGL);
//	textMode(SCREEN);

	frameRate(30);

	minim = new Minim(this);

	in = minim.getLineIn(Minim.STEREO, 1024);
	
	//println(PFont.list());
	//textFont(createFont("Electron", 8));

	fftLog = new FFT(in.bufferSize(), in.sampleRate());
	fftLog.logAverages(22, 3);

	vals = new float[fftLog.avgSize()];
	for(int i = 0;i<vals.length;i++)
		vals[i] = 0;
	
	fftLog.window(FFT.HAMMING);
	noStroke();
	//noCursor();

}
void draw()
{
	fftLog.forward(in.mix);
	float density = 5;
	int w = int(width/fftLog.avgSize());
	float x = 0;

	// update vals
	for(int i = 0; i<fftLog.avgSize() ;i++){
		density = map(fftLog.getAvg(i),0,20,1,2);
		vals[i] += (density-vals[i])/speed;
		x += vals[i]*2.0;
	}

	//colours
	if(flicker){
		if(frameCount%2==0){
			background(0);
			fill(255);
		}else{
			background(255);
			fill(0);

		}
	}else{
		background(0);
		fill(255,200);


	}

	// draw
	for(int i =0;i<vals.length;i++){
		fill(255,200);
		rect(i*(width/vals.length),0,map(pow(vals[i]-0.5,1.5),0,x,0,width),height);
		fill(0);
		//for(int q = 0;q<height;q+=8)
		//text((int)map(pow(vals[i]-0.5,1.5),0,x,0,width)+"",i*(width/vals.length),q);
	}
}


void stop()
{
	// always close Minim audio classes when you finish with them
	in.close();
	minim.stop();

	super.stop();
}
