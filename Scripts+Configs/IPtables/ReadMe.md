### Information Directory ###
---
###### [IPtables User Script](iptables_user-firewall.sh) ######
- A basic `iptables` script which can be used to 
  - Filter, log, and drop traffic to SSH, VPN, etc. ports
  - Log SSH/VPN traffic
- Created for routers running LEDE/OpenWrt, but can be used by any distro running iptables
  - [LEDE](https://lede-project.org/) / [OpenWrt](https://openwrt.org/)
    - Save as: /etc/firewall.user
    - Remove shebang
    - Uncomment UCI variables
