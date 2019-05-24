#Script creates required service accounts and groups to install and run 
#FIM Sync, FIM Service, FIM Portals (including SSPR) and FIM Reporting. 
#Script will ask for several account passwords during its run.
#Script uses svc prefix for service accounts and adm prefix for groups.

#NOTE! AD domain is ad.company.com in example but DNS domain is company.com

#Global variables
$userPath = "OU=FIM,OU=Service Accounts,DC=ad,DC=company,DC=com"
$upnSuffix = "company.com"
$groupPath = "OU=FIM,OU=Groups,DC=ad,DC=company,DC=comL"
$portalHostname = "fim.company.com"
$serviceHostname = "fimservice.company.com"
$pwRegHostname = "pwreg.company.com"

Import-Module ActiveDirectory

#Accounts to $userPAth

#svcFIMAdmin : FIM administrator
New-ADUser svcFIMAdmin -SamAccountName svcFIMAdmin -UserPrincipalName svcFIMAdmin@$upnSuffix -GivenName FIM -Surname Admin -DisplayName "FIM Admin" -Description "FIM administrator" -Path $userPath -AccountPassword (Read-Host -AsSecureString "AccountPassword (FIM Admin)") -ChangePasswordAtLogon $false -PasswordNeverExpires $true -Enabled $true

#svcFIMSync : FIM Synchronization Service serviceaccount
New-ADUser svcFIMSync -SamAccountName svcFIMSync -UserPrincipalName svcFIMSync@$upnSuffix -GivenName FIM -Surname Sync -DisplayName "FIM Sync" -Description "FIM Synchronization Service service account" -Path $userPath -AccountPassword (Read-Host -AsSecureString "AccountPassword (FIM Sync)") -ChangePasswordAtLogon $false -PasswordNeverExpires $true -Enabled $true

#svcFIMMA : FIM Management Agent account
New-ADUser svcFIMMA -SamAccountName svcFIMMA -UserPrincipalName svcFIMMA@$upnSuffix -GivenName FIM -Surname MA -DisplayName "FIM MA" -Description "FIM Management Agent account" -Path $userPath -AccountPassword (Read-Host -AsSecureString "AccountPassword (FIM MA)") -ChangePasswordAtLogon $false -PasswordNeverExpires $true -Enabled $true

#svcFIMService  :  FIM Service serviceaccount
New-ADUser svcFIMService -SamAccountName svcFIMService -UserPrincipalName svcFIMService@$upnSuffix -GivenName FIM -Surname Service -DisplayName "FIM Service" -Description "FIM Service service account" -Path $userPath -AccountPassword (Read-Host -AsSecureString "AccountPassword (FIM Service)") -ChangePasswordAtLogon $false -PasswordNeverExpires $true -Enabled $true

#svcFIMPWResetPool : FIM Password Reset portal application pool identity
New-ADUser svcFIMPWResetPool -SamAccountName svcFIMPWResetPool -UserPrincipalName svcFIMPWResetPool@$upnSuffix -GivenName FIM -Surname PWResetPool -DisplayName "FIM PWReset Pool" -Description "FIM Password Reset portal application pool identity" -Path $userPath -AccountPassword (Read-Host -AsSecureString "AccountPassword (FIM PWReset Pool)") -ChangePasswordAtLogon $false -PasswordNeverExpires $true -Enabled $true

#svcFIMPWRegPool : FIM Password Registration portal application pool identity
New-ADUser svcFIMPWRegPool -SamAccountName svcFIMPWRegPool -UserPrincipalName svcFIMPWRegPool@$upnSuffix -GivenName FIM -Surname PWRegPool -DisplayName "FIM PWReg Pool" -Description "FIM Password Registration portal application pool identity" -Path $userPath -AccountPassword (Read-Host -AsSecureString "AccountPassword (FIM PWReg Pool)") -ChangePasswordAtLogon $false -PasswordNeverExpires $true -Enabled $true

#svcFIMSPFPool : FIM SPF (SharePoint Foundation) application pool identity
New-ADUser svcFIMSPFPool -SamAccountName svcFIMSPFPool -UserPrincipalName svcFIMSPFPool@$upnSuffix -GivenName FIM -Surname SPFPool -DisplayName "FIM SPF Pool" -Description "FIM SPF (SharePoint Foundation) application pool identity" -Path $userPath -AccountPassword (Read-Host -AsSecureString "AccountPassword (FIM SPF Pool)") -ChangePasswordAtLogon $false -PasswordNeverExpires $true -Enabled $true

#svcFIMSPFFarm : FIM SPF farmaccount
New-ADUser svcFIMSPFFarm -SamAccountName svcFIMSPFFarm -UserPrincipalName svcFIMSPFFarm@$upnSuffix -GivenName FIM -Surname SPFFarm -DisplayName "FIM SPF Farm" -Description "FIM SPF farm account" -Path $userPath -AccountPassword (Read-Host -AsSecureString "AccountPassword (FIM SPF Farm)") -ChangePasswordAtLogon $false -PasswordNeverExpires $true -Enabled $true

