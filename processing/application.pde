/*
The MIT License (MIT)

Copyright (c) 2014 Amrei Röhlig

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
*/
FamilyTree tree;
int startId;
SunburstItem[] sunburst;
int startX;

void setup(){  
  colorMode(HSB, 360,100,100,100);
  String file = "family_example.csv";
  startId = 1; 
  
  //int colorValue = 0; ; int brightness = 100; // red
  //int colorValue = 25;  int brightness = 100; // orange
  //int colorValue = 180; int brightness = 90; // cyan
  int colorValue = 215; int brightness = 100; // blue
  //int colorValue = 135; int brightness = 90; // green
  //int colorValue = 280;  int brightness = 100; // purple
  //int colorValue = 50;  int brightness = 100; // yellow
  //int colorValue = 300; int brightness = 100; //pink


  tree = new FamilyTree(file, startId, colorValue, brightness);   
  sunburst = tree.createSunburstItems(startId);
  
  //define image size
  println("Image size: " + tree.getImageWidth() + " x" + tree.getImageWidth());  
  size(tree.getImageWidth(),tree.getImageWidth());

  //background color
  background(360);
  
  PFont f = createFont("Verdana",16,true);
  textFont(f,36); 

   noLoop();
}

void draw(){  
    for (int i = 0 ; i < sunburst.length; i++) {
        sunburst[i].drawArc(width/2, height/2);
    }
     sunburst[sunburst.length-1].drawMiddleText(width/2, height/2);
    for (int i = 0 ; i < sunburst.length-1; i++) {
        sunburst[i].drawText(width/2, height/2);
    }
 
    save("sunburst"+startId+".png"); 
}
