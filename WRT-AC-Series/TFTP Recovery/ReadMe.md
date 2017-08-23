### Information Directory ###
---
###### [TFTP Recovery](TFTP%20Recovery.pdf) ######
- Wiki on performing a TFTP recovery firmware flash

###### [WRT AC Series Serial Port](WRT1X00AC(S)%20Serial%20Port.pdf) ######
- Covers different ways of connecting via serial
  - _USB - TTL AJ (Audio Jack) cable_
  - _USB - TTL Header cable_
  - _Max232 RS-232 Line Driver_
  - _Arduino_
- Covers header [serial] port pin out
- Describes how to install an audio jack into the case for easy access with a USB - TTL AJ cable

###### [PuTTY Serial Session](Putty-Serial-Session.reg) ######
- Verify correct COM port is set
  - __Registry Line 206:__ `"SerialLine"="COM3"`
  - __PuTTY:__ _Sesion - Serial line_
- Once Line 206 is correctly set, merge into registry

###### [TFTP32/64 config](tftpd32.ini) ######
- tftp32.ini is utilized regardless of whether TFTP32 or TFTP64 is used
- Lines requiring customization:
  -  __3:__ `IP_Pool=192.168.1.20`
     - _Your PC IP, which needs to be manually set_
  -  __9:__ `Mask=255.255.255.0`
  -  __10:__ `Gateway=192.168.1.1`
     - _IP of device you're flashing (i.e. a router)_
  -  __36:__ `BaseDirectory=D:\TFTP\FLASH`
     - _Directory where files are being transfered from (cannot contain spaces)_
  -  __51:__ `LocalIP=192.168.1.20`
     - _Your PC IP, which needs to be manually set_
- Once the above is correctly set, place _tftp32.ini_ in root directory containing TFTP32/64
 
