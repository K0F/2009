import processing.serial.*;
import cc.arduino.*;

boolean listen = true;


Arduino arduino;

float smoothv = 0;

void setup() {


	size(600,300,P2D);

	println(Arduino.list());
	arduino = new Arduino(this, Arduino.list()[0], 57600);

	frameRate(25);


	for (int i = 0; i <= 13; i++)
		arduino.pinMode(i, Arduino.OUTPUT);
	//arduino.pinMode(0,Arduino.INPUT);
	background(0);
}

int cnt=0;

void draw(){

	//background(0);

	stroke(255);


	int a = arduino.analogRead(0);
	smoothv += (a-smoothv)/3.0;


	//arduino.digitalWrite(13,Arduino.HIGH);


	line(cnt,map(smoothv,0,120,height,0),cnt+1,map(smoothv,0,120,height,0));


	cnt += 1;
	if(cnt>width){
		background(0);
		cnt=0;
	}

	println(a);


}


