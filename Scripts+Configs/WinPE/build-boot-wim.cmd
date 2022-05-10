:: All commands MUST be executed within terminal opened by:
   :: Cmd /K "C:\Program Files (x86)\Windows Kits\10\Assessment and Deployment Kit\Deployment Tools\DandISetEnv.bat"
   
      :: To do so, execute this script from that terminal:
         :: C:\path\to\build-boot-wim.cmd

:: Normally, the following WinPE OCs would be added, however they're missing from the WinPE
:: Add-on and I'm unable to determine why from Microsoft Docs (no statement of depreciation)
   :: WinPE-FMAPI
   :: WinPE-Rejuv
   :: WinPE-SRT
   :: WinPE-WiFi-Packages

:: Create WinPE boot.wim with Setup:
CopyPE amd64 "C:\WinPE" &&^
Dism /Mount-Image /ImageFile:"C:\WinPE\media\sources\boot.wim" /Index:1 /MountDir:"C:\WinPE\mount" &&^
MkLink /J "C:\WinPE\OCs" "C:\Program Files (x86)\Windows Kits\10\Assessment and Deployment Kit\Windows Preinstallation Environment\amd64\WinPE_OCs" &&^
Dism /Add-Package /Image:"C:\WinPE\mount" /PackagePath:"C:\WinPE\OCs\WinPE-WMI.cab" &&^
Dism /Add-Package /Image:"C:\WinPE\mount" /PackagePath:"C:\WinPE\OCs\en-us\WinPE-WMI_en-us.cab" &&^
Dism /Add-Package /Image:"C:\WinPE\mount" /PackagePath:"C:\WinPE\OCs\WinPE-NetFx.cab" &&^
Dism /Add-Package /Image:"C:\WinPE\mount" /PackagePath:"C:\WinPE\OCs\en-us\WinPE-NetFx_en-us.cab" &&^
Dism /Add-Package /Image:"C:\WinPE\mount" /PackagePath:"C:\WinPE\OCs\WinPE-Scripting.cab" &&^
Dism /Add-Package /Image:"C:\WinPE\mount" /PackagePath:"C:\WinPE\OCs\en-us\WinPE-Scripting_en-us.cab" &&^
Dism /Add-Package /Image:"C:\WinPE\mount" /PackagePath:"C:\WinPE\OCs\WinPE-EnhancedStorage.cab" &&^
Dism /Add-Package /Image:"C:\WinPE\mount" /PackagePath:"C:\WinPE\OCs\en-us\WinPE-EnhancedStorage_en-us.cab" &&^
Dism /Add-Package /Image:"C:\WinPE\mount" /PackagePath:"C:\WinPE\OCs\WinPE-FMAPI.cab" &&^
Dism /Add-Package /Image:"C:\WinPE\mount" /PackagePath:"C:\WinPE\OCs\WinPE-SecureStartup.cab" &&^
Dism /Add-Package /Image:"C:\WinPE\mount" /PackagePath:"C:\WinPE\OCs\en-us\WinPE-SecureStartup_en-us.cab" &&^
Dism /Add-Package /Image:"C:\WinPE\mount" /PackagePath:"C:\WinPE\OCs\WinPE-Dot3Svc.cab" &&^
Dism /Add-Package /Image:"C:\WinPE\mount" /PackagePath:"C:\WinPE\OCs\en-us\WinPE-Dot3Svc_en-us.cab" &&^
Dism /Add-Package /Image:"C:\WinPE\mount" /PackagePath:"C:\WinPE\OCs\winpe-pppoe.cab" &&^
Dism /Add-Package /Image:"C:\WinPE\mount" /PackagePath:"C:\WinPE\OCs\en-us\winpe-pppoe_en-us.cab" &&^
Dism /Add-Package /Image:"C:\WinPE\mount" /PackagePath:"C:\WinPE\OCs\winpe-rndis.cab" &&^
Dism /Add-Package /Image:"C:\WinPE\mount" /PackagePath:"C:\WinPE\OCs\en-us\winpe-rndis_en-us.cab" &&^
Dism /Add-Package /Image:"C:\WinPE\mount" /PackagePath:"C:\WinPE\OCs\winpe-wds-tools.cab" &&^
Dism /Add-Package /Image:"C:\WinPE\mount" /PackagePath:"C:\WinPE\OCs\en-us\winpe-wds-tools_en-us.cab" &&^
Dism /Add-Package /Image:"C:\WinPE\mount" /PackagePath:"C:\WinPE\OCs\winpe-powershell.cab" &&^
Dism /Add-Package /Image:"C:\WinPE\mount" /PackagePath:"C:\WinPE\OCs\en-us\winpe-powershell_en-us.cab" &&^
Dism /Add-Package /Image:"C:\WinPE\mount" /PackagePath:"C:\WinPE\OCs\winpe-dismcmdlets.cab" &&^
Dism /Add-Package /Image:"C:\WinPE\mount" /PackagePath:"C:\WinPE\OCs\en-us\winpe-dismcmdlets_en-us.cab" &&^
Dism /Add-Package /Image:"C:\WinPE\mount" /PackagePath:"C:\WinPE\OCs\winpe-platformid.cab" &&^
Dism /Add-Package /Image:"C:\WinPE\mount" /PackagePath:"C:\WinPE\OCs\winpe-securebootcmdlets.cab" &&^
Dism /Add-Package /Image:"C:\WinPE\mount" /PackagePath:"C:\WinPE\OCs\winpe-storagewmi.cab" &&^
Dism /Add-Package /Image:"C:\WinPE\mount" /PackagePath:"C:\WinPE\OCs\en-us\winpe-storagewmi_en-us.cab" &&^
Dism /Add-Package /Image:"C:\WinPE\mount" /PackagePath:"C:\WinPE\OCs\winpe-winrecfg.cab" &&^
Dism /Add-Package /Image:"C:\WinPE\mount" /PackagePath:"C:\WinPE\OCs\en-us\winpe-winrecfg_en-us.cab" &&^
Dism /Add-Package /Image:"C:\WinPE\mount" /PackagePath:"C:\WinPE\OCs\winpe-setup.cab" &&^
Dism /Add-Package /Image:"C:\WinPE\mount" /PackagePath:"C:\WinPE\OCs\en-us\winpe-setup_en-us.cab" &&^
Dism /Set-ScratchSpace:512 /Image:"C:\WinPE\mount" &&^
Dism /Cleanup-Image /Image:"C:\WinPE\mount" /StartComponentCleanup /ResetBase &&^
Dism /Unmount-Image /MountDir:"C:\WinPE\mount" /Commit &&^
Dism /Export-Image /SourceImageFile:"C:\WinPE\media\sources\boot.wim" /SourceIndex:1 /DestinationImageFile:"C:\WinPE\boot.wim" /DestinationName:"WinPE: Customized" /Compress:Max /Bootable /CheckIntegrity &&^
Del "C:\WinPE\media\sources\boot.wim" &&^
Copy "C:\WinPE\WinPE_Custom.wim" "C:\WinPE\media\sources\boot.wim" &&^
Del "C:\WinPE\WinPE_Custom.wim" &&^
exit
