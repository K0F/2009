import processing.opengl.*;

import oscP5.*;//import the OSC library
import netP5.*;

import blobDetection.*;



BlobDetection theBlobDetection;
Blob b[] = new Blob[0];


PFont font;
PImage source;
OSC osc;
//Senzor[] senzors;

boolean bang = false;

boolean overs[], overs2[];

float vibrant,vibt;
float[] vibs;

int[][] splits = new int[0][];
float [][] widths;// = new float[0][2];
float [][] heights;

int cas = 0;

void setup(){

	source = loadImage("partitionblack2.jpg");
	//source.loadPixels();

	size(source.width,source.height,OPENGL);

	//senzors = new Senzor[source.height];

	//for(int i = 0;i < senzors.length;i++){
	//	senzors[i] = new Senzor(i,i);
	//}

	vibs = new float[width];
	for(int i = 0;i<width;i++){
		vibs[i] = 0.0;
	}
	vibrant= vibt = height;

	noSmooth();

	font = createFont("Arial",9);
	textFont(font);
	//textMode(SCREEN);

	// blobl detection
	theBlobDetection = new BlobDetection(source.width, source.height);
	theBlobDetection.setPosDiscrimination(false);
	theBlobDetection.setThreshold(0.1f);
	theBlobDetection.computeBlobs(source.pixels);

	int g = 0;
	for (int n=0 ; n<theBlobDetection.getBlobNb() ; n++){
		if(b!=null){
			b= (Blob[])expand(b,b.length+1);
			//b[b.length-1] = new Blob();
			b[b.length-1] = theBlobDetection.getBlob(n);
			g++;

			println("no.: "+g+" has "+b[b.length-1].getEdgeNb()+"edges");
		}
	}


	overs  = new boolean[g];
	overs2  = new boolean[g];
	
	fillWidths();

	println("found "+g+" shapes");

	osc = new OSC("127.0.0.1",12000);
	osc.send(-1,1.0);
	frameRate(24);
}


void draw(){

	image (source,0,0,width,height);

	
	
	
	/*
	for(int i = 0;i < senzors.length;i++){
		senzors[i].run();
	}


	stroke(#FF0000,5);
	for(int i = 0;i < splits.length;i++){
		line(splits[i][0],0,splits[i][0],height);
		//line(splits[i][0],0,splits[i][0],height);
		}

	//rect(senzors[0].cas,vibt,3,3);
	//vibs[(int)senzors[0].cas] = vibrant;

	//vibrant+=(vibt-vibrant)/20.0;

	//stroke(#333333);
	//noStroke();
	stroke(#aa0000,160);

	pushStyle();
	strokeWeight(1);
	for(int i =1;i<vibs.length;i++){
		line(i,vibs[i],i,vibs[i-1]);
	}
	popStyle();

	//osc.send(0,vibs[0]);

*/	
	
	
	drawBlobsAndEdges(false,true);
	
	if(frameCount>1)
	for(int i = 0;i<overs.length;i++){
		if(overs[i]&&!overs2[i]){
			//println("bang "+i+" , "+map(0.5*(heights[i][0]+heights[i][1]),height,0,0.22,0.8)+" , "+map((widths[i][1]-widths[i][0]),0,100,0,1));
			osc.send(i,map(0.5*(heights[i][0]+heights[i][1]),height,0,0.22,0.8),map((widths[i][1]-widths[i][0]),0,100,0,1));
		}

	}
	
	for(int i =0 ;i<overs.length;i++)
	overs2[i] = overs[i];
		
	stroke(0);                                   
	line(cas,0,cas,height);
	cas +=4;
	if(cas>width)
		cas=0;
}

void genSplit(int _id){
	splits = (int[][])expand(splits,splits.length+1);
	splits[splits.length-1] = new int[2];
	splits[splits.length-1][0] = cas;
	splits[splits.length-1][1] = _id;


}

void keyPressed(){
	if(key==ENTER){
		save("out.png");
	}
}

void stop(){
	osc.send(-1,0.0);
	osc.osc.stop();
	super.stop();


}

float[] getBlobWidths(Blob _b){
	EdgeVertex A;
	float mina =width,maxa=0;

	for (int m=0;m<_b.getEdgeNb();m++)	{
		A = _b.getEdgeVertexA(m);

		if(A!=null){
			if(mina>A.x*width)
				mina = A.x*width;

			if(maxa<A.x*width)
				maxa = A.x*width;
		}
	}

	float a[] = {mina,maxa};
	return a;
}

