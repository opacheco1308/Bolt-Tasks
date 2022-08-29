##########################################################################################################
#Creating a scheduled task, WinRM is so dumb that dont allow COM direct call from a remote WinRM session.#
##########################################################################################################

 


#Verify if the scheduled job exist if its, delete it, this will alway push the last version of the job
$job = Get-ScheduledJob | Where-Object {$_.Name -like "InstallUpdates*"}
    if($job.Name -eq "InstallUpdates"){Unregister-ScheduledJob  $job.Name}

 


$task = Register-ScheduledJob -Name "InstallUpdates" -RunNow  -ScriptBlock {

 

#ScheduleJob variables
$Date = (get-date).ToString("yyyyMd-HH:MM:ss")
$dmes = $Date+',' +$env:COMPUTERNAME
$logfile = ''
$logfile = 'C:\log.csv'

 


#Define update criteria.
$Criteria = "IsInstalled=0 and Type='Software'"

 

#Search for relevant updates.
$Searcher = New-Object -ComObject Microsoft.Update.Searcher
$SearchResult = $Searcher.Search($Criteria).Updates

 

if ($SearchResult.Count -eq 0)
    {$dmes+',' + "There is no update to apply" >> $logfile}
     Else
     {{$dmes+ ','+ "There are $($SearchResult.Count) patches to install" >> $logfile}
        #Download updates.
        $Session = New-Object -ComObject Microsoft.Update.Session
        $Downloader = $Session.CreateUpdateDownloader()
        $Downloader.Updates = $SearchResult
        $Downloader.Download()
        #Install updates.
        $Installer = New-Object -ComObject Microsoft.Update.Installer
        $Installer.Updates = $SearchResult
        $InstallerResult = $Installer.Install()
            if ($InstallerResult -eq 2) 
                {$dmes+ ','+ "All patches has been successfully installed" >> $logfile}
                else 
                    {$dmes+ ','+ "One or more updates were not installed" >> $logfile}   
#Reboot
$dmes+ ','+ "Restarting" >> $logfile 
shutdown.exe /t 0 /r
  }
}