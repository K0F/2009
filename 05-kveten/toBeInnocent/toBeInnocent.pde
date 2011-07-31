/*
The shining of friday afternoon


At the beginning there was a noise;
so deep as a complete silence

no matter, no space, no time
no observer, therefore nothing at all

nobody knows how it happend;
that noise produced first pattern
the pattern we called the life

that all happened without glory
it was just naural, just like that
as natural as we can understand

now I am cheering that noise, cheering the nature,
cheering everything out of my understanding
because that made us, and we made it like this

we are that patterns in the noise which is surrounding us,
which our minds are inhabitants of

we are just natural consequence
quite rare in our scale,
but nothing more or less

of course I know I am wrong
just a noise is always true

that is the think I repeat endlessly
nothing more I ever wish to say

kof
*/


float speed = 25*70.0;

Noda[] n = new Noda[0];
Recorder r;

boolean rec = false;
PImage vitruv,now;

void setup(){


	vitruv = loadImage("vitruvian_man.jpg");
	now = loadImage("now.png");
	
	size(vitruv.width,vitruv.height,OPENGL);
	background(0);


	for(int i =0;i<6;i++){
		for(int yy = 0;yy<width;yy+=1){

			for(int xx = 0;xx<width;xx+=1){
				if(brightness(vitruv.pixels[yy*width+xx])<128){
					n = (Noda[])expand(n,n.length+1);
					n[n.length-1] = new Noda(xx,yy,width);
				}

			}
		}
	}
	if(rec)
		r = new Recorder("vid","theShininOfAFridayAfternoon.mp4");

	noFill();
	stroke(255,50);

}


void draw(){

	background(0);



		for(int i = 0 ; i<n.length ; i++){

			n[i].act();
		}

	
	/*if(frameCount>speed&&frameCount<speed+2){
		println(frameCount);
		image(now,0,0);
		//exit();
	}*/


	if(rec)
		r.add();
	
	if(frameCount>speed*2){
		if(rec)
			r.finish();
		exit();
	}


}

void keyPressed(){

	if(key=='q'){
	if(rec)
		r.finish();
	exit();}
}


class Noda{

	float x,y;
	float X,Y;
	float tx,ty;
	float spread = 10.0;

	Noda(float _x,float _y,float _spread){

		X = x = _x;
		Y = y = _y;
		spread = _spread;
		tx = random( -spread , spread);
		ty = random( -spread , spread);


	}

	void act(){
		compute();
		draw();

	}

	void compute(){

		x = map(sin((frameCount-speed)/speed),-1,1,X-tx,X+tx);
		y = map(sin((frameCount-speed)/speed),-1,1,Y-ty,Y+ty);

	}

	void draw(){
		rect(x,y,1,1);
	}


}
