
import ddf.minim.*;


Minim minim;
AudioPlayer sam[];
String files[] = {"understandingRepeating.mp3","clock.mp3","clockSmall.mp3","porcelan.mp3"};



void setup(){


	size(320,240,OPENGL);

	background(0);
	frameRate(25);

	sam = new AudioPlayer[files.length];
	minim = new Minim(this);

	for(int i =0;i<sam.length;i++){
		sam[i] = minim.loadFile(files[i], 2048);

	}

	syncstart();
}

void syncstart(){

	for(int i =0;i<sam.length;i++)
		sam[i].loop();

}

void draw(){
	background(0);

}

void stop(){


	// always close Minim audio classes when you are done with them
	for(int i =0;i<sam.length;i++)
		sam[i].close();
	// always stop Minim before exiting.
	minim.stop();

	super.stop();


}



