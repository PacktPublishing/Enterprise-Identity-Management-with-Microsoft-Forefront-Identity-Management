#Add SPF PSSnapin
Add-PSSnapin Microsoft.SharePoint.PowerShell

#Initialize values required for the script
#FYI: SQL Alias used for FIM SPF is dbFIMSPF
$Domain = "AD"
$dbConfig = "FIM_SPF_Config"
$dbAdminConfig = "FIM_SPF_Admin_Content"
$dbContent = "FIM_SPF_Content"
$dbServer = "dbFIMSPF"
$Passphrase = "P@ssPhr@s3"
$SecPhassphrase = (ConvertTo-SecureString -String $Passphrase -AsPlainText -force)
$FarmAdminUser = $Domain + "\svcFIMSPFFarm"
$svcFIMPool = $Domain + "\svcFIMSPFPool"
$FIMPortalName = "fim.company.com"
$FIMPortalURL = "https://fim.company.com"
$FIMAdmin=$Domain+"\svcFIMAdmin"


#Create new configuration database
#Will prompt for Farm Admin credentials
New-SPConfigurationDatabase -DatabaseName $dbConfig -DatabaseServer $dbServer -AdministrationContentDatabaseName $dbAdminConfig -Passphrase $SecPhassphrase -FarmCredentials (Get-Credential -Message "FarmAdmin user" -UserName $FarmAdminUser)

#Create new Central Administration site
$caPort = "2013"
$caAuthProvider = "NTLM"
New-SPCentralAdministration -Port $caPort -WindowsAuthProvider $caAuthProvider

#Perform the config wizard tasks
#Install Help Collections
Install-SPHelpCollection -All 
#Initialize security
Initialize-SPResourceSecurity
#Install services
Install-SPService
#Register features
Install-SPFeature -AllExistingFeatures
#Install Application Content
Install-SPApplicationContent

#Add managed account for Application Pool
New-SPManagedAccount -Credential (Get-Credential -Message "FIMSPFPool Account" -UserName $($svcFIMPool))

#Create new ApplicationPool
New-SPServiceApplicationPool -Name FIMSPFPool -Account $svcFIMPool

#Create new Web Application.
#This creates a Web application that uses classic mode windows authentication.
#Claim-based authentication is not supported by FIM
New-SPWebApplication -Name "FIM" -Url $FIMPortalURL -Port 443 -HostHeader $FIMPortalName -SecureSocketsLayer:$true -ApplicationPool "FIMSPFPool" -ApplicationPoolAccount (Get-SPManagedAccount $($svcFIMPool)) -AuthenticationMethod "Kerberos" -DatabaseName $dbContent

#Create new SP Site
New-SPSite -Name "FIM Portal" -Url $FIMPortalURL -CompatibilityLevel 14 -Template "STS#0" -OwnerAlias $FarmAdminUser

#Disable server-side view state. Required by FIM
$contentService = [Microsoft.SharePoint.Administration.SPWebService]::ContentService
$contentService.ViewStateOnServer = $false
$contentService.Update()

#Disable Self-Service Upgrade to 2013 experience mode.
#2013 Experience mode is not supported by FIM
$SPSite = SPSite($FIMPortalURL)
$SPSite.AllowSelfServiceUpgrade = $false

#Add svcFIMAdmin as secondary collection administrator
Set-SPSite -Identity $FIMPortalURL -SecondaryOwnerAlias $FIMAdmin

#SPF 2013 Ready for FIM Installation