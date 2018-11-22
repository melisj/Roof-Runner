SoundFile enemy_shoot;
SoundFile hit_enemy;
PImage politie;

ArrayList<policeMan> policeMan = new ArrayList<policeMan>();


class policeMan {
  float x = 0;
  float y = 0;

  float yOnBuilding; //een object kan verdwijnen als het niet goed geplaats is en dan moet de politie die op het object stond teruggeplaats worden

  int sizeX = 40;
  int sizeY = 50;

  float bulletReloadTimer = 0;
  final float BULLET_TIME = 2.5;

  //checkt of de politie de speler kan zien
  boolean lineOfSight() {
    if (x < width && x - player.X > 0) {
      return true;
    } else {
      return false;
    }
  }
}

//plaats de politie op het gegeven gebouw
void initPolice(int i, Building aBuilding) {
  policeMan curPolice = policeMan.get(i);

  curPolice.x = random(aBuilding.left + 100, aBuilding.right - curPolice.sizeX);
  curPolice.y = aBuilding.top;
  curPolice.yOnBuilding = aBuilding.top;
}


void updatePolice() {
  //elke politie word gecheckt
  for (int i = policeMan.size() - 1; i >= 0; i--) {
    policeMan police = policeMan.get(i);
    police.bulletReloadTimer++;

    //checkt of de agent collision heeft met een object en plaat hem er bovenop
    for (int k = object.size() - 1; k >= 0; k--) {
      object objecten = object.get(k);

      //checkt voor collision en plaats hem er boven
      if (police.x + police.sizeX > objecten.objX && police.x < objecten.objX + imageObject[objecten.randomObj].width + 50 && objecten.objY < height) {
        police.y = objecten.objY - imageObject[objecten.randomObj].height; 
        if (police.x > width)
          police.x = random(objecten.objX, objecten.objX + imageObject[objecten.randomObj].width - police.sizeX - 10);
        break;
      } else {
        police.y = police.yOnBuilding;
      }
    }

    //als de politie de speler kan zien en hij gereload heeft kan hij een nieuwe bullet spawnen
    if (police.lineOfSight()) {
      if (police.bulletReloadTimer/60 >= police.BULLET_TIME) {
        bullet.add(new Bullet());
        particles.add(new particle(color(255, 0, 0), color(200, 200, 0), 30, -3, -1, police.x, police.y - police.sizeY / 1.2, 1));
        setupBullet(police.x, police.y - police.sizeY / 1.2, (police.y - player.Y) / (police.x - player.X));
        police.bulletReloadTimer = 0;
        enemy_shoot.play();
      }
    }

    //checkt of de boemerang de politie raakt
    if (boemerang.X + boemerang.radius > police.x 
      && boemerang.X - boemerang.radius < police.x + police.sizeX 
      && boemerang.Y + boemerang.radius > police.y - police.sizeY
      && boemerang.Y - boemerang.radius < police.y
      &&!(boemerang.X <= player.X + player.sizeX)) {
      score += 50;
      hit_enemy.play();

      //score particle
      particles.add(new particle(color(0, 255, 0), color(0, 50, 0), 40, 4, -2, police.x + police.sizeX, police.y - police.sizeY, 0));

      texts.add(new texts());
      texts text = texts.get(texts.size() - 1);
      text.text = "+50 SCORE";
      text.colorGreen = 255;
      text.colorRed = 0;
      text.y -= texts.size() * player.sizeY;

      boemerang.speedX = -player.vx; //snelheid omdraaien
      boemerang.comebackSpeed = boemerang.COMEBACK_SPEED_INCREASE; //de snelheid stijgt
      policeMan.remove(i);
    }
    //checkt of de politie door de speler word geraakt
    else if (player.X < police.x + police.sizeX
      && player.X + player.sizeX > police.x
      && player.Y > police.y - police.sizeY
      && player.Y - player.sizeY < police.y) {

      //als de speler op het hoofd springt krijgt hij punten
      if (player.Y > police.y - police.sizeY && player.Y < police.y - police.sizeY + 20 && player.X + player.sizeX / 2 > police.x ) {
        score += 50;
        hit_enemy.play();

        //score particle
        particles.add(new particle(color(0, 255, 0), color(0, 50, 0), 40, 4, -2, police.x + police.sizeX, police.y - police.sizeY, 0));

        texts.add(new texts());
        texts text = texts.get(texts.size() - 1);
        text.text = "+50 SCORE";
        text.colorGreen = 255;
        text.colorRed = 0;
        text.y -= texts.size() * player.sizeY;
      } else {
        lives--;
        score -= 25;

        get_hit.play();
        isHit = true;

        //blood particle en white particle
        particles.add(new particle(color(255, 0, 0), color(150, 0, 0), 20, -2, 2, player.X + player.sizeX, player.Y - player.sizeY, 1));
        particles.add(new particle(color(255), color(0), 40, 4, -2, police.x + police.sizeX, police.y - police.sizeY, 0));

        texts.add(new texts());
        texts text1 = texts.get(texts.size() - 1);
        text1.text = "-1 LIFE";
        text1.colorGreen = 0;
        text1.colorRed = 255;
        text1.y -= texts.size() * player.sizeY;

        texts.add(new texts());
        texts text2 = texts.get(texts.size() - 1);
        text2.text = "-25 SCORE";
        text2.colorGreen = 0;
        text2.colorRed = 255;
        text2.y -= texts.size() * player.sizeY;
      }
      policeMan.remove(i);
    }
  }
}

