/**
  * This sketch demonstrates how to use the <code>getLineIn</code> method of <code>Minim</code>. This method
  * returns an <code>AudioInput</code> object. An <code>AudioInput</code> represents a connection to the
  * computer's current record source (usually the line-in) and is used to monitor audio coming from an external source.
  * There are five versions of <code>getLineIn</code>:
  * <pre>
  * getLineIn()
  * getLineIn(int type)
  * getLineIn(int type, int bufferSize)
  * getLineIn(int type, int bufferSize, float sampleRate)
  * getLineIn(int type, int bufferSize, float sampleRate, int bitDepth)
  * </pre>
  * The value you can use for <code>type</code> is either <code>Minim.MONO</code> or <code>Minim.STEREO</code>.
  * <code>bufferSize</code> specifies how large you want the sample buffer to be, <code>sampleRate</code> specifies
  * the sample rate you want to monitor at, and <code>bitDepth</code> specifies what bit depth you want to monitor at.
  * <code>type</code> defaults to <code>Minim.STEREO</code>, <code>bufferSize</code> defaults to 1024,
  * <code>sampleRate</code> defaults to 44100, and <code>bitDepth</code> defaults to 16. If an <code>AudioInput</code>
  * cannot be created with the properties you request, <code>Minim</code> will report an error and return <code>null</code>.
  * <p>
  * When you run your sketch as an applet you will need to sign it in order to get an input.
  * <p>
  * Before you exit your sketch make sure you call the <code>close</code> method of any <code>AudioInput</code>'s
  * you have received from <code>getLineIn</code>.
  */
 
import ddf.minim.*;
import ddf.minim.analysis.*;

 import processing.opengl.*;
 
Minim minim;
AudioInput in;
FFT fft;


int cas = 0;
 
void setup()
{
  size(1024, 512, OPENGL);
 
  minim = new Minim(this);
//  minim.debugOn();
 
  // get a line in from Minim, default bit depth is 16
  in = minim.getLineIn(Minim.STEREO, 512);
   fft = new FFT(in.bufferSize(), in.sampleRate());

  background(0);
}
 
void draw()
{
	cas++;
	
	if(cas>width){
	background(0);
	cas=0;
	}
 // background(0);
  stroke(255,128,0,4);
  // draw the waveforms
  for(int i = 0; i < in.bufferSize() - 1; i++)
  {
    line(cas, 100 + in.left.get(i)*height*2, cas, 100 + in.left.get(i+1)*height*2);
   
  }
  
    // note that if jingle were a MONO file, this would be the same as using jingle.right or jingle.left
  fft.forward(in.mix);
  /*
  for(int i = 0; i < fft.specSize(); i++)
  {
    // draw the line for frequency band i, scaling it by 4 so we can see it a bit better
    stroke(255,constrain(fft.getBand(i)*120,0,200));
    line(cas, height-pow(i,0.5)*15, cas, 1+height-pow(i,0.5)*15);
  }
  */
  float w = int(width/fft.avgSize());

   for(int i = 0; i < fft.avgSize(); i++){
	   stroke(255);
	   rect(i*w, height, i*w + w, height - fft.getAvg(i));

	   }


  


}
 
 
void stop()
{
  // always close Minim audio classes when you are done with them
  in.close();
  //fft.colse();
  minim.stop();
 
  super.stop();
}
