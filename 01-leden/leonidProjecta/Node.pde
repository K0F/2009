class Node{
	color c;
	boolean ons[][] = new boolean[3][3];
	float x,y;
	int id;
	float speed = 0.2;
	float br = 20.0;
	float stillx,stilly;
	int freeze = 0;

	Node(int _id){
		id=_id;

		x= random(br,width-br);
		y= random(br,height-br);

		c= color(random(150,255),random(150,255),random(55));

		for(int i = 0;i<ons.length;i++){
			for(int r = 0;r<ons[i].length;r++){
				if(random(501)<250){
					ons[i][r] = true;
				}else{
					ons[i][r] = false;
				}
			}
		}

	}

	void run(){
		noStroke();
		for(int i = 0;i<ons.length;i++){
			for(int r = 0;r<ons[i].length;r++){
				if(ons[i][r]){
					fill(0,15);
					x+=(i-1)*speed;
					y+=(r-1)*speed;
				}else{
					fill(255,15);
				}
				rect(((int)x+(i-1)*3),((int)y+(r-1)*3),3,3);
			}
		}

		bordr(3);
		checkFreeze(20);
		collision();
	}


	void pdfDraw(PGraphics p,float _x,float _y){
		p.noStroke();
		for(int i = 0;i<ons.length;i++){
			for(int r = 0;r<ons[i].length;r++){
				if(ons[i][r]){
					p.fill(255);

					p.rect((_x+(i-1)*3),(_y+(r-1)*3),3,3);
				}
			}
		}

	}

	void collision(){
		for(int i = 0;i<n.length;i++){
			if(i!=id){
				if(abs(x-n[i].x)<4.5&&abs(y-n[i].y)<4.5){
					mutate(1);
				}
			}
		}

	}

	void checkFreeze(int lim){
		if(stillx==x){
			freeze++;
		}else if(stilly==y){
			freeze++;
		}else{
			freeze = 0;
		}

		stillx =x;
		stilly = y;

		if(freeze>lim){
			mutate(1);
		}


	}

	void bordr(int qark){

		if(x>width-br){
			x=width-br-1;
			mutate(qark);
		}

		if(x<br){
			x=br+1;
			mutate(qark);
		}


		if(y>height-br){
			y=width-br-1;
			mutate(qark);
		}

		if(y<br){
			y=br+1;
			mutate(qark);
		}

		x= constrain(x,br,width-br);
		y= constrain(y,br,height-br);


	}

	void mutate(int mutace){
		int cn = 0;

		int pre[] = new int[mutace];

		for(int i=0;i<pre.length;i++){
			pre[i] = (int)random(sq(ons.length));
		}

		for(int i=0;i<pre.length;i++){
			ons[pre[i]/3][pre[i]%3] = !ons[pre[i]/3][pre[i]%3];
		}
	}
}


