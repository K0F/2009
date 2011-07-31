/**
* 	Neural Network _alpha 0.4
*	by krystof pesek
*/

backPropagation bp;

int cntt = 0;
float error = 0.0;

float rate=1.0;
long epochs=100;
int nodesInEachLayer[]=new int[3];
int tag=0;
float meanSquareError=0.01;
String inputFile="input.txt";
String outputFile="output.txt";
int percentage=0;
int noOfSamples=0;
boolean prnt;

int num;

void setup(){
	size(300,300,OPENGL);

	num = 20;

	nodesInEachLayer[0]=6;
	nodesInEachLayer[1]=6;
	nodesInEachLayer[2]=1;

	//generateInOut();

	cycle(false);
}

void generateInOut(){
	String t[] = new String[num];
	for(int i =0;i<t.length;i++){
		t[i] = "";
		for(int w =0;w<nodesInEachLayer[0];w++){
			if(random(100)>=50){
				t[i] += 1+"";
			}else{
				t[i] += 0+"";
			}
			if(w!=nodesInEachLayer[0]-1){
				t[i] += " ";
			}
		}
	}
	saveStrings("input.txt",t);



	for(int i =0;i<t.length;i++)
	{
		t[i] = "";
		for(int w =0;w<nodesInEachLayer[2];w++){
			if(random(100)>=50){
				t[i] += 1+"";
			}else{
				t[i] += 0+"";
			}
			if(w!=nodesInEachLayer[2]-1){
				t[i] += " ";
			}
		}
	}
	saveStrings("output.txt",t);


}

void draw(){
	//background(0);

	//generateInOut();
	cycle(false);

	fill(255);

	pushMatrix();
	translate(20,20);
	
	
	
	println(error);
	for(int i =0;i<num;i++){
		error += (bp.test(i+1)-error)/num;
		stroke(map(bp.test(i+1),error*0.999,1,0,255),200);
		line(map(i,0,num,10,width-10),frameCount%height,map(i+1,0,num,10,width-10),frameCount%height);
		line(map(i,0,num,10,width-10),frameCount%height,-1+map(i,0,num,10,width-10),frameCount%height);
	}

	popMatrix();



}

void cycle(boolean _prnt){
	prnt=_prnt;

	float sampleMatrix[][]=new float[100][100];
	float desiredOutput[]=new float[100];
	float weightMatrix[][][]=new float[2][100][100];

	Network network=new Network();
	ReadAndWrite readAndWrite=new ReadAndWrite();

	// Initialize the weights in the network
	weightMatrix=network.randomiser(nodesInEachLayer);

	//Read input from the input file and store it in matrix
	sampleMatrix=readAndWrite.makeMatrix(nodesInEachLayer[0],inputFile,percentage);
	noOfSamples=readAndWrite.noOfSamples();

	//Read output from output file and store it in a vector form.
	desiredOutput=readAndWrite.readOutput(1,outputFile);

	//Call backPropagation	and send all the specification to start the training of neural network
	bp=new backPropagation(rate,epochs,weightMatrix,nodesInEachLayer,sampleMatrix,desiredOutput,noOfSamples,meanSquareError);

	//for(int i =0;i<num;i++)
	//backPropagation.testing(i);
	//epochs=0;

}


class Network{
	float[][][] randomiser(int nodesInEachLayer[]){

		/*
			 This method simply set the weights to some random values between 1 and 0. The input to this method is a array specifying all the nuber od nodes in each layer of the network. The output from this method is a 3D matrix which has all the weights initialized to some random values.
		*/

		int i;
		int j;
		int k;
		float weightMatrix[][][]=new float[2][100][100];
		Random random=new Random();

		for(k=0;k<2;k++){
			for(i=0;i<nodesInEachLayer[k];i++){
				for(j=0;j<nodesInEachLayer[k+1];j++){
					weightMatrix[k][i][j]=random.nextFloat();
				}// End of j
			}// End of i
		}// End of k
		return(weightMatrix);

	}// End of method randomiser.


