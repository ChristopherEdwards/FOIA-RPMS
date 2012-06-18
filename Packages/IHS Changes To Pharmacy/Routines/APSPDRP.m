APSPDRP ; IHS/DSD/ENM - SORT ENTRIES FROM DUE REVIEW FILE ;  [ 09/03/97   1:30 PM ]
 ;;6.0;IHS PHARMACY MODIFICATIONS;;09/03/97
 ;------------------------------------------------------------
START ;
 D BD ; Ask Beginning and Ending Dates
 G:'$D(APSPDRP("ED")) END
 D DIC ;Select the DUE Study
 G:'$D(APSPDRP("DFN'S")) END
 D QUE ;Ask Device
 G:POP!($D(IOQ)) END
EN D BODY ;Main driver for rest of routine
END D EOJ ; Clean up local variables
 Q
 ;--------------------------------------------------------------
BD ;
 K ^TMP("APSPDRP1",$J)
 S %DT("A")="PLEASE ENTER BEGINNING DATE: "
 S %DT="AE"
 D ^%DT
 I Y=-1 G BDX
 S APSPDRP("BD")=Y
 S %DT("A")="PLEASE ENTER ENDING DATE: "
 D ^%DT
 I Y=-1 G:X="" BD G BDX
 S APSPDRP("ED")=Y_".999999"
BDX Q
 ;
DIC ;
 S DIC="^APSPDUE(32.1,"
 S DIC(0)="AEQM"
 D ^DIC K DIC,DR
 I Y>0,'$D(^APSPDUE(32,"D",+Y)) W !,"No Review's on File for this Study..",! S DIC("A")="ANOTHER ONE: " G DIC
 I Y>0 S APSPDRP("DFN'S",+Y)="",DIC("A")="ANOTHER ONE: " G DIC
 K:$D(DTOUT)!($D(DUOUT)) APSPDRP("DFN'S")
 Q
QUE ;
 W !
 S %ZIS="QMN"
 D ^%ZIS
 I POP G QUEX
 I $D(IO("Q")),IO=IO(0) W !!,"Sorry, you cannot queue to your screen or to a slave printer.",! K IO("Q") G QUE
 S APSPDRP("IOP")=ION_";"_IOM
 I IO=IO(0)!('$D(IO("Q"))) D ^%ZISC G QUEX
 D ^%ZISC
 S ZTRTN="EN^APSPDRP",ZTSAVE("APSPDRP(""BD"")")=""
 S ZTSAVE("APSPDRP(""DFN'S"",")=""
 S ZTSAVE("APSPDRP(""ED"")")="",ZTIO="",ZTSAVE("APSPDRP(""IOP"")")=""
 S ZTDESC="PHARMACY DUE REVIEWS"
 D ^%ZTLOAD
 S:'$D(ZTSK) POP=1
QUEX Q
 ;------------------------------------------------------------------
BODY ;
 F APSPII=(APSPDRP("BD")-1):0 S APSPII=$O(^APSPDUE(32,"B",APSPII)) Q:APSPII>APSPDRP("ED")!('APSPII)  D SORT
 K APSPII
 I $D(ZTQUEUED) S ZTREQ="@" D QUE2 G BODYX
 D ^APSPDRP1
BODYX Q
 ;-------------------------------------------------------------------
SORT ;
 F APSPDRP("DA")=0:0 S APSPDRP("DA")=$O(^APSPDUE(32,"B",APSPII,APSPDRP("DA"))) Q:'APSPDRP("DA")  I $D(^APSPDUE(32,APSPDRP("DA"),0)),$D(APSPDRP("DFN'S",$P(^(0),U,2))) D
 . S ^TMP("APSPDRP1",$J,$P(^APSPDUE(32,APSPDRP("DA"),0),U,2),APSPII,$P(^(0),U,3),APSPDRP("DA"))=""
 . Q
 Q
QUE2 ;
 S ZTDTH=$H
 S ZTRTN="^APSPDRP1",ZTSAVE("APSPDRP(""BD"")")=""
 S ZTSAVE("^TMP(""APSPDRP1"",$J,")=""
 S ZTSAVE("APSPDRP(""ED"")")="",ZTSAVE("APSPDRP(""IOP"")")=""
 S ZTDESC="PRINT PHARMACY DUE REVIEWS"
 S ZTIO=APSPDRP("IOP")
 D ^%ZTLOAD
 Q
EOJ ;
 K APSPDRP,APSPII,ZTSK,ZTSAVE,ZTIO,IOP,IOQ,POP
 K ZTRTN,ZTDESC,%ZIS
 Q
