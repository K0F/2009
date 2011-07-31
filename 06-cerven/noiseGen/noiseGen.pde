/**noise gen
*/

Recorder r;
boolean rec = true;
int cntr = 0;

void setup(){

	size(720,576,OPENGL);
	background(0);
	loadPixels();
	noFill();
	noSmooth();

	r = new Recorder("out","noise.mp4");

}


void draw(){

	for(int x = 160;x<560;x+=1){

		for(int y = 88;y<488;y+=1){
			stroke(random(255));
			line(x,y,x+1,y);
		}
	}
	
	if(frameCount%25==0){
		cntr++;
		println(cntr);
		}

	if(rec){
		r.add();
	}
}

void keyPressed(){
	if(key=='q'){
		if(rec)
			r.finish();
		exit();
	}

}
