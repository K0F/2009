import processing.opengl.*;


Recorder r;

String code = "";
float[] rada = new float[0];
float[] uhly = {2.0,-5.0,35.0,-90.0};
float step = 10.0;
float x,y;

boolean rec = false;

void setup(){
	size(800,550,OPENGL);

	x = width-(2*width/PI);
	y = height/2.0;
	code = codeGen(10,0,0,0);

	for(int i =0 ;i<code.length();i++){
		rada = (float[])expand(rada,rada.length+1);
		if(code.charAt(i)=='A'){
			rada[rada.length-1] = uhly[0];
		}else if(code.charAt(i)=='B'){
			rada[rada.length-1] = uhly[1];
		}else if(code.charAt(i)=='C'){
			rada[rada.length-1] = uhly[2];
		}else if(code.charAt(i)=='D'){
			rada[rada.length-1] = uhly[3];
		}
	}
	
	textFont(createFont("Vernda",9));
	//textMode(SCREEN);

	stroke(255,15);
	fill(255,95);
	
	smooth();

	if(rec)
	r = new Recorder("out","output2.mp4");


}


void draw(){
	
	rada[frameCount%rada.length] = mouseX/(10+1.0);
	background(0);

	float[] qasi = rada;
	
	
	for(int q = 1;q<rada.length;q++){
	qasi = randomize(q);
	
		pushMatrix();
	translate(x,y);

	for(int i =0;i<rada.length;i++){
		
		rotate(radians(qasi[i]));
		line(0,0,0,-step);
		translate(0,-step);
	}
	text(q,0,0);
	popMatrix();
	
	}
	
	
	if(rec)
		r.add();



}

void keyPressed(){
	if(key=='q'){
		if(rec)
			r.finish();
		
		exit();
	
	}

}

float[] randomize(int _in){
	return sort(rada,_in);
}



String codeGen(int a,int b,int c,int d){
	String res = "";
	for(int i =0 ;i<a+b+c+d;i++){
		float q =  random(a+b+c+d);
		if(q<=a){
			res+="AAAAA";
		}else if(q<=a+b&&q>a){
			res+="BB";
		}else if(q<=a+b+c&&q>a+b){
			res+="C";
		}else if(q>c&&i>(a+b+c+d)/3.0){
			res+="D";
		}
	}
	return res;
}
