float uhly[] = {2.0,-3.0,0.0};
Branch kmen;
Branch vetve[];

color c;

void setup(){

	size(400,400,P3D);

	c = color(255);

	vetve = new Branch[0];
	kmen = new Branch(2.0);
	
	stroke(c);
}

void draw(){
	background( 255-brightness(c) );

	kmen.live();


}

class Branch{
	float loms [];
	float step;

	int id;
	int parId;

	float rx,ry,x,y;
	float xes[],yes[];

	String code =  "";
	float settings[] = new float[0];
	int newBranch[] = new int[0];


	//kmen constructor
	Branch(float _step){

		gen(10,10,10,5);

		loms=settings;
		yes=new float[loms.length];
		xes=new float[loms.length];
		step = _step;
		id = 0;
		x=rx=width/2.0;
		y=ry=height;
		live();
		
		for(int i =0 ;i<newBranch.length;i++){
			vetve = (Branch[])expand(vetve,vetve.length+1);
			vetve[vetve.length-1] = new Branch(1.0,i+1,0);
		}
	}

	Branch(float _step,int _id,int _parId){
		gen(10,10,10,5);
		loms=settings;

		step = _step;
		id = _id;
		parId = parId;
		yes=new float[loms.length];
		xes=new float[loms.length];
		//x=rx=parent.xes[t.newBranch[id]];
		//y=ry=parent.yes[t.newBranch[id]];
		println("branch no. "+id+" created");
		x=rx=kmen.xes[newBranch[id]];
		y=ry=kmen.yes[newBranch[id]];
	}

	void live(){
		rx=x;
		ry=y;

		pushMatrix();

		translate(rx,ry);
		for(int i = 0;i<loms.length;i++){

			yes[i]=modelY(0,0,0);
			xes[i]=modelX(0,0,0);

			translate(0,-step);

			ry+=step;



			rotate(radians(loms[i]));

			for(int q = 0;q<newBranch.length;q++){
				if(i==newBranch[q]){
					rect(0,0,3,3);
				}
				
			}
			
			line(0,0,0,-step);
		}

		popMatrix();


	}


	void gen(int _a,int _b,int _c,int _d){
		code =  "";
		code = codeGen(_a,_b,_c,_d);

		newBranch = new int[0];
		settings = new float[0];


		for(int i =0 ;i<code.length();i++){
			settings = (float[])expand(settings,settings.length+1);
			if(code.charAt(i)=='A'){
				settings[settings.length-1] = uhly[0];
			}else if(code.charAt(i)=='B'){
				settings[settings.length-1] = uhly[1];
			}else if(code.charAt(i)=='C'){
				settings[settings.length-1] = uhly[2];
			}else if(code.charAt(i)=='D'){
				newBranch = (int[])expand(newBranch,newBranch.length+1);
				newBranch[newBranch.length-1] = i;
			}
		}
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
