Site[] s = new Site[2];
float rot = 0;

void setup(){
	size(300,300,P3D);
	background(255);

	for(int i =0;i<s.length;i++){
		s[i] = new Site(i);
	}
	noFill();
	stroke(0);
}

void draw(){
	size(300,300,P3D);
	background(255);


	pushMatrix();
	translate(0,0,-width*1.2);
	pushMatrix();
	translate(width/2.0,height/2.0,width/2.0);

	pushMatrix();
	rotateY(rot);
	rot+=0.01;
	box(width);

	translate(-width/2.0,-height/2.0,-width/2.0);

	pushMatrix();


	for(int i =0;i<s.length;i++){
		s[i].draw();
	}

	popMatrix();

	popMatrix();

	popMatrix();

	popMatrix();
}

void mousePressed(){
	reset();
}

void reset(){
	for(int i =0;i<s.length;i++){
		s[i] = new Site(i);
	}

}


class Site{
	float x,y,z;
	int id;
	float siz = 10;

	Site(int _id){
		id=_id;
		x=random(0,width);
		y=random(0,height);
		z=random(0,height);
	}


	void compute(){


	}
	void draw(){
		//siz = mouseX;
		compute();
		pushStyle();
		noFill();
		stroke(0);
		pushMatrix();
		translate(x,y,z);
		box(3);
		popMatrix();

		for(int i = 0;i<s.length;i++){
			if(i!=id){
				line(s[i].x,s[i].y,s[i].z,x,y,z);

				fill(0,100);
				beginShape(QUAD);
				vertex(D(s[i])[0],D(s[i])[1],D(s[i])[2]);
				vertex(C(s[i])[0],C(s[i])[1],C(s[i])[2]);
				vertex(A(s[i])[0],A(s[i])[1],A(s[i])[2]);
				vertex(B(s[i])[0],B(s[i])[1],B(s[i])[2]);

				//vertex(A(s[i])[0],A(s[i])[1],A(s[i])[2]);
				endShape(CLOSE);
				noFill();


				pushMatrix();
				translate(midpoint(s[i])[0],midpoint(s[i])[1],midpoint(s[i])[2]);
				box(4);
				popMatrix();
			}

		}
		popStyle();

	}

	float[] midpoint(Site _s){
		Site temp = _s;

		float midX = lerp(x,temp.x,0.5);
		float midY = lerp(y,temp.y,0.5);
		float midZ = lerp(z,temp.z,0.5);

		float[] answr = {midX,midY,midZ};
		return answr;
	}

	float[] A(Site _s){

		float x2 = _s.x;
		float y2 = _s.y;
		float z2 = _s.z;

		float x3 = midpoint(_s)[0];
		float y3 = midpoint(_s)[1];
		float z3 = midpoint(_s)[2];

		float rX = x3+siz;
		float rY = y3+siz;
		float rZ = z3+(x3+y3-x2-y2)/(z2-z3);

		float result[] = {rX,rY,rZ};

		return result;

	}

	float[] B(Site _s){

		float x2 = _s.x;
		float y2 = _s.y;
		float z2 = _s.z;

		float x3 = midpoint(_s)[0];
		float y3 = midpoint(_s)[1];
		float z3 = midpoint(_s)[2];

		float rX = x3+siz;
		float rY = y3-siz;
		float rZ = z3+(x3+y2-x2-y3)/(z2-z3);

		float result[] = {rX,rY,rZ};

		return result;

	}

	float[] C(Site _s){
		float x2 = _s.x;
		float y2 = _s.y;
		float z2 = _s.z;

		float x3 = midpoint(_s)[0];
		float y3 = midpoint(_s)[1];
		float z3 = midpoint(_s)[2];

		float rX = x3-siz;
		float rY = y3+siz;
		float rZ = z3+(x2+y3-x3-y2)/(z2-z3);

		float result[] = {rX,rY,rZ};

		return result;

	}

	float[] D(Site _s){
		float x2 = _s.x;
		float y2 = _s.y;
		float z2 = _s.z;

		float x3 = midpoint(_s)[0];
		float y3 = midpoint(_s)[1];
		float z3 = midpoint(_s)[2];

		float rX = x3-siz;
		float rY = y3-siz;
		float rZ = z3+(x2+y2-x3-y3)/(z2-z3);

		float result[] = {rX,rY,rZ};

		return result;

	}

}
