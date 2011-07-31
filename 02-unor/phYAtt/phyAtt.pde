import traer.physics.*;

int num = 750;
Particle q[];

Particle mouse,mouse2;
ParticleSystem physics;

Recorder r;

color cols[] = new color[3];


float anim = 1;
int interval = 80;
int counter = 0;
float pos[][] = new float [num][2];
int cycle[] =new int[num];

float rot = 0;

void setup()
{
	size( 1280/2,720/2 ,P3D);
	//frameRate( 24 );
	//smooth();
	rectMode( CENTER );
	noStroke();
	cursor(CROSS);

	
	
	cols[0] = color(#000000);
	cols[1] = color(#ffffff);
	cols[2] = color(#431c00);

	
	physics = new ParticleSystem( 0, 0.001 );
	mouse = physics.makeParticle();
	mouse.makeFixed();
	
	mouse2 = physics.makeParticle();
	mouse2.makeFixed();
	
	mouse.moveTo( width/2,height/2.0,10 );

	r = new Recorder("out","phy4.mp4");

	q = new Particle[num];

	for(int i =0;i<q.length;i++){
		
		
		q[i] = physics.makeParticle(1.1,map(i,0,q.length-1,10,width-10), height-1,random(10)/* random(150)*/ );
		physics.makeAttraction( mouse, q[i], 100000, 1000 );
		physics.makeAttraction( mouse2, q[i], -1000, 1000 );
		q[i].setVelocity(anim,0,0);
		
		pos[i][0] = q[i].position().x();
		pos[i][1] = q[i].position().y();
		
		cycle[i] = (int)random(10000);
	}

	
	/*
		for(int i =0;i<q.length;i++){
			for(int j =0;j<q.length;j++){
				if(i!=j){
				physics.makeAttraction( q[i], q[j], -0.1, 10 );
				
				}
			}
		}
	*/
	
	background(cols[0]);


}

void draw(){
	
	counter++;
	mouse.moveTo( sin(counter/3.0)*width/5+width/2, cos(counter/10.0)*height/5+height/2 , 12 );
	mouse2.moveTo( cos(counter/3.0)*width/5+width/2, sin(counter/10.0)*height/5+height/2 , 10 );
	for(int j =0;j<q.length;j++){
		handleBoundaryCollisions( q[j] );
	}
	physics.tick(8);

	//background( 255 );

	fill( 255, 0, 0 );
	//ellipse( mouse.position().x(), mouse.position().y(), 35, 35 );
	
	fill( 0,15 );
	if(frameCount>2)
	for(int j =0;j<q.length;j++){
		float adda = 1;
		//if(j<30) //||j>q.length-30
		cycle[j]++;
			adda = ((sin(cycle[j]/2030.0)+1.0)/2.0)*10.0;
		
		stroke( lerpColor(cols[2],cols[1],constrain((PI+atan2(q[j].position().y()+sin(atan2(q[j].position().y()-pos[j][1],q[j].position().x()-pos[j][0])*30.0)*20.0 - pos[j][1] ,q[j].position().x()+cos(atan2(q[j].position().y()-pos[j][1],q[j].position().x()-pos[j][0])*30.0)*20.0 - pos[j][0]))/TWO_PI,0,1) ),/*(norm(q[j].velocity().x(),-8,8)*3.0+adda)*map(q[j].position().z(),-1,50,2.0,0.0000001)*/(interval-counter)/(interval+0.0)*15 );
		//line( q[j].position().x()+sin(j/3000.0)*10.0, q[j].position().y(), pos[j][0]+sin(j/30.0)*10.0, pos[j][1] );
		//println(atan2(	q[j].position().y()+sin(atan2(q[j].position().y()-pos[j][1],q[j].position().x()-pos[j][0])*30.0)*20.0 - pos[j][1] ,q[j].position().x()+cos(atan2(q[j].position().y()-pos[j][1],q[j].position().x()-pos[j][0])*30.0)*20.0 - pos[j][0]));
		
		line( q[j].position().x()+cos(atan2(q[j].position().y()-pos[j][1],q[j].position().x()-pos[j][0])*30.0)*20.0, q[j].position().y()+sin(atan2(q[j].position().y()-pos[j][1],q[j].position().x()-pos[j][0])*30.0)*20.0, pos[j][0], pos[j][1] );
		
		pos[j][0] = q[j].position().x();
		pos[j][1] = q[j].position().y();
		//pos[j][2] = q[j].position().z();
	}
	
	if(counter>interval){
		reset();
	}

	if(frameCount>4975){
		exit();
	}
	
	
}

void reset(){

	
	anim+=0.005;
	for(int i =0;i<q.length;i++){
		q[i].moveTo(map(i,0,q.length-1,10,width-10), height-1,random(10)/* random(150)*/ );
		q[i].setVelocity(anim,0,0);
		
		pos[i][0] = q[i].position().x();
		pos[i][1] = q[i].position().y();
		//pos[i][2] = q[i].position().z();

	}

	counter = 0;
	
	if(frameCount>1)
	r.add();
	filter(BLUR,0.81);
	fill(cols[0],50);
	rect(width/2,height/2,width,height);
	//box(width/2);
	//background(255);

}

void keyPressed(){
	if(key=='q'){
		r.finish();
		exit();
	}

}

// really basic collision strategy:
// sides of the window are walls
// if it hits a wall pull it outside the wall and flip the direction of the velocity
// the collisions aren't perfect so we take them down a notch too
void handleBoundaryCollisions( Particle p )
{
	if ( p.position().x() < 0 || p.position().x() > width )
		p.setVelocity( -0.9*p.velocity().x(), p.velocity().y(), 0 );
	if ( p.position().y() < 0 || p.position().y() > height )
		p.setVelocity( p.velocity().x(), -0.9*p.velocity().y(), 0 );
	if ( p.position().z() < 0 || p.position().z() > width )
		p.setVelocity( p.velocity().x(), p.velocity().y(), -0.9*p.velocity().z() );
	
	p.moveTo( constrain( p.position().x(), 0, width ), constrain( p.position().y(), 0, height ), constrain( p.position().z(), 0, width ));
}
