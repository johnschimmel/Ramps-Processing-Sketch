class Record {

  int xpos, ypos;
  float radius; 

  // Angle and angular velocity, accleration
  float theta;
  float theta_vel;
  float theta_acc;

  int scratchMode = 0;


  Record(int _x, int _y, int _radius) {
    this.xpos  = _x;
    this.ypos = _y;
    this.radius = _radius; 

    //
    this.theta = 0.0;
    this.theta_vel = 0.0;
    this.theta_acc = 0.045;
    
    this.scratchMode = 0;

  }

  void display() {
    smooth();

    stroke(255,200,100);
    strokeWeight(10);

    fill(255);
    ellipse(this.xpos,this.ypos,210,210);

    // Translate the origin point to the center of the screen
    pushMatrix();
    translate(this.xpos,this.ypos);

    // Convert polar to cartesian
    float x = this.radius * cos(this.theta);
    float y = this.radius * sin(this.theta);

    // Draw the rectangle at the cartesian coordinate
    ellipseMode(CENTER);
    stroke(200,0,100);
    strokeWeight(15);
    fill(200,0,100);
    line(0,0,x,y);

    if (this.scratchMode == 0) {
      this.theta_acc = 0.045;
    } 
    else if (scratchMode == 1) {
      this.theta_acc = 0.075;
    } 
    else if (scratchMode == -1) {
      this.theta_acc = -0.075; 

    }
    // Apply acceleration and velocity to angle (r remains static in this example)
    this.theta_vel = 0;
    this.theta_vel += this.theta_acc;
    this.theta += this.theta_vel;

    popMatrix();
  }

  void setScratch(int value) {
   // println("hello");
   this.scratchMode = value; 
  }
  
  
  void setRadiusByVolume(float volume) {

    //max radius
    float maxRadius = 145; 
    float minRadius = 15;

    this.radius = map(volume, minVolume, maxVolume, minRadius, maxRadius);

  }
}







