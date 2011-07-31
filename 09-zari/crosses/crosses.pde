
int num = 550;
Kriz k[];

void setup(){

	size(320,240,OPENGL);

	k = new Kriz[num];
	for(int i =0;i<k.length;i++)
		k[i] = new Kriz();

	background(0);
	stroke(255,20);
	smooth();
}

void draw(){
	background(0);

	for(int i =0;i<k.length;i++)
		k[i].draw();

}


class Kriz{

	float theta = 0;
	float speed = 0;
	float x,y,w,l;

	Kriz(){
		speed = random(115,120);
		w = 3;
		l = 20;
		x = random(w,width-w);
		y=  random(w,height-w);
	}

	void draw(){
		theta += sin(frameCount/speed);

		//pushMatrix();
		//translate(random(-2,2),random(-2,2));
		cross(x,y,w,l,theta);
		//popMatrix();

	}

	void cross(float x,float y,float b,float vel,float t){
		pushMatrix();
		translate(x,y);
		rotate(radians(t));
		strokeWeight(b);
		line(-vel,0,vel,0);
		line(0,-vel,0,vel);
		popMatrix();
	}



}
