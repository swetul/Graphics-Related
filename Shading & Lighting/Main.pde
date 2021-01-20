
//  SWETUL PATEL 

class Triangle {
  Triangle(float[] V1, float[] V2, float[] V3) {  // does DEEP copy!!
    v1 = Arrays.copyOf(V1, V1.length); 
    v2 = Arrays.copyOf(V2, V2.length);
    v3 = Arrays.copyOf(V3, V3.length);
  }

  // position data. in 3D space
  float[] v1; // 3 triangle vertices
  float[] v2;
  float[] v3;

  // projected data. On the screen raster
  float[] pv1; // (p)rojected vertices
  float[] pv2;
  float[] pv3;
  
  float[] E1;
  float[] E2;
  float[] E3;
  
  float normal;
  float[] v1Col;
  float[] v2Col;
  float[] v3Col;
   
}

Triangle[] sphereList;
Triangle[] rotatedList;
int xtr = 0;

void setup() {
  ortho(-320, 320, 320, -320); // hard coded, 640x640 canvas, RHS
  resetMatrix();
  colorMode(RGB, 1.0f);

  sphereList = makeSphere(SPHERE_SIZE, 10);
  rotatedList = new Triangle[sphereList.length];
  announceSettings();
}

void settings() {
  size(640, 640, P3D); // hard coded 640x640 canvas
}

float theta = 0.0;
float delta = 0.01;
void draw() {
  clear();

  if (rotate)
  {
    theta += delta;
    while (theta > PI*2) theta -= PI*2;
  } 
  
  
  if (lineTest)
    lineTest();
  else
  {
    rotateSphere(sphereList, rotatedList, theta);
    drawSphere(rotatedList, lighting, shading);
  }
}

//////////////////////  MAIN PROGRAM
// creates a sphere made of triangles, centered on 0,0,0, with given radius
//
// also - 
// calculates the 3 edge vectors for each triangle
// calculates the face normal (unit length)
//
// HINT: first setup a loop to calculate all the points around the sphere,
//       store in an array then loop over those points and setup your triangles.
Triangle[] makeSphere(int radius, int divisions)
{
  //Generate points of a sphere with radius and number of divisions
  // i = Theta
  // j = phi
  float spaceX = TWO_PI/divisions;
  float spaceY = PI/divisions;
  float[][][] points = new float[divisions+1][divisions+1][3];
  stroke(1.0f, 1.0f, 1.0f);
  float iterX = 0;
  float iterY = 0;
  int count = 0;
  for(int i = 0; i <= divisions; i++)
  {
    //println("i = "+iterX);
    for(int j = 0; j <= divisions; j++)
    {
      ///println("j = "+iterY);
      float X = (radius*sin(iterY)*sin(iterX));
      float Y = (radius*cos(iterY));
      float Z = (radius*sin(iterY)*cos(iterX));
      println("XYZ= " +X +" ^ "+Y+" ^ " +Z);
      float[] temp = {X,Y,Z};
      points[i][j] = temp;
      count++;
      iterY += spaceY;
    }
    iterY = 0;
    iterX += spaceX;
  }

  println("DONE---------------------------");
  
  //make triangles from points
   //make triangles from points
   println(count);
   Triangle[] TfromP = new Triangle[divisions*divisions*2];
   int c = 0;

  for(int a = 0; a < divisions; a++)
  {
    for(int b = 0; b < divisions; b++)
    {
      float[] v1; 
      float[] v2;
      float[] v3;
      
      v1 = points[a][b];                   //ab--a+1b--a+1b+1 CW OR ab--a+1b+1--a+1b  CCW  Correct
      v2 = points[a+1][b+1];                    
      v3 = points[a+1][b];                    //ab--a+1b+1--ab+1 CW OR ab--ab+1--a+1b+1  CCW  correct
      
      TfromP[c++] = new Triangle(v1,v2,v3);
      v1 = points[a][b];                      
      v2 = points[a][b+1];                    
      v3 = points[a+1][b+1];
      
      TfromP[c++] = new Triangle(v1,v2,v3);
     }
    }
    println(c);
  return TfromP;
}

 //<>//

// takes a new triangle, and calculates it's normals and edge vectors
Triangle setupTriangle(Triangle t)
{
  
  t.E1 = subtract(t.v2,t.v1);
  t.E2 = subtract(t.v3,t.v2);
  t.E3 = subtract(t.v1,t.v3);
  
  t.normal = cross2(t.E1,t.E2);
  
  return t;
}

