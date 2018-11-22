ArrayList<particle> particles = new ArrayList<particle>();
//particle system kan aangemaakt worden door een nieuwe particle toe te voegen aan de array
//hierbij vul je de benodigde informatie in de constuctor

class particle {
  float[] x, 
    y, 
    vx, 
    vy, 
    sizeX, 
    sizeY;

  float
    startX, 
    startY, 
    effect;//effect bepaalt of er vierkantjes of circels worden gedrawt

  final float GRAVITY = random(0.05, 0.1);
  final int RECT_EFFECT = 0;
  final int ELLIPSE_EFFECT = 1;

  int amount, 
    opacity = 255;
    
  color parColor,//dit is waar de kleur in word aangepast 
    beginColor, 
    endColor;

  //constuctor om een particle systeem te maken
  particle(color beginColor, color endColor, int amount, float speedX, float speedY, float startX, float startY, float effect) {
    this.beginColor = beginColor;
    parColor = beginColor;
    this.endColor = endColor;
    this.amount = amount;
    this.startX = startX;
    this.startY = startY;
    this.effect = effect;
    x = new float[amount];
    y = new float[amount];
    vx = new float[amount];
    vy = new float[amount];
    sizeX = new float[amount];
    sizeY = new float[amount];

    //geeft alle particles een waarde
    for (int i = 0; i < amount; i++) {
      vx[i] = random((speedX >= 0) ? 0 : speedX, (speedX >= 0) ? speedX : 0); //als de speed negatief is komt hij aan de linkerkant te staan en anders rechts
      vy[i] = random((speedY >= 0) ? 0 : speedY, (speedY >= 0) ? speedY : 0);
      x[i] = startX;
      y[i] = startY;
      sizeX[i] = 10;
      sizeY[i] = 10;
    }
  }


  void update() {
    //alle particles worden aangepast
    for (int i = 0; i < amount; i++) {
      vy[i] += GRAVITY;
      x[i] += vx[i] - player.vx;//speed van de particles is altijd min de snelheid van de speler
      y[i] += vy[i];
      sizeX[i] -= 0.2;
      sizeY[i] -= 0.2;
    }
    opacity -= 5; //doorzichtigheid van de particles
    parColor = lerpColor(parColor, endColor, 0.025); //verander de kleur elke frame steeds een beetje naar de eindkleur
  }

  void draw() {
    //drawt alle particles
    for (int i = 0; i < amount; i++) {
      noStroke();
      fill(parColor, opacity);
      if (effect == RECT_EFFECT) {
        rect(x[i], y[i], sizeX[i], sizeY[i]);
      } else {
        ellipse(x[i], y[i], sizeX[i], sizeY[i]);
      }
    }
  }
}