int num = 300;
float tresh = 0.0;
Node[] n;

void setup(){
	size(300,300,P2D);
	background(0);
	rectMode(CENTER);

	n = new Node[num];

	for(int i =0;i<num;i++){
		n[i] = new Node(i,2);
	}

	noFill();
	stroke(255);
}

void draw(){

	background(0);

	for(int i =0;i<num;i++){
		n[i].calc();
		n[i].update();
	}


	for(int i =0;i<num;i++){
		n[i].draw();
	}



}

class Node{
	float x,y;
	int id,inum;
	int ins[];
	float w[];
	boolean active = true;
	float sum = 0,sum2;

	Node(int _id,int _inum){
		id = _id;
		inum = _inum;
		ins = new int[inum];
		w = new float[inum];
		sum2 = 2;
		x = random(width);

		y = random(height);



		for(int i = 0;i<inum;i++){
			
			
				ins[i] = (int)random(num);
				if(ins[i]==id)			
			while(ins[i]==id){
				ins[i] = (int)random(num);
			}
			w[i] = random(-100,100)/100.0;
			
		}


	}

	void calc(){
		if(id<5){
			sum = random(-100,100)/100.0;
		
		}else{
		float sum = 0;
		
		int cnt = 0;
		for(int i = 0;i<inum;i++){
			if(n[i].active){
				sum += n[i].sum2*w[i];
				cnt++;	
			}
		}
		sum = (sum/(cnt+0.0));
		}

	}

	void update(){
		sum2 += (sum-sum2)/3.0;
		x = map(sum2,-1,1,0,width);
		
		if(sum>=tresh){
			active = true;
		}else{
			active = false;
		}
	}

	void draw(){
		stroke(255,map(sum2,-1,1,0,255));
		rect(x,y,3,3);

		for(int i =0;i<inum;i++){
			stroke(255,map(sum2,-1,1,0,255));
			line(n[ins[i]].x,n[ins[i]].y,x,y);
		}


	}



}
