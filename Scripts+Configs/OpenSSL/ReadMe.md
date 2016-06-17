###Information Directory###
---
######OpenSSL.cnf######
  - I created this config for maximum security when creating **CA**s [_Certificate Authorities_], **ICA**s [_Intermediate Certificate Authorities_], and **Certificates**.

- By default, the CA profile does not have a pathleen set, allowing it to sign an infinite number of CAs and ICAs; however, the ICA profile has a pathleen of 0, preventing it from signing any CA or ICA.
  - CA & ICA _keyUsage_ **should** not be altered, as the values set are the only values a CA or ICA should have.

- _Information and applicable commands can be found beginning at_ ___Line 321___