	float[][] multiply(float matrixOne[][],float matrixTwo[][][],int rowsInOne, int coloumsInOne,int coloumsInTwo,int matrixNumber){
		/*
			It will perform two matrix multiplication. The input to this method are a 2D matrix , 3D matrix,  number of rows in first matrix, number of coloums in first matrix , number of coloums in second matrix and a number specifying weather it is matrix one or matrix two in the 3D matrix. The output from this method is a 2D matrix which is the product of the two input matrix.	
		*/


		float multipliedMatrix[][]=new float[rowsInOne][coloumsInTwo];

		int i;
		int j;
		int k;

		for(i=0;i<rowsInOne;i++){
			for(j=0;j<coloumsInTwo;j++){
				multipliedMatrix[i][j]=0.0;
				for(k=0;k<coloumsInOne;k++){
					//System.out.println("i "+i+" j "+j+" k "+k);
					multipliedMatrix[i][j]=multipliedMatrix[i][j]+matrixOne[i][k]*matrixTwo[matrixNumber-1][k][j];
				}// End of k

			}// End of j

		}// End of i

		return(multipliedMatrix);


	}// End of method multiply.


	float[][][] transpose(float matrix[][][],int noOfRows,int noOfColoums,int number){
		/*
			This method takes inputs as a 3D matrix, the number of rows in the matrix, number of coloumns in the matrix and a number specifying weather it is matrix one or matrix two in the 3D matrix . It returns a 3D matrix which is the transpose of the input matrix.
		*/

		int i;
		int j;
		float temp[][][]=new float[2][100][100];
		for(i=0;i<noOfRows;i++){
			for(j=0;j<noOfColoums;j++){
				temp[number-1][j][i]=matrix[number-1][i][j];

			}// End of j
		}// End of i
		return(temp);
	}// End of method transpose.

}// End of class Network.


class ReadAndWrite{
	int lengthOfFile=0;



	float[][] makeMatrix(int sampleSize,String fileName,int percentage){
		/*
		This method reads the input file and takes the samples from it and put it in a matrix form. The input to this method are the number of attributes in the sample and the file name from which the sample has to be read. It then read the whole file and make a matrix out of it.

		*/


		//float inputMatrix[0][0];
		//String fileName = _fileName;
		//String loadStrings()

		float inputMatrix[][]=new float[100][sampleSize];
		String lineOfFile=" ";

		int i;
		int j;
		int counter=0;
		float temp;
		int factor;

		try{
		//	println(sketchPath+"/"+fileName);
			RandomAccessFile file = new RandomAccessFile(sketchPath+"/"+fileName,"rw");

			lengthOfFile=(int)((file.length())/(int)(2*sampleSize));
			temp=(lengthOfFile*(percentage/100.0));
			factor=lengthOfFile-(int)(temp);

			if(factor!=0){
				temp=lengthOfFile-lengthOfFile/factor;
			}
			if((temp==0)||(factor==0)){
				System.out.println("Error : No training data available ");
				temp=lengthOfFile;
				epochs=1;
				factor=0;

			}

			for(i=0;i<temp;i++){
				if(factor!=0){
					if(i%factor==0){
						file.readLine();
					}
				}
				lineOfFile=file.readLine();

				StringTokenizer st= new StringTokenizer(lineOfFile);
				for(j=0;j<sampleSize;j++){
					inputMatrix[counter][j]=Float.parseFloat(st.nextToken());
					// System.out.print(inputMatrix[i][j]+"  ");

				}// End of j
				//System.out.println();
				counter++;

			}// End of i

			file.close();
		}catch(Exception e){
			System.out.println("ERROR 1 "+e.toString());
		}
		return(inputMatrix);

	}// End of method makeMatrix.



	int noOfSamples(){
		/*
			This method just returns te number of samples in the file as it is srored in the variable lengthOfFile which has the value from the method 
		*/
		return(lengthOfFile);
	}// End of method noOfSamples.



	float[] readOutput(int nodesInOutputLayer,String fileName){

		/*
			This method reads the output file and takes the samples from it and put it in a vector form. The input to this method are array specifying the nodes in each Layer of the network and the fileme of the output file. It then read the whole file and make a vector out of it.

		*/	


		int i;
		float desiredOutput[]=new float[100];
		String lineOfFile=" ";

		try{
			RandomAccessFile file = new RandomAccessFile(sketchPath+"/"+fileName,"rw");
			for(i=1;i<=((int)(file.length()/(2)));i++){
				lineOfFile=file.readLine();
				desiredOutput[i-1]=Float.parseFloat(lineOfFile);
				//System.out.println("desired output "+desiredOutput[i-1]);

			}// End of i

			file.close();
		}catch(Exception e){
			System.out.println("ERROR 2 "+e.toString());
		}

		return(desiredOutput);

	}// End of method readOutput.




}// End of class ReadAndWrite


