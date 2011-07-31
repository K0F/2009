PImage bg;


int sDetail = 35;  //Sphere detail setting
float rotationX = 0;
float rotationY = 0;
float velocityX = 0;
float velocityY = 0;
float globeRadius = 300;
float pushBack = 0;

float[] cx,cz,sphereX,sphereY,sphereZ;
float sinLUT[];
float cosLUT[];
float SINCOS_PRECISION = 0.5f;
int SINCOS_LENGTH = int(360.0 / SINCOS_PRECISION);


void renderGlobe(){
	//earth.beginDraw();
	earth.pushMatrix();
	earth.translate(width/2.0, height/2.0, pushBack);
	earth.pushMatrix();
	earth.noFill();
	earth.stroke(0);
	earth.strokeWeight(4);
	earth.smooth();
	earth.popMatrix();
	//earth.lights();
	earth.pushMatrix();
	earth.rotateX( radians(-rotationX) );
	earth.rotateY( radians(270 - rotationY) );
	earth.fill(200);
	earth.noStroke();
	earth.textureMode(IMAGE);
	texturedSphere(globeRadius, texmap);
	earth.popMatrix();
	earth.popMatrix();
	//earth.endDraw();
	rotationX += velocityX;
	rotationY += velocityY;
	velocityX *= 0.95;
	velocityY *= 0.95;

	// Implements mouse control (interaction will be inverse when sphere is  upside down)
	//if(mousePressed){
	//	velocityX += (mouseY-pmouseY) * 0.01;
	//	velocityY -= (mouseX-pmouseX) * 0.01;
	//}
}

void initializeSphere(int res){
	sinLUT = new float[SINCOS_LENGTH];
	cosLUT = new float[SINCOS_LENGTH];

	for (int i = 0; i < SINCOS_LENGTH; i++) {
		sinLUT[i] = (float) Math.sin(i * DEG_TO_RAD * SINCOS_PRECISION);
		cosLUT[i] = (float) Math.cos(i * DEG_TO_RAD * SINCOS_PRECISION);
	}

	float delta = (float)SINCOS_LENGTH/res;
	float[] cx = new float[res];
	float[] cz = new float[res];

	// Calc unit circle in XZ plane
	for (int i = 0; i < res; i++) {
		cx[i] = -cosLUT[(int) (i*delta) % SINCOS_LENGTH];
		cz[i] = sinLUT[(int) (i*delta) % SINCOS_LENGTH];
	}

	// Computing vertexlist vertexlist starts at south pole
	int vertCount = res * (res-1) + 2;
	int currVert = 0;

	// Re-init arrays to store vertices
	sphereX = new float[vertCount];
	sphereY = new float[vertCount];
	sphereZ = new float[vertCount];
	float angle_step = (SINCOS_LENGTH*0.5f)/res;
	float angle = angle_step;

	// Step along Y axis
	for (int i = 1; i < res; i++) {
		float curradius = sinLUT[(int) angle % SINCOS_LENGTH];
		float currY = -cosLUT[(int) angle % SINCOS_LENGTH];
		for (int j = 0; j < res; j++) {
			sphereX[currVert] = cx[j] * curradius;
			sphereY[currVert] = currY;
			sphereZ[currVert++] = cz[j] * curradius;
		}
		angle += angle_step;
	}
	sDetail = res;
}

// Generic routine to draw textured sphere
void texturedSphere(float r, PImage t){
	int v1,v11,v2;
	r = (r + 240 ) * 0.33;
	//earth.beginDraw();
	earth.beginShape(TRIANGLE_STRIP);
	earth.texture(t);
	float iu=(float)(t.width-1)/(sDetail);
	float iv=(float)(t.height-1)/(sDetail);
	float u=0,v=iv;
	for (int i = 0; i < sDetail; i++) {
		earth.vertex(0, -r, 0,u,0);
		earth.vertex(sphereX[i]*r, sphereY[i]*r, sphereZ[i]*r, u, v);
		u+=iu;
	}
	earth.vertex(0, -r, 0,u,0);
	earth.vertex(sphereX[0]*r, sphereY[0]*r, sphereZ[0]*r, u, v);
	endShape();

	// Middle rings
	int voff = 0;
	for(int i = 2; i < sDetail; i++) {
		v1=v11=voff;
		voff += sDetail;
		v2=voff;
		u=0;
		earth.beginShape(TRIANGLE_STRIP);
		earth.texture(t);
		for (int j = 0; j < sDetail; j++) {
			earth.vertex(sphereX[v1]*r, sphereY[v1]*r, sphereZ[v1++]*r, u, v);
			earth.vertex(sphereX[v2]*r, sphereY[v2]*r, sphereZ[v2++]*r, u, v+iv);
			u+=iu;
		}

		// Close each ring
		v1=v11;
		v2=voff;
		earth.vertex(sphereX[v1]*r, sphereY[v1]*r, sphereZ[v1]*r, u, v);
		earth.vertex(sphereX[v2]*r, sphereY[v2]*r, sphereZ[v2]*r, u, v+iv);
		earth.endShape();
		v+=iv;
	}
	u=0;

	// Add the northern cap
	earth.beginShape(TRIANGLE_STRIP);
	earth.texture(t);
	for (int i = 0; i < sDetail; i++) {
		v2 = voff + i;
		earth.vertex(sphereX[v2]*r, sphereY[v2]*r, sphereZ[v2]*r, u, v);
		earth.vertex(0, r, 0,u,v+iv);
		u+=iu;
	}
	earth.vertex(0, r, 0,u, v+iv);
	earth.vertex(sphereX[voff]*r, sphereY[voff]*r, sphereZ[voff]*r, u, v);
	earth.endShape();
	
	//earth.endDraw();

}

