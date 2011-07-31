Recorder r;
int num = 2;
Layer l[] = new Layer[num];


boolean rec = false;



void setup(){

	size(720,480,OPENGL);
	noSmooth();

	stroke(0);
	strokeWeight(3);

	for(int i = 0 ;i<num;i++){
		l[i] = new Layer( 10.5 , 12.5, 1.0, i );

	}

	strokeWeight(1.7);


	if(rec)
		r = new Recorder("out","moire5.mp4");
}


void draw(){
	pushStyle();
	fill(255);
	stroke(0);
	strokeWeight(10);
	rect(0,0,width,height);

	popStyle();

	for(int i =0;i<l.length;i++){
		l[i].act();
	}

	if(rec)
		r.add();


}

void keyPressed(){
	if(key == 'q'){
		if(rec)
			r.finish();

		exit();

	}

}



class Layer{

	float cx,cy;
	float x,y;
	float rozsek;

	float rot = 0;
	float sp;
	int id;

	Layer(float _down,float _up,float _sp,int _id){
		id = _id;
		cx= width/2;
		cy= height/2;
		x = random(width/2.0);//cos(frameCount/sp)*50+cx;
		y = height/2.0;//random(height);//sin(frameCount/sp)*50+cy;
		rozsek = random(_down,_up);

		sp = random(280.0,300.0);

	}

	void act(){
		if(frameCount>25)
			rot+=sp;

		if(id==0){
			x = mouseX;
			y = mouseY;
		}else{
			x+=(cx-x)/sp;
			y+=(cy-y)/sp;
		}

		noFill();


		for(float f = 0;f<width/2;f+=rozsek){
			ellipse(x,y,f,f);

		}


	}


}
