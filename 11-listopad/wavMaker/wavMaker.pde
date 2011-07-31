// basemeent of wave generator
// bona (www.papamuerta.com) & dimitre
int count = 500;
int step = 13;
PImage src;

int num = (int)((200+88200)*0.2);
byte[] buffer;
// 88200 = 44100 samples/sec * 2 channels = 1 second of wave

int index;
float amplitude;
double sample, sample2;

String name = "ram.png";
int numbr = 2;

void setup() {

	src=loadImage(name);
	src.loadPixels();
	num = src.pixels.length;//+waveHeader.length+200;
	buffer = new byte[num];
	println(num);

	System.arraycopy(waveHeader, 0, buffer, 0, waveHeader.length);

	// volume do som, vai de 0 a 127
	amplitude = 80;
	// frequencia em HZ, 440 � a nota L�
	/*vyska = (float)i;
	vyska2 = count-(float)i;
	vyska3 = abs(vyska-vyska2);*/

	for (index=0; index<num-waveHeader.length; index++) {

		// onda normal
		// sample = (sin(2*PI*index/divisor) * amplitude);
		// onda composta
		sample = brightness(color(src.pixels[index]));//((sin(2*PI*index/divisor) * amplitude) + (sin(2*PI*index/divisor2) * amplitude) + (sin(2*PI*index/divisor3) * amplitude)) / 2;

		//tremolo
		//amplitude = (sin(index/1000f) * 127);
		if (sample < 0) sample = 255 - (sample * -1) ;
		buffer[waveHeader.length+index] = (byte)(sample);
	}
	geraWave();

	exit();
}

void geraWave(){
	//File file = null;
	//file = new File("tuu.wav");

	saveBytes("out/listenTheFotography_"+name+".wav", buffer);
	println(name+" done!");

}



static byte waveHeader[] = {
                                   (byte)0x52, (byte)0x49, (byte)0x46, (byte)0x46, (byte)0x8a, (byte)0x00, (byte)0x00, (byte)0x00, (byte)0x57,
                                   (byte)0x41, (byte)0x56, (byte)0x45, (byte)0x66, (byte)0x6d, (byte)0x74, (byte)0x20, (byte)0x10, (byte)0x00,
                                   (byte)0x00, (byte)0x00, (byte)0x01, (byte)0x00, (byte)0x01, (byte)0x00, (byte)0x44, (byte)0xac, (byte)0x00,
                                   (byte)0x00, (byte)0x88, (byte)0x58, (byte)0x01, (byte)0x00, (byte)0x02, (byte)0x00, (byte)0x10, (byte)0x00,
                                   (byte)0x64, (byte)0x61, (byte)0x74, (byte)0x61, (byte)0x8A, (byte)0x58, (byte)0x01, (byte)0x00
                           };
