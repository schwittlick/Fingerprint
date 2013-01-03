import toxi.geom.*;
import toxi.geom.mesh.*;
import java.util.Calendar;
import controlP5.*;
import peasy.*;
import processing.opengl.*;

PImage finger;
PeasyCam cam;
int steps, threshold;

PShape shape;
WETriangleMesh mesh;

/**
 * As the time of writing, this sketch is NOT WORKING with Processing 2.0b7- use 2.0b6 instead.
*/
public void setup() {
  
  size(800, 800, P3D);
  
  finger = loadImage("fp2.png");
  finger.resize(700, 0);
  finger.filter(INVERT);
  mesh = new WETriangleMesh();
  
  cam = new PeasyCam(this, 1000);

  steps = 6;
  threshold = 20;

  setupShape();
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
}

void draw() {
  
  background(0);
  lights();
  //fill(255);
  shape(shape);
}

void keyPressed() {
  if (key == 's') {
    saveFrame("screen_fingerprint_"+timestamp()+".png");
    mesh.saveAsSTL("fingerprint-"+timestamp()+".stl");
    exit();
  }
}

String timestamp() {
  Calendar now = Calendar.getInstance();
  return String.format("%1$ty%1$tm%1$td_%1$tH%1$tM%1$tS", now);
}

