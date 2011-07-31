
// "the supreme code" by krystof pesek
// every single line of the text you are now reading;
// has been genereted by the text itself
// source language: processing - 5.1.2009

String code[];

void setup (){
	// load this code line by line
	code = loadStrings("supremeCode.pde");

	// prepare the frame
	size(320,code.length*9+20,P3D);

	// create the output
	beginRecord(PDF, "theWhatYouAreNowLookingAt.pdf");

	// create the font
	textFont(createFont("Veranda",9));
}

void draw(){
	// blank white background
	background(color(#FFFFFF));

	// loop through an every line of the source
	for(int i =0;i<code.length;i++){

		// gray out the comments line like this one
		if(code[i].indexOf("/")>-1&&code[i].indexOf("indexOf")==-1){
			fill(color(#666666));
		}else{
			fill(color(#000000));
		}

		// apply simple text formatting
		int format = code[i].lastIndexOf("\t");
		if(format>-1){
			for(int q = 0;q < format;q++)
				code[i]="   "+code[i];
		}

		// and print each line of itself
		text(code[i],15,i*9+10);
	}

	// save it
	endRecord();

	// and die
	exit();

	// "there is no need to understand anymore,
	// when you find out that you are the understanding itself"
}



