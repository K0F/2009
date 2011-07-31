

float x,y;
float count = 0;
float r = 80.0;

float step = 0.0133;

int len = 5000;

int rozestup = 402;

color c[] = {#ffffff,#ffffFF};

void setup(){
	size(800,400,P3D);
	background(0);


}


void draw(){

	noStroke();
	fill(0,15);
	rect(0,0,width,height);


	step = map(sin(frameCount/3000.0),-1,1,0.25,0.5);
	float speed = 200.01;
	rozestup = (int)map(mouseX,0,width,0,500);

	if(count>6500000)
		count = 0;

	for(int stereo = 0;stereo<=1;stereo++){
		stroke(c[stereo],70);
		for(int i = 0;i<len;i++){

			count += step;
			r = sin(i/speed)*80.0;

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
}
