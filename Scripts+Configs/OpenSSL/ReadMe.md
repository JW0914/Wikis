### Information Directory ###
---
###### [Language Profile](Notepad++%20OpenSSL%20Language%20Profile.xml) ######
- Profiles I created for config files, making it far more convenient to view config files in Notepad++
  - Import via: **Language -> Define Your Language -> Import**


###### [OpenSSL Config](openssl.cnf) ######
- I created this config for maximum security when creating **CA**s [_Certificate Authorities_], **ICA**s [_Intermediate Certificate Authorities_], and **Certificates**.
  - _Information and applicable commands can be found beginning at Line 430_

- By default, the CA profile does not have a pathleen set, allowing it to sign an infinite number of CAs and ICAs; however, the ICA profile has a pathleen of 0, preventing it from signing any CA or ICA.
  - CA & ICA `keyUsage` **should not** be altered, as the values set are the only values a CA or ICA should have.

- CAs & ICAs should **_always_** have a hash equal to, or larger than, the hash of the certificates they sign.
  - CA & ICA keys **should not** have _less_ than 4096bit encryption and should be _encrypted_ with a password
    - Encryption password should be complex, contain at least 20 characters, and have a minimum of _two_ lowercase letters, _two_ uppercase letters, _two numbers_, & _two_ symbols.
  - When not in use, certificate keys, _especially CA & ICA keys_, should reside within an encrypted container, secured by at least a 4096bit PGP signing cert (_see [GnuPG](https://www.gnupg.org/)_) that is also secured by the same password complexity as above

- All VPN/Web Servers & client V3 profiles should always have at least the following `keyUsage` & `extendedKeyUsage` flags
  - **Server**
    - **`keyUsage`:**
      - `digitalSignature`
      - `nonRepudiation`
      - `keyEncipherment`
      - `keyAgreement`
    - **`extendedKeyUsage`**
      - `serverAuth`
  - **Client**
    - **`keyUsage`:**
      - `digitalSignature`
      - `nonRepudiation`
      - `keyEncipherment`
    - **`extendedKeyUsage`**
      - `clientAuth`
- `nscertype` flags **should not** be utilized within certs or VPN configs as they're obsolete & were never officially recognized OIDs for _anything other than the NetScape browser_
  - **Client Config:** `remote-cert-eku "TLS Web Server Authentication"` should be utilized in lieu of `remote-cert-tls`


###### [PEM Association](PEM%20Association.reg) ######
  - Importing this into the registry allows Windows to display PEM certificates in GUI form.

