ATXSTX ; IHS/OHPRD/TMJ - SEND TAXONOMY WITH PACKAGE ; 20 Nov 2008  11:48 AM   
 ;;2.0;IHS PCC SUITE;;MAY 14, 2009
 ;
 ;
START ;
 D MAIN
 D EOJ
 Q
 ;
MAIN ;
 D INIT
 Q:ATXQ
 F  D GENRTN Q:ATXQ
 Q:'ATXTSF  ;            quit if no taxonomy sent
 D POSTINIT ;           update post-init in package file
 Q
 ;
GENRTN ; GENERATE ROUTINE TO INSTALL TAXONOMY
 K ^TMP($J),^TMP("ATX",$J)
 D TAXONOMY ;           get taxonomy to export
 Q:ATXQ
 D PGMNAME ;            get program name
 Q:ATXQ
 D TXCHECK ;            check taxonomy
 Q:ATXQ
 S ATXTSF=1 ;           set flag that taxonomy sent
 D TXSTORE ;            store taxonomy
 D BUILD ;              build and save routines
 D DRIVER ;             build and save main driver
 Q
 ;
INIT ;
 D ^XBKVAR
 S ATXQ=1
 S ATXTSF=0 ;               taxonomy sent flag
 W !!,"This routine will build a post-init routine for the specified package."
 W !,"The post-init routine will add the selected entry to the TAXONOMY file"
 W !,"on the target machine.",!!
 D PACKAGE ;            get package
 Q:ATXQ
 S ATXQ=1
 ; get agency/site/programmer
 W !
 S DIR(0)="F^7:15",DIR("A")="Enter agency/site/programmer for routine first line",DIR("?")="E.g., IHS/OHPRD/EDE" K DA D ^DIR K DIR
 Q:$D(DIRUT)
 S ATXASP=X
 W !!,"The name of the primary routine to be generated will be the package prefix"
 W !,"followed by TX.  For each taxonomy being sent there will be one routine with"
 W !,"the same name followed by a letter A-Z.  For large taxonomies there will be"
 W !,"additional routines with the same letter A-Z followed by a letter A-Z.",!
 S ATXQ=0
 Q
 ;
PACKAGE ; GET PACKAGE
 S ATXQ=1
 S DIC="^DIC(9.4,",DIC(0)="AEMQ"
 D ^DIC
 K D,DD,D0,D1,DA,DI,DIADD,DIC,DICR,DIE,DIPGM,DLAYGO,DO,DQ,DR,DINUM
 Q:Y<0
 S ATXPK=+Y
 S ATXPRFX=$P(^DIC(9.4,ATXPK,0),U,2)
 S ATXQ=0
 Q
 ;
PGMNAME ; GET PROGRAM NAME
 S ATXQ=1
 S ATXPGM=ATXPRFX_"TX",ATXDRVR=ATXPGM
 ;S ATXPGM="BJPC1T",ATXDRVR=ATXPGM
 F ATXI=1:1:27 S X=ATXPGM_$C(64+ATXI) X ^%ZOSF("TEST") Q:'$T
 I ATXI=27 W !,ATXPGM_"A-Z already exist.  Cannot continue.",!! Q
 S (ATXPGM,ATXPGMR)=X
 W !!,"Generating new routine ^"_ATXPGM
 S X=ATXDRVR X ^%ZOSF("TEST")
 I $T W !,"Updating existing routine ^"_ATXDRVR,! I 1
 E  W !,"Generating new routine ^"_ATXDRVR,!
 S ATXQ=0
 Q
 ;
TAXONOMY ; GET TAXONOMY
 S ATXQ=1
 S DIC="^ATXAX(",DIC(0)="AEMQZ"
 D ^DIC
 K D,DD,D0,D1,DA,DI,DIADD,DIC,DICR,DIE,DIPGM,DLAYGO,DO,DQ,DR,DINUM
 Q:Y<0
 S ATXTX=+Y
 S ATXTXNM=Y(0,0)
 S ATXQ=0
 Q
 ;
