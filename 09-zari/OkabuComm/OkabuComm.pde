String path = "Okabu.txt";//"/mnt/lan/PESEK/PublicFolder/Okabu.txt";
String Input[] = new String[0];
String Output[];

BB[] bb = new BB[0];
int GLOB_ID = 0;

float Gcx,Gcy,Gcz;

int zoom = 100;

boolean debug = true;
boolean show = true;

float scalar = 0.1;

PVector camPos;

PMatrix3D cam2;
int R = 100;

void setup(){

	size(320,240,OPENGL);
	background(0);

	//println(PFont.list());

	textFont(createFont("Pixel Classic",8));
	fill(255);
	stroke(255);
	cam2 = new PMatrix3D();

	////////////////////////////////////////////////////////////
	addMouseWheelListener(new java.awt.event.MouseWheelListener() {
	                      public void mouseWheelMoved(java.awt.event.MouseWheelEvent evt) {
		                      int notches = evt.getWheelRotation();
		                      if(notches!=0){
			                      zoom+=(int)(notches*10);}}});
	////////////////////////////////////////////////////////////

}




void draw(){
	background(0);


	if(bb.length>0&&show){


		if((abs(pmouseX-mouseX)/100.0)<0.5&&(abs(pmouseY-mouseY)/100.0)<0.5){
			cam2.rotateX( (mouseY-pmouseY)/100.0 );
			cam2.rotateZ( (pmouseX-mouseX)/100.0 );
		}

		PVector x = cam2.mult(new PVector(1, 0, 0), new PVector(0, 0, 0));
		PVector y = cam2.mult(new PVector(0, 0, 1), new PVector(0, 0, 0));
		PVector d = x.cross(y); d.normalize(); d.mult(zoom);

		camera(d.x+Gcx, d.y+Gcy, d.z+Gcz,0+Gcx, 0+Gcy, 0+Gcz, 0, 0 ,1 );

		/*
		// camera !!
		camera(
		        //(sin(mouseX/(100.0))*zoom+Gcx) + (sin(mouseY/(100.0))*zoom) , (cos(mouseX/(100.0))*zoom+Gcy) + (cos(mouseY/(100.0))*zoom), sin(mouseY/(100.0))*zoom+Gcz,
		        camPos.x,camPos.y,camPos.z,
		        Gcx,Gcy,Gcz,
		        0.0,0.0,1.0);

		*/
		noFill();
		stroke(255,120);
		for(int i = 0;i<bb.length;i++)
			bb[i].draw();


		camera();

		//camPos = rotateAxis(camPos, new PVector(0,1,0), mouseX);


	}

	if(Input.length>0&&debug){
		fill(255,120);
		for(int i = 0;i<Input.length;i++)
			text(Input[i],10,i*9+10);

	}

}

void keyPressed(){

	if(key == ' '){
		loadInput();
	}else if(key =='d'){
		debug = !debug;
	}else if(key =='s'){
		show = !show;
	}

}

void loadInput(){

	Input = new String[0];
	Input = loadStrings(path);

	if(Input.length>0){

		resetBB();

		for(int i = 0;i<Input.length;i++){
			float parser[] = new float[7];
			String[] temp = splitTokens(Input[i]," ,");
			parser[0] = parseFloat(temp[0])*scalar;
			parser[1] = parseFloat(temp[1])*scalar;
			parser[2] = parseFloat(temp[2])*scalar;
			parser[3] = parseFloat(temp[3])*scalar;
			parser[4] = parseFloat(temp[4])*scalar;
			parser[5] = parseFloat(temp[5])*scalar;
			parser[6] = parseFloat(temp[6])*scalar;
			bb = (BB[])expand(bb,bb.length+1);
			bb[bb.length-1] = new BB(parser[0],parser[1],parser[2],parser[3],parser[4],parser[5],parser[6]);

		}

		float[] centers = getCenterOfObjects();
		Gcx = centers[0];
		Gcy = centers[1];
		Gcz = centers[2];

		camPos = new PVector(0,-10,0);

		println("Gcx = "+Gcx+",Gcy = "+Gcy+",Gcz = "+Gcz);

	}

	//println(Input);

}

void resetBB(){
	bb = new BB[0];
	GLOB_ID = 0;
}

float[] getCenterOfObjects(){

	float x,y,z;

	if(bb.length>0){
		x = bb[0].cx;
		y = bb[0].cy;
		z = bb[0].cz;

		for(int i = 1;i<bb.length;i++){
			x += bb[i].cx;
			y += bb[i].cy;
			z += bb[i].cz;
		}

		x /= (bb.length+0.0);
		y /= (bb.length+0.0);
		z /= (bb.length+0.0);

		return new float[]{x,y,z};
	}else{
		return null;
	}


}

class BB{
	float x,y,z,x2,y2,z2,cx,cy,cz;
	float val;
	int id;

	BB(float _x,float _y,float _z,float _x2,float _y2,float _z2,float _val){
		id = GLOB_ID;
		GLOB_ID ++;

		x = _x;
		y = _y;
		z = _z;
		x2 = _x2;
		y2 = _y2;
		z2 = _z2;
		val = _val;

		cx = (x+x2)/2.0;
		cy = (y+y2)/2.0;
		cz = (z+z2)/2.0;

		println(id+" comes alive!");

	}

	void draw(){

		pushMatrix();
		translate(cx,cy,cz);
		box(abs(x-x2),abs(y-y2),abs(z-z2));

		popMatrix();
	}




}

PVector rotateAxis(PVector v, PVector _axis,float ang)
{
	PVector axis=new PVector(_axis.x,_axis.y,_axis.z);
	PVector vnorm=new PVector(v.x,v.y,v.z);
	float _parallel= axis.dot(v);
	axis.mult(_parallel);
	PVector parallel= axis;
	parallel.sub(v);
	PVector perp= parallel;
	PVector Cross= v.cross(axis);
	Cross.mult(sin(-ang));
	perp.mult(cos(-ang));
	PVector result = new PVector(0,0,0);
	result.add(parallel);
	result.add(Cross);
	result.add(perp);
	return result;
}
