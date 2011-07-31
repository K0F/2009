class Modul{

	String code = "";
	float[] rada = new float[0];
	float[] uhly = {2.0,-5.0,35.0,-90.0};
	float step = 10.0;
	float x,y;
	int id;

	Modul(float _x,float _y,int _id){
		id = _id;
		x = _x;//width-(2*width/PI);
		y = _y;//height/2.0;
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

	}

	void live(){

		rada[frameCount%rada.length] += (dist(x,y,mouseX,mouseY)/(10+1.0)-rada[frameCount%rada.length])/1.1;
		//
		for(int i = 0;i<m.length;i++){
			if(i!=id)
				rada[frameCount%rada.length] += (m[i].rada[frameCount%rada.length]-rada[frameCount%rada.length])/(m.length+1.0);
		}

		float[] qasi = rada;


		for(int q = 1;q<rada.length;q++){
			qasi = randomize(q);

			pushMatrix();
			translate(x,y);

			for(int i =0;i<rada.length;i++){
				pushStyle();
				if(i==(frameCount%rada.length))
				{
					stroke(#FF0000,55);

				}
				rotate(radians(qasi[i]+(2.0-dist(modelX(0,0,0),modelY(0,0,0),x,y)/6.0)));
				line(0,0,0,-step);
				popStyle();
				translate(0,-step);
			}
			text(q,0,0);
			popMatrix();

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


}
