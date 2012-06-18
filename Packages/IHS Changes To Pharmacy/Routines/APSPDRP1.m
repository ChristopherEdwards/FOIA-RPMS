APSPDRP1 ; IHS/DSD/ENM - PRINT DUE REVIEW REPORT ;  [ 09/03/97   1:30 PM ]
 ;;6.0;IHS PHARMACY MODIFICATIONS;;09/03/97
 ; This routine is responsible for getting the information to
 ; print and doing the formatting of the report.
 ; The routine calls APSDRP2 to do the actual printing.  I had to
 ; break up the routine because of its size.
 ;
 ; Input Variables:  APSPDRP("BD"),APSPDRP("ED"),APSPDRP("IOP"),
 ;                   ^TMP("APSPDRP1",$J,
 ;-----------------------------------------------------------------
START ;
 S (DX,DY)=1 X:$D(^%ZOSF("XY"))#2 ^("XY")
 I '$D(ZTSK),$P(APSPDRP("IOP"),";",1)'=ION S IOP=APSPDRP("IOP") D ^%ZIS U IO
 ELSE  U IO
 D BODY
END D EOJ
 Q
 ;------------------------------------------------------------------
BODY ;
 F APSPDRP1("STUDY")=0:0 S APSPDRP1("STUDY")=$O(^TMP("APSPDRP1",$J,APSPDRP1("STUDY"))) Q:'APSPDRP1("STUDY")!($D(APSPDRP1("QFLG")))  D INIT,HEADER,^APSPDRP2 D:'$D(APSPDRP1("QFLG")) TOTAL
 D ^%ZISC
 Q
INIT ;
 S APSPDRP1("STUDY CNT")=0 K APSPDRP1("STUDY CR")
 F APSPI=0:0 S APSPI=$O(^APSPDUE(32.1,APSPDRP1("STUDY"),11,APSPI)) Q:'APSPI  S APSPDRP1("STUDY CR",$P(^APSPDUE(32.2,APSPI,0),U,1))="",APSPDRP1("STUDY CNT")=APSPDRP1("STUDY CNT")+1
 S APSPDRP1("CR LF")=((APSPDRP1("STUDY CNT")*6)/(IOM-68))
 S:APSPDRP1("CR LF")["." APSPDRP1("CR LF")=$P(APSPDRP1("CR LF"),".",1)+1
 K APSPI
 K APSPDRP1("YES CNT")
 S (APSPDRP1("CNT"),APSPDRP1("ALL MET CNT"))=0
 S APSPDRP1("PAGE")=0
 Q
HEADER ;EP
 S APSPDRP1("PAGE")=APSPDRP1("PAGE")+1
 I $D(DUZ(2)) W !!,$P(^DIC(4,DUZ(2),0),"^",1)," ",$P(^APSPDUE(32.1,APSPDRP1("STUDY"),0),U,1)," STUDY REPORT"
 I '$D(DUZ(2)) W !!,$P(^APSPDUE(32.1,APSPDRP1("STUDY"),0),U,1)," STUDY REPORT"
 W ?73,"Page ",APSPDRP1("PAGE")
 W !,"DATE OF REPORT: "
 S Y=DT X ^DD("DD") W Y K Y
 W !!,"This report will include all DUE review entries "
 W "from ",!
 S Y=APSPDRP("BD") X ^DD("DD") W Y," through " K Y
 S Y=$P(APSPDRP("ED"),".",1) X ^DD("DD") W Y,".",!!
 W !,?69,"CRITERIA",?(IOM-3),"ALL"
 W !,?69,"MET",?(IOM-3),"MET",!
 W !,"DATE",?15,"PATIENT",?40,"PROVIDER",?62 D
 . F APSPII=0:0 S APSPII=$O(APSPDRP1("STUDY CR",APSPII)) Q:'APSPII  W:$X+12>IOM !,?62 W ?($X+3),APSPII I $L(APSPII)<3 W $S($L(APSPII)<2:"  ",1:" ")
 K APSPII
 W ! F I=1:1:(IOM) W "_"
 W !
 Q
TOTAL ; Prints totals from Report
 I $E(IOST,1,2)="P-",($Y+6+APSPDRP1("CR LF"))>IOSL W @IOF D HEADER
 I $E(IOST,1,2)'="P-",($Y+6+APSPDRP1("CR LF"))>IOSL D EOP G:$D(APSPDRP1("QFLG")) TOTALX
 W !
 W ! F I=1:1:(IOM) W "_"
 W !
 W !,"TOTAL",?62
 F APSPII=0:0 S APSPII=$O(APSPDRP1("YES CNT",APSPII)) Q:'APSPII  W:$X+12>IOM !,?62 W ?($X+3),APSPDRP1("YES CNT",APSPII) I $L(APSPII)<3 W $S($L(APSPII)<2:"  ",1:" ")
 W ?(IOM-3),APSPDRP1("ALL MET CNT")
 W !,"COUNT",?15,APSPDRP1("CNT")
 W !
 I $E(IOST,1,2)="P-" W @IOF
TOTALX Q
 ;
EOP ; Calls reader for an End of Page call
 S DIR(0)="E" D ^DIR K DIR,X,Y
 S:$D(DTOUT)!($D(DUOUT)) APSPDRP1("QFLG")=1
 S (DX,DY)=1 X:$D(^%ZOSF("XY"))#2 ^("XY")
 Q
EOJ ;
 K:$D(ZTSK) ZTSK ;IHS/DSD/ENM 01/14/97
 K APSPDRP1,^TMP("APSPDRP1",$J),DTOUT,DUOUT,DIR,DIRUT
 Q
 ;
