### Information Directory ###
---
###### Nginx Configuration ######
- Nginx configuration for [_FreeNAS_] ownCloud [_Standard_] Jail
  - __Line 7__
    - _Should be set to number of CPU processors/threads_
  - __Lines 24, 25, & 26__
    - _Must point to server's cert, key, & dh.pem_
  - __Lines 35 & 47__
    - _Must point to server's address_(_es_)
  - __Line 48__
    - _Must point to server's root directory_

- SSL Protocols will need to be edited __if__ utilizing [_older_] devices using [_older_] browsers which still require TLSv1

- SSL Ciphers will need to be edited if you require more lenient ciphers
  - `openssl ciphers -s -v` will display your server's supported ciphers in the format you'll need them in
    - On FreeBSD 10.3 [_standard jail_], the `-s` [_supported ciphers_] flag isn't supported
  - Choosing which ciphers to go, or not go, with shouldn't be decided without thorough research and understanding... ___especially___ _if exposing server to WAN_.
    - ECDHE ciphers are faster than, and therefor generally preferred to, DHE, which is why they take precedence in the config.
  - Simply because a 2048bit cert is used __does not__ mean your connection will utilize that level of encryption.
	  - Client and server will negotiate the encryption, level, and authentication utilized; often being less than one would think.
