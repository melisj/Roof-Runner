SoundFile game_over;

void gameOver() {
  //drawt het gameoverscherm
  noStroke();
  fill(0, 0, 0, 8);
  rect(0, 0, width, height);
  fill(255);
  textSize(100);
  textAlign(CENTER);
  text("Game Over! \n\n", width/2, height/3);
  textSize(48);
  text("Score: " + (int)score + "\n\n"+ "Press 'R' to restart", width/2, height/2);
  

  //reset het level
  if (buttonPressed['r'] || buttonPressed['R']) { //reset
    if (powerup.active) {
      counterPowerup = 20 * 60;
    }
    highscores.add((int)score);
    backgroundMusic.stop();
    state = 1;
    setup();
    powerup.x = 0;
    
  }
}