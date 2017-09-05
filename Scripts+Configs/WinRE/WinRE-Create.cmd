::
               ::[[--- Custom WinRE Creation ---]]::

::================================================================
  :: Title:        WinRE-Create.cmd
  :: Description:  Creates a WinRE Image
  :: Author:       JW0914
  :: Created:      2016.08.11
  :: Updated:      2016.08.11
  :: Usage:        .\WinRE-Create.cmd
::===================================================================


::###################################################################
        ::----- Synopsis -----::
::-------------------------------------------------------------------

    :: This script will perform 3 main tasks:
        :: Create a cusom WinRE WIM for use by Recovery
        :: Create a bootable WinRE ISO
        :: Create a bootable WinRE VHD

        :: If setting the USB variable:
            :: Creates a bootable WinRE USB drive
        

::###################################################################
        ::----- Prerequisite Requirements -----::
::###################################################################

    :: Windows ADK if Windows >8
        :: Windows Preinstallation Environment selected
    
    :: Windows AIK if Windows <7
        :: Windows Preinstallation Environment selected
    
    :: Recovery partition mounted as Drive X:\
    
    :: Add the following to System Path:
        :: C:\Program Files (x86)\Windows Kits\10\Assessment and Deployment Kit\Deployment Tools\amd64\DISM
        :: C:\Program Files (x86)\Windows Kits\10\Assessment and Deployment Kit\Deployment Tools\amd64\Oscdimg
        :: C:\Program Files (x86)\Windows Kits\10\Assessment and Deployment Kit\Windows Preinstallation Environment


::###################################################################
        ::--- Set Variables ---::
::-------------------------------------------------------------------

@echo off


::###################################################################
        ::--- End User Customizable Variables ---::
::-------------------------------------------------------------------

::    Set to Directory Containing Custom Files      ::
::        to be Included in the Image               ::

set PE-Custom=D:\JW0914\Documents\Microsoft\WinPE


::   Set USB Drive letter if wishing to make a      ::
::     bootable WinRE USB ( E: F: or G: etc.)       ::     

set USB=


::###################################################################
        ::---  Do not change if one is not familiar ---::
::-------------------------------------------------------------------

set PE-Build=C:\Temp\PE5

set date=%date:~0,4%%date:~5,2%%date:~8,2%
set del=del /Q /F C:\Temp\PE5\Media\Sources\*.xml
set Drivers=%PE-Build%\Drivers
set dtime=%time:~0,2%%time:~3,2%.%time:~6,2%
set DP=diskpart -s

set L=^ echo.
set Log=/NP /TS /TEE /LOG+:"%PE-Build%\%date%_%dtime%.log"

set Make="C:\Program Files (x86)\Windows Kits\10\Assessment and Deployment Kit\Windows Preinstallation Environment\MakeWinPEMedia.cmd"
set MakeISO=Oscdimg -n -m -oc -d -h -lWin10-PE5 -ADD -bC:\Temp\PE5\Media\boot\etfsboot.com
set MakeUSB=%Make% /UFD
set MakeVHD=%Make% /UFD
set MD=C:\Mount

set PE-EFI=C:\Program Files (x86)\Windows Kits\10\Assessment and Deployment Kit\Deployment Tools
set PE-Lang=C:\Temp\PE\WinPE_OCs\en-us
set PE-Media="C:\Program Files (x86)\Windows Kits\10\Assessment and Deployment Kit\Windows Preinstallation Environment\amd64\Media"
set PE-OC=C:\Temp\PE\WinPE_OCs
set PE-Sources=C:\Temp\PE5\Media\Sources
set PKG=DISM /Image:C:\MOUNT /Add-Package /PackagePath

set RE=%PE-Build%\WIM\winre.wim
set Robo=robocopy /E /ZB /ETA /V /ETA /MT:30 %Log%

set WIM-Ex=DISM /Export-Image /SourceImageFile:%RE% /SourceIndex:1
set WIM-M=DISM /Mount-Image /ImageFile:%RE% /Index:1 /MountDir:%MD%
set WIM-U=DISM /Unmount-WIM /MountDir:%MD%
set WinRE=X:\Recovery\WindowsRE


::###################################################################
        ::--- Prequisites ---::
::-------------------------------------------------------------------

::--- Prequisites ---::
%L% & %L% & %L%
echo [[-----::  Prequisites  ::-----]]
%L% & %L% & %L%

    :: Disable WinRE ::
    %L% & %L% & %L%
    echo ...Disabling WinRE...
    %L%
    reagentc /disable

    :: Make Working Directory ::
    %L% & %L%
    echo ...Creating working directory...
    %L%
    mkdir %MD%

    :: Copy WIM Base Image ::
    %L% & %L% & %L%
    echo ...Copy WinRE from System...
    %L%
    mkdir %WinRE%
    %L%
    %Robo% C:\Windows\System32\Recovery %PE-Build%\WIM

    :: Mount WIM ::
    %L% & %L% & %L%
    echo ...Mounting WIM for customization...
    %L%
    %WIM-M%


::###################################################################
        ::--- Begin Phase 1 ---::
