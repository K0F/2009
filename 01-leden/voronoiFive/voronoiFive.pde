
//import com.processinghacks.triangulate.*;


int num = 8;
Site t[];


void setup(){
	size(400,400,P3D);
	frameRate(20);


	reseed();
	rectMode(CORNER);
	textFont(createFont("Veranda",9));
	textMode(SCREEN);
	//smooth();


}

void reseed(){
	t = new Site[num];
	for(int i =0;i<num;i++){
		t[i] = new Site(i);
	}
}

void mousePressed(){
	if(mouseButton==LEFT){
		reseed();
	}

}

void draw(){
	fill(#ffffff);
	rect(0,0,width,height);


	for(int i =0;i<t.length;i++){
		//vertex(t[i].x,t[i].y);
		t[i].live();
	}


}





class Site{
	int ns = num;

	int id;
	float x,y;
	float k[][];
	float r[][];
	float rohyX[] = new float[0];
	float rohyY[] = new float[0];
	int neighs[];
	float verX[] = new float[0];
	float verY[] = new float[0];
	boolean valid[];

	boolean vizKolmice = true;
	boolean vizSite = true;
	boolean vizStred = true;

	PVector stred,L,T,R,D,VIS;

	boolean first = true;
	
	Site(int _id){
		id = _id;
		x= random(width);
		y= random(height);
		neighs = new int[ns];
		k = new float[ns][4];
		r = new float[ns][2];
		
	}

	void compute(){
		
		if(id==2&&first){
			first=false;
			println(closest(id,ns));
			
		}
		
		//neighs=(closest(id,ns));
		for(int i = 0;i<ns;i++){
			if(i!=id){
			r[i][0] = lerp(x,t[i].x,0.5);
			r[i][1] = lerp(y,t[i].y,0.5);
			k[i] = kolmice(x,y,t[i].x,t[i].y);
			}
		}

		valid=new boolean[ns];
		rohyX=new float[0];
		rohyY=new float[0];

		verX = new float[0];
		verY = new float[0];

		
		for(int i =0;i<ns;i++){
		valid[i] = true;

			for(int e = 0;e<ns;e++){
				//if(i!=e){
					VIS = segIntersection(r[e][0],r[e][1],x,y,k[i][0],k[i][1],k[i][2],k[i][3]);
					if(VIS!=null){
						valid[i] = false;
					}
				//}
			}
		}
		
		
		
		for(int i =0;i<ns;i++){
			int a = i;
			
			
			//directly visible?
			if(valid[i]){
		
				for(int w = 0;w<ns;w++){	
					if(valid[w]){
					stred=lineIntersection(k[a][0],k[a][1],k[a][2],k[a][3],k[w][0],k[w][1],k[w][2],k[w][3]);
					if(stred!=null){
						addV(stred.x,stred.y);
					}
					}
				}

			}
		}

			/*

			for(int w = 0;w<ns;w++){


				             // if(valid[w]){



					              L = lineIntersection(k[a][0],k[a][1],k[a][2],k[a][3],0,0,0,height);
					              T = lineIntersection(k[a][0],k[a][1],k[a][2],k[a][3],0,0,width,0);                                                           
					              R = lineIntersection(k[a][0],k[a][1],k[a][2],k[a][3],width,0,width,height);
					              D = lineIntersection(k[a][0],k[a][1],k[a][2],k[a][3],0,height,width,height);

					              stred=lineIntersection(k[a][0],k[a][1],k[a][2],k[a][3],
					                                     k[w][0],k[w][1],k[w][2],k[w][3]);
					              //if(stred!=null&&dist(r[i][0],r[i][1],x,y)>dist(stred.x,stred.y,r[i][0],r[i][1])){
						      
					              addP(stred);
					              
					              addP(L);
					              addP(T);
					              addP(R);
					              addP(D);


				              //}
			              }

			             }
			            }*/


			//constructVertex(8);

		}

		boolean visible(float xaa,float yaa){
			boolean answr = true;
			for(int e = 0;e<ns;e++){
				//if(e!=id){
				VIS = segIntersection(xaa,yaa,x,y,k[e][0],k[e][1],k[e][2],k[e][3]);
				if(VIS!=null){
					answr = false;
				}
				//}

			}
			return answr;

		}

	/*	void constructVertex(int q){
			addV(r[neighs[0]][0],r[neighs[0]][1]);

			//int which = closestRC(0)[0];

			int result[] = closObj(neighs[0],1);
			for(int i =0;i<q;i++){

				if(result[1]==1){
					addV(r[result[0]][0],r[result[0]][1]);
					result = closObj(result[0],1);
				}else{
					addV(rohyX[result[0]],rohyY[result[0]]);
					result = closObj(result[0],2);
				}
			}
		}
*/

		void addV(float xx,float yy){
			verX = (float[])expand(verX,verX.length+1);
			verY = (float[])expand(verY,verY.length+1);
			verX[verX.length-1] = xx;
			verY[verY.length-1] = yy;


		}

		void addP(PVector q){
			if(q!=null&&visible(q.x,q.y)){
				rohyX = (float[])expand(rohyX,rohyX.length+1);
				rohyY = (float[])expand(rohyY,rohyY.length+1);
				rohyX[rohyX.length-1] = q.x;
				rohyY[rohyY.length-1] = q.y;
			}
		}

		void live(){
			compute();
			stroke(#553300,60);

			fill(0);
			rect(x,y,2,2);
			text(id,x,y);

			if(id==2){


				fill(#ffcc00);
				for(int i = 0;i<ns;i++){
					rect(r[i][0],r[i][1],3,3);
				}

				//println(verX.length);
				//beginShape(POLYGON);
				for(int i = 0;i<verX.length;i++){
					ellipse(verX[i],verY[i],15,15);
				}
				//endShape(CLOSE);

				for(int i = 0;i<k.length;i++){
					//int a = constrain(i-1,0,k.length);

					if(valid[i]){
						stroke(0);	
					}else{
						stroke(0,60);
					}
					line(r[i][0],r[i][1],x,y);
					line(k[i][0],k[i][1],k[i][2],k[i][3]);
					
				}

				for(int i = 0;i<rohyY.length;i++){
					boolean valid = false;

					for(int q = 0;q<num;q++){

						if(q!=id){
							if(dist(rohyX[i],rohyY[i],x,y) < dist(rohyX[i],rohyY[i],r[q][0],r[q][1])){
								valid = true;
							}
						}
					}

					//if(valid){
					fill(255,0,0);
					rect(rohyX[i],rohyY[i],3,3);
					//}
				}
				x=mouseX;
				y=mouseY;
			}
		}

		int[] closest(int q,int _kolik){
			int[] answr = new int[_kolik];
			float[] temp = new float[num];
			//float[] temp2 = new float[num];

			for(int i =0 ;i<num;i++){
				if(i==q){
					temp[i] = width*height;
				}else{
					temp[i] = dist(t[q].x,t[q].y,t[i].x,t[i].y);
				}
			}

			//temp2=temp;

			for(int i =0;i<_kolik;i++){
				for(int w =0;w<num;w++){
					if(temp[w]==min(temp)){
						answr[i] = w;
						temp[w] = max(temp);
						break;
					}
				}
			}

			return answr;
		}


		float[] kolmice(float x1,float y1,float x2,float y2){
			float A1 = x1-x2;
			float A2 = y1-y2;
			float midX = lerp(x1,x2,0.5);
			float midY = lerp(y1,y2,0.5);
			float resX = midX+A2*10.5;
			float resY = midY-A1*10.5;
			float resX2 = midX-A2*10.5;
			float resY2 = midY+A1*10.5;

			float[] res = {resX,resY,resX2,resY2};
			return res;
		}


		// Line Segment Intersection
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

	}
