import net.sf.fann.swig.*;
import net.sf.fann.*;


import java.io.File;

import net.sf.fann.swig.fann;
import net.sf.fann.swig.fann_activationfunc_enum;
import net.sf.fann.swig.fann_connection;
import net.sf.fann.swig.fann_nettype_enum;
import net.sf.fann.swig.libfann;


XorTest nn;


	public static int CONNECTION_RATE = 1;
	public static float LEARNING_RATE = 0.7f;
	public static int NUM_INPUT = 2;
	public static int NUM_NEURONS_HIDDEN = 4;
	public static int NUM_OUTPUT = 1;

	public static float DESIRED_ERROR = 0.0001f;
	public static int MAX_ITERATIONS = 100000;
	public static int ITERATIONS_BETWEEN_REPORTS = 1000;

void setup(){
	size(300,300);

	nn = new XorTest();



}

class XorTest {	

	//@Test
	public void testXor() {
		NeuralNet ann = new NeuralNet(CONNECTION_RATE, new long[] {NUM_INPUT, NUM_NEURONS_HIDDEN, NUM_OUTPUT});
		ann.setActivationFunctionForOutput(NeuralNet.ActivationFunction.SIGMOID_SYMMETRIC_STEPWISE);
		Training training = new Training(ann);
		training.setLearningRate(LEARNING_RATE);
		training.train("examples/xor.data", MAX_ITERATIONS, ITERATIONS_BETWEEN_REPORTS, DESIRED_ERROR);
		ann.save("java/src/data/xor_float.net");
	}

	//@Test
	public void testXor1() {
		NeuralNet ann = new NeuralNet(false, new long[] {NUM_INPUT, NUM_NEURONS_HIDDEN, NUM_OUTPUT});
		ann.setActivationFunctionForOutput(NeuralNet.ActivationFunction.SIGMOID_SYMMETRIC_STEPWISE);
		Training training = new Training(ann);
		training.setLearningRate(LEARNING_RATE);
		training.train("examples/xor.data", MAX_ITERATIONS, ITERATIONS_BETWEEN_REPORTS, DESIRED_ERROR);
	}

	//@Test
	public void testXor15() {
		NeuralNet ann = new NeuralNet(false, new long[] {NUM_INPUT, NUM_NEURONS_HIDDEN, NUM_OUTPUT});
		ann.setActivationFunctionForOutput(NeuralNet.ActivationFunction.SIGMOID_SYMMETRIC_STEPWISE);
		Training training = new Training(ann);
		training.setLearningRate(LEARNING_RATE);
		TrainingData data = new TrainingData("examples/xor.data");
		training.train(data, MAX_ITERATIONS, ITERATIONS_BETWEEN_REPORTS, DESIRED_ERROR);
	}

	//@Test
	public void testXor2() throws InterruptedException {
		NeuralNet ann = new NeuralNet(true, new long[] {NUM_INPUT, NUM_NEURONS_HIDDEN, NUM_OUTPUT});
		ann.setActivationFunctionForOutput(NeuralNet.ActivationFunction.SIGMOID_SYMMETRIC_STEPWISE);
		Training training = new Training(ann);
		training.setLearningRate(LEARNING_RATE);
		training.train("examples/xor.data", MAX_ITERATIONS, ITERATIONS_BETWEEN_REPORTS, DESIRED_ERROR);

		training.train(new double[] {1, 1}, new double[] {0});
		double[] result = training.test(new double[] {1, 1}, new double[] {0});
		assertEquals(1, result.length);
		assertEquals(-1, result[0], 0.2);
	}

	//@Test
	public void testCallback() {
		NeuralNet ann = new NeuralNet(false, new long[] {NUM_INPUT, NUM_NEURONS_HIDDEN, NUM_OUTPUT});
		ann.setActivationFunctionForOutput(NeuralNet.ActivationFunction.SIGMOID_SYMMETRIC_STEPWISE);
		Training training = new Training(ann);
		training.setLearningRate(LEARNING_RATE);
		training.setCallback(this);
		System.out.println("Starting training");
		training.train("examples/xor.data", MAX_ITERATIONS, 1, DESIRED_ERROR);
		System.out.println("Training ended");
	}

