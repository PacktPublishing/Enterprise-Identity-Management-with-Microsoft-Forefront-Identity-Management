#SQL Alias needed on FIM server
#FIM instance on SQL supposed to use port 1433
#SCSMMGTM instance on SQL supposed to use port 1533
#Ports are configured on SQL using ModifyStaticPortOnFIMSQLInstances.ps1
$sqlServerHostname="SQL.ad.company.com"

$dbFIMSync = "DBMSSOCN,$sqlServerHostname,1433"
$dbFIMService = "DBMSSOCN,$sqlServerHostname,1433"
$dbFIMSPF = "DBMSSOCN,$sqlServerHostname,1433"
$dbSCSMMgmt = "DBMSSOCN,$sqlServerHostname,1533"

#Registerlocation for x86 and x64 alias
$x86="HKLM:\Software\Wow6432Node\Microsoft\MSSQLServer\Client\ConnectTo"
$x64="HKLM:\Software\Microsoft\MSSQLServer\Client\ConnectTo"

#Skapa registerplats om de inte finns
If(!(Test-Path -Path $x86)){New-Item $x86}
If(!(Test-Path -Path $x64)){New-Item $x64}

#Skapa 32-bit alias
New-ItemProperty -Path $x86 -Name "dbFIMSync" -PropertyType String -Value $dbFIMSync
New-ItemProperty -Path $x86 -Name "dbFIMService" -PropertyType String -Value $dbFIMService
New-ItemProperty -Path $x86 -Name "dbFIMSPF" -PropertyType String -Value $dbFIMSPF
New-ItemProperty -Path $x86 -Name "dbSCSMMgmt" -PropertyType String -Value $dbSCSMMgmt

#Skapa 64-bit alias
New-ItemProperty -Path $x64 -Name "dbFIMSync" -PropertyType String -Value $dbFIMSync
New-ItemProperty -Path $x64 -Name "dbFIMService" -PropertyType String -Value $dbFIMService
New-ItemProperty -Path $x64 -Name "dbFIMSPF" -PropertyType String -Value $dbFIMSPF
New-ItemProperty -Path $x64 -Name "dbSCSMMgmt" -PropertyType String -Value $dbSCSMMgmt