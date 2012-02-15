// RUNS in Processing 1.5.1 - Does not run in Processing 2.0a

import processing.video.*;
import processing.serial.*;

// SONG CONFIG - MP3 Files should be in /data folder
// Songs are defined in the setup loop
Movie song1, song2, currentSong;

//quicktime
float song1Speed, song2speed = 1.0;
float volumeAdjustment = 0.07;
float maxVolume = 1.0;
float minVolume = 0.0;

//serial
Serial myPort; //serial variable
int lf = 10;


char leftDirection, rightDirection;
int leftSpeed, rightSpeed = 0;
float leftWheelTimer, rightWheelTimer=0;

int scratchMode = 0;
boolean songSwitchPressed = false;

//visuals
Record line1, line2;
Slider fader;

void setup() {
  size(800, 500);  

  //start serial
  myPort = new Serial(this, Serial.list()[0], 57600); 
  myPort.bufferUntil(lf);

  // define songs
  song2 = new Movie(this, "Allure.mp3");
  song1 = new Movie(this, "Interlude.mp3");

  setVolume(song2, 0.0); //turn volume off on 2nd song

  //visuals
  line1 = new Record(width/3, height/2, 125);
  line2 = new Record((width/3)*2+25, height/2, 15);

  //sliders
  //fader left side
  color fColor = color(200, 0, 100);
  fader = new Slider(10, 10, 100, 25, 10, height-40, fColor, "vertical");
} 

void draw() {

  if ( getVolume(song1) > 0.5) {
    currentSong = song1;
    line1.setScratch(scratchMode);
  } 
  else {
    currentSong = song2; 
    line2.setScratch(scratchMode);
  }


  background(0);



  if (  (scratchMode !=0 ) &&  (millis() - rightWheelTimer) < 100  ) {
    if (scratchMode == -1) {
      currentSong.speed(3.0 * scratchMode);
    } 
    else {
      float mapped = 0;
      if (rightSpeed < 120) {
        mapped = map(rightSpeed, 400, .01, 1, 1.4);
        //println(rightSpeed + " " + mapped);
      } 
      else {
        mapped = map(rightSpeed, 400, .01, .2, .99);
        //println(rightSpeed + " " + mapped);
      }

      currentSong.speed(mapped * scratchMode);


      // currentSong.speed(1.6 * scratchMode);
    }
  } 
  else {
    //reset song speed
    song1.speed(1.0);
    song2.speed(1.0);
    line1.setScratch(0);
    line2.setScratch(0);


    //reset wheel
    resetWheel("right");
  }

  //update object properties
  line1.setRadiusByVolume(getVolume(song1));
  line2.setRadiusByVolume(getVolume(song2));
  line1.display();
  line2.display();

  //display
  fader.display();
  fader.setPositionByVolume(getVolume(song1));

  //loop songs if ended
  if (isDone(song1)) {
    song1.jump(0.0);
  } 
  else if (isDone(song2)) {
    song2.jump(0.0);
  }
}


void setVolume(Movie theSong, float newVolume) {
  try {
    if ((newVolume <= maxVolume )&&  (newVolume >= minVolume)) {
      theSong.movie.setVolume(newVolume);
    } 
    else if (newVolume <= minVolume) {
      theSong.movie.setVolume(minVolume);
    } 
    else if (newVolume >=maxVolume) {
      theSong.movie.setVolume(maxVolume);
    }
  } 
  catch (Exception e) {
  }
}

float getVolume(Movie theSong) {
  try {
    float v = theSong.movie.getVolume();
    return v;
  } 
  catch (Exception e) {
  } 


  return 0.0;
}

void resetWheel(String wheel) {
  if (wheel == "right") {
    rightDirection = 0;
    rightSpeed = 0;
  } 
  else if (wheel == "left") {
    leftDirection = 0;
    leftSpeed = 0;
  }
}

void keyPressed() {

  float s1v = getVolume(song1);
  float s2v = getVolume(song2);

  if (keyCode == UP) { 
    setVolume(song1, (s1v + volumeAdjustment) );//turn song 1 up
    setVolume(song2, (s2v - volumeAdjustment) ); //turn song 2 down
  } 
  else if (keyCode ==DOWN) {
    setVolume(song1, (s1v - volumeAdjustment) );//turn song 1 down
    setVolume(song2, (s2v + volumeAdjustment) ); // turn song 2 up
  }
  else if (keyCode == RIGHT) {
    scratchMode = 1;
  } 
  else if (keyCode ==LEFT) {
    //scratchSong(song1, -1); 
    scratchMode = -1;
  }
}

void keyReleased() {
  scratchMode = 0;
  songSwitchPressed = false;
}

boolean isDone(Movie theSong) {
  try {
    return theSong.movie.isDone();
  } 
  catch (Exception e) {
  } 
  return false;
}


void serialEvent(Serial p) { 
  String inString = (myPort.readString()); 

  String[] wheelInfo = splitTokens(inString, " ");

  float s1v = getVolume(song1);
  float s2v = getVolume(song2);

  if (wheelInfo.length == 6) {

    leftDirection = char(wheelInfo[2].charAt(0));
    rightDirection = char(wheelInfo[5].charAt(0));

    leftSpeed = int(wheelInfo[1]);
    rightSpeed = int(wheelInfo[4]);

    if (rightSpeed != 0) {
      rightWheelTimer = millis(); 
      scratchMode = (rightDirection == '1') ? 1 : -1;
    } 
    else {
      scratchMode =0;
    }

    ///println(leftSpeed + "  " + rightSpeed);

    if ( (leftDirection == '1') && (rightDirection == '1') ) {
      println("both forward");
    } 
    else if ( (leftDirection =='1') && (rightDirection == '0') ) {

      setVolume(song1, (s1v + volumeAdjustment) );//turn song 1 up
      setVolume(song2, (s2v - volumeAdjustment) ); // turn song 2 down
    } 
    else if ( (leftDirection =='0') && (rightDirection == '1') ) {
      //   t.turnLeft();
    } 
    else if ( (leftDirection =='-') && (rightDirection == '0') ) { 

      setVolume(song1, (s1v - volumeAdjustment) );//turn song 1 down
      setVolume(song2, (s2v + volumeAdjustment) ); // turn song 2 up
    } 
    else if (  (leftDirection =='0') && (rightDirection == '-') ) {
      //   t.turnBackLeft();
    } 
    else if ( (leftDirection == '-') && (rightDirection == '-')) {
      //t.decelerate();
    }
  }
  myPort.clear();
}






