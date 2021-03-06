float Element_1_RotationX=90; //many variables
float Element_1_RotationY=0;
float Element_1_RotationZ=0;
float RingDetail=100;
float RingRotation1=0;
float RingRotation2=0;
float GlowA=1;
float GlowB=1010;
boolean Flash=true;
boolean Ship=true;
boolean ShowPlanet=false;
float PlanetRotation=0;
float PlanetColor1=0;
float PlanetColor2=0;
float PlanetColor3=0;
void setup(){
  size(800,800,P3D);
}

void draw(){
  lights();
  background(15);
  
  textSize(20);
  if(ShowPlanet==false){
    text("Press the up arrow to scan a planet.",50,50);}
    
  translate(height/2,width/2,0);
  scale(0.5);

  pushMatrix();
  
    
    UserRotation();
    if(ShowPlanet==false){
      fill(100);
      noStroke();
      Ring1();
      Ring2();
      Orb();
      fill(150);
      Body();
    }
    else{
      Planet();
    }
  popMatrix();
}

void UserRotation(){
  if(mousePressed==true){   //Defines overall rotation.
      if(mouseButton==LEFT){
      Element_1_RotationX=Element_1_RotationX-mouseY+pmouseY;} 
      }
    if(Element_1_RotationZ>360){
      Element_1_RotationZ=Element_1_RotationZ-360;
    }
    if(Element_1_RotationZ<0){
      Element_1_RotationZ=Element_1_RotationZ+360;
    }
    if(mousePressed==true){
      if(mouseButton==LEFT){
      Element_1_RotationZ=Element_1_RotationZ-mouseX+pmouseX;
      }
    } 
    
  rotateX(radians(Element_1_RotationX)); //rotates everything
  rotateZ(radians(Element_1_RotationZ));
  if(ShowPlanet==false){
  translate(-200,-200);
  }
}

void Ring1(){
  
  fill(255);
  RingRotation1=RingRotation1+1;
  if(RingRotation1>360){RingRotation1=RingRotation1-360;} // Keeps variable in check
  
  pushMatrix();
    rotateY(radians(RingRotation1));
    for(float b=RingDetail; b>0; b--){
    pushMatrix();
     translate(0,200,0);
     box(25,25,25);
    popMatrix();
    rotateZ(TAU/RingDetail);
    }
   popMatrix();
}

void Ring2(){
  pushMatrix();
  
    rotateX(radians(RingRotation1));
    for(float a=RingDetail; a>0; a--){
    pushMatrix();
     translate(0,175,0);
     box(25,25,25);
    popMatrix();
    rotateZ(TAU/RingDetail);
    }
  popMatrix();
  
}

void Orb(){
  
  if((GlowB>=20) || (GlowB<=0)){ //Controls the pulsating orb and flash
    if(Flash==false){
    GlowA=GlowA*-1;}
    else{
      GlowA=-100;
    }
  }
  if((GlowB<20) && (GlowB>0)){
    Flash=false;
  }
  GlowB=GlowB+GlowA;
  
  for(int c=1; c<20; c++){
  fill(#A2C2D1,255/c);
  sphere(30+c+GlowB);}
  stroke(255);
  strokeWeight(5);
  line(0,0,0,random(-150,150),random(-150,150),random(-150,150)); //randomly flashing line
  noStroke();
}

void Body(){  //This section just places all the boxes that make up the body of the mass relay.
  pushMatrix();
  rotateZ(radians(-5));
    for(float a=RingDetail; a>0; a--){
    pushMatrix();
     translate(0,305+abs((RingDetail/2-a)*0.2),0);
     box(100,150-abs((RingDetail/2-a)*1.5),100);
    popMatrix();
    rotateZ(TAU/RingDetail*0.70);
    }
  popMatrix();
  
  fill(100);
  pushMatrix();
  rotateZ(radians(-5));
    for(float a=RingDetail; a>0; a--){
    pushMatrix();
     translate(0,335+abs((RingDetail/2-a)*0.2),0);
     box(100,150-abs((RingDetail/2-a)*1.5),65);
    popMatrix();
    rotateZ(TAU/RingDetail*0.70);
    }
  popMatrix();
  
  pushMatrix();
  translate(415,575,0);
  rotateZ(radians(35));
  fill(150);
  box(900,100,100);
  translate(-90,65,0);
  fill(100);
  box(800,40,65);
  box(900,20,65);
  box(800,60,45);
  popMatrix();
  
  pushMatrix();
  translate(650,125,0);
  rotateZ(radians(35));
  fill(150);
  box(900,100,100);
  translate(-90,-65,0);
  fill(100);
  box(800,40,65);
  box(900,20,65);
  box(800,60,45);
  popMatrix();
  
  pushMatrix();
  rotateZ(radians(120));
  translate(400,100,0);
  box(300,20,20);
  translate(0,50,0);
  box(200,15,15);
  translate(0,-100,0);
  box(200,15,15);
  popMatrix();
}

void Planet(){
  background(#1F264B);
  if(mousePressed==false){
    PlanetRotation=PlanetRotation+1;}
  if(PlanetRotation>360){PlanetRotation=PlanetRotation-360;} // Keeps variable in check
  pushMatrix();
  rotateX(radians(PlanetRotation));
  fill(PlanetColor1,PlanetColor2,PlanetColor3);
  noStroke();
  sphere(400);
  fill(PlanetColor1,PlanetColor2,PlanetColor3,150);
  sphere(420);
  sphere(440);
  stroke(255);
  strokeWeight(2);
  
  pushMatrix();
  for(int p=0; p<12; p++){
    ellipse(0,0,880,880);
    rotateX(TAU/12);
  }
  rotateY(radians(90));
  ellipse(0,0,880,880);
    
  popMatrix();
  
  pushMatrix();
  //for(int p=0; p<12; p++){
    
  //}
  popMatrix(); 
  popMatrix();
}

void keyPressed(){  //flash effect
  if((key==ENTER) || (key==RETURN)){
  Flash=true;
  GlowB=1010;
  if(Ship==true){
    Ship=false;}
    else{Ship=true;}
  }
  if(keyCode==UP){
    if(ShowPlanet==true){
    ShowPlanet=false;}
    else{ShowPlanet=true;
    PlanetColor1=random(0,255);
    PlanetColor2=random(0,255);
    PlanetColor3=random(0,255);
  
    }
  }
}
