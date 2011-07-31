Recorder r;

int X = 0,Y = 0;

float Xshift = 0.96078444;
float AMP = 7.0588236;

int layers[] = {32*32,16,16,1};

float rate = 100000.0*layers.length;
float sqerr = 1000.0;

PImage img;
PImage result;

ProcessingUnit pu;

boolean learning = true;
boolean test = false;
boolean rec = false;


void setup(){

	img = loadImage("test32.png");

	size(img.width+40,img.height+40,OPENGL);

	pu = new ProcessingUnit(0,0,color(#FFCC00),0);
	pu.createNeurons();

	if(rec)
		r=new Recorder("out","neuroStation.mp4");
}

void draw(){
        
	
	pu.act();
	
	//background(pu.current());
	
	println(sqerr);

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
			ins = new int[pu.n[layer-1].length];
			w = new float[pu.n[layer-1].length];

			for(int i = 0;i<ins.length;i++){
				ins[i] = i;
				w[i] = random(-10,10)/100.0;

			}

		}

	}

	void compute(){

		if(layer>0&&layer<layers.length-1){
			sum = 0;

			for(int i =0;i<ins.length;i++){
				sum+=pu.n[layer-1][i].sum*w[i];
			}
			//sum/=(ins.length+0.0);
			float res = sigmoidal(sum);
			sum = res;
		}else if(layer==0){
			if(!bias){
				sum = pu.IN[id];
			}else{				
					sum = 1.0;
			}
		}else{
			sum = 0;

			for(int i =0;i<ins.length;i++){
				sum+=pu.n[layer-1][i].sum*w[i];
			}

			//sum/=(ins.length+0.0);
			//float res = sigmoidal(sum);
			//sum = res;
			pu.OUT[id] = sum;

		}
	}

	void learn(){
		if(layer>0){
			//load current state
			float ress[] = new float[pu.OUT.length];
			float _w []= new float[w.length];
		
			//backup
			for(int i =0;i<pu.OUT.length;i++){
				ress[i] = pu.OUT[i];
			}

			for(int i =0;i<w.length;i++){
				_w[i]=w[i];
			}

			//comparation
			for(int q =0;q<pu.OUT.length;q++){
				for(int i =0;i<w.length;i++){
					w[i]+=random(-10.0*abs(ress[q]-pu.desire[q]),10.0*abs(ress[q]-pu.desire[q]))/rate;
					w[i] = constrain(w[i],0.0,1.0);

					for(int r1 =0;r1<layers.length;r1++){
						for(int r2 =0;r2<layers[r1];r2++){
							pu.n[r1][r2].compute();
						}
					}

					if(abs(ress[q]-pu.desire[q])<abs(pu.OUT[q]-pu.desire[q]))
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