	//@Test
	public void testCallbackAnonymous() {
		NeuralNet ann = new NeuralNet(false, new long[] {NUM_INPUT, NUM_NEURONS_HIDDEN, NUM_OUTPUT});
		ann.setActivationFunctionForOutput(NeuralNet.ActivationFunction.SIGMOID_SYMMETRIC_STEPWISE);
		Training training = new Training(ann);
		training.setLearningRate(LEARNING_RATE);
		training.setCallback(new TrainingReportCallback() {
			                     public void report(Training training, long maxEpochs,
			                                        long epochsBetweenReports, double desiredError, long epochs) {
				                     System.out.println("Report from anonymous: epochs="+epochs);
			                     }
		                     });
		System.out.println("Starting training");
		training.train("examples/xor.data", MAX_ITERATIONS, 1, DESIRED_ERROR);
		System.out.println("Training ended");
	}


	public void report(Training training, long maxEpochs,
	                   long epochsBetweenReports, double desiredError, long epochs) {
		System.out.printf("JavaReport: Epochs=%d. Current error=%f. Bit fail %d\n",
		                  epochs, training.getMSE(), training.getBitFail());
	}

	//@Test
	public void testErrors() {
		try {
			NeuralNet ann = new NeuralNet("bad/file.name");
			fail("Excepted an exception");
		} catch (FannException e) {
			// this is excepted
			assertTrue(e.getMessage().contains("bad/file.name"));
			e.printStackTrace();
		}
	}

	//	@Test
	public void testNullArgument() {
		try {
			libfann.fann_get_bit_fail(null);
			fail("Excepted an exception");
		} catch (RuntimeException e) {
			// this is excepted
			assertTrue(e.getMessage().contains("is null"));
			assertTrue(e instanceof NullPointerException);
		}
	}



}

/* 
 * The following are not available since we are using floating points
 * fann_get_decimal_point
 * fann_get_multiplier
 */
class NeuralNet extends ErrorHandling {
	
	
	/**
	 * Enums: fann_activationfunc_enum
	 * 
	 * The activation functions used for the neurons during training. The activation functions
	 * can either be defined for a group of neurons by <fann_set_activation_function_hidden> and
	 * <fann_set_activation_function_output> or it can be defined for a single neuron by <fann_set_activation_function>.
	 * 
	 * The steepness of an activation function is defined in the same way by
	 * <fann_set_activation_steepness_hidden>, <fann_set_activation_steepness_output> and <fann_set_activation_steepness>.
	 *
	 */
	public enum ActivationFunction {
		  LINEAR, // 0
		  THRESHOLD,
		  THRESHOLD_SYMMETRIC,
		  SIGMOID,
		  SIGMOID_STEPWISE,
		  SIGMOID_SYMMETRIC,
		  SIGMOID_SYMMETRIC_STEPWISE,
		  GAUSSIAN,
		  GAUSSIAN_SYMMETRIC,
		  GAUSSIAN_STEPWISE,
		  ELLIOT,
		  ELLIOT_SYMMETRIC,
		  LINEAR_PIECE,
		  LINEAR_PIECE_SYMMETRIC,
		  SIN_SYMMETRIC,
		  COS_SYMMETRIC,
		  SIN,
		  COS
	};

	
	/* Enum: fann_network_type_enum
	 * 
	 * Definition of network types used by <fann_get_network_type>
	 * 
	 * FANN_NETTYPE_LAYER - Each layer only has connections to the next layer
	 * FANN_NETTYPE_SHORTCUT - Each layer has connections to all following layers
	 *  
     */
	public enum NeuralNetType {
		  LAYER, // 0
		  SHORTCUT
	};
	
	private fann ann;
	private Object userdata;
	
	public NeuralNet(boolean shortcut, long numLayers) {
		if (shortcut) {
			ann = libfann.fann_create_shortcut(numLayers);
		} else {
			ann = libfann.fann_create_standard(numLayers);
		}
		checkError();
	}

	public NeuralNet(boolean shortcut, long[] noNodesInEachLayer) {
		if (shortcut) {
			ann = libfann.fann_create_shortcut_array(noNodesInEachLayer.length, noNodesInEachLayer);
		} else {
			ann = libfann.fann_create_standard_array(noNodesInEachLayer.length, noNodesInEachLayer);
		}
		checkError();
	}

