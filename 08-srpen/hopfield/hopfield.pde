
int X = 128;
int Y =  X;

int cycle = 0;

boolean textual = false;

boolean pattern[] = new boolean[X];
int wt[][] = new int[X][Y];

float cerror;
float crr[];

float inm[];
float outm[];

boolean learning = false;
boolean doLearn = true;

int [][] lcyc;
int lc = 0;

int[][] matrix = new int[X][Y];
int input[] = new int[X];
int output[] = new int[X];
int error[] = new int[X];


void setup(){

	size(1000,240,P2D);
	background(0);

	cerror = .5;
	crr = new float[width];
	outm = new float[width];
	inm = new float[width];
	for(int i=0;i<width;i++){
		crr[i] = 0;
		inm[i] = 0;
		outm[i] = 0;
	}

	reborn(width);


	//rndIn();
	initNet();
	runNetwork();




	textFont(createFont("04b03b",8));
	textMode(SCREEN);
	textAlign(RIGHT);
	noStroke();


}

void reborn(int lin){
	createPattern(lin);
	lcyc = loadPattern();

}

void createPattern(int len){
	String s[] = new String[len];


	int vala = 200;

	for(int q = 0 ;q<len;q++){
		String temp = "";
		vala += random(-2,3);
		vala = constrain(vala,0,255);
		
		for(int i = 0 ;i<16;i++){
			temp+=nf(parseInt(binary(vala)),8)+"";
		}
		s[q] = temp+"";
	}

/*
	for(int i = 0 ;i<len;i++){
		String temp = "";
		rndIn();
		for(int z =0; z<X;z++){
			temp+=input[z]+"";
		}
		s[i] = temp+"";
	}
*/
	saveStrings("data/set.txt",s);
}

int[][] loadPattern(){
	String s[] = loadStrings("set.txt");
	int[][] ans = new int[s.length][X];

	for(int i = 0 ;i<s.length;i++){
		String temp = s[i]+"";
		for(int z =0; z<X;z++){
			ans[i][z] = parseInt(s[i].charAt(z)+"");
		}

	}

	return ans;
}

void draw(){
	background(0);


	int val = funpack(input);
	inm[frameCount%width]=map(val,0,255,height-10,10);

	val = funpack(output);
	outm[frameCount%width]=map(val,0,255,height-10,10);


	noFill();

	if(doLearn){
		fill(255);
		text("L",width-2,height-10);
		learnCyc(1);

	}

	if(!learning)
		test();

	fill(255);
	for(int x = 0;x<matrix.length;x++){
		if(input[x]==1)
			fill(#FF0000);
		else
			fill(255);

		if(textual)
			text(input[x],x*10+20,10);
		else
			rect(x+20,10,1,1);
	}

	for(int x = 0;x<matrix.length;x++){
		if(error[x]==1)
			fill(#FF0000);
		else
			fill(255);

		if(textual)
			text(output[x],x*10+20,height-20);
		else
			rect(x+20,height-20,1,1);
	}

	fill(255);
	text(cycle,width-2,10);



	stroke(255,50);
	line(0,height/2,width,height/2);




	for(int i=0;i<width;i++){
		stroke(255);
		point(i,map(crr[i],0,1,height-10,10));
		stroke(#00FF00);
		point(i,inm[i]);
		stroke(#FFCC00);
		point(i,outm[i]);

	}
	noStroke();


}

void learnCyc(int kolik){
	for(int i =0;i<kolik;i++)
		drill();

}

void keyPressed(){
	if(key == ' '){
		drill();
		learning = true;
	}else if(key=='l'){
		doLearn = !doLearn;
	}
}


void keyReleased(){
	if(key == ' '){

		learning = false;
	}else if(keyCode == ENTER){
		reborn(width);
	}
}

void drill(){


	train();
	//runNetwork();
	//initNet();



}

void test(){
	lc++;
	if(lc>(lcyc.length-1)) lc=0;
	input = lcyc[lc];

	initNet();

	runNetwork();

	float q = 0;
	for(int i =0;i<X;i++){
		q += error[i];
	}
	q = (q/(X+0.0));

	cerror += (q-cerror)/10.0;

	crr[frameCount%(width-1)] = cerror;

}

void rndIn(){


	input = new int[X];
	for(int i =0;i<input.length;i++)
		if(random(100)>50)
			input[i] = 1;
		else
			input[i] = 0;

}


void initNet(){

	for ( int row=0;row<X;row++ )
		for ( int col=0;col<Y;col++ )
			wt[row][col]=matrix[row][col];
	for ( int row=0;row<X;row++ ) {
		int i = input[row];
		if ( i==0 )
			pattern[row] = false;
		else
			pattern[row] = true;
	}

}

void runNetwork() {




	Network net = new Network(wt);
	net.activation(pattern);

	for ( int row=0;row<X;row++ ) {
		if ( net.output[row] )
			output[row] = 1;
		else
			output[row] = 0;
		if ( net.output[row]==pattern[row] )
			error[row] = 0;
		else
			error[row] = 1;
	}
}


void clear(){
	for ( int row=0;row<X;row++ )
		for ( int col=0;col<Y;col++ )
			matrix[row][col] = 0;
}

int[] unpack(int[] in,int num){
	int[] answ = new int[num];

	int tc = 0;
	for(int i =0;i<num;i++){
		String tmp = "";

		for(int q =0;q<8;q++){
			if(in[q+tc]==1)
				tmp+=1+"";
			else
				tmp+=0+"";

		}

		answ[i] = unbinary(tmp);
		tc+=8;
	}

	return answ;
}

int funpack(int[] a){
	int res = 0;
	for(int i =0;i<16;i++)
		res+=unpack(a,16)[i];

	res = (int)(res/16.0);

	return (res);

}

void train(){
	cycle ++;
	int work[][] = new int[X][Y];
	int bi[] = new int[X];

	for ( int x=0;x<X;x++ ) {
		if ( input[x]==0 )
			bi[x] = -1;
		else
			bi[x] = 1;
	}

	for ( int row=0;row<X;row++ )
		for ( int col=0;col<Y;col++ ) {
			work[row][col] = bi[row]*bi[col];
		}

	for ( int x=0;x<X;x++ )
		work[x][x] -=1;

	for ( int row=0;row<X;row++ )
		for ( int col=0;col<Y;col++ ) {
			int i = matrix[row][col];
			matrix[row][col] = i+work[row][col];
		}

}


