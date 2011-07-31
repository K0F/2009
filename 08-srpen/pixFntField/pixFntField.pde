

PGraphics anim;

int cntr = 0;

void setup(){

	size(176,220);
	background(0);
	frameRate(3);
	textFont(createFont("04b08",8));
	fill(255);
	animate();
	
}

void animate(){

	
	anim = createGraphics(width,height,P3D);
	anim.beginDraw();
	//anim.textFont(createFont("04b08",64));
	anim.fill(255,85);
	anim.pushMatrix();
	anim.translate(0,0,100);
	anim.rect(-width,-height,3*width,3*height);
	anim.popMatrix();
	
	anim.strokeWeight(5);
	anim.fill(#999999,160);
	anim.stroke(0);
	
	anim.pushMatrix();
	anim.translate(width/2.0,height/2.0);
	anim.rotateX(radians(-45));
	anim.rotate(radians(cntr));
	anim.box(70);
	
	anim.popMatrix();
	//anim.text("kof",20,height-30);
	anim.endDraw();

}



void draw(){

	
	background(0);
	//image(anim,0,0);
	
	anim.loadPixels();
	for(int y = 2;y<height-2;y+=6){
		for(int x = 2;x<width-2;x+=6){
			fill(anim.pixels[y*width+x]);
			text((char)((int)(random(0,27)+65)),x,y);
		}

	}
	
	saveFrame("fr####.png");
	println(cntr);

	animate();
	cntr+=5;
}
