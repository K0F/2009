import traer.physics.*;


ParticleSystem physics;

boolean testing = false;

Particle truP[] = new Particle[7];
Spring truS[]  = new Spring[12];

Particle nohaL1P;
Spring nohaL1S[] = new Spring[2];

Particle nohaL2P;
Spring nohaL2S[] = new Spring[1];

Particle nohaR1P;
Spring nohaR1S[] = new Spring[2];

Particle nohaR2P;
Spring nohaR2S[] = new Spring[1];


Particle rukaL1P;
Spring rukaL1S[] = new Spring[1];

Particle rukaL2P;
Spring rukaL2S[] = new Spring[1];

Particle rukaR1P;
Spring rukaR1S[] = new Spring[1];

Particle rukaR2P;
Spring rukaR2S[] = new Spring[1];



Particle hlavaP;
Spring hlavaS[] = new Spring[2];

Particle anchor;
Spring spagat;

float ruceSila = 3.0;
float ruceDamp = 0.05;

float nohySila = 3.0;
float nohyDamp = 0.1;


float hlavaSila = 3.0;
float hlavaDamp = 0.1;

Hero hero;
World world;

void setup(){
	size(320,240,OPENGL);

	hero = new Hero();
	noSmooth();

	frameRate(30);

	physics = new ParticleSystem( 0.5, 0.01 );


	// torso
	truP[0] = physics.makeParticle( hero.mass[0], hero.x-7, hero.y-16, 0.0 );
	truP[1] = physics.makeParticle( hero.mass[0], hero.x-7, hero.y-20, 0.0 );
	truP[2] = physics.makeParticle( hero.mass[0], hero.x-1, hero.y-20, 0.0 );
	truP[3] = physics.makeParticle( hero.mass[0], hero.x-1, hero.y-16, 0.0 );
	truP[4] = physics.makeParticle( hero.mass[0], hero.x,hero.y-9, 0.0 );
	truP[5] = physics.makeParticle( hero.mass[0], hero.x-4,hero.y-4, 0.0 );
	truP[6] = physics.makeParticle( hero.mass[0], hero.x-8,hero.y-9, 0.0 );

	truS[0] = physics.makeSpring(truP[0], truP[1],1,1,1);
	truS[1] = physics.makeSpring(truP[1], truP[2],1,1,1);
	truS[2] = physics.makeSpring(truP[2], truP[3],1,1,1);
	truS[3] = physics.makeSpring(truP[3], truP[4],1,1,1);
	truS[4] = physics.makeSpring(truP[4], truP[5],1,1,1);
	truS[5] = physics.makeSpring(truP[5], truP[6],1,1,1);
	truS[6] = physics.makeSpring(truP[6], truP[0],1,1,1);
	truS[7] = physics.makeSpring(truP[5], truP[0],1,1,1);
	truS[8] = physics.makeSpring(truP[5], truP[1],1,1,1);
	truS[9] = physics.makeSpring(truP[5], truP[2],1,1,1);
	truS[10] = physics.makeSpring(truP[5], truP[3],1,1,1);
	truS[11] = physics.makeSpring(truP[0], truP[3],1,1,1);

	for(int i =0;i<truS.length;i++){
		truS[i].setRestLength( truS[i].currentLength() );
		truS[i].setStrength( 14.0);
		truS[i].setDamping( 0.0001 );

	}



	////
	hlavaP = physics.makeParticle( hero.mass[1], hero.x-4, hero.y-28, 0 );

	hlavaS[0] = physics.makeSpring( truP[1], hlavaP, 1,1,1 );
	hlavaS[1] = physics.makeSpring( truP[2], hlavaP, 1,1,1 );

	for(int i =0;i<hlavaS.length;i++){
		hlavaS[i].setRestLength( hlavaS[i].currentLength() );
		hlavaS[i].setStrength( hlavaSila);
		hlavaS[i].setDamping( hlavaDamp );

	}

	////
	nohaL1P = physics.makeParticle( hero.mass[2], hero.x-9, hero.y-2, 0 );

	nohaL1S[0] = physics.makeSpring( truP[5], nohaL1P, 1,1,1 );
	nohaL1S[1] = physics.makeSpring( truP[6], nohaL1P, 1,1,1 );

	for(int i =0;i<nohaL1S.length;i++){
		nohaL1S[i].setRestLength( nohaL1S[i].currentLength() );
		nohaL1S[i].setStrength( nohySila);
		nohaL1S[i].setDamping( nohyDamp );

	}

	//////
	nohaL2P = physics.makeParticle( hero.mass[3], hero.x-9, hero.y+2, 0 );

	//nohaL2S[0] = physics.makeSpring( truP[5], nohaL2P, 1,1,1 );
	nohaL2S[0] = physics.makeSpring( nohaL1P, nohaL2P, 1,1,1 );

	for(int i =0;i<nohaL2S.length;i++){
		nohaL2S[i].setRestLength( nohaL2S[i].currentLength() );
		nohaL2S[i].setStrength( nohySila);
		nohaL2S[i].setDamping( nohyDamp );

	}


	////
	nohaR1P = physics.makeParticle( hero.mass[4], hero.x+1, hero.y-2, 0 );

	nohaR1S[0] = physics.makeSpring( truP[5], nohaR1P, 1,1,1 );
	nohaR1S[1] = physics.makeSpring( truP[4], nohaR1P, 1,1,1 );

	for(int i =0;i<nohaL1S.length;i++){
		nohaR1S[i].setRestLength( nohaR1S[i].currentLength() );
		nohaR1S[i].setStrength( nohySila);
		nohaR1S[i].setDamping( nohyDamp );

	}

	//////
	nohaR2P = physics.makeParticle( hero.mass[5], hero.x+1, hero.y+2, 0 );

	//nohaR2S[0] = physics.makeSpring( truP[5], nohaR2P, 1,1,1 );
	nohaR2S[0] = physics.makeSpring( nohaR1P, nohaR2P, 1,1,1 );

	for(int i =0;i<nohaR2S.length;i++){
		nohaR2S[i].setRestLength( nohaR2S[i].currentLength() );
		nohaR2S[i].setStrength( nohySila);
		nohaR2S[i].setDamping( nohyDamp );

	}



	//////////////////// RUCE

	////
	rukaL1P = physics.makeParticle( hero.mass[8], hero.x-14, hero.y-20, 0 );

	//rukaL1S[0] = physics.makeSpring( truP[0], rukaL1P, 1,1,1 );
	rukaL1S[0] = physics.makeSpring( truP[1], rukaL1P, 1,1,1 );

	for(int i =0;i<rukaL1S.length;i++){
		rukaL1S[i].setRestLength( rukaL1S[i].currentLength() );
		rukaL1S[i].setStrength( ruceSila);
		rukaL1S[i].setDamping( ruceDamp );

	}

	//////
	rukaL2P = physics.makeParticle( hero.mass[9], hero.x-20, hero.y-20, 0 );

	//rukaL2S[0] = physics.makeSpring( truP[0], rukaL2P, 1,1,1 );
	rukaL2S[0] = physics.makeSpring( rukaL1P, rukaL2P, 1,1,1 );

	for(int i =0;i<rukaL2S.length;i++){
		rukaL2S[i].setRestLength( rukaL2S[i].currentLength() );
		rukaL2S[i].setStrength( ruceSila);
		rukaL2S[i].setDamping( ruceDamp );

	}


	////
	rukaR1P = physics.makeParticle( hero.mass[10], hero.x+5, hero.y-20, 0 );

	rukaR1S[0] = physics.makeSpring( truP[2], rukaR1P, 1,1,1 );
	//rukaR1S[0] = physics.makeSpring( truP[3], rukaR1P, 1,1,1 );

	for(int i =0;i<rukaR1S.length;i++){
		rukaR1S[i].setRestLength( rukaR1S[i].currentLength() );
		rukaR1S[i].setStrength( ruceSila);
		rukaR1S[i].setDamping( ruceDamp );

	}

	//////
	rukaR2P = physics.makeParticle( hero.mass[11], hero.x+11, hero.y-20, 0 );

	//rukaR2S[0] = physics.makeSpring( truP[3], rukaR2P, 1,1,1 );
	rukaR2S[0] = physics.makeSpring( rukaR1P, rukaR2P, 1,1,1 );

	for(int i =0;i<rukaR2S.length;i++){
		rukaR2S[i].setRestLength( rukaR2S[i].currentLength() );
		rukaR2S[i].setStrength( ruceSila);
		rukaR2S[i].setDamping( ruceDamp );

	}



	anchor = physics.makeParticle( 1.0, width/2+20, 0, 0 );
	anchor.makeFixed();

	spagat = physics.makeSpring( rukaL2P, anchor, 1,1,10 );
	spagat.setRestLength(spagat.currentLength());
	spagat.setStrength( 10.4);
	spagat.setDamping( 0.41 );
	

	//
	//s = physics.makeSpring( p, anchor, 1.0, 0.1, 100 );
	world = new World();

	rectMode(CENTER);
	noFill();
	stroke(255,100);
}


