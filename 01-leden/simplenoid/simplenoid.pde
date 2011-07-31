
int num = 450;
MyObj[] o = new MyObj[num];
PImage shade,glow;
Recorder r;


boolean smoothing = true;
boolean recording = true;
boolean blurring = true;

void setup() {

	size(600,300,P3D);
	background(0);


	if(smoothing)
		smooth();


	if(recording)
		r = new Recorder("out","sorting2.avi");

	shade = loadImage("shade.png");
	glow = loadImage("glow.png");
	imageMode(CENTER);
	rectMode(CENTER);

	PFont a = new PFont();

	//println(a.list());
	textFont(createFont(a.list()[86],9));
	textMode(SCREEN);
	textAlign(CENTER);

	//create an array of MyObjs
	for(int i=0;i<o.length;i++) {
		o[i] = new MyObj(i);
	}
	// sort the array. since MyObj implements
	// the comparable interface, the MyObj list
	// will be sorted based on the outcome of
	// function toCompare
	Arrays.sort(o);



	// print the sorted list based on value x of
	// each object

}


void draw(){
	//background(40);

	fill(20,180);
	rect(width/2,height/2,width,height);

	Arrays.sort(o);


	for(int i  = 0;i<o.length;i++){
		o[i].draw();
	}
	
	if(blurring){
	filter(BLUR,1.8);
	for(int i  = 0;i<o.length;i++){
		o[i].draw();
	}
	}


	if(recording)
		r.add();
}

void keyPressed(){
	if(key=='q'){
		if(recording)
			r.finish();
		exit();

	}

}

class MyObj implements Comparable {
	float x,y,tx,ty;
	int id;
	color c;
	int cycle;
	int sir = 20;
	int redT = 0;
	float theta = 0;

	MyObj(int theId) {
		id = theId;
		cycle = (int)random(1500)+40;
		c = color(lerpColor(0xff2e482c,0xff000000,random(1000)/1000.0));
		tx = x = (random(width));
		ty = y = (random(height));
	}


	void draw(){
		stroke(0);
		image(shade,x+5,y+5);
		fill(c,200);
		rect(x,y,sir,sir);
		fill(0,60);
		text(id,x+2,y+4);
		fill(#a6552b);
		text(id,x,y+3);

		line(x+3,y+10,x+3,height);
		stroke(255,15);
		line(x+2,y+10,x+2,height);
		noStroke();
		//fill(#8c0d0d,redT);
		//rect(x+sir/2.0-2,y-sir/2.0+1.5,3,3);
		if(frameCount%cycle==0){
			redT=255;
			tx=random(width);
			ty=random(height);
		}

		tint(255,redT);
		image(glow,x+2,y+2,60,60);
		noTint();

		drawNode();

		x+=(tx-x)/30.0;
		y+=(ty-y)/30.0;

		if(redT>1)
			redT-=3;
		//collide();
	}

	void collide(){
		//boolean answ = false;
		//	int w = 0;
		int coll[] = new int[0];

		for(int i =0;i<o.length;i++){
			if(abs(x-o[i].x)<sir/2.0&&abs(y-o[i].y)<sir/2.0){
				x+=(tx-o[i].x)/20.0;
				y+=(ty-o[i].y)/20.0;
			}



			coll = (int[])expand(coll,coll.length+1);
			coll[coll.length-1]=i;

		}


	}

	void drawNode(){
		theta += 0.1*(atan2(ty-y,tx-x)-theta);
		pushStyle();
		stroke(0,100);
		noFill();
		//for(float i = 0;i<=1;i+=0.1){
		pushMatrix();
		translate(x,y);
		rotate(theta);
		//	if(i==1)

		stroke(lerpColor(#000000,#ffffff,norm(redT,0,255)),100);
		triangle(50,0,40,3,40,-3);
		rect(0,0,sir*2+sir,sir*2+sir);
		//line(0,0,50,0);
		popMatrix();
		//}
		popStyle();

	}

	//if we want to sort based on the X value of MyObj-es:
	int compareTo(Object o)
	{
		MyObj other=(MyObj)o;
		if(other.y>y)
			return -1;
		if(other.y==y)
			return 0;
		else
			return 1;
	}

}
