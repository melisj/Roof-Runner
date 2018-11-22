//Sets up highscore database
ArrayList<Integer> highscores = new ArrayList((int)score);

public void drawHighscore() {
  //Text variables
  float textX = width/2;
  float textSize = 40;
  float textY = 50;
  int textSizeY = 70;

  background(0, 123, 122);
  textSize(textSize);
  textAlign(CENTER);   

  //if there are no highscores
  if (highscores.size() == 0) {
    text("No Highscores", textX, height/2 + textSize/2);
  }
  //drawing the highscores 
  for (int i = 0; i < ((highscores.size() < 10) ? highscores.size() : 10); i++) {
    text(highscores.get(i), textX, textY+i*textSizeY);
  }

  //going back
  text("Press 'X' to go back", textX, height - textSize/2);
  if ((key == 'x' || key == 'X') && keyPressed) {
    state = statePrev;
  }
}