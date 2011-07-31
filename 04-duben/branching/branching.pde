import processing.opengl.*;

Tree t;
Branch b[] = new Branch[0];

void setup(){
	size(400,300,P3D);

	stroke(0,85);
	t = new Tree(new float[]{2.0,-3.0,0.0});
}

void draw(){
	background(255);
	t.live();
}

class Tree{

	String code =  "";
	float settings[] = new float[0];
	int newBranch[] = new int[0];

	float uhly[] = {2.0,-3.0,0.0};

	Tree(float _uhly[]){
		uhly=_uhly;
		
		
		
		gen();
		
		println(code);
		println("branchesAt:");
		println(newBranch);

		b = (Branch[])expand(b,b.length+1);
		b[b.length-1] = new Branch(1.0,settings,0);

		if(newBranch!=null)
			for(int i = 0;i<newBranch.length;i++){
				gen();
				b = (Branch[])expand(b,b.length+1);
				b[b.length-1] = new Branch(1.0,settings,i,0);

			}
	}

	void live(){
		for(int i =0;i<b.length;i++){
			b[i].live();
		}
	}
	
	
		void gen(){
			code =  "";
			code = codeGen(20,20,30,5);

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

class Branch{
	float loms [];
	float step;
	int id;
	int parId;
	float rx,ry,x,y;
	float xes[],yes[];

	Branch(float _step,float[] _loms,int _id){
		loms=_loms;
		yes=new float[loms.length];
		xes=new float[loms.length];
		step = _step;
		id = _id;
		x=rx=width/2.0;
		y=ry=height;
		live();
	}

	Branch(float _step,float[] _loms,int _id,int _parId){
		loms=_loms;
		step = _step;
		id = _id;
		parId = parId;
		yes=new float[loms.length];
		xes=new float[loms.length];
		//x=rx=parent.xes[t.newBranch[id]];
		//y=ry=parent.yes[t.newBranch[id]];
		println("branch no. "+id+" created");
		x=rx=b[parId].xes[t.newBranch[id]];
		y=ry=b[parId].yes[t.newBranch[id]];
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

			line(0,0,0,-step);
		}

		popMatrix();


	}
}
void mousePressed(){
	saveFrame("a-###.png");
}
