AZAXPKG ;IHS/PHXAO/AEF - CHECK PACKAGE FILE
 ;;1.0;ANNE'S SPECIAL ROUTINES;;AUG 4, 2004
 ;
DESC ;----- ROUTINE DESCRIPTION
 ;;
 ;; This routine checks the PACKAGE file for the following: 
 ;; 1) Duplicate entries in both the package names and prefixes (namespaces)
 ;; 2) Missing CURRENT VERSION fields
 ;; 3) Compares the INSTALL and PACKAGE files to determine if there are
 ;;    entries in the INSTALL file that are not in the PACKAGE file
 ;;     
 ;;$$END
 ;
EN ;EP -- MAIN ENTRY POINT
 ;
 D ^XBKVAR
 D HOME^%ZIS
 ;
 D TXT
 ;
 D QUE("DQ^AZAXPKG","","PACKAGE FILE CHECK")
 ;
 Q
DQ ;----- QUEUED JOB STARTS HERE
 ;
 D ^XBKVAR
 ;
 D PRT
 ;
 K ^TMP("AZAX",$J,"PKGCHK")
 ;
 D ^%ZISC
 Q
PRT ;----- PRINT THE REPORT
 ;
 N OUT,PAGE
 ;
 S (PAGE,OUT)=0
 ;
 D DUPCHK(.PAGE,.OUT)
 Q:OUT
 ;
 D CURVER(.PAGE,.OUT)
 Q:OUT
 ;
 D COMP(.PAGE,.OUT)
 Q:OUT
 ;
 Q 
DUPCHK(PAGE,OUT) ;
 ;----- CHECK FOR DUPLICATE NAME ENTRIES
 ;
 N D0,DATA,DUPE,PKG,T,XREF
 ;
 K ^TMP("AZAX",$J,"PKGCHK")
 ;
 S T="DUPLICATE PACKAGE NAMES/PREFIXES"
 D HDR(T,.PAGE,.OUT)
 Q:OUT
 ;
 S DUPE=0
 ;
 F XREF="B","C" D
 . S PKG=""
 . F  S PKG=$O(^DIC(9.4,XREF,PKG)) Q:PKG']""  D
 . . S D0=0
 . . F  S D0=$O(^DIC(9.4,XREF,PKG,D0)) Q:'D0  D
 . . . Q:$O(^DIC(9.4,"C",PKG,D0,0))   ;ADDITIONAL PREFIX
 . . . S ^TMP("AZAX",$J,"PKGCHK",XREF,PKG)=+$G(^TMP("AZAX",$J,"PKGCHK",XREF,PKG))+1
 . . . I ^TMP("AZAX",$J,"PKGCHK",XREF,PKG)>1 S DUPE=DUPE+1
 ;
 I DUPE'>0 D  Q
 . W !!?5,"NO DUPLICATES FOUND"
 ;
 F XREF="B","C" D  Q:OUT
 . S PKG=""
 . F  S PKG=$O(^TMP("AZAX",$J,"PKGCHK",XREF,PKG)) Q:PKG']""  D  Q:OUT
 . . Q:^TMP("AZAX",$J,"PKGCHK",XREF,PKG)'>1
 . . I $Y>(IOSL-5) D HDR(T,.PAGE,.OUT)
 . . Q:OUT
 . . W !
 . . S D0=0
 . . F  S D0=$O(^DIC(9.4,XREF,PKG,D0)) Q:'D0  D  Q:OUT
 . . . I $Y>(IOSL-5) D HDR(T,.PAGE,.OUT)
 . . . Q:OUT
 . . . S DATA=$G(^DIC(9.4,D0,0))
 . . . W !,$J(D0,4)_" "_$P(DATA,U)_" ("_$P(DATA,U,2)_")"
 ;
 K ^TMP("AZAX",$J,"PKGCHK")
 ;
 Q
CURVER(PAGE,OUT) ;
 ;----- CHECK FOR MISSING CURRENT VERSION
 ;
 N D0,PKG,T
 ;
 K ^TMP("AZAX",$J,"PKGCHK")
 ;
 S T="PACKAGES MISSING CURRENT VERSION"
 D HDR(T,.PAGE,.OUT)
 Q:OUT
 ;
 S D0=0
 F  S D0=$O(^DIC(9.4,D0)) Q:'D0  D
 . Q:$P($G(^DIC(9.4,D0,"VERSION")),U)]""
 . S PKG=$P($G(^DIC(9.4,D0,0)),U)
 . Q:PKG']""
 . S ^TMP("AZAX",$J,"PKGCHK",PKG,D0)=""
 ;
 I '$D(^TMP("AZAX",$J,"PKGCHK")) D  Q
 . W !?5,"EVERYTHING LOOKS OK"
 ;
 S PKG=""
 F  S PKG=$O(^TMP("AZAX",$J,"PKGCHK",PKG)) Q:PKG']""  D  Q:OUT
 . S D0=0
 . F  S D0=$O(^TMP("AZAX",$J,"PKGCHK",PKG,D0)) Q:'D0  D  Q:OUT
 . . I $Y>(IOSL-5) D HDR(T,.PAGE,.OUT)
 . . Q:OUT
 . . W !,$J(D0,4),"  ",PKG
 ;
 K ^TMP("AZAX",$J,"PKGCHK")
 ;
 Q
