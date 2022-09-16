/*
TITLE: Calculated Attack
AUTHOR: Kyle Koon
DATE DUE: 2/18/21
DATE SUBMITTED: 2/18/21
COURSE TITLE: Game Design
MEETING TIME(S): Mon. and Wed. at 2pm
DESCRIPTION: This program creates the Calculated Attack Game. In this game, the user must solve math problems to kill off the attacking goblins.
There are three different levels of goblins with varying difficulties of math problems. The easiest goblin/problems move the fastest. The hardest move the slowest.
The objective of the game is to defeat all of the goblins (solve all the math problems) and save your castle. The user must click on lane 1, 2, or 3, type their answer, and press enter.
If it is correct, the goblin will be defeated. If not, the goblin will continue to approach. Complete all three levels and you win!
HONOR CODE: On my honor, I neither gave nor received unauthorized aid on this assignment. Signature: Kyle Koon
*/


import java.util.Random;

boolean setup = false;
boolean clicked = false;
int selectedLane = -1;

int enemiesRemaining = 0;
int health = 0;

int scene = 1;
int level = 0;
int numLanes = 3;

PImage goblin1;
PImage goblin2;
PImage goblin3;
PImage grass;
PImage startCastle;
PImage castle;
PImage skyBackground;

String[][] easyEqs = new String[][]{{"x+3=0","-3"},{"x/2=10","20"},{"5x=20","4"},{"2x-7=3","5"},{"x^3=8","2"},{"x/3=9","27"},{"(1/2)x^2=8","4"},{"9x+3=3","0"}}; //2 dimensional array that stores easy equations and their solution
String[][] mediumEqs = new String[][]{{"(x-2)(x-2)=0","2"},{"x^2+6x+9","-3"},{"x^2-2x+1","-1"},{"sin(0)","0"},{"sin(90)","1"},{"sin(pi)","0"},{"sin(270)","-1"},{"cos(0)","1"},{"cos(pi/2)","0"},{"cos(180)","-1"},{"cos((3/2)pi)","0"},{"sin^2(x)+cos^2(x)","1"}}; //2 dimensional array that stores medium equations and their solution
String[][] hardEqs = new String[][]{{"d/dx((1/3)x^2)","(2/3)x"},{"d/dx(e^x)","e^x"},{"d/dx(sin(x))","cos(x)"},{"integral(x^2)}","(1/3)x^3"},{"d/dx(tan(x))","sec^2(x)"},{"d/dx(ln(x))","1/x"},{"integral(sin(x))","-cos(x)"},{"integral(cos(x))","sin(x)"}}; //2 dimensional array that stores hard equations and their solution

Enemy[] enemies = new Enemy[3]; //stores the three enemy objects
textField[] fields = new textField[3]; //stores the three textField objects

class textField{
  private int x;
  private int y;
  private String name;
  private String typed = ""; //stores what the user has typed in this text field
  
  textField(int tempX, int tempY, String tempName){
    x = tempX;
    y = tempY;
    name = tempName; //name of the lane (ex: Lane 1)
  }
  void drawField(){
    text(name + " " + typed,x,y); //displays the text on-screen
  }
  
  void updateField(char txt){ //adds txt to the text field
    typed += txt;
  }
  
  void backSpace(){ //removes the last letter in the text field
    if(typed.length() > 0){
      typed = typed.substring(0,typed.length()-1);
    }
  }
  
  void resetField(){ //clears the text in the text field
    typed = "";
  }
}

class Enemy{
  private PImage img;
  private Equation eq; //stores the equation related to an enemy object
  private float x;
  private float y;
  private int difficulty;
  private int lane; //the current lane that the enemy object occupies
  private float dy; //change in the enemy's y position
  
  Enemy(int diff, int ln){
    difficulty = diff;
    lane = ln;
    
    //sets movement speed based on the difficulty of the enemy. Harder enemies move slower
    if(difficulty == 1){
      img = goblin1; //the goblin1 image is the easiest goblin
      dy = 1.5;
    }
    else if(difficulty == 2){
      img = goblin2; //the goblin2 image is the medium goblin
      dy = 1;
    }
    else{
      img = goblin3; //the goblin3 image is the hardest goblin
      dy = .5;
    }
    
    x = (lane-1)*(width/numLanes); //x position of the enemy is based on the lane it occupies
    y = 20; //initial y position is set
    
    eq = getEquation(difficulty); //a random equation is selected based on the difficulty level of the enemy
  }
  
