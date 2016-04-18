###Information Directory###
---
######Multi-Hop######
- Necessary files and instructions on how to create a Multi-Hop SSH Tunnel
  - __Remote device__  ___-->___  _WAN SSH_  ___-->___  ___Router___  ___-->___  [multi-hop begins]  ___-->___  _LAN SSH_  ___-->___  __Local Device__

######How to MultiHop SSH######
- Wiki explaining how to configure PuTTY for a MultiHop
  - Files containing _(without registry)_ do not contain the registry output in file, and is the recommended version to utilize

######PuTTY Profiles######
- __OpenWRT Remote__ is the remote SSH profile for a _WAN facing router_
- __FreeNAS Remote__ is the remote SSH profile for a _local device_, which will be the final point in a MultiHop
