//  SWETUL PATEL  7802010

/// BASIC Math functions

// the "2D cross product"
float cross2(float[] e1, float[] e2)
{
  return (e1[0]*e2[1])-(e1[1]*e2[0]);
}

float[] cross3(float[] a, float[] b)
{
  // TODO: 
  float q = (a[1]*b[2])-(a[2]*b[1]);
  float w = (a[2]*b[0])-(a[0]*b[2]);
  float e = (a[0]*b[1])-(a[1]*b[0]);
  
  return new float[]{q, w, e};
}

// normalize v to length 1 in place
float[] normalize(float[] v)
{
  // TODO:
  float absVal = (sqrt((v[X]*v[X]) + (v[Y]*v[Y])));
  v[0] = v[0]/absVal;
  v[1] = v[1]/absVal;
  return v;
}

float magnitude(float[] v)
{
 return abs(sqrt((v[X]*v[X]) + (v[Y]*v[Y])));
}

float dot(float[] v1, float[] v2)
{
  
  return (v1[X]*v2[X])+(v1[Y]*v2[Y]);
}

// return a new vector representing v1-v2
float[] subtract(float[] v1, float v2[])
{
  float q = v1[0]-v2[0];
  float w = v1[1]-v2[1];
  //float e = v1[2]-v2[2];
  return new float[]{q, w};
}
