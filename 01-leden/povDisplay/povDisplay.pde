import processing.serial.*;

Serial port;
int[] pins = {8,12,10,11,7};
boolean[] ons;
boolean matrix[][] = new boolean[20][5];

MatrixGen mg;

String tt="";

int cntr = 0;
int chaa = 65;

void setup(){
	size(200,200,P3D);
	frameRate(60);

	textFont(createFont("Veranda",9));
	textMode(SCREEN);
	

	pins = reverse(pins);

	mg = new MatrixGen(" ");
	
	ons = new boolean[pins.length];
	println(Serial.list()[0]);
	port = new Serial(this, Serial.list()[0], 115200);

	for(int i =0;i<pins.length;i++){
		offLed(i);
	}

}

void draw(){
	background(0);

	fill(255);
	noStroke();


	if(!mg.working){
		try{
			for(int i = 0;i<matrix[0].length;i++){
				if(mg.working){
					return;
				}else{

					if(matrix[cntr][i]){
						onLed(i);
					}else{
						offLed(i);
					}

				}
			}
		}catch(ArrayIndexOutOfBoundsException e){
			println("hmm routine error ...");
		}
	}

	/**
		stroke(255,120);
		for(int x = 0;x<matrix.length;x++){
			line(x*40,0,x*40,height);
			for(int y = 0;y<matrix[x].length;y++){
				line(0,y*40,width,y*40);


				if(matrix[x][y]){
					rect(x*40,y*40,40,40);
				}
			}
		}
		*/

	cntr++;
	if(cntr>=matrix.length){
		cntr = 0;
	}

	fill(255);
	text(tt,10,10,width-20,height-20);
	if(frameCount%10==0)
		text("_");
}


void keyPressed(){
	//println((int)key);
	if(((int)key)>=33&&((int)key<=122)){
		tt += key;

	}else if(keyCode == BACKSPACE){
		if(tt.length()>=1){
			tt = tt.substring(0,tt.length()-1);
		}

	}else if(key == ' '){
		tt += " ";

	}else if(keyCode==DELETE){
		tt= "";

	}else if(keyCode == ENTER){
		mg.rebuild(tt);
	}else if(keyCode == TAB){
		String q[] = loadStrings("input.txt");
		tt = "";
		for(int i = 0;i<q.length;i++){
			tt+=q[i]+" ";
		}
		println("loaded");
		
	}
	
}

void storeChar(){
	String s[] = new String[5];
	for(int i =0;i<5;i++){
		s[i] = "";
		for(int q =0;q<s.length;q++){
			if(matrix[i][q]){
				s[i]+=1;
			}else{
				s[i]+=0;
			}
		}
	}
	saveStrings(((char)chaa)+".txt",s);
	chaa++;

}

void changeMatrix(int _x,int _y){
	matrix[_x][_y]=!matrix[_x][_y];

}

void changeState(int which){
	which = constrain(which,0,pins.length);
	if(ons[which]){
		offLed(which);
	}else{
		onLed(which);
	}
}


void onLed(int which) {
	int sel = pins[which];
	ons[which] = true;
	port.write("w d ");                                     
	port.write(sel+" 1");
	port.write(13);
}


void offLed(int which) {
	int sel = pins[which];
	ons[which] = false;
	port.write("w d ");
	port.write(sel+" 0");
	port.write(13);
}




