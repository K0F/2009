class Node{
   int mutaton = 2;
  float echo = 0.5f;
  
  int mat = 3;
  float[][] matix = new float[mat][mat];
  float w,h;
  float x,y,tx,ty;
  float speed = 30.0f;
  float wid,heig;
  float r = 15.0f;
  int tim = 0,lim;
  float t;
  color c[] = new color[3];
  int id;
  int which; 

  float ler = 0.0f;
  boolean sending;


  Node(int _id){
    id = _id;
    which = constrain(id-1,0,node.length-1);
    lim = (int)random(5,42);
    w=h=5;
    x=y=tx=ty=width/2.0f;
    wid = w*mat;
    heig=h*mat;
    sending = false;
    this.reset();
  }

  void run(){
    tim++;

    if(tim%lim==0&&id==node.length-1){
      lim = (int)random(50,420);      
      reset();
      sending = true;
    }

    

    compute();
    draw();
    
    if(sending){
      ler+=echo;
      fill(#FFCC00,85);
      ellipse(lerp(x+1.5f*w,node[which].x+1.5f*w,ler),lerp(y+1.5f*w,node[which].y+1.5f*w,ler),
      3*w-((ler)*3*w),3*w-((ler)*3*w));
      
      if(ler>=1){
        sendGen(which);
        sending = false;
        if(which!=0)node[which].sending = true;
        ler = 0.0f;
      }      
    }
  }

  void compute(){
    move();    
  }

  void draw(){



    fill(255,85);              


    triangle(x,y,x+3*w,y,(node[which].x+(1.5f*w)),(node[which].y+(1.5*w)));
    
    if(sending){
       fill(#FFCC00,85);
    triangle(x,y,x,y+3*w,(int)(node[which].x+(1.5f*w)),(int)(node[which].y+(1.5f*w)));

   
    triangle( x, y+3*w, x+3*w, y+3*w,(int)(node[which].x+(1.5f*w)),(int)(node[which].y+(1.5f*w)));

                   
    triangle(x+3*w,y,x+3*w,y+3*w,(int)(node[which].x+(1.5f*w)),(int)(node[which].y+(1.5*w)));    
    
    }else{
    
    fill(hue(c[0]),85);
    triangle(x,y,x,y+3*w,(int)(node[which].x+(1.5*w)),(int)(node[which].y+(1.5*w)));

    fill(hue(c[1]),85);
    triangle( x, y+3*w, x+3*w, y+3*w,(int)(node[which].x+(1.5f*w)),(int)(node[which].y+(1.5f*w)));

    fill(hue( c[2]),85);                 
    triangle(x+3*w,y,x+3*w,y+3*w,(int)(node[which].x+(1.5f*w)),(int)(node[which].y+(1.5f*w)));    
    }

    pushMatrix();
    fill(lerpColor(#FFFFFF,#FFCC00,ler),125);
    translate(x,y);
    ellipse((int)(w*1.5f),(int)(h*1.5f),r*2,r*2);
    image(shade,-41,-41);
    for(int i = 0;i < matix.length;i++){
      for(int q = 0;q < matix[i].length;q++){

        fill(matix[i][q]); 

        rect((int)i*w,(int)q*h,w,h);
      }
    }
    //colors();

    c[0] = color(matix[0][0],matix[1][0],matix[2][0]);
    c[1] =  color(matix[0][1],matix[1][1],matix[2][1]);
    c[2] = color(matix[0][2],matix[1][2],matix[2][2]);
    sipka();
    popMatrix();
    //rect(tx,ty,w,h);

  }

  void sendGen(int r){
    node[r].matix = new float[mat][mat];
    node[r].matix = (float[][])mutate(this.matix);  
    //println("sendingGen from "+id+" >> "+r);
  }

  void receiveGen(int q){
    this.matix = (mutate(node[q].matix));  
  }

  float[][] mutate(float[][] _matix){
    float [][] mut = new float[mat][mat];
    for(int i = 0;i<mut.length;i++){
      for(int q = 0;q<mut[0].length;q++){
        mut[i][q] = _matix[i][q]; 
      }      
    }

    for(int i=0;i<mutaton;i++){
      int XR = (int)random(mut.length);
      int YR = (int)random(mut[0].length);
      mut[XR][YR]+=(random(0,255)-mut[XR][YR])/2.0;
    }
    return mut;
  }

  void reset(){
    matix = new float[mat][mat];
    for(int i = 0;i < matix.length;i++){
      for(int q = 0;q < matix[i].length;q++){
        this.matix[i][q] = random(0,255);
      }
    }
        
  }

  void move(){
    float up = (matix[0][0]+matix[1][0]+matix[2][0])/3.0f;
    float left = (matix[0][0]+matix[0][1]+matix[0][2])/3.0f;
    float down= (matix[0][2]+matix[1][2]+matix[2][2])/3.0f;
    float right = (matix[2][0]+matix[2][1]+matix[2][2])/3.0f;

    up = norm(up,0,255);
    left = norm(left,0,255);
    down = norm(down,0,255);
    right = norm(right,0,255);

    tx += ((norm(right-left,-0.5f,0.5f)*width)-tx)/speed;
    ty += ((norm(down-up,-0.5f,0.5f)*height)-ty)/speed;

    x+=(tx-x)/speed;
    y+=(ty-y)/speed;

    //bordrs();
  }

  void sipka(){
    t = atan2(ty-y,tx-x);

    pushMatrix();
    translate(1.5f*w,1.5f*w);
    rotate(t);
    pushMatrix();
    fill(255,map(dist(tx,ty,x,y),0,90,0,255));
    stroke(0,map(dist(tx,ty,x,y),0,90,90,255));

    triangle(r+2,-5,r+2,5,1.5f*r+2,0);
    popMatrix();
    popMatrix(); 
  }

  void bordrs(){
    if(x>width-r-1.5f*w){
      x=tx=width-r-1.5f*w;
    }
    if(y>height-r-1.5f*w){
      y=ty=height-r-1.5f*w;
    }
    if(x+1.5f*w<r){
      x=tx=r-1.5f*w;
    }
    if(y+1.5f*w<r){
      y=ty=r-1.5f*w;
    }
  }

  void colors(){
    color c2[] = {
      color(matix[0][0],matix[0][1],matix[0][2]),
      color(matix[1][0],matix[1][1],matix[1][2]),
      color(matix[2][0],matix[2][1],matix[2][2])
      };

      for(int i = 0;i < mat;i++){        
       
	if(!over()){
          fill(c2[i]);
        }
        else{
          fill(hue(c2[i])); 
        }
        rect((int)(i*w),(int)(mat*h+h),w,height-y);
      }
  }

  boolean over(){
    boolean answ = false;
    if((mouseX>x)&& (mouseX<x+w*matix.length)&& (mouseY>y)&& (mouseY<y+h*matix[0].length)){
      answ = true;      
    }
    return answ;
  }
}
