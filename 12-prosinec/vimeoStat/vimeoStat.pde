String[] data;
String[] dates;

String[] DMD;

int[] played;
int[] liked;
int maxplayed = 0;
int maxliked = 0;
float smoo;

void setup(){


	size(600,300,P3D);
	
	grabStat();
	
	textFont(createFont("Pixel",8));
	textMode(SCREEN);

	data = loadStrings("vals.txt");
	dates = loadStrings("dates.txt");
	
	println(data.length+" <---> "+dates.length+" should be the same number");
	
	if(data.length!=dates.length){
		println("parsing error! the number of values has no propried dates");
		exit();
	}else{

	parseData();
	}
	background(255);
}

void draw(){

	background(255);
	
	noFill();
	stroke(0,155);
	
	smoo = map(mouseY,0,height,300,2);
	
	float prum = 0;
	
	beginShape();
	for(int i = 0;i<data.length;i++){
		
		float x = map(i,0,data.length,0,width);
		float val = map(played[i],0,maxplayed,height,0);
		
		if(i==0)
			prum = val;
		
		vertex(x,val);
		prum += (val-prum)/smoo;
		if(abs(x-mouseX)<2){
		text(DMD[i],x,prum);
		fill(0,50);
		}
		point(x,prum);
	}
	
	endShape();
	
	
	/*
	stroke(255,0,0,155);
	
	beginShape();
	for(int i = 0;i<data.length;i++){
		vertex(map(i,0,data.length,0,width),map(liked[i],0,maxliked,height,0));
	
	}
	
	endShape();
*/

}

public class SomeException extends Exception {
    public SomeException() {
      super(); // calls Exception(), which ultimately calls Object()
    }
    public SomeException(String s) {
      super(s); // calls Exception(String), to pass argument to base class
    }
    public SomeException (int error_code) {
      this("error"); // class constructor above, which calls super(s)
      System.err.println(error_code);
    }
}


void parseData(){
	int result[][] = new int[2][data.length];
	DMD = new String[data.length];
	liked = new int[data.length];
	played = new int[data.length];
	
	for(int i = 0;i<data.length;i++){
		String tmp = data[i];
		String tmp2[] = splitTokens(tmp," ");
		
		played[i] = parseInt(tmp2[4]);
		liked[i] = parseInt(tmp2[7]);
		
		if(maxplayed<played[i])
			maxplayed=played[i];
		
		if(maxliked<liked[i])
			maxliked=liked[i];
		
		tmp = dates[i];
		tmp2 = splitTokens(tmp," ");
		DMD[i] = tmp2[2]+" "+tmp2[3]+" "+tmp2[4];
	}

}



void grabStat(){

	try{
		Runtime.getRuntime().exec("xterm -e grabstat");
		println("grabbing data");
	}catch(java.io.IOException e){
		println(e);
	}
}
