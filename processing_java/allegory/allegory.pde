////////////////////////////////////////////////////////////////////////////////
// code and images by Aaron Penne
// https://github.com/aaronpenne/generative_art
//
// released under the MIT license (https://opensource.org/licenses/MIT)
////////////////////////////////////////////////////////////////////////////////

int max_frames = 10;

float step = 5;
int radius = 5;

float increment = 0.025;

float z_off = 0.0;
float t_off = 0.0;

float z_increment = 0.02;

boolean record = false;
boolean animate = true;
boolean seeded = true;

int rand_seed = 1138;

OpenSimplexNoise noise;

float pal[][] = {{36, 16.9, 92.9}, 
                 {2.7, 40.3, 86.7}};
                 
String timestamp = String.format("%04d%02d%02dT%02d%02d%02d", year(), month(), day(), hour(), minute(), second());

void setup() {
  // Sets size of canvas in pixels (must be first line)
  size(700, 700);
    
  // Sets resolution dynamically (affects resolution of saved image)
  pixelDensity(displayDensity());  // 1 for low, 2 for high
    
  // Sets color space to Hue Saturation Brightness with max values of HSB respectively
  colorMode(HSB, 360, 100, 100, 100);
        
  // Set the number of frames per second to display
  frameRate(50);
    
  // Keeps text centered vertically and horizontally at (x,y) coords
  textAlign(CENTER, CENTER);
    
  rectMode(CORNERS);
    
  // Stops draw() from running in an infinite loop
  if (!animate) {
   noLoop();
  }
        
  // Sets random seed value for both Python and Processing 
  if (seeded) {
    randomSeed(rand_seed);  // Only applies to the random() Processing function
    noiseSeed(rand_seed);   // Only applies to the noise() Processing function
  }
  
  noise = new OpenSimplexNoise();
  
  background(0, 0, 25);
  stroke(60, 7, 86);
  noFill();
}

void draw() {
  
  float step = TAU/20;
  float xc = width*0.5;
  float yc = height*0.6;
  float x = 0;
  float y = 0;
  float r = 0;
  float r_off = 0;
  
  for (int t_off=0; t_off==100; t_off+=step) {
    int cnt = 0;
    beginShape();
    for (float a=0; a<=TAU+(3*step); a+=step) {
      if (cnt>10 & cnt<37) {
        r = 10;
        r_off = map((float) noise.eval(100+r*cos(a), 100+r*sin(a), z_off, t_off), 0, 1, 0, 5);
        r = r_off*(r+frameCount);
        x = xc+r*cos(a);
        y = yc+r*sin(a);
        curveVertex(x, y);
      }
      cnt++;
    z_off += z_increment;
    }
    endShape();
  }
  
  
  
  if (record) {
    String output_filepath = "output/%s_####.png";
    println(String.format("Saving %04d to %s", frameCount, String.format(output_filepath, timestamp)));
    saveFrame(String.format(output_filepath, timestamp));
  }
}

void draw_blobs(float x_extra, float y_extra, float z_off, float t_off) {
  float x_off = 0.0;
  for (int x=radius/2; x<width; x+=step) {
    x_off += increment;
    
    float y_off = 0.0;
    for (int y=radius/2; y<height; y+=step) {
      y_off += increment;
      
      float h = 0;
      float s = 0;
      float b = (float) noise.eval(x_off+x_extra, y_off+y_extra, z_off, t_off);
      
      strokeWeight(radius);
      if (b > 0.1) {
        point(x, y);
      }
    }
  }  
  
  
}