  void drawEnemy(){
    image(img,x,y); //the enemy is displayed on-screen
    y += dy; //the y-position of the enemy increases (moves down the screen)
  }
}


class Equation {
  private String problem;
  private String answer;
  
  Equation(String prob, String ans){
    problem = prob;
    answer = ans;
  }
  
  String getProblem(){
    return problem;
  }
  
  String getAnswer(){
    return answer;
  }
}


Equation getEquation (int difficulty) { //creates and returns an equation object based on the difficulty passed into the function
  Random rand = new Random();
  Equation eq = null;
  if(difficulty == 1){
    int i = rand.nextInt(easyEqs.length); //picks a random index within the easy equations array
    eq = new Equation(easyEqs[i][0],easyEqs[i][1]); //creates an equation object based on the randomly selected index
  }
  else if(difficulty == 2){
    int i = rand.nextInt(mediumEqs.length); //picks a random index within the medium equations array
    eq = new Equation(mediumEqs[i][0],mediumEqs[i][1]); //creates an equation object based on the randomly selected index
  }
  else if(difficulty == 3){
    int i = rand.nextInt(hardEqs.length); //picks a random index within the hard equations array
    eq = new Equation(hardEqs[i][0],hardEqs[i][1]); //creates an equation object based on the randomly selected index
  }
  return eq; //returns the equation object
}


boolean checkAnswer(String txt){ //checks if a string is equal to the solution of an equation
  for(int i = 0; i < enemies.length; i++){ //iterates through the current enemies on-screen
    if(enemies[i].lane == selectedLane){ //picks the enemy in the lane that the user has selected
      if(enemies[i].eq.getAnswer().equals(txt)){ //checks if the answer of the equation corresponding to this enemy is equal to txt
        return true; //the user answered correctly
      }
    }
  }
  return false; //the user answered incorrectly
}

boolean offScreen(Enemy enemy){ //checks if the enemy image has gone off the screen
  if(enemy.y > height){
    return true;
  }
  return false;
}

int pickDifficulty(int level){ //randomly pick a difficulty level for the enemies depending on the level of the game
  Random rand = new Random();
  int selectedIndex = -1;
  if(level == 1){
    int[] weights = {85, 13, 2}; //easy enemies will be more prevalent
    int rnd = rand.nextInt(100);
    
    for(int i = 0; i < weights.length; i++){ //iterates through the weights
      if(rnd < weights[i]){
        selectedIndex = i;
        break;
      }
      rnd -= weights[i];
    }
  }
  else if(level == 2){
    int[] weights = {25,40,35}; //medium enemies should be most prevalent
    int rnd = rand.nextInt(100);
    
    for(int i = 0; i < weights.length; i++){
      if(rnd < weights[i]){
        selectedIndex = i;
        break;
      }
      rnd -= weights[i];
    }
  }
  else if(level == 3){
    int[] weights = {10, 30, 60}; //hard enemies should be most prevalent
    int rnd = rand.nextInt(100);
    
    for(int i = 0; i < weights.length; i++){
      if(rnd < weights[i]){
        selectedIndex = i;
        break;
      }
      rnd -= weights[i];
    }
  }
  int difficulty = selectedIndex + 1; //difficulties range from 1-3 so we add 1 to the index which ranges from 0-2
  return difficulty;
}


void mousePressed(){
  if(scene!=1 && scene!=2 && scene!=4 && scene!=6){ //runs if the user is in a level and not on a cutscene
    for(int i = 0; i < fields.length; i++){ //iterates through the three textfields
      if(mouseX > fields[i].x - 25 && mouseX < fields[i].x + 200){ //checks if mouse is within the text field in the x direction
        clicked = true; //signifies that a text field has been selected
        selectedLane = i+1; //selected lane is set to the field index + 1 becuase lanes range from 1-3 but indeces range from 0-2
      }
    }
  }
}


