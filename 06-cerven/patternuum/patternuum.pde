import promidi.*;
import codeanticode.gsvideo.*;

import ddf.minim.*;
 
Minim minim;
AudioPlayer sam[];
String files[] = {"understandingRepeating.mp3","clock.mp3","clockSmall.mp3","porcelan.mp3"};


MidiIO midiIO;
MidiOut midiOut;
Note note;

int notes[] = {30,30,34,36,39,90,94,97};
//{0,32,37,43,51,64,85,127};//new int[0];//{0, 8, 16, , 60, 65, 70, 75, 80, 85, 90, 95, 100, 105, 110, 115, 120, 125, 30, 20};//new int[0];
char ch[] = {'a','s','d','f','g','h','j','k','l',';','z','x','c','v','b','n','m',',','.','/'};
ImgPlr one;
int lastPlayed = 0;

GSCapture cam;
int step = 32;

boolean doublesize = true;
boolean bw = true;

boolean auto = true;
boolean helper =true;

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
	noSmooth();

	//smooth();
	/*
	int g = 0;
	for(int i = width/2;i<width;i+=step){
			notes = (int[])expand(notes,notes.length+1);
			notes[notes.length-1] = constrain(g*8,0,127);//(int)map(i,width/2,width,20,100);
			print(notes[notes.length-1]+", ");
			g++;
}
	println("");
	println("created "+g+" of senzors");
	*/
	msk = loadImage("mask.png");
	
	
	midiIO = MidiIO.getInstance(this);

	midiOut = midiIO.getMidiOut(0,64);

	if(doublesize){
		cam = new GSCapture(this,320,240);
	}else{
		cam = new GSCapture(this,640,480);

	}

	//print a list with all available devices

	midiIO.printDevices();


	sam = new AudioPlayer[files.length];
	minim = new Minim(this);

	for(int i =0;i<sam.length;i++){
		sam[i] = minim.loadFile(files[i], 2048);

	}

	syncstart();
 




	one = new ImgPlr(loadImage("title.png"));

	noStroke();
	rectMode(CENTER);

}


void syncstart(){

	for(int i =0;i<sam.length;i++)
		sam[i].loop();

}

void draw(){


	background(255);
	noFill();
	stroke(0);
	

	one.act();

	image(msk,-1,-1,width+2,height+2);
	
	noFill();
	stroke(0);
	
	if(helper)
		for(int i =width/2 ;i<width*2;i+=step*2){
			ellipse(width/2,height/2,i-width/2,i-width/2);
		
		}
}

void stop(){


	// always close Minim audio classes when you are done with them
	for(int i =0;i<sam.length;i++)
		sam[i].close();
	// always stop Minim before exiting.
	minim.stop();

	super.stop();


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
		one.speed+=0.1;
		println(one.speed);
	}else if(keyCode==DOWN){
		one.speed-=0.1;
		println(one.speed);
	}else if(key== ' '){
		one.refresh();
	}else if(key==ch[0]){
		one.playNote(0);	
	}else if(key==ch[1]){
		one.playNote(1);	
	}else if(key==ch[2]){
		one.playNote(2);	
	}else if(key==ch[3]){
		one.playNote(3);	
	}else if(key==ch[4]){
		one.playNote(4);	
	}else if(key==ch[5]){
		one.playNote(5);	
	}else if(key==ch[6]){
		one.playNote(6);	
	}else if(key==ch[7]){
		one.playNote(7);	
	}else if(key==ch[8]){
		one.playNote(8);	
	}else if(key==ch[9]){
		one.playNote(9);	
	}else if(key==ch[10]){
		one.playNote(10);	
	}else if(key==ch[11]){
		one.playNote(11);	
	}else if(key==ch[12]){
		one.playNote(12);	
	}else if(key==ch[13]){
		one.playNote(13);	
	}else if(key==ch[14]){
		one.playNote(14);	
	}else if(key==ch[15]){
		one.playNote(15);	
	}else if(key==ch[16]){
		one.playNote(16);	
	}else if(key==ch[17]){
		one.playNote(17);	
	}else if(key==ch[18]){
		one.playNote(18);	
	}else if(key==ch[19]){
		one.playNote(19);	
	}else if(keyCode==LEFT){
		
		notes[lastPlayed] --;
		one.rebuild();
		println(notes[lastPlayed]);
	}else if(keyCode==RIGHT){
		notes[lastPlayed] ++;
		one.rebuild();
		println(notes[lastPlayed]);
	}
	

	one.speed=constrain(one.speed,-12,12);
}





class ImgPlr{

	PImage store;
	float rot = 0;
	float speed = 0.3;

	Note[] note = new Note[0];
	int mem[] = new int[0];
	int mem2[] = new int[0];

	int waits[] = new int[0];
	boolean ons[] = new boolean[0];

	int w = 3;
	float tresh = 6;


	ImgPlr(PImage _src){
		store = _src;

		rebuild();

	}
	
	void rebuild(){
	
	int g = 0;
		note = new Note[0];
		mem = new int[0];
		mem2 = new int[0];
		waits = new int[0];
		ons = new boolean[0];
		
		for(int i = width/2;i<width;i+=step){

			note = (Note[])expand(note,note.length+1);
			note[note.length-1] = new Note(notes[g],100,1000);

			mem = (int[])expand(mem,mem.length+1);
			mem[mem.length-1] = 0;

			mem2 = (int[])expand(mem2,mem2.length+1);
			mem2[mem2.length-1] = 0;

			waits = (int[])expand(waits,waits.length+1);
			waits[waits.length-1] = w;

			ons = (boolean[])expand(ons,ons.length+1);
			ons[ons.length-1] = true;


			g++;
		}
		
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
			
			if(ons[g]){
			fill(#FF0000);
			}else{
			fill(0);
			}
			rect(i,height/2,4,4);


			if((mem[g])<(mem2[g]-tresh-map(i,width/2,width,0,tresh*PI))){
				if(rot>2)
					if(!ons[g]){
						playNote( g ); //notes[g] , (int)constrain((abs(mem2[g]-mem[g])-tresh)*300,5,1000)
						ons[g] = true;
						waits[g] = w;
					}
			}

			mem2[g] = mem[g];



			if(waits[g]<=0){
				ons[g] = false;
			}else{
				waits[g]--;
			}
			
			g++;
		}

		if(auto)
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
				
				if(bw)store.filter(GRAY);
				//cam.resize(0,320);
				
				//for(int i =0;i<ons.length;i++){
				//	ons[i] = true;
					//waits[i] = w;
				//
				//}


			}catch(java.lang.NullPointerException e){
				println("weird error! @ "+frameCount);
			}
		}

		int g = 0;

	}

	void playNote(int id){

		//Note tmp = ;
		midiOut.sendNote( note[id] );
		lastPlayed = id;

	}



}





