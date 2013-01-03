import toxi.geom.*;
import toxi.geom.mesh.*;
import java.util.Calendar;
import peasy.*;

private PeasyCam cam;

private int steps, threshold;
private PImage finger;
private PShape shape;
private WETriangleMesh mesh;

/**
 * As the time of writing (03.01.2013), this sketch is NOT WORKING with Processing 2.0b7- use 2.0b6 instead.
 *
 * @author: Marcel Schwittlick
 * @email: marzzzel@gmail.com
 *
 * Fingerprint
 * I have always been impressed by the fact that every fingerprint of every person is slightly different.
 * And since I'm a big fan of patterns in general I liked the abstract way of what a fingerprint is
 * actually like. I wanted to have a little closer look and found a way to digitalize my fingerprint and
 * put it in the physical world, so you can touch and feel it more detailed. Since the technology is there
 * and an Shapeways order is just 3 clicks and 3 weeks away, I did it.
 */
public void setup() {
  size(800, 800, P3D);

  cam = new PeasyCam(this, 1000);

  finger = loadImage("fp2.png");
  finger.resize(700, 0);
  finger.filter(INVERT);
  mesh = new WETriangleMesh();

  steps = 3;
  threshold = 20;

  setupShape();
}

private void setupShape() {
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
    println(i+"/"+(finger.height-2)+" steps done");
  }
  shape.end();
}

public void draw() {
  background(0);
  lights();
  shape(shape);
}

public void keyPressed() {
  if (key == 's') {
    saveFrame("screen_fingerprint_"+timestamp()+".png");
  } 
  if (key == 'm') {
    saveAndProcessMesh();
  }
}

private void saveAndProcessMesh() {
  new LaplacianSmooth().filter(mesh, 1);
  mesh.faceOutwards();
  mesh.computeFaceNormals();
  mesh.computeVertexNormals();
  mesh.saveAsSTL("fingerprint-"+timestamp()+".stl");
}

private String timestamp() {
  Calendar now = Calendar.getInstance();
  return String.format("%1$ty%1$tm%1$td_%1$tH%1$tM%1$tS", now);
}