COMP(PAGE,OUT) ;
 ;----- COMPARE PACKAGE AND INSTALL FILES
 ;
 N D0,NAME,PAT,PKG,PKGD0,T,TYPE,VER,VERD0
 ;
 K ^TMP("AZAX",$J,"PKGCHK")
 ;
 S T="INSTALL FILE ITEMS NOT FOUND IN PACKAGE FILE"
 D HDR(T,.PAGE,.OUT)
 Q:OUT     
 ;
 S D0=0
 F  S D0=$O(^XPD(9.7,D0)) Q:'D0  D
 . Q:$P($G(^XPD(9.7,D0,0)),U,9)'=3   ;INSTALL COMPLETED
 . S NAME=$P($G(^XPD(9.7,D0,0)),U)
 . S TYPE="PATCH"
 . I NAME'["*" S TYPE="PACKAGE"
 . S PKG=$$PKG(D0)
 . S VER=$$VER(D0)
 . S PAT=$$PAT(D0)
 . ;
 . Q:PKG']""
 . S PKGD0=$O(^DIC(9.4,"B",PKG,0))
 . I 'PKGD0 D  Q
 . . S ^TMP("AZAX",$J,"PKGCHK",TYPE_" '"_PKG_"'")=""
 . I '$D(^DIC(9.4,PKGD0,22,"B",VER)) D  Q
 . . S ^TMP("AZAX",$J,"PKGCHK",TYPE_" '"_PKG_" "_VER_"'")=""
 . Q:TYPE="PACKAGE"
 . S VERD0=$O(^DIC(9.4,PKGD0,22,"B",VER,0))
 . I '$D(^DIC(9.4,PKGD0,22,VERD0,"PAH","B",PAT)) D  Q
 . . S ^TMP("AZAX",$J,"PKGCHK",TYPE_" "_NAME_" '"_PKG_" "_VER_" PATCH "_PAT_"'")=""
 ;
 I '$D(^TMP("AZAX",$J,"PKGCHK")) D  Q
 . W !?5,"EVERYTHING LOOKS OK"
 ;
 S PKG=""
 F  S PKG=$O(^TMP("AZAX",$J,"PKGCHK",PKG)) Q:PKG']""  D  Q:OUT
 . I $Y>(IOSL-5) D HDR(T,.PAGE,.OUT)
 . Q:OUT
 . W !,PKG
 ;
 K ^TMP("AZAX",$J,"PKGCHK")
 ;
 Q
PKG(D0) ;
 ;----- GET PACKAGE NAME
 ;
 N %,X,Y,Z
 ;
 S Y=""
 S X=$P($G(^XPD(9.7,D0,0)),U)
 I X["*" D
 . S Z=$P(X,"*")
 . S Z=$O(^DIC(9.4,"C",Z,0))
 . I Z S Y=$P($G(^DIC(9.4,Z,0)),U)
 I X'["*" D
 . S %=$L(X," ")
 . S Y=$P(X," ",1,%-1)
 S X=$P($G(^XPD(9.7,D0,0)),U,2)
 I X S Y=$P($G(^DIC(9.4,X,0)),U)
 Q Y
VER(D0) ;
 ;----- GET VERSION NUMBER
 ;
 N %,X,Y
 ;
 S Y=""
 S X=$P($G(^XPD(9.7,D0,0)),U)
 I X["*" D
 . S Y=$P(X,"*",2)
 I X'["*" D
 . S %=$L(X," ")
 . S Y=$P(X," ",%)
 Q Y
PAT(D0) ;
 ;----- GET PATCH NUMBER
 ;
 N X,Y
 ;
 S Y=""
 S X=$P($G(^XPD(9.7,D0,0)),U)
 I X["*" D
 . S Y=$P(X,"*",3)
 Q Y
HDR(T,PAGE,OUT) ;
 ;----- PRINT HEADER
 ;
 N DIR,DIRUT,DTOUT,DUOUT,I,X,Y
 ;
 I $E(IOST,1,2)="C-",$G(PAGE) S DIR(0)="E" D ^DIR K DIR I 'Y S OUT=1 Q
 ;
 S PAGE=$G(PAGE)+1
 W @IOF
 W !,T
 W ?49,$$NOW
 W "   PAGE ",PAGE
 W !
 F I=1:1:IOM W "-"
 Q
TXT ;----- PRINT ROUTINE DESCRIPTION
 ;
 N I,X
 F I=1:1 S X=$P($T(DESC+I),";",3) Q:X["$$END"  W !,X
 Q
NOW() ;----- RETURNS CURRENT DATE/TIME
 ;
 N %,%H,%I,X
 D ^XBKVAR
 D NOW^%DTC
 S Y=DT
 X ^DD("DD")
 Q Y_" "_$E($P(%,".",2),1,2)_":"_$E($P(%,".",2),3,4)
 ;
QUE(ZTRTN,ZTSAVE,ZTDESC) ;
 ;----- QUEUEING CODE
 ;
 N %ZIS,IO,POP,ZTIO,ZTSK
 S %ZIS="Q"
 D ^%ZIS
 Q:POP
 I $D(IO("Q")) D  Q
 . I IO("Q")
 . S ZTIO=ION_";"_IOST_";"_IOM_";"_IOSL
 . D ^%ZTLOAD
 . I $G(ZTSK) W !,"Task #",ZTSK," queued"
 D @ZTRTN
 Q
