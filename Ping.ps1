$WARNTHRESHOLD = 500
$next = $null
while ($true) {
  $date = Get-Date
  
  if ($next) {
    $gap = New-TimeSpan -Start $next -End $date
    if ($gap.TotalMilliseconds -gt 500) {
      Write-Host "…$($gap.ToString())…" -ForegroundColor DarkGray
    }
  }
  
  try {
    $result = Test-Connection -TargetName 4.2.2.2 -Count 1 -TimeoutSeconds 1 -ErrorAction Stop
    $color = $result.Status -eq "Success" ? ($result.Latency -le $WARNTHRESHOLD ? "Green" : "Yellow") : "Red"
  } catch {
    $color = "Red"
  }

  $time = Get-Date $date -Format "HH:mm:ss.fff"
  Write-Host ("{0} {1,5} ms {2}" -f $time, $result.Latency, $result.Status) -Foreground $color
  
  $now = Get-Date
  $next = $now.AddSeconds(1).AddMilliseconds(- $now.Millisecond + 1)
  $timespan = New-TimeSpan -Start $now -End $next
  Start-Sleep $timespan
}