int nDruppels = 60; // number of drops on the screen
int z = 255; // voor de druppel

class Druppel {  
  float x = random(width + 200);
  float y = -300;
  float vy = random(5, 20);
  float vx = random(1, 2.5);
  float rx = random(0.1, 4);
  float ry = random(10, 25);
}
Druppel []druppel = new Druppel[nDruppels];
void druppels() {
  for (int i = 0; i<nDruppels; i++) {
    Druppel aDruppel = druppel[i];
    if ( aDruppel.y + aDruppel.vy > height) {
      aDruppel.y -= height;
      aDruppel.x = random(width+100);
      aDruppel.rx = random(0.1, 4);
      aDruppel.ry = random(10, 25);
    }
    if (aDruppel.y > height) {
      z = 0;
    } else { 
      z = 100;
    }

    aDruppel.y+=aDruppel.vy;
    aDruppel.x-=aDruppel.vx;
    stroke(#77D4F0, z);
    strokeWeight(0);
    fill(#77D4F0, z);//colour
    rect(aDruppel.x, aDruppel.y, aDruppel.rx, aDruppel.ry, 255);
    noStroke();
  }
}