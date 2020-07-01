
### Information Directory ###
---

###### Configs are configured for security & may need to have less secure ciphers/exchanges added for certain SSH servers ######

### [BSD/Linux](BSD-Linux) ###
- ###### [_`~/.ssh/config`_](BSD-Linux/config) ######
  Custom user-specific OpenSSH client config, with three specific sections to this custom config
  - ###### Custom ######
    User-specific options which should be placed in `config`, not the system-wide `ssh_config`
  - ###### Hosts ######
    Individual host configurations, allowing user to connect via `ssh <host variable>`, such as `ssh FNr`
  - ###### Options ######
    Options overriding system-wide defaults in `ssh_config`
- ###### [_`/etc/ssh/ssh_config`_](BSD-Linux/ssh_config) ######
  Custom system-wide OpenSSH client config
- ###### [_`/etc/ssh/sshd_config`_](BSD-Linux/sshd_config) ######  
  Custom system-wide OpenSSH server config

##

### [Windows](Windows) ###
- ###### [_`%UserProfile%\.ssh\config`_](Windows/config) ######
  Custom user-specific Windows OpenSSH client config
- ###### [_`%ProgramData%\ssh\ssh_config`_](Windows/ssh_config) ######
  Custom system-wide Windows OpenSSH client config
- ###### [_`%ProgramData%\ssh\sshd_config`_](Windows/sshd_config) ######
  Custom system-wide Windows OpenSSH server config
---

## Permission Structure ##
- **`%UserProfile%\.ssh`** <br>
   Directory and files/subdirectories should be owned by, and only have inherited permissions for, the user

##

- **`%ProgramData%\ssh\ssh_config`**
  - _`NT AUTHORITY\SYSTEM:(F)` | `BUILTIN\Administrators:(F)` | `NT SERVICE\sshd:(R)`_
    ```bat
    Cmd /c Icacls %ProgramData%\ssh\sshd_config /Grant `"NT AUTHORITY\SYSTEM`":F
    Cmd /c Icacls %ProgramData%\ssh\sshd_config /Grant `"BUILTIN\Administrators`":F
    Cmd /c Icacls %ProgramData%\ssh\sshd_config /Grant `"NT SERVICE\sshd`":F
    ```
- **`%ProgramData%\ssh\sshd_config`**
  - _`NT AUTHORITY\SYSTEM:(F)` | `BUILTIN\Administrators:(F)` | `NT SERVICE\sshd:(R)`_
    ```bat
    Cmd /c Icacls %ProgramData%\ssh\sshd_config /Grant `"NT AUTHORITY\SYSTEM`":F
    Cmd /c Icacls %ProgramData%\ssh\sshd_config /Grant `"BUILTIN\Administrators`":F
    Cmd /c Icacls %ProgramData%\ssh\sshd_config /Grant `"NT SERVICE\sshd`":F
    ```
##

- **`%UserProfile%\.ssh`**
  - _`WRT\JW0914:(F)`_
    ```bat
    :: # Remove Inheritance ::
       Cmd /c Icacls %UserProfile%\.ssh /c /t /Inheritance:d

    :: # Set Ownership to Owner ::
       Cmd /c Icacls %UserProfile%\.ssh /c /t /Grant %UserName%:F

    :: # Remove All Users, except for Owner ::
       Cmd /c Icacls %UserProfile%\.ssh /c /t /Remove Administrator BUILTIN\Administrators BUILTIN Everyone System Users

    :: # Verify ::
       Cmd /c Icacls %UserProfile%\.ssh
    ```
##

- **`~/.ssh`**
  ```bash
  # Set Ownership to Owner (assumes user's group name is also user's name)
    chown -R $(echo $USER):$(echo $USER) ~/.ssh

  # Set Directory Permissions:
    chmod 700 ~/.ssh

  # Set Recursive File Permissions:
    chmod -R 600 ~/.ssh/*

  # Verify: 
    ls -lsa ~/.ssh
  
      # drwx------  1 jw  jw    .
      # -rw-------  1 jw  jw    authorized_keys
      # -rw-------  1 jw  jw    config
      # -rw-------  1 jw  jw    known_hosts
  ```