void draw(){
	//anchor.moveTo(mouseX,mouseY,0);
	physics.advanceTime( 0.2 );

	background(0);

	pushMatrix();
	
	
	
	hero.act();
	line(rukaL2P.position().x(),rukaL2P.position().y(),anchor.position().x(),anchor.position().y());
	world.render();

	if(testing){
		stroke(255,70);
	
		for(int i =0;i<truP.length;i++){
			truP[i].moveTo( truP[i].position().x(), truP[i].position().y(), 0.0 );
			rect(truP[i].position().x(),truP[i].position().y(),1,1);
		}
		
			for(int i =0;i<truS.length;i++){
				Particle p1 = truS[i].getOneEnd();
				Particle p2 = truS[i].getTheOtherEnd();
				line(p1.position().x(),p1.position().y(),p2.position().x(),p2.position().y());
			}
			
			for(int i =0;i<nohaL1S.length;i++){
				Particle p1 = nohaL1S[i].getOneEnd();
				Particle p2 = nohaL1S[i].getTheOtherEnd();
				line(p1.position().x(),p1.position().y(),p2.position().x(),p2.position().y());
			}
			
			
			for(int i =0;i<nohaL2S.length;i++){
				Particle p1 = nohaL2S[i].getOneEnd();
				Particle p2 = nohaL2S[i].getTheOtherEnd();
				line(p1.position().x(),p1.position().y(),p2.position().x(),p2.position().y());
			}
			
			
			for(int i =0;i<nohaR1S.length;i++){
				Particle p1 = nohaR1S[i].getOneEnd();
				Particle p2 = nohaR1S[i].getTheOtherEnd();
				line(p1.position().x(),p1.position().y(),p2.position().x(),p2.position().y());
			}
			
			
			for(int i =0;i<nohaR2S.length;i++){
				Particle p1 = nohaR2S[i].getOneEnd();
				Particle p2 = nohaR2S[i].getTheOtherEnd();
				line(p1.position().x(),p1.position().y(),p2.position().x(),p2.position().y());
			}
			
			for(int i =0;i<rukaL1S.length;i++){
				Particle p1 = rukaL1S[i].getOneEnd();
				Particle p2 = rukaL1S[i].getTheOtherEnd();
				line(p1.position().x(),p1.position().y(),p2.position().x(),p2.position().y());
			}
			
			
			for(int i =0;i<rukaL2S.length;i++){
				Particle p1 = rukaL2S[i].getOneEnd();
				Particle p2 = rukaL2S[i].getTheOtherEnd();
				line(p1.position().x(),p1.position().y(),p2.position().x(),p2.position().y());
			}
			
			
			for(int i =0;i<rukaR1S.length;i++){
				Particle p1 = rukaR1S[i].getOneEnd();
				Particle p2 = rukaR1S[i].getTheOtherEnd();
				line(p1.position().x(),p1.position().y(),p2.position().x(),p2.position().y());
			}
			
			
			for(int i =0;i<rukaR2S.length;i++){
				Particle p1 = rukaR2S[i].getOneEnd();
				Particle p2 = rukaR2S[i].getTheOtherEnd();
				line(p1.position().x(),p1.position().y(),p2.position().x(),p2.position().y());
			}
			
			for(int i =0;i<hlavaS.length;i++){
				Particle p1 = hlavaS[i].getOneEnd();
				Particle p2 = hlavaS[i].getTheOtherEnd();
				line(p1.position().x(),p1.position().y(),p2.position().x(),p2.position().y());
			}

		rect(nohaL1P.position().x(),nohaL1P.position().y(),1,1);
		rect(nohaL2P.position().x(),nohaL2P.position().y(),1,1);

		rect(nohaR1P.position().x(),nohaR1P.position().y(),1,1);
		rect(nohaR2P.position().x(),nohaR2P.position().y(),1,1);

		rect(hlavaP.position().x(),hlavaP.position().y(),1,1);


		rect(rukaL1P.position().x(),rukaL1P.position().y(),1,1);
		rect(rukaL2P.position().x(),rukaL2P.position().y(),1,1);

		rect(rukaR1P.position().x(),rukaR1P.position().y(),1,1);
		rect(rukaR2P.position().x(),rukaR2P.position().y(),1,1);
	
	}
popMatrix();
}

