//import processing.opengl.*;

/**
* Voronoi structure by Krystof Pesek (aka kof)
*	speed optimization in las release
*
*/

///////////////////////////////////////////////// >
int num = 100;
int precision = 4;
///////////////////////////////////////////////// >
boolean record = true;
boolean smoothing = true;
///////////////////////////////////////////////// >
Recorder r;
Site [] s;
///////////////////////////////////////////////// >

void setup(){
	size(800,500,P3D);
	background(0);

	//textFont(createFont("Veranda",9));
	//textMode(SCREEN);
	rectMode(CENTER);


	//frame.setAlwaysOnTop(true);

	if(record)
		r = new Recorder("out","voronoiIO5.avi");

	s = new Site[num];

	if(smoothing)
		smooth();

	float X = 0;
	float Y = 0;
	for(int i =0;i<s.length;i++){
		s[i] = new Site(i);
	}
}

///////////////////////////////////////////////// >

void draw(){
	//background(0);
	fade(50);

	for(int i =0;i<s.length;i++){
		s[i].live();
	}

	if(record)
		r.add();
}

///////////////////////////////////////////////// >

void fade(int kolik){
	fill(0,kolik);
	noStroke();
	rect(width/2,height/2,width,height);
}

///////////////////////////////////////////////// >

void keyPressed(){
	if(key=='q'){
		if(record)
			r.finish();
		exit();
	}else if(key == 's'){
		save("shot"+nf(frameCount,6)+".png");
		println("shot saved");
	}
}


///////////////////////////////////////////////// >

class Site{
	int id;
	float x,y,tx,ty;
	float speed = 3.0;

	float[][] kol = new float[0][4];
	//float [][] bis = new float[s.length][2];;
	boolean valid[];
	Vector vX = new Vector();
	Vector vY = new Vector();
	Vector poradi = new Vector();

	float dens = 0;

	color c;

	float br = 20.0;

	///////////////////////////////////////////////// >

	Site(int _id){
		id=_id;
		tx=x=random(br,width-br);
		ty=y= random(br,height-br);
		c = color(random(255));
		valid = new boolean[s.length];

	}

	///////////////////////////////////////////////// >

	Site(int _id,float _x,float _y){
		id=_id;
		tx=x=_x;
		ty=y= _y;
		c = color(random(255));
		valid = new boolean[s.length];

	}

	///////////////////////////////////////////////// >

	void compute(){
		kol = new float[0][4];

		for(int i =0;i<s.length;i++){
			if(i!=id){
				float bisX=lerp(x,s[i].x,0.5);
				float bisY=lerp(y,s[i].y,0.5);
				if(kol.length>0){
					if(visible2(bisX,bisY)<precision){
						kol = (float[][])expand(kol,kol.length+1);
						kol[kol.length-1] = kolmice(x,y,s[i].x,s[i].y);
					}
				}else{
					kol = (float[][])expand(kol,kol.length+1);
					kol[kol.length-1] = kolmice(x,y,s[i].x,s[i].y);

				}
			}
		}

		kol = (float[][])expand(kol,kol.length+1);
		kol[kol.length-1] = kolmice2(x,y,x,br);
		kol = (float[][])expand(kol,kol.length+1);
		kol[kol.length-1] = kolmice2(x,y,width-br,y);
		kol = (float[][])expand(kol,kol.length+1);

		kol[kol.length-1] = kolmice2(x,y,x,height-br);
		kol = (float[][])expand(kol,kol.length+1);

		kol[kol.length-1] = kolmice2(x,y,br,y);


		PVector tmp;
		vX.clear();
		vY.clear();
		//println((Float)vX.get(0));
		for(int i = 0;i<kol.length;i++){
			//if(valid[i]){
			for(int e = 0;e<kol.length;e++){
				if(e!=i){
					tmp = lineIntersection(kol[i][0],kol[i][1],kol[i][2],kol[i][3],
					                       kol[e][0],kol[e][1],kol[e][2],kol[e][3]);
					if(tmp!=null){
						if(visible(tmp.x,tmp.y)){
							if(!exist(tmp.x,tmp.y)){
								vX.add(tmp.x);
								vY.add(tmp.y);
							}
						}
					}
				}
			}
		}

		sortV();

	}

	///////////////////////////////////////////////// >

