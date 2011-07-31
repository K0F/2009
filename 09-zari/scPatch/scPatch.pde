import supercollider.*;

Synth synth;

void setup ()
{
    size(800, 200);

    // uses default sc server at 127.0.0.1:57110    
    // does NOT create synth!
    synth = new Synth("sine");
    
    // set initial arguments
    synth.set("amp", 0.5);
    synth.set("freq", 80);
    
    // create synth
    synth.create();
}

void draw ()
{
    background(0);
    stroke(255);
    line(mouseX, 0, mouseX, height);
}

void mouseMoved ()
{
    synth.set("freq", 40 + (mouseX * 3)); 
}

void stop ()
{
    synth.free();
}
