//2D vector class and methods
class Vec2{
  float x,y;
  Vec2(){
    x = -1;
    y = -1;
  }
  Vec2(float x, float y){
    this.x = x;
    this.y = y;
  }
  float arcTan2(Vec2 other){
    float dx = other.x - this.x;
    float dy = other.y - this.y;
    return atan2(dy,dx);
  }
  float dist(Vec2 other){
    float dx = this.x - other.x;
    float dy = this.y - other.y;
    return sqrt(dx*dx + dy*dy);
  }
  Vec2 midPoint(Vec2 other){
  Vec2 temp = new Vec2(lerp(this.x, other.x, 0.5), lerp(this.y, other.y, 0.5));
  return temp;
  }
}
//save and load
void saveVec2(String filename, Vec2 [] data){
  String [] file = new String [data.length];
  for(int i = 0; i < data.length; i++){
  if (data[i] == null) println("bad"); else println ("good");
    file[i] = data[i].x+" "+data[i].y;
  }
  saveStrings(filename, file);
}
Vec2 [] loadVec2(String filename){
  String [] file = loadStrings(filename);
  Vec2 [] data = new Vec2[file.length];
  for(int i = 0; i < file.length; i++){
    String [] temp = split(file[i]);
    data[i] = new Vec2(float(temp[0]),float(temp[1]));
  }
  return data;
}
//array functions
Vec2 [] addVec2(Vec2 [] vectors, Vec2 newVector) {  
  Vec2 [] temp = new Vec2[vectors.length + 1];  
  System.arraycopy(vectors, 0, temp, 0, vectors.length);  
  temp[vectors.length] = newVector;   
  return temp;
}
Vec2 [] concatVec2(Vec2 [] vectors, Vec2 [] addVectors) {  
  Vec2 [] temp = new Vec2[vectors.length + addVectors.length];  
  System.arraycopy(vectors, 0, temp, 0, vectors.length);  
  System.arraycopy(addVectors, 0, temp, vectors.length, addVectors.length);   
  return temp;
}
Vec2 [] subsetVec2(Vec2 [] vectors, int offset, int len) {  
  Vec2 [] temp = new Vec2[len];  
  System.arraycopy(vectors, offset, temp, 0, len);    
  return temp;
}
Vec2 [] copyVec2(Vec2 [] vectors){
  Vec2 [] temp = new Vec2[vectors.length];
    System.arraycopy(vectors, 0, temp, 0, vectors.length);
  return temp;
}
/*
float [] atan2Vec2(Vec2 [] vectors){
    float [] atan2Return = new float[vectors.length-1];
    for(int i = 1; i < vectors.length; i++)
      atan2Return[i-1] = vectors[i-1].arcTan2(vectors[i]);
    return atan2Return;
}
*/
double [] atan2Vec2(Vec2 [] vectors){
    double [] atan2Return = new double[vectors.length-1];
    for(int i = 1; i < vectors.length; i++)
      atan2Return[i-1] = (1.0 / TWO_PI) * (vectors[i-1].arcTan2(vectors[i]));
    return atan2Return;
}
