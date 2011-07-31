
int pocet = 8;
int variace = 3;

float zaznam = 0.1;

boolean rec = false;
//Recorder r;
ThinkCenter alph;
PImage input;
PGraphics inna;

float prumer = 0,prumer2 = 0;
float prums[] = new float[pocet];
float prums2[] = new float[pocet];

void setup(){
	size(1000,400,OPENGL);
	background(0);

	alph = new ThinkCenter(pocet,variace);
	input = loadImage("input.png");

	inna = createGraphics(width,height,JAVA2D);
	inna.beginDraw();
	inna.image(input,0,0);
	inna.endDraw();



	textFont(createFont("Veranda",9));
	//textMode(SCREEN);
	//textAlign(RIGHT);

	//	if(rec)
	//		r = new Recorder("out","ai.mp4");

	//noSmooth();
	smooth();
	fill(255);
	
}

void mousePressed(){
	alph = new ThinkCenter(pocet,variace);

}

void draw(){
	//zaznam = mouseX/1000.0;
	stroke(255);
	if((frameCount*zaznam)%width==0){
		fill(0,123);
		rect(0,0,width,height);}
	fill(0);
	rect(0,0,variace*20+2,pocet*10+6);

	alph.stat();
	
	
	if(alph.alive){
		stroke(255,0,0,20);
		line((frameCount*zaznam)%width,0,(frameCount*zaznam)%width,height);
	}
	
	stroke(255,0,0,95);
	line((frameCount*zaznam)%width-1,prumer2*4+height/2,(frameCount*zaznam)%width,prumer*4+height/2);
	
	stroke(255,25);
	for(int i = 0;i<prums.length;i++){
	line((frameCount*zaznam)%width-1,prums2[i]*4+height/2,(frameCount*zaznam)%width,prums[i]*4+height/2);
	}
	
	prumer2 = prumer;
	prums2 = prums;
	
	//	if(rec)
	//		r.add();

	//	alph.degenerate((int)random(alph.n.length));// = new ThinkCenter(pocet,variace);
	//	stroke(255,0,0);
	//	line(((frameCount)*zaznam)%width,0,((frameCount)*zaznam)%width,height);
		//prumer = 0;
		//for(int i = 0;i<alph.n.length;i++){
		//prumer +=	alph.n[i].weight;
	//}
		//}

}

void keyPressed(){
	if(key=='q'){

		//		if(rec)
		//			r.finish();


		exit();
	}else if(key=='1'){
	alph.n[0].degen(0);
	}else if(key=='2'){
	alph.n[0].degen(1);
	}else if(key=='3'){
	alph.n[0].degen(2);
	}

}

class ThinkCenter{
	Neuron n[];
	int num;
	int connex;
	int qa [];
	
	boolean alive = false;
	int alCt = 0;
	
	ThinkCenter(int _num,int _connex){
		//int[] q = inna.pixels;
		num = _num;
		connex = _connex;

		n = new Neuron[num];
		qa =new int[num];
		
		for(int i = 0; i < num;i++){
			qa[i] = (int)random(-100,100);
		}
		
		//qa[5] = 2;

		for(int i = 0; i < num;i++){
			n[i] = new Neuron(i,qa[i%qa.length],connex,num);
		}

	}
	
	void degenerate(int which){
		n[which].degen(0);// = new Neuron(which,qa[which%qa.length],connex,num);
	}

	void stat(){

		//degenerate(0);
		
		int temp[] = new int[num];
		for(int i =0;i<n.length;i++){
		temp[i] = n[i].sum();
		n[i].weight = temp[i];
		}
		
		//all
		
		//for(int i =0;i<n.length;i++){
		//n[i].weight = temp[i];
		//}
		
		
	
	
		for(int i =0;i<n.length;i++){
			//if(mousePressed)
			
			fill(255);
			//text(n[i].weight,10,i*10+10);
			//text(" = ",10,i*10+10);
			
			prumer += (n[i].weight-prumer)/(num*50+1.0);
			prums[i] += (n[i].weight-prums[i])/(num*50+1.0);
			
			for(int q = 0;q<n[i].ins.length;q++){
				fill(map(n[n[i].ins[q]].weight,-100,100,0,255));
				//stroke(map(n[n[i].ins[q]].weight,-100,100,0,255),10);

				text(n[i].ins[q],10+q*20,i*10+10);
				//line(width-5,n[i].ins[q]*10+10,10+q*20,i*10+10);
			}





			//pixe
			/*
			for(int q = 0;q<n[i].ins.length;q++){
				//if(n[n[i].ins[q]].weight>0){
				//	stroke(255,62);}else{stroke(0,62);
				//}
				
				
				stroke(map(n[n[i].ins[q]].weight,-100,100,0,255));
				line(i,q,i+.6,q);
		}*/



		}
	}




}

class Neuron{
	int id;
	int weight;
	int ins[],outs[];


	Neuron(int _id,int _weight, int _con,int _len){
		id = _id;
		weight = _weight;
		ins = new int[_con];
		for(int i =0;i<_con;i++){
			ins[i] = -1;
		}
		for(int i =0;i<_con;i++){
			//	if(i!=id){

			int a = (int)random(_len);
			int counter = 0;

			if(a==id||!checkValidity(a)){
				while(a==id||!checkValidity(a)){
					counter ++;
					a = (int)random(_len);
					if(counter>1000)
						break;
				}
			}

			ins[i] = a;
			//}
		}
	}
	
	void degen(int which){
			int a = (int)random(pocet);
			int counter = 0;

			if(a==id||!checkValidity(a)){
				while(a==id||!checkValidity(a)){
					counter ++;
					a = (int)random(pocet);
					if(counter>1000)
						break;
				}
			}

			ins[which] = a;
	}


	boolean checkValidity(int number){
		boolean answr = true;
		for(int i = 0;i<ins.length;i++){
			if(number==ins[i])
				answr = false;
		}
		return answr;

	}

	int sum(){
		int waaa = weight;
		int _weight = 0;
		for(int i = 0;i<ins.length;i++){
			_weight += alph.n[ins[i]].weight;
			if(_weight>100)_weight = -100;
			if(_weight<-100)_weight = 100;
		}
		//if(_weight>-100&&_weight<100)
		//weight+=(int)((_weight-weight)/20.0);
		//if(abs(weight-_weight)<150)
			waaa += (_weight-waaa)/2.0;
			return waaa;
	}

}