void keyPressed(){
  if(clicked){ //runs if a text field has been selected
    if(key != '\n'){ //runs if the user has not pressed enter
      if(key == BACKSPACE){ //checks if the user has pressed the backspace key
        fields[selectedLane-1].backSpace(); //deletes the last character that the user typed
      }
      else if(key == CODED){
        if(keyCode == SHIFT){ //if the user presses shift, a space is not created
        }
      }
      else{
        fields[selectedLane-1].updateField(key); //the textfield is updated based on the key that the character pressed (character that they entered)
      }
    }
    else{ //runs if the user presses enter
      if(checkAnswer(fields[selectedLane-1].typed)){ //checks to see if the string in the textfield is the correct answer to that lane's math problem
        int i = pickDifficulty(level); //a new difficulty is picked
        enemies[selectedLane-1] = new Enemy(i,selectedLane); //a new enemy is created to replace the previous one in this lane
        enemiesRemaining -= 1;
        if(enemiesRemaining == 0){
          scene+=1; //the user advances to the next level
        }
      }
      fields[selectedLane-1].resetField(); //the text field for the current lane is cleared
      clicked = false; //the text field is no longer active. It must be selected again.
    }
  }
}

void scene1(){
  background(0);
  image(skyBackground,0,0);
  image(startCastle,0,0);
  textAlign(CENTER);
  textSize(75);
  fill(0);
  text("Calculated Attack",width/2+10,800);
  textSize(30);
  text("Click to continue!",width/2+10,850);
  if(mousePressed){
    delay(500); //delay so that mousePressed can return to false
    scene+=1;
  }
}

void scene2(){
  fill(255);
  background(0);
  image(grass,0,0);
  textAlign(LEFT);
  textSize(70);
  text("Rules: ", 50,100);
  textSize(20);
  text("Goblins are trying to storm your castle. Kill them off by clicking on a lane and solving \nthe approacing math problem. " +
      "Enter a value of x that satisfies the equation \nor enter the appropriate function. \n\nPut parentheses around fractions \nex: (1/3)x" +
      "\nUse ^ for exponents \nex: e^x \nThere is no need for the multiplication sign \nex: (1/3)x not (1/3)*x" +
      "\nPress enter after typing your answer. If it is incorrect, you must select the lane again", 50, 200);
  textAlign(CENTER);
  textSize(20);
  text("Click your mouse to begin!", width/2, height-100);
   if(mousePressed){ //issue here
    scene+=1;
  }
}

void scene3(){
  level = 1;
  background(0);
  image(grass,0,0);
  image(castle,0,800);
  textAlign(LEFT);
  textSize(15);
  if(!setup){ //runs if have not been created yet
    //enemies of difficulty 1 are created
    enemies[0] = new Enemy(1,1);
    enemies[1] = new Enemy(1,2);
    enemies[2] = new Enemy(1,3);
    
    //three text fields (lanes) are created
    fields[0] = new textField(5,790,"Lane 1:");
    fields[1] = new textField(width/3-45,790,"Lane 2:");
    fields[2] = new textField(2*width/3-45,790,"Lane 3:");
    
    enemiesRemaining = 5;
    health = 10;
    
    setup = true; //setup is now complete
  }
  
  for(int i = 0; i < enemies.length; i++){
    enemies[i].drawEnemy(); //draws the enemies on screen
    text(enemies[i].eq.getProblem(),enemies[i].x,enemies[i].y-5); //places the equation for the current enemy slightly above the enemy's image
    
    if(offScreen(enemies[i])){ //checks if the enemy has gone off the screen
      health -= enemies[i].difficulty; //decreases the player's health according to the difficulty of the enemy
      int q = pickDifficulty(1); //a new difficulty is picked based on the player being in level 1
      enemies[i] = new Enemy(q,i+1); //a new enemy is created and placed into the same lane
    }
  }
  
  for(int i = 0; i < fields.length; i++){
    fields[i].drawField(); //the text fields are drawn
  }
  
  text("Enemies Remaining: " + enemiesRemaining, width-175, 100);
  textSize(20);
  text("Health: " + health, width-125, 790);
  if(health <= 0){
    scene = 9; //goes directly to the defeat scene
  }
    
}

void scene4(){
  background(0);
  textAlign(CENTER);
  textSize(70);
  text("Level 1 Complete!", width/2, height/2);
  textSize(30);
  text("Click to continue!",width/2, height/2+50);
  
  setup = false; //setup is reset to false before the next scene
  
  if(mousePressed){
    scene+=1;
  }
}

