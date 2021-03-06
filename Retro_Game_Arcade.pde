int currentScreen=0; // 0=Title 1=Menu 2=Game
int gameMap=0; // 0=Unselected 1=Pong 2=Asteroids 3=Snake 4=Tank Destroyer
int gameState=0; // 0=Game not running 1=Starting sequence 2=Game running 3=Ending Sequence
int textFade=255;
int textFadeToggle=5;
PImage GameOverScreen;
PImage tankBackground;
PImage snakeBackground;

Button menuButton1;
Button menuButton2;
Button menuButton3;
Button menuButton4;
PixelObjectLoader myPixelObjectLoader;
Bullets bullet1;
ExplosionPoint[] explosionPoints;
Rock[] rock1;
EnemyTank[] myEnemyTank;
Timer myTimer;

void setup() {
  fullScreen(P3D);
  //frameRate(90);
  menuButton1=new Button(color(#6792A2), -200, -200, 150, 150, 1); // Takes you to Pong
  menuButton2=new Button(color(#6792A2), -200, 200, 150, 150, 2); // Takes you to Asteroid
  menuButton3=new Button(color(#6792A2), 200, -200, 150, 150, 3); // Takes you to Snake
  menuButton4=new Button(color(#6792A2), 200, 200, 150, 150, 4); // Takes you to Tank Destroyer
  myPixelObjectLoader=new PixelObjectLoader(); // Space Invader in the title screen.
  myTimer=new Timer(10000);
  GameOverScreen = loadImage("https://cloud.githubusercontent.com/assets/14901273/11832564/3395b590-a37f-11e5-81fc-9aa4395b8177.png");
  tankBackground = loadImage("https://cloud.githubusercontent.com/assets/14901273/11832592/72124af4-a37f-11e5-91d8-fe244fbcd2a4.png");
  snakeBackground = loadImage("https://cloud.githubusercontent.com/assets/14901273/11832579/61659954-a37f-11e5-8426-2f8c14334a97.png");

  bullet1=new Bullets();
  explosionPoints = new ExplosionPoint[40];
  for (int i = 0; i < explosionPoints.length; i=i+1) {
    explosionPoints[i] = new ExplosionPoint();
  }

  rock1=new Rock[10];
  for (int j = 0; j < rock1.length; j=j+1) {
    rock1[j] = new Rock();
  }
  
  myEnemyTank=new EnemyTank[10];
  for (int k = 0; k < myEnemyTank.length; k=k+1) {
    myEnemyTank[k] = new EnemyTank();
  }
}

void draw() {
  background(0);
  lights();
  //debugging();
  if (currentScreen==0) {
    titleScreen();
  }
  if (currentScreen==1) {
    menuScreen();
  }
  if (currentScreen==2) {
    gameScreen();
  }
  if(gameState!=2){
  myTimer.timerStart();
  }
}

void debugging() { // Displays some important information.
  fill(0, 200, 0);
  text(currentScreen, 100, 50);
  text(gameMap, 100, 100);
  text(gameState, 100, 150);
  text(asteroidScore, 100, 200);
}

void titleScreen() {
  borderBox1();
  fill(0, 200, 0);
  stroke(0);
  strokeWeight(3);
  textSize(60);
  textAlign(CENTER);
  myPixelObjectLoader.display();
  myPixelObjectLoader.updatePos();
  text("Retro", displayWidth/2, displayHeight/2-175);
  text("Arcade", displayWidth/2, displayHeight/2+130);
  textSize(30);
  textFade();
  fill(0, 200, 0, textFade);
  text("Press any key to start.", displayWidth/2, displayHeight/2+200);
  if (mousePressed==true) {
    currentScreen=1;
  }
  if (keyPressed==true) {
    currentScreen=1;
  }
}

void menuScreen() {
  borderBox1();
  menuButton1.displayGameMapButton();
  menuButton2.displayGameMapButton();
  menuButton3.displayGameMapButton();
  menuButton4.displayGameMapButton();
  fill(0, 200, 0);
  stroke(0);
  strokeWeight(2);
  textSize(40);
  textAlign(CENTER);
  text("Choose a Game.", displayWidth/2, displayHeight/2);
  if (gameMap!=0) {
    textSize(30);
    text("Press Enter to Start", displayWidth/2, displayHeight/2+50);
  }
  if ((gameMap!=0) && (keyPressed==true) && ((key==ENTER) ||(key==RETURN))) {
    currentScreen=2;
    gameState=1;
  }
}

void gameScreen() {
  borderBox1();
  if (gameMap==1) {
    pongController();
  }
  if (gameMap==2) {
    asteroidsController();
  }
  if (gameMap==3) {
    snakeController();
  }
  if (gameMap==4) {
    tankDestroyerController();
  }
}

void textFade() { // This just makes some text fade in and out.
  if ((textFade==255) || (textFade==0)) {
    textFadeToggle=textFadeToggle*-1;
  }
  textFade=textFade+textFadeToggle;
}

void borderBox1() {  // This is just a decorative box around the outside.
  shapeMode(CENTER);
  stroke(0, 200, 0);
  fill(0, 100, 0);
  strokeWeight(2);
  pushMatrix();
  translate(displayWidth/2-600, displayHeight/2, 0);
  box(50, 700, 50);
  box(40, 700, 50);
  box(30, 700, 50);
  translate(1200, 0, 0);
  box(50, 700, 50);
  box(40, 700, 50);
  box(30, 700, 50);
  popMatrix();

  pushMatrix();
  translate(displayWidth/2, displayHeight/2-375, 0);
  box(1250, 50, 50);
  box(1250, 40, 50);
  box(1250, 30, 50);
  translate(0, 750, 0);
  box(1250, 50, 50);
  box(1250, 40, 50);
  box(1250, 30, 50);
  popMatrix();
}

float asteroidsShipAngle=0;
int asteroidNumber=1;
int asteroidScore=0;
float randomAsteroidAngle=0;
int asteroidLives=3;

void asteroidsController() { // This runs the Asteroids game.
  if (gameState==1) { // Runs if the game is in the intro sequence and has not started yet.
    gameStartTimer();
    textAlign(CENTER);
    textSize(40);
    fill(0, 200, 0);
    text("Score:", 350, 175);
    text(asteroidScore, 450, 175);
    text("Lives:", 350, 225);
    text(asteroidLives, 450, 225);
    ringOfConcealment();
    asteroidShipPoint();
    bullet1.display();
    enemyTankNumber=1;
  }

  if (gameState==2) { //This is the main body of the game.
    textAlign(CENTER);
    textSize(40);
    fill(0, 200, 0);
    text("Score:", 350, 175);
    text(asteroidScore, 450, 175);
    text("Lives:", 350, 225);
    text(asteroidLives, 450, 225);
    ringOfConcealment();
    asteroidShipPoint();
    for (int j = 0; j < asteroidNumber; j=j+1) {
      rock1[j].update();
      rock1[j].display();
    }
    if (myTimer.isFinished()) {
      myTimer.timerStart();
      if (asteroidNumber<=9) {
        asteroidNumber=asteroidNumber+1;
      }
    }

    bullet1.updatePos();
    bullet1.display();
    if (mousePressed==true) {
      bulletVisable=true;
      bullet1.targetPosX=mouseX;
      bullet1.targetPosY=mouseY;
      bullet1.bulletVersion=1;
      bullet1.bulletReturn();
    }

    if (asteroidLives==0) {
      gameState=3;
    }
  }

  if (gameState==3) { // This is the game over screen.
    fill(0, 200, 0);
    strokeWeight(2);
    textSize(70);
    textAlign(CENTER);
    text("Game Over", displayWidth/2, displayHeight/2);
    textSize(50);
    text("Score:", displayWidth/2-35, displayHeight/2+100);
    textAlign(LEFT);
    text(asteroidScore, displayWidth/2+55, displayHeight/2+100);
    image(GameOverScreen, width/2-400, height/2-55, 800, 80);

    textFade();
    fill(0, 200, 0, textFade);
    textAlign(CENTER);
    text("Press any key to return to Menu.", displayWidth/2, displayHeight/2+200);
    if (mousePressed==true) {
      currentScreen=1;
      gameMap=0;
      gameState=0;
    }
    if (keyPressed==true) {
      currentScreen=1;
      gameMap=0;
      gameState=0;
    }
  }
}



void asteroidShipPoint() {
  if (mouseX - width/2!=0) {
    if (mouseY>=height/2) {
      asteroidsShipAngle=degrees(acos((mouseX-width/2) / dist(mouseX, mouseY, width/2, height/2)));
    } else {
      asteroidsShipAngle=0-degrees(acos((mouseX-width/2) / dist(mouseX, mouseY, width/2, height/2)));
    }
  }
  pushMatrix();
  translate(width/2, height/2);
  rotateZ(radians(asteroidsShipAngle));
  sphereDetail(1);
  sphere(25);
  translate(10, 0, 0);
  sphere(20);
  translate(-20, 6, 0);
  sphere(7);
  translate(0, -12, 0);
  sphere(7);

  popMatrix();
}

class Rock {
  float rockPosX=width/2+random(-300, 300);
  float rockPosY=height/2+random(-300, 300);
  float rockAngle=random(0, 360);
  float rockDirection=0;
  int rockState=3;
  int rockSpeed=2;
  Rock() {
    float rockPosX=width/2+random(-300, 300);
    float rockPosY=height/2+random(-300, 300);
    float rockAngle=random(0, 360);
    float rockDirection=0;
    int rockState=3;
    int rockSpeed=2;
  }

  void display() {
    if (rockState!=0) {
      pushMatrix();
      translate(rockPosX, rockPosY, 0);
      rotateX(radians(rockAngle));
      rotateZ(radians(rockAngle));
      rotateY(radians(2*rockAngle));
      sphereDetail(6);
      sphere(20*rockState);
      popMatrix();
    }
  }

  void update() {
    rockAngle=rockAngle+1;
    if (rockAngle>360) {
      rockAngle=rockAngle-360;
    }
    if (rockState==0) {
      newRock();
      asteroidScore=asteroidScore+1;
    }
    if (rockPosX!=width/2) {
      if (width/2>=rockPosX) {
        rockDirection=degrees(atan((height/2-rockPosY) / (width/2 - rockPosX)));
      } else {
        rockDirection=degrees(atan((height/2-rockPosY) / (width/2 - rockPosX)))+180;
      }
    }
    rockPosX=rockPosX+int(rockSpeed*cos(radians(rockDirection)));
    rockPosY=rockPosY+int(rockSpeed*sin(radians(rockDirection)));

    if (dist(rockPosX, rockPosY, width/2, height/2)<rockState*20) {
      asteroidLives=asteroidLives-1;
      newRock();
    }
  }

  //x = cx + r * cos(a)
  void newRock() {
    randomAsteroidAngle=random(0, 360);
    rockPosX=width/2+350*cos(randomAsteroidAngle);
    rockPosY=height/2+350*sin(randomAsteroidAngle);
    rockState=3;
  }

  void shrinkRock() {
    if (rockState>0) {
      rockState=rockState-1;
    }
  }
}

void ringOfConcealment() {
  fill(0, 100, 0);
  stroke(0, 200, 0);
  pushMatrix();
  translate(width/2, height/2);
  for (int i=0; i<60; i=i+1) {
    rotateZ(radians(360/60));
    pushMatrix();
    translate(350, 0, 0);
    box(60, 60, 120);
    popMatrix();
  }
  popMatrix();
}
boolean bulletVisable=true;
class Bullets {

  float bulletSize;
  float bulletPosX=-500;
  float bulletPosY=-500;
  float bulletAngle;
  float bulletSpeed;
  float targetPosX;
  float targetPosY;
  int bulletVersion;

  Bullets() {
    float bulletSize=20;
    float bulletPosX=-500;
    float bulletPosY=-500;
    float bulletAngle=45;
    float bulletSpeed=10;
    float targetPosX;
    float targetPosY;
    int bulletVersion=1;
  }

  void display() {
    if (bulletVisable==true) {

      if (bulletVersion==1) {
        fill(0, 100, 0);
        noStroke();
        pushMatrix();
        translate(bulletPosX, bulletPosY, 0);
        rotateZ(radians(bulletAngle));
        sphere(bulletSize*0.5);
        popMatrix();
      }

      if (bulletVersion==2) {
        fill(100, 100, 100);
        noStroke();
        pushMatrix();
        translate(bulletPosX, bulletPosY, 0);
        rotateZ(radians(bulletAngle));
        for (int a=0; a<10; a=a+1) {
          rotateX(TAU/10);
          box(bulletSize*1.5, bulletSize, bulletSize);
        }
        translate(bulletSize*0.8, 0, 0);
        sphere(bulletSize*0.7);
        popMatrix();
      }
    }
  }

  void updatePos() {

    for (int i = 0; i < explosionPoints.length; i=i+1) {
      explosionPoints[i].update();
      explosionPoints[i].display();
    }
    explosionPoints[round(random(0, explosionPoints.length-1))].explosionFade();
    bullet1.detectCollision();
    if (bulletVisable==true) {
      if (bullet1.detectCollision()==254) {
        bulletPosX=bulletPosX+((targetPosX-bulletPosX)/10);
        bulletPosY=bulletPosY+((targetPosY-bulletPosY)/10);
      } else {
        if (bullet1.detectCollision()==255) {
          for (int i = 0; i < explosionPoints.length; i=i+1) {
            explosionPoints[i].newBoom(bulletPosX, bulletPosY);
          }
          bulletVisable=false;
        } else {
          for (int i = 0; i < explosionPoints.length; i=i+1) {
            explosionPoints[i].newBoom(bulletPosX, bulletPosY);
          }
          bulletVisable=false;
          if(gameMap==2){
          rock1[bullet1.detectCollision()].shrinkRock();
          }
          if(gameMap==4){
          myEnemyTank[bullet1.detectCollision()].newEnemyTank();
          tankScore=tankScore+1;
          }
        }
      }
    }

    if (mouseX!=width/2) {
      if (mouseX>=bulletPosX) {
        bulletAngle=degrees(atan((targetPosY-bulletPosY) / (targetPosX - bulletPosX)));
      } else {
        bulletAngle=degrees(atan((targetPosY-bulletPosY) / (targetPosX - bulletPosX)))+180;
      }
      bulletSize=20;
    }
  }

  int detectCollision() {
    if (gameMap==2) {
      for (int i = 0; i < asteroidNumber; i=i+1) {
        if ((dist(bulletPosX, bulletPosY, rock1[i].rockPosX, rock1[i].rockPosY)<=bulletSize+rock1[i].rockState*20)) {
          return i;
        }
      }
    }
    
    if (gameMap==4){
      for (int i = 0; i < enemyTankNumber; i=i+1) {
        if ((dist(bulletPosX, bulletPosY, myEnemyTank[i].enemyTankPosX, myEnemyTank[i].enemyTankPosY)<=bulletSize+30)) {
          return i;
        }
      }
    }

    if (dist(bulletPosX, bulletPosY, targetPosX, targetPosY)<=bulletSize) {
      return 255;
    }

    return 254;
  }

  void bulletReturn() {
    if (bullet1.bulletVersion==1) {
      bulletPosX=width/2;
      bulletPosY=height/2;
    }

    if (bullet1.bulletVersion==2) {
      bulletPosX=tankPosX;
      bulletPosY=tankPosY;
    }
  }
}
class Button {
  color buttonColor;
  float buttonX;
  float buttonY;
  float buttonWidth;
  float buttonHeight;
  int buttonValue;

  Button(color _buttonColor, float _buttonX, float _buttonY, float _buttonWidth, float _buttonHeight, int _buttonValue) {
    buttonColor=_buttonColor;
    buttonX=_buttonX;
    buttonY=_buttonY;
    buttonWidth=_buttonWidth;
    buttonHeight=_buttonHeight;
    buttonValue=_buttonValue;
  }

  void displayGameMapButton() {
    pushMatrix();
    shapeMode(CENTER);
    if (gameMap==buttonValue) {
      fill(0, 170, 0);
    } else {
      fill(0, 100, 0);
    }
    //stroke(0);
    //strokeWeight(5);
    if (((displayWidth/2+buttonX-buttonWidth/2 < mouseX) && (mouseX< displayWidth/2+buttonX+buttonWidth/2) && (displayHeight/2+buttonY-buttonHeight/2 < mouseY)&&(mouseY < displayHeight/2+buttonY+buttonHeight/2)) || (gameMap==buttonValue)) {
      translate(displayWidth/2+buttonX, displayHeight/2+buttonY, -20);
    } else {
      translate(displayWidth/2+buttonX, displayHeight/2+buttonY, 0);
    }
    box(buttonWidth, buttonHeight, 50);
    translate(0,0,30);
    box(buttonWidth-25, buttonHeight-25, 10);
    fill(0, 200, 0);
    strokeWeight(2);
    textSize(30);
    textAlign(CENTER);

    if (buttonValue==1) {
      text("Pong", buttonX*0.85, 0, 10);
    }
    if (buttonValue==2) {
      text("Asteroids", buttonX*0.85, 0, 10);
    }
    if (buttonValue==3) {
      text("Snake", buttonX*0.85, 0, 10);
    }
    if (buttonValue==4) {
      text("Tank", buttonX*0.85, 0, 10);
      text("Destroyer", buttonX*0.85, 40, 10);
    }

    popMatrix();
    if (((displayWidth/2+buttonX-buttonWidth/2 < mouseX) && (mouseX< displayWidth/2+buttonX+buttonWidth/2) && (displayHeight/2+buttonY-buttonHeight/2 < mouseY)&&(mouseY < displayHeight/2+buttonY+buttonHeight/2)) && (mousePressed==true)) {
      gameMap=buttonValue;
    }
  }
}
float explosionFadeTimer=0;
class ExplosionPoint {
  float trajectoryX;
  float trajectoryY;
  float trajectoryZ;
  float posX;
  float posY;
  float posZ;
  float pointColor;


  ExplosionPoint() {
    float trajectoryX = random(-3, 3);
    float trajectoryY = random(-3, 3);
    float trajectoryZ = random(0.1, 0.2);
    float posX = 0;
    float posY = 0;
    float posZ = 20;
    float pointColor = 0;
  }

  void display() {
    if (gameState==2) {
      if (explosionFadeTimer>0) {
        if (bullet1.bulletVersion==1) {
          fill(0, pointColor, 0, explosionFadeTimer);
        } else {
          fill(255, pointColor, 0, explosionFadeTimer);
        }
        noStroke();
        pushMatrix();
        translate(posX, posY, 0);
        box(posZ, posZ, posZ);
        popMatrix();
      }
    }
  }

  void newBoom(float bulletPosX, float bulletPosY) {
    posX = bulletPosX;
    posY = bulletPosY;
    posZ = 0;

    trajectoryX = random(-6, 6);
    trajectoryY = random(-6, 6);
    trajectoryZ = random(1, 2);

    pointColor = random(0, 255);
    explosionFadeTimer=255;
  }

  void update() {
    trajectoryX = trajectoryX*0.9;
    trajectoryY = trajectoryY*0.9;
    trajectoryZ = trajectoryZ*0.9;
    posX = posX+trajectoryX;
    posY = posY+trajectoryY;
    posZ = posZ+trajectoryZ;
  }

  void explosionFade() {
    if (  ( (trajectoryX<0.05)|| (trajectoryY<0.05) || (trajectoryZ<0.05)) && (explosionFadeTimer>=5) ) {
      explosionFadeTimer=explosionFadeTimer-5;
    }
  }
}
int startTimerValue=60;
int startTimerState=3;

void gameStartTimer() {
  if (startTimerValue==0) {
    startTimerState=startTimerState-1;
    startTimerValue=60;
    if (startTimerState==0) {
      gameState=2;
      for (int j = 0; j < asteroidNumber; j=j+1) {
      rock1[j].newRock();
    }
      startTimerValue=60;
      startTimerState=3;
    }
  }
  startTimerValue=startTimerValue-1;
  ellipseMode(CENTER);
  fill(0, 100, 0);
  stroke(0, 200, 0);
  strokeWeight(2);
  textAlign(CENTER);
  textSize(40);
  if (gameState==1) {  

    if (gameMap==1) {
      pushMatrix();
      translate(0, 0, -70);
      if (startTimerState==3) {
        arc(width/2, height/2, 300, 300, radians(-90), radians(270), PIE);
        translate(0, 0, 10);
        arc(width/2, height/2, 250, 250, radians(-90), radians(270), PIE);
        translate(0, 0, 10);
        arc(width/2, height/2, 200, 200, radians(-90), radians(-90+startTimerValue*6), PIE);
        fill(0, 100, 0);
      }


      if (startTimerState==2) {
        arc(width/2, height/2, 300, 300, radians(-90), radians(270), PIE);
        translate(0, 0, 10);
        arc(width/2, height/2, 250, 250, radians(-90), radians(-90+startTimerValue*6), PIE);
        fill(0, 100, 0);
      }


      if (startTimerState==1) {
        arc(width/2, height/2, 300, 300, radians(-90), radians(-90+startTimerValue*6), PIE);
        fill(0, 100, 0);
      }
      popMatrix();
    }

    if (gameMap==2) {
      pushMatrix();
      translate(width/2,height/2);
      sphereDetail(15);
      if (startTimerState==3) {
        rotateZ(radians(6*startTimerValue));
        sphere(120+startTimerValue);
      }


      if (startTimerState==2) {
        rotateZ(radians(-6*startTimerValue));
        sphere(60+startTimerValue);
      }


      if (startTimerState==1) {
        rotateZ(radians(6*startTimerValue));
        sphere(startTimerValue);
      }
      popMatrix();
    }

    if (gameMap==3) {
      pushMatrix();
      popMatrix();
    }

    if (gameMap==4) {
      pushMatrix();
      popMatrix();
    }
  }
}
int[] alien1={ 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 
  1, 0, 0, 1, 0, 0, 0, 1, 0, 0, 1, 0, 
  1, 0, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 
  1, 1, 1, 0, 1, 1, 1, 0, 1, 1, 1, 0, 
  1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 
  0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 
  0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 
  0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0};
float pixelAlien1Rotation=0;

class PixelObjectLoader {

  int objectSize;
  float centerPosX;
  float centerPosY;

  PixelObjectLoader() {
    int objectSize=100;
    float centerPosX=400;
    float centerPosY=400;
  }

  void updatePos() {
    //centerPosX=mouseX-(6*25);
    //centerPosY=mouseY-(6*25);
    centerPosX=width/2;
    centerPosY=height/2;
  }

  void display() {
    fill(0, 150, 0);
    stroke(0, 100, 0);
    strokeWeight(0.5);
    pushMatrix();
    translate(centerPosX, centerPosY, 0);
    rotateY(pixelAlien1Rotation);
    pixelAlien1Rotation=pixelAlien1Rotation+0.01;
    if (pixelAlien1Rotation>360) {
      pixelAlien1Rotation=pixelAlien1Rotation-360;
    }
    for (int y=0; y<8; y=y+1) {
      for (int x=0; x<12; x=x+1) {
        pushMatrix();
        if (alien1[x+(y*12)]==1) {
          translate(-(5*25)+x*25, -(5*25)+y*25, 0);
          box(22, 22, 22);
        }
        popMatrix();
      }
    }
    popMatrix();
  }
}
float ball1PosX=width/2;
float ball1PosY=height/2;
float ball1Angle=45;
float ball1Speed=10;
float ball1Size=25;
float paddleSize=200;
float paddle1PosY;
float paddle2PosY;
float yBoundaries=350;
float xBoundaries=500;
int pongScore=0;
float ballPosXWin1=0;
float ballPosYWin1=0;
float ballPosXWin2=0;
float ballPosYWin2=0;
float ballPosXWin3=0;
float ballPosYWin3=0;

void pongController() {

  textAlign(CENTER);
  textSize(40);
  fill(0, 200, 0);

  ballPosXWin3=ballPosXWin2;        // This section is the win conditional. There is a rare bug where the ball gets stuck on the enemy paddle, and this section checks for it and tells the player they won if it happens.
  ballPosYWin3=ballPosYWin2;
  ballPosXWin2=ballPosXWin1;
  ballPosYWin2=ballPosYWin1;
  ballPosXWin1=ball1PosX;
  ballPosYWin1=ball1PosY;
  if (gameState==2) {
    if ((abs(ballPosXWin3-ballPosXWin1)<5)&&(abs(ballPosYWin3-ballPosYWin1)<5)) {
      gameState=4;
    }
  }


  if (gameState==1) {
    gameStartTimer();
    paddle1();
    ball1PosX=width/2;
    ball1PosY=height/2;
    ball1Speed=10;
    pongScore=0;
    ball1Angle=random(-45, 45);
    ball1();
    paddle2();
  }


  if (gameState==2) {
    fill(0, 100, 0);
    stroke(0, 200, 0);
    paddle1();
    ball1Move();
    ball1();
    paddle2();
    text("Score:", 350, 175);
    text(pongScore, 450, 175);
  }


  if (gameState==3) {
    fill(0, 200, 0);
    strokeWeight(2);
    textSize(70);
    textAlign(CENTER);
    text("Game Over", displayWidth/2, displayHeight/2);
    textSize(50);
    text("Score:", displayWidth/2-35, displayHeight/2+100);
    textAlign(LEFT);
    text(pongScore, displayWidth/2+55, displayHeight/2+100);
    image(GameOverScreen, width/2-400, height/2-55, 800, 80);

    textFade();
    fill(0, 200, 0, textFade);
    textAlign(CENTER);
    text("Press any key to return to Menu.", displayWidth/2, displayHeight/2+200);
    if (mousePressed==true) {
      currentScreen=1;
      gameMap=0;
      gameState=0;
      pongScore=0;
    }
    if (keyPressed==true) {
      currentScreen=1;
      gameMap=0;
      gameState=0;
      pongScore=0;
    }
  }
  if (gameState==4) {
    fill(0, 200, 0);
    strokeWeight(2);
    textSize(70);
    textAlign(CENTER);
    text("You Win!!!", displayWidth/2, displayHeight/2);
    textSize(50);
    text("Score:", displayWidth/2-35, displayHeight/2+100);
    textAlign(LEFT);
    text(pongScore, displayWidth/2+55, displayHeight/2+100);

    textFade();
    fill(0, 200, 0, textFade);
    textAlign(CENTER);
    text("Press any key to return to Menu.", displayWidth/2, displayHeight/2+200);
    if (mousePressed==true) {
      currentScreen=1;
      gameMap=0;
      gameState=0;
      pongScore=0;
    }
    if (keyPressed==true) {
      currentScreen=1;
      gameMap=0;
      gameState=0;
      pongScore=0;
    }
  }
}


void paddle1() {
  if ((mouseY<=yBoundaries+height/2-paddleSize/2) && (mouseY>=-yBoundaries+height/2+paddleSize/2)) {
    paddle1PosY=mouseY;
  } else {
    if (mouseY>yBoundaries+height/2-paddleSize/2) {
      paddle1PosY=yBoundaries+height/2-paddleSize/2;
    }
    if (mouseY<-yBoundaries+height/2+paddleSize/2) {
      paddle1PosY=-yBoundaries+height/2+paddleSize/2;
    }
  }
  pushMatrix();
  translate(width/2-xBoundaries, paddle1PosY, 0);
  box(20, paddleSize, 20);
  popMatrix();
}

void ball1() {
  noStroke();
  pushMatrix();
  translate(ball1PosX, ball1PosY, 0);
  sphere(ball1Size);
  popMatrix();
}

void ball1Move() {
  if ((ball1PosX+int(ball1Speed*cos(radians(ball1Angle)))<=width/2+xBoundaries-ball1Size)
    &&(ball1PosX+int(ball1Speed*cos(radians(ball1Angle)))>=width/2-xBoundaries+ball1Size) 
    &&(ball1PosY+int(ball1Speed*sin(radians(ball1Angle)))<=height/2+yBoundaries-ball1Size)
    &&(ball1PosY+int(ball1Speed*sin(radians(ball1Angle)))>=height/2-yBoundaries+ball1Size)) {

    ball1PosX=ball1PosX+int(ball1Speed*cos(radians(ball1Angle)));
    ball1PosY=ball1PosY+int(ball1Speed*sin(radians(ball1Angle)));
  } else {
    if (ball1PosX+int(ball1Speed*cos(radians(ball1Angle)))>width/2+xBoundaries-ball1Size) {
      ball1Angle=ball1Angle/abs(ball1Angle)*180-ball1Angle;
    }
    if (ball1PosX+int(ball1Speed*cos(radians(ball1Angle)))<width/2-xBoundaries+ball1Size) {
      if ((ball1PosY<=paddle1PosY+paddleSize/2)&&(ball1PosY>=paddle1PosY-paddleSize/2)) {
        ball1Angle=(0+ball1PosY-paddle1PosY)*0.8;
        pongScore=pongScore+1;
        ball1Speed=ball1Speed+1;
      } else {
        gameState=3;
      }
    }
    if (ball1PosY+int(ball1Speed*sin(radians(ball1Angle)))>height/2+yBoundaries-ball1Size) {
      ball1Angle=-ball1Angle;
    }
    if (ball1PosY+int(ball1Speed*sin(radians(ball1Angle)))<height/2-yBoundaries+ball1Size) {
      ball1Angle=-ball1Angle;
    }
    //ball1Move();
  }
}


void paddle2() {
  stroke(0, 200, 0);
  if ((ball1PosY<=yBoundaries+height/2-paddleSize/2) && (ball1PosY>=height/2-yBoundaries+paddleSize/2)) {
    paddle2PosY=ball1PosY;
  }
  if (ball1PosY>yBoundaries+height/2-paddleSize/2) {
    paddle2PosY=yBoundaries+height/2-paddleSize/2;
  }
  if (ball1PosY<height/2-yBoundaries+paddleSize/2) {
    paddle2PosY=-yBoundaries+height/2+paddleSize/2;
  }
  pushMatrix();
  translate(width/2+xBoundaries, paddle2PosY, 0);
  box(20, paddleSize, 20);
  popMatrix();
}
int snakeScore=0;
void snakeController() {
  textAlign(CENTER);
  textSize(40);
  fill(0, 200, 0);

  fill(0, 200, 0);
  strokeWeight(2);
  textSize(40);
  textAlign(CENTER);
  text("Coming Soon...", displayWidth/2, displayHeight/2+200);
  image(snakeBackground, width/2-500, height/2-75, 1000, 150);
  if(mousePressed==true){
  currentScreen=1;
  gameState=0;
  }
}
int tankScore=0;
float tankPosX=width/2;
float tankPosY=height/2;
float tankWheelRotation=0;
float tankAngle=0;
float tankSpeed=2;
float barrelAngle=0;
int tankLives=5;
int enemyTankNumber=1;
void tankDestroyerController() {

  if (gameState==1) {
    textAlign(CENTER);
    textSize(40);
    fill(0, 200, 0);
    text("Score:", 350, 175);
    text(tankScore, 450, 175);
    gameStartTimer();
    tank();
    bullet1.updatePos();
    bullet1.display();
    tankPosX=width/2;
    tankPosY=height/2;
    enemyTankNumber=1;
    tankScore=0;
    tankLives=5;
    for (int j = 0; j < enemyTankNumber; j=j+1) {
      myEnemyTank[j].newEnemyTank();
    }
    pushMatrix();
    translate(0, 0, -20);
    image(tankBackground, width/2-600, height/2-350, 1200, 700);
    popMatrix();
  }

  if (gameState==2) {
    textAlign(CENTER);
    textSize(40);
    fill(0, 200, 0);
    text("Score:", 350, 175);
    text(tankScore, 450, 175);
    text("Lives:", 350, 225);
    text(tankLives, 450, 225);
    tank();
    for (int j = 0; j < enemyTankNumber; j=j+1) {
      myEnemyTank[j].update();
      myEnemyTank[j].display();
    }
    bullet1.updatePos();
    bullet1.display();

    if (mousePressed==true) {
      bulletVisable=true;
      bullet1.targetPosX=mouseX;
      bullet1.targetPosY=mouseY;
      bullet1.bulletVersion=2;
      bullet1.bulletReturn();
    }

    if (tankLives==0) {
      gameState=3;
    }
    pushMatrix();
    translate(0, 0, -20);
    image(tankBackground, width/2-600, height/2-350, 1200, 700);
    popMatrix();
    if (myTimer.isFinished()) {
      myTimer.timerStart();
      if (enemyTankNumber<=9) {
        enemyTankNumber=enemyTankNumber+1;
      }
    }
  }

  if (gameState==3) { // This is the game over screen.
    fill(0, 200, 0);
    strokeWeight(2);
    textSize(70);
    textAlign(CENTER);
    text("Game Over", displayWidth/2, displayHeight/2);
    textSize(50);
    text("Score:", displayWidth/2-35, displayHeight/2+100);
    textAlign(LEFT);
    text(tankScore, displayWidth/2+55, displayHeight/2+100);
    image(GameOverScreen, width/2-400, height/2-55, 800, 80);

    textFade();
    fill(0, 200, 0, textFade);
    textAlign(CENTER);
    text("Press any key to return to Menu.", displayWidth/2, displayHeight/2+200);
    if (mousePressed==true) {
      currentScreen=1;
      gameMap=0;
      gameState=0;
      tankScore=0;
      tankLives=5;
    }
    if (keyPressed==true) {
      currentScreen=1;
      gameMap=0;
      gameState=0;
    }
  }
}

void tank() {
  if (keyPressed==true) {
    if (keyCode==LEFT) {
      tankAngle=tankAngle-2;
    }
    if (keyCode==RIGHT) {
      tankAngle=tankAngle+2;
    }
    if (keyCode==UP) {
      if ((tankPosX+(tankSpeed*cos(radians(tankAngle)))>width/2-545)&&
        (tankPosX+(tankSpeed*cos(radians(tankAngle)))<width/2+545)&&
        (tankPosY+(tankSpeed*sin(radians(tankAngle)))>height/2-320)&&
        (tankPosY+(tankSpeed*sin(radians(tankAngle)))<height/2+320)) {
        tankPosX=tankPosX+(tankSpeed*cos(radians(tankAngle)));
        tankPosY=tankPosY+(tankSpeed*sin(radians(tankAngle)));
      }
    }
    if (keyCode==DOWN) {
      if ((tankPosX-(tankSpeed*cos(radians(tankAngle)))>width/2-545)&&
        (tankPosX-(tankSpeed*cos(radians(tankAngle)))<width/2+545)&&
        (tankPosY-(tankSpeed*sin(radians(tankAngle)))>height/2-320)&&
        (tankPosY-(tankSpeed*sin(radians(tankAngle)))<height/2+320)) {
        tankPosX=tankPosX-(tankSpeed*cos(radians(tankAngle)));
        tankPosY=tankPosY-(tankSpeed*sin(radians(tankAngle)));
      }
    }
  }

  fill(100, 150, 100);
  stroke(100, 100, 100);
  tankWheelRotation=tankWheelRotation+5;
  if (tankWheelRotation>360) {
    tankWheelRotation=tankWheelRotation-360;
  }
  pushMatrix();
  translate(tankPosX, tankPosY);
  rotateZ(radians(tankAngle));
  box(70, 40, 10);
  noStroke();
  translate(0, 0, -5);
  sphere(20);
  stroke(50);
  pushMatrix();
  if (mouseX!=tankPosX) {
    if (mouseY>=tankPosY) {
      //barrelAngle=degrees(atan((mouseY-tankPosY) / (mouseX - tankPosX)));
      barrelAngle=(acos((mouseX-tankPosX) / dist(mouseX, mouseY, tankPosX, tankPosY)));
    } else {
      barrelAngle=0-(acos((mouseX-tankPosX) / dist(mouseX, mouseY, tankPosX, tankPosY)));
      //barrelAngle=180+degrees(atan((mouseY-tankPosY) / (mouseX - tankPosX)));
    }
  }
  rotateZ(barrelAngle-radians(tankAngle));
  translate(10, 0, 15);
  box(10, 5, 5);
  popMatrix();
  translate(-20, 0, 0);
  pushMatrix();
  fill(50);
  stroke(50);
  rotateY(radians(tankWheelRotation));
  box(10, 50, 10);
  box(2, 54, 2);
  popMatrix();
  translate(20, 0, 0);
  pushMatrix();
  rotateY(radians(tankWheelRotation));
  box(10, 50, 10);
  box(2, 54, 2);
  popMatrix();
  box(55, 50, 12);
  translate(20, 0, 0);
  pushMatrix();
  rotateY(radians(tankWheelRotation));
  box(10, 50, 10);
  box(2, 54, 2);
  popMatrix();
  popMatrix();
}

class EnemyTank {
  float enemyTankPosX=random(width/2-320, width/2+320);
  float enemyTankPosY=height/2-350;
  int enemyTankSpeed=1;
  EnemyTank() {
    float enemyTankPosX=random(width/2-320, width/2+320);
    float enemyTankPosY=height/2-350;
    int enemyTankSpeed=1;
  }

  void display() {
    fill(150, 100, 100);
    pushMatrix();
    translate(enemyTankPosX, enemyTankPosY, 0);
    rotateZ(radians(90));
    box(70, 40, 10);
    noStroke();
    translate(0, 0, -5);
    sphere(20);
    box(10, 5, 5);
    translate(-20, 0, 0);
    fill(50);
    stroke(50);
    box(10, 50, 10);
    box(2, 54, 2);
    translate(20, 0, 0);
    box(10, 50, 10);
    box(2, 54, 2);
    box(55, 50, 12);
    translate(20, 0, 0);
    box(10, 50, 10);
    box(2, 54, 2);
    popMatrix();
  }

  void update() {
    enemyTankPosY=enemyTankPosY+enemyTankSpeed;
    if (enemyTankPosY>height/2+350) {
      tankLives=tankLives-1;
      newEnemyTank();
    }
  }
  void newEnemyTank() {
    enemyTankPosX=random(width/2-320, width/2+320);
    enemyTankPosY=height/2-350;
  }
}
