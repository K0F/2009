//import processing.opengl.*;

int num = 300;
float x[],y[], speed[], offset[];

void setup(){
	size(1280,720,P3D);
	background(255);

	x = new float[num];
	y = new float[num];
	speed = new float[num];
	offset = new float[num];

	for(int i =0;i<num;i++){
		offset[i] = 1.0;
		speed[i] = random(40.0,60.0);
		}

	noFill();
	stroke(0,1.5);//stroke(0,90);

	smooth();
}

void draw(){

	compute();

	//background(255);

	for(int i =0;i<num;i++){
		line(x[i],y[i],x[i]+sin(y[i]/100.0)*10.0,y[i]+cos(x[i]/100.0)*10.0);
		line(x[i],y[i],x[i]+5,y[i]);
	}
}

void compute(){
	
	for(int i =0;i<num;i++){
		x[i] = (cos(frameCount/(speed[i]+i))*width*180.0/(i+offset[i]))+width/2.0;
		y[i] = (sin(frameCount/(speed[i]+i))*width*180.0/(i+offset[i]))+width/2.0;
		offset[i]+=offset[i]/2000.0;
	}


}