::-------------------------------------------------------------------

%L% & %L% & %L% & %L% & %L%
echo [[-----::  Phase I:  Customizing Image  ::-----]]
%L% & %L% & %L%


    :: Set Default Scratch Size ::
    %L% & %L% & %L%
    echo ...Set WIM Scratch Space...
    %L%
    dism /Set-ScratchSpace:512 /Image:%MD%

    :: Copy Custom Files ::
    %L% & %L% & %L%
    echo ...Adding Custom Files...
    %L%
    %Robo% %PE-Custom%\Image %MD%
    %L% & %L% & %L% & %L% & %L%


::###################################################################
        ::--- Begin Phase 2 ---::
::-------------------------------------------------------------------

%L% & %L% & %L% & %L% & %L%
echo [[-----::  Phase II:  Adding Components  ::-----]]
%L% & %L% & %L%


    :: Scripting ::
      :: Must be added first to PE/RE image ::
    ::---------------------------------------------------------------
    %L% & %L% & %L%
    echo ...Adding Scripting...
    %L%
    %PKG%:"%PE-OC%\WinPE-Scripting.cab"
    %L%
    %PKG%:"%PE-Lang%\WinPE-Scripting_en-us.cab"

    %L% & %L% & %L%
    echo ...Adding WMI...
    %L%
    %PKG%:"%PE-OC%\WinPE-WMI.cab"
    %L%
    %PKG%:"%PE-Lang%\WinPE-WMI_en-us.cab"

    :: Startup ::
    ::---------------------------------------------------------------
    %L% & %L% & %L%
    echo ...Adding Secure Startup...
    %L%
    %PKG%:"%PE-OC%\WinPE-SecureStartup.cab"
    %L%
    %PKG%:"%PE-Lang%\WinPE-SecureStartup_en-us.cab"

    :: File Management ::
    ::---------------------------------------------------------------
    %L% & %L% & %L%
    echo ...Adding FMAPI...
    %L%
    %PKG%:"%PE-OC%\WinPE-FMAPI.cab"

    :: Microsoft .NET
      ::  Dependencies: WinPE-WMI ::
    ::---------------------------------------------------------------
    %L% & %L% & %L%
    echo ...Adding netFx...
    %L%
    %PKG%:"%PE-OC%\WinPE-NetFx.cab"
    %L%
    %PKG%:"%PE-Lang%\WinPE-NetFx_en-us.cab"

    :: Networking ::
    ::---------------------------------------------------------------
    %L% & %L% & %L%
    echo ...Adding Dot3Svc...
    %L%
    %PKG%:"%PE-OC%\WinPE-Dot3Svc.cab"
    %L%
    %PKG%:"%PE-Lang%\WinPE-Dot3Svc_en-us.cab"

    %L% & %L% & %L%
    echo ...Adding PPPoE...
    %L%
    %PKG%:"%PE-OC%\WinPE-PPPoE.cab"
    %L%
    %PKG%:"%PE-Lang%\WinPE-PPPoE_en-us.cab"

    %L% & %L% & %L%
    echo ...Adding RNDIS...
    %L%
    %PKG%:"%PE-OC%\WinPE-RNDIS.cab"
    %L%
    %PKG%:"%PE-Lang%\WinPE-RNDIS_en-us.cab"

    %L% & %L% & %L%
    echo ...Adding WDS-Tools...
    %L%
    %PKG%:"%PE-OC%\WinPE-WDS-Tools.cab"
    %L%
    %PKG%:"%PE-Lang%\WinPE-WDS-Tools_en-us.cab"

    :: PowerShell 
      :: Dependencies: WinPE-WMI, WinPE-NetFX, WinPE-SecureStartup ::
    ::---------------------------------------------------------------
    %L% & %L% & %L%
    echo ...Adding PowerShell...
    %L%
    %PKG%:"%PE-OC%\WinPE-PowerShell.cab"
    %L%
    %PKG%:"%PE-Lang%\WinPE-PowerShell_en-us.cab"

    :: dism ::
      :: Dependencies: WinPE-WMI, WinPE-NetFX, WinPE-Scripting, WinPE-PowerShell ::
    ::---------------------------------------------------------------
    %L% & %L% & %L%
    echo ...Adding dism Cmdlets...
    %L%
    %PKG%:"%PE-OC%\WinPE-dismCmdlets.cab"
    %L%
    %PKG%:"%PE-Lang%\WinPE-dismCmdlets_en-us.cab"

    %L% & %L% & %L%
    echo ...Adding Secure Boot Cmdlets...
    %L%
    %PKG%:"%PE-OC%\WinPE-SecureBootCmdlets.cab"

    %L% & %L% & %L%
    echo ...Adding Storage WMI...
    %L%
    %PKG%:"%PE-OC%\WinPE-StorageWMI.cab"
    %L%
    %PKG%:"%PE-Lang%\WinPE-StorageWMI_en-us.cab"

    :: Recovery ::
    ::---------------------------------------------------------------
    %L% & %L% & %L%
    echo ...Adding WinRE CFG...
    %L%
    %PKG%:"%PE-OC%\WinPE-WinReCfg.cab"
    %L%
    %PKG%:"%PE-Lang%\WinPE-WinReCfg_en-us.cab"

    :: Storage ::
    ::---------------------------------------------------------------
    %L% & %L% & %L%
    echo ...Adding Enhanced Storage...
    %L%
    %PKG%:"%PE-OC%\WinPE-EnhancedStorage.cab"
    %L%
    %PKG%:"%PE-Lang%\WinPE-EnhancedStorage_en-us.cab"
    %L% & %L% & %L% & %L% & %L%