class backPropagation{
	float rate;
	long epochs;
	long i;
	long j;
	int noOfSamples;
	float weightMatrix[][][]=new float[2][100][100];
	float desiredOutput[]=new float[100];
	float sampleInput[][]=new float[100][100];
	int nodesInEachLayer[]=new int[3];
	float meanSquareError;

	Network network=new Network();

	backPropagation(float rate,long epochs,float weightMatrix[][][],int nodesInEachLayer[],float sampleInput[][],float desiredOutput[],int noOfSamples,float meanSquareError){
		this.rate=rate;
		this.epochs=epochs;
		this.noOfSamples=noOfSamples;
		this.weightMatrix=weightMatrix;
		this.sampleInput=sampleInput;
		this.desiredOutput=desiredOutput;
		this.nodesInEachLayer=nodesInEachLayer;
		this.meanSquareError=meanSquareError;

		startTraining();


	}// End of constructor.

	void startTraining(){
		cntt ++;
		println("generation "+(cntt*epochs));
		/*
			This the method which is called by the constructor and it does the whole mauplation of the weights in the network. The main loop is repeated as many times as the epochs. It uses the backPropagation algorithm to calculate the weight change for all the sample in one step and then add the weight change into the weights of the network. It uses the batch mode updation therefore the weight are not changed untill each epoch. The observed output is calculated by multipying the input sample matrix which is builed by makeMatrix() method in ReadAndWrite class with the weightMatrix of the network and then passing it to the transfer function. The transfer function used is the log sig which is also declared in this class. This method calculates the Mean square error and display it on the terminal after each epoch.
		*/
		int i;
		int j;
		int k;
		int l;

		float MSE=0.0;
		float inputToHiddenLayer[][]=new float[noOfSamples][nodesInEachLayer[1]];
		float activationOfHiddenLayer[][]=new float[noOfSamples][nodesInEachLayer[1]];
		float inputToOutputLayer[][]=new float[noOfSamples][nodesInEachLayer[2]];
		float observedOutput[][]=new float[noOfSamples][nodesInEachLayer[2]];
		float benifitOfOutputLayer[]=new float[noOfSamples];
		float benifitOfHiddenLayer[][]=new float[noOfSamples][nodesInEachLayer[1]];
		float derivative[]=new float[noOfSamples];
		float temp1[][]=new float[noOfSamples][1];
		float temp2[]=new float[noOfSamples];
		float temp3[][]=new float[noOfSamples][nodesInEachLayer[1]];
		String st=new String();


		try{
			RandomAccessFile file = new RandomAccessFile("mse.txt","rw");



			for(i=0;i<epochs;i++){
				MSE=0.0;
				inputToHiddenLayer=network.multiply(sampleInput,weightMatrix,noOfSamples,nodesInEachLayer[0],nodesInEachLayer[1],1);


				for(k=0;k<noOfSamples;k++){
					for(j=0;j<nodesInEachLayer[1];j++){
						activationOfHiddenLayer[k][j]=sigmoidal(inputToHiddenLayer[k][j]);
						//System.out.print(" "+activationOfHiddenLayer[k][j]);
					}// End of j
					//System.out.println();
				}// End of k


				inputToOutputLayer=network.multiply(activationOfHiddenLayer,weightMatrix,noOfSamples,nodesInEachLayer[1],nodesInEachLayer[2],2);

				for(k=0;k<noOfSamples;k++){
					for(j=0;j<nodesInEachLayer[2];j++){
						observedOutput[k][j]=sigmoidal(inputToOutputLayer[k][j]);
						//System.out.print(" "+inputToOutputLayer[k][j]);
					}//end of j

					benifitOfOutputLayer[k]=desiredOutput[k]-observedOutput[k][0];
					derivative[k]=observedOutput[k][0]*(1.0-observedOutput[k][0]);
					temp1[k][0]=derivative[k]*benifitOfOutputLayer[k];
					temp2[k]=temp1[k][0]*rate;
					for(j=0;j<nodesInEachLayer[1];j++){
						weightMatrix[1][j][nodesInEachLayer[2]-1]=weightMatrix[1][j][nodesInEachLayer[2]-1]+activationOfHiddenLayer[k][j]*temp2[k];

					}//end of j


					MSE=MSE+benifitOfOutputLayer[k]*benifitOfOutputLayer[k];

				}//end of k
				MSE=MSE/noOfSamples;


				st=String.valueOf(MSE);

				file.writeBytes(st);
				file.writeBytes(" ");

				if(MSE<=meanSquareError){
					System.out.println("Network Converged");
					System.out.println("Number Of Epochs = "+i);
					System.out.println("Mean Square Error"+MSE);
					break;

				}

				if(prnt)
					System.out.println("Mean Square Error :"+MSE);
				benifitOfHiddenLayer=network.multiply(temp1,network.transpose(weightMatrix,nodesInEachLayer[1],1,2),noOfSamples,1,nodesInEachLayer[1],2);
				for(k=0;k<noOfSamples;k++){
					for(j=0;j<nodesInEachLayer[1];j++){
						temp3[k][j]=rate*benifitOfHiddenLayer[k][j]*activationOfHiddenLayer[k][j]*(1.0-activationOfHiddenLayer[k][j]);

					}
					for(l=0;l<nodesInEachLayer[1];l++){
						for(j=0;j<nodesInEachLayer[0];j++){
							weightMatrix[0][j][l]=weightMatrix[0][j][l]+sampleInput[k][j]*temp3[k][l];
						}//end of j
					}//end of l
				}//end of k


				String q;
				for(l=0;l<2;l++)
					for(j=0;j<nodesInEachLayer[l];j++){
						for(k=0;k<nodesInEachLayer[l+1];k++){
							q = (weightMatrix[l][j][k]+"  ");
						}
						//System.out.println();
					}

			}//end of for i=epochs

			file.close();
		}catch(Exception e){
			System.out.println("ERROR 3 "+e.toString());
		}

	}// End of method startTraining.