// This function draws the 2D, already projected triangle, on the raster
// - it culls degenerate or back-facing triangles
//
// - it calls fillTriangle to do the actual filling, and bresLine to
// make the triangle outline. 
//
// - implements the specified lighting model (using the global enum type)
// to calculate the vertex colors before calling fill triangle. Doesn't do shading
//
// - if needed, it draws the outline and normals (check global variables)
//
// HINT: write it first using the gl LINES/TRIANGLES calls, then replace
// those with your versions once it works.
void draw2DTriangle(Triangle t, Lighting lighting, Shading shading)
{
  t.E1 = subtract(t.pv2,t.pv1);
  t.E2 = subtract(t.pv3,t.pv2);
  t.E3 = subtract(t.pv1,t.pv3);
  
  if((cross2(t.E1,t.E2)) > 1)
  {
    if(shading != Shading.NONE)
    {
      fillTriangle(t, shading);   
    }    
    if(doOutline)
    {
      stroke(OUTLINE_COLOR[0],OUTLINE_COLOR[1],OUTLINE_COLOR[2]);
      bresLine((int)t.pv1[0],(int)t.pv1[1],(int)t.pv2[0],(int)t.pv2[1]);
      bresLine((int)t.pv1[0],(int)t.pv1[1],(int)t.pv3[0],(int)t.pv3[1]);
      bresLine((int)t.pv2[0],(int)t.pv2[1],(int)t.pv3[0],(int)t.pv3[1]);
    }
  }
}

// uses a scanline algorithm to fill the 2D on-raster triangle
// - implements the specified shading algorithm to set color as specified
// in the global variable shading. Note that for NONE, this function simply
// returns without doing anything
// - uses POINTS to draw on the raster
void fillTriangle(Triangle t, Shading shading)
{
  //find bindingbox
  float xMin = min(t.pv1[X],t.pv2[X],t.pv3[X]);
  float xMax = max(t.pv1[X],t.pv2[X],t.pv3[X]);
  float yMin = min(t.pv1[Y],t.pv2[Y],t.pv3[Y]);
  float yMax = max(t.pv1[Y],t.pv2[Y],t.pv3[Y]);
  
  //draw the pixel
  for(int row = (int)xMin; row < xMax; row++)
  {
    for(int col = (int)yMin; col < yMax; col++)
    {
      float[] currentP = {row,col};
      float[] A1 = subtract(currentP,t.pv1);
      float[] A2 = subtract(currentP,t.pv2);
      float[] A3 = subtract(currentP,t.pv3);
      float area = abs(t.normal)/2;
      float cross1 = cross2(t.E1,A1);
      float cross2 = cross2(t.E2,A2);
      float cross3 = cross2(t.E3,A3);
      float[] norm = cross3(t.v1,t.v2);  // 3dcross
      float u = (abs(cross2)/2)/area;
      float v = (abs(cross3)/2)/area;
      float w = (abs(cross1)/2)/area;
      boolean valid = false;

      if(cross1 >= 0)
      {
        if(cross2 >= 0)
        {
          if(cross3 >= 0)
          {
             valid = true;     
          }
        }
      }
            
      if(valid)
      {
        if(shading == Shading.FLAT)
        {
          if(lighting == Lighting.PHONG_FACE)
          {
            float[] pf_flat = phong(currentP, norm, EYE, LIGHT, MATERIAL, FILL_COLOR, PHONG_SPECULAR);

          stroke(pf_flat[0],pf_flat[1],pf_flat[2]);
          }
          else
          {
            stroke(FILL_COLOR[0],FILL_COLOR[1],FILL_COLOR[2]);
          }
          
          beginShape(POINTS);
          vertex(row,col);
          endShape();
        }
        if(shading == Shading.BARYCENTRIC)
        {
          //cross 231
          stroke(u,v,w);
          beginShape(POINTS);
          vertex(row,col);
          endShape();
        }
        if(shading == Shading.GOURAUD)
        {
          
          if(lighting == Lighting.FLAT)
          {
            t.v1Col = FILL_COLOR;
            t.v2Col = FILL_COLOR;
            t.v3Col = FILL_COLOR;
          }
          if(lighting == Lighting.PHONG_FACE)
          {
            
            t.v1Col = phong(t.pv1, norm, EYE, LIGHT, MATERIAL, FILL_COLOR, PHONG_SPECULAR);
            t.v2Col = phong(t.pv2, norm, EYE, LIGHT, MATERIAL, FILL_COLOR, PHONG_SPECULAR);
            t.v3Col = phong(t.pv3, norm, EYE, LIGHT, MATERIAL, FILL_COLOR, PHONG_SPECULAR);
          }
          float[] t1 = {t.v1Col[0]*u,t.v1Col[1]*u,t.v1Col[2]*u};
          float[] t2 = {t.v2Col[0]*v,t.v2Col[1]*v,t.v2Col[2]*v};
          float[] t3 = {t.v3Col[0]*w,t.v3Col[1]*w,t.v3Col[2]*w};
          
          float r = (t1[0]+t2[0]+t3[0]);
          float g = (t1[1]+t2[1]+t3[1]);
          float b = (t1[2]+t2[2]+t3[2]);
          
          //cross 231
          stroke(r,g,b);
          beginShape(POINTS);
          vertex(row,col);
          endShape();
        }
        if(shading == Shading.PHONG)
        {
          
        }
        
      }  
   }   
  }   
}

