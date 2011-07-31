
PImage img;

Recorder r;
boolean rec = false;

int num1 = 32;
int num2 = 32;

Neuron n[][];
Neuron in[] = new Neuron[2];
Neuron out[] = new Neuron[3];
float rs[],gs[],bs[];

void setup(){

	size(50*2,50,OPENGL);

	img = loadImage("kandinsky2.png");


	rs = new float[img.pixels.length];
	gs = new float[img.pixels.length];
	bs = new float[img.pixels.length];

	n = new Neuron[2][num1];

	for(int i = 0;i<n.length;i++){
		for(int w = 0;w<n[i].length;w++){
			if(i==0){
				n[i][w] = new Neuron(w,2,i);
			}else{
				n[i][w] = new Neuron(w,n[i].length,i);
			}
		}
	}

	in[0] = new Neuron(0,2,-1);
	in[1] = new Neuron(1,2,-1);

	out[0] = new Neuron(0,num1,-2);
	out[1] = new Neuron(1,num1,-2);
	out[2] = new Neuron(2,num1,-2);

	if(rec)
		r = new Recorder("out",in.length+"x"+num1+"x"+num1+"x"+out.length+"mp4");

}

void draw(){
	background(0);
	image(img,img.width,0);

	for(int y = 0;y<img.height;y++){
		for(int x = 0;x<img.width;x++){
			in[0].listen(x*50);
			in[1].listen(y*50);


			//inputs
			for(int i = 0;i<in.length;i++){
				in[i].compute();
			}


			//layers
			for(int i = 0;i<n.length;i++){
				for(int w = 0;w<n[i].length;w++){
					n[i][w].compute();
				}
			}

			//outputs
			for(int i = 0;i<out.length;i++){
				out[i].compute();
			}


			rs[y*img.width+x] = 0.5*abs(out[0].sum-red(img.pixels[y*img.width+x]));
			gs[y*img.width+x] = 0.5*abs(out[1].sum-green(img.pixels[y*img.width+x]));
			bs[y*img.width+x] = 0.5*abs(out[2].sum-blue(img.pixels[y*img.width+x]));



			noFill();
			stroke(out[0].sum,out[1].sum,out[2].sum);
			rect(x,y,1,1);

			int which = y*img.width+x;//(int)random(img.pixels.length);//y*img.width+x;
			backProp(out[0],250,map(rs[which] ,0,255,1,0.0));
			backProp(out[1],250,map(gs[which] ,0,255,1,0.0));
			backProp(out[2],250,map(bs[which] ,0,255,1,0.0));

		}
	}


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

void backProp(Neuron _n,float rate,float target){
	Neuron current = _n;

	int top = 0;
	float vals = 0;

	for(int i =0;i<current.ins.length;i++){
		if(vals<current.weights[i]){
			vals = current.weights[i];//127-abs(current.weights[i]*n[1][current.ins[i]].sum-current.sum);
			top = i;
		}

		//current.weights[i]+=((2-target)-current.weights[top])/rate;
	}

	current.weights[top]+=(target-current.weights[top])/rate;

	Neuron next = n[1][current.ins[top]];
	vals = 0;
	top = 0;

	for(int i =0;i<next.ins.length;i++){
		if(vals<next.weights[i]){
			vals = next.weights[i];//127-abs(next.weights[i]*n[1][next.ins[i]].sum-next.sum);
			top = i;
		}
		//next.weights[i]+=((2-target)-next.weights[top])/rate;
	}

	next.weights[top]+=(target-next.weights[top])/rate;

	Neuron next2 = n[0][next.ins[top]];
	vals = 0;
	top = 0;

	for(int i =0;i<next2.ins.length;i++){
		if(vals<next2.weights[i]){
			vals = next2.weights[i];//127-abs(next2.weights[i]*n[1][next2.ins[i]].sum-next2.sum);
			top = i;
		}
		//next2.weights[i]+=((2-target)-next2.weights[top])/rate;
	}

	next2.weights[top]+=(target-next2.weights[top])/rate;

}


class Neuron{

	float x,y;
	int id,layer;
	int ins[];

	boolean active = true;

	float sum,sum2,rate = 20.0;
	float tresh;
	float weights[];

	Neuron(int _id,int _num,int _layer){
		id = _id;
		layer = _layer;

		tresh = 1.5;

		if(layer!=-2){
			x = layer*50+100;
			y = _id*5+5;
		}else{
			x = -layer*50+100;
			y = _id*5+5;
		}



		ins = new int[_num];
		weights = new float[_num];

		for(int i =0;i<weights.length;i++){
			weights[i] = random(0,100)/100.0;
			ins[i] = i;
		}


	}

	void listen(int a){
		sum = a;
	}

	void compute(){

		//	weights[i]+=random(100.0)/1000.0;

		for(int i = 0;i<weights.length;i++)
			weights[i] = constrain(weights[i],0,1);

		switch (layer){

		case -2:
			sum2 = 0;
			for(int i =0;i<ins.length;i++){
				//weights[i]+=random(100.0)/1000.0;

					sum2+=n[-layer-1][i].sum*weights[i];
				
			}
			
			//sum2=sum2/(ins.length+0.0);
			sum+=(sigmoidal(sum2)-sum)/rate;

			break;

		case 1:
			sum2 = 0;
			for(int i =0;i<ins.length;i++){
				//weights[i]+=random(-100.0,100.0)/10000.0;

					sum2+=n[layer-1][i].sum*weights[i];
				
			}
			//sum2=sum2/(ins.length+0.0);
			sum+=(sigmoidal(sum2)-sum)/rate;


			if(sum>tresh){
				active=true;
			}else{
				active = false;
			}

			break;

		case 0:
			sum2=((in[0].sum*weights[0])+(in[1].sum*weights[1]));
			//sum2=sum2/(ins.length+0.0);
			sum+=(sigmoidal(sum2)-sum)/rate;



			break;

		}

	}
	
	float sigmoidal(float inputValue){
		/*
			method just takes input as some real number and calculates the sigmoidal function of that value and return the same.
		*/
		return(float)((1.0/(1.0+Math.exp(-1.0*inputValue))));
		
		
	}


	void act(){

		compute();

		noFill();
		if(active){
			stroke(255,0,0);
		}else{
			stroke(255);
		}

		rect(x,y,3,3);



		stroke(255,20);

		if(layer>0){
			for(int i =0;i<ins.length;i++){
				line(n[layer-1][ins[i]].x,n[layer-1][ins[i]].y,x,y);
			}
		}else if(layer == 0){
			for(int i =0;i<ins.length;i++){
				line(in[ins[i]].x,in[ins[i]].y,x,y);
			}
		}else if(layer == -2){
			for(int i =0;i<ins.length;i++){
				line(n[-layer-1][ins[i]].x,n[-layer-1][ins[i]].y,x,y);
			}
		}


	}

}

