BSTS10P8 ;GDIT/HS/BEE-Version 1.0 Patch 8 Post (and Pre) Install ; 19 Nov 2012  9:41 AM
 ;;1.0;IHS STANDARD TERMINOLOGY;**8**;Sep 10, 2014;Build 35
 ;
ENV ;EP - Environmental Checking Routine
 ;
 N VERSION,EXEC,BMWDT
 ;
 ;Check for BSTS*1.0*7
 I '$$INSTALLD("BSTS*1.0*7") D BMES^XPDUTL("Version 1.0 Patch 7 of BSTS is required!") S XPDQUIT=2 Q
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
 NEW ICONC,ICIEN,INALL,CNT
 N TRIEN,EXEC,ERR,X,VAR,STS
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
 ;Populate new GALAXY SUBSET field in BSTS CONCEPT
 W !,"Populating new BSTS CONCEPT 'GALAXY SUBSET' field"
 S ICONC="" F  S ICONC=$O(^BSTS(9002318.4,"C",36,ICONC)) Q:'ICONC  D
 . S ICIEN="" F  S ICIEN=$O(^BSTS(9002318.4,"C",36,ICONC,ICIEN)) Q:'ICIEN  D
 .. ;
 .. NEW BSTSUPD,ERROR,NMID
 .. ;
 .. ;Quit on partial
 .. I $$GET1^DIQ(9002318.4,ICIEN_",",.03,"I")="P" Q
 .. ;
 .. S NMID=$$GET1^DIQ(9002318.4,"11,",.07,"E")
 .. I NMID'=1552,NMID'=36 Q
 .. ;
 .. ;Look for IHS PROBLEM ALL SNOMED or RXNO SRCH Drug Ingredients All
 .. I NMID=1552,'$D(^BSTS(9002318.4,ICIEN,4,"B","RXNO SRCH Drug Ingredients All")) Q
 .. I NMID=36,'$D(^BSTS(9002318.4,ICIEN,4,"B","IHS PROBLEM ALL SNOMED")) Q
 .. ;
 .. S BSTSUPD(9002318.4,ICIEN_",",.15)="Y"
 .. D FILE^DIE("","BSTSUPD","ERROR")
 .. S CNT=$G(CNT)+1 I CNT#1000=0 W "."
 ;
 ;Manually update 4 32772 entries
 S STS=$$DTSLKP^BSTSAPI("VAR","732^32772")
 S STS=$$DTSLKP^BSTSAPI("VAR","734^32772")
 S STS=$$DTSLKP^BSTSAPI("VAR","776^32772")
 S STS=$$DTSLKP^BSTSAPI("VAR","738^32772")
 ;
 ;Unlock installation entry
 L -^TMP("BSTSINSTALL")
 ;
 ;Queue custom codesets
 D QUEUE^BSTSVOFL(32771)
 D QUEUE^BSTSVOFL(32772)
 D QUEUE^BSTSVOFL(32773)
 D QUEUE^BSTSVOFL(32774)
 D QUEUE^BSTSVOFL(32775)
 ;
 ;Kick off RxNorm update
 D QUEUE^BSTSVOFL("S1552") ;Put it on the queue
 ;
 ;Kick off update to pull down replacement information
 D QUEUE^BSTSVOFL(32780) ;Put it on the queue
 ;
 D JOBNOW^BSTSVOFL  ;Kick off now
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
 S DIU="^BSTS(9002318.6,",DIU(0)="DST" D EN^DIU2
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
