import net.sf.fann.*;
import net.sf.fann.swig.*;


static {
	    System.loadLibrary("fann");
	}	
	
	public static final long numNeuronsHidden = 4;
	public static final long numOutput = 1;
	public static final float desiredError = 0.0001f;
	public static final long maxNeurons = 40;
	public static final long neuronsBetweenReports = 1;
	public static double[] steepness = new double[] {0.1,0.2,0.4,0.5,0.6,0.7,0.8,0.9,1.0,1.1};


void setup(){


}

public void testCascadingTrainging() {
		// load and scale the training and test data
		TrainingData trainData = new TrainingData("two-spiral.train");
		TrainingData testData = new TrainingData("two-spiral.test");
		trainData.scale(0, 1);
		testData.scale(0, 1);
		
		// configure the network
		NeuralNet ann = new NeuralNet(true, new long[] {trainData.getNumInput(), trainData.getNumOutput()});
		ann.setActivationFunctionForAllHidden(ActivationFunction.SIGMOID_SYMMETRIC);
		ann.setActivationFunctionForOutput(ActivationFunction.SIGMOID_SYMMETRIC);
		ann.setActivationSteepnessForAllHidden(0.5);
		ann.setActivationSteepnessForOutput(0.5);
		
		// configure the training
		CascadeTraining training = new CascadeTraining(ann);
		training.setTrainingAlgorithm(TrainingAlgorithm.RPROP);
		training.setTrainingErrorFunction(ErrorFunction.LINEAR);
		training.setRPropIncreaseFactor(1.2f);
		training.setRPropDecreaseFactor(0.5f);
		training.setRPropDeltaMin(0.0f);
		training.setRPropDeltaMax(50.0f);

		// configure the cascading training
		training.setOutputChangeFraction(0.01f);
		training.setOutputStagnationEpochs(12);
		training.setCandidateChangeFraction(0.01f);
		training.setCandidateStagnationEpochs(12);
		training.setCandidateLimit(1000.0f);
		training.setWeightMultiplier(0.4);
		training.setMaxOutEpochs(150);
		training.setMaxCandEpochs(150);
		training.setActivationSteepnesses(steepness);
		training.setNumCandidateGroups(1);

		// print the config
		ann.printParameters();
		
		training.train(trainData, maxNeurons, neuronsBetweenReports, desiredError);
		
		ann.printConnections();

		System.out.printf("\nTrain error: %f, Test error: %f\n\n", training.test(trainData), training.test(testData));

		ann.save("java/src/data/two-spiral.net");
	}
