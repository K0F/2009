/*
Kohonen Neural net demo.
 
 Sorts an image into it's constituent colours.
 
 This example can be adapted to sort all sorts of data
 into groups.
 
 Adapted from tutorial at:
 http://www.ai-junkie.com/ann/som/som1.html
*/

PFont font;
PImage pic;
Cortex cortex;
Buttons [] button;
int choice = -1;
boolean go = false;

void setup(){
  size(123*2,123*2,P2D);
  pic = loadImage("1.gif");
  cortex = new Cortex();
  int col = #EEEEEE;
  button = new Buttons[2];
  button[0] = new Buttons(128,0,64,20,col,"train",null);
  button[1] = new Buttons(192,0,64,20,col,"reset",null);
  font = createFont("04b03b",8);
  textMode(SCREEN);
  textFont(font,8);
  noStroke();
  noSmooth();
}

void draw(){
  image(pic,0,0,width,height);
  cortex.draw();
  if (go) cortex.train();
  for (int i = 0; i < button.length; i++){
    button[i].draw();
  }
}

void mousePressed(){
  for(int i = 0; i < button.length; i++){
    if(button[i].over()){
      choice = i;
    }
  }
  switch(choice){
  case 0:
    go = !go;
    break;
  case 1:
    cortex = new Cortex();
    break;
  }
}


