//Gesture recognition using angles between vectors
//Structure guidelines taken from
//<http://www.generation5.org/content/2004/aiTabletOcr.asp>
BPN net;
PFont font;
int pathLength = 20;
int sampleNum = 5;
double [][] outs;
double [][] thetas;
Tracer tracer = new Tracer(pathLength);
Vec2 [] input;
Vec2 [][] sample;
Vec2 [][] miniSample;
Buttons [] button;
int state = 0;
int epochs = 100;
String id = "Press train network";
void setup(){
  size(500,400);
  sample = new Vec2[sampleNum][pathLength];
  miniSample = new Vec2[sampleNum][pathLength];
  thetas = new double[sampleNum][pathLength-1];
  font = loadFont("Kartika-48.vlw");
  textFont(font, 24);
  //load training set
  Vec2 [] temp = loadVec2("data.txt");
  for(int i = 0; i < sampleNum; i++){
    sample[i] = subsetVec2(temp,i*pathLength,pathLength);
    thetas[i] = atan2Vec2(sample[i]);
    shrinkSample(i);
  }
  outs = new double[sampleNum][sampleNum];
  for(int i = 0; i < outs.length; i++)
    for(int j = 0; j < outs[i].length; j++)
      if(i == j) outs[i][j] = 0.99; 
      else outs[i][j] = 0.0;
  //inputs, hidden, outputs, learning, sigmoid threshold, sigmoid elasticity, momentum
  net = new BPN(pathLength-1, (pathLength + sampleNum) / 2, sampleNum, 0.05, 0.5, 0.5, 0.999);
  //buttons
  button = new Buttons[8];
  for(int i = 0; i < 5; i++)
    button[i] = new Buttons(width-200, 40 + i * 20, 200, 20, color(240), "save as training set "+i, null);
  button[5] = new Buttons(width-200, 140, 200, 20, color(240), "save training vectors file", null);
  button[6] = new Buttons(width-200, 160, 200, 20, color(240), "train network", null);
  button[7] = new Buttons(width-200, 180, 200, 20, color(240), "classify drawing", null);
}
void draw(){
  if(!mousePressed)
    background(255);
  tracer.draw();
  drawSamples();
  text(id, 20, height-20);
  for(int i = 0; i < button.length; i++)
    button[i].draw();
}
void mousePressed(){
  int choice = -1;
  for(int i = 0; i < button.length; i++)
    if (button[i].over()) choice = i;
  switch(choice){
  case 0:
  case 1:
  case 2:
  case 3:
  case 4:
    sample[choice] = copyVec2(tracer.vectors);
    thetas[choice] = atan2Vec2(sample[choice]);
    shrinkSample(choice);
    break;
  case 5:
    Vec2 [] stemp = new Vec2[pathLength * sampleNum];
    stemp = sample[0];
    for(int i = 1; i < sample.length; i++)
      stemp = concatVec2(stemp, sample[i]);
    saveVec2("data.txt", stemp);
    println("saved");
    break;
  case 6:
    net = new BPN(pathLength-1, (pathLength + sampleNum) / 2, sampleNum, 0.1, 0.5, 0.5, 0.999);
    trainNet();
    id = "network trained";
    break;
  case 7:
    double [] temp2;
    temp2 = atan2Vec2(tracer.vectors);
    net.propagate(temp2);
    int bestMatch = -1;
    double bestMatchScore = -1.0;
    for(int i = 0; i < net.outA.length; i++){
      print(net.outA[i]+" ");
      if(net.outA[i] > bestMatchScore){
        bestMatch = i;
        bestMatchScore = net.outA[i];
      }
    }
    print(" best match:"+bestMatch+"\n");
    id = "best match:"+bestMatch;
    break;
  default:
    input = new Vec2[1];
    input[0] = new Vec2(mouseX,mouseY);
    point(mouseX,mouseY);
    break;
  }
}
void mouseDragged(){
  Vec2 temp = new Vec2(mouseX,mouseY);
  input = addVec2(input, temp);
  point(mouseX,mouseY);
}
void mouseReleased(){
  if(!over(width-200,40,200,160))
    tracer.initVectors(input);
}
void keyPressed(){
  switch(key){
  case 't':
    double [] temp;
    for(int i = 0; i < sample.length; i++){
      temp = atan2Vec2(sample[i]);
      net.learnVector(temp,outs[i]);
      println("learnt "+i+" error:"+net.absoluteError);
    }
    break;
  }
}
void trainNet(){
  boolean [] picked = new boolean[sampleNum];
  //first pass
  for(int i = 0; i < epochs; i++){
  for(int j = 0; j < sampleNum; j++){
      net.learnVector(thetas[j],outs[j]);
    }
  }
  /*
  //second pass - randomise sets
  for(int i = 0; i < sample.length; i++){
    int k = -1;
    while(true){
      k = int(random(sampleNum));
      if(!picked[k]){
        picked[k] = true;
        break;
      }
    }
    temp = atan2Vec2(sample[k]);
    for(int j = 0; j < learningIterations; j++){
      net.learnVector(temp,outs[k]);
      //println("learnt "+i+" error:"+net.absoluteError);
      if(net.absoluteError <= 0.1) break;
    }
  }
  */
}
void shrinkSample(int num){
  miniSample[num][0] = new Vec2(0,0);
  for(int i = 1; i < miniSample[num].length; i++){
    float x = miniSample[num][i-1].x + cos((float)thetas[num][i-1] * TWO_PI) * 2.0;
    float y = miniSample[num][i-1].y + sin((float)thetas[num][i-1] * TWO_PI) * 2.0;
    miniSample[num][i] = new Vec2(x,y);
  }
}
void drawSamples(){
  for(int i = 0; i < miniSample.length; i++){
    pushMatrix();
    translate(20+i*40,30);
    fill(130);
    text(str(i),0,0);
    if(miniSample[i][0] != null){
      beginShape(LINE_STRIP);
      for(int j = 0; j < miniSample[i].length; j++)
        vertex(miniSample[i][j].x, miniSample[i][j].y);
      endShape();
    }
    popMatrix();
  }
}
