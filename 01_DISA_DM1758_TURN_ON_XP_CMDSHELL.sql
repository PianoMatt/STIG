/* 
   *******************************************************************************
    ENVIRONMENT:    SQL 2005

	NAME:           01_DISA_DM1758_TURN_ON_XP_CMDSHELL.sql

    DESCRIPTION:    THIS SCIRPT WILL ENABLE XP_CMDSHELL, DISA RECOMMENDS THIS 
                    OPTION TO BE DISABLE.  THIS OPTION IS ENABLED BECAUSE
                    OF OUR MONITORING JOBS.

    INPUT:          @DEBUG
						0 - THIS WILL TURN ON XP_CMDSHELL
                        1 - (DEFAULT) THIS WILL PRINT OUT WHAT THE SCRIPT WILL 
                            BE DOING.

    NOTES:          ** WHEN RUNNING THIS SCRIPT ONLY, YOU NEED TO UPDATE ALL THE
                       $(...) TAGS.  THESE OUR PLACEHOLDERS FOR THE SQLCMD TO
                       CHANGE WHAT THESE SCRIPTING VARIABLES SHOULD BE

    AUTHOR         DATE       VERSION  DESCRIPTION
    -------------- ---------- -------- ------------------------------------------
    AB82086        11/25/2009 1.0      INITIAL CREATION
    AB82086        11/26/2009 1.01     ADD SQL SERVER INFO
    AB82086        08/02/2010 2.0      MAKING CHANGES TO THE SCRIPT SO THEY CAN 
                                       BE EXECUTED BY A PARENT SCRIPT.  
   *******************************************************************************
*/
USE [master]
GO
SET NOCOUNT ON

DECLARE @Debug		bit

SET @Debug = $(Debug)

IF @Debug = 1
	BEGIN 
		PRINT REPLICATE('*', 80)
		PRINT '*' + REPLICATE(' ', 78) + '*'
		PRINT '*' + REPLICATE(' ', 78) + '*'
		PRINT '*' + REPLICATE(' ', 35) + 'DEBUG ON' + REPLICATE(' ', 35) + '*'
		PRINT '*' + REPLICATE(' ', 78) + '*'
		PRINT '*' + REPLICATE(' ', 78) + '*'
		PRINT REPLICATE('*', 80)
		PRINT ''
		PRINT ''
	END

PRINT CONVERT(varchar(30), GETDATE(), 109) + ' *** DOCUMENT SSP AND/OR CREATE EXCEPTION IF NECESSARY ***' 
PRINT ''
PRINT ''

PRINT CONVERT(varchar(30), GETDATE(), 109) + ' BEGIN SQL SERVER INFORMATION' 
PRINT CONVERT(varchar(30), GETDATE(), 109) + '     MachineName:     ' + CAST(ISNULL(SERVERPROPERTY('MachineName'), 'NULL') AS varchar(128))
PRINT CONVERT(varchar(30), GETDATE(), 109) + '     ServerName:      ' + CAST(ISNULL(SERVERPROPERTY('ServerName'), 'NULL') AS varchar(128))
PRINT CONVERT(varchar(30), GETDATE(), 109) + '     InstanceName:    ' + CAST(ISNULL(SERVERPROPERTY('InstanceName'), 'NULL') AS varchar(128))
PRINT CONVERT(varchar(30), GETDATE(), 109) + '     Edition:         ' + CAST(ISNULL(SERVERPROPERTY('Edition'), 'NULL') AS varchar(128))
PRINT CONVERT(varchar(30), GETDATE(), 109) + '     ProductVersion:  ' + CAST(ISNULL(SERVERPROPERTY('ProductVersion'), 'NULL') AS varchar(128))
PRINT CONVERT(varchar(30), GETDATE(), 109) + '     ProductLevel:    ' + CAST(ISNULL(SERVERPROPERTY('ProductLevel'), 'NULL') AS varchar(128))
PRINT CONVERT(varchar(30), GETDATE(), 109) + '     Collation:       ' + CAST(ISNULL(SERVERPROPERTY('Collation'), 'NULL') AS varchar(128))
PRINT CONVERT(varchar(30), GETDATE(), 109) + ' END SQL SERVER INFORMATION' 
PRINT ''

IF EXISTS(SELECT * FROM sys.configurations WHERE name = 'xp_cmdshell' AND value = 1)
	PRINT CONVERT(varchar(30), GETDATE(), 109) + ' XP_CMDSHELL OPTION IS ENABLED ALREADY'
ELSE
	BEGIN
		IF EXISTS(SELECT * FROM sys.configurations WHERE name = 'show advanced options' AND value = 0)
			BEGIN
				PRINT CONVERT(varchar(30), GETDATE(), 109) + ' TURNING ADVANCE OPTIONS ON'
				PRINT CONVERT(varchar(30), GETDATE(), 109) + '     EXECUTE sp_configure ''show advanced options'', 1'
				PRINT CONVERT(varchar(30), GETDATE(), 109) + '     RECONFIGURE'

				IF @Debug = 0 
					BEGIN
						PRINT ''
						EXECUTE sp_configure 'show advanced options', 1
						RECONFIGURE
						PRINT ''
						PRINT CONVERT(varchar(30), GETDATE(), 109) + ' ADVANCE OPTIONS IS TURNED ON'
					END

				PRINT ''
			END

		PRINT CONVERT(varchar(30), GETDATE(), 109) + ' TURNING XP_CMDSHELL OPTION ON'
		PRINT CONVERT(varchar(30), GETDATE(), 109) + '     EXECUTE sp_configure ''xp_cmdshell'', 1'
		PRINT CONVERT(varchar(30), GETDATE(), 109) + '     RECONFIGURE'

		IF @Debug = 0 
			BEGIN
				PRINT ''
				EXECUTE sp_configure 'xp_cmdshell', 1
				RECONFIGURE
				PRINT ''
				PRINT CONVERT(varchar(30), GETDATE(), 109) + ' XP_CMDSHELL OPTION IS TURNED ON'
			END
	END