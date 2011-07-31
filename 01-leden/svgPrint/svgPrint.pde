 	

import processing.candy.*;
import processing.xml.*;

SVG m;

void setup(){
  size(400,400);
  // The file "moo.svg" must be in the data folder
  // of the current sketch to load successfully
  m = new SVG(this, "test.svg");
} 

void draw(){
  m.draw();
  m.draw(200, 200);
}
