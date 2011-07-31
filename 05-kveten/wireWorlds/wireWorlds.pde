int X, Y;

Recorder r;
boolean rec = false;

int top = 4;
int numx = 320/top,numy = 240/top;

Cell c[][] = new Cell[numx*top][numy*top];
color col[] = {color(0),color(50),color(120),color(255)};

int shiftx=0,shifty=0;

int scaler = 4;
String filename;

void setup(){
	size(320,240,OPENGL);
	background(0);

	noCursor();

	filename =  "machines/looper2_"+c.length+"x"+c[0].length;

	frameRate(30);

	for(int y=0;y<c[0].length;y++){
		for(int x=0;x<c.length;x++){
			c[x][y] = new Cell(x,y);
		}
	}

	//if(rec){
		r = new Recorder("out","cellularComuter.mp4");
	//}


	//for(int x=0;x<c.length;x++){
	//	c[x][30].state=1;
	//}

	noStroke();


}

void loadState(){
	try{
		String temp[] = loadStrings(filename+".txt");

		for(int y=0;y<c[0].length;y++){
			for(int x=0;x<c.length;x++){
				c[x][y].state = parseInt(temp[y].charAt(x))-48;
			}
		}

	}catch(NullPointerException e){
		println("no such a file, please save before");
	}
	println("machine loaded: "+filename+".txt");
}

void saveState(){

	String data[] = new String[0];

	for(int y=0;y<c[0].length;y++){
		data = (String[])expand(data,data.length+1);
		data[data.length-1] = "";
		for(int x=0;x<c.length;x++){
			data[data.length-1]+=c[x][y].state!=0?"1":"0";
		}
	}

	saveStrings(filename,data);
	println("saved as: "+filename+".txt");


}


void loadStateFromImage(){
	try{
		PImage temp = loadImage(filename+".png");


		if(temp.width==c.length&&temp.height==c[0].length){

			c = new Cell[numx*top][numy*top];

			for(int y=0;y<c[0].length;y++){
				for(int x=0;x<c.length;x++){
					c[x][y] = new Cell(x,y);
					if((brightness(color(temp.pixels[y*temp.width+x]))) != 0.0){
						c[x][y].state=1;
					}else{
						c[x][y].state=0;
					}
				}
			}

			println("state loaded sucessfully from: "+filename+".bmp");



		}else{
			println("error: stored values does not correpondent to dimensions");

		}

	}catch(NullPointerException e){
		println("error: saved record does not found " +e);
	}


}



void saveStateToImage(){
	PImage temp = createImage(c.length,c[0].length,RGB);


	for(int y=0;y<c[0].length;y++){
		for(int x=0;x<c.length;x++){
			if(c[x][y].state>0){temp.pixels[y*temp.width+x]=color(255);}else{temp.pixels[y*temp.width+x]=color(0);}
		}
	}

	temp.save(filename+".bmp");
	println("state saved as image: "+filename+".bmp");


}

void draw(){

	background(0);

	step(1);


	pushMatrix();
	translate(-shiftx,-shifty);


	for(int y=0;y<c[0].length;y++){
		for(int x=0;x<c.length;x++){
			c[x][y].draw();
		}
	}

	noFill();
	stroke(255);
	rect(-1,-1,1,1);
	rect(c.length*scaler+1,-1,1,1);
	rect(-1,c[0].length*scaler+1,1,1);
	rect(c.length*scaler-1,c[0].length*scaler+1,1,1);
	noStroke();

	popMatrix();



	X = constrain((int)((mouseX/scaler)+shiftx/scaler),0,c.length-1);
	Y = constrain((int)((mouseY/scaler)+shifty/scaler),0,c[0].length-1);

	c[X][Y].sel=true;

	if(mousePressed){
		if(mouseButton==LEFT)
			c[X][Y].state=1;
		if(mouseButton==RIGHT)
			c[X][Y].state=0;
		if(mouseButton==3){
			c[X][Y].state=3;
			mousePressed=false;
		}
	}


	if(rec){
		r.add();
	}
}