TXCHECK ; CHECK TAXONOMY
 W !,"Checking taxonomy "
 S ATXQ=0
 D TXIENCHK ;                        see if values or iens
 I ATXQ W !!,"Cannot send a taxonomy of IENs.",! Q
 S ATXY=0
 F ATX21C=0:1 S ATXY=$O(^ATXAX(ATXTX,21,ATXY)) Q:'ATXY  D
 . S X=$P(^ATXAX(ATXTX,21,ATXY,0),U)
 . S:$E(X,$L(X))'=" " X=X_" "
 . I $D(^TMP("ATX",$J,21,X)) W !!,"Duplicate code entry for code="_X,! S ATXQ=1 Q
 . S ^TMP("ATX",$J,21,X)=ATXY
 . Q
 Q:ATXQ
 S ATXQ=1
 S ATXAAC=0
 S ATXX=""
 F ATXAAC=0:1 S ATXX=$O(^ATXAX(ATXTX,21,"AA",ATXX)) Q:ATXX=""
 S ATXX=""
 F ATXBC=0:1 S ATXX=$O(^ATXAX(ATXTX,21,"B",ATXX)) Q:ATXX=""
 I 'ATX21C W !!,"No codes in taxonomy",! Q
 I ATXBC'=ATX21C W !!,"B xref is not correct.  B count=",ATXBC,"  Entry count=",ATX21C,! Q
 I ATXAAC,ATXAAC'=ATX21C W !!,"AA xref is not correct.  AA count=",ATXAAC,"  Entry count=",ATX21C,! Q
 S ATXQ=0
 Q
 ;
TXIENCHK ; CHECK TAXONOMY FOR IENS OR VALUES
 S ATXFILE=$P(^ATXAX(ATXTX,0),U,15)
 Q:'ATXFILE
 S ATXFGBL=^DIC(ATXFILE,0,"GL")
 S ATXY=0,ATXNIEN=0
 F  S ATXY=$O(^ATXAX(ATXTX,21,ATXY)) Q:'ATXY  D  Q:ATXNIEN
 . S X=$P(^ATXAX(ATXTX,21,ATXY,0),U)
 . I X'=+X S ATXNIEN=1 Q
 . I '$D(@(ATXFGBL_"X,0)")) S ATXNIEN=1 Q
 . Q
 I 'ATXNIEN S ATXQ=1
 Q
 ;
TXSTORE ; STORE TAXONOMY IN ^TMP
 W !,"Storing taxonomy "
 K ^TMP("DIERR",$J)
 F ATXF=.01,.02,.04,.06,.08,.09,.11,.12,.13,.14,.15,.16,.17,3101 D
 . S ATXX=$$VALI^XBDIQ1(9002226,ATXTX,ATXF)
 . S:ATXX="" ATXX="@" ;      if field null make null on target
 . S ^TMP("ATX",$J,9002226,ATXTX,ATXF)=ATXX
 . Q
 S ATXCODE=""
 F  S ATXCODE=$O(^TMP("ATX",$J,21,ATXCODE)) Q:ATXCODE=""  D
 . S ATXY=^TMP("ATX",$J,21,ATXCODE)
 . S ATXIENS=ATXTX_","_ATXY
 . S ATXSBSC=ATXTX_","_ATXCODE
 . W "."
 . F ATXF=.01,.02 D
 .. S ATXX=$$VALI^XBDIQ1(9002226.02101,ATXIENS,ATXF)
 .. Q:ATXX=""
 .. S ^TMP("ATX",$J,9002226.02101,ATXSBSC,ATXF)=ATXX
 .. Q
 . Q
 S ATXBULL=$$VALI^XBDIQ1(9002226,ATXTX,.07)
 D:ATXBULL BULSTORE
 ; should the bulletin on the target machine be deleted if there
 ;   is no bulletin on the sending machine?  If yes, uncomment the
 ;   following line:
 ;S:'ATXBULL ^TMP("ATX",$J,9002226,ATXTX,.07)="@"
 Q
 ;
