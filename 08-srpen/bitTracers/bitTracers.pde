PImage zdroj;
PImage trace;

void setup(){
	zdroj = loadImage("sample.jpg");
	//zdroj.filter(THRESHOLD,0.4);
	size(zdroj.width,zdroj.height,P2D);

	trace = edgeDetect(zdroj,3.0);




}


void draw(){
	
	image(trace,0,0);


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
	
	
	cpy.filter(THRESHOLD,.25);
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
	src.filter(THRESHOLD,0.5);
	
	
	
	src.loadPixels();
	
	for(int i = 0;i<src.pixels.length;i++)
		out.pixels[i] = src.pixels[i];
	
	return out;





}
