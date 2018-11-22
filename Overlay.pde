PImage heart;

float opacityPowerupName = 255; //opacity van de QUOTES text als je een powerup pakt

//array om texten toe te voegen die worden gemaakt door de acties van de speler
ArrayList<texts> texts = new ArrayList<texts>();
//je kan een text aanmaken door een text toe te voegen aan de array
//hierbij moet de kleur van groen en rood aangegeven worden en text zelf moet worden ingevoerd

class texts {
  float x = player.X;
  float y = player.Y - player.sizeY;
  float speed = 4;//snelheid waarmee de text omhoog gaat
  float opacitySpeed = 5;//hoesnel een text fade
  float opacity = 200; 
  float colorGreen;
  float colorRed;

  String text;
}

//laad de plaatjes
public void initOverlay() {

  heart = loadImage("heart.png");
  heart.resize(50, 50);
}

public void drawOverlay() {

  textAlign(LEFT);

  fill(255);

  //alle texten in de array worden gedrawt
  for (int i = texts.size() - 1; i >= 0; i--) {
    texts text = texts.get(i);

    text.opacity -= text.opacitySpeed;

    text.y -= text.speed;

    fill(text.colorRed, text.colorGreen, 0, text.opacity);
    text(text.text, text.x, text.y);

    if (text.opacity <= 0) {
      texts.remove(i);
    }
  }

  fill(255);

  textFont(font, 32);
  text("Lives: ", 10, 50);

  //alle levens worden achterelkaar gedrawt
  for (int i = 0; i < lives; i++) {
    image(heart, i * 70 + 180, 12);
  }

  text("Score: " + (int)score, width - 320, 50);

  //als er een powerup actief is word er een balk gedrawt met de duur van de powerup en met de naam van powerup
  if (powerup.active) {

    textFont(font, 50);
    opacityPowerupName -= 2;
    textAlign(CENTER);     
    fill(0, 255, 0, opacityPowerupName);
    text(powerup.quote, width/2, 300);

    textFont(font, 32);
    textAlign(LEFT);
    fill(255);
    text("Powerup: " + powerup.name, 10, 100);


    //lege witte balk
    noStroke();
    fill(255);
    rect(10, 120, POWERUP_TIME_LENGTH * 25, 20);

    //tijd die je nog over hebt is een rode balk
    fill(255, 0, 0);
    rect(10, 120, counterPowerup / 60 * 25, 20);
  } else {
    opacityPowerupName = 200;
  }
  
  //text((int)frameRate, width/2-40, 50);
}