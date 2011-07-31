


PImage in;
PGraphics prep;
PGraphics result;
int W = 15;
int H = 12;
int rW = 360;
int rH = 288;
int matrix[];

void setup(){


	size(rW,rH);
	loadMatrix();

	println(matrix);

	in = loadImage("../noisePdf/out.png");

	prep = createGraphics(rW,rH,JAVA2D);
	prep.beginDraw();
	prep.image(in,0,0,rW,rH);
	prep.endDraw();

	process();



}

void process(){


	int aspect = rW/W;
	int area  =5;
	int pseudoImg[][] = new int[W][H];

	for(int y =0;y<rH;y+=aspect){
		for(int x =0;x<rW;x+=aspect){
			float soucet = brightness(prep.pixels[(y+3)*rW+(x+3)]);
			int count = 1;

			for(int yy = 0;yy<=area;yy++){
				for(int xx = 0;xx<=area;xx++){
					soucet += (brightness(prep.pixels[(y+yy+3)*rW+(x+xx+3)]));
					count ++;
				}
			}
			soucet /= (count+0.0);

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

	stroke(#FF0000);
	noFill();
	for(int y =0;y<rH;y+=aspect){
		for(int x =0;x<rW;x+=aspect){
fill(pseudoImg[x/aspect][y/aspect]);
			rect(x+3,y+3,area,area);

		}
	}

}


void loadMatrix(){
	String[] tmp = loadStrings("../noisePdf/data/matix"+W+"x"+H+".txt");
	matrix = new int[tmp.length];

	for(int y = 0;y<H;y++){
		for(int x = 0;x<W;x++){
			matrix[y*W+x] = parseInt(tmp[y*W+x]);
		}
	}

}
