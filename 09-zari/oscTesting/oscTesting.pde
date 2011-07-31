import netP5.*;
import oscP5.*;

  
oscP5.OscP5 oscP5;
netP5.NetAddress myRemoteLocation;

void setup() {
  size(400,400);
  frameRate(25);
  
  oscP5 = new oscP5.OscP5(this,111);
  
}


void draw() {
  background(0);  
}

void mousePressed() {
 
  OscMessage myMessage = new OscMessage("/test");
  
  myMessage.add(123);

}



void oscEvent(OscMessage theOscMessage) {
 
  print("### received an osc message.");
  print(" addrpattern: "+theOscMessage.addrPattern());
  println(" typetag: "+theOscMessage.typetag());
}
