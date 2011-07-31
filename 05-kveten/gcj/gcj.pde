void setup(){
	size(200,200,OPENGL);
	stroke(255);
}

int count = 0;

void draw(){
	background(0);
	line(0,count%height,width,count%height);
	count++;

}