	/**
	 * Creates a standard backpropagation neural network, which is not fully connected.
	 * @param connectionRate The connection rate controls how many connections there will
	 *  be in the network.  If the connection rate is set to 1, the network will be fully
	 *  connected, but if it is set to 0.5 only half of the connections will be set.
	 *  A connection rate of 1 will yield the same result as fann_create_standard
	 * @param numLayers The total number of layers including the input and the output layer.
	 */
	public NeuralNet(float connectionRate, long numLayers) {
		ann = libfann.fann_create_sparse(connectionRate, numLayers);
		checkError();
	}

	/**
	 * Creates a standard backpropagation neural network, which is not fully connected.
	 * @param connectionRate The connection rate controls how many connections there will
	 *  be in the network.  If the connection rate is set to 1, the network will be fully
	 *  connected, but if it is set to 0.5 only half of the connections will be set.
	 *  A connection rate of 1 will yield the same result as fann_create_standard
	 * @param noNodesInEachLayer an array of layer sizes.
	 */
	public NeuralNet(float connectionRate, long[] noNodesInEachLayer) {
		ann = libfann.fann_create_sparse_array(connectionRate, noNodesInEachLayer.length, noNodesInEachLayer);
		checkError();
	}

	
	/**
	 * Create a new Neural Network based on a copy from another Neural Network.
	 * Creates a copy of a fann structure.
	 * Data in the user data fann_set_user_data is not copied, but the user data
	 * pointer is copied.
	 * @param nn the nn to copy
	 */
	public NeuralNet(NeuralNet nn) {
		// TODO: Only in 2.2
//		ann = libfann.fann_copy(nn.ann);
		// for now the only way to copy it, is saving and reloading.
		String tempFilename = "NeuralNet.copy.tmp";
		nn.save(tempFilename);
		load(tempFilename);
		
		// delete the file again
		new File(tempFilename).delete();
		
		userdata = nn.userdata;
		checkError();
	}

	/**
	 * Constructs a backpropagation neural network from a configuration file, 
	 * which have been saved by fann_save.
	 */
	public NeuralNet(String filename) {
		ann = libfann.fann_create_from_file(filename);
		if (ann==null) {
			throw new FannException("Unable to open configuration file for reading: "+filename);
		}
		checkError();
	}
	
	
	/**
	 * Destroys the entire network and properly freeing all the associated memmory.
	 */
	public void destroy() {
		libfann.fann_destroy(ann);
		checkError();
	}
	
	/**
	 * Will run input through the neural network, returning an array of outputs,
	 * the number of which being equal to the number of neurons in the output layer.
	 * @param inputs
	 */
	public double[] run(double[] inputs) {
		double[] result = new double[(int) getNumOutput()];
		libfann.fann_run_wrap(ann, inputs, result, result.length);
		checkError();
		return result;
	}
	
	/***************************************************************************
	 *                              PARAMETERS
	 ***************************************************************************/
	
	/**
	 * Prints all of the parameters and options of the ANN
	 */
	public void printParameters() {
		libfann.fann_print_parameters(ann);
		checkError();
	}
	
	/**
	 * Will print the connections of the ann in a compact matrix, for easy viewing of
	 * the internals of the ann.
	 * 
	 * The output from fann_print_connections on a small (2 2 1) network trained on
	 * the xor problem
	 * 
	 *     Layer / Neuron 012345
	 *         L   1 / N    3 BBa...
	 *         L   1 / N    4 BBA...
	 *         L   1 / N    5 ......
	 *         L   2 / N    6 ...BBA
	 *         L   2 / N    7 ......
	 *         
	 * This network have five real neurons and two bias neurons.  This gives a
	 * total of seven neurons named from 0 to 6.  The connections between these neurons
	 * can be seen in the matrix.  �.� is a place where there is no connection, while a
	 * character tells how strong the connection is on a scale from a-z.  The two real
	 * neurons in the hidden layer (neuron 3 and 4 in layer 1) has connection from the
	 * three neurons in the previous layer as is visible in the first two lines.  The
	 * output neuron (6) has connections form the three neurons in the hidden
	 * layer 3 - 5 as is visible in the fourth line.
	 * 
	 * To simplify the matrix output neurons is not visible as neurons that connections
	 * can come from, and input and bias neurons are not visible as neurons that
	 * connections can go to.
	 */
	public void printConnections() {
		libfann.fann_print_connections(ann);
		checkError();
	}

