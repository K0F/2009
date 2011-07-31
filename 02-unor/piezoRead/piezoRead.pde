import processing.serial.*;


Serial port;

void setup(){
	size(200,100,P3D);
	background(0);

	// List all the available serial ports:
	println(Serial.list());
	println("done!");
	
	if(Serial.list().length<1){
		println("error: Arduino not listed");
	exit();
	
	}else{
	
	/*  I know that the first port in the serial list on my mac
	is always my  Keyspan adaptor, so I open Serial.list()[0].
	Open whatever port is the one you're using.
	*/
	
	port = new Serial(this,Serial.list()[0],9600);
	textFont(createFont("Veranda",9));
	textMode(SCREEN);
	// Send a capital A out the serial port:
	port.write(65);
}
	fill(255);
	


}

byte val[];
int in = 0;

void draw(){
	fill(0);
	noStroke();
	rect(0,0,width,20);
	fill(255);
	
	stroke(255);
	point(frameCount%width,map(in,10,70,0,100));
	fill(255);
	text(in,10,10);
	
	if(port.available()>-1){
				
		int ina = port.read();
		if (ina>-1)
			in+=(ina-in)/5.0;
		//println(ina);
		port.clear();
		//println(in);
	}
	
	if(frameCount%width==0)
		background(0);
	
	

}    

