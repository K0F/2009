

float boom = 0.96078444;//-1.00622;//-1.0056844;//-1.010625;
float TRESH = 6.1764708;// 0.675;

float INSCALE = 1.0;

/////////////////////////////////////////////////////
/////////////////////////////////////////////////////

int layers[];
Neuro n[][];

float mapperR = 1.0,mapperG = 1.0,mapperB = 1.0;

float IN[];
float OUT[];

boolean learning = true;

PImage img;
Recorder r;
boolean rec = false;

float sqerr = 255.0;
float er[];//,eg[],eb[];

/////////////////////////////////////////////////////
/////////////////////////////////////////////////////

void setup(){
	img = loadImage("kandinsky3.png");

	layers= new int[3];
	layers[0] = (img.width);
	layers[1] = (int)(img.width*0.3);
	layers[2] = (img.width);


	size(img.width+40,img.height+40,OPENGL);

	er = new float[img.width];
	//eg = new float[img.pixels.length];
	//eb = new float[img.pixels.length];

	reset();

	noFill();
	rectMode(CENTER);

	if(rec){
		String name = "";
		for(int i =0;i<layers.length;i++){
			if(i>0)
				name+="x";
			name+=layers[i];
		}
		name+=".mp4";
		r = new Recorder("out",name);
	}
	

}

/////////////////////////////////////////////////////
/////////////////////////////////////////////////////

void draw(){

	background(0);

	//interact();

	pushMatrix();
	translate(20,20);

	for(int y = 0;y<img.height;y++){
		for(int x = 0;x<img.width;x++){

			int which = y*img.width+x;
			IN[x] = x;//brightness(img.pixels[which]);//+random(-5,5);
			
			globComp();
			
			er[x] = abs(brightness(img.pixels[which])-OUT[x]);
			sqerr+=(er[x]-sqerr)/(img.pixels.length+0.0);
			
			stroke(OUT[x]);
			line(x,y,x+1,y);

		}
	}
	
		popMatrix();

	




	if(learning){

		for(int y = 0;y<img.height;y++){
			for(int x = 0;x<img.width;x++){


				float power = (img.pixels.length+0.0);
				backProp(n[n.length-1][0],
				         (er[x]),
				         power);
					 
					 //println();

			}
		}
		//exit();

		//if(frameCount%100==0)
			println(sqerr);

	}




	if(rec)
		r.add();


}

void globComp(){
	for(int i = 0;i<n.length;i++){
		for(int q = 0;q<n[i].length;q++){
			n[i][q].compute();
		}
	}

}

/////////////////////////////////////////////////////
/////////////////////////////////////////////////////

void reset(){

	n = new Neuro[layers.length][0];
	for(int i = 0;i<n.length;i++){
		for(int q = 0;q<layers[i];q++){
			n[i] = (Neuro[])expand(n[i],n[i].length+1);
			if(i==0&&q==layers[0]-1){
				n[i][q] = new Neuro(0);
			}else{
			n[i][q] = new Neuro(i,q);
			}
		}
	}

	IN = new float[layers[0]];
	OUT = new float[layers[layers.length-1]];



}


/////////////////////////////////////////////////////
/////////////////////////////////////////////////////


void interact(){
	TRESH = map(mouseX,0,width,0,100);
	//TRESH = 0.68;
}


/////////////////////////////////////////////////////
/////////////////////////////////////////////////////


void mousePressed(){
	println(boom+" : "+TRESH+" : "+INSCALE);
	reset();

}


/////////////////////////////////////////////////////
/////////////////////////////////////////////////////


void keyPressed(){
	if(key=='w')
	{	saveWeights();
	}else if(key=='r'){
		loadWeights();
	}else if(key == 'l'){
		learning=!learning;
	}else if(key=='q'){
		if(rec)
			r.finish();
		exit();
	}


}

/////////////////////////////////////////////////////
/////////////////////////////////////////////////////

float sigmoidal(float inputValue){

	//println((mouseX-width/2.0)+":"+(mouseY-height/2.0));
	return(float)((boom/((boom)+Math.exp(TRESH*(inputValue)))));

}

/////////////////////////////////////////////////////
/////////////////////////////////////////////////////

float derivative(float input){

	return(1.0-(sigmoidal(input)*(1.0-sigmoidal(input)))*4.0);
}

/////////////////////////////////////////////////////
/////////////////////////////////////////////////////

void saveWeights(){

	String data[] = new String[0];
	data = (String[])expand(data,data.length+1);
	data[data.length-1] = ":";

	for(int i =0;i<n.length;i++){
		data[data.length-1] += " "+layers[i];
	}

	for(int i =1;i<n.length;i++){


		for(int q =0;q<n[i].length;q++){
			data = (String[])expand(data,data.length+1);
			data[data.length-1] = i+" "+q+" :";
			for(int r = 0;r<n[i][q].w.length;r++)
				data[data.length-1] += " "+n[i][q].w[r]*10000000.0;
		}
	}


	String name = "";
	for(int i =0;i<layers.length;i++){
		if(i>0)
			name+="x";
		name+=layers[i];
	}

	saveStrings(name+".txt",data);
	println("state saved");
}

