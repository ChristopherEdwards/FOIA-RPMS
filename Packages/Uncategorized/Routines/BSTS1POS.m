BSTS1POS ;GDIT/HS/BEE-Version 1.0 Post (and Pre) Install ; 19 Nov 2012  9:41 AM
 ;;1.0;IHS STANDARD TERMINOLOGY;;Sep 10, 2014;Build 101
 ;
ENV ;EP - Environmental Checking Routine
 ; Run pre-install checks
 N VERSION,EXEC,BMWDT
 ;
 ;Check for Ensemble version greater or equal to 2012
 S VERSION=$$VERSION^%ZOSV
 I VERSION<2012 D BMES^XPDUTL("Ensemble 2012 or later is required!") S XPDQUIT=2 Q
 ;
 ;Make sure a refresh is not running already
 L +^BSTS(9002318.1,0):0 E  D BMES^XPDUTL("A Local BSTS Cache Refresh is Already Running. Please Try Later") S XPDQUIT=2 Q
 L -^BSTS(9002318.1,0)
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
 NEW DA,DIC,X,Y,ZTRTN,ZTDESC,ZTIO,ZTSAVE,DLAYGO,NMID,NMIEN
 S DIC(0)="LNZ",DIC="^BSTS(9002318,",DLAYGO=9002318,X=$P($G(^AUTTSITE(1,0)),U,1)
 I X="" S X=$O(^BGPSITE(0))
 I X'="" S X=$P(^DIC(4,X,0),U,1)
 D ^DIC
 ;
 ;Load the classes
 ;
 N TRIEN,EXEC,ERR
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
 ;Update LAST SUBSET CHECK now so process won't keep getting called
 D
 . NEW BSTS,ERROR,NMIEN
 . S NMIEN=$O(^BSTS(9002318.1,"B",36,"")) Q:NMIEN=""
 . S BSTS(9002318.1,NMIEN_",",.06)=DT
 . D FILE^DIE("","BSTS","ERROR")
 ;
 ;Unlock installation entry
 L -^TMP("BSTSINSTALL")
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
 ;Clear out existing entries
 S DIU="^BSTS(9002318.1,",DIU(0)="DST" D EN^DIU2
 S DIU="^BSTS(9002318.3,",DIU(0)="DST" D EN^DIU2
 S DIU="^BSTS(9002318.4,",DIU(0)="DST" D EN^DIU2
 S DIU="^BSTSCLS(",DIU(0)="DST" D EN^DIU2
 ;
 Q
