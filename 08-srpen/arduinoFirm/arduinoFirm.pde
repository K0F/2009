import processing.serial.*;
import cc.arduino.*;

Arduino arduino;
int ledPin = 11;

import javax.swing.*;


void init(){
	frame.setLocation(1680,10);
	super.init();

}

void setup(){
	size(200,200);
	//frame.setLocation(50,10);
	
	JFrame f = new JFrame("ciao");
		f.pack();
		f.setSize(100,100);
		f.setLocation(1680,20);
		f.show();
		f.background(0);
		
	
	//println(Arduino.list());
	arduino = new Arduino(this, Arduino.list()[0]); // v2
	// arduino = new Arduino(this, Arduino.list()[0], 57600); // v1
	arduino.pinMode(ledPin, Arduino.OUTPUT);
	frameRate(30);
}

void draw()
{
	
	background(0);
	arduino.analogWrite(ledPin, (int)map(mouseX,0,width,0,255));

}

