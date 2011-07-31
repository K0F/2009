
//make imports

import codeanticode.gsvideo.*;

//init cam instance

GSPipeline cam;
PGraphics result;

// some vars
int W = 360;
int H = 288;
int rW = 360;
int rH = 288;
//aspect ratio
String pomer = "500/403";
//matrixes for translation
int matrix[];
int korekce[];
//manipulation
int res = 1;
int bor = 5;

int aspect = 1;
int area  = 1;

int check = 0;

import codeanticode.gsvideo.*;



void init() {
	frame.removeNotify();

	frame.setUndecorated(true);

	// addNotify, here i am not sure if you have
	// to add notify again.
	frame.addNotify();
	super.init();
}

void setup(){

	//store = loadImage("screen.png");
	//a = new Deconstructor(store);
	size(rW,rH);
	//cam = new GSCapture(this,720,576,"v4lsrc");
	result = createGraphics(W,H,P2D);

	loadMatrix("matix"+W+"x"+H+".txt");
	// ! ffdeinterlace
	//cam = new GSPipeline(this,"v4l2src ! ffmpegcolorspace ! videoscale ! video/x-raw-rgb ,width = "+ W +",height = "+ H +", bpp=32, depth=24 ");

	/*
	cam = new GSPipeline(this,"v4l2src ! ffmpegcolorspace ! videoscale ! video/x-raw-rgb ,width = "+ W +",height = "+ H +", bpp=32, depth=24 "");
	*/

	cam = new GSPipeline(this,"dv1394src ! dvdemux ! ffdec_dvvideo ! queue ! ffmpegcolorspace ! aspectratiocrop aspect-ratio="+pomer+" ! ffvideoscale method=0 ! video/x-raw-rgb ,width = "+ rW +",height = "+ rH +", bpp=32, depth=24");
	/*
	cam = new GSPipeline(this,"dv1394src ! dvdemux ! ffdec_dvvideo !  ffmpegcolorspace ! video/x-raw-rgb ,width = "+ W +",height = "+ H +", bpp=32, depth=24 ");

	*/

	//tr = new Translator(10);
	frameRate(15);
	noStroke();
	stroke(255,25);
	noSmooth();
}


void loadMatrix(String _which){
	String[] tmp = loadStrings(_which);
	matrix = new int[tmp.length];

	for(int i =0;i<W*H;i++){
		matrix[i] = parseInt(tmp[i]);
	}

}


void draw(){
	//background(0);
	fill(0,25);
	rect(0,0,width,height);

	readCam();


	//stroke(random(255),random(255),random(255),60);
	//a.draw();
	//tr.draw();


}

void readCam(){
	if (cam.available() == true) {
		try{
			cam.read();


			if(check ==1){
				int pseudoImg[][] = new int[W+1][H+1];

				for(int y =0;y<rH;y+=aspect){
					for(int x =0;x<rW;x+=aspect){
						float soucet = brightness(cam.pixels[(y)*rW+(x)]);
						
						//sizing here
						/*
						int count = 1;

						for(int yy = 0;yy<=area;yy++){
							for(int xx = 0;xx<=area;xx++){
								soucet += (brightness(cam.pixels[(y+yy)*rW+(x+xx)]));
								count ++;
							}
						}
						soucet /= (count+0.0);
						*/

						pseudoImg[x/aspect][y/aspect] = (int)soucet;

					}
				}

				PGraphics pima = createGraphics(W,H,P2D);
				pima.beginDraw();
				for(int y =0;y<H;y++){
					for(int x =0;x<W;x++){
						pima.pixels[matrix[y*W+x]] = color(pseudoImg[x][y]);
					}
				}

				pima.endDraw();

				image(pima,0,0,width,height);


			}else if(check == 0){

				image(cam,0,0);

				/*stroke(#FF0000);
				noFill();
				for(int y =0;y<rH;y+=aspect){
					for(int x =0;x<rW;x+=aspect){
						
						rect(x+3,y+3,area,area);
					}
					}*/
			}
			/*result.beginDraw();
						int g = 0;

						for(int y =0;y<H;y+=res){
							for(int x =0;x<W;x+=res){

								for(int a =0;a<res;a++){
									for(int b =0;b<res;b++){
										int pix = cam.pixels[y*W+x];
										int pixCoded = cam.pixels[matrix[y*W+x]];
										
										if((x<bor||x>W-bor||y<bor||y>H-bor)&&check==0)
											result.pixels[(y+a)*W+(x+b)]=pix;
										else if(check == 0 || check == 1)
											result.pixels[(y+a)*W+(x+b)]=pixCoded;

										if(check==2)
											result.pixels[(y+a)*W+(x+b)]=pix;
										g++;
									}
								}
							}
						}
						result.endDraw();
			*/


		}catch(java.lang.NullPointerException e){
			println("weird error! @ "+frameCount);
		}
	}
}

void keyPressed(){
	if(key == ' '){
		check++;
		check = check%2;

	}if (keyCode == UP){
		res++;

	}else if(keyCode == DOWN){
		res --;
	}

	res = constrain(res,1,100);

}

