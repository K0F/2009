

float boom = 9.333329;
float TRESH = 11.75;

float sigmoidal(float inputValue){

	//println((mouseX-width/2.0)+":"+(mouseY-height/2.0));
	return(float)((boom/((boom)+Math.exp(TRESH*(inputValue)))));

}

float derivative(float input){

	return(1.0-(sigmoidal(input)*(1.0-sigmoidal(input)))*2.0);
}


void setup(){
	size(255,255,OPENGL);
	

}


void draw(){
	background(255);
	
	TRESH = map(mouseY,height,0,0,30);
	boom = map(mouseX,0,width,-5,5);
	
	for(int i =0;i<width;i++){
		stroke(0);
		float y = sigmoidal(map(i,0,width,-1,1))*height;
		line(i,y,i,y+1);
		stroke(255,0,0);
		float _y = derivative(map(i,0,width,-1,1))*height;
		line(i,_y,i,_y+1);
	
	}
	
	stroke(0,40);
	line(0,height/2.0,width,height/2.0);
	line(width/2.0,0,width/2.0,height);


}

void mouseClicked(){
	println(TRESH+" : "+boom);


}
