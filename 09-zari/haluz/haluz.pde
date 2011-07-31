Recorder r;
boolean rec  = false;
float hust = 0.0;

PGraphics one,two;

void setup(){

	size(320,320,OPENGL);
	noStroke();
	frameRate(25);

	//one = createGraphics(width,height,P2D);
	//two = createGraphics(width,height,P2D);
	smooth();

	r = new Recorder("out","haluz2.mp4");

}


void draw(){

	background(255);

	haluz(frameCount);
	//haluz(-frameCount*6.28,two);

	//image(one,0,0);
	//blend(two,0,0,width,height,0,0,width,height,ADD);

	hust = (sin(frameCount/130.0)+2.5)*3.14;


	if(rec)
		r.add();

}

void keyPressed(){
	if(key == 'q'){

		if(rec)
			r.finish();
		exit();

	}

}

void haluz(float theta){
	int g = 0;
	int lasti = 0;
	pushMatrix();
	translate(width/2.0,height/2.0);
	rotate(radians(theta));

	
	for(int i =0;i<width*2;i+=5){
		if(g%2==0)
			fill(255);
		else
			fill(0);
		
		ellipse(cos(g/hust)*(2*width-i)/10.0,sin(g/hust)*(2*width-i)/10.0,2*width-i,2*width-i);
		g++;
		lasti=i;

	}	
	popMatrix();
	

}

void haluz(float theta,PGraphics a){

	a.beginDraw();
	a.background(255);
	a.smooth();
	a.noStroke();
	a.pushMatrix();
	a.translate(width/2.0,height/2.0);
	a.rotate(radians(theta));

	int g = 0;
	for(int i =0;i<width;i+=10){
		if(g%2==0)
			a.fill(255);
		else
			a.fill(0);

		a.ellipse(cos(g/hust)*20.0,sin(g/hust)*20.0,width-i,width-i);
		g++;

	}

	a.popMatrix();
	a.endDraw();


}
