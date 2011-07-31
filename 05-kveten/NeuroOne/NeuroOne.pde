Recorder r;

float Xshift = 0.96078444;
float AMP = 7.0588236;

int layers[] = {2,2,2,3};

float rate = 100000.0*layers.length;
float sqerr = 1000.0;

PImage img;
PImage result;

ProcessingUnit pu[];

boolean learning = true;
boolean test = false;
boolean rec = false;


void setup(){

	img = loadImage("test32.png");

	size(img.width+40,img.height+40,OPENGL);

	if(test){
		pu = new ProcessingUnit[1];
		
		
		pu[0] = new ProcessingUnit(0,0,color(#FFCC00),0);
		pu[0].createNeurons();

	}else{
		pu = new ProcessingUnit[img.pixels.length];


		int cntr = 0;
		for(int y = 0;y<img.height;y++){
			for(int x = 0;x<img.width;x++){
				pu[cntr] = new ProcessingUnit(x,y,color(img.pixels[cntr]),cntr);
				pu[cntr].createNeurons();
				cntr++;

			}
		}
	}
	
	if(rec)
		r=new Recorder("out","neuroStation.mp4");
}



void draw(){


	if(test){
		
		pu[0].act();
		background(pu[0].current());
		println(sqerr);
		
	}else{

		background(0);

		pushMatrix();
		translate(20,20);


		for(int x =0;x<img.width;x++){
			for(int y =0;y<img.height;y++){

				int which = y*img.width+x;
				pu[which].act();

				stroke(pu[which].current());
				line(x,y,x+1,y);
			}
		}

		popMatrix();


		println(sqerr);

	}
	
	if(rec)
		r.add();

}

void keyPressed(){
	if(key == 'q'){
		if(rec)
			r.finish();
		exit();
	
	}else if(key=='l'){
		learning = !learning;
	}

}




class Neuron{
	float w[];
	int ins[];
	int id,layer;
	float sum;
	float err = 0.0;
	int puid;
	boolean bias = false;

	Neuron(int _id,int _layer,int _puid,boolean _bias){

		bias = _bias;
		id = _id;
		layer = _layer;
		puid = _puid;

		if(layer==0){
			ins = new int[1];
			ins[0] = 0;
			w = new float[1];
			w[0] = 1.0;
		}

		if(layer>0){
			ins = new int[pu[puid].n[layer-1].length];
			w = new float[pu[puid].n[layer-1].length];

			for(int i = 0;i<ins.length;i++){
				ins[i] = i;
				w[i] = random(0,100)/100.0;

			}

		}

	}

	void compute(){

		if(layer>0&&layer<layers.length-1){
			sum = 0;

			for(int i =0;i<ins.length;i++){
				sum+=pu[puid].n[layer-1][i].sum*w[i];
			}
			//sum/=(ins.length+0.0);
			float res = sigmoidal(sum);
			sum = res;
		}else if(layer==0){
			if(!bias){
			sum = pu[puid].IN[id];
			}else{
				if(id%2==0){
			sum = 1;}else{
			sum = 0;
			}
			}
		}else{
			sum = 0;

			for(int i =0;i<ins.length;i++){
				sum+=pu[puid].n[layer-1][i].sum*w[i];
			}

			//sum/=(ins.length+0.0);
			//float res = sigmoidal(sum);
			//sum = res;
			pu[puid].OUT[id] = sum;

		}
	}

	void learn(){
		if(layer>0){
			//load current state
			float ress[] = new float[pu[puid].OUT.length];
			float _w []= new float[w.length];

			for(int i =0;i<pu[puid].OUT.length;i++){
				ress[i] = pu[puid].OUT[i];
			}

			for(int i =0;i<w.length;i++){
				_w[i]=w[i];
			}


			for(int q =0;q<pu[puid].OUT.length;q++){
				for(int i =0;i<w.length;i++){
					w[i]+=random(-10.0*abs(ress[q]-pu[puid].desire[q]),10.0*abs(ress[q]-pu[puid].desire[q]))/rate;
					w[i] = constrain(w[i],0.0,1.0);

					for(int r1 =0;r1<layers.length;r1++){
						for(int r2 =0;r2<layers[r1];r2++){
							pu[puid].n[r1][r2].compute();
						}
					}

					if(abs(ress[q]-pu[puid].desire[q])<abs(pu[puid].OUT[q]-pu[puid].desire[q]))
						w[i] = _w[i];

				}
			}



		}
	}

}

float sigmoidal(float inputValue){
	return(float)((Xshift/((Xshift)+Math.exp(AMP*(inputValue)))));
}

float derivative(float input){
	return(1.0-(sigmoidal(input)*(1.0-sigmoidal(input)))*4.0);
}
