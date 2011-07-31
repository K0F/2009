
PGraphics frame[];

void setup(){

	size(320,240,P3D);
	
	frame = new PGraphics[10];
	
	frameRate(24);
	
	for(int i = 0;i<frame.length;i++)
	frame[i] = generateFrame(0,random(240,255),random(34,40),2+random(200)/100.0);
	

}

void draw(){
	background(200);
	
	
	image(frame[(int)random(frame.length)],random(-5),random(-5));


}

PGraphics generateFrame(float _shade,float _al,float _wei,float _bl){
	PGraphics p;

	p = createGraphics(width+10,height+10,JAVA2D);
	p.beginDraw();
	p.stroke(_shade,_al);
	p.strokeWeight(_wei);
	p.noFill();
	p.rect(0,0,width+10,height+10);
	p.filter(BLUR,_bl);
	p.endDraw();

	
	return p;

}
