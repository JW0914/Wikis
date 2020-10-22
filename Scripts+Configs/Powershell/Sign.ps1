#

#===========================================================
      ##::[[--  Powershell Signing Script  ---]]::##
#===========================================================

  # Title:        Sign.ps1
  # Description:  Signs PowerShell scripts
  # Author:       JW0914
  # Created:      2017.12.17
  # Updated:      2017.12.17
  # Version:      1.0
  # Usage:        .\Sign.ps1

#===========================================================

param([string] $file=$(throw "Please specify a script filepath."))

$Cert         = Get-ChildItem -Path "Cert:\CurrentUser\My" -CodeSigningCert
$timeStampURL = "http://timestamp.verisign.com/scripts/timstamp.dll"

  if($cert) { Set-AuthenticodeSignature -filepath $file -Certificate $Cert -HashAlgorithm SHA256 -TimestampServer $timeStampURL
  } else {
    throw "Did not find certificate with friendly name of `"$certFriendlyName`""
  }