	/**
	 * @return the number of input neurons.
	 */
	public long getNumInput() {
		long result = libfann.fann_get_num_input(ann);
		checkError();
		return result;
	}
	
	/**
	 * @return the number of output neurons.
	 */
	public long getNumOutput() {
		long result = libfann.fann_get_num_output(ann);
		checkError();
		return result;
	}
	
	/**
	 * @return the total number of neurons in the entire network.  This number does also
	 *  include the bias neurons, so a 2-4-2 network has 2+4+2 +2(bias) = 10 neurons.
	 */
	public long getTotalNeurons() {
		long result = libfann.fann_get_total_neurons(ann);
		checkError();
		return result;
	}

	/**
	 * @return the total number of connections in the entire network.
	 */
	public long getTotalConnections() {
		long result = libfann.fann_get_total_connections(ann);
		checkError();
		return result;
	}

	public long getNumLayers() {
		long result = libfann.fann_get_num_layers(ann);
		checkError();
		return result;
	}
	
	
	public NeuralNetType getNetworkType() {
		fann_nettype_enum x = libfann.fann_get_network_type(ann);
		checkError();
		for(NeuralNetType f : NeuralNetType.values()) {
			if (f.ordinal() == x.ordinal()) {
				return f;
			}
		}
		throw new FannException("Could not find a NeuralNetType with ordinal="+x.ordinal());
	}
	
	public float getConnectionRate() {
		float result = libfann.fann_get_connection_rate(ann);
		checkError();
		return result;
	}
	
	public long[] getLayerArray() {
		long[] numNeurons = new long[(int)getNumLayers()];
		libfann.fann_get_layer_array(ann, numNeurons);
		checkError();
		return numNeurons;
	}
	
	/**
	 * @return the number of bias in each layer in the network.
	 */
	public long[] getBiasArray() {
		long[] numBias = new long[(int)getNumLayers()];
		libfann.fann_get_bias_array(ann, numBias);
		checkError();
		return numBias;
	}

	public fann_connection[] getConnectionArray() {
		fann_connection[] connections = new fann_connection[(int)getTotalConnections()];
		// TODO
		// libfann.fann_get_connection_array(ann, connections);
		checkError();
		return connections;
	}
	
	/**
	 * Set a connection in the network.
	 * Only the weights can be changed.  The connection/weight is ignored if it does 
	 * not already exist in the network.
	 * 
	 * @param fromNeuron starting neuron number
	 * @param toNeuron ending neuron number
	 * @param weight the connection weight
	 */
	public void setWeight(long fromNeuron, long toNeuron, double weight) {
		libfann.fann_set_weight(ann, fromNeuron, toNeuron, weight);
		checkError();
	}
	
	/**
	 * Set connections in the network.
	 * Only the weights can be changed, connections and weights are ignored
	 * if they do not already exist in the network.
	 * 
	 * @param connections the definition of the connections
	 */
	public void setWeightArray(fann_connection[] connections) {
		// TODO:
		//libfann.fann_set_weight_array(ann, connections, (int) connections.length);
		checkError();
	}
	
	/**
	 * Initialize the weights using Widrow + Nguyen�s algorithm.
	 * 
	 * This function behaves similarly to fann_randomize_weights.  It will use
	 * the algorithm developed by Derrick Nguyen and Bernard Widrow to set the 
	 * weights in such a way as to speed up training.  This technique is not always 
	 * successful, and in some cases can be less efficient than a purely random 
	 * initialization.
	 * 
	 * The algorithm requires access to the range of the input data (ie, largest
	 * and smallest input), and therefore accepts a second argument, data, which 
	 * is the training data that will be used to train the network.
	 * 
	 */
	public void weightsInit(TrainingData data) {
		libfann.fann_init_weights(ann, data.getData());
		checkError();
	}
	