	void live(){
		compute();

		///////////////////////////////////////////////// >

		/**
		dens = 0;

		for(int i =0;i<poradi.size();i++){
			dens+=dist((float)(Float)vX.get((Integer)poradi.get(i)),
			           (float)(Float)vY.get((Integer)poradi.get(i)),x,y);
	}

		dens /= poradi.size();
		dens = map(dens,3,(width)/20.0,1,0);
		dens=constrain(dens,0,1);
		*/


		///////////////////////////////////////////////// >

		for(int i = 0;i<poradi.size();i++){
			int sel = (i+1)%(poradi.size());
			float X2a = (float)(Float)vX.get((Integer)poradi.get(i));
			float Y2a = (float)(Float)vY.get((Integer)poradi.get(i));
			float X2b = (float)(Float)vX.get((Integer)poradi.get(sel));
			float Y2b = (float)(Float)vY.get((Integer)poradi.get(sel));

			float [] center = getCenter(x,y,X2a,Y2a,X2b,Y2b);

			tx+=(center[0]-tx)/(poradi.size()+0.0);
			ty+=(center[1]-ty)/(poradi.size()+0.0);

		}
		
		
		///////////////////////////////////////////////// >



		fill(c,120);
		noStroke();

		c = lerpColor(color(#FFFFFF),color(#FFCC00),
		              constrain(map(dist(tx,ty,x,y),0,5,0,1),0,1));


/**
		///////////////////////////////////////////////// >

		beginShape(POLYGON);
		for(int i = 0;i<poradi.size();i++){
			float X2 = (float)(Float)vX.get((Integer)poradi.get(i));
			float Y2 = (float)(Float)vY.get((Integer)poradi.get(i));

			vertex(lerp(X2,x,0.05),lerp(Y2,y,0.05));
		}
		endShape(CLOSE);

		fill(0);
		noStroke();


		*///////////////////////////////////////////////// >
		
	//	 curveTightness(4.1);
		 fill(c,200);
		 float rat = 0.1;
		 
		beginShape();
		vertex(lerp((float)(Float)vX.get((Integer)poradi.get(0)),x,rat),lerp((float)(Float)vY.get((Integer)poradi.get(0)),y,rat));
		
		for (int i=1; i<poradi.size()+1; i++){
			
			float x2 = lerp((float)(Float)vX.get((Integer)poradi.get(i%poradi.size())),x,rat);
			float y2 = lerp((float)(Float)vY.get((Integer)poradi.get(i%poradi.size())),y,rat);
			
			float x1 = lerp((float)(Float)vX.get((Integer)poradi.get(i-1)),x,rat);
			float y1 = lerp((float)(Float)vY.get((Integer)poradi.get(i-1)),y,rat);
			
			float mx = lerp(x1,x2,0.5);
			float my = lerp(y1,y2,0.5);
			
			float cx1 = mx+(mx-tx)*map(dist(x1,y1,x2,y2),0,100,0.0001,0.6);
			float cy1 = my+(my-ty)*map(dist(x1,y1,x2,y2),0,100,0.0001,0.6);
			
			bezierVertex(cx1, cy1, cx1, cy1, x2, y2);			
		}
		
		endShape(CLOSE);

		
		
		fill(0);
		rat = 0.35;
		 
		beginShape();
		vertex(lerp((float)(Float)vX.get((Integer)poradi.get(0)),x,rat),lerp((float)(Float)vY.get((Integer)poradi.get(0)),y,rat));
		
		for (int i=1; i<poradi.size()+1; i++){
			
			float x2 = lerp((float)(Float)vX.get((Integer)poradi.get(i%poradi.size())),x,rat);
			float y2 = lerp((float)(Float)vY.get((Integer)poradi.get(i%poradi.size())),y,rat);
			
			float x1 = lerp((float)(Float)vX.get((Integer)poradi.get(i-1)),x,rat);
			float y1 = lerp((float)(Float)vY.get((Integer)poradi.get(i-1)),y,rat);
			
			float mx = lerp(x1,x2,0.5);
			float my = lerp(y1,y2,0.5);
			
			float cx1 = mx+(mx-tx)*map(dist(x1,y1,x2,y2),0,100,0.0001,0.6);
			float cy1 = my+(my-ty)*map(dist(x1,y1,x2,y2),0,100,0.0001,0.6);
			
			bezierVertex(cx1, cy1, cx1, cy1, x2, y2);			
		}
		
		endShape(CLOSE);
/**
		beginShape(POLYGON);
		for(int i = 0;i<poradi.size();i++){
			float X2 = (float)(Float)vX.get((Integer)poradi.get(i));
			float Y2 = (float)(Float)vY.get((Integer)poradi.get(i));

			vertex(lerp(X2,x,0.2),lerp(Y2,y,0.2));
		}

		endShape(CLOSE);
*/

		///////////////////////////////////////////////// >
		noStroke();
		fill(c,100);
		rect(x,y,3,3);
		fill(255,60);
		rect(tx,ty,2,2);

		///////////////////////////////////////////////// >
		tx=constrain(tx,br,width-br);
		ty=constrain(ty,br,height-br);

		x+=(tx-x)/speed;
		y+=(ty-y)/speed;
	}

	///////////////////////////////////////////////// >

	boolean exist(float _x,float _y){
		boolean answr = false;
		float d;
		for(int i =0;i<vX.size();i++){
			d = (abs((Float)vX.get(i)-_x)+abs((Float)vY.get(i)-_y)) * 1000.0;
			if(d<1){
				answr = true;
			}
		}
		return answr;
	}

	///////////////////////////////////////////////// >

	boolean visible(float xx,float yy){
		boolean answr = true;
		PVector a;

		for(int i =0;i<kol.length;i++){
			a = segIntersection(x,y,lerp(x,xx,0.998),lerp(y,yy,0.998),kol[i][0],kol[i][1],kol[i][2],kol[i][3]);
			if(a!=null){
				answr = false;
			}
		}
		return answr;
	}

	///////////////////////////////////////////////// >

	int visible2(float xx,float yy){
		int answr = 0;
		PVector a;

		for(int i =0;i<kol.length;i++){
			a = segIntersection(x,y,lerp(x,xx,0.998),lerp(y,yy,0.998),kol[i][0],kol[i][1],kol[i][2],kol[i][3]);
			if(a!=null){
				answr++;
			}
		}
		return answr;
	}

	///////////////////////////////////////////////// >

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
				if(((Float)thetas.get(selector)-(Float)thetas.get((Integer)poradi.get(poradi.size()-1)))>0.25)
					poradi.add(selector);
			}else{
				poradi.add(selector);
			}
		}
	}

	///////////////////////////////////////////////// >

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


	///////////////////////////////////////////////// >

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

	///////////////////////////////////////////////// >

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

	///////////////////////////////////////////////// >

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

	///////////////////////////////////////////////// >

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

	///////////////////////////////////////////////// >

	float getArea(float x1,float y1,float x2,float y2,float x3,float y3){
		float v1x, v1y, v2x, v2y;

		v1x = x2 - x1;	// compute side vectors
		v1y = y2 - y1; 	// compute side vectors

		v2x = x3 - x1; 	// compute side vectors
		v2y = y3 - y1; 	// compute side vectors

		// return cross product of side vectors / 2

		return 0.5 * (v1x * v2y - v1y * v2x);
	}

	///////////////////////////////////////////////// >

	float[] getCenter(float _x1,float _y1,float _x2,float _y2,float _x3,float _y3){

		float[] cntr = new float[2];
		cntr[0] = 0;
		cntr[1] = 0;

		float x1, y1, x2, y2, x3, y3, x4, y4;

		x1 = _x1;	// get endpoints of first median
		y1 = _y1;	// get endpoints of first median
		x2 = (_x2 + _x3) / 2.0;	// get endpoints of first median
		y2 = (_y2 + _y3) / 2.0;	// get endpoints of first median

		x3 = _x2;	// get endpoints of second median (only need two)
		y3 = _y2;	// get endpoints of second median
		x4 = (_x3 + _x1) / 2.0;	// get endpoints of second median
		y4 = (_y3 + _y1) / 2.0;	// get endpoints of second median

		// see if either median is vertical (slope == infinity)

		if (x1 == x2)	// if so...
		{
			x1 = _x3;	// use third median (can't be two vertical medians)
			y1 = _y3; // use third median
			x2 = (_x1 + _x2) / 2.0; // use third median
			y2 = (_y1 + _y2) / 2.0; // use third median
		}
		else if (x3 == x4)
		{
			x3 = _x3;
			y3 = _y3;
			x4 = (_x1 + _x2) / 2.0;
			y4 = (_y1 + _y2) / 2.0;
		}

		float a1, a2, b1, b2;

		a1 = (y2 - y1) / (x2 - x1);	// compute slope of first median
		b1 = y1 - a1 * x1;	// compute intercept of first median

		a2 = (y4 - y3) / (x4 - x3);	// compute slope of second median
		b2 = y3 - a2 * x3;	// compute intercept of second median

		// solve a1 * x + b1 = a2 * x + b2

		cntr[0] = (b2 - b1) / (a1 - a2);	// solve for x coordinate of intersection
		cntr[1] = a1 * cntr[0] + b1;	// solve for y coordinate of intersection

		return cntr;	// return center as a point

	}

	///////////////////////////////////////////////// >

}