// given point p, normal n, eye location, light location, calculates phong
// - material represents ambient, diffuse, specular as defined at the top of the file
// - calculates the diffuse, specular, and multiplies it by the material and
// - fillcolor values
float[] phong(float[] p, float[] n, float[] eye, float[] light, 
  float[] material, float[] fillColor, float s)
{

  //D
  float[] L = new float[3];
  
  L = subtract(light,p);
  L = normalize(L);
  n = normalize(n);

  float cosTH = dot(L,n);
  //float cosTh = (dot(L,n)) / (magnitude(L)*magnitude(n));
  
  //S
  float[] V = new float[3];
  V = subtract(eye,p);
  V = normalize(V);

  float r1 = 2*cosTH*n[0] - L[0];
  float r2 = 2*cosTH*n[1] - L[1];
  float[] r = {r1,r2};
  r = normalize(r);

  float cosTH2 = dot(r,V);

  
  float iD = material[M_DIFFUSE] * cosTH;
  float iS = pow(max(0.0,cosTH2),s)*material[M_SPECULAR];
  float iA = material[M_AMBIENT];
  float I = iD+iS+iA;
  
  
  float[] phong = {fillColor[0]*I,fillColor[2]*I,fillColor[2]*I};  //<>//
  
  return phong;
}

// implements Bresenham's line algorithm
void bresLine(int fromX, int fromY, int toX, int toY)
{
  int changeX = toX - fromX;
  int changeY = toY- fromY;
  float gradient = 0;
  //to avoid division by zero
  if(changeX != 0 && changeY != 0)
  {
    gradient = ((float)changeY)/changeX;
  }

  int directionX = 1;    //assuming direction is right
  int directionY = 1;    //assuming direction is up
  
  // setting all the directional depending on changeX and changeY
  
  //direction is left
  if(changeX < 0)
  {
    changeX = -changeX;
    directionX = -1;
  }
  //direction is down
  if(changeY < 0)
  {
    changeY = -changeY;
    directionY = -1;
  }
  //edge case when no change in y, no movement along Y-axis i.e HORIZONTAL LINE
  if(changeY == 0)
  {
    directionY = 0;
  }
  //edge case when no change in X, no movement along X-axis i.e VERTICAL LINE
  if(changeX == 0)
  {
    directionX = 0;
  }

   //make gradient positive to add to error and estimate whether to move in the appropriate direction
   if(gradient < 0)
   {
     gradient = -gradient;
   }
   
   int X = fromX;
   int Y = fromY;
   float error = 0.5;
   // two cases occur therefore two loops. 1. where change in X is greater than change in Y. and viceversa.
   if(changeX > changeY)
   {
     while(true)
     {
       beginShape(POINTS);
       vertex(X,Y);
       endShape();
     
       X += directionX;
       error += gradient;
       if(error > 0.5)
       {
         Y += directionY;
         error -= 1;
       }
       if(X == toX)
       {
         break;
       }
     }
   }
   //case where change in Y is greater than change in X
   else{
     gradient = 1/gradient;
     while(true)
     {
       beginShape(POINTS);
       vertex(X,Y);
       endShape();
     
       Y += directionY;
       error += gradient;
       if(error > 0.5)
       {
         X += directionX;
         error -= 1;
       }
       if(Y == toY)
       {
         break;
       }
     }
   }
  }  
  
