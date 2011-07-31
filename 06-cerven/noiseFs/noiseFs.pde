void setup(){


	size(1680,1050,OPENGL);

	background(0);

	loadPixels();

	for(int x = 0;x<width;x++){

		for(int y = 0;y<width;y++){
			stroke(random(255));
			line(x,y,x+1,y);

		}
	}


}



