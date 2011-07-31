//BPN taken from
//<http://www.patol.com/java/NN/index.html>
//
//	3 Layer Back Propagation Neural Network Class (BPN.class)
//
//	Author: Patocchi L.(patol@info.isbiel.ch, lorenz@cerfim.ch)
//	Date:		21st Mai 1996
//	
//	This class simulates a 3 layered neural network providing learning
//	functions and in future also disk IOs 
//
public class BPN {
  static final double	FIRE =			0.999;
  static final double 	NEUTRAL =		0.0;
  static final double 	DOWN =			-0.999;	
  static final double 	INIT =			-1.0;
  static final double	DELTA =			0.0;
  static final double	OUTPUT =		1.0;
  double instantError;
  double totalError;
  double absoluteError;
  double inpA[];          // activations
  double hidA[];          // activations
  double hidN[];          // sum of products
  double hidD[];          // output error
  double hidW[][];        // connection weights
  double outA[];          // activations
  double outN[];          // sum of products
  double outD[];          // output error
  double oldD[];          // old output error
  double outW[][];        // connection weights
  int Ninp;               // number of neurons on input  layer
  int Nhid;               // number of neurons on hidden layer
  int Nout;               // number of neurons on output layer
  double eida;            // learning rate
  double theta;           // sigmoid thresold
  double elast;           // elastics of sigmoid
  double momentum;	
  BPN(int i, int h, int o, double ei, double th, double el, double mo){		
    Ninp = i;
    Nhid = h;
    Nout = o;	
    this.inpA = new double[i];		
    this.hidW = new double[h][i];
    this.hidA = new double[h];
    this.hidN = new double[h];
    this.hidD = new double[h];		
    this.outW = new double[o][h];
    this.outA = new double[o];
    this.outN = new double[o];
    this.outD = new double[o];
    this.oldD = new double[o];		
    eida 	= ei;
    theta	= th;
    elast	= el;
    momentum = mo;		
    this.init();		
  }
  private double sigmoid( double x){
    // sig = 1.0 - Math.exp(-1.5* x + theta);
    double sig = ( 1.0 / (1.0 + Math.exp(-1.0 * elast * x + theta)) * 2.0 - 1.0);
    return sig; // (sig < -1.0)? (-1.0):(sig> 1.0)? (1.0): sig;
  }
  private double d1sigmoid(double x){
    //double sig = sigmoid(n,x);
    return 2.0 * Math.exp(-1.0 * elast * x -  theta)/(1+Math.exp(-2.0 * elast * x -  theta)); 
  }
  void feedForward(){
    double	sum2;
    for(int i = 0; i < Nhid; i++){
      sum2 = 0.0;
      for(int j = 0; j < Ninp; j++) sum2 += hidW[i][j] * inpA[j];
      hidN[i] = sum2;
      hidA[i] = sigmoid(sum2);
    }		
    for(int i = 0; i < Nout; i++){
      sum2 = 0.0;
      for(int j = 0; j < Nhid; j++) sum2 += outW[i][j] * hidA[j];
      outN[i] = sum2;
    }
  }	
  double computeDelta(int m){
    outD[m] = (outA[m] - sigmoid(outN[m])) * (d1sigmoid(outN[m]) + 0.1);
    for(int i = 0; i < Nhid; i++) outW[m][i] += outD[m] * hidA[i] * eida ;
    return outD[m]; // /(sig1(n,n->outN[m])+0.1);
  }	
  void updateWeights(){
    double	sum2;
    for(int m = 0; m < Nhid; m++){
      sum2 = 0.0;
      for(int i = 0; i < Nout; i++){ 
        sum2 += outD[i] * outW[i][m];
      };
      sum2 *= d1sigmoid(hidN[m]);
      for(int i = 0; i < Ninp; i++) hidW[m][i] += eida * sum2 * inpA[i];
    }
  }
  double frandom(double min, double max){
    return Math.random()*(max - min) + min;
  }
  void propagate(double[] vector) throws ArrayIndexOutOfBoundsException{
    double	sum2;
    if(vector.length != Ninp)
      throw new ArrayIndexOutOfBoundsException("Error: Vector size don't match Network input size !"); 	
    for(int i = 0; i < Ninp; i++) inpA[i] = vector[i];  	
    for(int i = 0; i < Nhid ; i++){
      sum2 = 0.0;
      for(int j = 0; j < Ninp; j++) sum2 += hidW[i][j] * inpA[j];
      hidA[i] = sigmoid(sum2);
    }
    for(int i = 0; i < Nout; i++){
      sum2 = 0.0;
      for(int j = 0; j < Nhid; j++) sum2 += outW[i][j] * hidA[j];
      outA[i] = sigmoid(sum2);
    }	
  }
  void init(){
    for(int i = 0; i < Ninp; i++) inpA[i] = frandom(-1.0,1.0);
    for(int i = 0; i < Nhid;i++){
      hidA[i] = frandom(-1.0,1.0);
      for(int m = 0; m < Ninp; m++) hidW[i][m] = frandom(-1.0,1.0);
    }
    for(int i = 0; i < Nout; i++)
      for(int m = 0; m < Nhid; m++) outW[i][m] = frandom(-1.0,1.0);	
    totalError	= 0.0;
    absoluteError	= 0.0;
  }	
  void trickForlearning(double min, double max){
    int i;
    for(i = 0; i < Ninp; i++) inpA[i] += frandom(min,max);
    inpA[i] = (inpA[i] > FIRE)? FIRE: (inpA[i] < DOWN) ? DOWN : inpA[i];
  }	
  void learnVector(double[] in, double out []) throws ArrayIndexOutOfBoundsException{
    if(in.length != Ninp)
      throw new ArrayIndexOutOfBoundsException("Error: In Vector size don't match Network input size !");
    if(out.length != Nout)
      throw new ArrayIndexOutOfBoundsException("Error: Out Vector size don't match Network output size !");	
    for(int i = 0; i < Ninp; i++) inpA[i] = in[i];
    for(int i = 0; i < Nout; i++) outA[i] = out[i];	
    this.feedForward();	
    totalError		= 0.0;
    absoluteError	= 0.0;		
    for(int j = 0; j < Nout ; j++){
      instantError 	= computeDelta(j);
      totalError 	+= instantError;
      absoluteError	+= Math.abs(instantError);
    }	  
    updateWeights();	
    eida *= momentum;
  }
  public boolean saveNeuro(String path, String name){
    int i,j;
    if(name == null || path == null) return false;
    try{
      File rawfile = new File(path, name);
      try{
        RandomAccessFile file = new RandomAccessFile(rawfile,"rw");
        file.writeUTF("3LNW V1.0");
        file.writeInt(Ninp);
        file.writeInt(Nhid);
        file.writeInt(Nout);
        file.writeDouble(eida);
        file.writeDouble(theta);
        file.writeDouble(elast);
        file.writeDouble(momentum);
        for(i=0;i < Ninp; i++)
          for(j=0;j < Nhid; j++) file.writeDouble(hidW[j][i]);
        for(i=0;i < Nhid; i++)
          for(j=0;j < Nout; j++) file.writeDouble(outW[j][i]);
        file.close();
      }
      catch(IllegalArgumentException iae){/*I'M A GOOD PROGRAMMER*/
        ;
      }
    }	
    catch(IOException ioe){
      return false;
    }
    catch(SecurityException se){
      return false;
    }
    return true;
  }
  public boolean loadNeuro(String path, String name){
    int i,j;
    if(name == null || path == null) return false;
    try{
      File rawfile = new File(path, name);
      try{
        RandomAccessFile file = new RandomAccessFile(rawfile,"r");
        if(file.readUTF().compareTo("3LNW V1.0") != 0){
          file.close();
          return false;
        }
        Ninp = file.readInt();
        Nhid = file.readInt();
        Nout = file.readInt();
        eida = file.readDouble();
        theta = file.readDouble();
        elast = file.readDouble();
        momentum = file.readDouble();
        //this(Ninp, Nhid, Nout, eida, theta, elast, momentum);
        this.inpA = new double[Ninp];
        this.hidW = new double[Nhid][Ninp];
        this.hidA = new double[Nhid];
        this.hidN = new double[Nhid];
        this.hidD = new double[Nhid];
        this.outW = new double[Nout][Nhid];
        this.outA = new double[Nout];
        this.outN = new double[Nout];
        this.outD = new double[Nout];
        this.oldD = new double[Nout];
        for(i=0;i < Ninp; i++)
          for(j=0;j < Nhid; j++) hidW[j][i] = file.readDouble();
        for(i=0;i < Nhid; i++)
          for(j=0;j < Nout; j++) outW[j][i] = file.readDouble();
        file.close();
      }
      catch(IllegalArgumentException iae){/*I'M A GOOD PROGRAMMER*/
        ;
      }
    }
    catch(IOException ioe){
      return false;
    }
    catch(SecurityException se){
      return false;
    }		
    return true;
  }
}
