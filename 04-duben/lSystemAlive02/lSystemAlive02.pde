import processing.opengl.*;

PImage hand;
float[] uhly = {-45,7,0};
int num = 40;

Totem t[] = new Totem[0];
Recorder r;

boolean rec = false;

String src;
int cnt = 0;

void setup(){
	size(720,486,OPENGL);


	hand = loadImage("hand.png");
	stroke(255,20);
	background(0);

	//if(rec)
		r = new Recorder("out","lsys.mp4");
	
	xpa();

}

void xpa(){

	src = "";
	for(int i =0 ;i<num;i++){
		float q =  random(1000);
		if(q<=333){
			src+="CCCCCCCCC";
		}else if(q<=900&&q>333){
			src+="BBC";
		}else if(q<=1000&&q>900){
			src+="A";
		}
	}

	t = (Totem[])expand(t,t.length+1);
	t[t.length-1] =  new Totem(src,width/2,height/2);


}

void keyPressed(){
	if(key=='q'){
		if(rec)
			r.finish();
		exit();
	}else if(key=='r'){
	rec=true;
	}
	keyPressed = false;
}

void mousePressed(){

	xpa();
}

void draw(){
	background(0);

	//fill(0,85);
	//rect(0,0,width,height);
	
	for(int i=0;i<t.length;i++){
		t[i].live();                                                                                      
		//t[i].degen();
		}
		
		if(rec)
			r.add();

}



class Totem{
	float sx,sy,xx,yy;
	String code;
	char repo[];
	float step = 2;
	int last;
	boolean fin = false;
	float uhlyQ[];
	float qx=0,qy=0,rr=0;
	
	Totem(String _a,float _x,float _y){
		code = _a+"";
		xx=sx = _x;
		yy=sy = _y;
		uhlyQ = uhly;
		
		/*
		for(int i = 0;i<uhlyQ.length;i++){
			uhlyQ[i]+=random(-10,10)/10.0;
		}*/
		
		qx=mouseX/10.0;
		qy=mouseY/100.0;
	}
	
	

	void degen(){
		
		
		

		int  len = code.length();
		//		println(len);
		repo = new char[len];

		last = code.lastIndexOf("C");


		for(int i =0;i<len;i++){
			repo[i] = code.charAt(i);
		}

		code = "";

		for(int i =0;i<len;i++){
			if(last!=i){
				code+=repo[i];
			}else{
				code+='A';
			}
		}
		
	}

	void live(){
		sy=yy;
		sx=xx;
		
		strokeWeight(2);
		
		step +=random(-100,100)/10000.0;
		
		for(int i = 0;i<uhlyQ.length;i++){
			uhlyQ[i]+=random(-10,10)/10000.0;
		}
		
		qx += (mouseX/100.0-qx)/100.0;
		qy += (mouseY/1000.0-qy)/100.0;
		//rr += 30*(dist(pmouseX,pmouseY,mouseX,mouseY)-rr)/3000.0;

		int e = code.lastIndexOf("C");

		pushMatrix();

		translate(sx,sy);
		for(int i = 0;i<code.length();i++){

			translate(0,step);

			sy-=step;

			if(code.charAt(i)=='A'){
				rotate(radians(uhlyQ[0])+qy);
			}else if(code.charAt(i)=='B'){
				rotate(radians(uhlyQ[1]+qx));
			}else if(code.charAt(i)=='C'){
				rotate(radians(uhlyQ[2]));
			}
			//	if(i>e&&frameCount%15==0)
			line(0,0,0,step);
			//line(-5,0,5,0);
		}
		
		float scal = 10.0;
		image(hand,(-hand.width/scal/2.0)-10,0,hand.width/scal,hand.height/scal);



		popMatrix();

	}

}
