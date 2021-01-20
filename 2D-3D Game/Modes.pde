//Swetul Patel
final char KEY_VIEW = 'r';
final char KEY_LEFT = 'a';
final char KEY_RIGHT = 'd';
final char KEY_UP = 'w';
final char KEY_DOWN = 's';
final char KEY_JUMP = ' ';
final char KEY_BONUS = 'b';
final char KEY_TEX = 't';
final char KEY_COLLISION = 'c';

boolean keyLeft = false;
boolean keyRight = false;
boolean keyDown = false;
boolean keyUp = false;
boolean keyJump = false;
boolean doBonus = false;
boolean doTextures = false;
boolean doCollision = false;

// false is perspective mode.
boolean orthoMode = true;

void keyPressed()
{
  if(key == KEY_VIEW)
  {
    orthoMode = !orthoMode;
  }
  if(key == KEY_RIGHT)
  {
    keyRight = true;  
  }
  if(key == KEY_LEFT)
  {
    keyLeft = true; 
  }
  if(key == KEY_UP)
  {
    keyUp = true; 
  }
  if(key == KEY_DOWN)
  {
    keyDown = true;
  }
  if(key == KEY_TEX)
  {
    doTextures = !doTextures;
  }
  if(key == KEY_JUMP)
  {
     if(!doubleJump && keyJump)
     {
       doubleJump = true;
     }
     else
     {
       if(!midJump)
       {
         keyJump = true;
         decel = false;
         midJump = true;
       }  
     }
  } 
}
void keyReleased()
{
  if(key == KEY_RIGHT)
  {
    keyRight = false;  
  }
  if(key == KEY_LEFT)
  {
    keyLeft = false; 
  }
  if(key == KEY_UP)
  {
    keyUp = false; 
  }
  if(key == KEY_DOWN)
  {
    keyDown = false;
     
  }
  //if(key == ' ')
  //{
  //  keyJump = false;
  //  if(doubleJump)
  //  {
  //    doubleJump = false;
  //    keyJump = false;
  //    firstJump = 0;
  //  }
    
  //  jump = 0;
  //}
}
