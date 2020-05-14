### Information Directory ###
---

[OpenWrt Project](https://openwrt.org/) SSH PuTTY profile
* [SSH for Newcomers](https://openwrt.org/docs/guide-quick-start/sshadministration) 
<br></br>
* [DropBear SSH Server Configuration](https://openwrt.org/docs/guide-user/base-system/dropbear) 
* [OpenSSH SSH Server Configuation](https://openwrt.org/docs/guide-user/services/ssh/openssh.server)

###### [SSH.OpenWrt.reg](SSH.OpenWrt.reg) ######

- **Line 60:** `"PublicKeyFile"="C:\\Users\\JW0914\\.ssh\\ppk\\WRT1900ACS_2r.ppk"`
  - Change to path of your SSH key
   - _Ensure double backslashes, not single, are used for the path_
<br></br>
- **Line 180:** `"PortForwardings"="L9000=192.168.1.1:443"`
   - **To utilize:** Navigate to: https://127.0.0.1:9000
     - SSH tunnel for accessing the WebUI over the encrypted SSH tunnel
     - _Update router's IP accordingly if it is not 192.168.1.1_
