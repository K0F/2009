
Pnt [][][] pnt = new Pnt[5][30][5];
float siz = 30.0;
float X,Y,Z;
float rspeed = 150.0;
float zoom = 0;
float zoomS = 0;
float highS = 0;
float rotS;

void setup(){
	size(640,400,OPENGL);
	X = Y = Z = 0;


	//textFont(createFont(PFont.list()[0],8));
	//textMode(SCREEN);

	////////////////////////////////////////////////////////////
	addMouseWheelListener(new java.awt.event.MouseWheelListener() {
		                      public void mouseWheelMoved(java.awt.event.MouseWheelEvent evt) {
			                      int notches = evt.getWheelRotation();
			                      if(notches!=0){
				                      zoom+=notches*40;}}});
	////////////////////////////////////////////////////////////

	int g = 0;
	for(int i = 0;i<pnt.length;i++){
		for(int ii = 0;ii<pnt[i].length;ii++){
			for(int iii = 0;iii<pnt[i][ii].length;iii++){
				pnt[i][ii][iii] = new Pnt(g);
				g++;
			}
		}
	}

	stroke(255,60);
	noFill();
}


void draw(){


	background(0);


	zoomS += (zoom-zoomS)/20.0;
	highS += ( (map(mouseY,0,height,-1000,1000) )-highS)/10.0;
	rotS += (map(mouseX,0,width,360,-360)-rotS)/10.0;





	camera(
	        (pnt.length-1)*siz/2.0+cos(rotS/rspeed)*(200+zoomS), (pnt[0].length-1)*siz/2.0 + highS, (pnt[0][0].length-1)*siz/2.0+sin(rotS/rspeed)*(200+zoomS),
	        (pnt.length-1)*siz/2.0, (pnt[0].length-1)*siz/2.0, (pnt[0][0].length-1)*siz/2.0,
	        0, 1, 0);




	//pushMatrix();

	//translate(width/2-(pnt.length-1)*siz/2,height/2-(pnt[0].length-1)*siz/2,-mouseY);


	int g = 0;
	for(int i = 0;i<pnt.length;i++){
		for(int ii = 0;ii<pnt[i].length;ii++){
			for(int iii = 0;iii<pnt[i][ii].length;iii++){
				pnt[i][ii][iii].draw();
				g++;

			}
		}
	}

	

}


class Pnt{
	float w;
	int id;
	float x,y,z;
	float bx,by,bz;

	Pnt(int _id){
		id = _id;
		w = 1.0;// random(100)/100.0;

		bx = x = X;
		by = y = Y;
		bz = z = Z;

		X+=siz;

		if(X>=pnt.length*siz){
			X=0;
			Y+=siz;
		}

		if(Y>=pnt[0].length*siz){
			Y=0;
			Z+=siz;
		}
	}

	void draw(){
		w = (0.5*(sin(frameCount/(id+10.0))+1.0));
		x = bx + (((cos(frameCount/(id+10.0))+1.0)))*100.0;
		z = bz + (((sin(frameCount/(id+10.0))+1.0)))*100.0;
		
		pushMatrix();
		translate(x,y,z);
		line(-5,0,0,5,0,0);
		line(0,-5,0,0,5,0);
		line(0,0,-5,0,0,5);
		box(w*siz);
		popMatrix();
	}
	
	Pnt [] getNeighs(){
		Pnt[] tmp= new Pnt[0];
		
		//int[] matix = new int[26];
		//matix[0] = pnt[];
		
		return tmp;
	
	
	
	}
}
