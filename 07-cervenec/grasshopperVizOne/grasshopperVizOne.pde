/**
 * oscP5parsing by andreas schlegel
 * example shows how to parse incoming osc messages "by hand".
 * it is recommended to take a look at oscP5plug for an
 * alternative and more convenient way to parse messages.
 * oscP5 website at http://www.sojamo.de/oscP5
 */

import oscP5.*;
import netP5.*;

OscP5 oscP5;
NetAddress myRemoteLocation;

int id;
float x,y,z;

Pt[] a = new Pt[0];

void setup() {
	size(400,400,P3D);
	frameRate(25);
	/* start oscP5, listening for incoming messages at port 12000 */
	oscP5 = new OscP5(this,12000);

	/* myRemoteLocation is a NetAddress. a NetAddress takes 2 parameters,
	 * an ip address and a port number. myRemoteLocation is used as parameter in
	 * oscP5.send() when sending osc packets to another computer, device, 
	 * application. usage see below. for testing purposes the listening port
	 * and the port of the remote location address are the same, hence you will
	 * send messages back to this sketch.
	 */
	//myRemoteLocation = new NetAddress("127.0.0.1",12000);
}

void draw() {
	background(0);

	pushMatrix();
	translate(0,0,-mouseY*1000);
	
	for(int i =0;i<a.length;i++){
	if(a[i]!=null)
		a[i].act();
	}
	popMatrix();
}


void oscEvent(OscMessage theOscMessage) {
	/* check if theOscMessage has the address pattern we are looking for. */
	//println(theOscMessage.typetag());
	x = (float)theOscMessage.get(0).doubleValue();
	y = (float)theOscMessage.get(1).doubleValue();
	z = (float)theOscMessage.get(2).doubleValue();
	id = theOscMessage.get(3).intValue();
	int corp = theOscMessage.get(3).intValue();

	if(a.length>corp){
		a = new Pt[0];
	}

	if(existujeBod(id)){
		a[id].sedCoords(x,y,z);
	}else{
		a = (Pt[])expand(a,a.length+1);
		a[a.length-1] = new Pt(x,y,z,id);
	}
}

boolean existujeBod(int _id){
	boolean answr = false;
	int ids = _id;
	for(int i = 0;i<a.length;i++){
		if(a[i].id==ids){
			ids = a[i].id;
			answr = true;
		}
		
	}
	return answr;
}

class Pt{
	float x,y,z;
	int id;

	Pt(float _x,float _y,float _z,int _id){
		x = _x;
		y = _y;
		z = _z;
		id = _id;
	}

	void sedCoords(float _x,float _y,float _z){
		x=_x;
		y=_y;
		z=_z;
	}

	void act(){
		stroke(255);
		line(x-100,y,z,x+1000,y,z);
		line(x,y-100,z,x,y+100,z);
		line(x,y,z-100,x,y,z+100);
	}

}
