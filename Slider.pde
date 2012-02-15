class Slider {
  int x1, y1,w, h;
  int slideMax, slideMin;
  color theColor;
  String direction;

  Slider(int x1, int y1, int _w, int _h, int _min, int _max, color _color, String _direction) {

    this.x1 = x1;
    this.y1 = y1;
    this.w = _w;
    this.h = _h;
    this.direction = _direction;

    this.slideMax = _max;
    this.slideMin = _min;

    this.theColor = _color;

  }

  void display() {
    fill(theColor);
    noStroke();
    rect(x1,y1,w,h); 
  }
  
  void setPositionByVolume(float vol) {

    float adjustedY = map(vol, 1.0,0.0,this.slideMin, this.slideMax);
    this.y1 = (int)adjustedY;
  }

}


