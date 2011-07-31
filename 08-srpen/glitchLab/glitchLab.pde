// to run command:
// rm out.txt && pp 2> out.txt

PImage a,b;
Recorder r;
byte[] data;
boolean rec = false;
PGraphics ram;
String txt[];
PGraphics ou;
void setup()
{
	a = loadImage("bratri2.jpg");
	//a.save("data/bratriMod.jpg");
	//b = loadImage("bratriMod.jpg");
	txt = loadStrings("out.txt");

	size(a.width,a.height,OPENGL);
	r = new Recorder("out","glitch3.mp4");
	background(0);
	//data=loadBytes("bratri2.jpg");
	
	image(a,0,0);

	textFont(createFont(PFont.list()[0],8));
	textAlign(RIGHT);

	ou = createGraphics(width,height,JAVA2D);
	ram = createGraphics(width,height,P2D);
	
	kurv();
	
	ram.beginDraw();
	ram.noFill();
	ram.stroke(0,150);
	ram.strokeWeight(10);
	ram.rect(0,0,width,height);
	ram.endDraw();
	ram.filter(BLUR,2.5);
}


void draw(){
	kurv();

	noTint();
	image(ou,0,0);

	fill(255,120);
	
	for(int i = 0;i<txt.length;i++){
		int pos = txt.length*6;
		if(pos>height-10)
			text(txt[i],width-10,i*6-pos+height-10);
		else
			text(txt[i],width-10,i*6);

	}

	noTint();
	image(ram,0,0);

	if(rec)
		r.add();


}

void keyPressed(){
	if(key=='q'){
		if(rec)
			r.finish();
		exit();
	}else if(key=='r'){
		rec=true;
	}
	keyPressed = false;
}

void kurv(){
	data =loadBytes("bratri2.jpg");
	for(int i=0;i<4;i++) // 100 changes
	{
		int loc=(int)random(256,data.length);//(int)constrain(map(mouseY*width+mouseX,0,height*width+width,1024,data.length),1024,data.length);//(int)random(1024,data.length);//guess at header being 128 bytes at most..
		data[loc]+=(byte)((byte)random(120,125)-data[loc])/20.0;
	}
	saveBytes("data/bratriMod.jpg",data);
	b = loadImage("bratriMod.jpg");
	txt = loadStrings("out.txt");
	
	ou.beginDraw();
	if(frameCount%25==0){
		ou.noTint();
	}else{
		ou.tint(random(128,255),random(128,255),12,100);
	}

	ou.image(b,0,random(-10,10));
	ou.endDraw();


}



