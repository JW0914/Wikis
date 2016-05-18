' Created by: Shawn Brink
' http://www.tenforums.com
' Tutorial: https://www.tenforums.com/tutorials/4543-system-restore-point-shortcut-create-windows-10-a.html 


Function GetOS    
    Set objWMI = GetObject("winmgmts:{impersonationLevel=impersonate}!\\" & ".\root\cimv2")
    Set colOS = objWMI.ExecQuery("Select * from Win32_OperatingSystem")
    For Each objOS in colOS
        If instr(objOS.Caption, "Windows 10") Then
        	GetOS = "Windows 10"
        End If
	Next
End Function

If GetOS = "Windows 10" Then
	If WScript.Arguments.length =0 Then
  		Set objShell = CreateObject("Shell.Application")
		objShell.ShellExecute "wscript.exe", Chr(34) & WScript.ScriptFullName & Chr(34) & " Run", , "runas", 1 
         Else  
               const HKEY_LOCAL_MACHINE = &H80000002
               strComputer = "."
               Set oReg=GetObject("winmgmts:{impersonationLevel=impersonate}!\\" & strComputer & "\root\default:StdRegProv")
               strKeyPath = "SOFTWARE\Microsoft\Windows NT\CurrentVersion\SystemRestore"
               strValueName = "SystemRestorePointCreationFrequency"
               oReg.SetDWORDValue HKEY_LOCAL_MACHINE,strKeyPath,strValueName,0  	
        CreateSRP  
  	End If
End If

Sub CreateSRP
	Set SRP = getobject("winmgmts:\\.\root\default:Systemrestore")
	sDesc = "Manual RP"
	sDesc = InputBox ("Please Type a Description for the Checkpoint", "Instant RP Creation","Instant SR Checkpoint")
	If Trim(sDesc) <> "" Then
		sOut = SRP.createrestorepoint (sDesc, 0, 100)
		If sOut <> 0 Then
	 		WScript.echo "Error " & sOut & ": Unable to create Restore Point."
                else 
                MsgBox "The restore point " & Chr(34) & sDesc & Chr(34) & " was created successfully.", 0, "SR Checkpoint"
		End If
	End If
End Sub

