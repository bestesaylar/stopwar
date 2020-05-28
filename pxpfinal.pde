float angle = 0;

ArrayList<PVector> vectors = new ArrayList<PVector>();

import peasy.*;
import peasy.org.apache.commons.math.*;
import peasy.org.apache.commons.math.geometry.*;
import processing.video.*;
//music
import ddf.minim.*;

float beta = 0;

PShader shift;
Minim minim;
AudioPlayer sample;

Planet sun;
PeasyCam cam;
Movie mMovie;
Movie bgMovie;
PImage mS;
int vScale=4;
int mW;
int mH;


PImage bg;
PImage img;
float i;
float a=0.0; 
Capture video;

PImage starfield;
PImage sunTexture;
PImage[] textures= new PImage[8];


float x=(width/2)-200;
float y=(height/2)-100;
int z=0;

IntDict counts;
void setup(){
  //background(0);
  //bg=loadImage("pic2.png");
  //bg.resize(width,height);

  //size(1280,720,P3D);
  size(1440,900,P3D);
 
  //
  
  mMovie = new Movie(this, "mov2.mov");
  mMovie.loop();
  
  bgMovie = new Movie(this, "bg_movie2.mov");
  bgMovie.play();
  
   //music
  //frameRate(50);
  //frameRate(30);
  frameRate(28.5);
  smooth();
  minim = new Minim(this);
  sample = minim.loadFile("pxp_music.mp3", 1024);
  sample.play();
 
//WORD COUNTING
//   counts=new IntDict();
//   String[]lines=loadStrings("environment.txt");
//   String allwords=join(lines,"\n");
//   String[] tokens  = splitTokens(allwords,"\n\" /)(.,:?!}{");
   
//   for(int i=0;i<tokens.length;i++){
//     String word=tokens[i].toLowerCase();
//     if(counts.hasKey(word)){
//       counts.increment(word);
//   }else{
//     counts.set(word,1);
//   }
// }
//String[] keys=counts.keyArray();
//for(String k:keys){
//  int count =counts.get(k);
//  textSize(count);
//  float x=random(width);
//  float y=random(height);
//  text(k,x,y);
//}
  
  String videoList[] = Capture.list();
  video = new Capture(this, width, height, videoList[0]);
  video.start();

  sunTexture=loadImage("sun.jpg");
  textures[0]=loadImage("mars.jpg");
  textures[1]=loadImage("earth.jpg");
  textures[2]=loadImage("venus.jpg");
  textures[3]=loadImage("neptune.jpg");
  textures[4]=loadImage("pluto.jpg");
  textures[5]=loadImage("mercury.jpg");
  textures[6]=loadImage("jupiter.jpg");
  
  cam = new PeasyCam(this,500);
  sun = new Planet(50,0,0,sunTexture);
  sun.spawnMoons(4,1);
  
}

void movieEvent(Movie mMovie){
  mMovie.read();
  bgMovie.read();
}

void draw(){
  //background(mMovie);
  //image(mMovie,0,0);

  if (mMovie.available()){
    mMovie.read();
  }
  
  if (video.available() == true){
    video.read();
  }
  
  backgroundVid();
  knot();
  music();

  
  //tvscreen 
   lights();
   noStroke();
   fill(127);
   pushMatrix();
   lights();
   translate(x,y,z);
   rotate(a);  
   rotateY(i);
   beginShape();
   box(120,80,2);
   texture(video);
   texture(bgMovie);
   endShape(CLOSE);
   popMatrix();
   i+=.0121;
   a+=.01;

  directionalLight(255,255,255,-1,0,0);
  pointLight(255,255,255,0,0,0);
  sun.show();
  sun.orbit();
}     

void backgroundVid() {
   cam.beginHUD();
   pushMatrix();
   beginShape();
   translate(width/2,height/2,-1000);
   //fill(255,0,0);
   box(width,height,1);
   //rect(-width,-height,width * 2,height *2);
   texture(mMovie);
   endShape(CLOSE);

   popMatrix();
   cam.endHUD();
}

void music(){
  cam.beginHUD();
  stroke(128);
  strokeWeight(1);
  //WITH GRID
  //for ( int i=0; i<height/60; i++) {
  //  line(0, i*60, width, i*60);
  //}
  //for ( int i=0; i<width/60; i++) {
  //  line(i*60, 0, i*60, height);
  //}
  
  translate(width/2, height/2);
  scale(1, 2);
  rotate(-PI/4);
  strokeWeight(2);
  stroke(255, 120);
  noFill();
  beginShape();
  float f = 400;
  float left[] = sample.left.toArray();

  for ( int i =0; i<sample.bufferSize() -10; i++) {
        float x1 = left[i];
    float x2 = left[i+10];
    curveVertex( (x1)*f, (x2)*f);
  }
  endShape();
  cam.endHUD();
}

void knot(){
  cam.beginHUD();
  pushMatrix();
  translate(width/2, height/2);
  rotateY(angle);
  angle += 0.03;

//knot pattern formula
  float r = 100*(0.8 + 1.6 * sin(6 * beta));
  float theta = 2 * beta;
  float phi = 0.6 * PI * sin(12 * beta);
  
  float x = r * cos(phi) * cos(theta);
  float y = r * cos(phi) * sin(theta);
  float z = r * sin(phi);
  stroke(255, r, 255);

  //draw it
  vectors.add(new PVector(x,y,z));

  beta += 0.01;

  noFill();
  stroke(255,255,204);
  //stroke(255);
  strokeWeight(1);
  beginShape();
  for (PVector v : vectors) {

    //float d=v.mag();
    //stroke(255,d,0);
    vertex(v.x, v.y, v.z);
  }
  endShape();
  popMatrix();
  cam.endHUD();
}
