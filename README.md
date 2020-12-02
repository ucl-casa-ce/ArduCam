# ArduCam

A small Processing sketch that downloads an ArduCam image over the USB Serial cable (or any serial connection including Bluetooth).

Captures 320x240 JPEG image every couple of seconds using single shot capture command (0x10).

You will need to manually configure the appropriate COM port in the code.
<br>
<br>

## Protocol

<br>
Write <br> 
0x10
<br>
<br>
Receive (first shot)<br>
ACK CMD ArduCAM Start! END <br>
ACK CMD SPI interface OK. END <br>
ACK CMD OV2640 detected. END <br>
ACK CMD CAM start single shoot. END <br>
ACK CMD CAM Capture Done. END <br>
6152 <br>
ACK IMG END <br>
`Binary Payload`
<br>
<br>
Receive (subsequent shots)<br>
ACK CMD CAM start single shoot. END <br>
ACK CMD CAM Capture Done. END <br>
5128 <br>
ACK IMG END <br>
`Binary Payload`