###Information Directory###
---
######PuTTY Serial Session######
- Verify correct COM port is set _(default is COM3)_
  - __Registry Line 206:__ _"SerialLine"="COM3"_
  - __PuTTY:__ _Sesion - Serial line_
- Once Line 206 is correctly set, merge into registry

######TFTP32/64 config######
- tftp32.ini is utilized regardless of whether TFTP32 or TFTP64 is used
- Lines needing customization:
  -  __3:__ _IP_Pool=192.168.1.20_
    - Your PC IP, which needs to be manually set
  -  __9:__ _Mask=255.255.255.0_
  -  __10:__ _Gateway=192.168.1.1_
    - IP of device you're flashing (i.e. a router)
  -  __36:__ _BaseDirectory=D:\TFTP\FLASH_
    - Directory where files are being transfered from, cannot contain spaces
  -  __51:__ _LocalIP=192.168.1.20_
    - Your PC IP, which needs to be manually set
- Once the above is correctly set, place _tftp32.ini_ in root directory containing TFTP32/64
