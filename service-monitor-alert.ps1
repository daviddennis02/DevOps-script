# PowerShell cmdlet to start a named service
Clear-Host
$srvName = "PLA"
$servicePrior = Get-Service $srvName
"$srvName is now " + $servicePrior.status
Set-Service $srvName -startuptype manual
Start-Service $srvName
$serviceAfter = Get-Service $srvName
"$srvName is now " + $serviceAfter.status