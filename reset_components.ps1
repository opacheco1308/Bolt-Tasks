#Resets the Windows Update components
#DESCRIPTION 
#This script will reset all of the Windows Updates components to defaults.

 
Write-Host "1. Stopping Windows Update Services..."
Stop-Service -Name wuauserv
 
Write-Host "2. Renaming the Software Distribution..."

$Foldername1="C:\Windows\SoftwareDistribution"
$Foldername2="C:\Windows\SoftwareDistribution.bak"
If (Test-Path $Foldername2) 
{
Remove-Item -Recurse -Force $Foldername2 }
else
 {
Rename-item $Foldername1 -NewName $Foldername2 }
 
Write-Host "3. Removing old Windows Update log..."
Remove-Item -Path C:\Windows\WindowsUpdate.log -Force  
 
Write-Host "4. Removing WSUS client registry settings..."
reg Delete HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate /v SusClientId /f  
reg Delete HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate /v SusClientIDValidation /f 
 
Write-Host "5. Resetting the WinSock..."
netsh winsock reset
 
 
Write-Host "6. Starting Windows Update Services..."
Start-Service -Name wuauserv

 
Write-Host "7. Forcing discovery..."
wuauclt /resetauthorization /detectnow
 
Write-Host "Process complete. Server will reboot, please check WSUS Server"
Restart-Computer -force