import supercollider.*;

int num = 10;
Zenit z[];

void setup (){
	size(300, 300,P3D);
	frameRate(24);
	
	textFont(createFont("Veranda",9));
	textMode(SCREEN);
	
	z= new Zenit[num];

	for(int i =0 ;i<num;i++){
		z[i] = new Zenit();
	}
}

void draw (){
	background(0);
	for(int i =0 ;i<num;i++){
		z[i].live();

	}
}

void stop (){
	for(int i =0 ;i<num;i++){
		z[i].kill();
	}
}

class Zenit{
	float tx,ty,x,y,sx,sy;
	Synth synth;

	Zenit(){
		sx=x=tx=random(width);
		sy=y=ty=random(height);
		synth = new Synth("defs");
		synth.set("freq", 80);
		synth.create();
	}

	void live(){
		tx = tx+random(-10,10);
		ty = ty+random(-10,10);
		
		sx+=(tx-sx) * 0.1;
		sy+=(ty-sy) * 0.1;
		
		for(int i = 0;i<z.length;i++){
			if(dist(x,y,z[i].x,z[i].y)<10){
			tx-=(z[i].x-x)*.02;
			ty-=(z[i].y-y)*.02;
			}
		}
		
		bordr(10);
		
		x+=(tx-x)*0.01;
		y+=(ty-y)*0.01;
		float speed = abs(sx-x)+abs(sy-y);
		speed/=2.0;

		pushStyle();
		fill(255,80);
		noStroke();
		rect(x,y,3,3);
		text(speed,x,y);
		stroke(255,80);
		line(sx,sy,x,y);
		popStyle();

		synth.set("freq",speed);
	}
	
	void bordr(int q){
		if(tx<q)tx=q;
		if(tx>width-q)tx=width-q;
		
		if(ty<q)ty=q;
		if(ty>height-q)ty=height-q;
		
	}

	void kill(){
		synth.free();
	}
}
