import codeanticode.gsvideo.*;


GSMovieMaker mm;

boolean rec = false;

boolean disp = true;

float x,y;
float count = 0;
float r = 80.0;
float r2 = 80.0;

float step = 0.0133;

int len = 5000;

int rozestup = 350;

color c[] = {#ffffff,#ffffFF};

void setup(){
	size(720,400,P3D);
	background(0);
	
	frameRate(3);

	mm = new GSMovieMaker(this,width,height,"out/out.avi",GSMovieMaker.X264,GSMovieMaker.BEST,25);
	mm.start();
	
	textFont(createFont("Veranda",11));
	textMode(SCREEN);


}


void draw(){

	noStroke();
	fill(0,35);
	rect(0,0,width,height);


	step = map(sin(frameCount/3000.0),-1,1,0.25,0.5);
	float speed = 200.01;
	//rozestup = (int)map(mouseX,0,width,0,500);

	if(count>6500000)
		count = 0;

	if(disp){
		for(int stereo = 0;stereo<=1;stereo++){
			stroke(c[stereo],100);
			for(int i = 0;i<len;i++){

				count += step;
				r = sin(i/speed)*r2;

				x = width/2.0+cos(count)*r*2.0-(rozestup/2.0)+(rozestup*stereo);
				if(stereo==0){
					y = height/2.0+(sin(count)*r*2.0);
				}else{
					y = height/2.0-(sin(count)*r*2.0);
					//+step*3.333*stereo

				}

				point(x,y);

			}
		}
	}else{
		fill(255,30);
		textAlign(CENTER);
		
		text("try to skew until you can see three white crosses",width/2.0,height/2.0+5);
	pushStyle();
	stroke(255);
	strokeWeight(3);
	line(width/2.0-(rozestup/2.0)-10,height/2.0,width/2.0-(rozestup/2.0)+10,height/2.0);
	line(width/2.0-(rozestup/2.0),height/2.0-10,width/2.0-(rozestup/2.0),height/2.0+10);
	
	
	line(width/2.0+(rozestup/2.0)-10,height/2.0,width/2.0+(rozestup/2.0)+10,height/2.0);
	line(width/2.0+(rozestup/2.0),height/2.0-10,width/2.0+(rozestup/2.0),height/2.0+10);

	popStyle();
	
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

	}else if(key == 'a'){
		rec=!rec;

	}else if(key == 'd'){
		disp=!disp;
	}

}
