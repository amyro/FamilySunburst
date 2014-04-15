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
import java.util.Map;

class FamilyTree {
  ArrayList[][] tree;
 
  int[] generation;
  int colorValue;
  int brightness;
  HashMap<String, Float> hm = new HashMap<String, Float>();
  ArrayList<Integer>list; //contains IDs of all family members by youngest generation
  
  float minExtPP = 850; //minimum arc radius
  float ringwidth = 400; //width of each ring
  float radius = 800; //radius of the inner circle

  
  FamilyTree(String file, int startId, int colorValue, int brightness){
    this.colorValue = colorValue;
    this.brightness = brightness;
    Table table = loadTable(file, "header, tsv");
    println(table.getRowCount() + " family members loaded");
    tree = new ArrayList[table.getRowCount()+1][3];
   
    for( TableRow row : table.rows()){
       int id = row.getInt(0);

       tree[id][0]=new ArrayList(4);       
       tree[id][0].add(row.getString(1)); //preruf
       tree[id][0].add(row.getString(2)); //ruf
       tree[id][0].add(row.getString(3)); //postruf
       tree[id][0].add(row.getString(4)); //nachname  

       String partner = row.getString(5);    
       tree[id][1]=getArrayListFromString(partner);

       String kinder = row.getString(6);
       tree[id][2]=getArrayListFromString(kinder); 
           
     }
    
     generation = new int[table.getRowCount()+1];
     
     list = new ArrayList(); // contains IDs of all family members
     ArrayList<Integer> tmpidx = new ArrayList(); // id list for recursive iterations
     generation[startId] = 0;
     tmpidx.add(startId);
     while(tmpidx.size() > 0){
       int idx = tmpidx.remove(0);
       list.add(idx);
       ArrayList<Integer> childs = getChildren(idx);
       if(childs != null){
         for(int child : childs){
           generation[child] = generation[idx]+1;
           tmpidx.add(child);
         }
       }
       //println(tree[idx][0] + " " + generation[idx]);
     }
      calculateExtensions();
   }
   
  //calculates the space that is needed for the sunburst diagram 
  void calculateExtensions(){
    //calculate extension per person
     for(int i=list.size()-1; i>=0; i--){
       int idx = list.get(i);
       float parentExt = 0;
       setExtToHM(idx,0,0,0);
       ArrayList<Integer> partners = getPartners(idx);
       ArrayList<Integer> childs = getChildrenWithoutPartner(idx);
       //println(childs.size() + " " + + (getChildren(idx)).size() + " " + tree[idx][0]);
       //Partner vorhanden
       if(partners != null && partners.size() > 0){
         float radParent = radius + (generation[idx]*ringwidth*2);
         float radPartner = radParent + ringwidth;
         float radChild = radPartner + ringwidth;
         //float parentExt = 0;
         //children with partner
         for(int partner : partners){
           float partnerExt = 0;
           ArrayList<Integer> childsWithPartner = getChildren(idx, partner);
           for(int child : childsWithPartner){
             partnerExt += (getExtFromHM(child,0,0)*radPartner)/radChild;
             setExtToHM(idx,partner,child, getExtFromHM(child,0,0));
           }
           //check if arc has minimum size
           if (partnerExt > minExtPP) setExtToHM(idx,partner,0,partnerExt);
           else setExtToHM(idx,partner,0,minExtPP);
           parentExt += (getExtFromHM(idx,partner,0)*radParent)/radPartner;
         }
         //check if arc has minimum size
         setExtToHM(idx,0,0,parentExt);
         //println(tree[idx][0] + "\t" + extPFM[idx]);

       }
       //children without partner
       if(childs.size() > 0){
         float radParent = radius + (generation[idx]*ringwidth*2);
         float radChild = radParent + ringwidth + ringwidth;
         for(int child : childs){
            parentExt += (getExtFromHM(child,0,0)*radParent)/radChild;
            setExtToHM(idx,0,child, getExtFromHM(child,0,0));
         }
         //check ob errechneter Kreisbogen Mindestmaß übersteigt
         setExtToHM(idx,0,0,parentExt);
       }
       //no partner or children
       if(parentExt < minExtPP)
       {
          setExtToHM(idx,0,0,minExtPP);
       }
     }
     //check for radius
     float gen0Ext = 0;
     for(int i=0; i<generation.length; i++){
       if(generation[i] == 1){
         gen0Ext += getExtFromHM(i,0,0);
       }
     }
     gen0Ext = ((gen0Ext*radius)/(radius+ringwidth+ringwidth))/(2*PI);
     float ringExt = 2 * PI * radius;
     if(gen0Ext > ringExt){
        radius += 200;
        println("Attentaion sunburst radius is too small!!! Trying radius = " + radius);
        calculateExtensions();
     }
  }
  
