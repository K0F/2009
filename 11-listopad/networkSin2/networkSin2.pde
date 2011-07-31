Neuron n[][] = new Neuron[480][720];
Recorder r;
boolean rec = false;

void setup(){
	size(n[0].length,n.length,P2D);
	background(0);

	for(int i =0;i<n.length;i++){
		for(int ii =0;ii<n[i].length;ii++){
			n[i][ii] = new Neuron(i,ii);
		}
	}

	noFill();

	if(rec)
		r= new Recorder("brainPix","neuroPix.mp4");
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

	if(rec){
		r.add();
	}
}

void keyPressed(){
	if(key=='q'){
		if(rec)
			r.finish();
		exit();
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
		w = new float[3];

		for(int i =0;i<w.length;i++){
			w[i] = random(400)/100.0;
		}

		vibra = random(800,1000)/10000.0;

		val = random(255);
	}

	void cycle(){
		tone+=vibra;
		amount = (sin(tone)+1.0)/2.0;

		val2 = 0.0;

		val2 += n[(lay+n.length-1)%n.length][(id+n[0].length-1)%n[0].length].val*amount*w[0];
		val2 += n[(lay+n.length-1)%n.length][(id+n[0].length)%n[0].length].val*amount*w[1];
		val2 += n[(lay+n.length-1)%n.length][(id+n[0].length+1)%n[0].length].val*amount*w[2];

		//val2 += n[(lay+n.length)%n.length][(id+n[0].length-1)%n[0].length].val*amount*w[2];
		//val2 += n[(lay+n.length)%n.length][(id+n[0].length+1)%n[0].length].val*amount*w[3];

		val2 /= (w.length+0.0);
		//stochaist(10.0);
	}

	void update(){
		val += (val2-val)/1.0;
		val = constrain(val,1,254);
	}

	void draw(){
		stroke(lerpColor(#000000,#f7fd58,val/(255.0)));
		point(0,0);


	}

	void sync(float kolik){
		n[(lay+n.length+1)%n.length][id].amount += (amount-n[(lay+n.length+1)%n.length][id].amount)*(map(val,0,255,0,kolik));
		n[(lay+n.length+1)%n.length][id].vibra += (vibra-n[(lay+n.length+1)%n.length][id].vibra)*(map(val,0,255,0,kolik));
		n[(lay+n.length+1)%n.length][id].tone += (tone-n[(lay+n.length+1)%n.length][id].tone)*(map(val,0,255,0,kolik));


	}

	void stochaist(float kolik){
		for(int i =0;i<w.length;i++){
			w[i]+=random(-kolik,kolik)/1000.0;
			//vibra+=random(-kolik,kolik)/1000.0;
			w[i] = constrain(w[i],0.01,5.0);
		}
	}




}
