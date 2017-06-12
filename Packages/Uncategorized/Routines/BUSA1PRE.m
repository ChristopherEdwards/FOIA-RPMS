BUSA1PRE ;GDIT/HS/ALA-Preinstallation program ; 06 Mar 2013  9:52 AM
 ;;1.0;IHS USER SECURITY AUDIT;;Nov 05, 2013;Build 65
 ;
ENV ;EP - Environmental Checking Routine
 ; Run pre-install checks
 N VERSION,EXEC,BMWDT
 ;
 ; Verify that BMW classes exist and we have the correct version.
 ;was; S BMWDT=$G(^BMW("fm2class","GenDate"))
 ;was; S EXEC="S BMWDT=$ZDTH(BMWDT,,,,,,,,,"""")" X EXEC
 ;was; I BMWDT="" D BMES^XPDUTL("Cannot retrieve BMW version") S XPDQUIT=2 I 1
 ;was;E  I BMWDT<62962 D BMES^XPDUTL("BMW version 2013-05-20 or higher required") S XPDQUIT=2
 ;
 ; Add code to check for Ensemble version greater or equal to 2012
 S VERSION=$$VERSION^%ZOSV
 I VERSION<2012 D BMES^XPDUTL("Ensemble 2012 or later is required!") S XPDQUIT=2
 ;
 Q
 ;
PRE ;EP - Preinstallation
 ;
 ;Reset some transport files data
 NEW II,DA,DIK,X1,X2,X,%H
 ;
 S II=0 F  S II=$O(^BUSACLS(II)) Q:'II  S DA=II,DIK="^BUSACLS(" D ^DIK
 ;
 ;Get future date
 S X1=DT,X2=7 D C^%DTC
 ;
 ;Save off current BUSA AUDIT RPC DEFINITIONS file entries
 K ^XTMP("BUSARPCD")
 S ^XTMP("BUSARPCD",0)=$G(X)_"^"_DT_"^BUSA VERSION 1.0 INSTALL SCRATCH GLOBALS"
 S II=0 F  S II=$O(^BUSA(9002319.03,II)) Q:'II  M ^XTMP("BUSARPCD",II)=^BUSA(9002319.03,II)
 ;
 ;Now remove them
 S II=0 F  S II=$O(^BUSA(9002319.03,II)) Q:'II  S DA=II,DIK="^BUSA(9002319.03," D ^DIK
 ;
 Q
 ;
POS ;EP - Post Installation Code
 ;
 NEW TYP,CURR,DIK,II
 ;
 F TYP="M","B","C","W" D
 . ;
 . ;Quit if already on
 . I +$$STATUS^BUSAOPT(TYP) Q
 . S CURR=1
 . D NREC^BUSAOPT(TYP,1)
 ;
 ;Now add the existing entries back in
 S II=0 F  S II=$O(^XTMP("BUSARPCD",II)) Q:'II  D
 . ;
 . NEW RPCNAME,X,Y,DIC,IEN,DLAYGO
 . ;
 . S RPCNAME=$P($G(^XTMP("BUSARPCD",II,0)),U) Q:RPCNAME=""
 . ;
 . ;Look to see if entry exists - if it does, it is newer than the existing one
 . S IEN=$O(^BUSA(9002319.03,"B",RPCNAME,"")) I IEN]"" Q
 . ;
 . ;Create a new entry
 . S DIC="^BUSA(9002319.03,",DIC(0)="L",DLAYGO=9002319.03,X=RPCNAME
 . K DO,DD D FILE^DICN
 . S IEN=+Y
 . I IEN<1 Q
 . ;
 . ;If we have an IEN file the entry
 . M ^BUSA(9002319.03,IEN)=^XTMP("BUSARPCD",II)
 ;
 ;Re-Compile indices OF RPC file
 S DIK(1)=".01",DIK="^BUSA(9002319.03," D ENALL^DIK
 ;
 ;Compile class process
 ;
 N TRIEN,EXEC,ERR
 ;
 ;For each build, set this to the 9002319.05 entry to load
 S TRIEN=1
 ;
 ;Delete existing BUSA Classes
 S EXEC="DO $SYSTEM.OBJ.DeletePackage(""BUSA"")" X EXEC
 ;
 ; Import BUSA classes
 K ERR
 I $G(TRIEN)'="" D IMPORT^BUSACLAS(TRIEN,.ERR)
 I $G(ERR) Q
 ;
 ;Prompt for approved reporting tool users
 D USER^BUSAOPT
 ;
 Q
 ;
CONV ;EP - Pre-Install - Handle previous installs
 ;
 Q
