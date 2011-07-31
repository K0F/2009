


OscSender s;

float x,y,vel;

void setup() {
	size(320,240,P2D);
	frameRate(30);
	s = new OscSender("127.0.0.1",12000);

}



                                                                           
void draw() {
	background(0);
	x = map(mouseX,0,width,220,240);
	y = map(mouseY,0,height,10,25);
	
	
	stroke(255,100);
	line(mouseX,0,mouseX,height);
	line(0,mouseY,width,mouseY);
	
	float[] tst = {x,y};
	s.send("/test", tst);
}

