public void drawMenu(){
  //Variables for buttons
  float buttonWidth = 350;
  float buttonHeight = 120;
  float buttonX = width/2;
  float[] buttonShade = {0,0,0};
  float[] buttonY = {height * 0.25,height * 0.5, height * 0.75};

  //Variables for text
  float textX = width/2;
  float textSize = 40;
  float[] textY = {height * 0.25 + textSize/2,
                   height * 0.5 + textSize/2,
                   height * 0.75 + textSize/2};
  String[] text = {"Start","HighScore","Settings"};
  
  textFont(font, 32);
  image(menuBG,0,0);
  rectMode(CENTER);
  textSize(textSize);
  textAlign(CENTER);
  
  //Draws the buttons
  for(int i = 0; i<3; i++){
    
    //Button selected
    if (buttonSelectedMenu == i) {
      buttonShade[i] = 100;
      //Button clicked
      if ((key == 'z' || key == 'Z') && keyPressed){
         statePrev = 0;
         //delay(200);
         switch(i){
          case 0:
            state = 1;
            break;
          case 1:
            state = 3;
            break;
          case 2:
            state = 4;
            break;
         }
      }
    } else {
      buttonShade[i] = 0;
    }
    fill(buttonShade[i]);
    strokeWeight(3);
    stroke(255,0,0);
    rect(buttonX, buttonY[i], buttonWidth, buttonHeight);
    fill(255);
    text(text[i], textX, textY[i]);    
    text("Use the arrow keys to jump and duck \n Use 'Z' to select and shoot \n Use 'P' to pause and 'R' to restart",textX, height - 120);
  } 
}