class Cortex{
	
  KCell [] layer;
  int bestCell = -1;
  float mapUnit,mapWidth,mapArea,mapRadius,learningRate;
  float startLearningRate = 0.1;
  float iterations = 1.0;
  float sumIterations = 1000.0;
  String mode = "brightness";
  
  Cortex(){
	  
    layer = new KCell[pic.pixels.length];
    mapArea = float(pic.pixels.length);
    mapWidth = sqrt(mapArea);
    mapUnit = width/mapWidth;
    for(int i = 0; i < layer.length; i++){
      layer[i] = new KCell(i,i%int(mapWidth),i/int(mapWidth),mapUnit);
    }
    //calculate radius (max (width, height)/2) or ->
    mapRadius = sqrt(mapArea)/2;
  }
  void draw(){
    //render an image of the weight values of the net and
    //highlight where the best cell is picked
    noStroke();
    for(int i = 0; i < layer.length; i++){
      fill(255,255,0);
      if(i == bestCell){
        ellipse(layer[i].x*mapUnit,layer[i].y*mapUnit,20,20);
      }
      //layer[i].draw();
    }
    for(int i = 0; i < layer.length; i++){
      stroke(layer[i].weight[0]*255.0,layer[i].weight[1]*255.0,layer[i].weight[2]*255.0);
      point(layer[i].x,layer[i].y); 
    }
  }
  void train(){
    //calculate best matching unit
    float bestInputVectorDelta = 100000.0;
    bestCell = -1;
    int pick = int(random(layer.length));
    float [] inputVector = new float[3];
    inputVector[0] = (1.0/255.0) * red(pic.pixels[pick]);
    inputVector[1] = (1.0/255.0) * green(pic.pixels[pick]);
    inputVector[2] = (1.0/255.0) * blue(pic.pixels[pick]);
    for(int i = 0; i < layer.length; i++){
      float vectorDelta = 0.0;
      //normally iterate through sum of weights
      for (int j = 0; j < layer[i].weight.length; j++){
        vectorDelta += sq(inputVector[j] - layer[i].weight[j]);
      }
      vectorDelta = sqrt(vectorDelta);
      if (vectorDelta < bestInputVectorDelta){
        bestCell = i;
        bestInputVectorDelta = vectorDelta;
      }
    }
    //calc time constant
    float timeConstant = sumIterations/log(mapRadius);
    //calc neighbourhood
    float neighbourhood = mapRadius * exp(-iterations/timeConstant);
    for (int i = 0; i < layer.length; i++){
      //calculate the Euclidean distance (squared) to this node from the
      //Best Matching Unit
      float distToNodeSq = sq(layer[bestCell].x-layer[i].x) + sq(layer[bestCell].y-layer[i].y);
      float widthSq = sq(neighbourhood);
      //if within the neighbourhood adjust its weights
      if (distToNodeSq < widthSq){
        //calculate by how much its weights are adjusted
        float influence = exp(-(distToNodeSq) / (2*widthSq));
        layer[i].educate(learningRate,influence,inputVector);
      }
    }//next node
    //set new learning rate
    learningRate = startLearningRate * exp(-iterations/sumIterations);
    iterations++;
  }
}

class KCell{
  //a Kohonen neural net component
  int id;
  float x,y,mapUnit;
  float [] weight;
  KCell(int id, float x, float y, float mapUnit){
    this.id = id;
    weight = new float[3];
    for (int i = 0; i < weight.length; i++){
      weight[i] = random(0.1,0.5);
    }
    this.x = x;
    this.y = y;
    this.mapUnit = mapUnit;
  }
  void educate(float learningRate, float influence, float [] targetVector){
    //alters weight on dendrites based on desired input
    for (int i = 0; i < targetVector.length; i++){
      weight[i] += learningRate * influence * (targetVector[i] - weight[i]);
    }
  }
  void draw(){
    //put rectangular pixels representing the net over their source pixels
    fill(weight[0]*255.0,weight[1]*255.0,weight[2]*255.0);
    rect(x*mapUnit,y*mapUnit,5,5);
  }
}

