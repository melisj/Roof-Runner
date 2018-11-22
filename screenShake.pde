float clockStart = 0;
float clockStop = 0;
float screenX = 2;
float screenY = 2;
int redTint;
boolean isHit = false;

void screenshake() {
  if (isHit) {
    redTint = 50;
    clockStart++;
 //clockStop is basically zero but i made a variable for it to show was it does
 //if clockStop(0) + 5 is greater than clockstart, 
 //which keeps counting up THIS happens (the first screenshake)
 //after 5 frames clockStop + 5 won't be greater then clockStart so THIS stops happenening
 //in the first 5 frames i also added a red flash to indicate that the player got hit
 
    if (clockStop + 5 >= clockStart) {
      fill(255, 0, 0, redTint);
      rectMode(CORNER);
      rect(0, 0, 1920, 1080);
      redTint -= 10;
      for (Building buildings : building) {
        buildings.x += screenX;
        buildings.y += screenY;
      }
      for (object objecten : object) {
        objecten.objX += screenX;
        objecten.objY += screenY;
      }
      for (policeMan policeMan : policeMan) {
        policeMan.x += screenX;
        policeMan.y += screenY;
      }      
      player.X += screenX;
      player.Y += screenY;

      powerup.x += screenX;
      powerup.y += screenY;
    }


//the same deal here but this doesn't happen in the first 5 frames
    if (clockStart >= 5 && clockStop + 10 >= clockStart) {
      for (Building buildings : building) {
        buildings.x += screenX;
        buildings.y -= screenY;
      }
      for (object objecten : object) {
        objecten.objX += screenX;
        objecten.objY -= screenY;
      }
      for (policeMan policeMan : policeMan) {
        policeMan.x += screenX;
        policeMan.y -= screenY;
      }
      player.X += screenX;
      player.Y -= screenY;

      powerup.x += screenX;
      powerup.y -= screenY;
    }



    if (clockStart >= 10 && clockStop + 15 >= clockStart) {
      for (Building buildings : building) {
        buildings.x -= screenX;
        buildings.y += screenY;
      }
      for (object objecten : object) {
        objecten.objX -= screenX;
        objecten.objY += screenY;
      }
      for (policeMan policeMan : policeMan) {
        policeMan.x -= screenX;
        policeMan.y += screenY;
      }
      player.X -= screenX;
      player.Y += screenY;

      powerup.x -= screenX;
      powerup.y += screenY;
    }



    if (clockStart >= 15 && clockStop + 20 >= clockStart) {
      for (Building buildings : building) {
        buildings.x -= screenX;
        buildings.y -= screenY;
      }
      for (object objecten : object) {
        objecten.objX -= screenX;
        objecten.objY -= screenY;
      }
      for (policeMan policeMan : policeMan) {
        policeMan.x -= screenX;
        policeMan.y -= screenY;
      }
      player.X -= screenX;
      player.Y -= screenY;

      powerup.x -= screenX;
      powerup.y -= screenY;
    }
  }




  if (clockStop + 20 <= clockStart) {
    clockStart = 0;
    clockStart = 0;
    isHit = false;
  }
}