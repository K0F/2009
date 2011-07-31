class Sampler
{
	int timer = 0;
	int durat = 120;
	float locvol = 0.1;

	boolean[] pressed = new boolean[kdown.length];
	boolean[] pressed2= new boolean[kdown.length];
	boolean[] ons = new boolean[kdown.length];

	boolean map[][] = new boolean[durat][kdown.length];

	Synth[] s = new Synth[6];
	boolean recording,playing;

	Sampler()
	{
		recording = true;

		for(int i = 0;i<s.length;i++){
			ons[i] = false;
			s[i] = new Synth("sine");
			s[i].set("freq", freqs[i]);
			s[i].set("amp", 0);
			s[i].create();
		}
	}

	void run(){
		if(recording){
			for(int i =0;i<kdown.length;i++){
				pressed[i] = kdown[i];

				//on note
				if(pressed[i]&&!pressed2[i]){
					map[timer][i] = true;
					//ons[i] = true;
				}

				//off note
				if(pressed2[i]&&!pressed[i]){
					map[timer][i] = true;
					//ons[i] = false;
				}
			}

			for(int i =0;i<kdown.length;i++){
				pressed2[i]=pressed[i];
			}

			timer ++;
			if(timer==durat){
				timer = 0;
				recording = false;
				playing = true;
				println("sampled "+durat+" frames");

			}
		}

		if(playing){
			for(int i =0;i<s.length;i++){
				if(!ons[i]&&map[timer][i]){
					s[i].set("amp", locvol); ons[i] = true;
				}else if(ons[i]&&map[timer][i]){
					s[i].set("amp", 0); ons[i] = false;
				}



			}

			timer++;

			if(timer>=durat){
				timer = 0;
				flush();
			}



		}
		
		if(!recording&&!playing){
			timer++;
			if(timer>=durat){
				timer = 0;
				}
		}

	}
	
	void flush(){
	for(int i =0;i<s.length;i++){
					s[i].set("amp", 0); ons[i] = false;
				}
	
	}

	void free(){
		for(int i = 0;i<s.length;i++){
			s[i].free();
		}
	}








}
