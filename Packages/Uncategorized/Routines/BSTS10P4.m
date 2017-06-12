BSTS10P4 ;GDIT/HS/BEE-Version 1.0 Patch 4 Post (and Pre) Install ; 19 Nov 2012  9:41 AM
 ;;1.0;IHS STANDARD TERMINOLOGY;**4**;Sep 10, 2014;Build 32
 ;
ENV ;EP - Environmental Checking Routine
 ;
 N VERSION,EXEC,BMWDT
 ;
 ;Check for BSTS*1.0*3
 I '$$INSTALLD("BSTS*1.0*3") D BMES^XPDUTL("Version 1.0 Patch 3 of BSTS is required!") S XPDQUIT=2 Q
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
 ;Display install message
 D BMES^XPDUTL("Kicking off process to retrieve terms for Description Ids")
 ;
RESTART ;Restart from here if check below fails
 ;
 ;Kick off process if not already running
 L +^XTMP("BSTSCFIX"):0 E  G XEN
 ;
 ;Verify that DTS is working
 NEW STS,VAR
 D RESET^BSTSWSV1  ;Reset the DTS link to on
 S STS=$$VERSIONS^BSTSAPI("VAR",36)
 I (+STS'=2)!$G(ERR) D  W !!,"DTS is not working properly. Please contact the BSTS Support Group - Aborting Installation" H 10 S XPDABORT=1 Q
 . ;
 . ;Quit if a restart
 . Q:'$G(KIDS)
 . ;
 . ;Allow logins again
 . NEW LIEN,LOG,ERR
 . S LIEN=$O(^%ZIS(14.5,0)) Q:'+LIEN
 . S LOG(14.5,LIEN_",",1)="N"
 . D FILE^DIE("","LOG","ERR")
 ;
 ;Kick off background process
 D FIX1^BSTSCFIX
 ;
XEN ;Unlock installation entry
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
 ;Clear out existing transport global
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
