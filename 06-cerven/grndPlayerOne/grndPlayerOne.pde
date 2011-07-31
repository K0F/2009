import promidi.*;
import codeanticode.gsvideo.*;

MidiIO midiIO;
MidiOut midiOut;
Note note;

int notes[] = {75, 41, 62, 71, 89, 61, 98, 93, 65, 43, 47, 78, 107, 108, 90, 45, 71, 73, 66, 89};//new int[0];

ImgPlr one;


GSCapture cam;
int step = 12;

boolean doublesize = false;

PImage msk;

/*

 midiOut.sendController(

      new promidi.Controller(myNumber,int(xPos/6)+2)

    );
 midiOut.sendProgramChange(

        new ProgramChange(myNumber)

      );

*/

void setup(){

	size(480,480,OPENGL);

	background(0);
	frameRate(25);

	//smooth();
	/*
	int g = 0;
	for(int i = width/2;i<width;i+=step){
			notes = (int[])expand(notes,notes.length+1);
			notes[notes.length-1] = (int)random(40,110);//(int)map(i,width/2,width,20,100);
			print(notes[notes.length-1]+", ");
			g++;
}
	println("");
	println("created "+g+" of senzors");
	*/
	msk = loadImage("mask.png");
	for(int i = 0 ;i<notes.length;i++)
		notes[i] = i*2+60;

	midiIO = MidiIO.getInstance(this);

	midiOut = midiIO.getMidiOut(1,1);

	if(doublesize){
		cam = new GSCapture(this,320,240);
	}else{
		cam = new GSCapture(this,640,480);

	}

	//print a list with all available devices

	//midiIO.printDevices();




	one = new ImgPlr(loadImage("title.png"));

	noStroke();
	rectMode(CENTER);

}


void draw(){


	background(255);

	one.act();

	image(msk,0,0,width,height);
}


void keyPressed(){

	if(key=='q'){
		try{
			exit();
		}catch(NullPointerException e){
			println("buckEnd!");
		}
	}else if(key==' '){

		one.refresh();


	}else if(keyCode==UP){
		one.speed++;
		println(one.speed);
	}else if(keyCode==DOWN){
		one.speed--;
		println(one.speed);
	}

	one.speed=constrain(one.speed,1,30);
}





class ImgPlr{

	PImage store;
	float rot = 0;
	float speed = 1;
	int mem[] = new int[0];
	int mem2[] = new int[0];
	float tresh = 30;

	ImgPlr(PImage _src){
		store = _src;


		for(int i = width/2;i<width;i+=step){
			mem = (int[])expand(mem,mem.length+1);
			mem[mem.length-1] = 0;
			mem2 = (int[])expand(mem2,mem2.length+1);
			mem2[mem2.length-1] = 0;
		}
		refresh();
	}

	void act(){
		rot+=speed;



		pushMatrix();
		translate(width/2,height/2);
		rotate(radians(rot));

		if(doublesize){
			image(store,-store.width,-store.height,store.width*2,store.height*2);

		}else{
			image(store,-store.width/2,-store.height/2);


		}
		popMatrix();

		int g = 0;

		for(int i = width/2;i<width;i+=step){
			mem[g] = (int)brightness(get(i,height/2));
			fill(abs(mem[g]-mem2[g]));
			rect(i,height/2,4,4);


			if(abs(mem2[g]-mem[g])>tresh){
				if(rot>2)
					playNote( notes[g] , (int)constrain((abs(mem2[g]-mem[g])-tresh)*30,5,1000) );
			}

			mem2[g] = mem[g];


			g++;
		}

		if(rot>360){
			rot=0;
			refresh();
		}

	}

	void refresh(){
		if (cam.available() == true) {
			try{
				cam.read();
				store=cam;
				//cam.resize(0,320);


			}catch(java.lang.NullPointerException e){
				println("weird error! @ "+frameCount);
			}
		}

		int g = 0;

	}



}



void playNote(int tone,int len){

	note = new Note(tone,(int)map(len,0,1000,20,127),len);
	midiOut.sendNote(note);

}


