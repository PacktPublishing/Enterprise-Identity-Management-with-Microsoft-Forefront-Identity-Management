In this download you will find a lot of scripts and configuration files that are required to configure the pre-requisites for a typical 4-server FIM setup as show in FIMFourServerSetup.png.

Hardware setup for each server could be something like this.
Role / Service	CPU / Memory / Disk	Description
SQL Server	CPU 3 pc	 	SQL Server with 2 instances for FIM and SCSM Management databases
		Memory: 8GB
		Disk:
		C: (OS) 40GB
		D: (Data) 100GB

SCSM Mgmt	CPU 1 pc	 	SCSM Management Server
		Memory: 2GB
		Disk: 
		C: 40GB

SCSM DW		CPU 3 pc	 	SQL Server and SCSM DW Management Server
		Memory: 8GB
		Disk 
		C: (OS) 40GB
		D: (Data) 100GB

FIM		CPU 3 pc	 	FIM 2010 R2 SP1. Synchronization Service, FIM Service, FIM Portals.
		Memory: 6GB
		Disk 
		C: (OS) 40GB
		D: (Data) 40GB


NOTE! Before using or executing any files please read comments in each on how to adjust for your specific environment.

The recommended order of execution and usage are...
Phase 1: Creating accounts and groups
1. Run on DC as Domain Admin: FIMServiceAccounts.ps1
2. Run on DC as Domain Admin (or DNS Admin): FIMDNSRecords.ps1
3. Run on DC as Domain Admin: Create GPO for each server and import GPO configuration in GPO.zip
NOTE! Make sure each server have applied GPO before continuing since local Administrators group needs to be updated.

Phase 2: Installing SQL Server
4. Run on SQL Server as svcFIMSQLAdmin: Install SQL 2012 using SQLFIMConfigurationFile.ini
5. Run on SQL Server as svcFIMSQLAdmin: Install SQL 2012 using SQLSCSMMGMTConfigurationFile.ini
6. Run on SQL Server as svcFIMSQLAdmin: StaticPortOnFIMSQLInstances.ps1

Phase 3: Install and configure SCSM 2012 R2
7. Run on SCSM Mgmt as svcFIMSCSMAdmin: Install SQL 2012 using SQLClientandToolsConfigurationFile.ini
8. Run on SCSM Mgmt as svcFIMSCSMAdmin: Install SQL_AS_AMO.msi
9. Run on SCSM Mgmt as svcFIMSCSMAdmin: Install SCSM 2012 R2 Management Server
10. Run on SCSM DW as svcFIMSCSMAdmin: Install SQL 2012 using SQLSCSMDWConfigurationFile.ini
11. Run on SCSM DW as svcFIMSCSMAdmin: Install SCSM 2012 R2 DataWarehouse Managment Server
12. Run on SCSM Mgmt as svcFIMSCSMAdmin: Register SCSM Mgmt with SCSM DataWarehouse using SCSM Management Console

Phase 4: Configure Pre-requisites on FIM
Copy the SPF2013 folder to D:
Download (http://www.microsoft.com/en-us/download/details.aspx?id=42039) SPF2013 and extract into folder D:\SPF2013\SPF2013.
13. Run on FIM as svcFIMAdmin: Install SQL 2012 using SQLClientandToolsConfigurationFile.ini
14. Run on FIM as svcFIMAdmin: SQLAliasOnFIMServer.ps1
15. Run on FIM as svcFIMAdmin: Install SCSM 2012 R2 Service Management Console
16. Run on FIM as svcFIMAdmin: FIMRequestSSLCertificate.ps1
17. Run on FIM as svcFIMAdmin: \SPF2013\Install-SPF2013-Roles-Features.ps1
18. Run on FIM as svcFIMAdmin: \SPF2013\SPF2013\Setup.exe
19. Run on FIM as svcFIMAdmin: \SPF2013\ConfigureSPF2013.ps1
20. Run on FIM as svcFIMAdmin: Configure IIS to bind and use SSL