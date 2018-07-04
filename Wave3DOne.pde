/**
 * 
 * PixelFlow | Copyright (C) 2017 Thomas Diewald - www.thomasdiewald.com
 * 
 * https://github.com/diwi/PixelFlow.git
 * 
 * A Processing/Java library for high performance GPU-Computing.
 * MIT License: https://opensource.org/licenses/MIT
 * 
 */


// PIXELFLOW'S
import com.thomasdiewald.pixelflow.java.DwPixelFlow;
import com.thomasdiewald.pixelflow.java.imageprocessing.DwShadertoy;

// MICROPHONE
import ddf.minim.*;

// Import Minim and create the object
Minim minim;
AudioInput in;
  
DwPixelFlow context;
DwShadertoy toy, toyA, toyB;

// Initialize the microphone's fft's
float wav = 0.0;
float fre = 0.0;
  
public void settings() {
  size(800, 450, P2D);
  smooth(0);
}

public void setup() {
  
  // Initialize minim
  minim = new Minim(this);
  
  // use the getLineIn method of the Minim object to get an AudioInput
  in = minim.getLineIn();
  
  surface.setResizable(true);
  
  context = new DwPixelFlow(this);
  context.print();
  context.printGL();
  
  toyB = new DwShadertoy(context, "Test_BufB.frag");
  toyA = new DwShadertoy(context, "Test_BufA.frag");
  toy  = new DwShadertoy(context, "Test.frag");
  
  frameRate(60);
}


public void draw() {
  
  // Traverse the mic data to get the fft's
  for(int i = 0; i < in.bufferSize() - 1; i++)
  {
  
    fre = ( in.left.get(i) ) * 500.0;
    wav = ( in.right.get(i) ) * 500.0;
  
  }
  
  if(mousePressed){
    toyA.set_iMouse(mouseX, height-1-mouseY, mouseX, height-1-mouseY);
    toyB.set_iMouse(mouseX, height-1-mouseY, mouseX, height-1-mouseY);
  }
  
  
  toyB.set_iChannel(0, toyB);
  toyB.set_iChannel(1, toyA);
  toyB.set_iSampleRate(wav);
  toyB.apply(width, height);
  
  toyA.set_iChannel(0, toyA);
  toyA.set_iChannel(1, toyB);
  toyA.set_iSampleRate(wav);
  toyA.apply(width, height);
  
  toy.set_iChannel(0, toyA);
  toy.set_iSampleRate(wav);
  toy.apply(this.g);

  String txt_fps = String.format(getClass().getSimpleName()+ "   [size %d/%d]   [frame %d]   [fps %6.2f]", width, height, frameCount, frameRate);
  surface.setTitle(txt_fps);
}
