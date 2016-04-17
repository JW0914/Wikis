Contains a VBS Script which creates an instant restore point and prompts for a description
  - VBS script should be placed in a path with no spaces
    - For example: %ProgramData%\Scripts\SR\RPwithConfirmation
  - Description can be changed by editing line 33:
    - sDesc = "System Startup"
  - Does not provide a confirmation for success or error
