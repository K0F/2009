class Sampler
{
	int timer = 0;
	int durat = 30;
	
	boolean[] pressed = new boolean[kdown.length];
	boolean[] pressed2= new boolean[kdown.length];
	
	boolean map[][] = new boolean[durat][kdown.length];
	
	Synth[] s = new Synth[0];
	boolean recording,playing;
	
	Sampler()
	{
		recording = true;	
	}
	
	void run(){
		if(recording){
			for(int i =0;i<kdown.length;i++){
				pressed[i] = kdown[i];
				if(pressed[i]&&!pressed2){
					map[timer][i] = true;
				}
			}
			pressed2=pressed;
						
			timer ++;
			if(timer==durat){
				recording = false;
				println("sampled "+durat+" frames");
			}
		}
	
	}
	
	
	





}
