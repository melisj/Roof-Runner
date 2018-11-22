powerup powerup = new powerup();

SpriteSheet lifePowerSpriteSheet;
SpriteSheet speedPowerSpriteSheet;
SpriteSheet jumpPowerSpriteSheet;
SpriteSheet shieldPowerSpriteSheet;
SpriteSheet boemerangSpeedPowerSpriteSheet;

boolean timerBoost = false;
float counterSpawn = 10;
float counterPowerup = 0;

final float RESPAWN_TIME = 1;
final float POWERUP_TIME_LENGTH = 12;

class powerup {
  float x = 0;
  float y = 0;
  float size = 40;
  float vx = 0;

  String name;
  String quote;

  boolean shield;
  boolean spawned; //powerup staat ergens op het scherm of heeft een plaats gekregen buiten het scherm
  boolean active; //de speler heeft de powerup geactiveerd

  int numEffect = (int)random(0, 5); //het effect wat de powerup gaat hebben 
}

void powerup() {
  float top = powerup.y;
  float bottom = powerup.y + powerup.size;
  float right = powerup.x + powerup.size;
  float left = powerup.x;
  rectMode(CENTER);
  powerup.vx = -player.vx;
  powerup.x += powerup.vx;

  if (left <= 0)
    powerup.spawned = false;

  if (!powerup.spawned && !powerup.active) {
    counterSpawn++;
  }
  //als counter / 60 (secondes dus) groter is dan 5
  if (counterSpawn / 60 >= RESPAWN_TIME) {
    counterSpawn = 0;
    powerup.spawned = true;
    for (Building building : building) {
      if (width < building.left) {
        powerup.y = building.top - random(40, 100);
        powerup.x = random(building.left, building.right);
      }
    }
  }

  //als de powerup in een object staat krijgt het een nieuwe plek
  for (int i = object.size() - 1; i >= 0; i--) {
    object objecten = object.get(i);
    if (powerup.x > width)
      if (powerup.x + powerup.size > objecten.objX && powerup.x < objecten.objX + imageObject[objecten.randomObj].width + 50 && objecten.objY < height) {
        //als je niet onder het object kan bukken word hij er bovenop geplaats 
        if (objecten.randomObj < 5)
          powerup.y = objecten.objY - imageObject[objecten.randomObj].height - random(30, 100);
        else 
        counterSpawn = 60 * RESPAWN_TIME; //respawnt de powerup
      }
  }

  //collision met player
  if ((right > player.X && left < player.X + player.sizeX )&& 
    (bottom > player.Y - player.sizeY  && top < player.Y)) {   
    pickUp.play();
    timerBoost = true;
    powerup.x = -100; 
    powerup.y = -100;
    powerup.active = true;
    powerup.spawned = false;

    //particle effect als je powerup pakt
    if (powerup.numEffect == 3) {
      particles.add(new particle(color(0, 255, 0), color(0, 50, 0), 30, player.vx, -4, player.X + player.sizeX / 2, player.Y - player.sizeY / 2, 0));
    } else {
      particles.add(new particle(color(0, 0, 255), color(0, 0, 50), 30, player.vx, -4, player.X + player.sizeX / 2, player.Y - player.sizeY / 2, 0));
    }

    //geeft een effect op de speler gebasseerd op welke powerup is opgepakt
    switch(powerup.numEffect) {
    case 0: 
      player.vx *= 1.5; 
      powerup.quote = "GOTTA GO FAST";
      powerup.name = "SPEED";
      break;
    case 1: 
      player.jumpForce = -16; 
      powerup.quote = "JUMP FOR THE SKY";
      powerup.name = "JUMP FORCE";
      break;
    case 2: 
      boemerang.beginSpeed = 30; 
      powerup.quote = "THROW THAT THING";
      powerup.name = "BOEMERANG SPEED";
      break;
    case 3: 
      lives++;
      counterPowerup = POWERUP_TIME_LENGTH * 60;

      texts.add(new texts());
      texts text = texts.get(texts.size() - 1);
      text.text = "+1 LIFE";
      text.colorGreen = 255;
      text.colorRed = 0;
      text.y -= texts.size() * player.sizeY;

      break;
    case 4:
      powerup.shield = true;
      powerup.quote = "PROTECT YOURSELF";
      powerup.name = "SHIELD";
      break;
    }
  }

  //drawt schild als het actief is
  if (powerup.shield == true) {
    imageMode(CENTER);
    image(shield, player.X + (player.sizeX/2), player.Y - (player.sizeY/2));
    imageMode(CORNER);
  }

  //als de speed powerup is geactiveerd gaat de speler langzaam vooruit totdat hij bij de orginele plek is waar hij begint
  if (powerup.numEffect == 0 && powerup.active && player.X <= player.START_X) {
    player.X += 0.7;
    boemerang.X += 0.7;
  }

  //timer voor de powerup
  if (timerBoost == true) {  
    counterPowerup++;
  }


  //als counter / 60 (secondes dus) groter is dan 5 reset het de powerup
  if (counterPowerup / 60 >= POWERUP_TIME_LENGTH) {
    powerup.active = false;
    switch(powerup.numEffect) {
    case 0: 
      player.vx = 5.5; //run speed reset
      break;
    case 1: 
      player.jumpForce = -13; //jump speed reset
      break;
    case 2: 
      boemerang.beginSpeed = 20; //boemerang speed reset
      break;
    case 4:
      powerup.shield  = false;
      break;
    }

    timerBoost = false; 
    counterPowerup=0; 
    powerup.numEffect = (int)random(0, 5); //effect reset
  }

  lifePowerSpriteSheet.update();
  speedPowerSpriteSheet.update();
  jumpPowerSpriteSheet.update();
  shieldPowerSpriteSheet.update();
  boemerangSpeedPowerSpriteSheet.update();
}

void drawPowerup() {
  powerup(); 
  
  //de texture van de powerup word bepaald door het effect van de powerup
  switch(powerup.numEffect) {
  case 0:
    speedPowerSpriteSheet.draw(powerup.x, powerup.y, powerup.size, powerup.size);
    break;
  case 1:
    jumpPowerSpriteSheet.draw(powerup.x, powerup.y, powerup.size, powerup.size);
    break;
  case 2:
    boemerangSpeedPowerSpriteSheet.draw(powerup.x, powerup.y, powerup.size, powerup.size);
    break;
  case 3: 
    lifePowerSpriteSheet.draw(powerup.x, powerup.y, powerup.size, powerup.size);
    break;
  case 4:
    shieldPowerSpriteSheet.draw(powerup.x, powerup.y, powerup.size, powerup.size);
    break;
  }
}