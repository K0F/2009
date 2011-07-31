import processing.opengl.*;

import progl.renderers.*;
import progl.*;


ProGLShape circleShape;


void setup(){
  size(800, 600, ProGLGraphics.graphics());
  smooth();
  
  circleShape = new ProGLShape();
  initCircleShape();
}


void initCircleShape(){
  circleShape.beginRecord();
  
  stroke(255, 50);
  noFill();
  
  for (int i = 0; i < 4000; i++){
    rotateX(random(TWO_PI));
    rotateY(random(TWO_PI));

    translate(random(-20, 20), random(-20, 20), random(-1f));
    float diameter = random(5, 50);
    ellipse(0, 0, diameter, diameter);
  }

  circleShape.endRecord();
}

float angle = 0;

void draw(){
  background(0);
  angle += 0.1;
  translate(400, 300, -200);
  rotateX(PI / 2f);
  rotateZ(angle);
  circleShape.draw();
}

void mousePressed(){
  initCircleShape();
}

