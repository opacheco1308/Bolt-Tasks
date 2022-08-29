#[system.windows.messagebox]::show('click to continue updates detection,if no update are available the Server will logoff automatically')
$updateSession = new-object -com "Microsoft.Update.Session"; $updates=$updateSession.CreateupdateSearcher().Search($criteria).Updates
$i =0
do{
$i++
wuauclt.exe /detectnow
wuauclt.exe /reportnow
}
until ($i -le 10)
#$UpdateSession = New-Object -ComObject Microsoft.Update.Session
#$UpdateSearcher = $UpdateSession.CreateupdateSearcher()
If ($Updates = @($UpdateSearcher.Search("IsHidden=0 and IsInstalled=0").Updates))
{
$Updates | Select-Object Title }
Else
{
Write-Output "There are no updates pending on this Server"
}