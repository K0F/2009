import processing.video.*;
import processing.opengl.*;

//////////////////////////////

MovieMaker mm;
int n = 300;
AGroup[] ag = new AGroup[n];
PImage img[] = new PImage[n];
PImage shade;



void setup(){
  size(1280,720,P3D);
  background(255);
  
  for(int i = 0;i<n;i++){
    img[i] = loadImage(sketchPath+"/data/icos/icon ("+(i+1)+").png"); 
    ag[i] = new AGroup(i,img[i]);
    println(i+ "loaded!");
  }
  shade = createImage(200,200,ARGB);
  for(int x = 0;x<shade.width;x++){
    for(int y = 0;y<shade.height;y++){
   shade.pixels[y*shade.width+x] =  color(0,constrain(map(dist(x,y,shade.width/2,shade.height/2),0,shade.width/2,255,0),0,255));
    }
  }
  
  mm = new MovieMaker(this, width, height, "catastrophe.mov",30, MovieMaker.JPEG, MovieMaker.HIGH);
  println("mm created!");
  //noSmooth();
  textFont(createFont("Arial",18));
  println("font created!");

}



void mousePressed(){
  for(int i = 0;i<n;i++){
    ag[i].reset();
  }
  mousePressed=false;
}



void draw(){
  background(0);

  for(int i = 0;i<n;i++){
    ag[i].run();

  }

  mm.addFrame();
}

void stop(){
  mm.finish();
  super.stop();

}



void keyPressed(){
  if(key==' '){
    save("screen.png");
  } 
  else if(keyCode==ENTER){
    mm.finish();
    println("hotovo!");
  }
  keyPressed=false;

}


