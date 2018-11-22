dayNight dayNight = new dayNight();

//houdt informatie van de gebouwen op de achtergrond bij
float backgroundX = 0; 
float backgroundOpacity = 0; //voor de nacht achtergrond


class dayNight {
  PImage sun;
  PImage moon;
  PImage stars;

  float cycleX; //hoe ver de zon op de X as is
  float cycleY;

  boolean day = true;

  color currentColor;
  final color DAY_LIGHT = color(64, 142, 234);
  final color MOON_LIGHT = color(40, 40, 120);
  final color SUNSET_LIGHT = color(216, 149, 39);

  final color RAINING_BG_DAY = color(80, 80, 120);
  final color RAINING_BG_NIGHT = color(45, 57, 57);
  final color THUNDER_BG_DAY = color(64, 79, 93);
  final color THUNDER_BG_NIGHT = color(32, 40, 46);

  //reset waardes
  void init() {
    sun = loadImage("sun.png");
    sun.resize(180, 180);
    moon = loadImage("moon.png");
    stars = loadImage("star background.png");
    stars.resize(width, height);

    currentColor = color(64, 142, 234);
    day = true;
    cycleX = 1200;
  }


  void update() {

    cycleX += 10.5; //snelheid van de zon/maan 
    if (cycleX >= width + sun.width * 2) { //als de zon/maan onder is verandert de plaats
      cycleX = -150;
      day = !day; //maak dag niet dag
    }

    cycleY = (height/2) - (height/3) * sin(((2 * PI) / (width * 4)) * cycleX - (width / 3)); //berekening om cirkel beweging te krijgen
  }


  void draw() {
    update();
    noStroke();


    //Deze if statements kijken welke kleur de achtergrond moet hebben gebaseerd op de omstandigheden
    if (day) {
      if (clouds.size() >= 60 && raining) {
        currentColor = lerpColor(currentColor, RAINING_BG_DAY, 0.05);
      } else if (clouds.size() >= 120 && thunder) {
        currentColor = lerpColor(currentColor, THUNDER_BG_DAY, 0.05);
      } else {
        currentColor = lerpColor(currentColor, DAY_LIGHT, 0.05);
      }
    } else {
      if (clouds.size() >= 60 && raining) {
        currentColor = lerpColor(currentColor, RAINING_BG_NIGHT, 0.05);
      } else if (clouds.size() >= 120 && thunder) {
        currentColor = lerpColor(currentColor, THUNDER_BG_NIGHT, 0.05);
      } else {
        currentColor = lerpColor(currentColor, MOON_LIGHT, 0.05);
      }
    }

    //als de zon uit het scherm is verandert de kleur naar oranje 
    if (cycleX >= width && cycleX <= width + sun.width * 2) {
      currentColor = lerpColor(currentColor, SUNSET_LIGHT, 0.05);
    } 


     background(currentColor); //verandert background

    //als het dag is word de zon gedrawt anders de maan
    if (!thunder) {
      if (day) {
        tint(255);
        image(sun, cycleX  - sun.height / 2, cycleY - sun.height /2); //draw zon
      } else {
        //als de maan voorbij een bepaald punt is verandert de doorzichtigheid van de sterren
        if (cycleX >= width - 50) {
          tint(255, 150 - (cycleX - width + 100));
        } else if ((cycleX <= width + 150)) {
          tint(255, cycleX);
        }

        image(stars, 0, 0); //draw sterren
        tint(255);
        image(moon, cycleX  - moon.width / 2, cycleY - moon.height /2); //draw maan
      }
    }

    //houdt de achtergrond opacity van de nacht achtergrond bij
    if (day && backgroundOpacity >= 0) {
      backgroundOpacity--;
    } else if(!day && backgroundOpacity <= 255){
      backgroundOpacity++;
    }

    //alle gebouwen worden gedrawt
    image(background, backgroundX, 0);
    image(background, backgroundX + background.width, 0);
    tint(255, 255, 255, backgroundOpacity);
    image(backgroundNight, backgroundX, 0);
    image(backgroundNight, backgroundX + background.width, 0);
    tint(255);

    //achtergrond word gereset als het bij dezelfde waarde komt van het begin van de texteture voor een naadloose overgang
    if (backgroundX <= -background.width) {
      backgroundX = 0;
    }
    backgroundX -= player.vx / 5.5;
  }
}