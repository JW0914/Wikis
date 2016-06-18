###Information Directory###
---
######OpenSSL.cnf######
  - I created this config for maximum security when creating **CA**s [_Certificate Authorities_], **ICA**s [_Intermediate Certificate Authorities_], and **Certificates**.

- By default, the CA profile does not have a pathleen set, allowing it to sign an infinite number of CAs and ICAs; however, the ICA profile has a pathleen of 0, preventing it from signing any CA or ICA.
  - CA & ICA _keyUsage_ **should** not be altered, as the values set are the only values a CA or ICA should have.

- The VPN Server V3 profile [_v3_vpn_server_] must have all five _keyUsage_ values listed, as they're required for the VPN server to authenticate itself as a server with the _extendedKeyUsage_ of _serverAuth_
  - nscertype flags **should not** be utilized within certs or VPN configs as they're obsolete and were never officialy recognized OIDs 

- _Information and applicable commands can be found beginning at_ ___Line 321___