void drawPolice() {
  updatePolice();

  rectMode(CORNER);  

  //als er op een gebouw nog geen politie agent staat word hij toegevoegd aan de array
  for (Building building : building) {
    if (!building.enemyOn) {
      if (building.left > width) {
        policeMan.add(new policeMan());
        initPolice(policeMan.size() - 1, building);
        building.enemyOn = true;
      }
    }
  }

  //als de politie agent buiten het scherm is word hij verwijdert
  for (int i = policeMan.size() - 1; i >= 0; i--) {
    policeMan police = policeMan.get(i);
    if (police.x < -100) {
      policeMan.remove(i);
    }

    police.x -= player.vx;
    tint(255, 255);
    fill(255);
    image(politie, police.x, police.y - police.sizeY, police.sizeX, police.sizeY);
  }
}



//_____________________________________________________________________________________________________
//oude code voor generation \/ \/ \/ \/ \/ \/ \/ \/ \/

/*
void initPolice(int i, Building aBuilding) {
 for (int j = 0; j < nBuildings; j++) {
 Building aBuilding = building[j];
 policeMan curPolice = policeMan.get(i);
 
 if (aBuilding.left > width) {
 if (aBuilding.enemyOn) {
 int nextBuilding;
 
 
 if (j==nBuildings - 1) {
 nextBuilding = 0;
 } else {
 nextBuilding = j+1;
 }
 
 Building nBuilding = building[nextBuilding];
 if (nBuilding.left > width) {
 curPolice.x = random(nBuilding.left + 100, nBuilding.right - curPolice.sizeX);
 curPolice.y = nBuilding.top;
 
 curPolice.yOnBuilding = nBuilding.top;
 nBuilding.enemyOn = true;
 }
 } else {
 curPolice.x = random(aBuilding.left + 100, aBuilding.right - curPolice.sizeX);
 curPolice.y = aBuilding.top;
 
 curPolice.yOnBuilding = aBuilding.top;
 aBuilding.enemyOn = true;
 }
 break;
 }
 }
 }
 */


/*
  for (int i = amountPolice - 1; i >= 0; i--) {
 if (amountPolice > policeMan.size()) {
 policeMan.add(new policeMan());
 initPolice(policeMan.size() - 1);
 }
 }*/