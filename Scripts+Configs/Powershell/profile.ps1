#

#===========================================================
        ##::[[--- Powershell PS1 Profile ---]]::##
#===========================================================

# ANSI:
  $ESC                            = [char]27

# Colors
#-----------------------------------------------------------
$PD                               = $($Host.PrivateData)

$Host.UI.RawUI.BackgroundColor    = ($bckgrnd = 'Black')
$Host.UI.RawUI.ForegroundColor    = 'Gray'

$PD.ErrorForegroundColor          = 'Red'
$PD.ErrorBackgroundColor          = $bckgrnd

$PD.WarningForegroundColor        = 'Magenta'
$PD.WarningBackgroundColor        = $bckgrnd

$PD.DebugForegroundColor          = 'Yellow'
$PD.DebugBackgroundColor          = $bckgrnd

$PD.VerboseForegroundColor        = 'Green'
$PD.VerboseBackgroundColor        = $bckgrnd

$PD.ProgressForegroundColor       = 'Yellow'
$PD.ProgressBackgroundColor       = $bckgrnd


# Terminal
#-----------------------------------------------------------
Function set-prompt {
  Param (
    [Parameter(Position=0)]
    [ValidateSet("Default","Test")]
    $Action
  )

  switch ($Action) {
    "Default" {
      Function global:prompt {
        if (test-path variable:/PSDebugContext) { '[DBG]: ' }
          write-host " "
          write-host ("$ESC[48;2;40;40;40m$ESC[38;2;170;210;0m$(Get-Location) $ESC[0m $ESC[0m")

        if ( $host.UI.RawUI.WindowTitle -match "Administrator" ) {
          $Host.UI.RawUI.ForegroundColor = 'Red'
          $(if ($nestedpromptlevel -ge 1) {
            write-host ('PS $$ ') -ForegroundColor Red -NoNewLine
          } else {
            write-host ('PS $ ') -ForegroundColor Red -NoNewLine
          })
        } else {
          $(if ($nestedpromptlevel -ge 1) {
            write-host ('PS $$ ') -ForegroundColor Blue -NoNewLine
          } else {
            write-host ('PS $ ') -ForegroundColor Blue -NoNewLine
          })
        }
        return " "
      }
    }
  }
}

set-prompt Default


# Relaunch as Admin:
  function Relaunch-Admin { Start-Process -Verb RunAs (Get-Process -Id $PID).Path }
  Set-Alias psadmin Relaunch-Admin

# PSReadLine
  if ($host.Name -eq 'ConsoleHost') { Import-Module PSReadline }

# Chocolatey profile
  $ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
  if (Test-Path($ChocolateyProfile)) { Import-Module "$ChocolateyProfile" }


#===========================================================

# Module Browser
#-----------------------------------------------------------
  # Version: 1.3.2

Add-Type -Path 'C:\Program Files (x86)\WindowsPowerShell\Module Browser\ModuleBrowser.dll'

#$moduleBrowser   = $psISE.CurrentPowerShellTab.VerticalAddOnTools.Add('Module Browser', [ModuleBrowser.Views.MainView], $true)
#$psISE.CurrentPowerShellTab.VisibleVerticalAddOnTools.SelectedAddOnTool  = $moduleBrowser


# Script Browser
#-----------------------------------------------------------
  # Version: 1.3.2

Add-Type -Path 'C:\Program Files (x86)\WindowsPowerShell\Script Browser\System.Windows.Interactivity.dll'
Add-Type -Path 'C:\Program Files (x86)\WindowsPowerShell\Script Browser\ScriptBrowser.dll'
Add-Type -Path 'C:\Program Files (x86)\WindowsPowerShell\Script Browser\BestPractices.dll'

#$scriptBrowser   = $psISE.CurrentPowerShellTab.VerticalAddOnTools.Add('Script Browser', [ScriptExplorer.Views.MainView], $true)
#$scriptAnalyzer  = $psISE.CurrentPowerShellTab.VerticalAddOnTools.Add('Script Analyzer', [BestPractices.Views.BestPracticesView], $true)
#$psISE.CurrentPowerShellTab.VisibleVerticalAddOnTools.SelectedAddOnTool  = $scriptBrowser


#===========================================================
                    # User Variables #
#===========================================================

# CFA Allow
  Remove-Variable -Name allapp -Force -ea silentlycontinue
  Set-Variable -Name allapp -Value "Add-MpPreference -ControlledFolderAccessAllowedApplications" -Scope "Global"

# Sign:
  Remove-Variable -Name sign -Force -ea silentlycontinue
  Set-Variable -Name sign -Value "$env:ProgramData\Scripts\Sign\sign.ps1" -Scope "Global"

# Symbolic link:
  Remove-Variable -Name ln -Force -ea silentlycontinue
  Set-Variable -Name ln -Value "Cmd /c MkLink /j" -Scope "Global"

# Win 10 Powershell
  Remove-Variable -Name P -Force -ea silentlycontinue
  Set-Variable -Name P -Value "$env:WinDir\System32\WindowsPowerShell\v1.0\powershell.exe" -Scope Global


# OpenSSH:
#-----------------------------------------------------------

# .ssh:
  Remove-Variable -Name SSH -Force -ea silentlycontinue
  Set-Variable -Name SSH -Value "$env:UserProfile\.ssh" -Scope "Global"

# Local:
  Remove-Variable -Name idl -Force -ea silentlycontinue
  Set-Variable -Name idl -Value "$env:UserProfile\.ssh\ids\local" -Scope "Global"

# Remote:
  Remove-Variable -Name idr -Force -ea silentlycontinue
  Set-Variable -Name idr -Value "$env:UserProfile\.ssh\ids\remote" -Scope "Global"

#===========================================================
