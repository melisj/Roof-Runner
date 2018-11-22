PImage building_1;
PImage building_2;

int nBuildings = 4; //number of buildings on the screen
int amountBuildingTextures = 2;

Building []building = new Building[nBuildings];
PImage[] buildingTexture = new PImage[amountBuildingTextures];

public class Building {
  float w;
  float h;
  float x;
  float y;

  float top, bottom, left, right;


  int randomTexture = (int)random(0, amountBuildingTextures);
  
  //dit bepaald hoeveel van verschillende dingen er op een gebouw staan
  int objMaxPerBuilding = (int)random(4, 7);
  int objOnBuilding = 0;
  int puddleOnBuilding = 0;
  int puddleMaxBuilding = 4;
  boolean enemyOn = false;
  
}

public void buildingInit() {
  building_1 = loadImage("building-1.png");
  building_2 = loadImage("building-2.png");

  buildingTexture[0] = building_1;
  buildingTexture[1] = building_2;
}



public void buildings() {
  for (int i = 0; i<nBuildings; i++) {
    Building aBuilding = building[i];
    int prevBuilding;

    //if building rightEdge is out of 
    //screen move it to right edge again with random values
    if (i==0) {
      prevBuilding = nBuildings-1;
    } else {
      prevBuilding = i-1;
    }
    
    //als het gebouw buiten het scherm is reset het alle informatie
    if (aBuilding.right < 0) {
      aBuilding.objMaxPerBuilding = (int)random(4, 7);
      aBuilding.objOnBuilding = 0;
      aBuilding.puddleOnBuilding = 0;
      aBuilding.enemyOn = false;
      aBuilding.randomTexture = (int)random(0, amountBuildingTextures);

      aBuilding.w = random(1500, 2000);

      //plaats het gebouw achter het vorige gebouw
      if (width + aBuilding.w < building[prevBuilding].right + player.sizeX) {
        aBuilding.x = aBuilding.w/2 + building[prevBuilding].right + random(100, 200);
      } else if (width + aBuilding.w/2 > building[prevBuilding].right + 100) {
        aBuilding.x = aBuilding.w/2 + building[prevBuilding].right + random(100, 200);
      } else {
        aBuilding.x = width + aBuilding.w;
      }

      //nieuwe hoogte
      aBuilding.y = random(building[prevBuilding].y - 30, building[prevBuilding].y + 30);
    }

    //alle verschillede uiteinde van het gebouw worden berekend
    aBuilding.top = aBuilding.y - aBuilding.h/2;
    aBuilding.bottom = aBuilding.y + aBuilding.h/2;
    aBuilding.left = aBuilding.x - aBuilding.w/2;
    aBuilding.right = aBuilding.x + aBuilding.w/2;


    aBuilding.x -= player.vx; //moving building to the right

    tint(255);
    image(buildingTexture[aBuilding.randomTexture], aBuilding.left, aBuilding.top, aBuilding.w, 1000);
  }
}