
int num = 50;
Node n[];

Recorder r;
boolean record = false;


void setup(){
	size(320,240,P3D);
	background(255);

	n = new Node[num];
	for(int i = 0;i<num;i++)
		n[i] = new Node(i);

	rectMode(CENTER);

	if(record){
		r = new Recorder("out","netCon.avi");
	}




}


void draw(){
	background(255);

	stroke(0);
	noFill();
	for(int i = 0;i<n.length;i++){
		if(n[i].alive)
		n[i].run();
		}

	if(record)
		r.add();

}

void destroy(int _id){
	Node[] pre;
	if(_id<1){
	pre = new Node[1];
	pre[0] = n[0];
	}else{
	pre = (Node[])subset(n,0,_id);
	}
	Node[] post = (Node[])subset(n,_id,n.length-pre.length);

	for(int i =1;i<post.length;i++){
		pre = (Node [])append(pre,post[i]);
	}

	n=pre;

}

void keyPressed(){
	if(key=='q'){
		if(record)
			r.finish();
		exit();
	}

}



class Node{

	float x,y,dx,dy;
	int id;
	float tresh = 40.0;
	int neighs[];
	boolean alive = true;

	Node(int _id){
		id=_id;
		dx=x=random(width);
		dy=y=random(height);
	}

	void run(){
		compute();
		draw();
	}

	void compute(){

		neighs = new int[0];

		for(int i = 0;i<num;i++){
			if(i!=id&&n[i].alive){
//				
				
				if(dist(n[i].dx,n[i].dy,dx,dy)<1){
				alive=false;
					//destroy(id);
				/*
				if(random(1000)>500){
						x-=10;
					}else{
						x+=10;
					}
					
					if(random(1000)>500){
						y-=10;
					}else{
						y+=10;
					}*/
				//y=random(height);
				}else if(dist(n[i].x,n[i].y,x,y)<tresh/1.5){
				x-=(n[i].x-x)/(tresh/5.0);
				y-=(n[i].y-y)/(tresh/5.0);
			}else if(dist(n[i].x,n[i].y,x,y)<tresh){
				neighs = (int[])expand(neighs,neighs.length+1);
				neighs[neighs.length-1] = i;

				x+=(n[i].x-x)/tresh;
				y+=(n[i].y-y)/tresh;
			}

			}
		}


		x=constrain(x,0,width);
		y=constrain(y,0,height);

		dx+=(x-dx)/20.0;
		dy+=(y-dy)/20.0;
	}



	void draw(){
		stroke(0,45);
		rect(dx,dy,3,3);

		stroke(0,10);
		for(int i = 0 ;i<neighs.length;i++){
			line(n[neighs[i]].dx,n[neighs[i]].dy,dx,dy);

		}


	}



}
