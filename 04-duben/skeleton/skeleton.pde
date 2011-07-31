
PImage clanek;
Kostra k;


void setup(){
	size(400,400,P3D);

	clanek = loadImage("bone.png");

	k = new Kostra(10);

}


void draw(){
	background(255);

	k.live();


}


class Kostra{
	Clanek c[];
	int pocet;

	Kostra(int _pocet){
		pocet = _pocet;
		seta();
	}

	void seta(){

		c = new Clanek[pocet];
		for(int i =0;i<c.length;i++){
			c[i]= new Clanek();
		}

	}

	void live(){
		for(int i =0;i<c.length;i++){
			c[i].live();
		}

	}

}

class Clanek{
	PImage img;
	float x,y;
	Clanek(){
		
		img = clanek;
	}

	void live(){
		image(img,x,y,img.width/2.0,img.height/2.0);

	}



}
