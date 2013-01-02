import toxi.geom.*;
import toxi.geom.mesh.*;

import controlP5.*;
import peasy.*;
import processing.opengl.*;

PImage finger;
PeasyCam cam;
ControlP5 cp5;
PMatrix3D currCameraMatrix;
PGraphics3D g3; 
Slider stepsSlider, thresholdSlider;
int steps, threshold;

PShape shape;
WETriangleMesh mesh;

public void setup() {
  finger = loadImage("fp2.png");
  finger.resize(700, 0);
  finger.filter(INVERT);
  mesh = new WETriangleMesh();
  size(800, 800, P3D);
  g3 = (PGraphics3D)g;
  cam = new PeasyCam(this, 1000);
  cp5 = new ControlP5(this);

  steps = 3;
  threshold = 20;

  setupShape();

  cp5.addSlider("steps", 1, 30, steps, 20, 30, 10, 100);
  cp5.addSlider("threshold", 0, 255, threshold, 50, 30, 10, 100);
}

void setupShape() {
  shape = createShape(TRIANGLES);
  shape.noStroke();
  shape.fill(255);
  finger.loadPixels();
  for (int i=0; i<finger.height-steps; i+=steps) {
    for (int j=0; j<finger.width-steps; j+=steps ) {
      shape.vertex(j, i, red(finger.pixels[i*finger.width+j])/threshold);
      shape.vertex(j+steps, i, red(finger.pixels[i*finger.width+j+steps])/threshold);
      shape.vertex(j+steps, i+steps, red(finger.pixels[(i+steps)*finger.width+j+steps])/threshold);

      shape.vertex(j, i, red(finger.pixels[i*finger.width+j])/threshold);
      shape.vertex(j, i+steps, red(finger.pixels[(i+steps)*finger.width+j])/threshold);
      shape.vertex(j+steps, i+steps, red(finger.pixels[(i+steps)*finger.width+j+steps])/threshold);

      Vec3D p1 = new Vec3D(j, i, red(finger.pixels[i*finger.width+j])/threshold);
      Vec3D p2 = new Vec3D(j+steps, i, red(finger.pixels[i*finger.width+j+steps])/threshold);
      Vec3D p3 = new Vec3D(j+steps, i+steps, red(finger.pixels[(i+steps)*finger.width+j+steps])/threshold);
      Vec3D p4 = new Vec3D(j, i, red(finger.pixels[i*finger.width+j])/threshold);
      Vec3D p5 = new Vec3D(j, i+steps, red(finger.pixels[(i+steps)*finger.width+j])/threshold);
      Vec3D p6 = new Vec3D(j+steps, i+steps, red(finger.pixels[(i+steps)*finger.width+j+steps])/threshold);
      mesh.addFace(p1, p2, p3);
      mesh.addFace(p4, p5, p6);
    }
    //println(i+"/"+(finger.height-2)+" steps done");
  }
  int w = finger.width%steps;
  int h = finger.height%steps;
  int padding = -10;
 /*
  //left
  shape.vertex(0, 0, 255/threshold+1);
  shape.vertex(0, 0, 0);
  shape.vertex(0, finger.height-h, 0);
  mesh.addFace(new Vec3D(0, 0, 255/threshold+1), new Vec3D(0, 0, padding), new Vec3D(0, finger.height-h, padding));

  shape.vertex(0, finger.height-h, 0);
  shape.vertex(0, finger.height-h, 255/threshold+1);
  shape.vertex(0, 0, 255/threshold+1);
  mesh.addFace(new Vec3D(0, finger.height-h, padding), new Vec3D(0, finger.height-h, 255/threshold+1), new Vec3D(0, 0, 255/threshold+1));

  //top
  shape.vertex(0, 0, 255/threshold+1);
  shape.vertex(0, 0, 0);
  shape.vertex(finger.width-w, 0, 0);
  mesh.addFace(new Vec3D(0, 0, 255/threshold+1), new Vec3D(0, 0, padding), new Vec3D(finger.width-w, 0, padding));

  shape.vertex(finger.width-w, 0, 0);
  shape.vertex(finger.width-w, 0, 255/threshold+1);
  shape.vertex(0, 0, 255/threshold+1);
  mesh.addFace(new Vec3D(finger.width-w, 0, padding), new Vec3D(finger.width-w, 0, 255/threshold+1), new Vec3D(0, 0, 255/threshold+1));

  //right
  shape.vertex(finger.width-w, 0, 255/threshold+1);
  shape.vertex(finger.width-w, 0, 0);
  shape.vertex(finger.width-w, finger.height-h, 0);
   mesh.addFace(new Vec3D(finger.width-w, 0, 255/threshold+1), new Vec3D(finger.width-w, 0, padding), new Vec3D(finger.width-w, finger.height-h, padding));

  shape.vertex(finger.width-w, finger.height-h, 0);
  shape.vertex(finger.width-w, finger.height-h, 255/threshold+1);
  shape.vertex(finger.width-w, 0, 255/threshold+1);
  mesh.addFace(new Vec3D(finger.width-w, finger.height-h, padding), new Vec3D(finger.width-w, finger.height-h, 255/threshold+1), new Vec3D(finger.width-w, 0, 255/threshold+1));

  //bottom
  shape.vertex(0, finger.height-h, 255/threshold+1);
  shape.vertex(0, finger.height-h, 0);
  shape.vertex(finger.width-w, finger.height-h, 0);
  mesh.addFace(new Vec3D(0, finger.height-h, 255/threshold+1), new Vec3D(0, finger.height-h, padding), new Vec3D(finger.width-w, finger.height-h, padding));

  shape.vertex(finger.width-w, finger.height-h, 0);
  shape.vertex(finger.width-w, finger.height-h, 255/threshold+1);
  shape.vertex(0, finger.height-h, 255/threshold+1);
  mesh.addFace(new Vec3D(finger.width-w, finger.height-h, padding), new Vec3D(finger.width-w, finger.height-h, 255/threshold+1), new Vec3D(0, finger.height-h, 255/threshold+1));

  //ground
  shape.vertex(0, 0, padding);
  shape.vertex(0, finger.height-h, padding);
  shape.vertex(finger.width-w, finger.height-h, padding);
  mesh.addFace(new Vec3D(0, 0, padding), new Vec3D(0, finger.height-h, padding), new Vec3D(finger.width-w, finger.height-h, padding));


  shape.vertex(0, 0, -10);
  shape.vertex(finger.width-w, 0, -10);
  shape.vertex(finger.width-w, finger.height-h, -10);
  mesh.addFace(new Vec3D(0, 0, padding), new Vec3D(finger.width-w, 0, padding), new Vec3D(finger.width-w, finger.height-h, padding));
  shape.end();
  
  //new LaplacianSmooth().filter(mesh, 1);
  
  
  mesh.faceOutwards();
  mesh.computeFaceNormals();
  mesh.computeVertexNormals();
  //mesh.scale(3);
*/
  mesh.saveAsSTL(sketchPath("fingerprint-"+(System.currentTimeMillis()/1000)+".stl"));
  exit();
}

public void draw() {
  lights();
  background(0);
  //fill(255);
  shape(shape);
  cam.beginHUD();
  cp5.draw();
  cam.endHUD();
}

void keyPressed() {
  if (key == 's') {
    saveFrame("screen_fingerprint_"+(int)random(100)+".png");
  }
}

