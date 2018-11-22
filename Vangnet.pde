ArrayList<Bullet2> bullet2 = new ArrayList<Bullet2>();
SpriteSheet vangnetSpriteSheet;

class Bullet2 {
  float posX; 
  float posY;
  float size = 40;
  float vx = 6;
  float vy;

  float bulletSpread = random(0.6, 1.1);
}


//het initialiseren van een bullet
void setupBullet2(float HelicopterX, float HelicopterY, float speedY) {
  Bullet2 bullets2 = bullet2.get(bullet2.size() - 1); //bullet aan het eind van array (nieuw bullet)
  bullets2.posX = HelicopterX;
  bullets2.posY = HelicopterY;
  bullets2.vy = speedY;
}

void updateBullets2() {
  
  //elke bullet word gecheckt
  for (int i = bullet2.size() - 1; i >= 0; i--) {
    Bullet2 bullets2 = bullet2.get(i);
    
    float highestIndex = bullet2.size();

    //posities veranderen
    bullets2.posX -= bullets2.vx + player.vx; 
    bullets2.posY += bullets2.vy * bullets2.vx * bullets2.bulletSpread;

    //als bullet uit het scherm is word het verwijdert
    if (bullets2.posX < -bullets2.size) {
      bullet2.remove(i);
      break;
    }

    //checkt of obj word geraakt en verwijdert de bullet
    for (object objecten : object) {
      if (bullets2.posX + bullets2.size > objecten.objX 
        && bullets2.posX < objecten.objX + imageObject[objecten.randomObj].width
        && bullets2.posY + bullets2.size> objecten.objY - imageObject[objecten.randomObj].height
        && highestIndex == bullet2.size()) {
        bullet2.remove(i);
        break;
      }
    }

    //checkt of building word geraakt en verwijdert de bullet
    for (Building buildings : building) {
      if (bullets2.posX + bullets2.size > buildings.left 
        && bullets2.posX < buildings.right
        && bullets2.posY + bullets2.size > buildings.top
        && highestIndex == bullet2.size()) {
        bullet2.remove(i);
        break;
      }
    }

    //checkt of player word geraakt en verwijdert de bullet
    if (bullets2.posX + bullets2.size > player.X 
      && bullets2.posX < player.X + player.sizeX 
      && bullets2.posY + bullets2.size > player.Y - player.sizeY
      && bullets2.posY < player.Y
      && highestIndex == bullet2.size()) {
      bullet2.remove(i);

      if (powerup.shield == false) {
        lives--;
        
        get_hit.play();
        isHit = true;

        //blood particle
        particles.add(new particle(color(255, 0, 0), color(150, 0, 0), 20, player.vx, -1, bullets2.posX, bullets2.posY, 1));

        get_hit.play();

        texts.add(new texts());
        texts text = texts.get(texts.size() - 1);
        text.text = "-1 LIFE";
        text.colorGreen = 0;
        text.colorRed = 255;
        text.y -= texts.size() * player.sizeY;
      }

      break;
    }
  }
  vangnetSpriteSheet.update();
}

void drawBullets2() {
  updateBullets2();

  //elke bullet word hier gedrawt
  for (int i = bullet2.size() - 1; i >= 0; i--) {
    Bullet2 bullets2 = bullet2.get(i);
    fill(0, 0, 0, 255);
    rectMode(CORNER);
    vangnetSpriteSheet.draw(bullets2.posX, bullets2.posY, bullets2.size, bullets2.size);
  }
}