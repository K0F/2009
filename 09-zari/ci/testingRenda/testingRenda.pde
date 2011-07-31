
Recorder r;

void setup(){
	size(360,288,OPENGL);
	r = new Recorder("out","test.mp4");
	noStroke();
	fill(0);
}

void draw(){

	background(255);
	
	
	translate(width/2,height/2);
	rotate(radians(frameCount));
	rect(-width,0,width*2,height*2);

	r.add();
	
	if(frameCount>300){
	
		r.finish();
		exit();
	}

}

void keyPressed(){
	if(key == ' '){
	save("screen.png");
	}

}

class Recorder{
  String dir,name;
  int cntr = 0;

	
  Recorder(String _dir,String _name){
    dir = _dir;
    name= _name;
    //btrt = _btrt;
  }

  void add(){
    save(dir+"/screen"+nf(cntr,4)+".png");
    cntr++;
  }

  void finish(){
    String Path = sketchPath+"/"+dir;
    try{     
      String bitrate="8000k";//+(((int)(50*25*width*height)/256)*2);
      Runtime.getRuntime().exec("gnome-terminal -x png2vid "+Path+" "+name+" "+width+"x"+height+" "+bitrate);
      println("finishing");
    }
    catch(java.io.IOException e){
      println(e); 
    }  
  }
}

