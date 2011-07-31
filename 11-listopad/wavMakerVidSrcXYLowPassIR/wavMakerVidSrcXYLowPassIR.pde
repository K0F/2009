import codeanticode.gsvideo.*;

import java.util.ArrayList;
//import processing.opengl.*;
import ddf.minim.effects.*;
//import processing.video.*;
import ddf.minim.*;
import ddf.minim.signals.*;


GSPipeline cam;


//////// camera res ////////
int numX = 320;
int numY = 240;
//////////////////////////////

Minim minim;

AudioSample sam;
AudioOutput out;

playBack pb;
LowPassFS lpf;
Amplitude_Modulation AM;

//MovieMaker mm;

void setup()
{
	size(numX, numY, P2D);

	frameRate(25);
	noFill();
	noSmooth();

	//numX = (int)(koef*numX);
	//numY = (int)(koef*numY);


	//img = new int[numX*numY];
	cam = new GSPipeline(this, "v4l2src  ! queue ! ffvideoscale !"+"video/x-raw-rgb,width="+numX+",height="+numY);

	float[] tmp = new float[width*height];
	for(int i = 0;i<tmp.length;i++)
		tmp[i] = random(-100,100)/100.0;
	
	sam  = createSample(tmp,Minim.WAV,tmp.length);

	minim = new Minim(this);
	out = minim.getLineOut(Minim.STEREO,numX*numY);
	AM = new Amplitude_Modulation();

	pb = new playBack();

	out.addSignal(sam);
	out.addEffect(AM);

	//lpf = new LowPassFS(100, out.sampleRate());
	//lpf.setFreq(1350);

	//recorder = Minim.createRecorder(out, "output.wav", true);
	//recorder.beginRecord();
}

void draw()
{
	if (cam.available() == true){
		cam.read();
		set(0,0,cam);

		loadPixels();
		float[] tmp = new float[pixels.length];
		for(int i = 0;i<tmp.length;i++)
			tmp[i] = map(brightness(pixels[i]),0,255,0,1);

		pb.generate(tmp);
		//AM.process(tmp);

		//pb.generate(tmp,tmp);
		//println(tmp[0]);
	}
}

void keyReleased()
{
	if ( key == 'r' )
	{
		// to indicate that you want to start or stop capturing audio data, you must call
		// beginRecord() and endRecord() on the AudioRecorder object. You can start and stop
		// as many times as you like, the audio data will be appended to the end of the buffer
		// (in the case of buffered recording) or to the end of the file (in the case of streamed recording).
		if ( recorder.isRecording() )
		{
			recorder.endRecord();
		}
		else
		{
			recorder.beginRecord();
		}
	}
	if ( key == 's' )
	{
		// we've filled the file out buffer,
		// now write it to the file we specified in createRecorder
		// in the case of buffered recording, if the buffer is large,
		// this will appear to freeze the sketch for sometime
		// in the case of streamed recording,
		// it will not freeze as the data is already in the file and all that is being done
		// is closing the file.
		// the method returns the recorded audio as an AudioRecording,
		// see the example  AudioRecorder >> RecordAndPlayback for more about that
		recorder.save();
		println("Done saving.");
	}
}

class playBack implements AudioSignal{ //Just a simple "re-route" audio class.
	float[] left = new float[numX*numY];
	float[] right = new float[numX*numY];
	float mix[] = new float[numX*numY];
	//Getting.
	/*
		public void samples(float[] arg0) {
			left = arg0;
		}

		public void samples(float[] arg0, float[] arg1) {
			left = arg0;
			right = arg1;
		}*/
	//Sending back.

/*
	public void generate(float[] samp) {
		for(int i =0;i<samp.length;i++)
			samp[i];
	}
*/
	public void process(float[] samp) {
		for(int i =0;i<samp.length;i++)
			left[i] = samp[i];
	}
	
	void generate(float[] samp){
	
		for(int i = 0;i<samp.length;i++){
			this.samples[i] = samp[i];
		}
	}


	void generate(float[] left, float[] right)
	{
		generate(left);
		generate(right);
	}
	/*
	public void generate(float[] arg0, float[] arg1) {
	//System.out.println(arg0[0]);
	if (left!=null && right!=null){
		System.arraycopy(left, 0, arg0, 0, arg0.length);
		System.arraycopy(right, 0, arg1, 0, arg1.length);
}
}*/
}

class Amplitude_Modulation implements AudioEffect
{ // the mono version doesn’t do anything
	void process(float[] samp)
	{
		float[] AM = new float[samp.length];

		for (int j = 0; j < samp.length; j++) AM[j] = samp[j];

		// we have to copy the values back into samp for this to work
		arraycopy(AM, samp);
	}

	void process(float[] samp1, float[] samp2)
	{
		float[] AM = new float[samp1.length];

		for (int j = 0; j < samp1.length; j++) AM[j] = samp1[j]*samp2[j];
		// we have to copy the values back into samp for this to work
		arraycopy(AM, samp1);
		arraycopy(AM, samp2);
	}
}


void stop()
{
	out.close();
	minim.stop();
	super.stop();
}
