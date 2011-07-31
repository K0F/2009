import processing.opengl.*;


Recorder r;
Modul m[] = new Modul[3];


boolean rec = false;

void setup(){
	size(720,576,OPENGL);
	for(int i =0 ; i< m.length;i++){

		m[i] = new Modul(map(i,0,m.length-1,100,width-100),height/3.0*2.0+random(-100,100),i);
	}

	textFont(createFont("Vernda",9));
	//textMode(SCREEN);

	stroke(255,15);
	fill(255,95);

	smooth();

	if(rec)
		r = new Recorder("out","dance.mp4");


}


void draw(){

	background(0);

	for(int i =0 ; i< m.length;i++){
		m[i].live();
		
		pushStyle();
		
		stroke(255,255-dist(m[i].x,m[i].y,mouseX,mouseY)/3.0);
			line(m[i].x,m[i].y,m[i].x,height);
			
		
		popStyle();
	}


	if(rec)
		r.add();



}

void keyPressed(){
	if(key=='q'){
		if(rec)
			r.finish();

		exit();

	}

}


