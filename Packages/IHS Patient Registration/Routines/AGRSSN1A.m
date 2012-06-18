AGRSSN1A ; IHS/ASDS/EFG - SSN Statistical Report - CONT FEB 6,1995 ;  
 ;;7.1;PATIENT REGISTRATION;;AUG 25,2005
 ;
WRT ;EP
 S IOP=AG("IOP")_";80",AG("PG")=0 D ^%ZIS U IO
 D HD
 S AG("LOC")=0 F AG("I")=1:1 S AG("LOC")=$O(^TMP("AG-SSN1",$J,AG("LOC"))) Q:AG("LOC")=""  D BODY
 I AG("I")>2 S AG("LOC")=0 D BODY
 G XIT
BODY I $Y>(IOSL-7),IO=IO(0),$E(IOST)="C" S DIR(0)="E" D ^DIR Q:$D(DTOUT)!$D(DUOUT)!$D(DIROUT)  D HD
 I $Y>(IOSL-7) D HD
 D LOC
 W !,"Age Distributions..:   0-9   10-19  20-29  30-39  40-49  50-59  60-Over   Total "
 I AG("LOC")'=0 W !,"                      -----  -----  -----  -----  -----  -----  -------  -------"
 E  W !,"                      =====  =====  =====  =====  =====  =====  =======  ======="
 W !,"Patients with SSN..:"
 S AG("T")=0 F X=1:1:7 W $J($FN($P(^TMP("AG-SSN1",$J,AG("LOC"),0),U,X),",",0),$S(X=7:9,1:7)) S AG("T")=AG("T")+$P(^(0),U,X)
 W ?73,$J($FN(AG("T"),","),7)
 W !,"Total Patients.....:"
 S AG("T")=0 F X=8:1:14 W $J($FN($P(^TMP("AG-SSN1",$J,AG("LOC"),0),U,X),",",0),$S(X=14:9,1:7)) S AG("T")=AG("T")+$P(^(0),U,X)
 W ?73,$J($FN(AG("T"),","),7)
 W !,"Percent Compliance.:"
 S (AG("TT"),AG("CT"))=0 F X=1:1:7 S AG("C")=$P(^TMP("AG-SSN1",$J,AG("LOC"),0),U,X),AG("T")=$P(^(0),U,X+7) W $J($S('+AG("T"):0,1:AG("C")/AG("T")*100),$S(X=7:9,1:7),0) S AG("TT")=AG("TT")+$P(^(0),U,X+7),AG("CT")=AG("CT")+$P(^(0),U,X)
 W ?73,$J($S(+AG("TT")=0:0,1:AG("CT")/AG("TT")*100),7,0)
 Q
 ;
HD W $$S^AGVDF("IOF") S AG("PG")=AG("PG")+1
 W !,AG("HD"),?60 S Y=DT D DD^%DT W Y,?73,"Page ",AG("PG")
 W:$D(AG("HD",1)) !,AG("HD",1)
 W:$D(AG("HD",2)) !,AG("HD",2)
 W !,"--------------------------------------------------------------------------------"
 Q
LOC W !! I AG("LOC")=0 W "*********************************  TOTALS  **********************************"
 E  W "LOCATION: ",AG("LOC")
 Q
XIT Q
