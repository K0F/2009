import processing.pdf.*;
PImage store;
PGraphics resiz;

int matrix[];
int W = 360;
int H = 288;


void setup(){


	//store = loadImage("320x240.png");
	size(W,H,P3D);
	makeMatrix2();


	PImage store = loadImage("bratri.png");
	resiz = createGraphics(W,H,JAVA2D);
	resiz.beginDraw();
	resiz.image(store,0,0,W,H);
	resiz.noStroke();
	
	resiz.save("not.png");
	
	resiz.loadPixels();
	for(int y = 0;y<H;y++){
		for(int x = 0;x<W;x++){
			resiz.fill(resiz.pixels[matrix[y*W+x]]);
			resiz.rect(x,y,1,1);
		}
	}
	
	resiz.endDraw();


	resiz.save("out.png");
	
	/*
	store = loadImage("screen60x48.png");

	PGraphics pdf = createGraphics(width,height, PDF, "noise.pdf");
	pdf.beginDraw();
	pdf.background(255);
	pdf.fill(0);
	pdf.noStroke();
	for(int y = 0;y<pdf.height;y++){
		for(int x = 0;x<pdf.width;x++){
			pdf.fill(brightness(store.pixels[matrix[y*pdf.width+x]]));
			pdf.rect(x,y,1,1);
		}
}
	pdf.dispose();
	pdf.endDraw();
	*/

	/*
	loadPixels();
	store.loadPixels();
	for(int y = 0;y<height;y++){
		for(int x = 0;x<width;x++){
			pixels[matrix[y*width+x]] = store.pixels[y*width+x];
		}
}


	PGraphics pdf = createGraphics(width,height, PDF, "noise.pdf");
	pdf.beginDraw();
	pdf.background(255);
	pdf.fill(0);
	pdf.noStroke();
	for(int y = 0;y<pdf.height;y++){
		for(int x = 0;x<pdf.width;x++){
			pdf.fill(brightness(store.pixels[matrix[y*pdf.width+x]]));
			pdf.rect(x,y,1,1);
		}
}
	pdf.dispose();
	pdf.endDraw();
	save("screen.png");
	*/
	exit();



}

void loadMatrix(){
	String[] tmp = loadStrings("matix"+W+"x"+H+".txt");
	matrix = new int[tmp.length];

	for(int y = 0;y<height;y++){
		for(int x = 0;x<width;x++){
			matrix[y*width+x] = parseInt(tmp[y*width+x]);
		}
	}

}
void makeMatrix(){

	String[] newMatrix = new String[width*height];
	int g = 0;


	// Random rgen = new Random();  // Random number generator
	//int[] cards = new int[store.width*store.height];

	int[] novaMatice = new int[0];

	/*  for (int i=0; i<cards.length; i++) {
	    cards[i] = i;
	  }

	  --- Shuffle by exchanging each element randomly
	  for (int i=0; i<cards.length; i++) {
	    int randomPosition = rgen.nextInt(cards.length);
	    int temp = cards[i];
	    cards[i] = cards[randomPosition];
	    cards[randomPosition] = temp;
	  }*/

	for (int i=0; i<width*height; i++) {
		novaMatice = (int[])expand(novaMatice,novaMatice.length+1);

		int newRndm = (int)random(width*height);

		if(i>=width*height-10){
			novaMatice[novaMatice.length-1] = (int)random(5);

		}else{

			boolean isInList = false;
			for(int q = 0;q< novaMatice.length;q++){
				if(novaMatice[q]==newRndm)
					isInList = true;
			}

			if(isInList){
				while(isInList){
					newRndm = (int)random(width*height);

					isInList = false;
					for(int q = 0;q< novaMatice.length;q++){
						if(novaMatice[q]==newRndm)
							isInList = true;
					}
				}
			}

			novaMatice[novaMatice.length-1] = newRndm;
		}
		if(i%1000==0)
			println(i);

	}


	for (int i=0; i<width*height; i++) {
		newMatrix[i] = novaMatice[i]+"";
	}

	matrix = novaMatice;
	saveStrings("data/matix"+W+"x"+H+".txt",newMatrix);
	saveStrings("../translator/data/matix"+W+"x"+H+".txt",newMatrix);

}


void makeMatrix2(){

	Random rgen = new Random();
	int[] novaMatice = new int[W*H];
	matrix = new int[W*H];

	for (int i=0; i<novaMatice.length; i++) {
		novaMatice[i] = i;
	}

	//--- Shuffle by exchanging each element randomly
	for (int i=0; i<novaMatice.length; i++) {
		int randomPosition = rgen.nextInt(novaMatice.length);
		int temp = novaMatice[i];
		novaMatice[i] = novaMatice[randomPosition];
		novaMatice[randomPosition] = temp;
	}
	
	String newMatrix[] = new String[W*H];
	for(int i =0;i<newMatrix.length;i++){
		newMatrix[i] = novaMatice[i]+"";
		matrix[i] = novaMatice[i];
	}

	saveStrings("data/matix"+W+"x"+H+".txt",newMatrix);
	saveStrings("../translator/data/matix"+W+"x"+H+".txt",newMatrix);


}
