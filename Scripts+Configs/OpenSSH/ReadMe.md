
### Information Directory ###
---

###### Configs are configured for security & may need to have less secure ciphers/exchanges added for certain SSH servers _(DropBear for instance)_ ###### 


### [BSD/Linux](BSD-Linux) ###

  ###### [_config_](BSD-Linux/config) ######
  - Custom user specific OpenSSH client config, which should be placed at _~/.ssh/config_
  - There are three specific sections to this custom config
    - ###### Custom ######
      - Contains user specific options which should be placed in _config_, but not the system wide _/etc/ssh/ssh_config_
    - ###### Hosts ######
      - Contains individual host configurations, allowing user to connect via `ssh <host variable>`, such as `ssh FNr`
    - ###### Options ######
      - Contains options that override the system default ssh_config located at _/etc/ssh/ssh_config_

  ###### [_ssh_config_](BSD-Linux/ssh_config) ######
  - System wide OpenSSH client config, which should be placed at _/etc/ssh/ssh_config_

  ###### [_sshd_config_](BSD-Linux/sshd_config) ######  
  - System wide OpenSSH server config, which should be placed at _/etc/ssh/sshd_config_


### [Windows](Windows) ###

  ###### [_config (Win32-OpenSSH)_](Windows/config%20(Win32-OpenSSH)) ######
  - Custom user specific Windows OpenSSH client config, which should be placed at _%USERPROFILE%\\.ssh\config_
    - As of August 2017, this **_must_** be utilized since the Windows binary does not recognize _C:\Program Files\OpenSSH\ssh_config_ (See issue [#847](https://github.com/PowerShell/Win32-OpenSSH/issues/847))

  ###### [_ssh_config (Win32-OpenSSH)_](Windows/ssh_config%20(Win32-OpenSSH)) ######
  - System wide Windows OpenSSH client config, which should be placed at _C:\Program Files\OpenSSH\ssh_config_
    - As of August 2017, the Windows binary does not recognize _C:\Program Files\OpenSSH\ssh_config_ (See issue [#847](https://github.com/PowerShell/Win32-OpenSSH/issues/847))
      - Instead, [config](Windows/config%20(Win32-OpenSSH)) should be utilized and placed at _%USERPROFILE%\\.ssh\config_

  ###### [_sshd_config (Win32-OpenSSH)_](Windows/sshd_config%20(Win32-OpenSSH)) ######
  - System wide Windows OpenSSH server config, which should be placed at _C:\Program Files\OpenSSH\sshd_config_
---

## Permission Structure ##
- **NOTE:**
  - **%UserProfile%\\.ssh**
    - This, and all files/directories within, should _**not**_ have inherited permissions.
      - _Unless user is only one being passed for inheritance_
    - User should be the owner of _%UserProfile%\\.ssh_ and all files/directories within
  - **%ProgramFiles%\\OpenSSH\\ssh_host_*_key**
    - [`PsExe`](https://docs.microsoft.com/en-us/sysinternals/downloads/psexec) should be utilized to register the server keys as _NT AUTHORITY\SYSTEM_ (_[halfway down](https://github.com/PowerShell/Win32-OpenSSH/wiki/Install-Win32-OpenSSH)_)
      - [`sdelete`](https://docs.microsoft.com/en-us/sysinternals/downloads/sdelete) should be used to securely erase them _(5 pass minimum)_ once registered
##

- **_%ProgramFiles%\\OpenSSH\\ssh_config_**
  - _`NT AUTHORITY\SYSTEM:(F) | BUILTIN\Administrators:(F) | NT SERVICE\sshd:(R)`_
    - ```icacls %ProgramFiles%\OpenSSH\sshd_config /grant `"NT AUTHORITY\SYSTEM`":`(F`)```
    - ```icacls %ProgramFiles%\OpenSSH\sshd_config /grant `"BUILTIN\Administrators`":`(F`)```
    - ```icacls %ProgramFiles%\OpenSSH\sshd_config /grant `"NT SERVICE\sshd`":`(R`)```
- **_%ProgramFiles%\\OpenSSH\\sshd_config_**
  - _`NT AUTHORITY\SYSTEM:(F) | BUILTIN\Administrators:(F) | NT SERVICE\sshd:(R)`_
    - ```icacls %ProgramFiles%\OpenSSH\sshd_config /grant `"NT AUTHORITY\SYSTEM`":`(F`)```
    - ```icacls %ProgramFiles%\OpenSSH\sshd_config /grant `"BUILTIN\Administrators`":`(F`)```
    - ```icacls %ProgramFiles%\OpenSSH\sshd_config /grant `"NT SERVICE\sshd`":`(R`)```
##

- **_%UserProfile%\\.ssh_**
  - _`WRT\JW0914:(F)`_
    - ```icacls %UserProfile%\.ssh /grant `"WRT\JW0914`":`(F`)```
- **_%UserProfile%\\.ssh\\authorized_keys_**
  - _`NT SERVICE\sshd:(R) | WRT\JW0914:(F)`_
    - ```icacls %UserProfile%\.ssh\authorized_keys /grant `"NT SERVICE\sshd`":`(R`)```
    - ```icacls %UserProfile%\.ssh\authorized_keys /grant `"WRT\JW0914`":`(F`)```
- **_%UserProfile%\\.ssh\\config_**
  - _`WRT\JW0914:(F)`_
    - ```icacls %UserProfile%\.ssh\config /grant `"WRT\JW0914`":`(F`)```
- **_%UserProfile%\\.ssh\\known_hosts_**
  - _`WRT\JW0914:(F)`_
    - ```icacls %UserProfile%\.ssh\known_hosts /grant `"WRT\JW0914`":`(F`)```
##

- **_~/.ssh_**
  ```
  [root@LEDE] /home/jw # ls -lsa .ssh
      0 drwx------    1 jw       jw             368 Sep 10  2017 .
      4 -rw-------    1 jw       jw            2254 Sep 10  2017 authorized_keys
      8 -rw-------    1 jw       jw            6699 Sep 10  2017 config
      0 -rw-------    1 jw       jw               0 Sep 10  2017 known_hosts
  ```
