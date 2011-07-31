import megamu.mesh.*;

int num = 5000;

float thick = 0.2;
float sp = 1.31;


boolean mesh=false;
boolean voron=true;

Voronoi voronoi;
Site[] s;
float[][] points = new float[num][3];
float[][] myEdges;


MPolygon[] regions;

void setup(){
	size(1200,800,P3D);
	frameRate(5);
	//	smooth();
	/*
	xx= new float[num];
	yy= new float[num];
		
	tx= new float[num];
	ty= new float[num];
	lx= new float[num];
	ly= new float[num];

	cnt = new int[num];
	*/

	reset();
}

void draw(){
	background(0);

	//refresh();
	//update = false;

	if(voron){
		//beginShape();

		for(int i=0; i<myEdges.length; i++){
			// an array of points
			//noStroke();
			stroke(255);
			//fill(s[i].c);
			line(myEdges[i][0],myEdges[i][1],myEdges[i][2],myEdges[i][3]);
			//vertex(myEdges[i][2],myEdges[i][3]);



		}

		//endShape();
	}




	if(mesh){
		if(!voron){
			stroke(255,155);
		}else{
			stroke(0,155);
		}

		for(int i=0; i<myEdges.length; i++)
		{
			float startX = myEdges[i][0];
			float startY = myEdges[i][1];
			float endX = myEdges[i][2];
			float endY = myEdges[i][3];
			line( startX, startY, endX, endY );
		}
	}

	for(int i =0;i<num;i++){
		s[i].live();
	}

}

void reset(){
	s = new Site[num];
	//smooth();

	float X = 0;
	float Y = 0;
	for(int i =0;i<num;i++){
		s[i] = new Site(i);

		X+=random(20,30);
		if(X>width){
			X=0;
			Y+=20;
		}


		points[i][0] = s[i].x;
		points[i][1] = s[i].y;
		points[i][2] = s[i].z;
		/*
		lx[i]=tx[i]=xx[i] = s[i].x;
		ly[i]=ty[i]=yy[i] = s[i].y;
		cnt[i] = 0;
		*/
	}

	voronoi = new Voronoi( points );
	myEdges = voronoi.getEdges();
}

void refresh(){

	try{
		if(voron){
			voronoi = new Voronoi( points );
			//regions = voronoi.getRegions();
			myEdges = voronoi.getEdges();
		}

		if(mesh){
			Delaunay myDelaunay = new Delaunay( points );
			myEdges = myDelaunay.getEdges();
		}
	}catch( ArrayIndexOutOfBoundsException e){
		println("pruser!!! "+e);
		reset();
	}

}

void keyPressed(){
	if(key==' '){
		loop();
	}

}

class Site{
	float x,y,z;
	float tx,ty,tz;
	int id = 0;
	int cyc = 4;
	color c;

	float brdr = 50.0;


	float speed = 120.0;
	float trsh = 20.0;

	Site(int _id){
		id=_id;
		tx = x = random(brdr,width-brdr);
		ty = y = random(brdr,height-brdr);
		tz = z = random(brdr,height-brdr);

		c = color(random(120,255));
		//	speed = random(50,125);
	}

	Site(int _id,float _x,float _y,float _z){
		c = color(random(120,255));
		id=_id;
		tx = x = _x;
		ty = y = _y;
		tz = z = _z;
	}

	void live(){

		//move();
		//bordr(brdr);

		points[id][0] = x;
		points[id][1] = y;
		points[id][2] = z;

		draw();
	}

	void move(){
		for(int i =0;i<s.length;i++){
			if(i!=id){
				float d = dist(s[i].x,s[i].y,x,y);
				d = constrain(d,1.001,width);

				//c = lerpColor(#FFFFFF,#FFCC00,map(d,trsh*2,0,0,1));
				tx+=(s[i].x-tx)/(d*4.0);
				ty+=(s[i].y-ty)/(d*4.0);

				if(d<trsh){
					tx-=(s[i].x-tx)/(d);
					ty-=(s[i].y-ty)/(d);
				}

			}

		}

		//	tx = constrain(tx,x-10,x+10);
		//		ty = constrain(ty,y-10,y+10);

		x+=(tx-x)/speed;
		y+=(ty-y)/speed;

	}

	void bordr(float k){
		x = constrain(x,k,width-k);
		y = constrain(y,k,height-k);

	}

	void draw(){
		fill(0,150);
		noStroke();
		rect(x-1.5,y-1.5,2,2);
	}


}

/*
	myVoronoi = new Voronoi( points );
	
	float[][] myEdges = myVoronoi.getEdges();

for(int i=0; i<myEdges.length; i++)
{
	float startX = myEdges[i][0];
	float startY = myEdges[i][1];
	float endX = myEdges[i][2];
	float endY = myEdges[i][3];
	line( startX, startY, endX, endY );
}

	myRegions = myVoronoi.getRegions();

	for(int i=0; i<myRegions.length; i++){
		// an array of points
		float[][] regionCoordinates = myRegions[i].getCoords();

		fill(255,0,0,50);
		myRegions[i].draw(this); // draw this shape
	}
*/


