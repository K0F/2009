PShape a;

void setup(){
	size(300,300);
	a = loadShape("drawing.svg");
	smooth();
}

void draw(){
	//background(255);
	fill(0,120);
	rect(0,0,width,height);
	
	tint(#FFCC00,120);	
	
	for(int x = 10;x < width-10;x+=20){
	for(int y = 10;y< height-10;y+=20){
	shape(a,x+random(-2,2),y+random(-2,2),15,15);
}

}

}

void keyPressed(){
	if(key==' '){
		saveFrame("shot####.png");
	}

}
