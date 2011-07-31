class A{
  float x,y,z;
  float tx,ty,tz;
  float var = 1000.0f;
  float speed = 5.0f; //default
  int id;
  int parent;

  A(float _var, float _speed, int _id,int _parent){
    id=_id;
    parent=_parent;
    var=_var;
    speed=_speed;
    this.x=this.y=this.z=0;
    this.ty=this.tx=this.tz=this.x;
  }

  void compute(){
    if(id!=0){
      this.tx += (ag[parent].a[id-1].x-this.tx) / speed;
      this.ty += (ag[parent].a[id-1].y-this.ty) / speed;
      this.tz += (ag[parent].a[id-1].z-this.tz) / speed;
    }
    else{
      this.tx += random(-var,var);
      this.ty += random(-var,var);
      this.tz += random(-var,var);
      
      if(parent!=0){
        this.tx += (ag[parent-1].a[0].x-tx) / (0.975f*speed);
        this.ty += (ag[parent-1].a[0].y-ty) / (0.975f*speed);
        this.tz += (ag[parent-1].a[0].z-tz) / (0.975f*speed);
      }
      // border();
    }

    this.x+=(this.tx-this.x)/speed;
    this.y+=(this.ty-this.y)/speed;
    this.z+=(this.tz-this.z)/speed;
  }

  void draw(){

    if(id>20){
      stroke(255,25);
      //point(this.x,this.y,this.z);
      noFill();
    pushMatrix();
      translate(x,y,z);
      rotateY(-ag[parent].rot);
      //tint(255,map(z,-width,width,0,255));   
       image(shade,-80,-80);   
      image(ag[parent].ico,0,0,80,80);
      popMatrix();
	
    //  line(ag[parent].a[id].x,ag[parent].a[id].y,ag[parent].a[id].z,ag[parent].a[id-1].x,ag[parent].a[id-1].y,ag[parent].a[id-1].z);    
     
      
      stroke(0,3);  
      //line(a[id].this.x,a[id].this.y,a[id].this.z,a[id].this.x,-height,a[id].this.z);    
       
      /* line(a[id].this.x,a[id].this.y,a[id].this.z,-width,a[id].this.y,a[id].this.z);   
       
       line(a[id].this.x,a[id].this.y,a[id].this.z,a[id].this.x,a[id].this.y,-height);  */
    }
    border();
  } 

  void border(){
    if(this.x>width*2.0f){
      this.tx=this.x=width*2.0f;
    }
    if(this.x<-width*2.0f){
      this.tx=this.x=-width*2.0f;
    }
    if(this.y>width*2.0f){
      this.ty=this.y=width*2.0f;
    }
    if(this.y<-width*2.0f){
      this.ty=this.y=-width*2.0f;
    }
    if(this.z>width*2.0f){
      this.tz=this.z=width*2.0f;
    }
    if(this.z<-width*2.0f){
      this.tz=this.z=-width*2.0f;
    }    
  }


}
