import codeanticode.gsvideo.*;

GSCapture cam;

GSMovieMaker mm;


boolean rec = true;

PImage zdroj;
PImage trace;

void setup(){
	
	size(640,480);


	cam = new GSCapture(this,640,480);
	background(0);
	
	mm = new GSMovieMaker(this,width,height,"out/out.avi",GSMovieMaker.X264,GSMovieMaker.BEST,25);
		mm.start();

}


void draw(){

	if (cam.available() == true) {
		try{
			cam.read();
		}catch(java.lang.NullPointerException e){
			println("weird error! @ "+frameCount);
		}

		if(cam!=null)
		
			cam.loadPixels();
			
			PImage tmp1 = createImage(cam.width,cam.height,RGB);
			
			for(int i =0;i<cam.pixels.length;i+=1)
			tmp1.pixels[i]=cam.pixels[i];
		
			//tmp1.filter(THRESHOLD,0.999);
			tmp1 = edgeDetect(tmp1,20);
			image(tmp1, 0, 0);
			
			
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


PImage edgeDetect(PImage in,float kolik){

	PImage cpy = createImage(in.width,in.height,RGB);
	in.loadPixels();

	for(int i = 0;i<in.pixels.length;i++)
		cpy.pixels[i] = in.pixels[i];

	PGraphics src = createGraphics(in.width,in.height,P2D);

	src.beginDraw();

	//in.filter(THRESHOLD,.4);
	//in.filter(INVERT);
	//src.image(in,0,0);

	src.background(255);


	cpy.filter(THRESHOLD,.55);
	//cpy.filter(BLUR,15.0);
	src.image(cpy,0,0);



	int coordX[] = {-1,0,1,1,1,0,-1,-1}; //,-2,-1,0,1,2,2,2,2,2,1,0,-1,-2,-2,-2,-2
	int coordY[] = {-1,-1,-1,0,1,1,1,0}; //,-2,-2,-2,-2,-2,-1,0,1,2,2,2,2,2,1,0,-1

	float neighs[] = new float[coordX.length];
	float sims[] = new float[coordX.length];

	for(int y =0;y<in.height;y++){
		for(int x =0;x<in.width;x++){

			for(int i =0;i<coordX.length;i++)
				neighs[i] = brightness(in.pixels[((y+in.height+coordX[i])%in.height)*in.width+((x+in.width+coordY[i])%in.width)]);

			for(int i =0;i<neighs.length;i++){
				sims[i] = abs( neighs[(i+1)%(coordX.length)] - neighs[i]);
				if(sims[i]>kolik){
					src.stroke(0,map(sims[i],kolik,30,0,170));
					src.point(x+coordX[i],y+coordY[i]);
				}
			}

		}
	}


	//src.tint(255,50);
	//in.filter(THRESHOLD,.3);
	src.endDraw();

	PImage out = createImage(src.width,src.height,RGB);
	//src.filter(THRESHOLD,0.5);



	src.loadPixels();

	for(int i = 0;i<src.pixels.length;i++)
		out.pixels[i] = src.pixels[i];

	return out;





}
