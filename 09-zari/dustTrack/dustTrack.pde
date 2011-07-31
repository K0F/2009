
Agent a[];
float sila = 1.0;
float sila2 = 10.0;

float prostredi = 0.98;
float hmotnost = 1000.0;

void setup(){
	size(400,400,OPENGL);

	a = new Agent[150];

	reset();
	noSmooth();
	background(0);
}

void mousePressed(){
	reset();

}

void reset(){

	for(int i = 0;i<a.length;i++)
		a[i] = new Agent(random(width),random(height),0,i);
}


void draw(){

	background(0);


	for(int i = 0;i<a.length;i++)
		a[i].act();

	for(int i = 0;i<a.length;i++)
		a[i].apply();

}


class Agent{

	int id;
	float x,y,z;
	float radius = 120;//.0;
	float radius2 = 80.0;
	PVector move;
	boolean pN[],oN[];
	


	Agent(float _x,float _y,float _z,int _id){
		move = new PVector( 0,0,0 );
		x = _x;
		y = _y;
		z = _z;
		id = _id;
		oN = new boolean[a.length];
		pN = new boolean[a.length];
		//hmotnost = random(10,100.0);
	}

	void act(){

		radius2 = map(mouseY,0,height,3,radius);

		int p = 0;
		int o = 0;

		for(int i =0;i<a.length;i++){
			if(i!=id){
				
				pN[i] = false;
				oN[i] = false;
				if(dist(x,y,z,a[i].x,a[i].y,a[i].z)<radius2){
					
					pN[i] = true;
					p++;
					
				}
				
				if(dist(x,y,z,a[i].x,a[i].y,a[i].z)<radius){
					
					oN[i] = true;
					o++;
				}


			}
		}




		float len = radius2;
		PVector pritazl[] = new PVector[p];
		PVector odpuzl[] = new PVector[o];
		o = p = 0;
		for(int i = 0;i<a.length;i++){
			if(pN[i]){
				len = dist(a[i].x,a[i].y,a[i].z,x,y,z);
				pritazl[p] = new PVector(a[i].x-x,a[i].y-y,a[i].z-z);
				pritazl[p].normalize();
				pritazl[p].mult( sila * (radius-len)/radius/hmotnost );
				move.add(pritazl[p]);
				p++;
			}

			if(oN[i]){
				len = dist(a[i].x,a[i].y,a[i].z,x,y,z);
				odpuzl[o] = new PVector(x-a[i].x,y-a[i].y,z-a[i].z);
				odpuzl[o].normalize();
				odpuzl[o].mult( sila2 * (radius2-len)/radius2/hmotnost );
				move.add(odpuzl[o]);
				o++;
				
				//line(a[i].x,a[i].y,a[i].z,x,y,z);
			}
		}
	}

	void apply(){
		move.mult(prostredi);
		x += move.x;
		y += move.y;
		z += move.z;

		bordr();
		
		draw();

	}

	void draw(){


		noFill();
		stroke(255,40);

		pushMatrix();
		translate(x,y,z);
		box(2);

		popMatrix();


	}
	
	void bordr(){
	
	
		x=constrain(x,0,width);
		y=constrain(y,0,width);
		z=constrain(z,0,width);
	
	
	
	}






}
