### Information Directory ###
---
###### Multi-Hop ######
- Necessary files and instructions on how to create a Multi-Hop SSH Tunnel
  - __Remote device__  ___-->___  _WAN SSH_  ___-->___  ___Router___  ___-->___  [multi-hop begins]  ___-->___  _LAN SSH_  ___-->___  __Local Device__

###### [How to MultiHop SSH](How%20To%20Multi-Hop%20SSH.pdf) ######
- Wiki explaining how to configure PuTTY for a MultiHop

###### PuTTY Profiles ######
- [__FreeNAS Remote__](PuTTY_Profile_FreeNAS_Remote_Multi-hop.reg) is the remote SSH profile for a _local device_, which will be the final point in a MultiHop
  - Edit lines:
    - __5:__ `"HostName"="root@192.168.1.20"`
    - __6:__ `"LogFileName"="C:\\Path\\To\\PuTTY\\Logs\\SSH.FreeNAS.Remote.log"`
    - __15:__ `"PortNumber"=dword:00000016`
      - _Hex format (hex 16 -> dec[imal] 22)_
        - _BSD/Linux_
          - _cli hex -> dec: `printf '%d\n' 0x0a` returns 10_
          - _cli dec -> hex: `printf '%x\n' 10` returns 0a_
        - _Windows_
          - _Calculator has a programmer function with hex <-> dec conversion_
    - __32:__ `"ProxyTelnetCommand"="plink -v -load SSH.OpenWRT.Remote -nc %host:%port"`
      - _profile name (SSH.OpenWRT.Remote) must match router profile name and can't contain spaces_
    - __58:__ `"PublicKeyFile"="C:\\Path\\To\\PuTTY\\SSHkeys\\FreeNAS.SSH.ppk"`

- [__OpenWRT Remote__](PuTTY_Profile_OpenWRT_Remote.reg) is the remote SSH profile for a _WAN facing router_
  - Edit lines:
    - __5:__ `"HostName"="your.ddns.com"`
    - __6:__ `"LogFileName"="C:\\Path\\To\\PuTTY\\Logs\\SSH.OpenWRT.Remote.log"`
    - __15:__ `"PortNumber"=dword:00000016`
    - __58:__ `"PublicKeyFile"="C:\\Path\\To\\PuTTY\\SSHkeys\\OpenWRT.SSH.ppk"`
 