void scene5(){
  level = 2;
  background(125);
  image(grass,0,0);
  image(castle,0,800);
  textAlign(LEFT);
  textSize(15);
  if(!setup){
    
    //randomize this
    enemies[0] = new Enemy(2,1);
    enemies[1] = new Enemy(2,2);
    enemies[2] = new Enemy(2,3);
    
    fields[0] = new textField(5,790,"Lane 1:");
    fields[1] = new textField(width/3-45,790,"Lane 2:");
    fields[2] = new textField(2*width/3-45,790,"Lane 3:");
    
    enemiesRemaining = 10;
    health = 10;
    
    setup = true;
  }
  
  for(int i = 0; i < enemies.length; i++){
    enemies[i].drawEnemy();
    text(enemies[i].eq.getProblem(),enemies[i].x,enemies[i].y-5);
    
    if(offScreen(enemies[i])){
      health -= enemies[i].difficulty;
      int q = pickDifficulty(2);
      enemies[i] = new Enemy(q,i+1);
    }
  }
  
  for(int i = 0; i < fields.length; i++){
    fields[i].drawField();
  }
  
  text("Enemies Remaining: " + enemiesRemaining, width-175, 100);
  textSize(20);
  text("Health: " + health, width-125, 790);
  if(health <= 0){
    scene = 9;
  }
}

void scene6(){
  background(0);
  textAlign(CENTER);
  textSize(70);
  text("Level 2 Complete!", width/2, height/2);
  textSize(30);
  text("Click to continue!",width/2, height/2+50);
  
  setup = false;
  
  if(mousePressed){
    scene+=1;
  }
}

void scene7(){
  level = 3;
  background(125);
  image(grass,0,0);
  image(castle,0,800);
  textAlign(LEFT);
  textSize(15);
  if(!setup){
    
    enemies[0] = new Enemy(3,1);
    enemies[1] = new Enemy(3,2);
    enemies[2] = new Enemy(3,3);
    
    fields[0] = new textField(5,790,"Lane 1:");
    fields[1] = new textField(width/3-45,790,"Lane 2:");
    fields[2] = new textField(2*width/3-45,790,"Lane 3:");
    
    enemiesRemaining = 15;
    health = 10;
    
    setup = true;
  }
  
  for(int i = 0; i < enemies.length; i++){
    enemies[i].drawEnemy();
    text(enemies[i].eq.getProblem(),enemies[i].x,enemies[i].y-5);
    
    if(offScreen(enemies[i])){
      health -= enemies[i].difficulty;
      int q = pickDifficulty(3);
      enemies[i] = new Enemy(q,i+1);
    }
  }
  
  for(int i = 0; i < fields.length; i++){
    fields[i].drawField();
  }
  
  text("Enemies Remaining: " + enemiesRemaining, width-175, 100);
  textSize(20);
  text("Health: " + health, width-125, 790);
  if(health <= 0){
    scene = 9;
  }
}

void scene8(){
  background(0);
  textAlign(CENTER);
  textSize(50);
  text("You've beat the goblins! \nThe castle is safe!", width/2, height/2);
}

void scene9(){
  background(0);
  textAlign(CENTER);
  textSize(50);
  text("You've been defeated by goblins! \nThe castle is destroyed!", width/2, height/2);
}

void setup(){
  size(900,900);
  
  //loads and resizes the various images
  goblin1 = loadImage("goblin1.png");
  goblin1.resize(100,0);
  goblin2 = loadImage("goblin2.png");
  goblin2.resize(100,0);
  goblin3 = loadImage("goblin3.png");
  goblin3.resize(100,0);
  grass = loadImage("grass.png");
  grass.resize(width,height);
  castle = loadImage("castle.jpg");
  castle.resize(width,100);
  startCastle = loadImage("startCastle.png");
  startCastle.resize(width,height-150);
  skyBackground = loadImage("skyBackground.jpg");
  skyBackground.resize(width,height);
}

void draw(){
  switch(scene){ //runs if the scene number changes
    case 1:
      scene1();
      break;
    case 2:
      scene2();
      break;
    case 3:
      scene3();
      break;
    case 4:
      scene4();
      break;
    case 5:
      scene5();
      break;
    case 6:
      scene6();
      break;
    case 7:
      scene7();
      break;
    case 8:
      scene8();
      break;
    case 9:
      scene9();
      break;
  }
}
