import java.util.Arrays;

// GLOBAL CONSTANTS
// -- use float[] for vectors, indexed as below
final int X = 0; 
final int Y = 1; 
final int Z = 2;
final int R = 0; 
final int G = 1; 
final int B = 2;

// resonable settings for size, projection, lighting.
final int SPHERE_SIZE = 200;

final float[] LIGHT = {200, 200, 350}; // location of light
final float[] EYE = {0, 0, 600};

final float[] OUTLINE_COLOR = {1.0f, .2f, .5f};
final float[] FILL_COLOR    = {1.0f, 1.0f, 1.0f}; 

// reasonable constants for PHONG
final float[] MATERIAL = {0.1, 0.8, 0.8}; // ambient, diffuse, specular %
final int M_AMBIENT = 0; 
final int M_DIFFUSE = 1; 
final int M_SPECULAR = 2;  
final float PHONG_SPECULAR = 30;


// returns null of the point is too close to the user (and thus not drawn). check for that
//
// uhm... don't worry about how this works :D
final float PERSPECTIVE = 0.002; // 1/500, don't bother changing 
float[] project(float[] v)
{
  float adjZ = v[Z]-EYE[Z];  // RHS, Z into screen
  if (adjZ>0) 
    return null; // clipping plane
  adjZ *=- 1; 
  float px = v[X] / (adjZ*PERSPECTIVE);
  float py = v[Y] / (adjZ*PERSPECTIVE);
  return new float[]{px, py};
}

// and don't worry about this, either
void rotateVertex(float[] v, float theta)
{
  float rx = v[X]*cos(theta) - v[Z]*sin(theta);
  float rz = v[X]*sin(theta) + v[Z]*cos(theta);
  v[X]=rx; 
  v[Z]=rz;
}

// Projects all the triangles from 3D space (x,y,z) to screen raster coordinates
// then draws each triangle.
// - this is provided so you don't have to mess with projection
void drawSphere(Triangle[] sphere, Lighting lighting, Shading shading)
{
  for (Triangle t : sphere) 
  {
    if (t == null)
      continue;

    // has to be re-projected each time because of animation
    t.pv1 = project(t.v1); 
    t.pv2 = project(t.v2);
    t.pv3 = project(t.v3);

    // null is clipped vertex
    if (! (t.pv1 == null || t.pv2 == null || t.pv3 == null) )
      draw2DTriangle(t, lighting, shading);
  }
}

// rotates all the sphere values by the angle given
void rotateSphere(Triangle[] original, Triangle[] rotated, float theta)
{
  for (int i = 0; i < original.length; i++)
  {
    if (rotated[i] == null)
      rotated[i] = setupTriangle(new Triangle(original[i].v1, original[i].v2, original[i].v3));
    else
    {
      System.arraycopy(original[i].v1, 0, rotated[i].v1, 0, original[i].v1.length);
      System.arraycopy(original[i].v2, 0, rotated[i].v2, 0, original[i].v2.length);
      System.arraycopy(original[i].v3, 0, rotated[i].v3, 0, original[i].v3.length);

      rotateVertex(rotated[i].v1, theta);
      rotateVertex(rotated[i].v2, theta);
      rotateVertex(rotated[i].v3, theta);
      setupTriangle(rotated[i]);
    }
  }
}
