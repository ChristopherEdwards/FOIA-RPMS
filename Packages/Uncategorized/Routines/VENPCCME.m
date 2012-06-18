VENPCCME ; IHS/OIT/GIS - PCC+ ENVIRONMENT CHECKER ;
 ;;2.6;PCC+;;NOV 12, 2007
 ;
 ; CONTAINS 2.5 UPDATES
 ; 
 N OUT
 D COMP(.OUT)
 W !!,OUT
 Q
 ; 
COMP(OUT) ; EP-REQUIRED COMPONENT CHECK-UP
 ; PATCHED BY GIS/OIT 10/15/05 ; PCC+ 2.5 PATCH 1
 N KIEN,TOT
 S KIEN=$O(^XPD(9.6,"B","PCC+ 2.5",0))
 I 'KIEN S OUT="Unable to find the KIDS installation record for PCC+ Version 2.5!" Q
 S TOT=0
 W ! I $$RTN S TOT=TOT+1
 W ! I $$FILE S TOT=TOT+1
 W ! I $$VR(KIEN) S TOT=TOT+1
 W ! I $$VF(KIEN) S TOT=TOT+1
 W ! I $$VOPT(KIEN) S TOT=TOT+1
 W ! I $$VKEY(KIEN) S TOT=TOT+1
 I TOT S OUT="PLEASE INSTALL THE MISSING COMPONENTS BEFORE PROCEEDING...." Q
 S OUT="Everyting checks out OK..."
 Q
 ; 
RTN() ; EP-ENVIRONMENT CHECK
 N X,Y,Z,N,I
 S N=0
 W !,"Checking Required RPMS routines...",!
 S X="EN1^APCHS,^XBCLS,^XBKVAR,^XLFDT,^XBFMK,^AGVAR,^AGEDIT,^APCDALV,^BIRPC"
 F I=1:1:$L(X,",") S Y=$P(X,",",I) D
 . X ("S Z=$T("_Y_")")
 . I '$L(Z) W !?3,"The routine "_$P(Y,U,2)_" is either missing or not the current version" S N=N+1
 . Q
 I N W "You must meed all prerequisites before installing PCC+ Ver. 2.5!" Q 1
 W "All required RPMS routines seem to be present" Q 0
 ; 
FILE() ; EP-CHECK FOR FILES
 N X,Y,Z,N,A,I
 S N=0
 S X="^AUPNMCR;MEDICARE ELIGIBLE,^AUPNMCD;MEDICAID ELIGIBLE,^AUTNEMPL;EMPLOYER,^AUPNPRVT;PRIVATE INSURANCE ELIGIBLE,^AUTNINS;INSURER,^AUPN3PPH;POLICY HOLDER"
 S X=X_",^AUPNBMSR;BIRTH MEASUREMNT,^BWDIAG;BW RESULTS/DIAGNOSIS,^BWPCD;BW PROCEDURE,^PSRX;PRESCRIPTION,^PSDRUG;DRUG"
 W !,"Checking RPMS files...",!
 F I=1:1:$L(X,",") S Y=$P(X,",",I) D
 . S Z=$P(Y,";"),A=$P(Y,";",2)
 . I '$D(@(Z_"(0)")) W !?3,"The file "_A_" is missing" S N=N+1
 . Q
 I N W "You must obtain the required RPMS files before proceeding!" Q 1
 W "All required RPMS files seem to be present" Q 0
 ; 
VF(KIEN) ; EP-CHECK FOR VEN 2.5 FILES VIA LATEST KIDS BUILD
 N X,Y,Z,FIEN
 S FIEN="",Z=0
 W !,"Checking PCC+ files...",!
 F  S FIEN=$O(^XPD(9.6,KIEN,4,"B",FIEN)) Q:FIEN  D
 . S X=$P($G(^DIC(FIEN,"%D",0)),U,5)
 . I X'<3050428 Q
 . S Z=Z+1
 . W "The PCC+ FILE "_FIEN_" is missing or not the current version",!
 . S Z=Z+1
 . Q
 I Z W "You must install the current PCC+ package before proceeding!" Q 1
 W "All required PCC+ files seem to be present and current" Q 0
 ; 
