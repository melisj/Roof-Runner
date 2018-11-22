public void drawPause(){
  //Variables for buttons
  float buttonWidth = 350;
  float buttonHeight = 120;
  float buttonX = width/2;
  float[] buttonShade = {0,0,0,0};
  float[] buttonY = {height / 5 * 1,height / 5 * 2, height / 5 * 3, height / 5 * 4};

  //Variables for text
  float textX = width/2;
  float textSize = 40;
  float[] textY = {height / 5 * 1 + textSize/2,
                   height / 5 * 2 + textSize/2,
                   height / 5 * 3 + textSize/2,
                   height / 5 * 4 + textSize/2};
  String[] text = {"Resume","HighScore","Settings","Quit"};
  
  noStroke();
  rectMode(CORNER);
  fill(50,50,50,5);
  rect(0,0, 1920, 1080);
  image(pauseBG, 0, 0);
  rectMode(CENTER);
  textSize(textSize);
  textAlign(CENTER);
  
  //Draws the buttons
  for(int i = 0; i<4; i++){
    
    //Button selected
    if (buttonSelectedPause == i) {
      buttonShade[i] = 50;
      //Button clicked
      if ((key == 'z' || key == 'Z') && keyPressed){
         statePrev = 2;
         delay(200);
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
          case 3:
            state = 0;
            //Reset here
            backgroundMusic.stop();
            setup();
            break;
         }
      }
    } else {
      buttonShade[i] = 0;
    }
    fill(buttonShade[i]);
    stroke(255,0,0);
    strokeWeight(2);
    rect(buttonX, buttonY[i], buttonWidth, buttonHeight);
    fill(255);
    text(text[i], textX, textY[i]);
    }
  } 