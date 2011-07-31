Neuron n[][] = new Neuron[200][200];


void setup(){
	size(n[0].length,n.length,P2D);
	background(0);

	for(int i =0;i<n.length;i++){
		for(int ii =0;ii<n[i].length;ii++){
			n[i][ii] = new Neuron(i,ii);
		}
	}

	noFill();


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
			translate(ii,i);
			n[i][ii].draw();
			popMatrix();
		}
	}




}

void mouseDragged(){
	n[mouseY][mouseX].val =255;

}

class Neuron{

	int lay,id;
	float vibra,val,val2;
	float tone = 0,amount = 0;
	float[] w  = new float[8];

	float prum[] = new float[3];
	float tresh = 230.0;

	Neuron(int _lay,int _id){
		lay = _lay;
		id = _id;

		for(int i =0;i<w.length;i++){
			w[i] = random(440)/100.0;
		}

		vibra = random(90000,100000)/1000000.0;
		tone = random(100.0)/100.0;
		amount = random(100.0)/100.0;
		
		
		val = 128;//random(255);
		
	}

	void cycle(){
		tone+=vibra;
		amount = (sin(tone)+1.0)/2.0;


		val2 = 0.0;

		/**
		-1,-1 0,-1 1,-1
		-1,0 x,x 1,0
		-1,1 0,1 1,1

		*/

		val2 += n[(lay+n.length-1)%n.length][(id+n[0].length-1)%n[0].length].val*amount*w[0];
		val2 += n[(lay+n.length-1)%n.length][(id+n[0].length)%n[0].length].val*amount*w[1];
		val2 += n[(lay+n.length-1)%n.length][(id+n[0].length+1)%n[0].length].val*amount*w[2];

		val2 += n[(lay+n.length)%n.length][(id+n[0].length-1)%n[0].length].val*amount*w[3];
		val2 += n[(lay+n.length)%n.length][(id+n[0].length+1)%n[0].length].val*amount*w[4];

		val2 += n[(lay+n.length+1)%n.length][(id+n[0].length-1)%n[0].length].val*amount*w[5];
		val2 += n[(lay+n.length+1)%n.length][(id+n[0].length)%n[0].length].val*amount*w[6];
		val2 += n[(lay+n.length+1)%n.length][(id+n[0].length+1)%n[0].length].val*amount*w[7];

		/*

		val2 += n[lay-1][(id+n[0].length-2)%n[0].length].val*amount*w[0];
		val2 += n[lay-1][(id+n[0].length-1)%n[0].length].val*amount*w[1];
		val2 += n[lay-1][id].val*amount*w[2];
		val2 += n[lay-1][(id+n[0].length+1)%n[0].length].val*amount*w[3];
		val2 += n[lay-1][(id+n[0].length+2)%n[0].length].val*amount*w[4];
		*/

		val2 /= (w.length+0.0);
		
		
		
		float Rprum = 0.0;
		prum[(frameCount)%prum.length] = val;
		for(int i = 0;i<prum.length;i++){
			Rprum += prum[i];
		}
		Rprum/=prum.length;

		if(Rprum>=tresh){
			assimilate(0.0,0.01,0.0);
			//val = 1;
			
			//n[(lay+n.length-1)%n.length][(id+n[0].length-1)%n[0].length].val = 255-val;
		}
		stochaist(20);

	}

	void update(){
		val += (val2-val)/2.01;
		val = constrain(val,1,254);

		



	}

	void stochaist(float kolik){
		for(int i =0;i<w.length;i++){
			w[i]+=random(-kolik,kolik)/1000.0;
		w[i] = constrain(w[i],0.01,4.0);
		}
	}

