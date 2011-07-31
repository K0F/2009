import codeanticode.gsvideo.*;
GSMovieMaker mm;
boolean rec = true;


PImage kriz[] = new PImage[9];
int next = 5,current = 0;

void setup(){


	for(int i =0;i<kriz.length;i++){
		kriz[i] = loadImage(i+"b.png");
	}

	size(kriz[0].width,kriz[0].height,OPENGL);
	frameRate(3);
	/*
	for(int i =0;i<kriz.length;i++){
		PImage temp = loadImage(i+".jpg");
		PGraphics pt = createGraphics(temp.width/3,temp.height/3,P2D);
		pt.beginDraw();
		pt.image(temp,0,0,pt.width,pt.height);
		pt.endDraw();
		
		pt.save(i+"b.png");
}*/
	println("loaded!");
	
	mm = new GSMovieMaker(this,width,height,"out/out.avi",GSMovieMaker.X264,GSMovieMaker.BEST,25);
	mm.start();
}

void draw(){

	image(kriz[current],0,0);

	if(frameCount%next==0){
		current = (int)random(kriz.length);
		next = (int)random(1,25);

	}
	
	if(rec){
		loadPixels();
		mm.addFrame(pixels);
	}

}

void keyPressed(){
	if(key == 'q'){

		if(rec){
			mm.finish();
		}
		mm.dispose();
		exit();
	}
}

