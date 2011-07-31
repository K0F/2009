
import javax.media.opengl.*;
import processing.opengl.*;
import java.nio.*;

void setup(){


	size(200,200,OPENGL);
	fill(255);
	textFont(createFont("04B_21__",16));
	background(255);



	//set everything up as usual
	PGraphicsOpenGL pgl = ((PGraphicsOpenGL)g);
	GL gl = pgl.beginGL();

	// GLFont (opengl Context, font name, size (in pixels), smooth)
	GLFont gltext = new GLFont(gl, "Arial",26, true);
	gltext.setcolor( 1.0, 0.0, 0.0, 1.0);
	pgl.endGL();

	//....
	//somewhere in your render
	gl = pgl.beginGL();
	gltext.write(gl, "Joey Joe-Joe Junior Shabadoo" ,  20, 20);
	pgl.endGL();

	//....
	//when you dont need text any longer
	gltext.deallocate(gl);



}

class GLFont{
	int _texsize, _tex[], _list[];
	float _size, _charwidth[], _color[];
	String _name;
	Hashtable _charmap;

	GLFont(GL gl, String fontName, float fontSize, boolean smoothFont){
		PFont font = createFont(fontName, fontSize, smoothFont);
		textFont(font);
		textMode(MODEL);

		_name = fontName;
		_size = fontSize;
		_texsize = font.images[0].width;
		_tex = new int[280];
		_list = new int[280];
		_charwidth = new float[280];
		_charmap = new Hashtable();
		setcolor(1,1,1,1);

		ByteBuffer tempBuf;
		boolean noImage;
		_charwidth[32] = textWidth( " " );
		for(int index=0; index<279; index++){
			_charmap.put( new Character( char(font.value[index]) ), new Integer(index) );
			_charwidth[index]= textWidth(char(font.value[index]));

			noImage = true;
			
			tempBuf = ByteBuffer.allocate( 4 * font.images[index].pixels.length );
			for(int t=0; t< font.images[index].pixels.length; t++){
				tempBuf.putInt(  t*4, (255<<24)+(255<<16)+(255<<8)+(font.images[index].pixels[t]) );
				if( font.images[index].pixels[t] >0 ) noImage = false;
			}
			tempBuf.rewind();
			if( noImage ) continue;

			_tex[index] = glNewTex(gl, GL.GL_TEXTURE_2D, _texsize, _texsize, GL.GL_RGBA, GL.GL_RGBA, GL.GL_UNSIGNED_BYTE,  GL.GL_NEAREST, GL.GL_NEAREST,  tempBuf);

			//generate and build the display list
			_list[index] = gl.glGenLists(1);
			gl.glNewList( _list[index] ,GL.GL_COMPILE);
			gl.glActiveTexture( GL.GL_TEXTURE0);
			gl.glEnable( GL.GL_TEXTURE_2D );
			gl.glBindTexture( GL.GL_TEXTURE_2D, _tex[index] );

			gl.glPushMatrix();
			gl.glBegin(GL.GL_POINTS);
			//i shift the pixel to the char's correct distance from the baseline
			gl.glVertex2f( _texsize/2 +font.leftExtent[index] , _size + _texsize/2 -font.topExtent[index] );
			gl.glEnd();
			gl.glPopMatrix();
			gl.glEndList();
		}
		gl.glActiveTexture( GL.GL_TEXTURE0);
		gl.glEnable( GL.GL_TEXTURE_2D );
		gl.glBindTexture( GL.GL_TEXTURE_2D, 0 );
	}

	void deallocate(GL gl){
		gl.glDeleteTextures(128, _tex, 0);
		gl.glDeleteLists(128, _list[0] );
	}

	void setcolor(float r, float g, float b, float a){
		_color = new float[]{r,g,b,a};
	}

	void write(GL gl, String l_text, float x, float y){
		gl.glPushAttrib( GL.GL_ALL_ATTRIB_BITS );
		gl.glPushMatrix();
		gl.glColor4f( _color[0], _color[1], _color[2], _color[3] );
		gl.glTranslatef(x,y,0);
		gl.glDepthMask(false);
		gl.glDisable(GL.GL_DEPTH_TEST);
		gl.glEnable(GL.GL_BLEND);  //blending is important for alpha

		//set up point sprites
		gl.glEnable(GL.GL_POINT_SPRITE);
		gl.glPointSize(_texsize);
		gl.glTexEnvi(GL.GL_POINT_SPRITE, GL.GL_COORD_REPLACE, GL.GL_TRUE);
		int len = l_text.length();
		int t;
		for(int i=0; i<len; i++){
			if( _charmap.containsKey( new Character( l_text.charAt(i) ) ) ){
				t = ( (Integer)_charmap.get( new Character( l_text.charAt(i) ) ) ).intValue();
				gl.glCallList( _list[t] );
				gl.glTranslatef( _charwidth[t], 0, 0 );
			}else if( l_text.charAt(i) == char(32) )
				gl.glTranslatef( _charwidth[32], 0, 0 );
		}
		gl.glPopMatrix();
		gl.glPopAttrib();
	}
}

//Create a new texture of any type and pass back it's ID
int glNewTex(GL gl, int texType, int w, int h,  int internalFormat, int l_format, int dataType, int minFilter, int magFilter, Buffer data){
	gl.glActiveTexture( GL.GL_TEXTURE0 );
	gl.glEnable(texType);
	int[] temp = new int[1];
	gl.glGenTextures( 1, temp, 0 );

	gl.glBindTexture( texType, temp[0] );
	gl.glTexParameteri( texType, GL.GL_TEXTURE_MIN_FILTER, minFilter );
	gl.glTexParameteri( texType, GL.GL_TEXTURE_MAG_FILTER, magFilter );
	gl.glTexParameteri( texType, GL.GL_TEXTURE_WRAP_S, GL.GL_CLAMP_TO_EDGE );
	gl.glTexParameteri( texType, GL.GL_TEXTURE_WRAP_T, GL.GL_CLAMP_TO_EDGE );
	gl.glTexImage2D( texType, 0, internalFormat, w, h, 0, l_format, dataType, data );
	gl.glActiveTexture( GL.GL_TEXTURE0);
	gl.glEnable( GL.GL_TEXTURE_2D );
	gl.glBindTexture( GL.GL_TEXTURE_2D, 0 );
	return temp[0];
}


