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
class SunburstItem {
 
 int tSize = 24; //maximum text size
 int ctSize = 128; //maximum centre text size
 float ringWidth;
 float startAngle;
 float extension;
 float radius;
 color c;
 ArrayList name;
 SunburstItem(float startAngle, float extension, float radius, float ringWidth, ArrayList name, color c){
    this.startAngle = startAngle;
    this.extension = extension;
    this.radius = radius;
    this.ringWidth = ringWidth;
    this.name = name;
    this.c = c;
    colorMode(HSB, 360,100,100,100);
 }

  void drawArc(int startX, int startY){
      fill(c);
     strokeWeight(1);
     if(extension == -1){
       println("print circe");
       ellipse(startX, startY, radius, radius);
     }
     else{
       arc(startX , startY ,radius,radius, startAngle, startAngle+extension, PIE);
     }  
  }
  
  void drawText(int startX, int startY){
     fill(10);
      String name = getFullName(tSize, ringWidth-20);
      textLeading(26);
     pushMatrix();
     //
     if((startAngle+(0.5*extension)) < 0.5*PI || (startAngle+(0.5*extension)) >= 1.5*PI){
       translate(startX,startY-5);
       rotate(startAngle+(0.5*extension));     
       text(name, 0.5*radius-ringWidth+10, 0);
     }
     else{
      translate(startX, startY); 
      rotate(startAngle+(0.5*extension)-PI);
      text(name, -0.5*radius+10, 0);

     }
     popMatrix();
  }
  
  void drawMiddleText(int startX, int startY){
     fill(10);
     pushMatrix();
     textAlign(CENTER);
     translate(startX,startY-50);
     String name = getFullName(ctSize, radius*0.7);
     text(name,0,0); 
     textAlign(LEFT);
     popMatrix();
  }


  String getFullName(int maxTextSize, float maxWidth){
     String fullName = "";
     textSize(maxTextSize);
     //check for rufname
     if(((String)name.get(1)).length() > 0){
         fullName += (String) name.get(1);
     }
     //preruf
     else if (((String)name.get(0)).length() > 0){
         fullName += (String) name.get(0);
     }       
     //postruf
     else if(((String)name.get(2)).length() > 0){ 
         fullName += (String) name.get(2);
     }
     //Check if prename String is short enough
     while( textWidth(fullName) > maxWidth){
       maxTextSize -= 2;
       textSize(maxTextSize);
     }     
     fullName += "\n" + (String)name.get(3); 
    //Check if lastname String is short enough 
     while( textWidth((String)name.get(3)) > maxWidth){
       maxTextSize -= 2;
       textSize(maxTextSize);
     }  

     return fullName;  
    }
}
