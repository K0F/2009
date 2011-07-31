Neuron n[][] = new Neuron[80][320];
Recorder r;
boolean rec = false;
import krister.Ess.*;

import codeanticode.gsvideo.*;

GSPipeline cam;

AudioStream myStream;
float[] streamBuffer;
int y  = 0;

boolean hasPictur = false;

float bluramount = 0.5;

void setup(){
	size(n[0].length,n.length,P2D);
	background(0);

	frameRate(25);

	noSmooth();

	Ess.start(this);

	myStream=new AudioStream();
	myStream.sampleRate(44100/4);
	myStream.bufferSize(width-10);
	streamBuffer=new float[myStream.size];
	myStream.start();



	cam = new GSPipeline(this, "v4l2src ! queue2 ! ffvideoscale !"+"video/x-raw-rgb,width="+(width)+",height="+(height));

	for(int i =0;i<n.length;i++){
		for(int ii =0;ii<n[i].length;ii++){
			n[i][ii] = new Neuron(i,ii);
		}
	}

	noFill();

	if(rec)
		r= new Recorder("brainPix","neuroPix.mp4");
}

void keyPressed()
{
	if(keyCode==UP){
		bluramount+=0.1;
	}else if(keyCode==DOWN){
		bluramount-=0.1;
	}else if(key=='q'){
		if(rec)
			r.finish();
		exit();

	}
	bluramount=constrain(bluramount,0.5,40);
}


void fillAudioBufferL(){
	loadPixels();

	int cnt =0;
	for(int X=10; X<width; X++) {
		streamBuffer[cnt] = map(brightness(pixels[y*width+X]),0,255,-0.9,0.9);
		cnt++;
	}
	/*
	for(int X=width-1; X>=0; X--) {
		streamBuffer[X] = map(brightness(pixels[y*width+X]),0,255,-0.9,0.9);
		cnt++;
		}*/

	//y=(int)((sin(frameCount/30.0)+1.0)*height/2.0);// width/3;//mouseY;
	y=height/2;//y%height;

}

void fillAudioBuffer(){
	loadPixels();


	for(int Y=0; Y<height; Y++) {
		if(Y%2==0){
			for(int X=0; X<width; X++) {
				streamBuffer[Y*width+X] = map(brightness(pixels[Y*width+X]),0,255,-0.9,0.9);
			}
		}else{
			for(int X=width-1; X>=0; X--) {
				streamBuffer[Y*width+X] = map(brightness(pixels[Y*width+X]),0,255,-0.9,0.9);
			}
		}
	}
	//myLowPass=new LowPass(220,-80,4);
	//myLowPass.filter(myStream);
}

void audioStreamWrite(AudioStream theStream) {
	System.arraycopy(streamBuffer,0,myStream.buffer,0,streamBuffer.length);
}

void draw(){
	//background(0);

	hasPictur = false;
	if (cam.available() == true){
		cam.read();
		hasPictur = true;
		//set(0,0,cam);
		//neuroFeed();
	}

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

	if(bluramount>0.5)
		filter(BLUR,bluramount);

	fillAudioBufferL();
	stroke(255,0,0);
	line(0,y,width,y);


	if(rec){
		r.add();
	}


}

public void stop() {
	Ess.stop();
	super.stop();
}

class Neuron{
	int lay,id;
	float vibra,val,val2;
	float r2,g2,b2;
	float r,g,b;
	//float tresh = 240.0;
	//float prum[] = new float[3];

	float tone = 0,amount = 0;
	float[] w;

	Neuron(int _lay,int _id){
		lay = _lay;
		id = _id;
		w = new float[8];
		for(int i =0;i<w.length;i++){
			w[i] = random(90,110)/100.0;//random(400)/100.0;
		}
		vibra = random(800,1000)/10000.0;

		//val = random(255);
		r = g = b = r2 = g2 = b2 = 0;
	}

	void cycle(){

		if(id<=10){
			if(hasPictur){
				r = red(cam.pixels[lay*width+id]);
				g = red(cam.pixels[lay*width+id]);
				b = red(cam.pixels[lay*width+id]);
			}
		}else{
			tone+=vibra;
			amount = 1 + (sin(tone))/40.0;                      
			//amount = 1;
			
			r2 = g2 = b2 = 0.0;

			r2 += n[(lay+n.length-1)%n.length][(id+n[0].length-1)%n[0].length].r*amount*w[0];
			r2 += n[(lay+n.length-0)%n.length][(id+n[0].length-1)%n[0].length].r*amount*w[1];
			r2 += n[(lay+n.length+1)%n.length][(id+n[0].length-1)%n[0].length].r*amount*w[2];

			g2 += n[(lay+n.length-1)%n.length][(id+n[0].length-1)%n[0].length].g*amount*w[0];
			g2 += n[(lay+n.length-0)%n.length][(id+n[0].length-1)%n[0].length].g*amount*w[1];
			g2 += n[(lay+n.length+1)%n.length][(id+n[0].length-1)%n[0].length].g*amount*w[2];

			b2 += n[(lay+n.length-1)%n.length][(id+n[0].length-1)%n[0].length].b*amount*w[0];
			b2 += n[(lay+n.length-0)%n.length][(id+n[0].length-1)%n[0].length].b*amount*w[1];
			b2 += n[(lay+n.length+1)%n.length][(id+n[0].length-1)%n[0].length].b*amount*w[2];

		}
		//val2 += n[(lay+n.length)%n.length][(id+n[0].length-1)%n[0].length].val*amount*w[2];
		//val2 += n[(lay+n.length)%n.length][(id+n[0].length+1)%n[0].length].val*amount*w[3];

		/*

				float Rprum = 0.0;
				prum[(frameCount)%prum.length] = val;
				for(int i = 0;i<prum.length;i++){
					Rprum += prum[i];
				}
				Rprum/=prum.length;

				if(Rprum>=tresh){
					assimilate(0.01,0.00,0.001);
					//val = 1;

					//n[(lay+n.length-1)%n.length][(id+n[0].length-1)%n[0].length].val = 255-val;
				}

		*/
		r2 /= (3.0);
		g2 /= (3.0);
		b2 /= (3.0);

		//if(val<50||val>200)
		stochaist(50.7);


	}
	/*
		void assimilate(float kolik,float kolik2,float kolik3){

			-1,-1 0,-1 1,-1
			-1,0 x,x 1,0
			-1,1 0,1 1,1

			

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
	*/
	void update(){
		if(id>10){
		r += (r2-r)/2.0;
		g += (g2-g)/2.0;
		b += (b2-b)/2.0;

		r= constrain(r,1,254);
		g= constrain(g,1,254);
		b= constrain(b,1,254);
		}
	}

	void draw(){
		stroke(r,g,b);
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
