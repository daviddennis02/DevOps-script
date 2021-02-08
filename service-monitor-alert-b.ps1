 # Powershell script to Get Apache Webserver service, watch it and restart if the service is stopped.
Clear-Host
$ServiceName = "Apache-Webserver"
$ServiceState = Get-Service $ServiceName
$SMTP = "smtp.gmail.com"
$MyEmail = "dennis.david02@gmail.com"
$Creds = (Get-Credential -Credential "$MyEmail")
#dennis.david02@gmail.com

if($ServiceState.Status -eq "Running"){

    Write-Output "Apache is running"
    Send-MailMessage -From  $MyEmail  -To "dennisdavid02@gmail.com" -Subject "Apache Monitor" -Body "Apache is running" -DeliveryNotificationOption OnSuccess, OnFailure -SmtpServer $SMTP -Credential $Creds -UseSsl -Port 587

} else {

    Write-Output "Apache is stopped"
} 