BULSTORE ; STORE BULLETIN
 W !,"Storing bulletin "
 F ATXF=.01,2 D
 . S ATXX=$$VALI^XBDIQ1(3.6,ATXBULL,ATXF)
 . Q:ATXX=""
 . S ^TMP("ATX",$J,3.6,ATXBULL,ATXF)=ATXX
 . Q
 S ATXY=0
 F  S ATXY=$O(^XMB(3.6,ATXBULL,4,ATXY)) Q:'ATXY  D
 . S ATXIENS=ATXBULL_","_ATXY
 . W "."
 . S ATXX=$$VALI^XBDIQ1(3.64,ATXIENS,.01)
 . Q:ATXX=""
 . S ^TMP("ATX",$J,3.64,ATXIENS,.01)=ATXX
 . Q:'$O(^XMB(3.6,ATXBULL,4,ATXY,1,0))
 . S ^TMP("ATX",$J,3.64,ATXIENS,1,0)=^XMB(3.6,ATXBULL,4,ATXY,1,0)
 . S ATXZ=0
 . F  S ATXZ=$O(^XMB(3.6,ATXBULL,4,ATXY,1,ATXZ)) Q:'ATXZ  S ^TMP("ATX",$J,3.64,ATXIENS,1,ATXZ,0)=^(ATXZ,0)
 . Q
 I $O(^XMB(3.6,ATXBULL,3,0)) D
 . S ^TMP("ATX",$J,3.63,ATXBULL,3,0)=^XMB(3.6,ATXBULL,3,0)
 . S ATXY=0
 . F  S ATXY=$O(^XMB(3.6,ATXBULL,3,ATXY)) Q:'ATXY  S ^TMP("ATX",$J,3.63,ATXBULL,3,ATXY,0)=^(ATXY,0)
 . Q
 I $O(^XMB(3.6,ATXBULL,1,0)) D
 . S ^TMP("ATX",$J,3.63,ATXBULL,1,0)=^XMB(3.6,ATXBULL,1,0)
 . S ATXY=0
 . F  S ATXY=$O(^XMB(3.6,ATXBULL,1,ATXY)) Q:'ATXY  S ^TMP("ATX",$J,3.63,ATXBULL,1,ATXY,0)=^(ATXY,0)
 . Q
 Q
 ;
BUILD ;
 W !,"Generating routines",!!
 S Y=DT
 D DD^%DT
 S ATXVER=$S($D(^DIC(9.4,ATXPK,"VERSION")):^("VERSION"),1:"")_";"_$P(^DIC(9.4,ATXPK,0),U,1)_";;"_Y
 K ^TMP("ATXPGM",$J)
 S ATXPGMC=1
 K ATXPGMS
 D PGMBEG ;                             build main routine
 S ATXZR=0
 F  S ATXZR=$O(^TMP("ATX",ATXZR)) Q:ATXZR=$J
 S ATXZR="^TMP(""ATX"","_ATXZR_")"
 D PGMTMP ;                             build TMP for $T
 S X=" ;" D SETTMP
 S X="OTHER ; OTHER ROUTINES" D SETTMP
 S ATXX=""
 F  S ATXX=$O(ATXPGMS(ATXX)) Q:ATXX=""  S X=" D ^"_ATXX D SETTMP
 S X=" Q" D SETTMP
 D PGMSAVE ;                            save generated program
 Q
 ;
PGMBEG ; BUILD BEGINNING OF PROGRAM
 K ^TMP("ATXPGM",$J,ATXPGM)
 S (ATXL,ATXLNTH)=0
 S X=ATXPGM_" ;"_ATXASP_"-CREATED BY ^ATXSTX ON "_Y_";" D SETTMP
 S X=" ;;"_ATXVER D SETTMP
 I ATXPGMC=1 D
 . S X=" ;;"_ATXTXNM D SETTMP
 . S X=" ;" D SETTMP
 . S X=" ; This routine loads Taxonomy "_ATXTXNM D SETTMP
 . Q
 F ATXI=1:1:5 S X=$P($T(CODE+ATXI),";;",2,99) Q:X=""  D SETTMP
 I ATXPGMC=1 F ATXI=6:1:10 S X=$P($T(CODE+ATXI),";;",2,99) Q:X=""  D SETTMP
 I ATXPGMC>1 S X=" Q" D SETTMP
 Q
 ;
PGMTMP ; BUILD TMP DATA FOR $T  ***(CALLED RECURSIVELY)***
 S ATXTMPQ=0
 S X=" ;" D SETTMP
 S X="TMP ;;TAXONOMY (WITH BULLETIN)" D SETTMP
 F  S ATXZR=$Q(@ATXZR) Q:$P(ATXZR,",")'="^TMP(""ATX"""  D PGMTMP2 Q:ATXTMPQ
 Q
 ;
PGMTMP2 ;
 S X=" ;;"_$P(ATXZR,$J_",",2,99) D SETTMP
 S X=" ;;"_@ATXZR D SETTMP
 I ATXLNTH>6000 D RECURSE S ATXTMPQ=1 Q
 Q
 ;