VR(KIEN) ; EP-CHECK FOR VEN 2.5 ROUTINES
 N X,Y,Z,NAME
 S NAME="",Z=0
 W !,"Checking PCC+ Routines...",!
 F  S NAME=$O(^XPD(9.6,KIEN,"KRN",9.8,"NM","B",NAME)) Q:NAME=""  D
 . S X="+2^"_NAME
 . X "I $T("_X_")'["";2.5""" E  Q
 . W "The PCC+ routine "_NAME_" is missing or not the current version",!
 . S Z=Z+1
 . Q
 I Z W "You must install the current PCC+ package before proceeding!" Q 1
 W "All required PCC+ routines seem to be present and current" Q 0
 ;
VOPT(KIEN) ; EP-CHECK FOR VER 2.5 OPTIONS
 N X,Y,Z,NAME
 S NAME="",Z=0
 W !,"Checking PCC+ Options...",!
 F  S NAME=$O(^XPD(9.6,KIEN,"KRN",19,"NM","B",NAME)) Q:NAME=""  D
 . S X=+$O(^DIC(19,"B",NAME,999999999),-1)
 . I $D(^DIC(19,X,0)) Q
 . W "The PCC+ Option / Menu item "_NAME_" is missing",!
 . S Z=Z+1
 . Q
 I Z W "You must install the current PCC+ package before proceeding!" Q 1
 W "All required PCC+ options seem to be present" Q 0
 ;
VKEY(KIEN) ; EP - CHECH FOR VER 2.5 KEYS
 N X,Y,Z,NAME
 S NAME="",Z=0
 W !,"Checking PCC+ Security Keys...",!
 F  S NAME=$O(^XPD(9.6,KIEN,"KRN",19.1,"NM","B",NAME)) Q:NAME=""  D
 . S X=+$O(^DIC(19.1,"B",NAME,999999999),-1)
 . I $D(^DIC(19.1,X,0)) Q  ; PATCHED BY GIS/OIT 1/15/06 ; PCC+ 2.5 PATCH 2
 . W "The PCC+ Security key "_NAME_" is missing",!
 . S Z=Z+1
 . Q
 I Z W "You must install the current PCC+ package before proceeding!" Q 1
 W "All required PCC+ security keys seem to be present" Q 0
 ;
