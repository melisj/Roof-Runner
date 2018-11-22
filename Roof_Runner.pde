import processing.sound.*;
SoundFile backgroundMusic;

PImage cloud1;
PImage background;
PImage backgroundNight;
PFont font;
PImage shield;
PImage menuBG;
PImage pauseBG;


int state = 0; //The current state
int statePrev = 0; //Previous state
final int MAIN_MENU = 0;
final int GAME = 1;
final int PAUSE = 2;
final int HIGHSCORE = 3;
final int SETTINGS = 4;
final int GAMEOVER = 5;
int lives = 3;
int buttonSelectedMenu = 0;  
int buttonSelectedPause = 0;
float score = 0;

boolean buttonPressed[] = new boolean[1024];

//Methode neemt de waarde van twee objecten en berekend de afstand ertussen op een as
//dus om te kijken of een object in twee dimensies word geraakt moet de berekening voor twee assen gemaakt word.
float collision1Axis(float obj0, float obj1, float widthHeight0, float widthHeight1) { 
  float distanceLeft = obj0 + widthHeight0 - obj1; //berekend de afstand van elkaar met de linkerkanten
  float distanceRight = obj1 + widthHeight1 - obj0; //berekend de afstand van elkaar met de rechterkanten
  return (distanceLeft < 0 || distanceRight < 0) ? 0 : (distanceRight >= distanceLeft) ? -distanceLeft : distanceRight; //geef een waarde terug van hoeveel overlap er plaats vind
}

void setup() { 
  fullScreen(P2D);
  frameRate(60);

  backgroundMusic = new SoundFile(this, "FAST AF.mp3");
  backgroundMusic.amp(1);
  backgroundMusic.loop();

  catch_boomerang = new SoundFile(this, "catch.wav");
  catch_boomerang.amp(0.3);
  boomerang = new SoundFile(this, "boomerang.wav");
  boomerang.amp(0.2);
  jump = new SoundFile(this, "jump.wav");
  jump.amp(0.5);
  enemy_shoot = new SoundFile(this, "enemy_shoot.wav");
  enemy_shoot.amp(0.2);
  game_over = new SoundFile(this, "game_over.wav");
  game_over.amp(0.5);
  pickUp = new SoundFile(this, "powerup.wav");
  pickUp.amp(0.3);
  get_hit = new SoundFile(this, "get_hit.wav");
  get_hit.amp(0.3);
  heli_shoot = new SoundFile(this, "heli_shoot.wav");
  heli_shoot.amp(0.3);
  hit_enemy = new SoundFile(this, "hit_enemy.wav");
  hit_enemy.amp(0.7);
  hit_obj = new SoundFile(this, "hit_obj.wav");
  hit_obj.amp(0.3);

  boemerangSpriteSheet = new SpriteSheet("Boemerang 2.png", 4, 5);
  boemerangSpeedSpriteSheet = new SpriteSheet("Boemerang speed.png", 4, 5);
  bulletSpriteSheet = new SpriteSheet("Bullet cops.png", 7, 1);
  vangnetSpriteSheet = new SpriteSheet("vangnet.png", 2, 8);


  heliSpriteSheet = new SpriteSheet("heli_spritesheet.png", 6, 5 );

  lifePowerSpriteSheet = new SpriteSheet("heart_powerup.png", 2, 10);
  speedPowerSpriteSheet = new SpriteSheet("run_powerup.png", 2, 10);
  jumpPowerSpriteSheet = new SpriteSheet("jump_powerup.png", 2, 10);
  shieldPowerSpriteSheet = new SpriteSheet("shield_powerup.png", 2, 10);
  boemerangSpeedPowerSpriteSheet = new SpriteSheet("speed_powerup.png", 2, 10);

  playerSpriteSheet = new SpriteSheet("player.png", 6, 4);
  playerSlideSpriteSheet = new SpriteSheet("playerSlide.png", 3, 10);

  politie = loadImage("police.png");

  font = loadFont("Pixeled.vlw");
  cloud1 = loadImage("cloud1.png");
  background = loadImage("Background.png");
  backgroundNight = loadImage("Background night.png");
  shield = loadImage("shield.png");
  lightning = loadImage("lightning.png");
  shield.resize(100, 100);
  menuBG = loadImage("bg_menu.png");
  pauseBG = loadImage("pause_menu.png");

  initOverlay();
  buildingInit();

  lives = 3;

  for (int i = clouds.size() - 1; i >= 0; i--) {
    clouds.remove(i);
  }
  for (int i = 0; i < amountClouds; i++) {
    clouds.add(new cloud());
    cloud Cloud = clouds.get(i);
    Cloud.x = random(width);
  }
  initObj();
  dayNight.init();
  player.init();
  boemerang.init();
  score = 0;


  for (int i = 0; i<nBuildings; i++) {
    building[i] = new Building();

    building[i].y = random(width/2, width/2 + 50);
    building[i].h = random(700, 800);
    building[i].w = 1500;
    building[i].x =  1.1 * building[i].w * i - 200;
  }

  for (int i = object.size() - 1; i >= 0; i--) {
    object.remove(i);
  }

  for (int i = puddles.size() - 1; i >= 0; i--) {
    puddles.remove(i);
  }

  for (int i = policeMan.size() - 1; i >= 0; i--) {
    policeMan.remove(i);
  }

  for (int i = bullet.size() - 1; i >= 0; i--) {
    bullet.remove(i);
  }

  for (int i = bullet2.size() - 1; i >= 0; i--) {
    bullet2.remove(i);
  }  

  for (int i = particles.size() - 1; i >= 0; i--) {
    particles.remove(i);
  }

  for (int j = 0; j<nDruppels; j++) {
    druppel[j] = new Druppel();
  }
  
  
  raining = false;
  thunder = false;
  randomWeather = (int)random(0, 2);
}

