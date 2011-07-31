//Line drawing class
class Tracer{
  Vec2 [] vectors;
  Tracer(){
  }
  Tracer(int len){
    vectors = new Vec2[len];
  }
  void initVectors(Vec2 [] input){
    //if the path is too short, double its length and interpolate vectors
    while(input.length < vectors.length){
      Vec2 [] temp = copyVec2(input);
      input = new Vec2[(temp.length*2)-1];
      for(int i = 0; i < temp.length-1; i++){
        input[i*2] = temp[i];
        input[i*2+1] = temp[i].midPoint(temp[i+1]);
      }
      input[input.length-1] = temp[temp.length-1];
    }
    //take points along the input as our path
    if (input.length > vectors.length){
      float step = (float)input.length/vectors.length;
      float j = 0.0;
      for(int i = 0; i < vectors.length; i++){
        vectors[i] = input[(int)j];
        j += step;
      }
    }
  }
  void draw(){
    if(tracer.vectors[0] != null){
      beginShape(LINE_STRIP);
      for(int i = 0; i < vectors.length; i++)
        vertex(vectors[i].x,vectors[i].y);
      endShape();
    }
  }
}
