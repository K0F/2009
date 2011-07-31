// Example by Krister Olsson

import krister.Ess.*;

AudioStream myStream;
SineWave myWave;

void setup() {
  size(256,200,P2D);
  background(0,0,255);

  // start up Ess
  Ess.start(this);

  // create a new AudioStream
  myStream=new AudioStream();

  // our wave
  myWave=new SineWave(90,.33);
  
  // start
  myStream.start();
}

void draw() {
  stroke(255,10);

  // overlay an average of the samples in the buffer being played
  float inc=myStream.buffer.length/256.0f;
  for (int i=0;i<256;i++) {
    int y=(int)(100+myStream.buffer[(int)(i*inc)]*100);
    
    line(i-200,y-200,i+200,y+200);
  }
}

void audioStreamWrite(AudioStream theStream) {
  // next wave
  myWave.generate(myStream);

  // adjust our phase
  myWave.phase+=myStream.size;
  myWave.phase%=myStream.sampleRate;
}

// we are done, clean up Ess

public void stop() {
  Ess.stop();
  super.stop();
}
