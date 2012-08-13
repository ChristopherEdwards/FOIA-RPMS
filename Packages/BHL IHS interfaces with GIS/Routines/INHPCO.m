INHPCO ; FRW ; 1 Mar 96 13:44;  Manipulate GIS control files 
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;COPYRIGHT 1991-2000 SAIC
 ;
EN ;Main entry point
 ;
 Q
 ;
ACTIVATE ;Activate everything in a production environment
 ;fall thru to PRD
 ;
PRD ;Activate a produciton environment
 ;
 D ALL^INHPSAM(1)
 S $P(^INRHT("ALAST"),U,2)=$$NOW^%ZTFDT
 Q
 ;
 ;D ACTONE^INHPCO1(1)
 Q
 ;
DEV ;Activate a development environment
 D ACTONE^INHPCO1(0)
 Q
 ;
PACK ;How to Package the GIS Control Files
 ;
 ;Prep globals  - D PREP
 ;set default directory  -  D ^%SPAWN(SET DEF)
 ;Call global COM file  -  D ^%SPAWN(@GLOBAL)
 ;   Set working directory
 ;   Save globals
 ;   Do diff
 ;Reactivate environment - D DEV^INHPCO
 ;Verify diff  - manual
 ;Set default directory - SET DEF
 ;Call global COM file - @GLOBAL
 ;   Replace globals into CMS 
 ;   Insert globals into class
 ;Create/Insert .DOC file into class - D ^ZCMS
 ;Mark class ready in CMS and Forum
 ;   
 Q
 ;
PREP ;Prep globals for packaging
 ;Verbose mode => 0 - verbose ; 1 - not verbose
 D PREP^INHPCO1
 Q
 ;
DEACTST ;Deactive non-production stuff
 ;
 W:'$G(INVERBOS) !,"*** Deactivating non-production entries ***"
 ;Loop through transaction types
 D LOOP("^INRHT(""B"")","D TTONE(DA)","^INRHT")
 ;Loop through messages
 D LOOP("^INTHL7M(""B"")","D MSGONE(DA)","^INTHL7M")
 ;Loop through the background process control file
 D LOOP("^INTHPC(""B"")","D BPCONE(DA,0)","^INTHPC")
 ;
 ;Delete the PARENT field from the TT if
 ;   the parent = "HL" and the .01 '= "HL"
 ;Delete from Message Replication (4020) file if
 ;   Originating TT = "HL" and the .01 '= "HL"
 ;
 Q
 ;
ACTIVTST ;Activate test stuff
 ;
 ;Activate messages
 D LOOP("^INTHL7M(""B"")","D ACTSTONE(DA)","^INTHL7M")
 ;Activate transaction types
 D LOOP("^INRHT(""B"")","D TTONE(DA,1)","^INRHT")
 ;Activate background processses
 D LOOP("^INTHPC(""B"")","D BPCONE(DA,1)","^INTHPC")
 Q
 ;
LOOP(INGL,INEXE,INGLDAT) ;Local LOOP call
 ;
 D LOOP^INHPCO1($G(INGL),$G(INEXE),$G(INGLDAT))
 Q
 ;
REMEMBER ;Remember environemntal information
 ;
 I '$G(INVERBOS) W !,"*** Storing environmental information ***"
 N INHPREP S INHPREP=$O(^UTILITY("INSAVE","GIS PREP",""))
 I INHPREP W !,"WARNING:  You already have environment data stored.",!,"<CR> to continue, Control C to abort." R %:DTIME
 S INHPREP=$H,%=$$BACKUP^INHSYSUL("GIS PREP",INHPREP)
 I '% W !,"*** Backup failed. some data may not be refreshed. ***" Q
 S ^UTILITY("INSAVE","GIS PREP","REMEMBER")=INHPREP_U_$$NOW^%ZTFDT
 Q
 ; old remember code follows
 ;N DA K INENV S INENV="^UTILITY(""INENV"","_+$G(DUZ)_")"
 ;If INENV global exists and has not been restored ask user if they want to continue (or refresh)
 ;I $D(@INENV) W !,"WARNING:  You already have environment data stored." R %:DTIME
 ;K @INENV
 ;;IP PORT (^5) and CLIENT ADDR fields (^6) in BPC file
 ;S @INENV@(4004)="",DA=0
 ;F  S DA=$O(^INTHPC(DA)) Q:'DA  D
 ;.  M @INENV@(4004,DA,5)=^INTHPC(DA,5)
 ;.  M @INENV@(4004,DA,6)=^INTHPC(DA,6)
 ;S @INENV@("STORE")=$$NOW^%ZTFDT
 ;
REFRESH ;Replace environmental information
 I '$G(INVERBOS) W !,"*** Replacing environmental information ***"
 N INHPREP S INHPREP=$O(^UTILITY("INSAVE","GIS PREP",""))
 I 'INHPREP W:'$G(INVERBOS) !,"*** No backup exists to refresh from. ***" Q
 S %=$$RESTORE^INHSYSUL("GIS PREP",INHPREP)
 K:% ^UTILITY("INSAVE","GIS PREP")
 Q
 ;
 ;N DA S:'$L($G(INENV)) INENV="^UTILITY(""INENV"","_+$G(DUZ)_")"
 ;IP PORT (^5) and CLIENT ADDR fields (^6) in BPC file
 ;S DA=0 F  S DA=$O(@INENV@(4004,DA)) Q:'DA  D
 ;.  M ^INTHPC(DA,5)=@INENV@(4004,DA,5)
 ;.  M ^INTHPC(DA,6)=@INENV@(4004,DA,6)
 ;S $P(@INENV@("STORE"),U,2)=$$NOW^%ZTFDT
 ;K @INENV
 ;
BCKCLN ;Clean up Background Process Control file
 I '$G(INVERBOS) W !,"*** Cleaning up Background Process Control File ***"
 ;Clean up - IP PORT (^5) and CLIENT ADDR fields (^6)
 ;           D/T last started, $J fields
 ;Loop through background process control file
 N DA,DIE,DR S DA=0,DIE=4004,DR=".04///@;.05///@"
 F  S DA=$O(^INTHPC(DA)) Q:'DA  K ^INTHPC(DA,5),^(6) D ^DIE
 Q
 ;
MISC ;miscellaneous things to do
 N DA,DIE
 S DA=+$$DIC^INHSYS05(4000,"HL GIS APPL ACKNOWLEDGEMENT",4000,"X")
 I DA<0 W !,"HL GIS APPL ACKNOWLEDGEMENT not found" Q
 S DIE=4000,DR=".16///5" D ^DIE
 Q
