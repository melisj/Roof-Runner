public void drawSettings() {
  //Text variables
  float textX = width/2;
  float textSize = 40;

  background(122, 123, 0);
  textSize(textSize);
  textAlign(CENTER);


  text("Choose Charachter \n\n\n\n Buy the full game to unlock \n\n $29,99", textX, height/3 + textSize/2);

  //going back
  text("Press 'X' to go back", textX, height - textSize/2);
  if (key == 'x' && keyPressed) {
    state = statePrev;
  }
}