float[] getBlobHeights(Blob _b){
	EdgeVertex A;
	float mina =width,maxa=0;

	for (int m=0;m<_b.getEdgeNb();m++)	{
		A = _b.getEdgeVertexA(m);

		if(A!=null){
			if(mina>A.y*height)
				mina = A.y*height;

			if(maxa<A.y*height)
				maxa = A.y*height;
		}
	}

	float a[] = {mina,maxa};
	return a;
}

void fillWidths(){
	widths = new float[b.length][2];
	heights = new float[b.length][2];

	for(int i = 0;i<b.length;i++){

		widths[i][0] = getBlobWidths(b[i])[0];
		widths[i][1] = getBlobWidths(b[i])[1];

		heights[i][0] = getBlobHeights(b[i])[0];
		heights[i][1] = getBlobHeights(b[i])[1];
	}
}

boolean over(int _id){
	boolean answr = false;
	overs[_id] = false;
	
	if(cas>widths[_id][0]&&cas<widths[_id][1]){
		answr = true;
		overs[_id] = true;
	}

	return answr;
}

void drawBlobsAndEdges(boolean drawBlobs, boolean drawEdges)
{
	pushStyle();
	noFill();
	rectMode(CENTER);

	//Blob bb;
	EdgeVertex eA,eB;
	for (int n=0 ; n<b.length ; n++)	{
		//bb=b[n];
		// Edges
		if (drawEdges){
			strokeWeight(3);
			stroke(255,0,0,180);
			if(over(n)){
				//rect(0.5*(widths[n][0]+widths[n][1]),0.5*(heights[n][0]+heights[n][1]),10,10);
				text(n,0.5*(widths[n][0]+widths[n][1]),0.5*(heights[n][0]+heights[n][1]));
				for (int m=0;m<b[n].getEdgeNb();m++){


					eA = b[n].getEdgeVertexA(m);
					eB = b[n].getEdgeVertexB(m);
					if (eA !=null && eB !=null){
						line(
						        eA.x*width, eA.y*height,
						        eB.x*width, eB.y*height
						);

					}
				}
			}
		}

		// Blobs
		if (drawBlobs){
			strokeWeight(1);
			stroke(255,0,0);
			rect(
			        b[n].xMin*width,b[n].yMin*height,
			        b[n].w*width,b[n].h*height
			);
		}

	}

	popStyle();


}

class OSC{
	OscP5 osc;
	NetAddress addr;
	int port;

	OSC(String _addr,int _port){
		port=_port;
		osc = new OscP5(this,_port-1);
		addr = new NetAddress(_addr,port);
	}

	void send(int _ident,float _whatX,float _whatY){
		OscMessage message = new OscMessage("/msg");
		String ident = (char)(_ident+65)+"";
		message.add(ident);
		//message.add("x ");
		message.add(_whatX);
		//message.add("y ");
		message.add(_whatY);
		osc.send(message, addr);
	}

	void send(int _ident,float _whatX,float _whatY,float _whatZ){
		OscMessage message = new OscMessage("/msg");
		String ident = (char)(_ident+65)+"";
		//message.add(ident);
		//message.add("x ");
		message.add(_whatX);
		//message.add("y ");
		message.add(_whatY);
		message.add(_whatZ);
		osc.send(message, addr);
	}


	void send(int _ident,float _what){
		OscMessage message = new OscMessage("/msg");
		String ident = (char)(_ident+65)+"";
		message.add(ident);
		message.add(_what);
		osc.send(message, addr);
	}

}

/*
class Senzor{
	float cas;
	float y;
	int id;
	int[] val;
	int lastval = 0;
	int runs = 0;
	int citlivost = 10;

	Senzor(int _id,float _y){
		y = _y;
		id = _id;
		cas = 0;
		val = new int[source.width];
		for(int i =0;i<source.width;i++){
			val[i] = (int)getVal(i);

		}
	}

	void run(){
		compute();
		draw();

	}

	void compute(){
		lastval = val[(int)cas];
		tick(5);
		if(runs==0){
			if(abs(val[(int)cas]-lastval)>citlivost){
				//if(val[(int)cas]<200){
				//println(id);
				genSplit(id);
			}
		}

		if(abs(val[(int)cas]-lastval)>citlivost)
			bang = true;


		if(abs(val[(int)cas])<10){
			vibt+=(y-vibt)/(senzors.length+0.0);
		}

	}

	void tick(float w){
		cas+=w;
		if(cas>=width){
			cas=0;
			runs++;
		}

	}

	void draw(){
		stroke(255-val[(int)cas]);
		line(cas,y,cas+1,y);
	}

	float getVal(int _x){
		return brightness(source.pixels[(int)y*source.width+_x]);
	}
}

*/
