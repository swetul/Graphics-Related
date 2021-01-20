// a test function that checks all the drawing octants and compars against the built
// in line function
void lineTest()
{
  int dsmall = 90;
  int dlarge = 180;
  int offset = 10;
  stroke(1.0f, 1.0f, 1.0f);
  beginShape(LINES);
  vertex(0, 0);
  vertex(dlarge, dsmall);
  vertex(0, 0);
  vertex(-dlarge, dsmall);
  vertex(0, 0);
  vertex(dlarge, -dsmall);
  vertex(0, 0);
  vertex(-dlarge, -dsmall);
  vertex(0, 0);
  vertex(dsmall, dlarge);
  vertex(0, 0);
  vertex(-dsmall, dlarge);
  vertex(0, 0);
  vertex(dsmall, -dlarge);
  vertex(0, 0);
  vertex(-dsmall, -dlarge);
  vertex(-dlarge, 0);
  vertex(dlarge, 0);
  vertex(0, -dlarge);
  vertex(0, dlarge);
  endShape(LINES);

  stroke(1.0f, 0f, 0.0f);
  bresLine(0+offset, 0+offset, dlarge+offset, dsmall+offset);
  bresLine(0+offset, 0+offset, -dlarge+offset, dsmall+offset);
  bresLine(0+offset, 0+offset, dlarge+offset, -dsmall+offset);
  bresLine(0+offset, 0+offset, -dlarge+offset, -dsmall+offset);

  bresLine(0+offset, 0+offset, dsmall+offset, dlarge+offset);
  bresLine(0+offset, 0+offset, -dsmall+offset, dlarge+offset);
  bresLine(0+offset, 0+offset, dsmall+offset, -dlarge+offset);
  bresLine(0+offset, 0+offset, -dsmall+offset, -dlarge+offset);

  bresLine(-dlarge, 0+offset, dlarge, 0+offset);
  bresLine(0+offset, -dlarge, 0+offset, dlarge);
}
