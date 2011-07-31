

Node[] n = new Node[250];
PImage shape1 ;

void setup()
{

	size(1024,768,OPENGL);
	background(0);

	
	shape1 = loadImage("shape1.png");
	
	for(int i =0;i<n.length;i++)
	{
		n[i] = new Node(i);
	}



}


void draw()
{
	//background(0);
	fill(0,2);
	rect(0,0,width,height);
	
	for(int i =0;i<n.length;i++)
	{
		n[i].live();
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
		pulseSpeed = random(2,30);

		c = color(random(255));
	}

	void seek()
	{

		area = 1+areaB*(sin(pulsar/pulseSpeed)+1.0)/2.0;
		pulsar ++;
		
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
		
		sx += (x-sx)/10.0;
		
		sy += (y-sy)/10.0;
		
		pushStyle();
		noFill();
		stroke(255,80);
		rectMode(CENTER);
		imageMode(CENTER);
		
		tint(c,90);
		image(shape1,sx,sy,area*2,area*2);
		
		//ellipse(sx,sy,area,area);

		//rect(sx,sy,3,3);
		popStyle();

	}



}
