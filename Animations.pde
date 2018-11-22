// Spritesheet class to draw sprite animations
class SpriteSheet {

  // The image containing the frames and the image to draw
  PImage sourceImage, drawImage;
  float fps = 4;
  int frame = 0;
  int frameWidth;
  int frameHeight;
  int nFrames = 0;
  //int x, y;

  // Contructor takes name of source image and the amount of frames 
  SpriteSheet(String imageName, int nFrames, int fps) {
    sourceImage = loadImage(imageName);
    this.nFrames = nFrames;
    frameWidth = sourceImage.width/nFrames;
    frameHeight = sourceImage.height;
    drawImage = createImage(frameWidth, sourceImage.height, ARGB);
    this.fps = fps;
  }

  // update() selects the image to draw based on fps and frames already drawn
  void update() {
    if ((frameCount % fps) == 0)    
      frame =  (frame + 1) % nFrames;

    drawImage.copy(sourceImage, 
      frame*frameWidth, 0, frameWidth, sourceImage.height, 
      0, 0, frameWidth, sourceImage.height);    
  }

  // draw the target image
  void draw(float x, float y, float sizeX, float sizeY) {
    image(drawImage, x, y, sizeX, sizeY);
  }
}