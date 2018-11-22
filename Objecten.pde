PImage airUnit;
PImage dumpster;
PImage schoorsteen;
PImage ventilatiebuis;
PImage dakuitgang;
PImage billboardside;
PImage billboardfront;
PImage billboardTutorial;
PImage watertoren;

int differentObj = 9; //hoeveelheid verschillende objecten
PImage[] imageObject = new PImage[differentObj];

ArrayList<object> object = new ArrayList<object>();

class object {
  float objY = -100; 
  float objX = -1000; 
  float objSizeX = 0;
  float objSizeY = 0;

  int randomObj = (int)random(0, differentObj);
}

//laad alle images en stopt ze in een array
void initObj() {
  airUnit = loadImage("airUnit.png");
  airUnit.resize(80, 40);
  dumpster = loadImage("dumpster.png");
  schoorsteen = loadImage("schoorsteen.png");
  ventilatiebuis = loadImage("ventilatiebuis.png");
  dakuitgang = loadImage("dakuitgangbrick.png");
  billboardside = loadImage("billboard.png");
  billboardfront = loadImage("billboardfront.png");
  billboardTutorial = loadImage("billboardTutorial.png");
  watertoren = loadImage("watertoren.png");


  //alles voorbij de index 5 is een object waar je onder moet bukken
  imageObject[0] = airUnit;
  imageObject[1] = dumpster;
  imageObject[2] = schoorsteen;
  imageObject[3] = ventilatiebuis;
  imageObject[4] = dakuitgang;
  imageObject[5] = billboardside;
  imageObject[6] = billboardfront;
  imageObject[7] = watertoren;
  imageObject[8] = billboardTutorial;
}


//objecten krijgen een waarde gebaseerd op welk gebouw er is geselecteerd
void setupObj(int i, Building aBuilding) {
  object curObject = object.get(i);

  curObject.objX = random(aBuilding.left + 150, aBuilding.right - imageObject[curObject.randomObj].width - 100);
  curObject.objY = aBuilding.top;
}


void updateObj() {
  //als een object collide met een ander object word het gerest door het uit het scherm te plaatsen
  for (int i = object.size() - 1; i >= 0; i--) {
    object curObject = object.get(i);   
    for (int j = object.size() - 1; j >= 0; j--) {
      object objecten = object.get(j);
      if (curObject.objX + imageObject[curObject.randomObj].width > objecten.objX 
        && curObject.objX <= objecten.objX + imageObject[curObject.randomObj].width
        && i != j) {
        objecten.objY = 2000;
        objecten.objX = -2000;
      }
      //als je onder het object moet bukken moet de marge van objecten eromheen iets groter zijn zodat je de tijd hebt om te bukken
      if (curObject.randomObj >= 5) {
        if (curObject.objX + imageObject[curObject.randomObj].width + 100 > objecten.objX 
          && curObject.objX - 100 <= objecten.objX + imageObject[objecten.randomObj].width
          && i != j) {
          objecten.objY = 2000;
          objecten.objX = -2000;
        }
      }
    }
  }
}

void drawObj() {
  updateObj();

  for (Building building : building) {
    //objecten kunnen alleen geplaats worden als het gebouw buiten het scherm is
    if (building.left > width) {
      //als er nog plek is op een gebouw om een object te plaatsen word er een object gemaakt
      while (building.objOnBuilding <= building.objMaxPerBuilding) {
        object.add(new object());
        building.objOnBuilding++;
        setupObj(object.size() - 1, building);
      }
    }
  }
  
  //als een object buiten het scherm valt word het vewijdert
  for (int i = object.size() - 1; i >= 0; i--) {
    object objecten = object.get(i);
    if (objecten.objX < -imageObject[objecten.randomObj].width) {
      object.remove(i);
    }

    objecten.objX -= player.vx;
    tint(255, 255);
    image(imageObject[objecten.randomObj], objecten.objX, objecten.objY - imageObject[objecten.randomObj].height);
  }
}


//_____________________________________________________________________________________________________
//oude code voor generation \/ \/ \/ \/ \/ \/ \/ \/ \/

/*
for (int j = 0; j < nBuildings; j++) {
 Building aBuilding = building[j];
 object curObject = object.get(i);
 curObject.objX = -2000;
 curObject.randomObj = (int)random(0, differentObj);
 
 if (aBuilding.left > width) {
 curObject.objX = random(aBuilding.left + 150, aBuilding.right - imageObject[curObject.randomObj].wiject.objY = aBuilding.top;
 
 if (curObject.objX >= aBuilding.left && curObject.objX + imageObject[curObject.randomObj].width <= aBuilding.right)
 aBuilding.objOnBuilding++;
 
 while (aBuilding.objOnBuilding >= aBuilding.objMaxPerBuilding) {
 int nextBuilding;
 
 if (j == nBuildings - 1) {
 nextBuilding = 0;
 } else {
 nextBuilding = j+1;
 }
 
 Building nBuilding = building[nextBuilding];
 if (nBuilding.left > width) {
 curObject.objX = random(nBuilding.left + 150, nBuilding.right - imageObject[curObject.randomObj].width - 100);
 curObject.objY = nBuilding.top;
 aBuilding.objOnBuilding--;
 nBuilding.objOnBuilding++;
 break;
 } else {
 curObject.objX = -2000;
 aBuilding.objOnBuilding--;
 }
 }
 break;
 }
 }*/