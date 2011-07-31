
Neuron n[];
Neuron outs[];

int total;
float rs[],gs[],bs[];

PImage img;

float noiss[][];

int counts[] = { 2,32,16,3 };

float learnRate = 12000;

float treshold = 1.0;
float netEcho = 10.0;

void backProp(Neuron _first,float target,float rate){
	Neuron temp = _first;
	
	//input layer has no weights
	//if(temp.id>counts[0]){

		for(int q =0;q<counts.length;q++){

			float best = 0;
			int which = 0;

			for(int i =0;i<temp.ins.length;i++){
				if(temp.w[i]*n[temp.ins[i]].sum>best){
					best = temp.w[i]*n[temp.ins[i]].sum;
					which = i;
				}
				//temp.w[i]*=0.99999;
			}

			temp.w[which]+=(target-temp.w[which])/rate;//(target - temp.w[which])/rate;
			Neuron last = temp;
			temp = n[last.ins[which]];

		}
		
		
	//}
}


void setup(){

	size(512,320,P3D);


	img = loadImage("kandinsky2.png");

	rs = new float[img.pixels.length];
	gs = new float[img.pixels.length];
	bs = new float[img.pixels.length];
	noiss = new float[2][img.pixels.length];
	
	for(int i =0;i<noiss[0].length;i++){
		noiss[0][i] = random(255);
		noiss[1][i] = random(255);
	}
	
	total = 0;

	for(int i = 0; i < counts.length; i++){
		total+=counts[i];
	}
	//println(total-1);
	n = new Neuron[total];

	int iid = 0;
	int layer = 0;
	for(int i = 0; i < counts.length; i++){

		for(int w = 0; w < counts[i]; w++){

			if(i==0)
				n[iid] = new Neuron(iid,20+iid*10,20);
			if(i==1)
				n[iid] = new Neuron(iid,20+iid*10-20,100,0,1);
			if(i==2)
				n[iid] = new Neuron(iid,20+iid*10-340,180,1);
			if(i==3)
				n[iid] = new Neuron(iid,20+iid*10-(340+160),260,true);

			//println(iid+" = "+i);

			iid++;
		}

	}

	outs = new Neuron[counts[3]];
	for(int i = 0; i < outs.length; i++){
		outs[i] = n[n.length-i-1];
	}

	noFill();
	stroke(255);




}

void draw(){

	
	
	background(0);
	noFill();

	for(int y = 0;y<img.width;y++){

		for(int x = 0;x<img.width;x++){

			n[0].listen(noiss[0][y*img.width+x]);
			n[1].listen(noiss[1][y*img.width+x]);


			//pushMatrix();
			//translate(img.width*2,0);
			for(int i = 2; i < n.length; i++){
				n[i].compute();
			}
			//popMatrix();

			

			int which = y*img.width+x;
			rs[which] =  abs( red(img.pixels[which]) -  outs[0].sum );
			gs[which] = abs( green(img.pixels[which]) - outs[1].sum );
			bs[which] = abs(  blue(img.pixels[which]) - outs[2].sum );

				
			pushMatrix();
			translate(20,20);
			stroke(outs[0].sum,outs[1].sum,outs[2].sum);
			rect(x,y,1,1);
			popMatrix();
			
			backProp(n[n.length-1],map(rs[which],0,255,2,0),learnRate);
			backProp(n[n.length-2],map(gs[which],0,255,2,0),learnRate);
			backProp(n[n.length-3],map(bs[which],0,255,2,0),learnRate);
			

		}
	}
	

	pushMatrix();
	translate(img.width*2,0);
	for(int i = 0; i < n.length; i++){
		n[i].act();
	}
	popMatrix();
}



class Neuron{

	float x,y,w[];
	int id,ins[];
	int layer;
	float sum,ssum;
	boolean active = true;
	float tresh = treshold;
	

	//types


	//input layer neuron
	Neuron(int _id,float _x,float _y){

		layer = 0;
		x=_x;
		y=_y;
		id=_id;

		ins = new int[1];
		w = new float[1];
		ins[0] = 0;w[0] = 0;

	}


	//1st layer
	Neuron(int _id,float _x,float _y,int a, int b){

		layer = 1;
		x=_x;
		y=_y;
		id=_id;

		ins = new int[2];
		w = new float[2];

		ins[0] = a;
		ins[1] = b;

		w[0] = random(0,200)/100.0;
		w[1] = random(0,200)/100.0;
	}


	//2nd .. nNd layer neuron
	Neuron(int _id,float _x,float _y,int _layer){

		layer = 2;
		x=_x;
		y=_y;
		id=_id;

		ins = new int[getLayerCount(_layer)];
		ins = getLayerIDs(_layer);
		w = new float[ins.length];

		for(int i = 0; i < w.length; i++){
			w[i] = random(0,200)/100.0;
		}




	}


	//output layer neuron
	Neuron(int _id,float _x,float _y,boolean last){
		layer = 3;
		x=_x;
		y=_y;
		id=_id;

		ins = new int[getLayerCount(2)];
		ins = getLayerIDs(2);

		w = new float[ins.length];
		for(int i = 0; i < w.length; i++){
			w[i] = random(0,200)/100.0;
		}

	}




	int[] getLayerIDs(int _wha){

		int g = getLayerCount(_wha);
		int l1[] = new int[g];


		int cnt = 0;
		for(int i =0;i<n.length;i++){
			if(n[i]!=null){
				if(n[i].layer==_wha){
					l1[cnt]=i;cnt++;}}
		}

		int temp[] = new int[g];

		for(int i =0;i<ins.length;i++){
			temp[i] = l1[i];
		}

		return temp;

	}

	int getLayerCount(int _wha){

		int g = 0;
		for(int i =0;i<n.length;i++){
			if(n[i]!=null){
				if(n[i].layer==_wha)
					g++;}
		}
		return g;
	}

	void compute(){
		
		for(int i =0;i<w.length;i++){
			//w[i]*=1+random(-100,100)/1000.0;
			w[i] = constrain(w[i],0,20);
		}
		
		//tresh = treshold;

		if(id>1){
			ssum = 0;

			for(int i =0;i<ins.length;i++){
				if(n[ins[i]].active)
				ssum += n[ins[i]].sum*w[i];
			}

			sum += ((ssum/(ins.length+0.01))-sum)/netEcho;

			
			if(sum>tresh){
				active = true;
				//sum=ssum;

			}else{
				active = false;
			}
		}


	}

	void listen(float q){
		sum = q;
	}

	void act(){


		//	compute();

		if(active){
			stroke(255);
		}else{
			stroke(120,0,0);
		}
		rect(x,y,3,3);


		for(int i = 0; i < ins.length; i++)
		{
			stroke(255,w[i]*10.0);
			line(n[ins[i]].x,n[ins[i]].y,x,y);

		}
	}




}
