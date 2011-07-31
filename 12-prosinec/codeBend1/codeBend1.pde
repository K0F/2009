// values to modify


for(int i = 0; i<20;i++){
int value = 60;
color white = color(255);
color myBlack = color(0);

background(myBlack);

stroke(random(255),random(255),random(255),255);
fill(random(255),random(255),random(255));
rect(random(40),random(40),random(40), random(255) );

stroke(random(255));
fill(random(255),random(255),random(255));
rect(random(40),random(40),random(255),random(255));
save("test"+i+".png");

}
exit();