::###################################################################
        ::--- Begin Phase 3 ---::
::-------------------------------------------------------------------

%L% & %L% & %L% & %L% & %L%
echo [[-----::  Phase III:  Adding Drivers  ::-----]]
%L% & %L% & %L%
%L% & %L% & %L% & %L% & %L%


    :: Add Drivers ::
    ::---------------------------------------------------------------
    ::%L% & %L% & %L%
    ::echo ...Injecting Drivers...
    ::%L%
    ::dism /Image:%MD% /Add-Driver /Driver:%PE-Build%\Drivers\WinPE /Recurse /ForceUnsigned


::###################################################################
        ::--- Begin Phase 4: Cleanup ---::
::-------------------------------------------------------------------

%L% & %L% & %L% & %L% & %L%
echo [[-----::  Phase IV:  Cleanup  ::-----]]
%L% & %L% & %L%


    ::Commit Changes ::
    %L% & %L% & %L%
    echo ...Unmounting WIM...
    %L%
    %WIM-U% /Commit

    :: Image Optimization::
    %L% & %L% & %L%
    echo ...Exporting WIM..
    %L%
    %WIM-Ex% /DestinationImageFile:%PE-Build%\WIM\winre_Optimized.wim
    %L%
    del /F /Q /A %RE%
    %L%
    ren %PE-Build%\WIM\winre_Optimized.wim winre.wim

    :: Copy WinRE ::
    %L% & %L% & %L%
    echo ...Copy WinRE to WindowsRE...
    %L%
    %Robo% %PE-Build%\WIM %WinRE%

    :: Re-Enable WinRE ::
    %L% & %L% & %L%
    echo ...Enable WinRE...
    %L%
    reagentc /setreimage /path %WinRE%\%RE%

    :: Enable WinRE ::
    %L% & %L% & %L%
    echo ...Enabling WinRE...
    %L%
    reagentc /enable
    %L%
    %L% & %L% & %L% & %L% & %L%


::###################################################################
        ::--- Begin Phase 5 ---::
::-------------------------------------------------------------------

%L% & %L% & %L% & %L% & %L%
echo [[-----::  Phase V:  Bootable Media Creation  ::-----]]
%L% & %L% & %L%


    :: Create WinPE Boot Files ::
    %L% & %L% & %L%
    echo ...Copying WinPE Boot Files to Build Folder...
    %L%
    %Robo% %PE-Media% %PE-Build%\Media

    :: Copy WinRE ::
    %L% & %L% & %L%
    echo ...Copy WinRE to WinPE Build Folder...
    %L%
    %Robo% %PE-Build%\WIM %PE-Sources%
    %L%
    echo .....Rename WinRE to boot.wim.....
    %L%
    rename %PE-Sources%\winre.wim boot.wim & %del%

    :: VHD ::
    ::---------------------------------------------------------------

    :: Mount WinRE ::
    %L% & %L% & %L%
    echo ...Mounting WIM for VHD Creation...
    %L%
    %WIM-M%

    :: Create and Attach VHD ::
    %L% & %L% & %L%
    echo ...Creating VHD...
    %L%
    %DP% %PE-Custom%\Attach-WinPE-VHD.txt

    :: Create WinPE VHD ::
    %L% & %L% & %L%
    echo ...Copying WinPE to VHD...
    %L%
    call %MakeVHD% %PE-Build% W:

    :: Detach VHD ::
    %L% & %L% & %L%
    echo ...Detaching VHD...
    %L%
    %DP% %PE-Custom%\Detach-WinPE-VHD.txt


    :: ISO ::
    ::---------------------------------------------------------------

    :: Create Bootable ISO ::
    %L% & %L% & %L%
    echo ...Creating Bootable ISO...
    %L%
    %MakeISO% %PE-Build%\Media %PE-Build%\Win10-PE5.iso


    :: USB ::
    ::---------------------------------------------------------------

    :: Create Bootable USB ::
      :: Change F: to drive letter of USB
    %L% & %L% & %L%
    echo ...Creating Bootable USB...
    %L%
    %MakeUSB% %PE-Build% %USB%


    :: Unmount WIM ::
    %L% & %L% & %L%
    echo ...Unmounting WIM...
    %L%
    %WIM-U% /discard

    :: Cleanup ::
    %L% & %L% & %L%
    echo ...Cleaning Up...
    %L%
    RD %MD%
    %L%

    :: Review for Errors ::
    %L% & %L% & %L%
    echo ...REVIEW OUTPUT FOR ERRORS...
    %L%
    pause