void mousePressed(){

	truP[6].addVelocity(20,0,0);
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
	}else if(key == 't'){
		testing = !testing;
	
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


	float mass[] = {
	                       0.6,0.15,

	                       0.15,0.15,0.15,0.15,
	                       0.03,0.03,

	                       0.12,0.1,0.12,0.1
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

	void act(){
		compute();
		render();

	}

	void compute(){

		x=(int)((truP[1].position().x()+truP[3].position().x()+truP[6].position().x()+truP[4].position().x())/4.0)+4;
		y=(int)((truP[1].position().y()+truP[3].position().y()+truP[6].position().y()+truP[4].position().y())/4.0)+10;
		partRotate(0,atan2(truP[3].position().y()-truP[0].position().y(),truP[3].position().x()-truP[0].position().x()) );

		//noha L
		partRotate(2,atan2(nohaL1P.position().y()-truP[6].position().y(),nohaL1P.position().x()-truP[6].position().x())-HALF_PI);
		partRotate(3,atan2(nohaL2P.position().y()-nohaL1P.position().y(),nohaL2P.position().x()-nohaL1P.position().x())-HALF_PI  );
		
		//nohaR
		partRotate(4,atan2(nohaR1P.position().y()-truP[4].position().y(),nohaR1P.position().x()-truP[4].position().x())-HALF_PI  );
		partRotate(5,atan2(nohaR2P.position().y()-nohaR1P.position().y(),nohaR2P.position().x()-nohaR1P.position().x())-HALF_PI  );
		
		
		//kotniky inactive
		partRotate(6,atan2(nohaL2P.position().y()-nohaL1P.position().y(),nohaL2P.position().x()-nohaL1P.position().x())-HALF_PI );
		partRotate(7,atan2(nohaR2P.position().y()-nohaR1P.position().y(),nohaR2P.position().x()-nohaR1P.position().x())-HALF_PI );
		
		

		partRotate(1,atan2(hlavaP.position().y()-lerp(truP[1].position().y(),truP[2].position().y(),0.5),hlavaP.position().x()-lerp(truP[1].position().x(),truP[2].position().x(),0.5))+ HALF_PI );

		//ruka L
		partRotate(8,atan2(rukaL1P.position().y()-truP[1].position().y(),rukaL1P.position().x()-truP[1].position().x())  +HALF_PI-PI);
		partRotate(9,atan2(rukaL2P.position().y()-rukaL1P.position().y(),rukaL2P.position().x()-rukaL1P.position().x()) - HALF_PI);


		//ruka R
		partRotate(10,atan2(rukaR1P.position().y()-truP[2].position().y(),rukaR1P.position().x()-truP[2].position().x()) - HALF_PI);
		partRotate(11,atan2(rukaR2P.position().y()-rukaR1P.position().y(),rukaR2P.position().x()-rukaR1P.position().x()) - HALF_PI);
		//float finetune = map(mouseX,0,width,0,1);
		//println(finetune);

		collide();

	}

	void partRotate(int i,float kolik){

		rotation[i] = (kolik);//map(kolik,-PI,PI,-180,180);//limits[i][0],limits[i][1]);

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

	void collide(){
		
		float fri = 1.0;
		float dmp = 0.01;

		for(int i =0;i<truP.length;i++){
			if(truP[i].position().y()>world.y){
				
				truP[i].setVelocity(truP[i].velocity().x()*fri,truP[i].velocity().y()*-dmp,0.0);
				truP[i].moveTo(truP[i].position().x(),world.y,0);
			}
		}
		
		if(nohaL1P.position().y()>world.y){
			
			nohaL1P.setVelocity(nohaL1P.velocity().x()*fri,nohaL1P.velocity().y()*-dmp,0.0);
			nohaL1P.moveTo(nohaL1P.position().x(),world.y,0);
		}
		
		if(nohaL2P.position().y()>world.y){
			
			nohaL2P.setVelocity(nohaL2P.velocity().x()*fri,nohaL2P.velocity().y()*-dmp,0.0);
			nohaL2P.moveTo(nohaL2P.position().x(),world.y,0);
		}
		
		if(nohaR1P.position().y()>world.y){
			
			nohaR1P.setVelocity(nohaR1P.velocity().x()*fri,nohaR1P.velocity().y()*-dmp,0.0);
			nohaR1P.moveTo(nohaR1P.position().x(),world.y,0);
		}
		
		if(nohaR2P.position().y()>world.y){
			
			nohaR2P.setVelocity(nohaR2P.velocity().x()*fri,nohaR2P.velocity().y()*-dmp,0.0);
			nohaR2P.moveTo(nohaR2P.position().x(),world.y,0);
		}
		
		if(rukaL1P.position().y()>world.y){
			
			rukaL1P.setVelocity(rukaL1P.velocity().x()*fri,rukaL1P.velocity().y()*-dmp,0.0);
			rukaL1P.moveTo(rukaL1P.position().x(),world.y,0);
		}
		
		if(rukaL2P.position().y()>world.y){
			
			rukaL2P.setVelocity(rukaL2P.velocity().x()*fri,rukaL2P.velocity().y()*-dmp,0.0);
			rukaL2P.moveTo(rukaL2P.position().x(),world.y,0);
		}
		
		if(rukaR1P.position().y()>world.y){
			
			rukaR1P.setVelocity(rukaR1P.velocity().x()*fri,rukaR1P.velocity().y()*-dmp,0.0);
			rukaR1P.moveTo(rukaR1P.position().x(),world.y,0);
		}
		
		if(rukaR2P.position().y()>world.y){
			
			rukaR2P.setVelocity(rukaR2P.velocity().x()*fri,rukaR2P.velocity().y()*-dmp,0.0);
			rukaR2P.moveTo(rukaR2P.position().x(),world.y,0);
		}
		
		if(hlavaP.position().y()>world.y){
			
			hlavaP.setVelocity(hlavaP.velocity().x()*fri,hlavaP.velocity().y()*-dmp,0.0);
			hlavaP.moveTo(hlavaP.position().x(),world.y,0);
		}	
		



	}
	
	

	void render(){

		//level0 poziceGlob
		pushMatrix();
		translate(x,y);


		//level1 trup
		pushMatrix();
		translate(positions[0][0],positions[0][1]);
		pushMatrix();

		translate(-anchors[0][0],-anchors[0][1]);
		rotate( (rotation[0]));

		//LEVA RUKA
		//level 2 rukaL1
		pushMatrix();
		translate(positions[8][0],positions[8][1]);
		pushMatrix();
		translate(-anchors[8][0],-anchors[8][1]);
		rotate( (rotation[8])-rotation[0]);
		image(part[8],-anchors[8][0],-anchors[8][1]);

		//level 3 rukaL2
		pushMatrix();
		translate(positions[9][0],positions[9][1]);
		pushMatrix();
		translate(-anchors[9][0],-anchors[9][1]);
		rotate( (rotation[9]-(rotation[8])));
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
		rotate( (rotation[2]-rotation[0]));
		image(part[2],-anchors[2][0],-anchors[2][1]);
		//level 3 hohaL2
		pushMatrix();
		translate(positions[3][0],positions[3][1]);
		pushMatrix();
		translate(-anchors[3][0],-anchors[3][1]);
		rotate( (rotation[3]-(rotation[2])));
		//level 4 botaL
		pushMatrix();
		translate(positions[6][0],positions[6][1]);
		pushMatrix();
		translate(-anchors[6][0],-anchors[6][1]);
		rotate( (rotation[6])-((rotation[3])));
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
		rotate( (rotation[4])-rotation[0]);
		image(part[4],-anchors[4][0],-anchors[4][1]);
		//level 3 hohaR2
		pushMatrix();
		translate(positions[5][0],positions[5][1]);
		pushMatrix();
		translate(-anchors[5][0],-anchors[5][1]);
		rotate( (rotation[5])-(rotation[4]));
		//level 4 botaR
		pushMatrix();
		translate(positions[7][0],positions[7][1]);
		pushMatrix();
		translate(-anchors[7][0],-anchors[7][1]);
		rotate( (rotation[7])-(rotation[5]));
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
		rotate( (rotation[1]));
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
		rotate( (rotation[10])-rotation[0]);
		image(part[10],-anchors[10][0],-anchors[10][1]);

		//level 3 rukaR2
		pushMatrix();
		translate(positions[11][0],positions[11][1]);
		pushMatrix();
		translate(-anchors[11][0],-anchors[11][1]);
		rotate( (rotation[11])-rotation[10]);
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

		println(map(mouseX,0,width,-TWO_PI,TWO_PI));

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

}





class World{
	float y = height-5;

	void render(){
		stroke(255);
		line(0,y,width,y);

	}

}
