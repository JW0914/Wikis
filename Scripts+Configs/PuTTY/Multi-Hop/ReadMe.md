###Information Directory###
---
######Multi-Hop######
- Necessary files and instructions on how to create a Multi-Hop SSH Tunnel
  - __Remote device__  ___-->___  _WAN SSH_  ___-->___  ___Router___  ___-->___  [multi-hop begins]  ___-->___  _LAN SSH_  ___-->___  __Local Device__

######How to MultiHop SSH######
- Wiki explaining how to configure PuTTY for a MultiHop
  - Files containing _(without registry)_ do not contain the registry output in file, and is the recommended version to utilize

######PuTTY Profiles######
- __FreeNAS Remote__ is the remote SSH profile for a _local device_, which will be the final point in a MultiHop
  - Edit lines:
    - __5:__ `"HostName"="root@192.168.1.20"`
    - __6:__ `"LogFileName"="C:\\Path\\To\\PuTTY\\Logs\\SSH.FreeNAS.Remote.log"`
    - __15:__ `"PortNumber"=dword:00000016`
      - ___hex format___, _hex 16 is dec 22_
      - _Windows calculator has a programmer function with hex <-> dec conversion_
    - __32:__ `"ProxyTelnetCommand"="plink -v -load SSH.OpenWRT.Remote -nc %host:%port"`
      - _profile name (SSH.OpenWRT.Remote) must match router profile name and can't contain spaces_
    - __58:__ `"PublicKeyFile"="C:\\Path\\To\\PuTTY\\SSHkeys\\FreeNAS.SSH.ppk"`
- __OpenWRT Remote__ is the remote SSH profile for a _WAN facing router_
  - Edit lines:
    - __5:__ `"HostName"="your.ddns.com"`
    - __6:__ `"LogFileName"="C:\\Path\\To\\PuTTY\\Logs\\SSH.OpenWRT.Remote.log"`
    - __15:__ `"PortNumber"=dword:00000016`
      - ___hex format___, _hex 16 is dec 22_
      - _Windows calculator has a programmer function with hex <-> dec conversion_
    - __58:__ `"PublicKeyFile"="C:\\Path\\To\\PuTTY\\SSHkeys\\OpenWRT.SSH.ppk"`
 
