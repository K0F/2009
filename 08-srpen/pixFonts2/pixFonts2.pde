

PFont[] fonts = new PFont[12];

void setup(){

	size(800,600);


	//PFont font = ;
	//println(PFont.list());
	fill(255);
	



	for(int q = 0;q<100;q++){
		background(0);
		for(int i = 4;i<25;i++){
			textFont(createFont(PFont.list()[q],i));

			text(PFont.list()[q]+" abcd0128 " + (i)+ "px.",10,24*(i - 3));

		}
		
		save(PFont.list()[q]+".png");


	}

}
