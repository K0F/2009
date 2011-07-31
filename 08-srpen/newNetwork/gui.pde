class Buttons{
  int x,y,w,h,col;
  String label;
  PImage pic;
  Buttons(int x, int y, int w, int h, int col, String label, PImage pic){
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    this.col = col;
    this.label = label;
    this.pic = pic;
  }
  void draw(){
    stroke(0);
    fill(0);
    int xup,yup;
    if(over()){
      if(mousePressed){
        xup = x-1;
        yup = y-1;
      }
      else{
        xup = x-4;
        yup = y-4;
      }
    }
    else{
      xup = x;
      yup = y;
    }
    rect(x,y,w,h);
    if(pic == null){
      fill(col);
      rect(xup,yup,w,h);
    }
    else{
      image(pic,xup,yup,w,h);
    }
    if (label.length() > 0){
      fill(0);
      text(label,xup+2,yup+18);
    }
  }
  boolean over(){
    if (mouseX <= x+w && mouseX >= x && mouseY <= y+h && mouseY >= y){
      return true;
    }
    else{
      return false;
    }
  }
}

