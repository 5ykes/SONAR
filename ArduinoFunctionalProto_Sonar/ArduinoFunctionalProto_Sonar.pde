  
import processing.sound.*;
import processing.serial.*;
//Begin JonF Code
// We communicate with the Arduino via the serial port
Serial _serialPort;

// Our serial port index (this will change depending on your computer)
final int ARDUINO_SERIAL_PORT_INDEX = 7; 
int _xPos = 0;
int _currentDist = 0; // in cm
final int MAX_SENSOR_VAL = 400; // in cm

PImage img;
PImage[] bat = new PImage[8];
PImage apple;
PImage apple2;
PImage bg; //end JonF Code

PFont f;

  SoundFile file;
  //put your audio file name here
  String batsound = "BatSounds.mp3";
  String path;

void setup(){
  size(1200, 800);
  //fullScreen();
  
  // Open the serial port
  _serialPort = new Serial(this, Serial.list()[ARDUINO_SERIAL_PORT_INDEX], 9600);
  //background
   bg = loadImage("back_cave_0.png");
   
  smooth(); //code syntax via Proccesing.org
  img = loadImage( "bat_gif.gif" );
  bat[0] = loadImage( "batgif1.png" );
  bat[1] = loadImage( "batgif2.png" );
  bat[2] = loadImage( "batgif4.png" );
  bat[3] = loadImage( "batgif5.png" );
  bat[4] = loadImage( "batgif7.png" );
  bat[5] = loadImage( "batgif8.png" );
  bat[6] = loadImage( "batgif9.png" );
  frameRate( 10 );
  
  apple = loadImage("apple.png"); //apple load
  apple2 = loadImage("apple2.png"); //apple2 load
  
  f = createFont("Arial",16,true); // via Processing.org
  
}

void draw(){
  background(bg);
  
  //Dynamic Rectangle - Base code via Processing.org 
  int xPos = 400;
  int yPos = 300;
  float maxBarWidth = width - xPos;
  float barWidth = maxBarWidth * (_currentDist / (float)MAX_SENSOR_VAL); //bar length based on total width of window * (varialbe distance / longest possible distance)
 
  //rect(xPos, yPos, barWidth, 30); //rect (x_loc, y_loc, width, length)
  
  //Bat animation
  image(bat[frameCount & 6], 0, 200 ); //call batgif from setup image - 
                                                                                               
  //begin Processing conditional code 
  if ((maxBarWidth * (_currentDist / (float)MAX_SENSOR_VAL)) > 301){                           //far distance and no reading, absorbent object
    //rect(xPos, yPos, barWidth, 30); //rect (x_loc, y_loc, width, length)
    String s = "I'm hungry but I can't see anything to eat!";
    fill(255);
    text(s, 150, 420, 230, 80);  // Text wraps within text box
  }
  if((maxBarWidth * (_currentDist / (float)MAX_SENSOR_VAL)) <= 300 && (maxBarWidth * (_currentDist / (float)MAX_SENSOR_VAL)) > 50){ //Medium distance: translucent object
    image(apple2,1000, 250, 200, 200); //appleimage
    //tint(255, 127);  // Display at half opacity
    rect(xPos, yPos, 2*(barWidth), 30);                   //rect (x_loc, y_loc, width, length)
    String s = "I see a snack, but its a little far away!";
    fill(255);
    text(s, 150, 420, 230, 80);                      // font tutorial from processing.org
    textFont(f,16);                                  // STEP 3 Specify font to be used
    fill(255);                                           // STEP 4 Specify font color 
    text(barWidth,550,400);
    text("cm", 570, 415);   // Display Text
  }
  if ((maxBarWidth * (_currentDist / (float)MAX_SENSOR_VAL)) < 50){ //short distance: solid object
    image(apple,1000, 250, 200, 200);
    rect(xPos, yPos, 2*(barWidth), 30); //rect (x_loc, y_loc, width, length)
    String s = "Found it! Dinner time!";
    fill(255);
    text(s, 150, 420, 230, 80);  // Text wraps within text box
    textFont(f,16);                  // STEP 3 Specify font to be used
    fill(255);                         // STEP 4 Specify font color 
    text(barWidth,550,400);
    text("cm", 570, 415);   // STEP 5 Display Text
  }

  println(barWidth);
  
}
//Jon F class Code
/**
* Called automatically when new data is received over the serial port. 
*/
void serialEvent (Serial _serialPort) {
  try {
    // Grab the data off the serial port. See: 
    // https://processing.org/reference/libraries/serial/index.html
    String inString = trim(_serialPort.readStringUntil('\n'));
    
    if(inString != null){
      _currentDist = int(inString);// convert to a float
      //_inLength = _serialPort.readStringUntil(",");
      println(inString);
    }
  }
  catch(Exception e) {
    println(e);
  }
}
