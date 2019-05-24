#Create DNS Records for FIM
#Using the following names for FIM Services
#FIM Service : fimservice
#FIM Portal : fim
#FIM PW Reset : pwreset
#FIM PW Registration : pwreg

$zone = "company.com"
$FIMserverIPv4 = "192.168.200.120"

$FIMService = "fimservice"
$FIMPortal = "fim"
$FIMPWReset = "pwreset"
$FIMPWRegistration="pwreg"

Add-DnsServerResourceRecordA -ZoneName $zone -Name $FIMService -IPv4Address $FIMserverIPv4
Add-DnsServerResourceRecordA -ZoneName $zone -Name $FIMPortal -IPv4Address $FIMserverIPv4
Add-DnsServerResourceRecordA -ZoneName $zone -Name $FIMPWReset -IPv4Address $FIMserverIPv4
Add-DnsServerResourceRecordA -ZoneName $zone -Name $FIMPWRegistration -IPv4Address $FIMserverIPv4
