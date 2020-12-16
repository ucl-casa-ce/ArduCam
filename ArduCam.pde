import processing.serial.*;

Serial myPort = null;
PImage finalImage;
long lastTime = 0;

byte[] buffer;

void setup(){
  size(320, 240);
  frameRate(1);
  
  // List all the available serial ports
  printArray(Serial.list());
  
  // Open the port you are using at the rate you want:
  myPort = new Serial(this, Serial.list()[2], 921600);
  delay(200);
  myPort.write(0x02); //Set image size: 0x00=160x120; 0x01=176x144; 0x02=320x240
  delay(200);
  readImage();
}


void draw(){
  if (finalImage != null)
    image(finalImage, 0, 0);
  
  if(millis() - lastTime > 2000){
    readImage();
    lastTime = millis();
  }
  
}


void readImage(){ 
  //Send command to capture image
  myPort.write(0x10); 
  delay(1600); //This is essential to allow time for the Arduino to send a full payload
  
  /***************************************
  
  The response is of the form:
  ACK CMD CAM start single shoot. END
  ACK CMD CAM Capture Done. END
  6152
  ACK IMG END
  <binary payload>
  
  ****************************************/
  
  int index=0;
  ArrayList<String> stringBuffer = new ArrayList<String>();
  int payloadLength = 0;
  
  while(true){
    String line = myPort.readStringUntil('\n');
    print(line);
    if(line == null) continue;
    stringBuffer.add(line.trim());
    if(line.equals("ACK IMG END\r\n")){
      //The payload length is the previous line
      //So get the last but one entry in the string buffer
      payloadLength = Integer.parseInt(stringBuffer.get(index-1));
      println("payload length=" + payloadLength);
      break;
    }
    index++;
  }
  
  //Now we know the length of the binary payload we can read it as bytes
  buffer = new byte[payloadLength];
  int ch = -1;
  int bytesRead = 0;
  while(true){
    ch = myPort.read();
    //print((char)ch);
    buffer[bytesRead] = (byte)ch;
    bytesRead++;
    if(bytesRead == payloadLength){
      break;
    }
  }
 
  saveBytes("image.jpg", buffer);
  finalImage = loadImage("image.jpg");  
  println("--------------------------------------------------------------------------------------------------------------------------");
  
}

void keyPressed() {
  if (key == 'q' || key == 'Q') {
    close();
    delay(200);
    exit();
  }
}


void mousePressed() {
  close();
  delay(200);
  exit();
}


void close() {
  println("Closing.....");
  myPort.clear();
  myPort.stop();
} 