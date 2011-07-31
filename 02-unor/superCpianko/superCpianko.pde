import supercollider.*;

Synth synth[] = new Synth[6];
char [] chars = {'q','w','e','i','o','p'};
float [] freqs = {261.6,293.7,329.6,349.2,392,440,393.9};
boolean kdown[] = new boolean[6];

Sampler[] samp = new Sampler[0];

float vol = 1;
void setup ()
{
	size(300, 200,P3D);
	frameRate(30);

	// uses default sc server at 127.0.0.1:57110
	// does NOT create synth!
	for(int i = 0;i<synth.length;i++){
		kdown[i] = false;
		synth[i] = new Synth("midisynth1");
		synth[i].set("freq", freqs[i]);
		//synth[i].set("amp", 1);
		//synth[i].set("dur", 1);
		synth[i].set("gate",0);
		synth[i].set("filter",0);
		synth[i].set("vibrato",20);
		
		//synth[i].set("dur", 4);
		
		synth[i].create();
	}

	textFont(createFont("Arial",9));
	textMode(SCREEN);

	fill(255);
	noStroke();
	//synth[1] = new Synth("sprinkler");
	// 261.6,293.7,329.6,349.2,392,440,393.9

	// set initial arguments
	//synth.set("amp", 0.5);
	//var clockRate, clockTime, clock, centerFreq, freq, panPos, patch;
	//synth[0].set("amp", 0.5);

	//synth[1].set("freq", 80);

	// create synth
	//synth[0].create();
	//synth[1].create();
}

float pos = 0;

void draw ()
{
	background(0);
	//stroke(255);

	for(int i = 0;i<synth.length;i++){
		if(kdown[i]){
			fill(255);
		}else{
			fill(255,45);
		}

		rect(i*(width/(synth.length+0.0))+20,10,10,10);
		text(chars[i],i*(width/(synth.length+0.0))+23,30);
	}

	
	for(int i = 0;i<samp.length;i++){
		if(samp[i]!=null){
			samp[i].run();
			if(samp[i].recording){
				fill(255,15,12);
			}else if(samp[i].playing){
				fill(15,255,12);
			}
			
			rect(i*20+20,40,10,10);
			if(mousePressed){
				if(!samp[i].recording&&mouseX>=i*20+20&&mouseX<=i*20+20+10&&mouseY>=40&&mouseY<=50){
					samp[i].playing = !samp[i].playing;
					samp[i].flush();
					mousePressed=false;
					}
					
			}
		}
		
	}
	

}

void keyPressed ()
{

	if (key == chars[0])
	{synth[0].set("gate", vol); kdown[0] = true;}

	if (key == chars[1])
	{synth[1].set("gate", vol); kdown[1] = true;}

	if (key == chars[2])
	{synth[2].set("gate", vol); kdown[2] = true;}

	if (key == chars[3])
	{synth[3].set("gate", vol); kdown[3] = true;}

	if (key == chars[4])
	{synth[4].set("gate", vol); kdown[4] = true;}

	if (key == chars[5])
	{synth[5].set("gate", vol); kdown[5] = true;}

	if(key == ' ')addSynth();


}

void addSynth(){
	samp=(Sampler[])expand(samp,samp.length+1);
	samp[samp.length-1] = new Sampler();	
}


void keyReleased (){
	if (key == chars[0])
	{synth[0].set("gate", 0); kdown[0] = false;}

	if (key == chars[1])
	{synth[1].set("gate", 0); kdown[1] = false;}

	if (key == chars[2])
	{synth[2].set("gate", 0); kdown[2] = false;}

	if (key == chars[3])
	{synth[3].set("gate", 0); kdown[3] = false;}

	if (key == chars[4])
	{synth[4].set("gate", 0); kdown[4] = false;}

	if (key == chars[5])
	{synth[5].set("gate", 0); kdown[5] = false;}
}

void stop ()
{
	for(int i = 0;i<synth.length;i++){
		synth[i].free();
	}
	
	for(int i =0;i<samp.length;i++)
		samp[i].free();
	//synth[1].free();
}

