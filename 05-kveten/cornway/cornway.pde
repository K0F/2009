
boolean rec = false;
Recorder r;

int w = 720/2;
int h = 386/2;
Cell c[] = new Cell[w*h];

float graph[] = new float[w];
float graph2[] = new float[w];

float tps = 0;
float dps = 0;

int loncnt = 0;
int death = 0;

void setup(){
	size(w,h+100,OPENGL);


	for(int Y = 0;Y<h;Y++){
		for(int X = 0;X<w;X++){
			c[Y*w+X] = new Cell(X,Y);
		}
	}

	if(rec)
		r = new Recorder("out","cornwayOnSteroids5.mp4");

	noFill();

	stroke(255);

	textFont(createFont("Veranda",9));


}


void draw(){
	
	fill(0);
	
	rect(0,h,w,100);
	
	
	
	noFill();


	stroke(255,200);
	int oncnt = 0;
	for(int i = 0;i<c.length;i++){
		c[i].act();
		if(c[i].active)
			oncnt++;

	}


	//print("mapa: "+oncnt+" @ ");
	//for(int i =0;i<w/2;i++)
	//print(c[i].state?"A":"B");
	//println(" ");

	
		graph[graph.length-1] = oncnt;
		graph2[graph.length-1] += (oncnt-graph2[graph.length-1])/(7.0);
	

	stroke(#ffcc00);
	float top = 0;
	float bottom = c.length;
	int tp = 0,dp = 0;


	for(int i = 0;i<graph.length;i++){
		if(graph[i]>top){
			top = graph[i];
			tp = i;
		}

		if(graph[i]<bottom&&graph[i]!=0){
			dp = i;
			bottom = graph[i];
		}
	}
	tps += (tp-tps)/3.0;
	dps += (dp-dps)/3.0;


	pushStyle();
	strokeWeight(4);
	for(int i = 0;i<graph.length;i++){

		stroke(#FFcc00,150);

		if(tps<dps){
			if(i>tps&&i<dps)
				stroke(#FFcc00);
		}else{
			if(i>dps&&i<tps)
				stroke(#FFcc00);
		}
		//stroke(#FFcc00,150);
		line(i,map(graph[i],bottom,top,height,h),i,map(graph[(i+graph.length-1)%graph.length],bottom,top,height,h));

		stroke(#FFFFFF,200);
		line(i,map(graph2[i],bottom,top,height,h),i,map(graph2[(i+graph.length-1)%graph.length],bottom,top,height,h));

	}
	popStyle();

	for(int i = 0;i<graph.length-1;i++){
		graph[i] = graph[i+1];
		graph2[i] = graph2[i+1];
	}

	for(int i = 0;i<c.length;i++){
		c[i].update();

	}

	stroke(#FF0000,200);
	line(tps,h+50,tps,h);
	line(dps,h+50,dps,height);

	line(tps,h,dps,height);


	stroke(255,15);
	int step = 1;

	for(int i =0;i<width-step;i+=step){
		pushMatrix();
	translate(i,map(graph2[i],bottom,top,height,h));
	rotate(atan2(map(graph2[i],bottom,top,height,h)-map(graph2[i+step],bottom,top,height,h),-step)+HALF_PI);

	//line(i,map(graph2[i],bottom,top,height,h),i+step,map(graph2[i+step],bottom,top,height,h));
	line(300,0,-300,0);
	popMatrix();
}
	fill(255,20);
	//triangle(tps,h,tps,height,dps,height);
	pushMatrix();
	translate(lerp(tps,dps,0.5),lerp(h,height,0.5));
	rotate(atan2(h-height,tps-dps));
	fill(#ff0000,200);
	text("slope: "+(90-degrees(atan2(height-h,dps-tps)-HALF_PI)),-30,0);
	popMatrix();
	fill(255);
	text("cycle: "+frameCount +" fr.",10,h+12);

	text("population: "+oncnt,10,h+21);
	fill(255,50);
	//arc(dps,height,80,80,atan2(h-height,tps-dps),0);

	
	noStroke();
	fill(0);
	rect(0,0,w,h);
	noFill();
	
	stroke(255);
	rect(0,h,w-1,100-1);
	
	for(int i = 0;i<c.length;i++){
		c[i].draw();
	}
	
	if(loncnt==oncnt){
		death++;
	}else{
		death = 0;
		
	}
	
	
	fill(255);
	if(death>width){
		text("..stable state acheived",width-170,h+10);
	}
	
	if(death>width*2){
		if(rec)
			r.finish();
		
		exit();
	}
	
	loncnt = oncnt;

	if(rec)
		r.add();


}

void keyPressed(){
	if(key=='q'){
		if(rec)
			r.finish();
		exit();
	}
}

class Cell{

	boolean state,active,nextstate;
	int neighs[] = new int[8];
	int x,y;
	int id;
	int alive = 0;

	Cell(int _x,int _y){
		x=_x;
		y=_y;
		id = y*width+x;



		//if(id>w&&id<h*w-w-1){

		int s = 0;
		neighs[0] = ((y+h-1+s)%(h)) * w + ((x+w-1+s)%(w));
		neighs[1] = ((y+h-1+s)%(h)) * w + ((x+w+s)%(w));
		neighs[2] = ((y+h-1+s)%(h)) * w + ((x+w+1+s)%(w));
		neighs[3] = ((y+h+s)%(h)) * w + ((x+w+1+s)%(w));
		neighs[4] = ((y+h+1+s)%(h)) * w + ((x+w+1+s)%(w));
		neighs[5] = ((y+h+1+s)%(h)) * w + ((x+w+s)%(w));
		neighs[6] = ((y+h+1+s)%(h)) * w + ((x+w-1+s)%(w));
		neighs[7] = ((y+h+s)%(h)) * w + ((x+w-1+s)%(w));
		active =true;

		if(random(50)>25){state=true;}else{state=false;}
		//state=false;


		/*}else{
			state=false;
			active = false;
	}*/

	}

	void act(){
		live();
	}

	void live(){
		
			int counter = 0;
			for(int i =0;i<8;i++){
				//	try{
				if(c[neighs[i]].state)
					counter++;
				/*	}catch(ArrayIndexOutOfBoundsException e){
						println(id+" @ "+i+" = "+x+" : "+y);
					}*/
			}


			//elegant algo
			if(!state){
				if(counter==3)
					nextstate = true;



			}else{
				if(counter < 2){
					nextstate = false;
				}else if(counter > 3){
					nextstate = false;
				}
				
			}

			if(nextstate==state){				
				alive++;
			}else{
				alive = 0;
				active = true;
			}

			if(alive>30){
				active = false;
			}
		//		alive = 0;
		//		int s = 0;
		//		nextstate = c[((y+h+s)%(h)) * w + ((x+w+1+s)%(w))].state;
				//c[((y+h+s)%(h)) * w + ((x+w+1+s)%(w))].nextstate = !c[((y+h+s)%(h)) * w + ((x+w+1+s)%(w))].state;
		//	}



		
	}

	void update(){
		state = nextstate;
	}

	void draw(){

		if(state){
			rect(x,y,0.4,0.4);
		}
	}
}



