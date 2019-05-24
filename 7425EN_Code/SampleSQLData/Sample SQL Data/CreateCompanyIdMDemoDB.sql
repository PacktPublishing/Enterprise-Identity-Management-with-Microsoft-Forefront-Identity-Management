/****** Create Database ******/
USE [master]
GO

/****** Object:  Database [CompanyIdM]    Script Date: 11/30/2011 03:01:30 ******/
CREATE DATABASE [CompanyIdM] ON  PRIMARY 
( NAME = N'CompanyIdM', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL10_50.MSSQLSERVER\MSSQL\DATA\CompanyIdM.mdf' , SIZE = 2048KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'CompanyIdM_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL10_50.MSSQLSERVER\MSSQL\DATA\CompanyIdM_log.ldf' , SIZE = 1024KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO

ALTER DATABASE [CompanyIdM] SET COMPATIBILITY_LEVEL = 100
GO

IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [CompanyIdM].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO

ALTER DATABASE [CompanyIdM] SET ANSI_NULL_DEFAULT OFF 
GO

ALTER DATABASE [CompanyIdM] SET ANSI_NULLS OFF 
GO

ALTER DATABASE [CompanyIdM] SET ANSI_PADDING OFF 
GO

ALTER DATABASE [CompanyIdM] SET ANSI_WARNINGS OFF 
GO

ALTER DATABASE [CompanyIdM] SET ARITHABORT OFF 
GO

ALTER DATABASE [CompanyIdM] SET AUTO_CLOSE OFF 
GO

ALTER DATABASE [CompanyIdM] SET AUTO_CREATE_STATISTICS ON 
GO

ALTER DATABASE [CompanyIdM] SET AUTO_SHRINK OFF 
GO

ALTER DATABASE [CompanyIdM] SET AUTO_UPDATE_STATISTICS ON 
GO

ALTER DATABASE [CompanyIdM] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO

ALTER DATABASE [CompanyIdM] SET CURSOR_DEFAULT  GLOBAL 
GO

ALTER DATABASE [CompanyIdM] SET CONCAT_NULL_YIELDS_NULL OFF 
GO

ALTER DATABASE [CompanyIdM] SET NUMERIC_ROUNDABORT OFF 
GO

ALTER DATABASE [CompanyIdM] SET QUOTED_IDENTIFIER OFF 
GO

ALTER DATABASE [CompanyIdM] SET RECURSIVE_TRIGGERS OFF 
GO

ALTER DATABASE [CompanyIdM] SET  DISABLE_BROKER 
GO

ALTER DATABASE [CompanyIdM] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO

ALTER DATABASE [CompanyIdM] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO

ALTER DATABASE [CompanyIdM] SET TRUSTWORTHY OFF 
GO

ALTER DATABASE [CompanyIdM] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO

ALTER DATABASE [CompanyIdM] SET PARAMETERIZATION SIMPLE 
GO

ALTER DATABASE [CompanyIdM] SET READ_COMMITTED_SNAPSHOT OFF 
GO

ALTER DATABASE [CompanyIdM] SET HONOR_BROKER_PRIORITY OFF 
GO

ALTER DATABASE [CompanyIdM] SET  READ_WRITE 
GO

ALTER DATABASE [CompanyIdM] SET RECOVERY FULL 
GO

ALTER DATABASE [CompanyIdM] SET  MULTI_USER 
GO

ALTER DATABASE [CompanyIdM] SET PAGE_VERIFY CHECKSUM  
GO

ALTER DATABASE [CompanyIdM] SET DB_CHAINING OFF 
GO

/****** Create PhoneData ******/

USE [CompanyIdM]
GO

/****** Object:  Table [dbo].[PhoneData]    Script Date: 11/30/2011 03:02:51 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[PhoneData](
	[objectID] [uniqueidentifier] NOT NULL,
	[displayName] [varchar](50) NULL,
	[department] [varchar](50) NULL,
	[officeLocation] [varchar](50) NULL,
	[phone] [varchar](50) NULL,
	[mobile] [varchar](50) NULL,
	[firstName] [varchar](50) NULL,
	[middleName] [varchar](50) NULL,
	[lastName] [varchar](50) NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

/****** Create HRData ******/

USE [CompanyIdM]
GO

/****** Object:  Table [dbo].[HRData]    Script Date: 11/30/2011 02:18:05 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[HRData](
	[objectID] [uniqueidentifier] NOT NULL,
	[objectType] [varchar](10) NULL,
	[accountName] [varchar](50) NULL,
	[displayName] [varchar](50) NULL,
	[manager] [uniqueidentifier] NULL,
	[parentOrg] [uniqueidentifier] NULL,
	[HRId] [int] NULL,
	[HRType] [varchar](50) NULL,
	[department] [varchar](50) NULL,
	[firstName] [varchar](50) NULL,
	[middleName] [varchar](50) NULL,
	[lastName] [varchar](50) NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[HRData] ADD  CONSTRAINT [DF_HRData_objectID]  DEFAULT (newid()) FOR [objectID]
GO

/****** Create vwHRMVData ******/

USE [CompanyIdM]
GO

/****** Object:  View [dbo].[vwHRMVData]    Script Date: 11/30/2011 03:08:40 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[vwHRMVData]
AS
SELECT     parentOrg AS objectID, 'member' AS attributeName, objectID AS memberID
FROM         dbo.HRData
WHERE     (parentOrg IS NOT NULL)

GO

/****** Add Sample Data to HRData ******/

/**** Add IT Department ****/
INSERT INTO [CompanyIdM].[dbo].[HRData]
           ([objectType]
           ,[accountName]
           ,[displayName]
           ,[HRType])
     VALUES
           ('orgUnit'
           ,'dep-IT'
           ,'IT'
           ,'Department')
GO

/**** Add HelpDesk Unit ****/
Declare @ITGUID as uniqueidentifier 
Select @ITGUID = objectID from CompanyIdM.dbo.HRData where accountName='dep-IT'

INSERT INTO [CompanyIdM].[dbo].[HRData]
           ([objectType]
           ,[accountName]
           ,[displayName]
           ,[parentOrg]
           ,[HRType]
           ,[department])
     VALUES
           ('orgUnit'
           ,'unit-HelpDesk'
           ,'HelpDesk'
           ,@ITGUID
           ,'Unit'
           ,'IT')
 GO

/**** Add Kent Nordström ****/
Declare @ITGUID as uniqueidentifier 
Select @ITGUID = objectID from CompanyIdM.dbo.HRData where accountName='dep-IT'

INSERT INTO [CompanyIdM].[dbo].[HRData]
           ([objectType]
           ,[accountName]
           ,[displayName]
           ,[parentOrg]
           ,[HRType]
           ,[department]
           ,[firstName]
           ,[middleName]
           ,[lastName])
     VALUES
           ('person'
           ,'knord'
           ,'Kent Nordström'
           ,@ITGUID
           ,'Contractor'
           ,'IT'
           ,'Kent'
           ,'Olov'
           ,'Nordström')
 GO


/**** Add John Doe ****/
Declare @ITGUID as uniqueidentifier 
Select @ITGUID = objectID from CompanyIdM.dbo.HRData where accountName='dep-IT'

INSERT INTO [CompanyIdM].[dbo].[HRData]
           ([objectType]
           ,[accountName]
           ,[displayName]
           ,[parentOrg]
           ,[HRType]
           ,[department]
           ,[firstName]
           ,[lastName])
     VALUES
           ('person'
           ,'jdoe'
           ,'John Doe'
           ,@ITGUID
           ,'Employee'
           ,'IT'
           ,'John'
           ,'Doe')
 GO
 
/**** Make John Doe Manager of IT and Kent ****/
Declare @ITGUID as uniqueidentifier 
Select @ITGUID = objectID from CompanyIdM.dbo.HRData where accountName='dep-IT'

Declare @JDoeGUID as uniqueidentifier 
Select @JDoeGUID = objectID from CompanyIdM.dbo.HRData where accountName='jdoe'

Declare @KentGUID as uniqueidentifier 
Select @KentGUID = objectID from CompanyIdM.dbo.HRData where accountName='knord'

UPDATE [CompanyIdM].[dbo].[HRData]
   SET [manager] = @JDoeGUID
 WHERE objectID=@ITGUID

UPDATE [CompanyIdM].[dbo].[HRData]
   SET [manager] = @JDoeGUID
 WHERE objectID=@KentGUID

GO