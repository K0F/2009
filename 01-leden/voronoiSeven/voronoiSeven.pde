

int num = 20;
Site [] s;


void setup(){
	size(800,400,P3D);
	background(0);

	textFont(createFont("Veranda",9));
	textMode(SCREEN);
	rectMode(CENTER);
	//smooth();

	s = new Site[num];

	for(int i =0;i<s.length;i++){
		s[i] = new Site(i);
	}
}

void draw(){
	background(0);

	
	for(int i =0;i<s.length;i++){
		s[i].live();

	}
}




class Site{
	int id;
	float x,y;
	float[][] kol = new float[s.length+4][4];
	float [][] bis = new float[s.length][2];;
	boolean valid[];
	Vector vX = new Vector();
	Vector vY = new Vector();
	Vector poradi = new Vector();

	color c = color(random(120,200));

	float br = 10.0;

	Site(int _id){
		id=_id;
		x=random(width);
		y= random(height);

		valid = new boolean[s.length];
	}

	void compute(){

		for(int i =0;i<s.length;i++){
			if(i!=id){
				bis[i][0]=lerp(x,s[i].x,0.5);
				bis[i][1]=lerp(y,s[i].y,0.5);
				kol[i] = kolmice(x,y,s[i].x,s[i].y);

			}
		}

		kol[s.length] = kolmice2(x,y,x,br);
		kol[s.length+1] = kolmice2(x,y,width-br,y);
		kol[s.length+2] = kolmice2(x,y,x,height-br);
		kol[s.length+3] = kolmice2(x,y,br,y);


		PVector tmp;
		vX.clear();
		vY.clear();
		for(int i = 0;i<kol.length;i++){
			for(int e = 0;e<kol.length;e++){
				if(e!=i){
					tmp = lineIntersection(kol[i][0],kol[i][1],kol[i][2],kol[i][3],
					                       kol[e][0],kol[e][1],kol[e][2],kol[e][3]);
					if(tmp!=null){
						if(visible(tmp.x,tmp.y)){
							vX.add(tmp.x);
							vY.add(tmp.y);
						}
					}
				}
			}
		}
		sortV();
		
		x+=random(-1,1);
		y+=random(-1,1);
		x=constrain(x,br,width-br);
		y=constrain(y,br,height-br);
	}

	void live(){
		compute();

		fill(c);
		stroke(0);
		beginShape(POLYGON);
		for(int i =0;i<poradi.size();i++){
			float X = (float)(Float)vX.get((Integer)poradi.get(i));
			float Y = (float)(Float)vY.get((Integer)poradi.get(i));
			vertex(lerp(X,x,0.2),lerp(Y,y,0.2));
		}
		endShape(CLOSE);

		noStroke();
		fill(0);
		rect(x,y,3,3);
		text(id,x+5,y+5);


	}

	boolean exist(float _x,float _y){
		boolean answr = false;
		float d;
		for(int i =0;i<vX.size();i++){
			d = (abs((Float)vX.get(i)-_x)+abs((Float)vY.get(i)-_y)) * 1000.0;
			if(d<5){

				answr = true;
			}

		}

		return answr;

	}

	boolean visible(float xx,float yy){
		boolean answr = true;
		PVector a;

		for(int i =0;i<kol.length;i++){

			a = segIntersection(x,y,lerp(x,xx,0.999),lerp(y,yy,0.999),kol[i][0],kol[i][1],kol[i][2],kol[i][3]);
			if(a!=null){
				answr = false;
			}
		}

		return answr;
	}

	void sortV(){
		int delka = vX.size();

		poradi.clear();
		Vector thetas =  new Vector();

		for(int i = 0;i<delka;i++){
			thetas.add(angle(i));
		}

		int selector = 0;
		float tmpaa = 1000.0;

		boolean[] sel = new boolean[thetas.size()];
		for(int i = 0;i<thetas.size();i++){

			selector = 0;
			tmpaa = 1000.0;

			for(int q = 0;q<thetas.size();q++){
				if((Float)thetas.get(q)<(tmpaa)&&!sel[q]){
					tmpaa = (Float)thetas.get(q);
					selector = q;
				}
			}

			sel[selector] = true;

			if(poradi.size()>0){
				if(((Float)thetas.get(selector)-(Float)thetas.get((Integer)poradi.get(poradi.size()-1)))>0.5)
					poradi.add(selector);
			}else{
				poradi.add(selector);
			}

		}
	}


	float[] kolmice(float x1,float y1,float x2,float y2){
		float A1 = x1-x2;
		float A2 = y1-y2;
		float midX = lerp(x1,x2,0.5);
		float midY = lerp(y1,y2,0.5);
		float resX = midX+A2*100.5;
		float resY = midY-A1*100.5;
		float resX2 = midX-A2*100.5;
		float resY2 = midY+A1*100.5;

		float[] res = {resX,resY,resX2,resY2};
		return res;
	}


	float[] kolmice2(float x1,float y1,float x2,float y2){
		float A1 = x1-x2;
		float A2 = y1-y2;
		float midX = x2;
		float midY = y2;
		float resX = midX+A2*100.5;
		float resY = midY-A1*100.5;
		float resX2 = midX-A2*100.5;
		float resY2 = midY+A1*100.5;

		float[] res = {resX,resY,resX2,resY2};
		return res;
	}

	PVector segIntersection(float x1, float y1, float x2, float y2, float x3, float y3, float x4, float y4){
		float bx = x2 - x1;
		float by = y2 - y1;
		float dx = x4 - x3;
		float dy = y4 - y3;

		float b_dot_d_perp = bx * dy - by * dx;

		if(b_dot_d_perp == 0) return null;

		float cx = x3 - x1;
		float cy = y3 - y1;

		float t = (cx * dy - cy * dx) / b_dot_d_perp;
		if(t < 0 || t > 1) return null;

		float u = (cx * by - cy * bx) / b_dot_d_perp;
		if(u < 0 || u > 1) return null;

		return new PVector(x1+t*bx, y1+t*by);
	}

	PVector lineIntersection(float x1, float y1, float x2, float y2, float x3, float y3, float x4, float y4){
		float bx = x2 - x1;
		float by = y2 - y1;
		float dx = x4 - x3;
		float dy = y4 - y3;

		float b_dot_d_perp = bx*dy - by*dx;

		if(b_dot_d_perp == 0) return null;

		float cx = x3-x1;
		float cy = y3-y1;

		float t = (cx*dy - cy*dx) / b_dot_d_perp;

		return new PVector(x1+t*bx, y1+t*by);
	}

	float angle(int b){
		float angle;

		float x1 = (Float)vX.get(b);
		float y1 = (Float)vY.get(b);

		float X = (x1-x);
		float Y = (y1-y);

		PVector vec = new PVector(X,Y);
		vec.normalize();

		if(vec.x==0){
			angle = 0;
		}else{
			angle = atan(vec.y / vec.x);
		}

		float qadr = 0;
		if((vec.x >= 0)&&(vec.y > 0)) qadr = 0;
		if((vec.x <= 0)&&(vec.y > 0)) qadr = 180;
		if((vec.x <= 0)&&(vec.y < 0)) qadr = 180;
		if((vec.x >= 0)&&(vec.y < 0)) qadr = 360;


		angle = degrees(angle)+qadr;

		return angle;

	}

}