	float sigmoidal(float inputValue){
		/*
			method just takes input as some real number and calculates the sigmoidal function of that value and return the same.
		*/
		return(float)((1.0/(1.0+Math.exp(-1.0*inputValue))));


	}// End of method sigmoidal.


	void testing(int sampleNo){
		int i;
		int j;
		float sum;
		float sample[]=new float[nodesInEachLayer[0]];
		float temp[]=new float[nodesInEachLayer[1]];
		for(i=0;i<nodesInEachLayer[0];i++){
			sample[i]=sampleInput[sampleNo-1][i];
		}
		for(j=0;j<nodesInEachLayer[1];j++){
			sum=0.0;
			for(i=0;i<nodesInEachLayer[0];i++){

				sum=sum+sample[i]*weightMatrix[0][i][j];

			}
			temp[j]=sigmoidal(sum);
		}
		sum=0.0;
		for(i=0;i<nodesInEachLayer[1];i++){
			sum=sum+temp[i]*weightMatrix[1][i][0];
		}
		sum=sigmoidal(sum);
		System.out.println("The Observed Output is "+sum );
		System.out.println("The Desired Output is "+desiredOutput[sampleNo-1]);

	}

	float test(int sampleNo){

		int i;
		int j;
		float sum;
		float sample[]=new float[nodesInEachLayer[0]];
		float temp[]=new float[nodesInEachLayer[1]];
		for(i=0;i<nodesInEachLayer[0];i++){
			sample[i]=sampleInput[sampleNo-1][i];
		}
		for(j=0;j<nodesInEachLayer[1];j++){
			sum=0.0;
			for(i=0;i<nodesInEachLayer[0];i++){

				sum=sum+sample[i]*weightMatrix[0][i][j];

			}
			temp[j]=sigmoidal(sum);
		}
		sum=0.0;
		for(i=0;i<nodesInEachLayer[1];i++){
			sum=sum+temp[i]*weightMatrix[1][i][0];
		}
		sum=sigmoidal(sum);



		return sum;

	}





}// End of class backPropagation