void keyPressed(){
	if(key==' '){
		for(int y=0;y<c[0].length;y++){
			for(int x=0;x<c.length;x++){
				c[x][y].calm();
			}

		}
	}else if(key=='='){
		scaler++;
	}else if(key=='-'){
		scaler--;
	}else if(key =='s'){
		saveState();
	}else if(key =='l'){
		loadState();
	}else if(keyCode==LEFT){
		shiftx-=3;
	}else if(keyCode==RIGHT){
		shiftx+=3;
	}else if(keyCode==UP){
		shifty-=3;
	}else if(keyCode==DOWN){
		shifty+=3;
	}else if(keyCode==DELETE){
		for(int y=0;y<c[0].length;y++){
			for(int x=0;x<c.length;x++){
				c[x][y].state=c[x][y].nextState=0;
			}
		}
	}else if(keyCode==ENTER){
		c[X][Y].state=3;


	}else if(keyCode == 155){
		saveStateToImage();

	}else if(keyCode==36){
		loadStateFromImage();
	}else if(key == 'q'){

		if(rec){
			r.finish();
		}
		exit();
	}else if(key == 'a'){
		rec=!rec;
	}


	scaler=constrain(scaler,1,top);
	keyPressed=false;
}

void step(int n){
	boolean anim = false;
	for(int y=0;y<c[0].length;y++){
		for(int x=0;x<c.length;x++){
			if(c[x][y].state>1){
				anim=true;
				break;
			}
		}
	}

	if(anim){
		if(frameCount%n==0){
			for(int y=0;y<c[0].length;y++){
				for(int x=0;x<c.length;x++){
					c[x][y].act();
				}
			}

			for(int y=0;y<c[0].length;y++){
				for(int x=0;x<c.length;x++){
					c[x][y].update();
				}
			}
		}
	}

}

class Cell{
	//state 0=black, 1=wire, 2= tail, 3=head
	int state = 0;
	int nextState = 0;
	int x,y;
	boolean sel = false;

	Cell(int _x,int _y){
		x=_x;
		y=_y;
	}

	void act(){
		compute();


	}

	void draw(){



		if(state>0){

			noStroke();
			fill(col[state]);
			rect(x*scaler,y*scaler,scaler,scaler);
		}

		if(sel){
			stroke(255);
			fill(col[state]);
			rect(x*scaler,y*scaler,scaler,scaler);
		}
		sel=false;



	}

	void compute(){

		//is wire?
		if(state>0){

			if(state==3){
				nextState = 2;
			}else if(state==2){
				nextState=	1;
			}else if(state==1){
				nextState=1;

				int q = getStates(3);
				if(q==1||q==2){
					nextState=3;
				}
			}

		}else{
			nextState=0;
		}

	}

	void update(){
		state=nextState;
	}

	int getStates(int wh){
		int cnt = 0;

		if(c[(x+c.length-1)%c.length][(y+c[0].length-1)%c[0].length].state==wh)cnt++;
		if(c[(x+c.length)%c.length][(y+c[0].length-1)%c[0].length].state==wh)cnt++;
		if(c[(x+c.length+1)%c.length][(y+c[0].length-1)%c[0].length].state==wh)cnt++;
		if(c[(x+c.length+1)%c.length][(y+c[0].length)%c[0].length].state==wh)cnt++;
		if(c[(x+c.length+1)%c.length][(y+c[0].length+1)%c[0].length].state==wh)cnt++;
		if(c[(x+c.length)%c.length][(y+c[0].length+1)%c[0].length].state==wh)cnt++;
		if(c[(x+c.length-1)%c.length][(y+c[0].length+1)%c[0].length].state==wh)cnt++;
		if(c[(x+c.length-1)%c.length][(y+c[0].length)%c[0].length].state==wh)cnt++;

		return cnt;

	}

	void calm(){

		if(state>0){
			nextState=1;
			update();
		}

	}
}
