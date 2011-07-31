
float [][] matice;
Determinant d[];

void setup(){
	size(200,200,OPENGL);
	background(0);

	matice = new float[width][height];

	for(int y = 0;y<height;y++){
		for(int x = 0;x<width;x++){
			matice[x][y] = random(1000)*0.001;

		}
	}
	
	noSmooth();

	d = new Determinant[width];

	for(int i =0;i<d.length;i++)
		d[i] = new Determinant(i);


}


void draw(){
	fill(0,10);
	rect(0,0,width,height);
	
	
	for(int c = 0;c<height;c++)
		for(int i =0;i<d.length;i++){
		d[i].display();
		d[i].nextStep();
	}


}

void redistribute(){
for(int y = 0;y<height;y++){
		for(int x = 0;x<width;x++){
			matice[x][y] += random(-100,100)*0.01;
			matice[x][y] = constrain(matice[x][y],0,1);

		}
	}

}

void keyPressed(){

	if(key == ' '){
		//d = null;
		//	d = new Determinant();

	}

}

class Determinant{
	int x,y;
	int id;
	//float mem = 0;
	color c;

	Determinant(int _id){
		id = _id;
		c = color(255);
		reset();
		

	}

	void reset(){
		
		x = id;//(int)random(width);
		y = 0;
		

	}

	void nextStep(){
		/*
		if((matice[x][y])<0.001){
			// matice[(x+1)%(width-1)][y] = 0.09;//random(1000.0)*0.001;
			x-=1;
			
			
		}else if((matice[x][y])>0.999){
			//matice[x][y] = matice[(x+1)%(width-1)][y];
			//matice[(x+width-2)%(width-1)][y] = 0.91;//random(1000.0)*0.001;
			
			x+=1;
			
			
			
		}*/
		x+=(int)(random(-20,20)/18.0);
		
		
		
		if(x<0)x=width-1;
		if(x>width-1)x=0;
		
		
		matice[(x+1)%(width-1)][y]+=random(-100,100)*0.0001;
		matice[(x+width-2)%(width-1)][y]+=random(-100,100)*0.0001;
		matice[x][y]=constrain(matice[x][y],0,1);

		if(y<height-1){
			
				
			y+=1;
			
		}else{
			reset();
			//if(id==0)
				//redistribute();
		}


	}

	void display(){
		stroke(c,10);
		line(x,y,x,y+1);

	}


}
