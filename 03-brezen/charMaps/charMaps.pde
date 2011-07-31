
import processing.opengl.*;

int w = 320;
int h = 240;
int res = 8;

PImage shade;
PGraphics light;

float speed = 30.0;

Recorder r;

int map[] = new int[w*h/res];
color[] cs = new color[map.length];
int timer[] = new int[map.length];

float lift = 1;
float[] lifts = new float[map.length];


PGraphics frame[];

void setup(){
	size(w,h,OPENGL);
	background(255);
	noSmooth();
	
	textFont(createFont("Tahoma",8));
	//textMode(SCREEN);
	
	shade = loadImage("shade1.png");
	//imageMode(SCREEN);
	
	light = createGraphics(40,40,JAVA2D);
	light.beginDraw();
	light.stroke(255);
	light.strokeWeight(10);
	light.line(12,12,40,40);
	light.filter(BLUR,1.8);
	light.endDraw();
	
	r = new Recorder("out","charMap.mp4");
	
	for(int i = 0;i<map.length;i++){
		map[i] = (int)random(10);
		lifts[i] = map[i];
		timer[i] = 0;
		cs[i] = color(random(20,255),66,15);
	}

	fill(0);
	//stroke(0,150);
	noStroke();
	frame = new PGraphics[10];
	for(int i = 0;i<frame.length;i++)
	frame[i] = generateFrame(0,random(240,255),random(34,40),2+random(200)/100.0,5);

}


void draw(){

	//background(255);

	int x=0, y = res;
	int sum = 0;
	for(int i = 0;i<map.length;i++){
		//map[i] = (int)(10*(0.5*(sin((frameCount+x)/30.0)+1)));
		int curr = map[i];
		
		if(curr!=lifts[i]){
			timer[i] = 90;
		}
		lifts[i] = curr;
		
		color c = lerpColor(cs[i],color(curr*25),0.5);
		
		fill(c);
		rect(x-lifts[i]*lift,y-lifts[i]*lift-res,res,res);
		
		
		c = lerpColor(cs[i],color(curr*10),0.7);
		
		fill(c);
		beginShape();		
		vertex(x-lifts[i]*lift+res,y-lifts[i]*lift-res);
		vertex(x+res,y-res);
		vertex(x+res,y);
		vertex(x-lifts[i]*lift+res,y-lifts[i]*lift);
		endShape();
		
		
		c = lerpColor(cs[i],color(curr*5),0.8);
		
		
		fill(c);
		beginShape();		
		vertex(x-lifts[i]*lift,y-lifts[i]*lift);
		vertex(x-lifts[i]*lift+res,y-lifts[i]*lift);
		vertex(x+res,y);
		vertex(x,y);
		endShape();
		
		
		
		
		
		fill(0);
		text(curr,x-lifts[i]*lift+1,y-lifts[i]*lift-1);
		image(shade,x-lifts[i]*lift,y-lifts[i]*lift-res);
		x+=res;
		sum +=curr;
		
		if(timer[i]>0){
			timer[i]-=25;
			tint(255,timer[i]);
			image(light,x-lifts[i]*lift-10-res,y-lifts[i]*lift-res-10);
			noTint();
		}
		
		if(x>w){
			//fill(map(sum,w/res*3,w/res*6,255,0),155);
			//rect(0,y-res,w,res);
			sum=0;
			x=0;
			y+=res;
		}
	}
	
	image(frame[(int)random(frame.length)],random(-5),random(-5));
	
	r.add();

	if(random(100)>80)
	mutate(10);
}

void keyPressed(){
	if(key=='q'){
		r.finish();
		exit();
	}

}


PGraphics generateFrame(float _shade,float _al,float _wei,float _bl,int _reserva){
	PGraphics p;

	p = createGraphics(width+_reserva,height+_reserva,JAVA2D);
	p.beginDraw();
	p.stroke(_shade,_al);
	p.strokeWeight(_wei);
	p.noFill();
	p.rect(0,0,width+_reserva,height+_reserva);
	p.filter(BLUR,_bl);
	p.endDraw();

	
	return p;

}

void mutate(int mult){
	int which[] = new int[mult];

	for(int i = 0;i<mult;i++){
		which[i] = (int)random(map.length);
		
		if(random(500)>250){
		map[which[i]] ++;
		}else{
		map[which[i]] --;		
		}
		//map[which[i]]=(int)random(10);
		map[which[i]] = constrain(map[which[i]],0,9);
	}
}
