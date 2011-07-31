
Squad squad;

void setup(){
	size(640,480,P3D);
	squad = new Squad(0,12);
	rectMode(CENTER);
}

void draw(){
	background(255);

	squad.run();

}

class Squad{
	Soldier s[];
	int num,id,cx=0,cy=0;
	float x,y,tx,ty;
	float heading,h2,th;
	float speed = 0.3;

	Squad(int _id,int _num){
		id = _id;
		num = _num;
		s = new Soldier[num];
		x=width/2;
		y=height/2;



		for(int i =0;i<num;i++){
			s[i] = new Soldier(this,100,i);
		}



		tx = width/2;//mouseX;
		ty = 0;//mouseY;
	}

	void run(){


		if(dist(x,y,tx,ty)>1.0){
			x+=cos(heading)*speed;
			y+=sin(heading)*speed;
		}


		heading =  atan2(ty-y,tx-x);


		//println(th);

		
		

		pushMatrix();
		translate(0,height/2);
		pushMatrix();
		rotateX(radians(50));

		
		translate(0,-420,-170);
		
		
		
		fill(255,255,0,70);
		rect(width/2,height/2,width,height);
		
		
		pushMatrix();
		translate(x,y);

		pushMatrix();
		rotate(heading+PI/2);



		stroke(0);
		line(0,-10,0,-30);

		for(int i =0;i<num;i++){
			s[i].draw();
		}

		popMatrix();

		popMatrix();

		popMatrix();

		popMatrix();
	}




}


class Soldier{
	PImage gfx;
	int health,type,id;
	int roz = 5;
	float x,y;
	float tx,ty;
	Squad parent;
	float speed = 0.1;

	Soldier(Squad _p,int _health,int _id){
		parent = _p;
		health = _health;
		id = _id;
		x=0;
		y=0;

		parent.cx=(id*roz)%20;
		tx = parent.cx-10;//(id*roz)%15;//+random(-2,2);

		if(parent.cx%20==0){
			parent.cy++;
		}
		ty = parent.cy*roz;//tx%15;


	}

	void draw(){
		noStroke();
		fill(0);

		x+=(tx-x)*speed;
		y+=(ty-y)*speed;

		pushMatrix();
		translate(x,y);
		rect(0,0,3,3);
		popMatrix();


	}



}

void mousePressed(){
	squad.tx = mouseX;
	squad.ty = mouseY;
}
