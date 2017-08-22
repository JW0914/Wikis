### Information Directory ###
---
###### [Client.ovpn](Client.ovpn) ######
- OpenVPN client config
  - **Android:** `pkcs12 vpn-client1.p12` can be removed (line 57), as Android imports certs into it's keychain

###### [OpenVPN-Server.conf](OpenVPN-Server.conf) ######
- OpenVPN server config for OpenWrt
  - Will need to be modified slightly for other Linux/BSD distros:
    - `option` isn't utilized & should be removed
    - `_` should be changed to `-`

###### [openvpn.conf-default](openvpn.conf-default) ######
- OpenVPN server config for Sophos [UTM](https://www.sophos.com/en-us/products/unified-threat-management.aspx)/[XG](https://www.sophos.com/en-us/products/next-gen-firewall.aspx)
  - Located at: */var/sec/chroot-openvpn/etc/openvpn/openvpn.conf-default*
    - */etc/openvpn/tls-auth.key* must be manually added to the directory */var/sec/chroot-openvpn/etc/openvpn*
      - Generate with: `openvpn --genkey --secret /var/sec/chroot-openvpn/etc/openvpn/tls-auth.key`
    - The two blank lines following `[<OPTIONS>]` should remain, followed by the EOF blank line, or three in total.
      - ConfD will append an additional two options to the end of */var/sec/chroot-openvpn/etc/openvpn/openvpn.conf* when SSL VPN is enabled in WebAdmin.
        - ConfD utilizes *openvpn.conf-default* to dynamically create */var/sec/chroot-openvpn/etc/openvpn/openvpn.conf* upon SSL VPN being enabled in WebAdmin; once disabled, ConfD deletes *openvpn.conf*.
    - The single `#` at the beginning of the file is for `vim`, else it won't apply syntax coloring in config files.

###### EC TLS Ciphers ######
  - EC [**E**lliptic **C**urve] ciphers require keys & hashes greater than the desired values
    - Example:
      - For 2048bit, a key of/over 3072bit would be required
      - For SHA256, a hash of/over SHA384 would be required
        - *x64 systems can process SHA512 faster than SHA256*

###### DH Keys ######
  - It's recommended to generate multiple DH [**D**iffie-**H**ellman] values at the same time (2048, 3072, 4096)
    - DH generation takes substantial time, with each subsequent generation occurring faster due to the rand file

---

###### [OpenSSL](https://openssl.org) #######
  * **Guides**
    * [Documents](https://www.openssl.org/docs/|OpenSSL)
    * [HowTo](https://www.openssl.org/docs/HOWTO/|OpenSSL)
    * [Man Page](https://www.openssl.org/docs/apps/openssl.html|OpenSSL)

  * **Info**
    * [Deploying a VPN with PKI on GNU/Linux](http://archive.oreilly.com/pub/a/security/2004/10/21/vpns_and_pki.html?page=1)

###### [OpenVPN](https://openvpn.net/index.php/open-source/overview.html) ######
  * **Android**
    * [OpenVPN on Android](https://docs.openvpn.net/docs/openvpn-connect/openvpn-connect-android-faq.html)
    * [Remove "Your Network Could be Monitored" Toast](http://forum.xda-developers.com/google-nexus-5/help/howto-install-custom-cert-network-t2533550)
    * [Trust CA cert's Root Certificate](http://wiki.cacert.org/FAQ/ImportRootCert#Android_Phones)

  * **Forum**
    * [OpenVPN Forum](https://forums.openvpn.net/)

  * **Guides**
    * [OpenVPN HowTo](https://openvpn.net/index.php/open-source/documentation/howto.html)
    * [OpenVPN Man Page](https://community.openvpn.net/openvpn/wiki/Openvpn24ManPage)
    * [OpenVPN Wikis](https://community.openvpn.net/openvpn/wiki)

  * **Tuning**
    * [Buffer Tuning](http://winaero.com/blog/speed-up-openvpn-and-get-faster-speed-over-its-channel/)
    * [MTU Tuning](https://community.openvpn.net/openvpn/wiki/Gigabit_Networks_Linux)
