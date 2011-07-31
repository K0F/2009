int[][] field;
Signal s[];
int NUM = 8;
boolean change[][];

Recorder r;
boolean rec = false;

int tl = 1;

int cout = 0;

void setup(){

	size(720,480,P2D);

	frameRate(25);

	field = new int[width][height];
	for(int ii = 0; ii< field[0].length;ii++){
		for(int i = 0; i< field.length;i++){
			field[i][ii] = 5;//(int)random(8);
			//print(field[i][ii]);
		}
	
	}


	change = new boolean[width][height];
	for(int ii = 0; ii< change[0].length;ii++){
		for(int i = 0; i< change.length;i++){
			change[i][ii] = false;//(int)random(8);
			//print(field[i][ii]);
		}
	}

	s = new Signal[NUM];
	for(int i = 0;i<s.length;i++)
		s[i] = new Signal();


	if(rec){

		r = new Recorder("fields","timeLapse"+tl);
	}

	background(0);

}


void draw(){

	//background(0);

	//colorizeField();

	fade(5);


	change = new boolean[width][height];
	for(int ii = 0; ii< change[0].length;ii++){
		for(int i = 0; i< change.length;i++){
			change[i][ii] = false;//(int)random(8);
			//print(field[i][ii]);
		}
	}
	
	cout = s.length*2;

	for(int i = 0;i<s.length;i++)
		s[i].update();

	for(int i = 0;i<s.length;i++)
		s[i].draw();


	if(rec&&frameCount%tl==0){
		//filter(BLUR,1.5);
		r.add();
	}



}

void keyReleased(){
	if(key=='q'){
		if(rec)
			r.finish();
		exit();
	}
}

void fade(int al){
	fill(0,al);
	noStroke();
	rect(0,0,width,height);
}

void colorizeField(){
	for(int yy = 0;yy<height;yy++){
		for(int xx = 0;xx<width;xx++){
			if(field[xx][yy]%2==0){
				stroke(255,15);
			}else{
				stroke(0,15);

			}
			//stroke(lerpColor(#ff0000,#00ff00,norm(field[xx][yy],0,7) ), 15);
			point(xx,yy);
		}
	}

}

class Signal{

	int x,y;
	int nx,ny;

	Signal(){
		x = (int)random(width);
		y = (int)random(height);

	}

	Signal(int _x,int _y){
		x = _x;
		y = _y;

	}

	void update(){

		if(field[x][y]==0){
			nx = (x + width - 1)%width;
			ny = (y + height - 1)%height;
		}else if(field[x][y]==1){
			nx = (x + width + 0)%width;
			ny = (y + height - 1)%height;
		}else if(field[x][y]==2){
			nx = (x + width + 1)%width;
			ny = (y + height - 1)%height;
		}else if(field[x][y]==3){
			nx = (x + width + 1)%width;
			ny = (y + height + 0)%height;
		}else if(field[x][y]==4){
			nx = (x + width + 1)%width;
			ny = (y + height + 1)%height;
		}else if(field[x][y]==5){
			nx = (x + width + 0)%width;
			ny = (y + height + 1)%height;
			
		}else if(field[x][y]==6){
			nx = (x + width - 1)%width;
			ny = (y + height + 1)%height;
		}else if(field[x][y]==7){
			nx = (x + width - 1)%width;
			ny = (y + height + 0)%height;
		}

		if(!change[x][y]){
			field[x][y] = (field[x][y]+2)%8;//(int)random(4);
			change[x][y] = true;
		}
		
		if(frameCount%10==0&&s.length<=cout&&random(100)<5){
			
			expa();
		}
	
		x = nx;
		y = ny;

	}

	void expa(){
		s = (Signal[])expand(s,s.length+1);
		s[s.length-1] = new Signal((x+1)%width,y);
	}

	void draw(){
		pushMatrix();
		translate(x,y);
		stroke(255,120);
		point(0,0);
		popMatrix();

	}

	int computeNextStep(){
		int tmp = 0;


		return tmp;
	}



}
