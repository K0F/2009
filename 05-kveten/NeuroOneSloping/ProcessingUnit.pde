class ProcessingUnit{

	Neuron n[][];

	float IN[],OUT[];
	float res[],desire[];

	color c;
	int X,Y;
	int id;

	ProcessingUnit(int inA, int inB,color _c,int _id){
		X=inA;
		Y=inB;
		c=_c;
		id = _id;

		
		
		reset(map(X,0,img.width,0,1),map(Y,0,img.height,0,1));
		X++;
		if(X)
		Y++;

	}

	void createNeurons(){
		n = new Neuron[layers.length][0];

		for(int i =0;i<layers.length;i++){
			for(int q = 0;q<layers[i];q++){
				if(i==0&&q==layers[i]-1){

					n[i] = (Neuron[])expand(n[i],n[i].length+1);
					n[i][n[i].length-1] = new Neuron(q,i,id,false);
					n[i] = (Neuron[])expand(n[i],n[i].length+1);
					n[i][n[i].length-1] = new Neuron(q,i,id,true);
					
					
				}else{
					
					n[i] = (Neuron[])expand(n[i],n[i].length+1);
					n[i][n[i].length-1] = new Neuron(q,i,id,false);

				}
			}

		}

		//first run
		for(int r1 =0;r1<layers.length;r1++){
			for(int r2 =0;r2<layers[r1];r2++){
				n[r1][r2].compute();
			}
		}

	}

	void reset(float _A,float _B){
		// ceate inputs
		IN = new float[layers[0]];

		IN[0] =  _A;
		IN[1] =  _B;

		//for(int i =0;i<IN.length;i++){
		//	IN[i] = map(i,0,IN.length-1,0,1);
		//}

		//create ouput and desired result

		OUT = new float[layers[layers.length-1]];
		res = new float[OUT.length];
		desire = new float[OUT.length];

		//for(int i =0;i<OUT.length;i++){
		desire[0] = brightness(c);
		//desire[1] = green(c);
		//desire[2] = blue(c);
		//}

		//init matrix





	}

	void iterate(int kolik){


		for(int d =0;d<kolik;d++){


			//collect inputs
			//for(int i =0;i<IN.length;i++){
			//	IN[i] = map(i,0,IN.length,0,1);
			//}

			//proceed matrix


			//learn matrix
			for(int i =0;i<layers.length;i++){
				for(int q =0;q<layers[i];q++){
					n[i][q].learn();
				}
			}

			//collect result
			for(int i = 0;i<OUT.length;i++){
				res[i] = abs(desire[i]-OUT[i]);
				sqerr += ((res[i])-sqerr)/(OUT.length+0.0);
			}
		}

	}

	void act(){



		if(learning){
			iterate(1);
			stroke(current());
			line(IN[0],IN[1],IN[0]+1,IN[1]);
		}else{

			IN[0] += ((random(0,100)/100.0)-IN[0])/3.0;

			IN[1] += ((random(0,100)/100.0)-IN[1])/3.0;

			IN[0]= constrain(IN[0],0,1);
			IN[1]= constrain(IN[1],0,1);

			for(int i =0;i<layers.length;i++){
				for(int q =0;q<layers[i];q++){
					n[i][q].compute();
				}
			}
		}
	}

	color current(){
		return color(OUT[0]*255);
	}
}
