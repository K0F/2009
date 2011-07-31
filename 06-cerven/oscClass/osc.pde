
import oscP5.*;
import netP5.*;

class OscSender{

	OscP5 oscP5;
	NetAddress myRemoteLocation;
	String address;
	int port;
	
	OscSender(String _address,int _port){
		
		address = _address;
		port = _port;
		
		oscP5 = new OscP5(this,port);
		myRemoteLocation = new NetAddress(address,port);
		
		/* start oscP5, listening for incoming messages at port 12000 */


		/* myRemoteLocation is a NetAddress. a NetAddress takes 2 parameters,
		 * an ip address and a port number. myRemoteLocation is used as parameter in
		 * oscP5.send() when sending osc packets to another computer, device, 
		 * application. usage see below. for testing purposes the listening port
		 * and the port of the remote location address are the same, hence you will
		 * send messages back to this sketch.
		 */
	}

	void send(String header, float what){


		OscMessage myMessage = new OscMessage(header);

		//myMessage.add(123); /* add an int to the osc message */
		myMessage.add(what); /* add a float to the osc message */
		//myMessage.add("some text"); /* add a string to the osc message */
		//myMessage.add(new byte[] {0x00, 0x01, 0x10, 0x20}); /* add a byte blob to the osc message */
		//myMessage.add(new int[] {1,2,3,4}); /* add an int array to the osc message */

		/* send the message */
		oscP5.send(myMessage, myRemoteLocation);
	}
	
void send(String header, float[] what){


		OscMessage myMessage = new OscMessage(header);

		//myMessage.add(123); /* add an int to the osc message */
		for(int i =0;i<what.length;i++)
		myMessage.add(what[i]); /* add a float to the osc message */
		//myMessage.add("some text"); /* add a string to the osc message */
		//myMessage.add(new byte[] {0x00, 0x01, 0x10, 0x20}); /* add a byte blob to the osc message */
		//myMessage.add(new int[] {1,2,3,4}); /* add an int array to the osc message */

		/* send the message */
		oscP5.send(myMessage, myRemoteLocation);
	}
	
	void send(String header, int[] what){


		OscMessage myMessage = new OscMessage(header);

		//myMessage.add(123); /* add an int to the osc message */
		for(int i =0;i<what.length;i++)
		myMessage.add(what[i]); /* add a float to the osc message */
		//myMessage.add("some text"); /* add a string to the osc message */
		//myMessage.add(new byte[] {0x00, 0x01, 0x10, 0x20}); /* add a byte blob to the osc message */
		//myMessage.add(new int[] {1,2,3,4}); /* add an int array to the osc message */

		/* send the message */
		oscP5.send(myMessage, myRemoteLocation);
	}


	/*
	void oscEvent(OscMessage theOscMessage) {
		
		print("### received an osc message.");
		print(" addrpattern: "+theOscMessage.addrPattern());
		println(" typetag: "+theOscMessage.typetag());
	} incoming osc message are forwarded to the oscEvent method. */


}
