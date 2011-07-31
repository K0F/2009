import rita.*;

RiText[] rts;
RiGrammar grammar;

void setup()
{
  size(650, 200);
  rts = new RiText[3];
  RiText.setDefaultAlignment(CENTER);
  //PFont a = createFont("Veranda",9);
  //RiText.setDefaultFont(a);
  rts[0] = new RiText(this, "click to", width/2, 85);
  rts[1] = new RiText(this, "generate", width/2, 110);
  rts[2] = new RiText(this, "a haiku",  width/2, 135);
  grammar = new RiGrammar(this, "haiku.g");
}

void draw()
{
  background(100);
}

void mouseClicked()                                                                                
{    
  String result = grammar.expand();
  String[] lines = result.split("%");
  for (int i = 0; i < rts.length; i++) {
    rts[i].fadeToText(lines[i].trim(), 1.0f);
  }
}