/////////////////////////////////////////////////////
/////////////////////////////////////////////////////

void loadWeights(){
	String name = "";
	for(int i =0;i<layers.length;i++){
		if(i>0)
			name+="x";
		name+=layers[i];
	}

	String[] data = loadStrings(name+".txt");

	String header = data[0]+"";
	String code[] = splitTokens(header," :");
	boolean valid = false;

	int err = 0;
	if(code.length==layers.length){
		for(int i = 0;i<code.length;i++){
			if(parseInt(code[i])!=layers[i])
				err+=1;
		}
	}

	if(err==0){
		valid = true;
	}



	if(valid){
		for(int i =1;i<data.length;i++){
			String radek = data[i]+"";
			String temp[] = splitTokens(radek,",: ");
			int lay = parseInt(temp[0]);
			int which = parseInt(temp[1]);
			for(int q = 0;q<n[lay][which].w.length;q++){
				n[lay][which].w[q] = parseFloat(temp[q+2])/10000000.0;
			}

		}
		println("new weight set loaded");
	}else{
		println("data in file do not represent a data for current network");
	}

}


/////////////////////////////////////////////////////
/////////////////////////////////////////////////////


void backProp(Neuro _first,float target,float rate){
	Neuro temp = _first;

	//input layer has no weights
	//if(temp.id>counts[0]){

	for(int q =0;q<n.length-1;q++){

		int rr = (int)random(temp.ins.length);
		float best = temp.w[rr];
		int which = rr;

		for(int i =0;i<temp.ins.length;i++){
			if(temp.w[i] > best){
				best =temp.w[i];
				which = i;
			}
		}

		//if(q>0)
		temp.w[which]+=(target-temp.w[which])/(rate);
		Neuro last = temp;
		temp = n[last.layer-1][last.ins[which]];


	}

}

/////////////////////////////////////////////////////
/////////////////////////////////////////////////////

void drawFunction(){
	stroke(255);
	for(int i =0;i<width;i++){
		rect(i,(sigmoidal(i/(width+0.0)))*height,1,1);
	}
}

/////////////////////////////////////////////////////
/////////////////////////////////////////////////////

class Neuro{

	float x,y,w[],tresh;
	int id,ins[],layer;
	float sum,sum2;
	boolean biased = false;

	Neuro(int _layer,int _id){

		id = _id;
		layer = _layer;

		if(layer!=0){
			ins = new int[n[layer-1].length];
			w =  new float[ins.length];


			if(layer==n.length-1){
				int g = 0;
				for(int i =0;i<n[layer-1].length;i++){
					ins[g] = i;
					w[g] = random(-500,500)/1000.0;
					g++;
				}
			}else{

				int g = 0;
				for(int i =0;i<n[layer-1].length;i++){
					ins[g] = i;
					w[g] = random(-500,500)/1000.0;
					g++;
				}
			}


		}

		x = id*10;
		y = layer *10;

		tresh = TRESH;
	}
	
	Neuro(int _bias){
		layer = 0;
		id = layers[0]-1;
		sum = _bias;
		biased = true;
	}

	/////////////////////////////////////////////////////
	/////////////////////////////////////////////////////

	void compute(){



		if(layer!=0){

			//for(int i =0;i<w.length;i++){//w[i]+=random(-10,10)/10000000.0;
				//w[i] = constrain(w[i],-1,1);}

			sum2 = 0;

			if(layer>0&&layer<n.length-1){
				for(int i = 0;i<ins.length;i++){
					sum2+=w[i]*n[layer-1][ins[i]].sum;
				}
				sum2/=(ins.length+0.0);
				sum2 = sigmoidal(sum2);

			}else{

				for(int i = 0;i<ins.length;i++){
					sum2+=(w[i]*n[layer-1][ins[i]].sum);
				}
				
				//sum2/=ins.length;

				//if(layer==n.length-1)
				
			}

			//sum2 = 
			sum = sum2;//(sum2-sum)/10.51;
		}else{
			if(!biased)
			sum = IN[id];
		}

		if(layer == layers.length-1){
			OUT[id] = sum;
		}

	}

	/////////////////////////////////////////////////////
	/////////////////////////////////////////////////////

	void act(){

		if(layer!=0)
			for(int i = 0;i<ins.length;i++){
				stroke(255,w[i]*12700000);
				line(n[layer-1][ins[i]].x,n[layer-1][ins[i]].y,x,y);
			}

		stroke(255,sum);
		rect(x,y,3,3);
	}
}