OS() ; EP - RETURN THE OPERATING SYSTEM INFO
 N V,O,X
 X ("S X="_$C(36,90,86)) I '$L(X) S (V,O)="Unknown" D OS1(V,O) Q 1
 S V=$S(X["MSM":"MSM",1:"CACHE")
 S O=$S(X["UNIX":"UNIX",X["AIX":"AIX",1:"WINDOWS")
 D OS1(V,O)
 Q 0
 ; 
OS1(V,O) ; EP - MORE OD INFO
 W !,"Checking computing environment..."
 W !?3,"PCC+ Version: ",+$P($T(+2^VENPCCME),";;",2)
 W !?3,"MUMPS: ",V
 W !?3,"Server Operating System: ",O
 Q
 ; 
CK(CFLG) ; EP - CHECK THE CONFIGURATION
 S CFG=$$CFG^VENPCCU I 'CFG W !!,"NO PRIMARY CONFIGURATION DEFINED!!!  SESSION TERMINATED" S CFLG=1 Q
 S STG=$G(^VEN(7.5,CFG,0)) S IP=$G(^(11)) S SM=$G(^(4)) S VER=$P($G(^(13)),U)
 S CDFN=$P(STG,U,2),TYPE=$P(STG,U,3),OS=$P(STG,U,4),MV=$P(STG,U,5)
 S UNI=$P(STG,U,6),DEM=$P(STG,U,8),PULL=$P(STG,U,9),PHS=$P(STG,U,10)
 S MON=$P(STG,U,11),BYP=$P(STG,U,12),GP=$P(STG,U,13),DP=$P(STG,U,14)
 S CMED=$P(STG,U,16),BACK=$P(STG,U,17)
 S EXRX=$P(STG,U,19),AUTO=$P(STG,U,21),ART=$P(STG,U,23)
 S IP(1)=$P(IP,U,1),IP(2)=$P(IP,U,2),SOCK=$P(IP,U,3)
 S PATH(1)=$G(^(1)),PATH(2)=$G(^(2)),PATH(3)=$G(^(3)),PATH(4)=$G(^(12))
CRES ; CONFIG RESULTS
RP ; REQUIRED PARAMETERS
 ; NO REQUIRED PIECES MISSING - YET...
 I OS="" W !?5,"OPERATING SYSTEM IS UNSPECIFIED" S CFLG=1
 I MV="" W !?5,"MUMPS VENDOR IS UNSPECIFIED" S CFLG=1
 I 'CFLG D  ; MAKE SURE OS AND MUMPS VENDOR ARE VALID IN CFG FILE
 . S X=$C(83,32,37)_$C(61,36,90,86)
 . X X S %=$$UP^XLFSTR(%)
 . I OS=1,%'["UNIX",%'["AIX" S CFLG=1 W !?5,"Invalid OS in the PCC+ config file.  Should be UNIX or AIX" Q
 . I OS=0,%'["NT" S CFLG=1 W !?5,"Invalid OS in the PCC+ config file. Should be 'Windows NT'" Q
 . I MV=2,%'["CACHE" S CFLG=1 W !?5,"Invalid MUMPS type in the config file" Q
 . I MV=1,%'["MSM" S CFLG=1 W !?5,"Invalid MUMPS type in the config file" Q
 . Q
 I TYPE="" W !,?5,"FACILITY TYPE IS UNSPECIFIED" S CFLG=1
 I MON W !?5,"THE CHECK IN PROCESS IS IN 'MONITOR MODE'.  PLEASE TURN OFF MONITOR MODE NOW." S CFLG=1
 I BYP W !?5,"THE PRINT DEAMON IS BEING BYPASSED.  PLEASE TURN OFF 'BYPASS MODE' NOW." S CFLG=1
 I '$D(^VA(200,+GP,0)) W !?5,"MISSING/INVALID GENERIC PROVIDER" S CFLAG=1
 I '$D(^DPT(+DP,0)) W !?5,"MISSING/INVALID DEMO PATIENT" S CFLAG=1
 I BACK S DIE="^VEN(7.5,",DA=CFG,DR=".17////0" L +^VEN(7.5,DA):0 D ^DIE L -^VEN(7.5,DA) ; FORCE NON-TASKMAN MODE
 I 'CFLG W !?5,"DEMO patient validated",!?5,"Generic provider validated"
PATH S DA=CFG F I=1:1:4 S X=$G(PATH(I)) D
 . I X="" W !?5,"THE PATH TO THE ",$P("PRINT (DATA)^HEADER^TEMPORARY^USER PREFERENCE",U,I)," FILE FOLDER IS MISSING" S CFLG=1 Q
 . S Y=$$SLASH^VENPCCU(X) I Y=X Q
 . W !?5,"INVALID PATH: ",X I Y="" Q
 . W "   SUGGESTED CORRECTION: ",Y
 . Q
PVAL ; NOW CHECK INTEGRITY OF EA. PATH
 F I=1:1:4 S PATH=PATH(I) D
 . S %=$$OPN^VENPCCP(PATH,"itest.txt","W","W 123")
 . I % S CFLG=1 W !?5,"Unable to access '"_PATH(I)_"'. Check path/permissions!" Q
 . K X S %=$$OPN^VENPCCP(PATH,"itest.txt","R","R X")
 . I % S CFLG=1 W !?5,"Unable to access '"_PATH(I)_"'. Check path/permissions!" Q
 . I $G(X)'=123 W !?5,"Read/write failue in directory '"_PATH(I) S CFLG=1 Q
 . D DEL^VENPCCP(PATH(I),"itest.txt") ; CLEANUP
 . Q
 I CFLG Q
 W !?5,"PCC+ directories are valid"
 ; 
 I $L(SM) G AUTO
V25 ; VER25
 I VER G SMINFO
 W !!,"You have not converted to the PCC+ Ver. 2.5 data file format yet."
 W !,"(This is RECOMMENDED if converting to Print Service, Ver. 2.5)" ; PATCHED BY GIS/OIT 10/15/05 ; PCC+ 2.5 PATCH 1
 W !,"Do you want to make the conversion"
 S %=1 D YN^DICN
 I %=1 S DIE="^VEN(7.5,",DA=CFG,DR="13.01////1" L +^VEN(7.5,DA):0 D ^DIE L -^VEN(7.5,DA) S VER=1
SMINFO ; GET SITE MGR INFO
 W !!,"You have not entered your brief site manager contact information yet"
 W !,"Please enter it now (e.g., 'For assistance, please call Mary Jones at ext. 4321')"
 S DIE="^VEN(7.5,",DA=CFG,DR=4
 L +^VEN(7.5,DA):0 D ^DIE L -^VEN(7.5,DA)
 S SM=$G(^VEN(7.5,CFG,4))
AUTO ; CHECK AUTO CLEAN UP FEATURE
 I AUTO G CK2
 W !?5,"The auto-cleanup feature for the pending document folder"
 W !,"('\print' dirrectory) has not been activated yet."
 W !,"Want to activate this feature now (RECOMMENDED)"
 S %=1 D YN^DICN
 I %'=1 G CK2
 S DIE="^VEN(7.5,",DA=CFG,DR=".21////1"
 L +^VEN(7.5,DA):0 D ^DIE L -^VEN(7.5,DA)
 S AUTO=1
CK2 W !,"The primary configuration is valid."
 W !!,"Additional configuration info: "
RX I '$O(^PSRX(0)) W !?5,"Your PRESCRIPTION FILE is not populated.  Are you using a Viking System???"
 I '$O(^PSRX(0)),$P($G(^VEN(7.5,CFG,0)),U,16) W !?10,"Unable to display chronic meds or other special Rx details"
 I $O(^PSRX(0)),$P($G(^VEN(7.5,CFG,0)),U,16) W !?10,"Chronic med filter will be applied to all PCC+ templates"
 I '$O(^PSRX(0)),$P($G(^VEN(7.5,CFG,0)),U,17) W !?10,"Unable to display expanded sigs"
 I $O(^PSRX(0)),$P($G(^VEN(7.5,CFG,0)),U,17) W !?10,"Expanded sigs will be displayed on all PCC+ templates"
 I $L(TYPE) W !?10,"FACILITY TYPE: ",$$GET1^DIQ(19707.5,(CFG_","),.03)
 W !?10,"VER 2.5 DATA FILE FORMAT: ",$S(VER:"YES",1:"NO")
 I $L(SM) W !?10,"SITE MANAGER MESSAGE: ",SM
 W !?10,"AUTOMATIC CLEANUP OF PRINT FOLDER: ",$S(AUTO:"YES",1:"NO")
 W !?10,"EDIT DEMOGRAPHICS DURING CHECK-IN: ",$S(DEM:"YES",1:"NO")
 W !?10,"ASK TO PULL CHART DURING CHECK-IN: ",$S(PULL:"YES",1:"NO")
 W !?10,"ALWAYS PRINT HEALTH SUMMARY IN MED RECORDS: ",$S(PHS:"YES",1:"NO")
 W !?10,"USE THE ADVERSE REACTION TRACKING PKG TO MONITOR ALLERGIES: ",$S(ART:"YES",1:"NO")
 Q
 ; 
