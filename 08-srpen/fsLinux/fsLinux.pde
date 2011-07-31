import fullscreen.*; 

FullScreen fs; 

void setup(){
  // set size to 640x480
  size(640,480,P3D);
  
  // 5 fps
  frameRate(40);

  // Create the fullscreen object
  fs = new FullScreen(this); 
  
  // enter fullscreen mode
 // fs.enter(); 
}


void draw(){
  background(0);
  
  // Do your fancy drawing here...
  for(int i = 0; i < 10; i++){
    fill(
      random(255),
      random(255),
      random(255)
    );

    rect(
      i*10, i*10,
      width - i*20, height - i*20
    ); 
  }
}


