SpriteSheet heliSpriteSheet;
SoundFile heli_shoot;
Helicopter Helicopter = new Helicopter();

class Helicopter {
  float x = 1700, 
    y = 100, 
    w = 100, 
    h = 100;
  float upDownSpeed = 1.5, 
    startX = 1700;
  int time = millis();


  void update() {  
    //Laat de helicopter omhoog & omlaag bewegen
    Helicopter.y += Helicopter.upDownSpeed;
    if (Helicopter.y >= 250 || Helicopter.y <= 50 ) {
      Helicopter.upDownSpeed *= -1;
    }

    //Laat de helicopter dichterbij komen
    if (lives == 3) {
      Helicopter.x = Helicopter.startX;
    } 
    if (lives == 2 && Helicopter.x >= Helicopter.startX - 425 ) {    
      Helicopter.x-=3;
    }
    if (lives == 1 && Helicopter.x >= Helicopter.startX - (425 * 2) ) {    
      Helicopter.x-=3;
    }

    //schiet vangnet elke X seconden
    if (millis() >= time + 5000) {
      bullet2.add(new Bullet2());
      setupBullet2(Helicopter.x, Helicopter.y+40, (player.Y - Helicopter.y) / (Helicopter.x - player.X));
      time = millis();
      heli_shoot.play();
    }

    heliSpriteSheet.update();
  }




  void draw() {  
    Helicopter.update();
    tint(255, 255);
    heliSpriteSheet.draw(Helicopter.x, Helicopter.y, Helicopter.w, Helicopter.h);
  }
}