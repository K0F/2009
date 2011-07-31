
Hero hero;


void setup(){
	size(200,200,OPENGL);

	hero = new Hero();
	noSmooth();


}


void draw(){

	background(0);

	hero.render();



}

void mousePressed(){

	hero.reload();
}

void keyPressed(){
	if(key=='w'){
		hero.control = 0;
	}else if(key=='2'){
		hero.control = 1;
	}else if(key=='a'){
		hero.control = 2;
	}else if(key=='z'){
		hero.control = 3;
	}else if(key=='d'){
		hero.control = 4;
	}else if(key=='c'){
		hero.control = 5;
	}else if(key=='q'){
		hero.control = 8;
	}else if(keyCode==TAB){
		hero.control = 9;
	}else if(key=='e'){
		hero.control = 10;
	}else if(key=='r'){
		hero.control = 11;
	}

}



class Hero{
	PImage mapa;
	int maska[];
	int anchors[][] = {{4,10},{5,7},

	                   {2,1},{1,0},{2,1},{1,0},
	                   {1,0},{1,0},

	                   {4,2},{1,1},{2,2},{1,1}
	                  };

	int positions[][] = {{0,0},{6,-3},

	                     {-1,4},{0,7},{4,4},{0,7},
	                     {2,6},{1,6},

	                     {1,-4},{-1,6},{7,-4},{1,6}

	                    };

	float rotation[] = new float[12];

	float limits[][] = {
	                           {-180,180},{-46.8,36.77},

	                           {138.0,-25.0},{5.2,-113.0},{138.0,-25.0},{5.2,-113.0},
	                           {-34.0,59.0},{-34.0,59.0},

	                           {178.0,-39.0},{158.0,-1.0},{169.0,-115.0},{133.0,-10.0}

	                   };

	PGraphics part[] = new PGraphics[12];

	String marks[] = new String[0];

	int x,y;
	int control = 0;

	Hero(){
		x = width/2;
		y= height/2;
		reload();

	}

	void fillGraphics(){




		for(int i = 0;i<part.length;i++){
			String temp[] = splitTokens(marks[i],",");
			int x = -(parseInt(temp[0])+2);
			int y = -(parseInt(temp[1])+2);
			part[i].beginDraw();
			part[i].image(mapa,x,y);
			part[i].endDraw();
		}

	}

	void reload(){

		mapa = loadImage("figurka.png");
		maska = new int[mapa.pixels.length];

		marks = new String[0];
		for(int y =0;y<mapa.height;y++){
			for(int x =0;x<mapa.width;x++){
				int which = y*mapa.width+x;
				if(brightness(mapa.pixels[which])==0){
					maska[which] = 0;
				}else if(brightness(mapa.pixels[which])>254){
					marks = (String[])expand(marks,marks.length+1);
					marks[marks.length-1] = ""+x+","+y;
				}else{
					maska[which] = 255;
				}
			}
		}

		mapa.mask(maska);

		println(marks.length);

		//hlava
		part[0] = createGraphics(8,16,JAVA2D);

		//trup
		part[1] = createGraphics(9,9,JAVA2D);


		//nohaL1
		part[2]= createGraphics(4,8,JAVA2D);
		//nohaL2
		part[3]= createGraphics(4,7,JAVA2D);

		//nohaR1
		part[4]= createGraphics(4,8,JAVA2D);
		//nohaR2
		part[5]= createGraphics(4,7,JAVA2D);

		//botaL
		part[6]= createGraphics(4,4,JAVA2D);
		//botaR
		part[7]= createGraphics(4,4,JAVA2D);

		//rukaL1
		part[8] = createGraphics(5,9,JAVA2D);
		//rukaL2
		part[9] = createGraphics(3,11,JAVA2D);

		//rukaR1
		part[10] = createGraphics(5,9,JAVA2D);
		//rukaR2
		part[11]= createGraphics(3,11,JAVA2D);


		fillGraphics();

		for(int i =0;i<rotation.length;i++){
			rotation[i] = 0;//random(-30,30);

		}

	}


	void partRotate(int i,float kolik){

		rotation[i] += (map(mouseX,0,width,limits[i][0],limits[i][1])-rotation[i])/10.0;

	}