  float getExtFromHM(int parentId, int partnerId, int childId){
    String s=""+parentId+";"+partnerId+";"+childId;
    if(!hm.containsKey(s)){println(s);}
    float f = hm.get(s);
    return f;
  }
  void setExtToHM(int parentId, int partnerId, int childId, float ext){
    String s = ""+parentId+";"+partnerId+";"+childId;
    hm.put(s,ext);
  }
  
  ArrayList<Integer> getPartners(int id){
     return tree[id][1]; 
  }
  
  ArrayList<Integer> getChildren(int id1, int id2){
     ArrayList<Integer> kids1 = tree[id1][2];
     ArrayList<Integer> kids2 = tree[id2][2];
     ArrayList<Integer> kids = new ArrayList();
     for(int i=0; i<kids1.size(); i++){
        if(kids2.contains(kids1.get(i))){
           kids.add((int)kids1.get(i)); 
        }
     }
     return kids;
  }
  
  ArrayList<Integer> getChildren(int id){
   return tree[id][2]; 
  }
  
  ArrayList<Integer> getChildrenWithoutPartner(int id){
    ArrayList<Integer> childs = (ArrayList<Integer>)getChildren(id).clone();
    ArrayList<Integer> partners = getPartners( id);
    for(int partner : partners){
      ArrayList<Integer> childsWithPartner = (ArrayList<Integer>)getChildren(id, partner);
      for(int child : childsWithPartner){
        childs.remove(new Integer(child));
      }
    }
    return childs;
  }
  
  ArrayList<Integer> getArrayListFromString(String s){
     ArrayList<Integer> list = new ArrayList<Integer>();
     String[] string_array = split(s, ";"); 
     if(string_array.length > 1){
         for(int i=0; i<string_array.length; i++){
             list.add(Integer.parseInt(string_array[i]));
         }        
       }
       else{
         try{
            list.add(Integer.parseInt(s));
         }catch(NumberFormatException e){}
       }
       return list;
  }
  
  int getImageWidth(){
     int maxGen = max(generation);
     int width = (((int)radius+(maxGen*2*(int)ringwidth))+(int)ringwidth); 
     return width;
  }
  
