import hardcorepawn.fog.*;


int num = 60;
int vlak =  60;


fog myFog;
float nearDist = 0;
float farDist = 350;
color fogColor;


PImage texmap;
PGraphics earth;

Recorder r;
boolean rec = false;
int DUR = 2182;//2*60*25;

boolean drawEarth = false;
boolean drawEllipses = false;
boolean drawIds = false;
boolean drawLines = true;
boolean drawBox = false;
boolean glowing = true;

Vlakno v[];

void setup(){
	size(720,480,OPENGL);
	frameRate(25);

	myFog=new fog(this);

	myFog.setupFog(nearDist,farDist);
	fogColor=color(0,0,0);
	myFog.setColor(fogColor);


	v = new Vlakno[num];

	for(int i = 0;i<num;i++){
		v[i] = new Vlakno(i,vlak);

	}

	if(drawEarth){
		earth = createGraphics(width,height,P3D);
		texmap = loadImage("earthWhit.png");
		initializeSphere(sDetail);
	}
	//println(PFont.list());

	if(drawIds){
		textFont(createFont("Pixel",8));
	}

	r = new Recorder("earthOut","dratysolo.mp4");

	smooth();
	//textMode(SCREEN);

	background(0);

}


void draw(){
	background(0);

	//fill(0,5);
	//rect(0,0,width,height);



	if(drawEarth){
		earth.beginDraw();
		earth.background(0);
		rotationY = -(frameCount/3.0);
		noStroke();

		renderGlobe();

		//earth.myFog.doFog();
		earth.endDraw();
		//earth.filter(BLUR,2);
	}




	//tint(255,50);

	//image(earth,0,0);



	pushMatrix();
	translate(width/2,height/2);
	rotateY(radians(frameCount/3.0));

	noFill();
	//sphere(200);
	if(drawBox){
		noFill();
		box(width/2.0);
	}
	for(int i = 0;i<num;i++){
		v[i].compute();
		v[i].draw();//= new Vlakno(i,100);

	}
	//println(v[0].rx+" "+v[0].ry+" "+v[0].rz);



	popMatrix();


	myFog.doFog();


	if(glowing){
		for(int i = 0;i<num;i++){
			v[i].glow(v[i].rx,v[i].ry,map(v[i].rz,50,200,0,25),map(v[i].rz,50,200,0,70),6);

		}
	}

	//	glow(x[10],y[10],5.0,6);

	if(drawEarth)
		image(earth,0,0);
	//blend(earth, 0, 0, width, height, 0, 0, width, height, MULTIPLY);


	if(rec){
		r.add();
		if (frameCount>=DUR)
			exit();
	}


}

void keyPressed(){
	if(key == 'q'){
		if(rec)
			r.finish();
		exit();

	}


}

class Vlakno{
	float x[],y[],z[];
	float X,Y,Z,rx,ry,rz;
	int id,len;
	float radi = 100;
	int glowRef = 8;

	Vlakno(int _id,int _len){
		id =_id;
		len = _len;

		x = new float[len];
		y = new float[len];
		z = new float[len];

		x[0] = random(-20,20);
		y[0] = random(-20,20);
		z[0] = random(-20,20);
		for(int i = 1;i<len;i++){
			x[i] = x[0];
			y[i] = y[0];
			z[i] = z[0];
		}

	}


	void compute(){
		x[0] += random(-10,10);
		y[0] += random(-10,10);
		z[0] += random(-10,10);

		for(int i = 1;i<len;i++){
			x[i] += (x[i-1]-x[i])/3.0;
			y[i] += (y[i-1]-y[i])/3.0;
			z[i] += (z[i-1]-z[i])/3.0;
		}

		//interact();
		bordrs();
	}

	void interact(){



		for(int i = 0;i<v.length;i++){

			if(id!=i){
				float dd = dist(x[10],y[10],z[10],v[i].x[10],v[i].y[10],v[i].z[10]);
				//dd = constrain(dd,0.01,width*2);
				if(dd<radi/2.0){
					x[0]-=(v[i].x[0]-x[0])/300.0;
					y[0]-=(v[i].y[0]-y[0])/300.0;
					z[0]-=(v[i].z[0]-z[0])/300.0;

				}else if(dd<radi){
					x[0]+=(v[i].x[0]-x[0])/300.0;
					y[0]+=(v[i].y[0]-y[0])/300.0;
					z[0]+=(v[i].z[0]-z[0])/300.0;


				}

			}

		}

	}


	void draw(){

		X = screenX(x[10],y[10],z[10])-width/2.0;
		Y = screenY(x[10],y[10],z[10])-height/2.0;
		Z = map(z[10],-width,width,20,2);

		stroke(255,80);


		if(drawLines){
			rx = screenX(x[glowRef],y[glowRef],z[glowRef]);
			ry = screenY(x[glowRef],y[glowRef],z[glowRef]);
			rz = modelZ(x[glowRef],y[glowRef],z[glowRef]);

			for(int i = 10;i<len;i++){
				if(i==10)
					stroke(255,200);
				else
					stroke(255,80);

				//strokeWeight(map(i,0,len,1,5));
				line(x[i],y[i],z[i],x[i-1],y[i-1],z[i-1]);
			}

		}



	}

	void glow(float x,float y,float dia,float top,int steps){
		pushStyle();
		for(int i =0;i<steps;i++){
			noStroke();
			float tmp = map(i,0,steps,0,dia);
			fill(random(255),map(i,0,steps,top,0));
			ellipse(x,y,tmp,tmp);
		}
		popStyle();
	}

	void draw2(){

		pushStyle();
		if(drawEllipses){
			fill(255,50);
			noStroke();
			ellipse( X , Y , Z , Z );
		}
		if(drawIds){

			fill(255,120);
			text(id,(int)(X+width/2.0)-3,(int)(Y+height/2.0)+3);
		}
		popStyle();

	}

	void bordrs(){

		/*
		x[0] = constrain(x[0],-width/2.0,width/2.0);
		y[0] = constrain(y[0],-width/2.0,width/2.0);
		z[0] = constrain(z[0],-width/2.0,width/2.0);
		*/

		if(dist(x[0],y[0],z[0],0,0,0)>200){
			x[0]+=(0-x[0])/20.0;
			y[0]+=(0-y[0])/20.0;
			z[0]+=(0-z[0])/20.0;
		}


	}



}
