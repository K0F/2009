import codeanticode.gsvideo.*;



GSMovieMaker mm;

boolean rec = false;

int num = 50;
Node node[];

int op = 60;

PImage shade,high;

void setup(){
  size(7*op,5*op,OPENGL);
  background(0);
  node = new Node[num];
  frame.setTitle("QadGenz 8");
  for(int i = 0;i < node.length;i++){
    node[i] = new Node(i);
  }
  smooth();
frameRate(3);

 // textFont(createFont("Tahoma",9));
  shade = loadImage("shade3.png");
  high = loadImage("high.png");
  //smooth();
  //frame.setLocation(0,screen.height-height); //works 
mm = new GSMovieMaker(this,width,height,"out/out.avi",GSMovieMaker.X264,GSMovieMaker.BEST,25);
if(rec)
	mm.start();
}


void draw(){
  float w = node[0].w;
  background(15); //#5a6a7a
  
   pushMatrix();
    translate(-((node[node.length-1].x+node[node.length-1].tx)/2.0f)+width/2,
    -((node[node.length-1].y+node[node.length-1].ty)/2.0f)+height/2);
  for(int i = 0;i < node.length;i++){
      
      
    /*image(shade,node[which].x-shade.width/4+(1.5*w),node[which].y-shade.height/4+(1.5*w),
     shade.width/2,shade.height/2);
     */
   
     node[i].run();
     
    
   // fill(255,155);
   // text("#"+(node.length-i),(int)node[i].x+3*w,(int)node[i].y);

    if(mousePressed&&node[i].over()){
      node[i].sendGen(node[i].which);
      mousePressed=false;
    }
  }
   popMatrix();

if(rec){
		loadPixels();
		mm.addFrame(pixels);
if(frameCount>25*60*5){
mm.dispose();
		exit();
}
	}

}

void keyPressed(){
	if(key == 'q'){

		if(rec){
			mm.finish();
		}
		mm.dispose();
		exit();

	}
}
