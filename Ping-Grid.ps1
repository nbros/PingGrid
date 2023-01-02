$WARNTHRESHOLD = 500
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$prevDate = $null
$pos = 0
Write-Host -NoNewline ("     ┌" + "─" * 60 + "┐") -ForegroundColor DarkGray
while ($true) {
    $date = Get-Date
    if (-not $prevDate -or $prevDate.Minute -ne $date.Minute) {
        if ($prevDate -and $prevDate.Minute -ne ($date.Minute - 1) -and -not ($prevDate.Minute -eq 59 -and $date.Minute -eq 0)) {
            while ($pos -lt 60) {
                Write-Host -NoNewline "·" -ForegroundColor DarkGray
                $pos++
            }
            # gap
            Write-Host -NoNewline "`n·····" -ForegroundColor DarkGray
        }
        $HHmm = Get-Date $date -Format "HH:mm"
        Write-Host -NoNewline "`n$HHmm " -ForegroundColor Gray
        $pos = 0
        $prevDate = $date
    }

    while ($pos -lt $date.Second) {
        Write-Host -NoNewline "·" -ForegroundColor DarkGray
        $pos++
    }

    try {
        $result = Test-Connection -TargetName 4.2.2.2 -Count 1 -TimeoutSeconds 1 -ErrorAction Stop
        $color = $result.Status -eq "Success" ? ($result.Latency -le $WARNTHRESHOLD ? "Green" : "Yellow") : "Red"
    } catch {
        $color = "Red"
    }
    
    Write-Host -NoNewline "■" -ForegroundColor $color
    $pos++

    $now = Get-Date
    $next = $now.AddSeconds(1).AddMilliseconds(- $now.Millisecond + 1)
    $timespan = New-TimeSpan -Start $now -End $next
    Start-Sleep $timespan
}