#PowerShell to Modify ports used by FIM SQL instances
#FIM instance name is FIM and port is set to 1433
#SCSM Managment instance name is SCSMMGMT and port is set to 1533

$hostname="SQL.ad.company.com"
Import-Module SQLPS

#Modify FIM instance
$smo = 'Microsoft.SqlServer.Management.Smo.'
$wmi = New-Object ($smo + 'Wmi.ManagedComputer')
$uri = "ManagedComputer[@Name='$hostname']/ServerInstance[@Name='FIM']/ServerProtocol[@Name='Tcp']"
$tcp = $wmi.GetSmoObject($uri)

#Set static port
$wmi.GetSmoObject($uri+"/IPAddress[@Name='IPAll']").IPAddressProperties[1].Value="1433"
#Clear dynamic port
$wmi.GetSmoObject($uri+"/IPAddress[@Name='IPAll']").IPAddressProperties[0].Value=""
#Commit change
$tcp.Alter()

#Modify SCSMMGMT instance
$smo = 'Microsoft.SqlServer.Management.Smo.'
$wmi = New-Object ($smo + 'Wmi.ManagedComputer')
$uri = "ManagedComputer[@Name='$hostname']/ServerInstance[@Name='SCSMMGMT']/ServerProtocol[@Name='Tcp']"
$tcp = $wmi.GetSmoObject($uri)

#Set static port
$wmi.GetSmoObject($uri+"/IPAddress[@Name='IPAll']").IPAddressProperties[1].Value="1533"
#Clear dynamic port
$wmi.GetSmoObject($uri+"/IPAddress[@Name='IPAll']").IPAddressProperties[0].Value=""
#Commit change
$tcp.Alter()