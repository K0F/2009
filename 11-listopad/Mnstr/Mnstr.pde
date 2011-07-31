
Monster m[];
int num = 12;

void setup(){
	size(320,240,P2D);
	background(#61684f);
	m = new Monster[num];

	for(int i =0;i<num;i++)
		m[i] = new Monster(i);

	stroke(#e9c40f,50);

}

void draw(){
	background(#464c3d);


	for(int i =0;i<num;i++)
		m[i].draw();


}

class Monster{

	float x,y,tx,ty;
	Chapadlo ch[];
	int nCh,id,timeToMove;
	float tempo;

	Monster(int _id){

		id = _id;
		tx = x = random(width);
		ty = y = random(height);

		timeToMove = (int)random(20,1600);
		
		nCh = (int)random(6,14);
		tempo = random(120,600);
		ch = new Chapadlo[nCh];

		for(int i =0;i<nCh;i++)
			ch[i] = new Chapadlo(i,(int)random(20,80),x,y,this);


	}

	void draw(){
		
		
		if(frameCount%timeToMove==0){
			if(random(50)>25){
			int rnd = (int)random(num);
		tx = m[rnd].x;
		
		ty = m[rnd].y;
			}else{
			tx = random(width);
			ty = random(height);
			
			}
		}

		x+=(tx-x)/30.0;
		y+=(ty-y)/30.0;
		
		for(int i =0;i<nCh;i++)
			ch[i].kresba();


	}

}

class Chapadlo{

	String dna = "";
	float x,y;
	float[] angles;
	int id,len;
	float angOne,angTwo,speed = 0,rot = 0;
	int MonsterId;
	Monster parent;
	float anomalie = 0;
	int anoId = 0;
	float step = 5;


	Chapadlo(int _id, int _len,float _x,float _y,Monster _parent){
		x = _x;
		y = _y;
		id = _id;
		len = _len;
		parent = _parent;
		init();

	}


	void init(){

		x = parent.x;
		y = parent.y;



		angOne = random(60);//random(9);
		angTwo = -random(60);//random(9)*-1;


		angles = new float[len];
		
		dna = "";
		for(int i =0;i<len;i++){
			if(random(50)>25){
				dna+="A";
				angles[i] = angOne;
			}else{
				dna+="B";
				angles[i] = angTwo;
			}
		}
		
		

	}

	void kresba(){

		//angOne-=0.1;
		//angTwo-=0.1;
/*
		if(random(500)<3){
			anomalie = random(100)/50.0;
			anoId = 0;
		}
		
		if(frameCount%3==0)
		anoId+=1;
		anoId = anoId%len;
		*/
		speed+=((dist(parent.x,parent.y,x,y)+1.0)-speed)/3.0;
		rot = (atan2(parent.ty-parent.y,parent.tx-parent.x)-HALF_PI);
		
		step = speed+0.1;
		
		x = parent.x;
		y = parent.y;
		
		pushMatrix();
		translate(x,y);
		rotate(rot);

		pushMatrix();
		for(int i = 0;i<len;i++){
			
			rotate(radians(angles[i])/(speed*2.0));
			angles[i]+=(random(-100,100)/100.0);
			line(0,0,0,-step);
			translate(0,-step);

		}
		popMatrix();



		popMatrix();

	}




}
