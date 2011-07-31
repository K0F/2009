import rita.wordnet.*;

RiWordnet wordnet;
PFont font1, font2;
String word;
String[] flak = new String[25];
color[] c = new color[25];
int radek =  0;
Basnik kecal;
boolean say = false;
int lastRadek = 0;

void setup() 
{
  size(300, 400,P3D);    
  font1 = loadFont("00Acrobatix-8.vlw");
  font2 = loadFont("Verdana-Bold-48.vlw");  
  wordnet = new RiWordnet(this,"/sketchBook/libraries/ritanet/library");
  kecal =  new Basnik("kevin16");  
  textMode(SCREEN);
}

void draw() 
{  
  background(30);
  // get synonyms every 100 frames 
  if (frameCount%30 == 1)  
  {   
    String sec = "";    
    String first = "";    
    String pre = "";
    String adv = "";
    String adj = "";
    
    //String[] temp = new String[10];
    first = wordnet.getRandomWord("v", true, 5);
    //temp = wordnet.getRandomWord(pos, stemsOnly, maxChars);
    sec = wordnet.getRandomWord("v", true, 8);    
    adv = wordnet.getRandomWord("r", true, 5);
    adj = wordnet.getRandomWord("a", true,12);
    
     if((adj.charAt(0)=='a')||(adj.charAt(0)=='e')||(adj.charAt(0)=='i')||
     (adj.charAt(0)=='o')||(adj.charAt(0)=='u')||(adj.charAt(0)=='y')){
      pre = "an"; 
    }
    else{
      pre = "a"; 
    }
    flak[radek] = "to ";
    flak[radek] += first; 
    flak[radek] += ", and ";
    flak[radek] += sec;
    flak[radek] += ", ";
    flak[radek] += pre;
    flak[radek] += " ";
    flak[radek] += adv;
    flak[radek] += " ";
    flak[radek] += adj;
    flak[radek] += " ";
    flak[radek] += wordnet.getRandomWord("n", true, 5);
    flak[radek] += ".";
    c[radek] = color(random(80,255));

    say = true;
    lastRadek=radek;
    radek++;

    if(radek==flak.length-1){
      radek=0;      
    }
  }
  
   textFont(font2);
  fill(255,55);
  text("poem::gen",5,48);

    textFont(font1);
  int yPos=60;   // draw the synonyms

  for (int i = 0; i < flak.length; i++){
    if(flak[i]==null){
    }
    else{
      fill(c[i]);
      text(flak[i], 10, yPos += 13);
    }  
  }
  
  if(say){
    rekni(); 
  }
}

void rekni(){
  println(flak[lastRadek]);
  kecal.mluv(flak[constrain(lastRadek-1,0,flak.length)]);  
  say = false;
}
