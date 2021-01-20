// Swetul Patel  
void myVertex(PVector vert)
{
  _myVertex(vert.x, vert.y, false);
}

void myVertex(float x, float y)
{
  _myVertex(x, y, false);
}

void myVertex(float x, float y, boolean debug)
{
  _myVertex(x, y, debug);
}

// translate the given point from object space to viewport space,
// then plot it with vertex.
void _myVertex(float x, float y, boolean debug)
{

// this one!
  //println("--------------------------------");
  PVector n = new PVector(x,y,1);
  PVector p = new PVector();
  M.mult(n,p);
  V.mult(p,p);
  Pr.mult(p,p);
  Vp.mult(p,p);
  vertex(p.x,p.y);

}
