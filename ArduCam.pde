import processing.serial.*;
import java.nio.charset.Charset;

private final Charset ASCII_CHARSET = Charset.forName("ISO-8859-1");

Serial myPort = null;
PImage finalImage;
long lastTime = 0;

byte[] buffer;
int index = 0;


void setup(){
  size(320, 240);
  frameRate(1);
  
  // List all the available serial ports
  printArray(Serial.list());
  
  // Open the port you are using at the rate you want:
  myPort = new Serial(this, Serial.list()[2], 921600);
  delay(2000);
  readImage();
}


void draw(){
  image(finalImage, 0, 0);
  
  if(millis() - lastTime > 2000){
    readImage();
    lastTime = millis();
  }
  
}


void readImage(){
  index=0;
  buffer = new byte[8192];
  
  myPort.write(0x10); //Send command to capture image
  delay(1750); //This is essential!
  
  int ch = -1;
  while(myPort.available() > 0){
    ch = myPort.read();
    //print((char)ch);
    buffer[index] = (byte)ch;
    index++;
  }
 
  String s = new String(buffer, ASCII_CHARSET);
  int start = s.lastIndexOf("ACK IMG END\r") + 13;
  //println(s);
  
  byte[] result = new byte[index-start];
  System.arraycopy(buffer, start, result, 0, index-start);
  saveBytes("image.jpg", result);
  
  finalImage = loadImage("image.jpg");
  //println("--------------------------------------------------------------------------------------------------------------------------");
  
}