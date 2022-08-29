#[system.windows.messagebox]::show('click to continue updates detection,if no update are available the Server will logoff automatically')
$updateSession = new-object -com "Microsoft.Update.Session"; $updates=$updateSession.CreateupdateSearcher().Search($criteria).Updates
$i =0
do{
$i++
wuauclt.exe /detectnow
wuauclt.exe /reportnow
}
until ($i -le 10)