// .OBJ Loader
// by SAITO <http://users.design.ucla.edu/~tatsuyas> 
// Placing a virtual structure represented as mathematically 
// three-dimensional object.
// OBJModel.load() reads structure data of the object stored 
// as numerical data.
// OBJModel.draw() gives a visual form to the structure data.
// processing standard drawing functions can be used to manipulate
// the visual form to create deep visual experiences.
// Created 20 April 2005
import saito.objloader.*;
import processing.opengl.*;
OBJModel model;
float rotX;
float rotY;
               
void setup()
{ 
   size(400, 400, OPENGL);
   frameRate(30);
   smooth();
   //hint(ENABLE_OPENGL_4X_SMOOTH); 
   model = new OBJModel(this);
   model.load("krystof2.obj"); // dma.obj in data folder
    model.drawMode(POLYGON);
}

void draw()
{
   background(0);
   //stroke(255,80);
   noStroke();
   
   
   lights();
   //directionalLight(200, 200, 200, -1, 0, 0);
   ambientLight(102, 102, 102);

   
   pushMatrix();
   translate(width/2, height/2, 0);
   rotateX(rotY);
   rotateY(rotX);
   scale(70.0);
  
   model.draw();
   popMatrix();
}
void keyPressed()
{
   if(key == 'a')
   model.enableTexture();

   else if(key=='b')
   model.disableTexture();
}
void mouseDragged()
{
   rotX += (mouseX - pmouseX) * 0.01;
   rotY -= (mouseY - pmouseY) * 0.01;
}


