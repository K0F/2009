String a  ="";

void setup(){
	size(200,200);
	textFont(loadFont("Monospaced.plain-9.vlw"));
	fill(255);

	for(int i =0;i<36;i++){
		a+="1";
	}
}
                                                                              
void draw(){
	background(0);

	for(int y = 10;y<height-8;y+=9){
		for(int x = 0;x<36;x++){
			if(random(255)>200){
				fill(120);
				text("1",x*5+10,y);
			}else{
				fill(20);
				text("0",x*5+10,y);
			}
		}
	}
}
