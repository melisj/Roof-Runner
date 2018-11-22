SpriteSheet playerSpriteSheet;
SpriteSheet playerSlideSpriteSheet;

SoundFile jump;
SoundFile get_hit;
SoundFile pickUp;

float gotHitcounter = 0;

player player = new player();
//player info
class player {
  int sizeX = 40; //begin grote van de speler
  int sizeY = 50; //
  final int NORMAL_SIZE_X = 40; //normale grote van speler
  final int NORMAL_SIZE_Y = 50; //
  final int SLIDE_SIZE_X = 50; //de grote van de speler als hij slide
  final int SLIDE_SIZE_Y = 30; //

  final float START_X = 500;
  float X; //de X waarde van de speler
  float Y; //de Y waarde van de speler
  float jumpVelocity; 
  float jumpForce = -13;
  float gravity;
  float vx;

  boolean forcedSliding = false; //als je geforceerd slide kan je niet springen of een boemerang gooien

  void init() {
    X = START_X;
    Y = 100;
    vx = 5.5;
    jumpVelocity = 0;
    gravity = 1;
  }



  void update() {
    if (buttonPressed[UP] && gravity == 0 && !forcedSliding) { //springen
      jumpVelocity = jumpForce;
      jump.play();
    }  

    if (buttonPressed[DOWN] && gravity != 0) {
      gravity = 1;
    }

    if (buttonPressed[DOWN] && gravity == 0) { //bukken
      sizeX = SLIDE_SIZE_X;
      sizeY = SLIDE_SIZE_Y;
    } else {
      sizeX = NORMAL_SIZE_X; 
      sizeY = NORMAL_SIZE_Y;
    }

    jumpVelocity += gravity; //player krijgt altijd gravity
    Y += jumpVelocity;

    gravity = 0.7;

    if (player.vx > 0) { //score erbij gebasseerd op je snelheid
      score += player.vx / 10;
    }

    if (player.X < 0 || player.Y > height + player.sizeX*2 || player.X < 0) { //als de speler naar beneden valt of van het scherm gaat
      lives = 0; //sterft hij
    }

    if (lives == 0) { //als de speler geen levens heeft komt er de text BUSTED
      texts.add(new texts());
      texts text = texts.get(texts.size() - 1);
      text.text = "BUSTED";
      text.colorGreen = 0;
      text.colorRed = 255;
      text.y -= texts.size() * player.sizeY;
    }

    for (puddle puddle : puddles) {
      float overlapX;
      overlapX = collision1Axis(X, puddle.startX, sizeX, puddle.endX - puddle.startX);

      //als er een overlap is met een puddle slide je automatische
      if (overlapX != 0 && Y <= puddle.Y + 15 && Y >= puddle.Y - 10) {
        sizeX = SLIDE_SIZE_X;
        sizeY = SLIDE_SIZE_Y;
        forcedSliding = true;
      } else {
        forcedSliding = false;
      }
    }


    //collision met objecten
    for (object object : object) {
      //overlaps met objecten
      float bukObject = object.objY - 1; //als het object onderdoor te bukken valt er geen collision zijn voor een klein stukje
      float overlapY;

      //als er onder het object door te bukken valt verandert de collision
      if (object.randomObj >= 5) 
        overlapY = collision1Axis(Y - sizeY, bukObject - imageObject[object.randomObj].height, sizeY, imageObject[object.randomObj].height - player.SLIDE_SIZE_Y);
      else 
      overlapY = collision1Axis(Y - sizeY, object.objY - imageObject[object.randomObj].height, sizeY, imageObject[object.randomObj].height);

      float overlapX = collision1Axis(X, object.objX, sizeX, imageObject[object.randomObj].width);

      //speler word teruggezet met de waarde die het overlapt
      if ((abs(overlapX) > abs(overlapY))) {
        Y += overlapY;
      } else if ((abs(overlapX) < abs(overlapY))) {
        X += overlapX;
      }

      //als de speler op het object staat stopt hij met vallen
      if (overlapY < 0 && X + sizeX > object.objX && X < object.objX + imageObject[object.randomObj].width) {
        gravity = 0;
        if (jumpVelocity > 1) {
          jumpVelocity = 0;
        }
        break;
      }
      //als de speler onder object ligt slide hij automatiche
      if (overlapY > 0 && X + sizeX > object.objX && X < object.objX + imageObject[object.randomObj].width) {
        sizeX = SLIDE_SIZE_X;
        sizeY = SLIDE_SIZE_Y;
        forcedSliding = true;
      } else {
        forcedSliding = false;
      }
    }



    //checkt of er collision is met gebouwen
    for (Building building : building) {
      // testing new collision
      float overlapY = collision1Axis(Y - sizeY, building.top, sizeY, building.h );
      float overlapX = collision1Axis(X, building.left, sizeX, building.right - building.left);


      if ((abs(overlapX) > abs(overlapY))) {
        Y += overlapY;
      } else if ((abs(overlapX) < abs(overlapY))) {
        X += overlapX;
      }

      //als de speler op het object staat stopt hij met vallen
      if (overlapY < 0 && X + sizeX > building.left && X < building.right) {
        gravity = 0;
        if (jumpVelocity > 1) {
          jumpVelocity = 0;
        }
        break;
      }

      //snelheid stopt als de speler tegen de zijkant van het gebouw komt
      if (overlapX < 0 && player.Y > building.top ) {
        vx = 0;
        break;
      }
    }
    playerSpriteSheet.update();
    playerSlideSpriteSheet.update();
  }

  void draw() {
    update();

    rectMode(CORNER);
    stroke(0, 0, 255);
    fill(250, 0, 0, 255);    

    //als de speler slide verandert de texture
    if (buttonPressed[DOWN] && gravity == 0 || sizeY == SLIDE_SIZE_Y) {
      playerSlideSpriteSheet.draw(X, Y - sizeY, sizeX, sizeY);
    } else {
      playerSpriteSheet.draw(X, Y - sizeY, sizeX, sizeY);
    }
  }
}






/* Old collision
 if (player.Y > building.top + 20 && player.X + player.SizeX > building.left && player.X <= building.right) {
 player.vx = 0;    
 player.X = building.left - player.SizeX;
 }
 if (player.Y >= building.top && player.Y <= building.top + 20 && player.X + player.SizeX >= building.left && player.X <= building.right) {
 player.gravity = 0;
 player.jumpVelocity = 0;
 player.Y = building.top;
 }
 }//*/