void draw() {
  switch(state) {
  case MAIN_MENU:
    drawMenu();
    break;
  case GAME:
    //main game here

    dayNight.draw();

    if (clouds.size() >= 60 && amountClouds >= 60) { //als er 60 wolken zijn gaat het regenen
      druppels();
    }
    clouds();
    puddles();

    if (buttonPressed['p'] || buttonPressed['P'] && state == 1) { //pauzeer het spel
      state = 2;
    }


    drawPowerup();
    rectMode(CENTER);
    buildings();


    player.draw();
    boemerang.draw();

    drawPolice();
    drawBullets();
    drawBullets2();

    Helicopter.draw();
    drawObj();


    if (lives <= 0) { //als je 0 levens hebt komt het gameover scherm
      game_over.play();
      state = 5;
    }

    //alle particlessystems worden getekend
    for (int i = particles.size() - 1; i >= 0; i--) {
      particle particle = particles.get(i);

      particle.update();
      particle.draw();
      if (particle.opacity <= 0) {
        particles.remove(i);
        continue;
      }
    }

    fill(250, 0, 0, 255);
    drawOverlay();
    screenshake();
    break;
  case PAUSE:
    drawPause();
    break;
  case HIGHSCORE:
    drawHighscore();
    break;
  case SETTINGS:
    drawSettings();
    break;
  case GAMEOVER:
    gameOver();
    break;
  }

  noCursor();
}


void keyPressed() {
  buttonPressed[keyCode] = true;

  //Pause
  if ((key == 'p' || key == 'P') && state == 1) {
    state = 2;
  } 
  if (keyCode == DOWN) {
    //Menu
    if (state == 0) {
      buttonSelectedMenu++;
      if (buttonSelectedMenu == 3)
        buttonSelectedMenu = 0;
    }
    //Pause
    if (state == 2) {
      buttonSelectedPause++;
      if (buttonSelectedPause == 4)
        buttonSelectedPause = 0;
    }
  } 
  if (keyCode == UP) {
    //Menu
    if (state == 0) {
      buttonSelectedMenu--;
      if (buttonSelectedMenu == -1)
        buttonSelectedMenu = 2;
    }
    //Pause
    if (state == 2) {
      buttonSelectedPause--;
      if (buttonSelectedPause == -1)
        buttonSelectedPause = 3;
    }
  }

  //als 'z' is ingedrukt en de boemerang is bij de speler schiet hij
  if (buttonPressed['z'] || buttonPressed['Z'] && !player.forcedSliding) { //schieten
    if (boemerang.X == player.X + player.sizeX / 2 ) { //checkt of de player rechtop staat en de boemerang bij de player is
      boemerang.X = player.X + player.sizeX;
      boemerang.speedX = boemerang.beginSpeed; //verander speed naar de begin snelheid
      boemerang.comebackSpeed = boemerang.COMEBACK_SPEED_DECREASE; // de boemerang
      boomerang.play();
      boemerang.alreadyPlayed = false;
    }
  }
}
public void keyReleased() {
  buttonPressed[keyCode] = false;
}