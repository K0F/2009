
class Mozek{
	Keuron k[][];
	int[] layers = LAYERS;

	Mozek(){

		k = new Keuron[layers.length][0];

		// create keurons
		for(int i = 0;i < layers.length;i++){
			GRAPY+=GRAPSTEP;
			GRAPX=0;



			for(int t = 0;t < layers[i];t++){

				k[i] = (Keuron[])expand(k[i],k[i].length+1);
				k[i][k[i].length-1] = new Keuron(i,this);
				GRAPX+=GRAPSTEP;
			}

			if(i==0){


				k[i] = (Keuron[])expand(k[i],k[i].length+1);
				k[i][k[i].length-1] = new Keuron(i,this,0);

				GRAPX+=GRAPSTEP;
				k[i] = (Keuron[])expand(k[i],k[i].length+1);
				k[i][k[i].length-1] = new Keuron(i,this,1);
				GRAPX+=GRAPSTEP;

			}



		}

		// fill keurons with connexions
		for(int i = 0;i < layers.length;i++){
			for(int t = 0;t < layers[i];t++){
				fillIns(i,t);
			}
		}

	}

	void act(){
		for(int i = 0;i < layers.length;i++){
			for(int t = 0;t < layers[i];t++){
				k[i][t].act();
			}
		}

	}

	int[] getIns(int lay,int kolik){

		int temp[] = new int[kolik];
		int vse[] = new int[LAYERS[lay]];
		int zbytek[] = new int[0];


		for(int i =0;i<vse.length;i++){
			vse[i] = k[lay][i].id;
		}

		for(int i =0;i<kolik;i++){

			int rand = (int)random(vse.length);
			temp[i] = rand;

			zbytek = new int[0];
			for(int t = 0;t<vse.length;t++){
				if(vse[t]!=rand){
					zbytek = (int[])expand(zbytek,zbytek.length+1);
					zbytek[zbytek.length-1] = vse[t];
				}
			}

			vse = new int[zbytek.length];
			for(int r = 0;r<zbytek.length;r++){
				vse[r] = zbytek[r];
			}

		}

		return temp;

	}

	int[] getIns2(int lay){

		int vse[] = new int[k[lay].length];
		for(int i =0;i<vse.length;i++){
			vse[i] = i;
		}
		return vse;

	}

	void fillIns(int l,int n){

		if(l!=0){
			k[l][n].ins = getIns2(l-1);
			k[l][n].initW();
		}
	}

}

class Keuron{

	float x,y;

	float val;
	int id;
	int[] ins;
	float[] w;
	boolean active;
	int layer;
	Mozek parent;

	Keuron(int _layer,Mozek _parent){
		id = register;
		register++;
		parent = _parent;

		// prvni / posledni / jine?
		layer = _layer;

		ins = new int[0];
		val = 0;//random(0,100)*0.01;
		active = true;

		x = GRAPX;
		y = GRAPY;

		if(layer==0){
			val = IN[id];
		}

	}

	Keuron(int _layer,Mozek _parent,float _val){
		id = register;
		register++;
		parent = _parent;

		// prvni / posledni / jine?
		layer = _layer;

		ins = new int[0];
		val = _val;
		x = GRAPX;
		y = GRAPY;

	}

	void initW(){
		w = new float[ins.length];
		for(int i =0;i<w.length;i++){
			w[i] = random(-100,100)*0.01;
		}

	}

	void act(){
		//if(!learning)
		refresh();

		if(STOCHAIST){

			if(layer!=0)
				stochaist(NOISEAMOUNT);
		}

	}

	void refresh(){
		if(layer>0){
			//if(learning){
			float soucet = 0;

			for(int i = 0;i<ins.length;i++){
				w[i] = constrain(w[i],-1,1);
				//if(parent.k[layer-1][ins[i]].active)
				soucet += parent.k[layer-1][ins[i]].val*w[i];
			}


			val = sigmoid2(soucet,ins.length,SLOPE);
			val = constrain(val,0,255);
			//}

		}else{
			val = IN[id]*255;
		}

	}

	void stochaist(float kolik){

		val += random(-100,100)/kolik;
		val = constrain(val,0.0,1.0);

	}

}
