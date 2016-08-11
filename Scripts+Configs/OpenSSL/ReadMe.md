###Information Directory###
---
######OpenSSL.cnf######
  - I created this config for maximum security when creating **CA**s [_Certificate Authorities_], **ICA**s [_Intermediate Certificate Authorities_], and **Certificates**.

- By default, the CA profile does not have a pathleen set, allowing it to sign an infinite number of CAs and ICAs; however, the ICA profile has a pathleen of 0, preventing it from signing any CA or ICA. 
  - CA & ICA `keyUsage` **should not** be altered, as the values set are the only values a CA or ICA should have.

- CAs & ICAs should **_always_** have a hash equal to, or larger than, the hash of the certificates they sign.
  - CA & ICA keys **should not** have _less_ than 4096bit encryption

- The VPN Server V3 profile `v3_vpn_server` should have all five `keyUsage` values listed, as they're required for the proper functioning of a VPN server to authenticate itself as a server with the `extendedKeyUsage` of `serverAuth` and properly encrypt data.
  - `nscertype` flags **should not** be utilized within certs or VPN configs as they're obsolete & were never officially recognized OIDs for _anything other than the NetScape browser_ 


######PEM Association.reg######
  - Importing this into the registry will allow Windows to display PEM certificates in GUI form.

***
######Information and applicable commands can be found beginning at _Line 430_######
***
