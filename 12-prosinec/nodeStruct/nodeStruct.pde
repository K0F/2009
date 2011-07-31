
Recorder r;
boolean rec = false;

import krister.Ess.*;


Node[] n = new Node[12];
PImage shape1 ;


AudioStream myStream;
float[] streamBuffer;

int y  = 0;

void setup()
{

	size(720,576/2,OPENGL);
	background(0);
	frameRate(25);
	smooth();
	
	Ess.start(this);

	myStream=new AudioStream();
	myStream.sampleRate(44100/4);
	myStream.bufferSize(width*2);
	streamBuffer=new float[myStream.size];
	myStream.start();
	
	shape1 = loadImage("shape1.png");
	
	y = height /2;
	strokeWeight(1.77);
	
	for(int i =0;i<n.length;i++)
	{
		n[i] = new Node(i);
	}

	
	if(rec)
		r = new Recorder("out","fluental");

}



void audioStreamWrite(AudioStream theStream) {
	System.arraycopy(streamBuffer,0,myStream.buffer,0,streamBuffer.length);
}

void fillAudioBufferL(){
	loadPixels();

	int cnt =0;
	for(int X=0; X<width; X++) {
		streamBuffer[cnt] = map(brightness(pixels[y*width+X]),0,255,-0.9,0.9);
		cnt++;
	}
	
	for(int X=width-1; X>=0; X--) {
		streamBuffer[X] = map(brightness(pixels[y*width+X]),0,255,-0.9,0.9);
		cnt++;
		}

	//y=(int)((sin(frameCount/30.0)+1.0)*height/2.0);// width/3;//mouseY;
	y=height/2;//y%height;

}


public void stop() {
	Ess.stop();
	super.stop();
}

void draw()
{
	background(0);
	//fill(0,90);
	//rect(0,0,width,height);
	
	for(int i =0;i<n.length;i++)
	{
		n[i].live();
	}	

	
	fillAudioBufferL();
	
	stroke(255,90);
	line(0,height/2,width,height/2);
	
	if(rec)
		r.add();
}

void keypressed(){
	if(key=='q')
	{
		if(rec)
		r.finish();
		exit();
	}
}

void BBox(){

	//pushMatrix();
	
	
	pushMatrix();
	translate(width/2.0,height/2.0);
	rotateY(radians(frameCount/3.0));
	noFill();
	noTint();
	stroke(0,10);
	box(400);

	
	popMatrix();


	
	//popMatrix();

}

class Node
{
	float x,y,sx,sy,speed = 60.0;
	float pulsar = 0;
	float pulseSpeed;
	int id;
	float area,areaB = 40.0;
	color c;

	Node(int _id)
	{
		id = _id;
		sx = x = random(width);
		sy = y = random(height);
		
		areaB = random(5,200);
		area = areaB;
		
		pulsar = random(1000)/100.0;
		pulseSpeed = random(4,3000);

		c = color(255);//color(random(255));
	}

	void seek()
	{

		area = 1+areaB*(sin(pulsar/pulseSpeed)+1.0)/2.0;
		pulsar +=2*(sin(frameCount/3.0)+1.0)*150.0;
		
		Node tmp = getNearest();

		if(dist(sx,sy,tmp.sx,tmp.sy)>=area+1){

			x += (tmp.x-x)/speed;
			y += (tmp.y-y)/speed;
		}else if(dist(sx,sy,tmp.sx,tmp.sy)<=area){

			x -= (tmp.x-x)/(speed*0.033);
			y -= (tmp.y-y)/(speed*0.033);

		}

		//stroke(255,40);
		//line(tmp.sx,tmp.sy,sx,sy);

	}
	
	void bordr()
	{
	
		if(x>width-area/2.0)x=width-area/2.0;
		if(x<area/2.0)x=area/2.0;
		
		
		if(y>height-area/2.0)y=height-area/2.0;
		if(y<area/2.0)y=area/2.0;
		
	
	}

	Node getNearest()
	{
		float lenn = width * height;
		Node a = this;

		for(int i = 0;i<n.length;i++)
		{

			float temp = dist(x,y,n[i].x,n[i].y);
			if(lenn>temp && i != id)
			{
				lenn = temp;
				a = null;
				a = n[i];
			}

		}

		return a;

	}


	void connect()
	{




	}

	void pulse()
	{


	}

	void live()
	{

		seek();
		bordr();
		
		//x+=(mouseX-x)/(abs(x-mouseX)+1);
		//y+=(mouseY-y)/(abs(y-mouseY)+1);
		
		sx += (x-sx)/1000.0;
		
		sy += (y-sy)/1000.0;
		//sy += (sin(x/30.0)*50.0-sy+height/2)/3.0;
		
		pushStyle();
		noFill();
		stroke(255,80);
		rectMode(CENTER);
		//imageMode(CENTER);
		
		for(float i = 0 ;i<250;i+=8+map(area,0,250,10,-5)){
		stroke(c,90);
		ellipse(sx,sy,i,i);
		}
		
		//tint(c,90);
		//image(shape1,sx,sy,area*2,area*2);
		
		//ellipse(sx,sy,area,area);

		//rect(sx,sy,3,3);
		popStyle();

	}



}