PGMSAVE ; SAVE GENERATED PROGRAM
 S XCN=0,DIE="^TMP(""ATXPGM"","_$J_","""_ATXPGM_""",",X=ATXPGM
 X ^%ZOSF("SAVE")
 K DIE,XCM,XCN
 S X=ATXPGM
 X ^%ZOSF("TEST")
 I $T W "Routine ^",ATXPGM," has been filed.",! I 1
 E  W "Saving of routine ^",ATXPGM," failed.",!
 K ^TMP("ATXPGM",$J,ATXPGM)
 Q
 ;
SETTMP ; SET ^TMP GLOBAL
 S ATXL=ATXL+1
 S ^TMP("ATXPGM",$J,ATXPGM,ATXL,0)=X
 S ATXLNTH=ATXLNTH+(4+$L(X))
 Q
 ;
RECURSE ; CALLED FROM PGMTMP TO BUILD OTHER ROUTINES IF TOO LARGE
 NEW ATXL,ATXLNTH,ATXPGM,ATXTMPQ
 S ATXPGMC=ATXPGMC+1
 S ATXPGM=ATXPGMR_$C(64+ATXPGMC)
 D PGMBEG
 D PGMTMP
 D PGMSAVE
 S ATXPGMS(ATXPGM)=""
 Q
 ;
DRIVER ; BUILD MAIN DRIVER ROUTINE
 S ATXPGM=ATXDRVR
 K ^TMP("ATXPGM",$J,ATXPGM)
 S (ATXL,ATXLNTH)=0
 S X=ATXPGM_" ;"_ATXASP_"-CREATED BY ^ATXSTX ON "_Y_";" D SETTMP
 S X=" ;;"_ATXVER D SETTMP
 S X=" ;" D SETTMP
 S X=" ; See referenced routines to see taxonomies being loaded." D SETTMP
 S X=" ;" D SETTMP
 S X="START ;" D SETTMP
 F ATXI=1:1:26 S X=ATXPGM_$C(64+ATXI) X ^%ZOSF("TEST") Q:'$T  D
 . X "ZL @X S Z=$T(@X+2),Z=$P(Z,"";;"",2)"
 . S Y="",$P(Y," ",(10-$L(X)))=" ",Y=" ;"_Y_Z
 . S X=" D ^"_X_Y D SETTMP
 . Q
 S X=" Q" D SETTMP
 D PGMSAVE
 Q
 ;
POSTINIT ; UPDATE POST INIT ENTRY IN PACKAGE FILE
 S ATXX=$$VALI^XBDIQ1(9.4,ATXPK,914)
 I ATXX'="",ATXX'=ATXDRVR D  Q:ATXQ
 . S ATXQ=1
 . W !!,"Package file already has post-init routine=^",ATXX
 . S DIR(0)="Y",DIR("A")="Do you want me to replace it",DIR("B")="NO" K DA D ^DIR K DIR
 . Q:'Y
 . S ATXQ=0
 . Q
 S DIE="^DIC(9.4,",DA=ATXPK,DR="914////"_ATXDRVR
 D ^DIE
 W !,"Package post-init routine has been set to ^",ATXDRVR,!
 Q
 ;
EOJ ;
 K ^TMP("ATX",$J),^TMP("ATXPGM",$J)
 D EN^XBVK("ATX")
 Q
 ;
 ;-------------------
INSTALL ; This is to test the code for the post init routine
 K ^TMP("ATX",$J)
 ;F ATXI=1:1 S X=$P($T(TMP+ATXI),";;",2,99) Q:X=""  S ATXI=ATXI+1,Y=$P($T(TMP+ATXI),";;",2,99) S @X=Y
 F ATXI=4:1 S X=$P($G(^TMP("ATXPGM",$J,ATXI,0)),";;",2) Q:X=""  S ATXI=ATXI+1,Y=$P(^TMP("ATXPGM",$J,ATXI,0),";;",2) S @X=Y
 I $O(^TMP("ATX",$J,3.6,0)) D BULL^ATXSTX2
 I $O(^TMP("ATX",$J,9002226,0)) D TAX^ATXSTX2
 D KILL^ATXSTX2
 Q
 ;--------------------
 ;
CODE ;; If you modify this code change all F ATXI=n1:n2:n3 as appropriate
1 ;; ;
2 ;;START ;
3 ;; K:'$G(ATXPGMC) ^TMP("ATX",$J)
4 ;; S ATXPGMC=$G(ATXPGMC)+1
5 ;; F ATXI=1:1 S X=$P($T(TMP+ATXI),";;",2,99) Q:X=""  S X="^TMP(""ATX"",$J,"_X,ATXI=ATXI+1,Y=$P($T(TMP+ATXI),";;",2,99) S @X=Y
6 ;; D OTHER
7 ;; I $O(^TMP("ATX",$J,3.6,0)) D BULL^ATXSTX2
8 ;; I $O(^TMP("ATX",$J,9002226,0)) D TAX^ATXSTX2
9 ;; D KILL^ATXSTX2
10 ;; Q
