
Structure s;
int compose[] = {2,2,2};

void setup(){

	size(200,200);
	background(0);

	s = new Structure(compose);


}

class Structure{

	int id,layer;
	int[] outs;
	float[] w;
	boolean active = true;
	int globid = 0;


	Neuron n[] = new Neuron[0];
	int[] model;

	Structure(int[] _model){
		model = _model;

		for(int i =0;i<model.length;i++){
			for(int q =0;q<model[i];q++){
				n = (Neuron[])expand(n,n.length+1);
				n[n.length-1] = new Neuron(i,this);
			}

		}

	}


	int act(int[] args){
		if(args.length==model[0]){
			for(int i =0;i<args.length;i++){
				n[i].val = args[i];
			}
		}else{
			print("incorrect no. of ins: "+args.length);
		}

	}


}

class Neuron{

	
	float x,y;
	int id,layer;
	int[] ins;
	float[] w;
	float val;
	boolean active = true;
	Structure parent;

	Neuron(int _layer, Structure _parent){
		layer = _layer;
		
		parent = _parent;
		
		id = parent.globid;
		parent.globid++;
		
		if(layer==0){
			// input lay creation
			w = new float[1];
			w[0] = 1.0;


		}else if(layer<parent.model.length-1){
			//hidden lay creation

			ins = new int[parent.model[layer-1]];
			w = new float[ins.length];

			for(int i = 0;i<ins.length;i++){
				ins[i] = n[parent.model[layer-1]].id;
				w[i] = random(-2.0,2.0);
			}


		}else{
			//output lay creation

			ins = new int[parent.model[layer-1]];
			w = new float[ins.length];

			for(int i = 0;i<ins.length;i++){
				ins[i] = i;
				w[i] = random(-2.0,2.0);
			}
		}

		//println("neuron no."+id+" created");


	}
	
	

	void compute(){
		val = 0;
		for(int i =0;i<parent.model[layer-1];i++){
			val += parent.n[ins[i]].val*w[i];
		}

	}
}


// toxi's

public float sigmoid(float x, float normV, float sharpness) {
	x=(x/normV*2-1)*5*sharpness;
	return 1.0f / (1.0f + (float)Math.exp(-x));
}


public double sigmoid(double x, double normV, double sharpness) {
	x=(x/normV*2-1)*5*sharpness;
	return 1.0 / (1.0 + Math.exp(-x));
}

// kof mod

float sigmoid2(float x, float norm, float slope) {
	x = (x / norm * 2 - 1) * 5 * slope;
	return (float) (1.0/( 1.0 + Math.pow( Math.E ,(-1.0 * x ))));
}


float derivative(float input,float norm,float slope){

	return(float)(1.0-(sigmoid2(input,norm,slope)*(1.0-sigmoid2(input,norm,slope)))*4.0);
}
