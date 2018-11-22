 boemerang boemerang = new boemerang();

SpriteSheet boemerangSpriteSheet;
SpriteSheet boemerangSpeedSpriteSheet;

SoundFile catch_boomerang;
SoundFile boomerang;
SoundFile hit_obj;

//boemerang info
class boemerang {
  float X, Y; // beginposities voor de boemerang
  int diameter = 25; //de grote van de collision (hitbox is een rondje) 
  int radius = diameter / 2;
  float speedX = 0; //dit is om de totale snelheid in op te slaan
  float speedY;
  float comebackSpeed = 1; //dit is om de snelheid te laten afnemen en toenemen
  boolean alreadyPlayed = true;

  final float COMEBACK_SPEED_DECREASE = 0.95; //de snelheid waarmee de boemrang langzaam afremt
  final float COMEBACK_SPEED_INCREASE = 1.05; //de hoeveelheid snelheid die de boemerang steeds toeneemt
  float beginSpeed = 20; //beginsnelheid

  //het reseten van de boemerang
  void init() {
    speedX = 0;
    speedY = 0;
    X = player.X + player.sizeX / 2;
    Y = player.Y - player.sizeY / 2;
  }
  void update() {

    if (speedX <= 0) { //checkt of de boemeang naar de speler gaat
      speedY = (player.Y - player.sizeY / 2 - Y) / (X - (player.X + player.sizeY / 2)); //berekening om de snelheid van de bal op de Y as te bepalen
      speedY += 2 * -((X - player.X + player.sizeX / 2) / width); //berekening om een boog te maken
    }

    if (speedX <= 0.8 && speedX >= 0.1) { //checkt of de boemerang bijna stil staat en draait de snelheid hem om als dit het geval is
      speedX *= -1; //snelheid omdraaien
      comebackSpeed = COMEBACK_SPEED_INCREASE; //de snelheid stijgt
    }

    speedX *= comebackSpeed; //snelheid exponentieel laten verhogen en verlagen
    X += speedX; //speed bij de positie
    Y -= speedY * speedX; //snelheid van Y keer de X snelheid


    for (int i = object.size() - 1; i >= 0; i--) { //elk object afloppen
      object objecten = object.get(i);

      //checkt of object geraakt word door boemerang 
      if (X + radius >= objecten.objX  
        && X - radius <= objecten.objX + imageObject[objecten.randomObj].width 
        && Y + radius > objecten.objY - imageObject[objecten.randomObj].height
        && !(X <= player.X + player.sizeX) ) {

        float overlapX = collision1Axis(X - radius, objecten.objX, diameter, imageObject[objecten.randomObj].height);
        X += overlapX;
        speedX = -player.vx; //draait de snelheid om
        comebackSpeed = COMEBACK_SPEED_INCREASE; //snelheid neemt toe
        hit_obj.play();
        break;
      }
    }


    for (Building building : building) { //checkt elk gebouw
      // testing new collision
      float overlapY = collision1Axis(Y - radius, building.top, diameter, building.h ); //Y as
      float overlapX = collision1Axis(X - radius, building.left, diameter, building.right - building.left); //X as

      //als de overlap groter is op een as plaats hij het object terug met de hoeveelheid overlap
      if ((abs(overlapX) > abs(overlapY))) { 
        Y += overlapY;
      } else if ((abs(overlapX) < abs(overlapY))) {
        X += overlapX;
      }

      //checkt of boemerang de bovenkant van het gebouw raakt
      if (overlapY < 0 && X + radius > building.left && X - radius < building.right) {
        speedY = 0;
        comebackSpeed = COMEBACK_SPEED_DECREASE; //snelheid neemt af
        break;
      } 
      //checkt of de boemerang de zijkant raakt en komt terug
      if (overlapX < 0 && Y + radius > building.top) {
        if (speedX > -player.vx) { //checkt of de boemerang naar het gebouw toe gaat
          speedX = -player.vx; //draait de snelheid om
          comebackSpeed = COMEBACK_SPEED_INCREASE;
          hit_obj.play();
          break;
        }
      }
    }

    boemerangSpriteSheet.update();
    boemerangSpeedSpriteSheet.update();
  }


  void draw() {
    update();

    //checkt of de boemerang bij de player is en reset de boemerang
    if (X <= player.X + player.sizeX) { //checkt of de boemerang bij de speler is
      init();
      if (alreadyPlayed == false) {
        catch_boomerang.play();
        alreadyPlayed = true;
      }
      boomerang.stop();
    } else {
      tint(255, 255);
      imageMode(CENTER);
      //als de boemerang powerup actief is verandert de texture
      if (powerup.numEffect == 2 && powerup.active) {
        boemerangSpeedSpriteSheet.draw(X, Y, diameter, diameter);
      } else {
        boemerangSpriteSheet.draw(X, Y, diameter, diameter);
      }
      imageMode(CORNER);
    }
  }
}




/*// old collision
 if (Y + radius > building.top && X + radius > building.left && X - radius <= building.right) { 
 if (speedX > -player.vx) { //checkt of de boemerang naar het gebouw toe gaat
 speedX = player.vx * -1; //draait de snelheid om
 comebackSpeed = COMEBACK_SPEED_INCREASE;
 }
 if (player.Y - player.NORMAL_SIZE_Y  > Y && Y < building.top)
 comebackSpeed = COMEBACK_SPEED_DECREASE;
 speedY = 0;
 }*/