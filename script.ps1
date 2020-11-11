Function Start-Monitoring {
  <# 
  $path = Get-Location
  #>
  Get-Content "./config.ini" | foreach-object -begin { $h = @{} } -process { $k = [regex]::split($_, '='); if (($k[0].CompareTo("") -ne 0) -and ($k[0].StartsWith("[") -ne $True)) { $h.Add($k[0], $k[1]) } }
  $screen = 1
  <#  #>


  While ($true) {
    $xbox = Get-PnpDevice -InstanceId  $h.Device

    if ($xbox.Status -eq "OK") {
      if ($screen -eq 1) {
        ./MultiMonitorTool.exe /disable $h.MainMonitor /enable $h.GameMonitor

        Start-Sleep 5

        Invoke-Expression $h.PlayniteExe
        ./nircmd.exe setdefaultsounddevice $h.SoundDevice

        $screen = 2
      }
    }
    else {
      if ($screen -eq 2) {
        ./MultiMonitorTool.exe /disable $h.GameMonitor /enable $h.MainMonitor
        
        taskkill /IM "Playnite.FullscreenApp.exe" /F

        $screen = 1
      }
    }
    # Do things lots
        
    # Add a pause so the loop doesn't run super fast and use lots of CPU        
    Start-Sleep 1
  }
}

Start-Monitoring
