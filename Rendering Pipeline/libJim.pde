final int GRID = 10;
void drawTest(float scale)
{
  float left = -scale/2;
  float right = scale/2;
  float top = scale/2;
  float bottom = -scale/2;

  float r = 1; 
  float g = 0; 
  float b = 0;
  beginShape(LINES);
  for (int i=0; i < GRID; i++)
    for (int j=0; j<GRID; j++)
    {
      float x = left + scale/GRID*i;
      float y = bottom + scale/GRID*j;

      g = (i>GRID/2) ? 1: 0;
      b = (j>GRID/2) ? 1: 0;
      stroke(r, g, b);
      myVertex(left, y);
      myVertex(right, y);
      myVertex(x, bottom);
      myVertex(x, top);
    }
  endShape(LINES);
}