#svcFIMSCSMAdmin : FIM SCSM (System Center Service Manager) administrator
New-ADUser svcFIMSCSMAdmin -SamAccountName svcFIMSCSMAdmin -UserPrincipalName svcFIMSCSMAdmin@$upnSuffix -GivenName FIM -Surname SCSMAdmin -DisplayName "FIM SCSM Admin" -Description "FIM SCSM (System Center Service Manager) administrator" -Path $userPath -AccountPassword (Read-Host -AsSecureString "AccountPassword (FIM SCSM Admin)") -ChangePasswordAtLogon $false -PasswordNeverExpires $true -Enabled $true

#svcFIMSQLAdmin : FIM SQL administrator
New-ADUser svcFIMSQLAdmin -SamAccountName svcFIMSQLAdmin -UserPrincipalName svcFIMSQLAdmin@$upnSuffix -GivenName FIM -Surname SQLAdmin -DisplayName "FIM SQL Admin" -Description "FIM SQL administrator" -Path $userPath -AccountPassword (Read-Host -AsSecureString "AccountPassword (FIM SQL Admin)") -ChangePasswordAtLogon $false -PasswordNeverExpires $true -Enabled $true


#Groups to $groupPath
#FIM.Admin : FIM administrator role
New-ADGroup -Name FIM.Admin -SamAccountName FIM.Admin -GroupCategory Security -GroupScope DomainLocal -DisplayName "FIM Administrators" -Description "FIM administrator role" -Path $groupPath
Add-ADGroupMember -Identity FIM.Admin -Members svcFIMAdmin

#FIM.SCSMAdmin : FIM SCSM administrator role
New-ADGroup -Name FIM.SCSMAdmin -SamAccountName FIM.SCSMAdmin -GroupCategory Security -GroupScope DomainLocal -DisplayName "FIM SCSM Administrators" -Description "FIM SCSM administrator role" -Path $groupPath
Add-ADGroupMember -Identity FIM.SCSMAdmin -Members svcFIMSCSMAdmin
Add-ADGroupMember -Identity FIM.SCSMAdmin -Members FIM.Admin

#FIM.SQLAdmin : FIM SQL administrator role
New-ADGroup -Name FIM.SQLAdmin -SamAccountName FIM.SQLAdmin -GroupCategory Security -GroupScope DomainLocal -DisplayName "FMKTj SQL Administrators" -Description "FIM SQL administrator role" -Path $groupPath
Add-ADGroupMember -Identity FIM.SQLAdmin -Members svcFIMSQLAdmin
Add-ADGroupMember -Identity FIM.SQLAdmin -Members FIM.Admin
Add-ADGroupMember -Identity FIM.SQLAdmin -Members FIM.SCSMAdmin

#Groups for FIM Synchronization service roles
#FIM.SyncAdmins : FIM Synchronization Service administrators
New-ADGroup -Name FIM.SyncAdmins -SamAccountName FIM.SyncAdmins -GroupCategory Security -GroupScope DomainLocal -DisplayName "FIM Sync Admins" -Description "FIM Synchronization Service administrators" -Path $groupPath
Add-ADGroupMember -Identity FIM.SyncAdmins -Members FIM.Admin
Add-ADGroupMember -Identity FIM.SyncAdmins -Members svcFIMService

#FIM.SyncBrowse : FIM Synchronization Service browsers
New-ADGroup -Name FIM.SyncBrowse -SamAccountName FIM.SyncBrowse -GroupCategory Security -GroupScope DomainLocal -DisplayName "FIM Sync Browse" -Description "FIM Synchronization Service browsers" -Path $groupPath

#FIM.SyncJoiners : FIM Synchronization Service joiners
New-ADGroup -Name FIM.SyncJoiners -SamAccountName FIM.SyncJoiners -GroupCategory Security -GroupScope DomainLocal -DisplayName "FIM Sync Joiners" -Description "FIM Synchronization Service joiners" -Path $groupPath

#FIM.SyncOperators : FIM Synchronization Service operators
New-ADGroup -Name FIM.SyncOperators -SamAccountName FIM.SyncOperators -GroupCategory Security -GroupScope DomainLocal -DisplayName "FIM Sync Operators" -Description "FIM Synchronization Service operators" -Path $groupPath

#FIM.SyncPasswordSet : FIM Synchronization Service password set and change
New-ADGroup -Name FIM.SyncPasswordSet -SamAccountName FIM.SyncPasswordSet -GroupCategory Security -GroupScope DomainLocal -DisplayName "FIM Sync PW Set" -Description "FIM Synchronization Service password set and change" -Path $groupPath
Add-ADGroupMember -Identity FIM.SyncPasswordSet -Members svcFIMService


#Kerberos konfiguration
#SPN (Service Principal Name)
SETSPN -S http/$portalHostname svcFIMSPFPool
SETSPN -S fimservice/$serviceHostname svcFIMService
SETSPN -S http/$pwRegHostname svcFIMPWRegPool

#Delegation (msDS-AllowedToDelegateTo)
Set-ADuser -Identity svcFIMSPFPool -Add @{"msDS-AllowedToDelegateTo" = "fimservice/$serviceHostname"}
Set-ADuser -Identity svcFIMService -Add @{"msDS-AllowedToDelegateTo" = "fimservice/$serviceHostname"}
Set-ADuser -Identity svcFIMPWRegPool -Add @{"msDS-AllowedToDelegateTo" = "fimservice/$serviceHostname"}
