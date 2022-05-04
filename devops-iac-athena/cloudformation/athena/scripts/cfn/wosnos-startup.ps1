
$nosFile = "C:\Athena\opt\nos_service\InstallService.bat"
$wosFile = "C:\Athena\opt\opt_service\InstallService.bat"
$wnHost = "$(C:\Athena\bin\get-localip.ps1)"
(Get-Content -path $nosFile -Raw) -replace 'WOSNOSHost',$wnHost | Set-Content -Path $nosFile
(Get-Content -path $wosFile -Raw) -replace 'WOSNOSHost',$wnHost | Set-Content -Path $wosFile
C:\Athena\opt\nos_service\InstallService.bat
C:\Athena\opt\opt_service\InstallService.bat

C:\Athena\opt\nos_service\StartService.bat
C:\Athena\opt\opt_service\StartService.bat