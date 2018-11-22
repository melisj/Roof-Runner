PImage lightning;

ArrayList<cloud> clouds = new ArrayList<cloud>();
ArrayList<puddle> puddles = new ArrayList<puddle>();

int amountClouds = 10;//normaal zijn er 10 wolken
boolean raining = false;
boolean thunder = false;



float cloudSpawnCounter = 0;
final float CLOUD_SPAWN_TIME = 0.1;
float thunderCounter = 0;
float thunderTime = random(5, 8);//tijd tot volgende bliksemslag

int randomWeather = (int)random(0, 2); //kan het laten regenen of onweren


class cloud {
  float speed = -random(1, 2);
  float x = width + 100;
  float y = random(0, 300);
  
  final color WHITE_CLOUD = color(200, 220);
  final color RAIN_CLOUD = color(80, 250);
  final color THUNDER_CLOUD = color(20, 255);

  color cColor = WHITE_CLOUD;
}

class puddle {
  float startX = 0, 
    endX = 0, 
    Y = 0, 
    initialY; //een object kan verdwijnen dus moet hij terug geplaats worden op het gebouw
}

//plaats een puddle op het bijbehoorende gebouw
public void puddleInit(int i, Building building) {
  puddle puddle = puddles.get(i);

  puddle.startX = random(building.left + 150, building.right - 200);
  puddle.endX = random(puddle.startX + 100, (building.right - 100 > puddle.startX + 150) ? puddle.startX + 150 : building.right - 100);
  puddle.Y = building.top;
  puddle.initialY = puddle.Y;
}

public void puddles() {  

  //als er meer dan 60 wolken zijn en horen te zijn plaats hij er zoveel puddles op het gebouw totdat het max per gebouw is berijkt
  if (clouds.size() >= 60 && amountClouds >= 60) { //als er 60 wolken zijn gaat het regenen
    for (Building building : building) {
      if (building.left > width) {
        while (building.puddleOnBuilding <= building.puddleMaxBuilding) {
          puddles.add(new puddle());
          building.puddleOnBuilding++;
          puddleInit(puddles.size() - 1, building);
        }
      }
    }
  }

  // checkt per puddle of er overlap is met andere puddles en objecten
  for (int i = puddles.size() - 1; i >= 0; i--) {
    puddle curPuddle = puddles.get(i); //puddle die gecheckt word
    for (int j = puddles.size() - 1; j >= 0; j--) {
      puddle puddle = puddles.get(j);
      //checkt of de puddle buiten het scherm is
      if (i != j && curPuddle.startX > width) {
        float overlapX;
        overlapX = collision1Axis(curPuddle.startX, puddle.startX - 50, curPuddle.endX - curPuddle.startX, puddle.endX - puddle.startX + 50);
        if (overlapX != 0) {
          //plaats de puddle onder het scherm
          puddle.Y = -2000;
        }
      }
    }
    
    float overlapX = 0;
    for (int j = object.size() - 1; j >= 0; j--) {
      object objecten = object.get(j);
      
      overlapX += collision1Axis(curPuddle.startX, objecten.objX - 50, curPuddle.endX - curPuddle.startX, imageObject[objecten.randomObj].width + 100);

      //plaats bij collision met een obeject op het object
      if (overlapX != 0 && curPuddle.startX > width) {
        curPuddle.Y = objecten.objY - imageObject[objecten.randomObj].height;
        curPuddle.startX = objecten.objX;
        curPuddle.endX = objecten.objX + imageObject[objecten.randomObj].width;
      }
      
      //reset puddle naar orginele plek als het object is verdwenen
      if (overlapX == 0 && curPuddle.initialY != curPuddle.Y && curPuddle.startX > width) {
        curPuddle.Y = curPuddle.initialY;
      }
    }
  }

  //elke puddle word gedrawt
  for (int i = puddles.size() - 1; i >= 0; i--) {
    puddle curPuddle = puddles.get(i);

    curPuddle.startX -= player.vx;
    curPuddle.endX -= player.vx;

    if (curPuddle.endX <= 0) {
      puddles.remove(i);
      break;
    }
    stroke(0, 0, 255);
    strokeWeight(5);
    line(curPuddle.startX, curPuddle.Y, curPuddle.endX, curPuddle.Y);
    noStroke();
  }
}


