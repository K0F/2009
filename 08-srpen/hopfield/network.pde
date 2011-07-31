
class Network {
  Neuron neuron[] = new Neuron[X];
  boolean output[] = new boolean[X];
  

  Network(int in[][]){
	  for(int i =0;i<in.length;i++)
		  neuron[i] = new Neuron(in[i]);
  }

  boolean threshold(int k){
    return(k>=0);
  }

  void activation(boolean pattern[]) {
	  //cycle++;
    int i,j;
    for ( i=0;i<X;i++ ) {
      neuron[i].activation = neuron[i].act(pattern);
      output[i] = threshold(neuron[i].activation);
    }
  }
}

public class Neuron{
  int activation;
  int weightv[] = new int[Y];

  Neuron(int in[]){
    int i;
    for (i = 0; i < Y; i++)
      weightv[i] = in[i];
  }

  int act(boolean x[]) {
    int i;
    int a = 0;

    for (i = 0; i < x.length; i++)
      if (x[i])
        a += weightv[i];
    return a;
  }

}
