
### Information Directory ###
---

###### Configs are configured for security & may need to have less secure ciphers/exchanges added for certain SSH servers ######

### [BSD/Linux](BSD-Linux) ###
- [`~/.ssh/config`](BSD-Linux/config) <br> Custom user-specific OpenSSH client config, with three specific sections to this custom config
  - **Custom:** <br> User-specific options which should be placed in `config`, not the system-wide `ssh_config`
  - **Hosts:** <br> Individual host configurations, allowing user to connect via `ssh <host variable>`, such as `ssh FNr`
  - **Options:** <br> Options overriding system-wide defaults in `ssh_config`
- [`/etc/ssh/ssh_config`](BSD-Linux/ssh_config) <br> Custom system-wide OpenSSH client config
- [`/etc/ssh/sshd_config`](BSD-Linux/sshd_config) <br> Custom system-wide OpenSSH server config
### [Windows](Windows) ###
- [`%UserProfile%\.ssh\config`](Windows/config) <br> Custom user-specific Windows OpenSSH client config
- [`%ProgramData%\ssh\ssh_config`](Windows/ssh_config) <br> Custom system-wide Windows OpenSSH client config
- [`%ProgramData%\ssh\sshd_config`](Windows/sshd_config) <br> Custom system-wide Windows OpenSSH server config

---

## Permission Structure ##
- **`%UserProfile%\.ssh`** <br>
  Directory and files/subdirectories should be owned by, and only have inherited permissions for, the user
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
