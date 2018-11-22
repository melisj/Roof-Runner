ArrayList<Bullet> bullet = new ArrayList<Bullet>();

SpriteSheet bulletSpriteSheet;

class Bullet {
  float posX; 
  float posY;
  float sizeX = 20;
  float sizeY = 10;
  float vx = 10;
  float vy;

  float bulletSpread = random(0.8, 1.2);
}

//het initialiseren van een bullet
void setupBullet(float policeX, float policeY, float speedY) {
  Bullet bullets = bullet.get(bullet.size() - 1); //bullet aan het eind van array (nieuw bullet)
  bullets.posX = policeX;
  bullets.posY = policeY;
  bullets.vy = speedY;
}

void updateBullets() {

  //elke bullet word gecheckt
  for (int i = bullet.size() - 1; i >= 0; i--) {
    Bullet bullets = bullet.get(i);
    
    //dit is om bij te houden of de index verandert en er niet een bullet twee keer verwijdert kan worden
    float highestIndex = bullet.size();

    //smoke particle
    particles.add(new particle(color(150), color(20), 30, -2, -1, bullets.posX + bullets.sizeX, bullets.posY + bullets.sizeY / 2, 1));

    //posities veranderen
    bullets.posX -= bullets.vx + player.vx; 
    bullets.posY -= bullets.vy * bullets.vx * bullets.bulletSpread;

    //als bullet uit het scherm is word het verwijdert
    if (bullets.posX < -bullets.sizeX) {
      bullet.remove(i);
      break;
    }

    //checkt of building word geraakt en verwijdert de bullet
    for (Building buildings : building) {
      if (bullets.posX + bullets.sizeX > buildings.left 
        && bullets.posX < buildings.right
        && bullets.posY + bullets.sizeY > buildings.top
        && highestIndex == bullet.size()) {
        bullet.remove(i);
        break;
      }
    }

    //checkt of player word geraakt en verwijdert de bullet
    if (bullets.posX + bullets.sizeX > player.X 
      && bullets.posX < player.X + player.sizeX 
      && bullets.posY + bullets.sizeY > player.Y - player.sizeY
      && bullets.posY < player.Y
      && highestIndex == bullet.size()) {

        
      //als de speler geen schild heeft verliest hij een leven
      if (powerup.shield == false) {
        lives--;
        get_hit.play();
        isHit = true;
        
        //blood particle
        particles.add(new particle(color(255, 0, 0), color(150, 0, 0), 20, player.vx, -1, bullets.posX, bullets.posY, 1));

        get_hit.play();

        //voeg nieuwe text toe
        texts.add(new texts());
        texts text = texts.get(texts.size() - 1);
        text.text = "-1 LIFE";
        text.colorGreen = 0;
        text.colorRed = 255;
        text.y -= texts.size() * player.sizeY;
      }
      bullet.remove(i);
      break;
    }

    //checkt of player word geraakt en verwijdert de bullet
    for (object objecten : object) {
      if (bullets.posX + bullets.sizeX > objecten.objX 
        && bullets.posX < objecten.objX + imageObject[objecten.randomObj].width
        && bullets.posY + bullets.sizeY> objecten.objY - imageObject[objecten.randomObj].height
        && highestIndex == bullet.size()) {
        bullet.remove(i);
        break;
      }
    }
  }



  bulletSpriteSheet.update();
}

void drawBullets() {
  updateBullets();

  //elke bullet word hier gedrawt
  for (int i = bullet.size() - 1; i >= 0; i--) {
    Bullet bullets = bullet.get(i);
    bulletSpriteSheet.draw(bullets.posX, bullets.posY, bullets.sizeX, bullets.sizeY);
  }
}