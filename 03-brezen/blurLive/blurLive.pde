import processing.opengl.*;
import codeanticode.glgraphics.*;
 
GLTexture srcTex, bloomMask, destTex;
GLTexture tex0, tex2, tex4, tex8, tex16;
GLTextureFilter extractBloom, blur, blend4, tonemap;
GLTextureParameters floatTexParams;
GLTextureFilterParameters bloomParam, toneParam;
GLGraphics glg1;
 
void setup() {
  size(800, 600, GLConstants.GLGRAPHICS);
 
  // Loading required filters.
  extractBloom = new GLTextureFilter(this, "ExtractBloom.xml");
  blur = new GLTextureFilter(this, "Blur.xml");
  blend4 = new GLTextureFilter(this, "Blend4.xml", 4);  
  tonemap = new GLTextureFilter(this, "ToneMap.xml", 2);
 
  bloomParam = new GLTextureFilterParameters(this);
  bloomParam.parFlt1 = 0.99; // bright threshold;  
  toneParam = new GLTextureFilterParameters(this);
  toneParam.parFlt1 = 0.86; // exposure;
  toneParam.parFlt2 = 0.5;  // bloom factor;
  toneParam.parFlt3 = 0.9;  // bright threshold;  
 
  glg1 = new GLGraphics(width, height, this, true);
  srcTex = glg1.getTexture();
  int w = srcTex.width;
  int h = srcTex.height;
  destTex = new GLTexture(this, w, h);
 
  // Initializing bloom mask and blur textures.
  floatTexParams = new GLTextureParameters();
  floatTexParams.format = GLTexture.FLOAT4;
  floatTexParams.minFilter = GLTexture.LINEAR;
  floatTexParams.magFilter = GLTexture.LINEAR;    
 
  bloomMask = new GLTexture(this, w, h, floatTexParams);
  tex0 = new GLTexture(this, w, h, floatTexParams);
  tex2 = new GLTexture(this, w / 2, h / 2, floatTexParams);
  tex4 = new GLTexture(this, w / 4, h / 4, floatTexParams);
  tex8 = new GLTexture(this, w / 8, h / 8, floatTexParams);
  tex16 = new GLTexture(this, w / 16, h / 16, floatTexParams);    
 
  srcTex.setFlippedY(true);  
  bloomMask.setFlippedY(true);  
  destTex.setFlippedY(true);  
  tex0.setFlippedY(true);  
  tex2.setFlippedY(true);      
  tex4.setFlippedY(true);      
  tex8.setFlippedY(true);  
  tex16.setFlippedY(true);
}
 
void draw() {
  glg1.beginDraw();
  glg1.stroke(255);
  glg1.background(0);    
  glg1.fill(255, 0, 0);
  glg1.rect(30, 30, 300, 200);
  glg1.stroke(0,255, 0);    
  glg1.line(0, 0, mouseX, mouseY);
  glg1.endDraw();  
 
  float fx = float(mouseX) / width;
  float fy = float(mouseY) / height;
 
  bloomParam.parFlt1 = fx;
  toneParam.parFlt1 = fy;    
  toneParam.parFlt3 = fx;
 
  // Extracting the bright regions from input texture.
  srcTex.filter(extractBloom, tex0, bloomParam);
 
  // Downsampling with blur.
  tex0.filter(blur, tex2);
  tex2.filter(blur, tex4);    
  tex4.filter(blur, tex8);    
  tex8.filter(blur, tex16);      
 
  // Blending downsampled textures.
  blend4.apply(new GLTexture[]{tex2, tex4, tex8, tex16  }, new GLTexture[]{ bloomMask });
 
  // Final tone mapping into destination texture.
  tonemap.apply(new GLTexture[]{srcTex, bloomMask  }, new GLTexture[]{destTex  }, toneParam);
 
  image(destTex, 0, 0, width, height);
} 