	void render(){

		partRotate(control,200.0);



		//level0 poziceGlob
		pushMatrix();
		translate(x,y);


		//level1 trup
		pushMatrix();
		translate(positions[0][0],positions[0][1]);
		pushMatrix();

		translate(-anchors[0][0],-anchors[0][1]);
		rotate(radians(rotation[0]));

		//LEVA RUKA
		//level 2 rukaL1
		pushMatrix();
		translate(positions[8][0],positions[8][1]);
		pushMatrix();
		translate(-anchors[8][0],-anchors[8][1]);
		rotate(radians(rotation[8]));
		image(part[8],-anchors[8][0],-anchors[8][1]);

		//level 3 rukaL2
		pushMatrix();
		translate(positions[9][0],positions[9][1]);
		pushMatrix();
		translate(-anchors[9][0],-anchors[9][1]);
		rotate(radians(rotation[9]));
		image(part[9],-anchors[9][0],-anchors[9][1]);



		popMatrix();
		popMatrix();
		//level 3 rukaL2 end
		popMatrix();
		popMatrix();
		//level 2 rukaL1 end

		//trup image
		image(part[0],-anchors[0][0],-anchors[0][1]);


		//LEVA NOHA
		//level 2 hohaL1
		pushMatrix();
		translate(positions[2][0],positions[2][1]);
		pushMatrix();
		translate(-anchors[2][0],-anchors[2][1]);
		rotate(radians(rotation[2]));
		image(part[2],-anchors[2][0],-anchors[2][1]);
		//level 3 hohaL2
		pushMatrix();
		translate(positions[3][0],positions[3][1]);
		pushMatrix();
		translate(-anchors[3][0],-anchors[3][1]);
		rotate(radians(rotation[3]));
		//level 4 botaL
		pushMatrix();
		translate(positions[6][0],positions[6][1]);
		pushMatrix();
		translate(-anchors[6][0],-anchors[6][1]);
		rotate(radians(rotation[6]));
		image(part[6],-anchors[6][0],-anchors[6][1]);
		popMatrix();
		popMatrix();
		//level 4 botaL end
		image(part[3],-anchors[3][0],-anchors[3][1]);
		popMatrix();
		popMatrix();
		//level 3 hohaL2 end
		popMatrix();
		popMatrix();
		//level 2 hohaL1 end


		//PRAVA NOHA
		//level 2 hohaR1
		pushMatrix();
		translate(positions[4][0],positions[4][1]);
		pushMatrix();
		translate(-anchors[4][0],-anchors[4][1]);
		rotate(radians(rotation[4]));
		image(part[4],-anchors[4][0],-anchors[4][1]);
		//level 3 hohaR2
		pushMatrix();
		translate(positions[5][0],positions[5][1]);
		pushMatrix();
		translate(-anchors[5][0],-anchors[5][1]);
		rotate(radians(rotation[5]));
		//level 4 botaR
		pushMatrix();
		translate(positions[7][0],positions[7][1]);
		pushMatrix();
		translate(-anchors[7][0],-anchors[7][1]);
		rotate(radians(rotation[7]));
		image(part[7],-anchors[7][0],-anchors[7][1]);
		popMatrix();
		popMatrix();
		//level 4 botaR end
		image(part[5],-anchors[5][0],-anchors[5][1]);
		popMatrix();
		popMatrix();
		//level 3 hohaR2 end
		popMatrix();
		popMatrix();
		//level 2 hohaR1 end









		//HLAVA
		//level2 hlava
		pushMatrix();
		translate(positions[1][0],positions[1][1]);
		pushMatrix();
		translate(-anchors[1][0],-anchors[1][1]);
		rotate(radians(rotation[1]));
		image(part[1],-anchors[1][0],-anchors[1][1]);
		popMatrix();
		popMatrix();
		//level 2 hlava end

		//PRAVA RUKA
		//level 2 rukaR1
		pushMatrix();
		translate(positions[10][0],positions[10][1]);
		pushMatrix();
		translate(-anchors[10][0],-anchors[10][1]);
		rotate(radians(rotation[10]));
		image(part[10],-anchors[10][0],-anchors[10][1]);

		//level 3 rukaR2
		pushMatrix();
		translate(positions[11][0],positions[11][1]);
		pushMatrix();
		translate(-anchors[11][0],-anchors[11][1]);
		rotate(radians(rotation[11]));
		image(part[11],-anchors[11][0],-anchors[11][1]);

		popMatrix();
		popMatrix();
		//level 3 rukaR2 end
		popMatrix();
		popMatrix();
		//level 2 rukaR1 end

		popMatrix();
		popMatrix();
		//level1 trup end

		popMatrix();
		//level0 glob end

	}





}
