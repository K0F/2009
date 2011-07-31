class OSC{
  OscP5 osc;
  NetAddress addr;
  int port;

//////////////////////////////////////////////////////////

  OSC(String _addr,int _port){
    port=_port;
    osc = new OscP5(this,_port-1);
    addr = new NetAddress(_addr,port);
  }
  
  //////////////////////////////////////////////////////////


  void send(float _whatX,float _whatY,float _whatZ){
    OscMessage message = new OscMessage("/msg");
    //message.add("x ");
    message.add(_whatX);
    //message.add("y ");
    message.add(_whatY);
   
    message.add(_whatZ);
    osc.send(message, addr);
    
    
  }
  
  //////////////////////////////////////////////////////////

  void send(int _ident,float _what){
    OscMessage message = new OscMessage("/msg");
    String ident = (char)(_ident+65)+"";
    message.add(ident);
    message.add(_what);
    osc.send(message, addr);
  }
  
  //////////////////////////////////////////////////////////
  
   void send(String _ident,float _what){
    OscMessage message = new OscMessage("/msg");
    String ident = _ident+"";
    message.add(ident);
    message.add(_what);
    osc.send(message, addr);
  }
  
  //////////////////////////////////////////////////////////

}