	/**
	 * Give each connection a random weight between min_weight and max_weight
	 * From the beginning the weights are random between -0.1 and 0.1.
	 * 
	 * @param minWeight
	 * @param maxWeight
	 */
	public void weightsRandomize(double minWeight, double maxWeight) {
		libfann.fann_randomize_weights(ann, minWeight, maxWeight);
		checkError();
	}
	
	public void setUserData(Object userdata) {
		this.userdata = userdata;
	}
	
	public Object getUserData() {
		return this.userdata;
	}
	
	
	/***************************************************************************
	 *                              FILE
	 ***************************************************************************/
	
	/**
	 * Constructs a backpropagation neural network from a configuration file, 
	 * which have been saved by fann_save.
	 * @param filename The filename
	 */
	public void load(String filename) {
		ann = libfann.fann_create_from_file(filename);
		checkError();
	}
	
	/**
	 * Save the entire network to a configuration file.
	 * The configuration file contains all information about the neural network
	 * and enables fann_create_from_file to create an exact copy of the neural 
	 * network and all of the parameters associated with the neural network.
	 * 
	 * These three parameters (fann_set_callback, fann_set_error_log, fann_set_user_data) 
	 * are NOT saved to the file because they cannot safely be ported to a different 
	 * location.  Also temporary parameters generated during training like fann_get_MSE
	 * is not saved.
	 * 
	 * @param filename The filename
	 */
	public void save(String filename) {
		int err = libfann.fann_save(ann, filename);
		if (err == -1) {
			throw new FannException("Could not save data to the file:"+filename);
		}
		checkError();
	}

	/**
	 * Saves the entire network to a configuration file.  But it is saved in fixed 
	 * point format no matter which format it is currently in.
	 * 
	 * This is usefull for training a network in floating points, and then later 
	 * executing it in fixed point.
	 * 
	 * The function returns the bit position of the fix point, which can be used to 
	 * find out how accurate the fixed point network will be.  A high value indicates 
	 * high precision, and a low value indicates low precision.
	 * 
	 * A negative value indicates very low precision, and a very strong possibility 
	 * for overflow.  (the actual fix point will be set to 0, since a negative fix 
	 * point does not make sence).
	 * 
	 * Generally, a fix point lower than 6 is bad, and should be avoided.  The best 
	 * way to avoid this, is to have less connections to each neuron, or just less 
	 * neurons in each layer.
	 * 
	 * The fixed point use of this network is only intended for use on machines that 
	 * have no floating point processor, like an iPAQ.  On normal computers the 
	 * floating point version is actually faster.
	 * 
	 * @param filename The filename
	 */
	public void saveToFixed(String filename) {
		int err = libfann.fann_save_to_fixed(ann, filename);
		if (err == -1) {
			throw new FannException("Could not save data to the file:"+filename);
		}
		checkError();
	}

	/***************************************************************************
	 *                              ERROR
	 ***************************************************************************/
	
	
	public void setErrorLog() {
	// TODO:		
	//			libfann.fann_set_error_log(errdat, log_file);
	}	
		
	/**
	 * @return Returns the last error number.
	 */
	public Error getLastError() {
		return convert(libfann.fann_get_errno_fann(ann)); 
	}

	/**
	 * Resets the last error number.
	 */
	public void resetLastError() {
		libfann.fann_reset_errno_fann(ann);
	}

	/**
	 * @return the last errstr.
	 */
	public String getErrorString() {
		return libfann.fann_get_errstr_fann(ann);
	}

	/**
	 * Resets the last error string.
	 */
	public void resetErrorString() {
		libfann.fann_reset_errstr_fann(ann);
	}

	/**
	 * Prints the last error to stderr. 
	 */
	public void printError() {
		libfann.fann_print_error_fann(ann);
	}

	/**
	 * @return the ann
	 */
	public fann getFann() {
		return ann;
	}

	/**
	 * @param ann the ann to set
	 */
	public void setFann(fann ann) {
		this.ann = ann;
	}
	
