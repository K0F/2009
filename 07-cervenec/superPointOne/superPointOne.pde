import com.hardcorepawn.*;
import processing.opengl.*;

SuperPoint p;

void setup()
{
	size(400,400,OPENGL);
	p=new SuperPoint(this);
	for(int i=0;i<100000;i++)
	{
		float ina = random(0.5);
		float x = random(-100,100);
		float y = random(-100,100);
		float z = random(-100,100);

		p.addPoint(x,y,z,1,1,1,0.5 );
	}
}

void draw()
{

	background(0);
	translate(width/2,height/2);
	rotateY(frameCount/300.0);

	pushMatrix();
	p.draw(13);
	popMatrix();
}
