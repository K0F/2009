import processing.pdf.*;

Node n[] = new Node[361];

PFont a,b;
	
void setup(){
	size(380,270,P3D);
	rectMode(CENTER);

	
	a = createFont("Veranda",4);
	b = createFont("Veranda",20);
	
	for(int i =0;i<n.length;i++){
		n[i] = new Node(i);
	}
	background(0);
}

void draw(){
	//background(255);

	for(int i =0;i<n.length;i++){
		n[i].run();
	}
	
	storeNodes(frameCount);
}

void keyPressed(){
	if(key==' '){
		storeNodes(0);
		println("output sored!");
	}



}


void storeNodes(int nu){
	PGraphics p = createGraphics(width,height,P3D);
	loadPixels();
	for(int i =0 ;i<pixels.length;i++){
		p.pixels[i] = pixels[i];
	}

	boolean last = false;
	int lastROw = 0;

	int cnt = 0;
	PGraphics pdf = createGraphics(500, 800, PDF, "out/output"+nf(nu,6)+".pdf");
	pdf.beginDraw();
	pdf.background(0);
	
	
	pdf.textFont(b);
	pdf.textAlign(LEFT);
	pdf.fill(255,200);
	pdf.text("lenoid project",20,30);
	pdf.text("screen no."+frameCount,20,50);
	
	pdf.textFont(a);
	pdf.textAlign(CENTER);
	
	for(int y= 80;y<pdf.height-25;y+=25){
		for(int x= 25;x<pdf.width-10;x+=25){
			if(cnt<n.length){
				pdf.fill(255);
				pdf.text(cnt,x-5,y);

				n[cnt].pdfDraw(pdf,x+5,y);
				cnt++;


			}
		}
	}
	pdf.imageMode(CENTER);
	pdf.image(p,pdf.width/2,pdf.height-height/2-10,width/2,height/2);


	
	pdf.dispose();
	pdf.endDraw();
	if(frameCount>199){
		exit();
	}

}






