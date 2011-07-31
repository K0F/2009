Neuron n[][] = new Neuron[262/2][420/2];


void setup(){
	size(4*n[0].length,4*n.length,P2D);
	background(0);

	for(int i =0;i<n.length;i++){
		for(int ii =0;ii<n[i].length;ii++){
			n[i][ii] = new Neuron(i,ii);
		}
	}
	
	noFill();
	noCursor();

}


void draw(){
	background(0);
	
	for(int i =0;i<n.length;i++){
		for(int ii =0;ii<n[i].length;ii++){
			n[i][ii].cycle();
		}
	}
	
	
	for(int i =0;i<n.length;i++){
		for(int ii =0;ii<n[i].length;ii++){
			n[i][ii].update();
		}
	}
	
	
	for(int i =0;i<n.length;i++){
		for(int ii =0;ii<n[i].length;ii++){
			pushMatrix();
			translate(ii*4,i*4);
			n[i][ii].draw();
			popMatrix();
		}
	}
}

class Neuron{

	int lay,id;
	float vibra,val,val2;
	float tone = 0,amount = 0;
	float[] w;

	Neuron(int _lay,int _id){
		lay = _lay;
		id = _id;
		w = new float[n.length];
		for(int i =0;i<w.length;i++){
			w[i] = random(400)/100.0;
		}
		vibra = random(1,1000)/10000.0;
		val = random(255);
	}

	void cycle(){
		tone+=vibra;
		amount = (sin(tone)+1.0)/2.0;

		if(lay>=1){
			val2 = 1.0;

			for(int i =0;i<w.length;i++){
				val2 += n[lay-1][i].val*amount*w[i];
			}
			val2 /= (w.length+0.0);
		}else{
			val2 = n[n.length-1][id].val;
		
		}
	}
	
	void update(){
		val += (val2-val)/1.01;
		val = constrain(val,1,254);
	}
	
	void draw(){
		stroke(lerpColor(#0a0a0a,#f7fd58,val/(255.0)));
		rect(0,0,3,3);
	
	
	}




}
