Contains a VBS Script which creates an instant restore point, prompts for a description, and shows a success or error message upon completion
  - VBS script should be placed in a path with no spaces
    - For example: %ProgramData%\Scripts\SR\RPwithConfirmation
  - Description can be changed by editing line 33:
    - sDesc = "System Startup"
