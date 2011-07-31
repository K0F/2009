
float R = 65.0;
float G = 51.0;
float B = 47.5;

Recorder r;
boolean rec = true;
PImage pani;

PGraphics rr,gg,bb;

void setup(){
	size(416,320);
	frameRate(25);
	noStroke();
	background(0);
	fill(255);

	pani = loadImage("pani.png");
	rr = createGraphics(width,height,P3D);
	gg = createGraphics(width,height,P3D);
	bb = createGraphics(width,height,P3D);


	drawGrph2(rr,R,#ff0000);
	drawGrph2(gg,G,#00ff00);
	drawGrph2(bb,B,#0000ff);


	if(rec)
		r = new Recorder("out","color.mp4");
}



void draw(){

	background(0);
	
	if(frameCount<= 1500){
	
	drawGrph(rr,R,#ff0000);
	drawGrph(gg,G,#00ff00);
	drawGrph(bb,B,#0000ff);
	
		
	}else{
	
	drawGrph2(rr,R,#ff0000);
	drawGrph2(gg,G,#00ff00);
	drawGrph2(bb,B,#0000ff);

	}
	image(rr,0,0);
	blend(gg, 0, 0, width, height, 0, 0, width, height, ADD);
	blend(bb, 0, 0, width, height, 0, 0, width, height, ADD);

	if(rec&&frameCount >= 3000){
		r.finish();
		exit();
	}else if(rec){
		r.add();
	}

}

void drawGrph(PGraphics which,float speed,color c){
	which.beginDraw();
	which.background(0);
	which.noStroke();
	which.fill(c);
	which.ellipse(width/2,height/2+sin(frameCount/speed)*50.0,50,50);
	which.endDraw();

}

void drawGrph2(PGraphics which,float speed,color c){
	which.beginDraw();
	which.background(0);
	//which.noStroke();
	which.tint(c);
	which.image(pani,0,sin(frameCount/speed)*50.0);//ellipse(width/2,height/2+sin(frameCount/speed)*50.0,50,50);
	which.endDraw();

}

void keyPressed(){
	if(key=='q'){
		r.finish();
		exit();

	}

}