public void clouds() {
  cloudSpawnCounter++;

  //check of de score deelbaar 1000 is en niet deelbaar door 2000 want dan stopt de regen
  if (score % 1000 >= 0 && score % 1000 <= 50 && !(score % 2000 >= 0 && score % 2000 <= 50)) {
    if (randomWeather == 0) {
      raining = true;
    } else {
      thunder = true;
    }
  } else if (score % 2000 >= 0 && score % 2000 <= 50) {
    randomWeather = (int)random(0, 2);
    raining = false;
    thunder = false;
  }

  //als het regent of onweert komen er meer wolken
  if (raining || thunder) {
    amountClouds++;
  }

  //check elke wolk
  for (cloud Cloud : clouds) {
    //als er 60 wolken zijn verandert de kleur
    if (amountClouds >= 60) {
      if (raining) //als het regent komen max 100 wolken
        amountClouds = 100;
      Cloud.cColor = lerpColor(Cloud.cColor, Cloud.RAIN_CLOUD, 0.01);
    } //als er 150 wolken zijn verandert de kleur
    if (amountClouds >= 150) {
      if (thunder) //als het regent komen max 150 wolken
        amountClouds = 150;
      Cloud.cColor = lerpColor(Cloud.cColor, Cloud.THUNDER_CLOUD, 0.01);
    }  
    //als het niet regent en niet onweert kunnen er max 10 wolken zijn
    if (!thunder && !raining) {
      amountClouds = 10;
      Cloud.cColor = lerpColor(Cloud.cColor, Cloud.WHITE_CLOUD, 0.01);
    }

    Cloud.x += Cloud.speed;
    tint(Cloud.cColor);
    image(cloud1, Cloud.x, Cloud.y); //draw cloud
  }

  thunderCounter++;
  
  //als er 120 wolken zijn en het onweert laat er dan bliksem om een X aantal seconden spawenen met een flits
  if (thunder && clouds.size() >= 120) {
    if (thunderCounter/60 >= thunderTime) {
      int x = (int)random(0, width - lightning.width);  
      int y = 0;
      tint(255);
      image(lightning, x, y);
      fill(255, 255, 255, 50);
      rect(0, 0, width, height);
      //reset de timer nadat er 1 seconde van onweer is geweest
      if (thunderCounter/60 % thunderTime >= 1)
        thunderCounter = 0;
        thunderTime = random(5, 8);
    }
  }


  //elke cloud word gecheckt of hij buiten het scherm is
  for (int i = clouds.size() - 1; i >= 0; i--) {
    cloud Cloud = clouds.get(i);
    if (Cloud.x <= -100) {
      clouds.remove(i);
    }
    if (amountClouds >= clouds.size() && cloudSpawnCounter / 60 >= CLOUD_SPAWN_TIME) {
      {
        clouds.add(new cloud());
        cloudSpawnCounter = 0;
        break;
      }
    }
  }
}


//_____________________________________________________________________________________________________
//oude code voor generation \/ \/ \/ \/ \/ \/ \/ \/ \/

/*
public void puddleInit(int i) {
 for (int j = 0; j < nBuildings; j++) {
 Building aBuilding = building[j];
 puddle puddle = puddles.get(i);
 
 if (aBuilding.left > width) {
 puddle.startX = random(aBuilding.left + 150, aBuilding.right - 200);
 puddle.endX = random(puddle.startX + 100, (aBuilding.right - 100 > puddle.startX + 150) ? puddle.startX + 150 : aBuilding.right - 100);
 puddle.Y = aBuilding.top;
 
 if (puddle.startX >= aBuilding.left && puddle.endX <= aBuilding.right)
 aBuilding.puddleOnBuilding++;
 
 while (aBuilding.puddleOnBuilding >= aBuilding.puddleMaxBuilding) {
 int nextBuilding;
 
 if (j == nBuildings - 1) {
 nextBuilding = 0;
 } else {
 nextBuilding = j++;
 }
 
 Building nBuilding = building[nextBuilding];
 if (nBuilding.left > width) {
 puddle.startX = random(nBuilding.left + 150, nBuilding.right - 200);
 puddle.endX = random(puddle.startX + 100, (nBuilding.right - 100 > puddle.startX + 150) ? puddle.startX + 150 : nBuilding.right - 100);
 puddle.Y = nBuilding.top;
 aBuilding.puddleOnBuilding--;
 nBuilding.puddleOnBuilding++;
 break;
 }
 }
 break;
 }
 }
 }*/