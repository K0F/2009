
Recorder r;

int matrix[];
int W = 360;
int H = 288;

int sel = 0;
int X=0,Y=0;

PGraphics marks;

void init() {
  /// to make a frame not displayable, you can 
  // use frame.removeNotify() 
  frame.removeNotify(); 
 
  frame.setUndecorated(true); 
 
  // addNotify, here i am not sure if you have  
  // to add notify again.   
  frame.addNotify(); 
  super.init();
}

void setup(){

	size(W,H,OPENGL);
	loadMatrix();
	
	r = new Recorder("out","order.mp4");

	marks = createGraphics(W,H,P2D);
	marks.beginDraw();
	marks.background(0);
	marks.stroke(255);
	marks.point(getPosition(matrix[sel])[0],getPosition(matrix[sel])[1]);
	marks.endDraw();



}


void draw(){
	image(marks,0,0);
	for(int i =1;i<20;i++){
		arrow(X+i,Y,getPosition(matrix[sel+i])[0],getPosition(matrix[sel+i])[1],(int)(255-(i*10)));

	}
	if(frameCount%3==0){
		
		
		marks.beginDraw();
		//marks.stroke(255);
		//marks.point(getPosition(matrix[sel])[0],getPosition(matrix[sel])[1]);
		marks.stroke(255,20);

		marks.line(X,Y,getPosition(matrix[sel])[0],getPosition(matrix[sel])[1]);
		marks.noStroke();
		marks.fill(255,20);

		marks.pushMatrix();
		marks.translate(getPosition(matrix[sel])[0],getPosition(matrix[sel])[1]);
		marks.rotate(atan2(getPosition(matrix[sel])[1]-Y,getPosition(matrix[sel])[0]-X)+HALF_PI);
		marks.triangle(0,0,-3,8,3,8);
		marks.popMatrix();
		marks.endDraw();
		

		X+=10;
		sel+=10;
	}

	if(X>=width){
		X=0;
		Y+=10;
	}

	if(Y >= height){
		r.finish();
		exit();
	}
	
	r.add();

}

void keyPressed(){
	if(key == 'q'){
		r.finish();
		exit();
	
	
	}

}

int[] getPosition(int pos){
	int[] res = {(pos%width),(int)(pos/(width+0.0))};
	return res;

}

void arrow(int x,int y, int x2, int y2,int alp){
	stroke(255,alp);

	line(x,y,x2,y2);
	noStroke();
	fill(255,alp);

	pushMatrix();
	translate(x2,y2);
	rotate(atan2(y2-y,x2-x)+HALF_PI);
	triangle(0,0,-2,9,2,9);
	popMatrix();



}


void loadMatrix(){
	String[] tmp = loadStrings("../translator/data/matix"+W+"x"+H+".txt");
	matrix = new int[tmp.length];

	for(int y = 0;y<tmp.length;y++){

		matrix[y] = parseInt(tmp[y]);

	}
	println("matrix.loaded");

}
