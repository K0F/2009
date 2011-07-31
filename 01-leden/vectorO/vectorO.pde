Vector xes = new Vector(), yes = new Vector();

void setup(){
	size(200,200);
	background(255);
	
	for(int i =0;i<20;i++){
		xes.add(i*10.0);
		yes.add(i*10.0);
	}
	
	stroke(0);
	for(int i =0;i<xes.size();i++){
		float x = (Float)xes.get(i);
		line(x,0,x,height);
		float y = (Float)yes.get(i);
		line(0,y,width,y);
	}
	
}
