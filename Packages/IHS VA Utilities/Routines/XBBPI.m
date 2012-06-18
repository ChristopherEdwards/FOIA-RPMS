XBBPI ; IHS/ADC/GTH - BUILD PACKAGE PRE-INIT ROUTINE ; [ 02/07/97   3:02 PM ]
 ;;3.0;IHS/VA UTILITIES;;FEB 07, 1997
 ;
 ; This routine builds a pre-init routine for a specified
 ; package. The pre-init routine will delete FileMan
 ; dictionaries being created by the package.  Data
 ; globals and templates will be saved.
 ;
START ;
 D ^XBKVAR
 W !!,"This routine will build a pre-init routine for the specified package."
 W !,"The pre-init routine will call XBKD to delete the FileMan dictionaries"
 W !,"being created by the package.  Data globals and templates will be saved.",!!
 F XBBPLOOP=0:0 D PACKAGE Q:Y<0  D BUILD
 KILL %,XBBPLOOP
 Q
 ;
PACKAGE ;
 S DIC="^DIC(9.4,",DIC(0)="AEMQ"
 D ^DIC
 KILL DIC
 Q
 ;
BUILD ;
 S XBBPDFN=+Y,XBBPPRFX=$P(^DIC(9.4,XBBPDFN,0),U,2),Y=DT
 D DD^%DT
 S XBBPVER=$G(^DIC(9.4,XBBPDFN,"VERSION"))_";"_$P(^DIC(9.4,XBBPDFN,0),U,1)_";;"_Y,XBBPPGM=XBBPPRFX_"PREI"
 D CHECKRTN
 I XBBPFLG D EOJ3 W !!,"Bye",! Q
 KILL ^UTILITY("XBBPI",$J),^UTILITY("XBBPPGM",$J),^UTILITY("XBBPI EXEC",$J)
 W "."
 S (XBBPX,XBBPFLE)=0
 F XBBPL=0:0 S XBBPFLE=$O(^DIC(9.4,XBBPDFN,4,"B",XBBPFLE)) Q:XBBPFLE'=+XBBPFLE  S ^UTILITY("XBBPI",$J,XBBPFLE)=""
 W "."
 S XBBPFLG=0,XBBPFLE=""
 F XBBPL=0:0 S XBBPFLE=$O(^UTILITY("XBBPI",$J,XBBPFLE)) Q:XBBPFLE'=+XBBPFLE  I '$D(^DIC(XBBPFLE)) S XBBPFLG=1 W !,XBBPFLE," does not exist in ^DIC!"
 I XBBPFLG W !!,"All files in package must exist.  Fix and rerun.",!! D EOJ Q
 W "."
 S XBBPFLE=""
 F XBBPL=0:0 S XBBPFLE=$O(^UTILITY("XBBPI",$J,XBBPFLE)) Q:XBBPFLE'=+XBBPFLE  S ^(XBBPFLE)="^UTILITY(""XBDSET"",$J,"_XBBPFLE_")=S^S"
 W "."
 S %DT="",X="T"
 D ^%DT
 X ^DD("DD")
 S ^UTILITY("XBBPPGM",$J,1,0)=XBBPPGM_" ; CREATED BY XBBPI ON "_Y
 S ^UTILITY("XBBPPGM",$J,2,0)=" ;;"_XBBPVER
 F XBBPI=1:1:3 S ^UTILITY("XBBPPGM",$J,XBBPI+2,0)=$P($T(DTA+XBBPI),";;",2,99)
 S XBBPFLE=0
 F XBBPI=6:1 S XBBPFLE=$O(^UTILITY("XBBPI",$J,XBBPFLE)) Q:XBBPFLE'=+XBBPFLE  S XBBPY=^(XBBPFLE),^UTILITY("XBBPPGM",$J,XBBPI,0)=" ;;"_XBBPY
 S DIE="^UTILITY(""XBBPPGM"",$J,",X=XBBPPGM,XCN=0
 X ^%ZOSF("SAVE")
 D EOJ
 Q
 ;
CHECKRTN ;
 S XBBPFLG=0
 Q:'$D(^DD("OS"))#2
 Q:'$D(^DD("OS",^DD("OS"),18))#2  S X=XBBPPGM X ^(18)
 E  Q
CR2 ;
 W !!,XBBPPGM," already exists.  Want to recreate it (Y/N) Y//"
 D YN^DICN
 S:$E(%Y)="N" XBBPFLG=1
 Q
 ;
EOJ ;
 W !!,"Routine ",XBBPPGM," has been filed.",!!
 I '$D(^DIC(9.4,XBBPDFN,"INI")) D EOJ2
 I $D(^DIC(9.4,XBBPDFN,"INI")),$P(^("INI"),U)="" D EOJ2 I 1
 E  I $D(^DIC(9.4,XBBPDFN,"INI")),$P(^("INI"),U)'=XBBPPGM W !!,"Package ",XBBPPRFX," has a pre-initialization routine entry but it is ",$P(^("INI"),U),"!"
 D EOJ3
 Q
 ;
EOJ2 ;
 W !,"Package ",XBBPPRFX," has no pre-initialization routine entry!",!
 Q
 ;
EOJ3 ;
 KILL ^UTILITY("XBBPI",$J),^UTILITY("XBBPPGM",$J),^UTILITY("XBBPI EXEC",$J)
 KILL %,%DT,DIE,XCN
 KILL XBBPDFN,XBBPFLE,XBBPFLG,XBBPI,XBBPL,XBBPP,XBBPPGM,XBBPPRFX,XBBPX,XBBPY,XBBPVER
 Q
 ;
DTA ;
 ;; K ^UTILITY("XBDSET",$J) F XBBPI=1:1 S XBBPIX=$P($T(Q+XBBPI),";;",2) Q:XBBPIX=""  S XBBPIY=$P(XBBPIX,"=",2,99),XBBPIX=$P(XBBPIX,"=",1) S @XBBPIX=XBBPIY
 ;; K XBBPI,XBBPIX,XBBPIY D EN2^XBKD
 ;;Q Q
