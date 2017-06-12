BSTS10P7 ;GDIT/HS/BEE-Version 1.0 Patch 7 Post (and Pre) Install ; 19 Nov 2012  9:41 AM
 ;;1.0;IHS STANDARD TERMINOLOGY;**6,7**;Sep 10, 2014;Build 34
 ;
ENV ;EP - Environmental Checking Routine
 ;
 N VERSION,EXEC,BMWDT
 ;
 ;Check for BSTS*1.0*6
 I '$$INSTALLD("BSTS*1.0*6") D BMES^XPDUTL("Version 1.0 Patch 6 of BSTS is required!") S XPDQUIT=2 Q
 ;
 ;Make sure a refresh is not running already
 L +^BSTS(9002318.1,0):0 E  D BMES^XPDUTL("A Local BSTS Cache Refresh is Already Running. Please Try Later") S XPDQUIT=2 Q
 L -^BSTS(9002318.1,0)
 ;
 ;Make sure an Description Id fix compile isn't running
 L +^XTMP("BSTSCFIX"):0 E  D BMES^XPDUTL("A Description Id Population Utility Process is Running.  Please Try later") S XPDQUIT=2 Q
 L -^XTMP("BSTSCFIX")
 ;
 ;Make sure an ICD9 to SNOMED compile isn't running
 L +^TMP("BSTSICD2SMD"):0 E  D BMES^XPDUTL("An ICD9 to SNOMED Background Compile is Running.  Please Try later") S XPDQUIT=2 Q
 L -^TMP("BSTSICD2SMD")
 ;
 ;Make sure another install isn't running
 L +^TMP("BSTSINSTALL"):3 E  D BMES^XPDUTL("A BSTS Install is Already Running") S XPDQUIT=2 Q
 L -^TMP("BSTSINSTALL")
 ;
 Q
 ;
EN ;EP
 ;
 ;Load the classes
 ;
 N TRIEN,EXEC,ERR,X,VAR
 ;
 ;For each build, set this to the 9002318.5 entry to load
 S TRIEN=1
 ;
 ;Delete existing BSTS Classes
 S EXEC="DO $SYSTEM.OBJ.DeletePackage(""BSTS"")" X EXEC
 ;
 ; Import BSTS classes
 K ERR
 I $G(TRIEN)'="" D IMPORT^BSTSCLAS(TRIEN,.ERR)
 I $G(ERR) Q
 ;
 ;Unlock installation entry
 L -^TMP("BSTSINSTALL")
 ;
 ;Pull the namespace and version
 S X=$$CODESETS^BSTSAPI("VAR")
 S X=$$VERSIONS^BSTSAPI("VAR",32779)
 S X=$$VERSIONS^BSTSAPI("VAR",32780)
 ;
 ;Fix 32772 Codeset and schedule refresh
 D 32772
 ;
 ;Kick off the Equivalency update
 ;Needed in order to pull down conditional mappings and concept default statuses
 D QUEUE^BSTSVOFL(32780) ;Put it on the queue
 D JOBNOW^BSTSVOFL  ;Kick off now
 ;
 Q
 ;
32772 ;EP - Fix 32772 entries and kick off process
 ;
 NEW CONC,CIEN
 ;
 S CONC="" F  S CONC=$O(^BSTS(9002318.4,"C",32772,CONC)) Q:CONC=""  S CIEN="" F  S CIEN=$O(^BSTS(9002318.4,"C",32772,CONC,CIEN)) Q:CIEN=""  D
 . ;
 . NEW DTSID,DA,DIK,TIEN
 . ;
 . S DTSID=$$GET1^DIQ(9002318.4,CIEN_",",.08,"I")
 . ;
 . ;Skip valid ones
 . I DTSID>570,DTSID<1147 Q
 . ;
 . ;Remove codeset entry
 . S DA=CIEN,DIK="^BSTS(9002318.4," D ^DIK
 . ;
 . ;Remove terms
 . S TIEN="" F  S TIEN=$O(^BSTS(9002318.3,"C",32772,CIEN,TIEN)) Q:TIEN=""  D
 .. NEW DA,DIK
 .. S DA=TIEN,DIK="^BSTS(9002318.3," D ^DIK
 ;
 ;Put 32772 refresh task on queue
 D QUEUE^BSTSVOFL(32772)
 ;
 Q
 ;
PRE ;Pre-Install Front End
 ;
 ;Perform Lock so only one install can run and DTS calls will be switched to local
 L +^TMP("BSTSINSTALL"):3 E  D BMES^XPDUTL("A BSTS Install is Already Running - Aborting Installation") S XPDABORT=1 Q
 ;
 N DIU
 ;
 ;Clear out existing transport global and new conversion file
 S DIU="^BSTSCLS(",DIU(0)="DST" D EN^DIU2
 ;
 Q
 ;
INSTALLD(BSTSSTAL) ;EP - Determine if patch BSTSSTAL was installed, where
 ; BSTSSTAL is the name of the INSTALL.  E.g "BSTS*1.0*1".
 ;
 NEW DIC,X,Y,D
 S X=$P(BSTSSTAL,"*",1)
 S DIC="^DIC(9.4,",DIC(0)="FM",D="C"
 D IX^DIC
 I Y<1 Q 0
 S DIC=DIC_+Y_",22,",X=$P(BSTSSTAL,"*",2)
 D ^DIC
 I Y<1 Q 0
 S DIC=DIC_+Y_",""PAH"",",X=$P(BSTSSTAL,"*",3)
 D ^DIC
 Q $S(Y<1:0,1:1)
