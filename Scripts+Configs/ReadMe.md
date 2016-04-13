Various scripts, registry files, and configs
  - If utilizing the registry configs, there may be values within the keys you will need to customize to your own environment
    - For example, the Explorer keys must be pointed to the right directory within the key
      - Please remember, paths in registry keys must use double backslashes "\\\", not single backslashes "\"
      - One can also customize the name shown in the Navigation Tree
    - Another example are the System Restore keys, which must have the path of the VBS script set correctly.
      - I recommend placing the vbs scripts in a folder with no spaces, such as creating a directory in %ProgramData% named Scripts (C:\ProgramData\Scripts)

  - I've included two OpenSSL.cnf configs, named OpenSSL.cnf & OpenSSL (Organized).cnf.
    - I recommend downloading OpenSSL (Organized).cnf, as I had to edit OpenSSL.cnf specifically for GitHub in order to have it appear organized and alligned.  Whether a cnf file is organized or not does not affect it's usage, however a clean, organized config file makes it much easier when reading, and/or adding to, it. 
    - OpenSSL (Organized).cnf needs to be renamed to OpenSSL.cnf once downloaded.
