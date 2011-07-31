
PGraphics pdf;

PImage result;
PFont a,b,c,d;
String word = "hello";
int sel = 0;

int counter = 0;
int multi = 100;

String[] input;
String slova[] = new String[0];

int alphas[] = {5,5,5,5};

void setup(){

	result = loadImage("JANA50-CELA-final.jpg");

	size(result.width,result.height,OPENGL);


	input = loadStrings("portugalsko50jana2.txt");

	for(int i =0;i<input.length;i++){
		String temp[] = splitTokens(input[i]," ,.!()");
		for(int q = 0;q<temp.length;q++){
			if(!temp[q].equals(" ")&&!temp[q].equals(":")){
				slova = (String[])expand(slova,slova.length+1);

				slova[slova.length-1] = temp[q]+"";}
		}

	}




	a = createFont("Veranda",12);
	b = createFont("Veranda",10);
	c = createFont("Veranda",12);
	d = createFont("Veranda",9);

	println("fonts initialized");

	pdf = createGraphics(width, height, PDF, "output.pdf");

	pdf.beginDraw();
	pdf.background(255);
	pdf.textAlign(CENTER);
	background(255);
	noStroke();
}



void draw(){

	//image(result,0,0);

	for(int i =0;i<multi;i++){
		int x, y;
		x= (int)random(width);
		y = (int)random(height);

		int which = y*result.width+x;
		which = constrain(which,0,result.pixels.length);


		if(brightness(result.pixels[which])<200){

			word = slova[(int)random(slova.length)];

			sel = (int)random(4);

			switch (sel){
			case 0:
				textFont(a);
				pdf.textFont(a);
				fill(result.pixels[which],alphas[0]);
				pdf.fill(result.pixels[which],alphas[0]);
				break;
			case 1:
				textFont(b);

				pdf.textFont(b);
				fill(result.pixels[which],alphas[1]);
				pdf.fill(result.pixels[which],alphas[1]);
				break;
			case 2:
				textFont(c);

				pdf.textFont(c);
				fill(result.pixels[which],alphas[2]);
				pdf.fill(result.pixels[which],alphas[2]);
				break;
			case 3:
				textFont(a);

				pdf.textFont(d);
				fill(result.pixels[which],alphas[3]);
				pdf.fill(result.pixels[which],alphas[3]);
				break;
			}


			text(word,x,y);

			//if(mousePressed)
			pdf.text(word,x,y);
			//counter ++;}

		}
	}


}

void keyPressed(){

	if(key=='q'){
		pdf.dispose();
		pdf.endDraw();
		exit();
	}

}