  SunburstItem[] createSunburstItems(int startId){
      float startAngle = 0;
      float extension = 2*PI;
      ArrayList sunburst = new ArrayList();
      color c = color(colorValue, 0, 100);
      sunburst.add(new SunburstItem(0, -1, radius, ringwidth/2, tree[startId][0], c));
      ArrayList<ArrayList> family = new ArrayList();
      ArrayList member = new ArrayList();
      member.add(startId); member.add(startAngle); member.add(extension); member.add(radius); member.add(c);
      family.add(member);
      
      while(family.size() > 0){
        ArrayList parent = family.remove(0);
        int parentId = (Integer)parent.get(0);
        ArrayList<Integer> childsWithoutPartner = getChildrenWithoutPartner(parentId);
        ArrayList<Integer> partners = getPartners( parentId);
        float parentStartAngle = (Float) parent.get(1);
        float parentRadius =  (Float) parent.get(3);
        float partnerRadius = parentRadius + ringwidth;
        float childRadius = partnerRadius + ringwidth;
        float parentExtension =  (Float) parent.get(2);
        //color parentC = (color) parent.get(4);
        color parentC = color(colorValue, ((100/max(generation))*generation[parentId]), brightness);
        if(parentId == startId) parentC = color(colorValue, ((100/max(generation))*generation[parentId]), 100);
        
        float partnerOffset = 0;
        float childWithoutPartnerOffset = 0;
 
        //Check if more circle space is available
        float extAll = 0;
        for(int partner : partners){
          extAll += (getExtFromHM(parentId,partner,0)*parentRadius)/partnerRadius;
        }
        for(int child : childsWithoutPartner){
         extAll += (getExtFromHM(parentId,0,child)*parentRadius)/childRadius;
        }
        //extAll = extAll/(2*PI*partnerRadius);
        //float parentOffset = 0;
        if ((extAll/(2*PI*partnerRadius)) < parentExtension){          
          float diff = ((parentExtension*2*PI*parentRadius)-extAll)/(partners.size() + childsWithoutPartner.size());
          partnerOffset = ((diff*partnerRadius)/parentRadius)/(2*PI*partnerRadius);
          childWithoutPartnerOffset = ((diff*childRadius)/parentRadius)/(2*PI*childRadius);
        }

        //Create sunbursts for partners
        float radiant = 2*PI;
        float partnerStartAngle = new Float(parentStartAngle);
        for(int partner : partners){
          float partnerExtension = (getExtFromHM(parentId,partner,0)/(2*PI*partnerRadius)) + partnerOffset;
          ArrayList<Integer> childs = getChildren(parentId, partner);
          extAll = 0;
          float childOffset = 0;
          //check if more circle space is available
          for(int child : childs){
             extAll += (getExtFromHM(parentId,partner,child)*partnerRadius)/childRadius;
          }
          if ((extAll/(2*PI*childRadius)) < partnerExtension){
            float diff = ((partnerExtension*2*PI*partnerRadius)-extAll)/childs.size();
            childOffset = ((diff*childRadius)/partnerRadius)/(2*PI*childRadius);
          }
          sunburst.add(new SunburstItem(partnerStartAngle, partnerExtension, partnerRadius, ringwidth/2, tree[partner][0], parentC)); 
          
          float childStartAngle = new Float(partnerStartAngle);
          for (int child : childs) {
            float childExtension = (getExtFromHM(parentId,partner,child)/(2*PI*childRadius)) + childOffset;
            color childC = color(colorValue, ((100/max(generation))*generation[child]), brightness);
            sunburst.add(new SunburstItem(childStartAngle, childExtension, childRadius, ringwidth/2, tree[child][0], childC));
            member = new ArrayList();
            member.add(child); member.add(childStartAngle); member.add(childExtension); member.add(childRadius); member.add(childC);
            family.add(member);
            childStartAngle += childExtension;
          }
          partnerStartAngle += partnerExtension;
        }        
        //Create sunbursts for childs with just one parent
        float childStartAngle = partnerStartAngle;
        for(int child: childsWithoutPartner){
          float childExtension = (getExtFromHM(parentId,0,child)/(2*PI*childRadius)) + childWithoutPartnerOffset;
          color childC = color(colorValue, ((100/max(generation))*generation[child]), brightness);
            sunburst.add(new SunburstItem(childStartAngle, childExtension, childRadius, ringwidth/2, tree[child][0], childC));
            member = new ArrayList();
            member.add(child); member.add(childStartAngle); member.add(childExtension); member.add(childRadius); member.add(childC);
            family.add(member);
            childStartAngle += childExtension;
        }
        
        
      }
      
      SunburstItem[] res = new SunburstItem[sunburst.size()];
      for(int i = 0; i < sunburst.size(); i++){
         SunburstItem s = (SunburstItem) sunburst.get(sunburst.size()-i-1);
         //s.printName(i);
         res[i] = (SunburstItem) sunburst.get(sunburst.size()-i-1);
      }
      return res; 
  }
  
}