/*class Vector
{
  float x,y,z;
  float nx,ny,nz;
  float mag;
  Vector(float _x, float _y, float _z)
  {
    x=_x;
    y=_y;
    z=_z;
    
    //calculate the normalised vector (vector of length 1) .. doesn't make sense for using vector for co-ords, but useful when an actual vector
    mag=sqrt(x*x+y*y+z*z);
    nx=x/mag;
    ny=y/mag;
    nz=z/mag;
  }
  
  Vector divide(float val)
  {
    return new Vector(x/val,y/val,z/val);
  }
}

// works out the distance between 2 points by their x,y,z co-ords.
float dist(Vector a, Vector b)
{
  float i=a.x-b.x;
  float j=a.y-b.y;
  float k=a.z-b.z;
  return sqrt(i*i+j*j+k*k);
}

float Dot(Vector a, Vector b)
{
  return(a.nx*b.nx + a.ny*b.ny + a.nz * b.nz);
}

Vector cross(Vector a, Vector b)
{
  return new Vector(a.y*b.z - a.z*b.y, a.z*b.x - a.x*b.z, a.x*b.y-a.y*b.x);
}

class MyLight
{
  float x,y,z;
  color c;
  
  MyLight(float _x, float _y, float _z, color _c)
  {
    x=_x;
    y=_y;
    z=_z;
    c=_c;
  }
}

class MyPoly
{
  Vector[] points;
  Vector Normal;
  Vector Centre;
  BImage lightmap;
  //3 point polys only to begin with...  
  MyPoly(Vector a, Vector b, Vector c)
  {
    points=new Vector[3];
    points[0]=a;
    points[1]=b;
    points[2]=c;
    
    Vector ba=new Vector(a.x-b.x, a.y-b.y, a.z-b.z);
    Vector cb=new Vector(b.x-c.x, b.y-c.y, b.z-c.z);
    
    Normal=cross(ba,cb);
    
    Centre=new Vector((a.x+b.x+c.x)/3.0,(a.y+b.y+c.y)/3.0,(a.z+b.z+c.z)/3.0);
    lightmap=new BImage(20,20);
    
  }
  
  void draw(MyLight[] Lights, int NumLights)
  {
     Vector ToLight;
     float lightlevel;
     color lc;
    stroke(255,0,0);
    
    Vector ab=new Vector(points[1].x-points[0].x, points[1].y-points[0].y, points[1].z-points[0].z);
    Vector bc=new Vector(points[2].x-points[1].x, points[2].y-points[1].y, points[2].z-points[1].z);
    Vector ca=new Vector(points[0].x-points[2].x, points[0].y-points[2].y, points[0].z-points[2].z);

    Vector GlobalLight=new Vector(Lights[0].x,Lights[0].y,Lights[0].z);
//    Vector Tangent=cross(ab,Normal);
 //   Vector Bitangent=cross(Tangent,Normal);
  //  Vector LocalLight=new Vector(Dot(GlobalLight,Tangent),Dot(GlobalLight,Bitangent),Dot(GlobalLight,Normal));
    
            
    Vector deltax=ab.divide(20);
    Vector deltay=bc.divide(20);

    for(int u=0;u<20;u++)
    {
      for(int v=0;v<=u;v++)
      {
        float a=points[0].x + u*deltax.x + v*deltay.x;
        float b=points[0].y + u*deltax.y + v*deltay.y;
        float c=points[0].z + u*deltax.z + v*deltay.z;
        color finalcolor=color(0,0,0);
        for(int w=0;w<NumLights;w++)
        {
          Vector d=new Vector(Lights[w].x-a,Lights[w].y-b,Lights[w].z-c);
          float ll=Dot(Normal,d);
//          color pc=color(red(Lights[w].c)*ll,0,0);
          Vector T=cross(ab,Normal);
          Vector B=cross(T,Normal);
          Vector LocalLight=new Vector(Dot(d,B),Dot(d,T),Dot(d,Normal));
          color bumpc=bump.get(u,v);
          Vector BumpNormal=new Vector((red(bumpc)-128)/128.0,(green(bumpc)-128)/128.0,(blue(bumpc)-128)/128.0);
          float NewPower=Dot(BumpNormal,LocalLight);
          color pc=color(NewPower*red(Lights[w].c),NewPower*green(Lights[w].c),NewPower*blue(Lights[w].c));
          finalcolor=color(red(finalcolor)+red(pc),green(finalcolor)+green(pc),blue(finalcolor)+blue(pc));          
        }
        lightmap.pixels[u+v*20]=finalcolor;
      }
    }
    fill(255,255,255);
    beginShape(POLYGON);
    texture(lightmap);
    vertex(points[0].x,points[0].y,points[0].z,0,0);
    vertex(points[1].x,points[1].y,points[1].z,19,0);
    vertex(points[2].x,points[2].y,points[2].z,19,19);
    endShape();
  }
}

class scene
{
  MyPoly[] Polys;
  MyLight[] Lights;
  int NumPolys;
  int NumLights;
  scene(int x, int y)
  {
    Polys=new MyPoly[x];
    Lights=new MyLight[y];
    NumPolys=0;
    NumLights=0;
  }
  
  void AddPoly(MyPoly a)
  {
    if(NumPolys<Polys.length)
    {
//      println("Adding Poly " + NumPolys);
      Polys[NumPolys]=a;
      NumPolys++;
    }
  }
  
  void AddLight(MyLight a)
  {
    if(NumLights<Lights.length)
    {
//      println("Adding light " + NumLights);
      Lights[NumLights]=a;
      NumLights++;
    }
  }
  
  void draw()
  {
    for(int i=0;i<NumPolys;i++)
    {
//      println("Drawing Plane " + i);
      Polys[i].draw(Lights,NumLights);
    }
  }
}

scene world;
BImage bump;

void setup()
{
  size(300,300);
  background(0);
  bump=loadImage("bump.jpg");
  world=new scene(100,3);
  world.AddLight(new MyLight(100,100,100,color(0,0,255)));
  world.AddLight(new MyLight(100,100,100,color(0,255,0)));
  world.AddLight(new MyLight(100,100,100,color(255,0,0)));
//  world.AddPoly(new MyPoly(new Vector(35,-35,0),new Vector(35,35,0),new Vector(-35,35,0)));
//  world.AddPoly
  Vector a=new Vector(-35,35,35);
  Vector b=new Vector(35,35,35);
  Vector c=new Vector(35,-35,35);
  Vector d=new Vector(-35,-35,35);
  Vector e=new Vector(35,35,-35);
  Vector f=new Vector(-35,35,-35);
  Vector g=new Vector(-35,-35,-35);
  Vector h=new Vector(35,-35,-35);
  
  world.AddPoly(new MyPoly(c,b,a));
  world.AddPoly(new MyPoly(a,d,c));
  world.AddPoly(new MyPoly(d,a,f));
  world.AddPoly(new MyPoly(f,g,d));
  world.AddPoly(new MyPoly(f,e,h));
  world.AddPoly(new MyPoly(h,g,f));
  world.AddPoly(new MyPoly(e,b,c));
  world.AddPoly(new MyPoly(c,h,e));
  world.AddPoly(new MyPoly(e,f,a));
  world.AddPoly(new MyPoly(a,b,e));
  world.AddPoly(new MyPoly(g,h,c));
  world.AddPoly(new MyPoly(c,d,g));
  
//  translate(width/2.0, height/2.0,0);
//  world.draw();
  
}

float an=0;
float an2=0;
float an3=0;

void loop()
{
  background(40,40,40);
  push();
  translate(width/2.0, height/2.0,0);
//  rotateY(an2);
  an+=0.05;
  an2+=0.0312;
  an3-=0.0412;
  world.Lights[0].x=100*sin(an3);
  world.Lights[0].y=100*sin(an);
  world.Lights[0].z=100*cos(an2);
  world.Lights[1].x=100*cos(an2);
  world.Lights[1].y=100*sin(an3);
  world.Lights[1].z=100*sin(an);
  world.Lights[2].x=100*cos(an);
  world.Lights[2].y=100*sin(an2);
  world.Lights[2].z=100*cos(an3);
  
  
  float mx=(mouseX-width/2.0)/(width/2.0);
  float my=(mouseY-height/2.0)/(height/2.0);
  
  rotateY(mx*PI);
  rotateX(my*PI);
  
  for(int i=0;i<world.NumLights;i++)
  {
  push();
  noStroke();
  translate(world.Lights[i].x,world.Lights[i].y,world.Lights[i].z);
  fill(world.Lights[i].c);
  sphere(5);
  pop();
  }

  world.draw();
  pop();
  for(int x=0;x<12;x++)
  {
    image(world.Polys[x].lightmap,x*20,0,20,20);
  }
}
*/
