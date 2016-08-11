###Information Directory###
---
######Notepad++ OpenSSL Language Profile######
- Profile I created for config files, making it far more convenient to view config files in Notepad++
  - Import via: **Language -> Define Your Language -> Import**


######OpenSSL.cnf######
- I created this config for maximum security when creating **CA**s [_Certificate Authorities_], **ICA**s [_Intermediate Certificate Authorities_], and **Certificates**.
  - _Information and applicable commands can be found beginning at Line 507_
- By default, the CA profile does not have a pathleen set, allowing it to sign an infinite number of CAs and ICAs; however, the ICA profile has a pathleen of 0, preventing it from signing any CA or ICA. 
  - CA & ICA `keyUsage` **should not** be altered, as the values set are the only values a CA or ICA should have.
- CAs & ICAs should **_always_** have a hash equal to, or larger than, the hash of the certificates they sign.
  - CA & ICA keys **should not** have _less_ than 4096bit encryption and should be _encrypted_ with a password
    - Encryption password should be complex, contain at least 20 characters, and have a minimum of _two_ lowercase letters, _two_ uppercase letters, _two numbers_, & _two_ symbols.
  - When not in use signing certificates, the signing key should reside within an encrypted container, secured by at least a 4096bit PGP signing cert (_see [GnuPG](https://www.gnupg.org/)_) that is also secured by the same password complexity as above
- All VPN Server V3 profiles (i.e. `v3_vpn_server1` & `v3_vpn_server2`) should always have all five `keyUsage` values listed, as they're required for the VPN server to authenticate itself as a server with the `extendedKeyUsage` of `serverAuth`, as well as properly encrypt data.
  - `nscertype` flags **should not** be utilized within certs or VPN configs as they're obsolete & were never officially recognized OIDs for _anything other than the NetScape browser_ 


######PEM Association.reg######
  - Importing this into the registry allows Windows to display PEM certificates in GUI form.