	public ActivationFunction getActivationFunction(int layer, int neuron) {
		fann_activationfunc_enum x = libfann.fann_get_activation_function(ann, layer, neuron);
		checkError();
		for(ActivationFunction f : ActivationFunction.values()) {
			if (f.ordinal() == x.ordinal()) {
				return f;
			}
		}
		throw new FannException("Could not find a ActivationFunction with ordinal="+x.ordinal());
	}

	/**
	 * Set the activation function for neuron number neuron in layer number layer, 
	 * counting the input layer as layer 0.
	 * 
	 * It is not possible to set activation functions for the neurons in the input layer.
	 * 
	 * When choosing an activation function it is important to note that 
	 * the activation functions have different range.  FANN_SIGMOID is e.g. in 
	 * the 0 - 1 range while FANN_SIGMOID_SYMMETRIC is in the -1 - 1 range and 
	 * FANN_LINEAR is unbound.
	 * 
	 * Information about the individual activation functions is available at 
	 * fann_activationfunc_enum.
	 * 
	 * The default activation function is FANN_SIGMOID_STEPWISE.
	 * 
	 * @param activationFunction the activation function to be used
	 * @param layer the layer number
	 * @param neuron the neuron number in the given layer
	 */
	public void setActivationFunction(ActivationFunction activationFunction, int layer, int neuron) {
		for(fann_activationfunc_enum f : fann_activationfunc_enum.values()) {
			if (f.ordinal() == activationFunction.ordinal()) {
				libfann.fann_set_activation_function(ann, f, layer, neuron);
				checkError();
				return;
			}
		}
		throw new FannException("Could not find a fann_activationfunc_enum matching the ActivationFunction="+activationFunction.toString());
	}
	
	/**
	 * Set the activation function for the whole layer with number layer, 
	 * counting the input layer as layer 0.
	 * 
	 * @param activationFunction the activation function to be used
	 * @param layer the layer number
	 */
	public void setActivationFunction(ActivationFunction activationFunction, int layer) {
		for(fann_activationfunc_enum f : fann_activationfunc_enum.values()) {
			if (f.ordinal() == activationFunction.ordinal()) {
				libfann.fann_set_activation_function_layer(ann, f, layer);
				checkError();
				return;
			}
		}
		throw new FannException("Could not find a fann_activationfunc_enum matching the ActivationFunction="+activationFunction.toString());
		
	}

	/**
	 * Set the activation function for the all hidden layers. 
	 * 
	 * @param activationFunction the activation function to be used
	 */
	public void setActivationFunctionForAllHidden(ActivationFunction activationFunction) {
		for(fann_activationfunc_enum f : fann_activationfunc_enum.values()) {
			if (f.ordinal() == activationFunction.ordinal()) {
				libfann.fann_set_activation_function_hidden(ann, f);
				checkError();
				return;
			}
		}
		throw new FannException("Could not find a fann_activationfunc_enum matching the ActivationFunction="+activationFunction.toString());
	}

	/**
	 * Set the activation function for the output layer. 
	 * 
	 * @param activationFunction the activation function to be used
	 */
	public void setActivationFunctionForOutput(ActivationFunction activationFunction) {
		for(fann_activationfunc_enum f : fann_activationfunc_enum.values()) {
			if (f.ordinal() == activationFunction.ordinal()) {
				libfann.fann_set_activation_function_output(ann, f);
				checkError();
				return;
			}
		}
		throw new FannException("Could not find a fann_activationfunc_enum matching the ActivationFunction="+activationFunction.toString());
	}
	
	/**
	 * Set the activation steepness all of the neurons in layer number layer, 
	 * counting the input layer as layer 0.
	 * 
	 * It is not possible to set activation steepness for the neurons in the input layer.
	 * 
	 * @param layer The layer number (input=0)
	 * @param steepness the steepness for that neuron
	 */
	public void setActivationSteepness(int layer, double steepness) {
		libfann.fann_set_activation_steepness_layer(ann, steepness, layer);
		checkError();
	}
	
	public void setActivationSteepnessForAllHidden(double steepness) {
		libfann.fann_set_activation_steepness_hidden(ann, steepness);
		checkError();
	}
	
	public void setActivationSteepnessForOutput(double steepness) {
		libfann.fann_set_activation_steepness_output(ann, steepness);
		checkError();
	}
	
	
}
