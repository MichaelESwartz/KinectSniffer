import org.openkinect.processing.*;
import gab.opencv.*;
import processing.net.*;
import org.rsg.carnivore.*;

CarnivoreP5 c;

PFont f;
int u = 0;

OpenCV opencv;
Kinect kinect;

int kinectWidth = 640;
int kinectHeight = 480;

int minThreshold = 100;
int maxThreshold = 900;

int deg;

String pkts = "";
String pkts_ = "";
float num = 0;

PImage cam = createImage(640, 480, RGB);

PGraphics pg;


//Client sniffclient;

void setup() {
  
  c = new CarnivoreP5(this);
  //c.setShouldSkipUDP(true);
  
  //size(1280, 960);
  fullScreen();
  kinect = new Kinect(this);
  kinect.initDepth();
  kinect.enableMirror(true);
  frameRate(15);

  
  printArray(PFont.list());
  f = createFont("Times-Roman", 10);
  textFont(f);
  textAlign(CENTER, CENTER);

  //sniffclient = new Client(this, "10.0.0.239", 22222);

  pg = createGraphics(1280, 960);
}


void draw() {
  //background(0);


  //println("Cleared text string");

  if (pkts_.length() > 5000) {
    println(pkts_);
    pkts = pkts_;
    pkts_ = " ";
    println("Cleared");
  }

  pg.beginDraw();
  pg.smooth();
  pg.textFont(createFont("Arial", 15));
  pg.background(0);
  pg.fill(255,0,0);
  //pg.text("HELLO WORLD HELLO WORLD HELLO WORLD HELLO WORLD HELLO WORLD HELLO WORLD HELLO WORLD HELLO WORLD HELLO WORLD HELLO WORLD HELLO WORLD HELLO WORLD HELLO WORLD HELLO WORLD HELLO WORLD HELLO WORLD HELLO WORLD HELLO WORLD HELLO WORLD HELLO WORLD HELLO WORLD HELLO WORLD", 0, 0, width, height);
  pg.text(pkts,0,0,width,height);
  pg.endDraw();

  cam.loadPixels();
  pg.loadPixels();
   

  int[] depth = kinect.getRawDepth();
  for (int x = 0; x <kinect.width; x++) {
    for (int y = 0; y < kinect.height; y++) {
      int offset = x + y * kinect.width;
      int d = depth[offset];

      if (d > minThreshold && d < maxThreshold) {
        //cam.pixels[offset] = color(255,0,0);
        cam.pixels[offset] = pg.get(x, y);
      } else {
        cam.pixels[offset] = color(0);
      }
    }
  }
  cam.updatePixels();

  //image(kinect.getDepthImage(), 0, 0);
  image(cam, 0, 0, width, height);
  
  println(pkts_.length());
}

void packetEvent(CarnivorePacket p) {
  //pkts += p.toString();
  pkts_ += p.toString() + p.receiverSocket() + p.dateStamp();
  println("Payload " + p.toString());
}


void keyPressed() {

    

    if (keyCode == UP) {
      deg++;
    } else if (keyCode == DOWN) {
      deg--;
    }
    deg = constrain(deg, 0, 30);
    kinect.setTilt(deg);
  
}