	void assimilate(float kolik,float kolik2,float kolik3){

		/**
		-1,-1 0,-1 1,-1
		-1,0 x,x 1,0
		-1,1 0,1 1,1

		*/
		
		// synchronize to vibra val
		n[(lay+n.length-1)%n.length][(id+n[0].length-1)%n[0].length].vibra += (vibra-n[(lay+n.length-1)%n.length][(id+n[0].length-1)%n[0].length].vibra)*kolik;
		n[(lay+n.length-1)%n.length][(id+n[0].length)%n[0].length].vibra += (vibra-n[(lay+n.length-1)%n.length][(id+n[0].length)%n[0].length].vibra)*kolik;
		n[(lay+n.length-1)%n.length][(id+n[0].length+1)%n[0].length].vibra += (vibra-n[(lay+n.length-1)%n.length][(id+n[0].length+1)%n[0].length].vibra)*kolik;

		n[lay][(id+n[0].length-1)%n[0].length].vibra += (vibra-n[lay][(id+n[0].length-1)%n[0].length].vibra)*kolik;
		n[lay][(id+n[0].length+1)%n[0].length].vibra += (vibra-n[lay][(id+n[0].length+1)%n[0].length].vibra)*kolik;

		n[(lay+n.length+1)%n.length][(id+n[0].length-1)%n[0].length].vibra += (vibra-n[(lay+n.length+1)%n.length][(id+n[0].length-1)%n[0].length].vibra)*kolik;
		n[(lay+n.length+1)%n.length][(id+n[0].length)%n[0].length].vibra += (vibra-n[(lay+n.length+1)%n.length][(id+n[0].length)%n[0].length].vibra)*kolik;
		n[(lay+n.length+1)%n.length][(id+n[0].length+1)%n[0].length].vibra += (vibra-n[(lay+n.length+1)%n.length][(id+n[0].length+1)%n[0].length].vibra)*kolik;



		// approx. counter weights
		n[(lay+n.length-1)%n.length][(id+n[0].length-1)%n[0].length].w[7] += (w[0]-n[(lay+n.length-1)%n.length][(id+n[0].length-1)%n[0].length].w[7])*kolik2;
		n[(lay+n.length-1)%n.length][(id+n[0].length)%n[0].length].w[6] += (w[1]-n[(lay+n.length-1)%n.length][(id+n[0].length)%n[0].length].w[6])*kolik2;
		n[(lay+n.length-1)%n.length][(id+n[0].length+1)%n[0].length].w[5] += (w[2]-n[(lay+n.length-1)%n.length][(id+n[0].length+1)%n[0].length].w[5])*kolik2;

		n[lay][(id+n[0].length-1)%n[0].length].w[4] += (w[3]-n[lay][(id+n[0].length-1)%n[0].length].w[4])*kolik2;
		n[lay][(id+n[0].length+1)%n[0].length].w[3] += (w[4]-n[lay][(id+n[0].length+1)%n[0].length].w[5])*kolik2;

		n[(lay+n.length+1)%n.length][(id+n[0].length-1)%n[2].length].w[2] += (w[5]-n[(lay+n.length+1)%n.length][(id+n[0].length-1)%n[0].length].w[2])*kolik2;
		n[(lay+n.length+1)%n.length][(id+n[0].length)%n[1].length].w[1] += (w[6]-n[(lay+n.length+1)%n.length][(id+n[0].length)%n[0].length].w[1])*kolik2;
		n[(lay+n.length+1)%n.length][(id+n[0].length+1)%n[0].length].w[0] += (w[7]-n[(lay+n.length+1)%n.length][(id+n[0].length+1)%n[0].length].w[0])*kolik2;
		
		
		// (experimental) approx. tones
		n[(lay+n.length-1)%n.length][(id+n[0].length-1)%n[0].length].w[0] += (w[7]-n[(lay+n.length-1)%n.length][(id+n[0].length-1)%n[0].length].tone)*kolik3;
		n[(lay+n.length-1)%n.length][(id+n[0].length)%n[0].length].w[1] += (w[6]-n[(lay+n.length-1)%n.length][(id+n[0].length)%n[0].length].tone)*kolik3;
		n[(lay+n.length-1)%n.length][(id+n[0].length+1)%n[0].length].w[2] += (w[5]-n[(lay+n.length-1)%n.length][(id+n[0].length+1)%n[0].length].tone)*kolik3;

		n[lay][(id+n[0].length-1)%n[0].length].w[3] += (w[4]-n[lay][(id+n[0].length-1)%n[0].length].tone)*kolik3;
		n[lay][(id+n[0].length+1)%n[0].length].w[4] += (w[3]-n[lay][(id+n[0].length+1)%n[0].length].tone)*kolik3;

		n[(lay+n.length+1)%n.length][(id+n[0].length-1)%n[0].length].tone += (tone-n[(lay+n.length+1)%n.length][(id+n[0].length-1)%n[0].length].tone)*kolik3;
		n[(lay+n.length+1)%n.length][(id+n[0].length)%n[0].length].tone += (tone-n[(lay+n.length+1)%n.length][(id+n[0].length)%n[0].length].tone)*kolik3;
		n[(lay+n.length+1)%n.length][(id+n[0].length+1)%n[0].length].tone += (tone-n[(lay+n.length+1)%n.length][(id+n[0].length+1)%n[0].length].tone)*kolik3;
	}

	void draw(){
		stroke(lerpColor(#000000,#ffffff,val/(255.0)));
		point(0,0);


	}




}
