
import oscP5.*;
import netP5.*;
import processing.serial.*;
import cc.arduino.*;


String data;
String serialString;
String[] vals = new String[3];


boolean listen = true;
boolean emit = false;

int sel = 1;
float posX[],posY[],posZ[];


Arduino arduino;
OSC osc;
Cube cub;

void setup() {

	size(1000, 600,P3D);
	frameRate(25);
	//osc = new OSC("127.0.0.1",12000);
	//osc.send("on",1);

	data = "";

	textFont(createFont("Veranda",9));
	textMode(SCREEN);

	fill(255);
	stroke(0,100);

	println("pahse0");

	cub = new Cube();
	noCursor();
	smooth();
	println("pahse1");


	posX= new float[10];
	posY= new float[10];
	posZ= new float[10];

	println("pahse2");

	//	osc = new OSCm("127.0.0.1",12000);

	println("pahse3");

	println(Arduino.list());
	arduino = new Arduino(this, Arduino.list()[0], 57600);

	/* start oscP5, listening for incoming messages at port 12000 */






}

void draw() {
	background(0);
	if(listen){
		serialInput();
	}

	cub.draw(listen);


}

/*
void stop(){
	osc.osc.stop();
	super.stop();


}*/




void serialInput() {

	vals[0] =""+arduino.analogRead(0);
	vals[1] =""+arduino.analogRead(1);
	vals[2] =""+arduino.analogRead(2);

	//println(vals);

}



void writePos(int q){
	listen = true;
	posX[q] = cub.p.x;
	posY[q] = cub.p.y;
	posZ[q] = cub.p.z;
}

void jdi(int q){
	//if(posX[q]!=null){
	sel = q;
	listen = false;
	//}

}


void keyPressed(){
	if(key == 'q'){
		writePos(1);
	}else if (key=='1'){
		jdi(1);
	}else if(keyCode==BACKSPACE){
	osc = new OSC("127.0.0.1",12000);
	emit = true;
	
	}

}



class Cube{
	float x,y;
	String a;
	float speed = 0.01;
	Drawer p;
	Follower ff;
	float velikost = 300;

	Cube(){
		x=width/2.0;
		y=height/2.0;
		textFont(createFont("Veranda",9));
		textMode(SCREEN);

		p = new Drawer(data,0,0,0);
		ff = new Follower(100.0);
	}

	void draw(boolean driven){
		pushMatrix();
		translate(x,y);
		pushMatrix();

		rotateY(frameCount*speed);
		noFill();
		stroke(255,200);
		//box(velikost);
		p.draw(driven);
		ff.draw();
		popMatrix();
		popMatrix();
	}

}

class Follower{
	float x,y,z;
	float speed;
	float X[],Y[],Z[];
	float xx,yy,zz;
	int num = 4000;
	int cntr = 0;
	boolean first = true;


	Follower(float _speed){
		speed=_speed;
		X = new float[num];
		Y = new float[num];
		Z = new float[num];
	}

	void draw(){
		x+=(cub.p.x-x)/speed;
		y+=(cub.p.y-y)/speed;
		z+=(cub.p.z-z)/speed;


		pushMatrix();
		translate(x,y,z);
		noFill();
		box(4);


		popMatrix();
		for(int i  =1;i<num;i++){
			if(i!=cntr&&i!=cntr+1){
				stroke(#FFCC00,150);
				line(X[i],Y[i],Z[i],X[i-1],Y[i-1],Z[i-1]);
			}
		}
		if(first){
			for(int i =0;i<num;i++){

				X[i] = x;
				Y[i] = y;
				Z[i] = z;
				first = false;
			}
		}
		X[cntr] = x;
		Y[cntr] = y;
		Z[cntr] = z;
		if(farL(0.01))
			cntr++;
		cntr = cntr % num;
	}

	boolean farL(float tresh){
		boolean answ = false;
		if(dist(xx,yy,zz,x,y,z)>tresh){
			answ = true;

		}
		xx=x;
		yy=y;
		zz=z;

		return answ;
	}

}

class Drawer{
	int num = 4000;
	float X[],Y[],Z[];
	float xx,yy,zz;
	float x,y,z;
	String s;
	int cntr = 0;
	boolean first = true;

	Drawer(String content,float _x,float _y,float _z){
		x=_x;
		y=_y;
		z=_z;
		s = content+"";

		X = new float[num];
		Y = new float[num];
		Z = new float[num];

		for(int i =0;i<num;i++){
			X[i] = Y[i] = Z[i] = 0;
		}


	}

	void draw(boolean driven){
		if(driven){
			getCoord();
		}else{
			getSoftCoord();
		}
		fill(255);
		stroke(255,100);
		line(x+10,y-10,z,x,y,z);
		line(x+10,y-10,z,x+100,y-10,z);
		for(int i =1;i<num;i++){
			if(i!=cntr&&i!=cntr+1){
				stroke(255,60);
				/*

				map(X[i],-cub.velikost/2,cub.velikost/2,0,255),
				map(Y[i],-cub.velikost/2,cub.velikost/2,0,255),
				map(Z[i],-cub.velikost/2,cub.velikost/2,0,255),

				*/
				line(X[i],Y[i],Z[i],X[i-1],Y[i-1],Z[i-1]);
			}
		}
		text(s,(int)screenX(x+100,y-10,z),(int)screenY(x+100,y-10,z));

	}

	void getCoord(){
		s = vals[2]+" : "+vals[1]+" : "+vals[0];
		if(vals[0]!=null){
			if(first){
				for(int i =0;i<num;i++){
					X[i] = map(parseFloat(vals[1]),98,1024,-cub.velikost/2,cub.velikost/2);
					Y[i] = map(parseFloat(vals[0]),98,1024,cub.velikost/2,-cub.velikost/2);
					Z[i] = map(parseFloat(vals[2]),98,1024,cub.velikost/2,-cub.velikost/2);
					first=false;
				}
			}

			X[cntr] = map(parseFloat(vals[1]),98,1024,-cub.velikost/2,cub.velikost/2);
			Y[cntr] = map(parseFloat(vals[0]),98,1024,cub.velikost/2,-cub.velikost/2);
			Z[cntr] = map(parseFloat(vals[2]),98,1024,cub.velikost/2,-cub.velikost/2);
		}
		x=X[cntr];
		y=Y[cntr];
		z=Z[cntr];

		if(emit)
		osc.send(x,-y,-z);
		if(farL(1))
			cntr++;
		cntr = cntr % num;
	}


	void getSoftCoord(){
		s = x+" : "+y+" : "+z;
		X[cntr] += (posX[sel]-X[cntr])/10.0;
		Y[cntr] += (posY[sel]-Y[cntr])/10.0;
		Z[cntr] += (posZ[sel]-Z[cntr])/10.0;

		x=X[cntr];
		y=Y[cntr];
		z=Z[cntr];

		//osc.send(0,x,cub.velikost-y,cub.velikost-z);
		if(farL(1))
			cntr++;
		cntr = cntr % num;
	}

	boolean farL(int tresh){
		boolean answ = false;
		if(dist(xx,yy,zz,x,y,z)>tresh){
			answ = true;

		}
		xx=x;
		yy=y;
		zz=z;

		return answ;
	}

}

