AMEROUT5 ; IHS/ANMC/GIS - HOURLY WORKLOAD DISPLAY DRIVER ; 
 ;;3.0;ER VISIT SYSTEM;;FEB 23, 2009
 ;
CRT ; DISPLAY THE REPORT ON A CRT
 N T,OCXI,X
 W @IOF,!?20,"*****  HOURLY WORKLOAD REPORT  *****",!!
 S (OCXI,T)=0 F  S OCXI=$O(^TMP("AMER PRINT",$J,OCXI)) Q:'OCXI  S X=^(OCXI) D  I T Q
 . I X="<>" S T=$$READ(X) W ! Q
 . W X,!
 . Q
 S T=$$READ("<>")
 Q
 ;
READ(X) ; END OF PAGE
 N %
 S DIR(0)="E",DIR("A")=X
 D ^DIR I $D(DUOUT)!$D(DTOUT) K DIR,Y,DUOUT Q 1
 W *13,?79,*13
 Q 0
 ;
ZIS ;ENTRY POINT FROM AMEROUT4
 ; ASK USER FOR DEVICE
 N POP,%ZIS,ZTRTN,ZTIO,ZTDESC,ZTSAVE,ZTSK
 S %ZIS="Q",%ZIS("A")="Print HOURLY WORKLOAD TOTALS on which device: "
 D ^%ZIS I POP S AMERQUIT=1 Q
 I '$D(IO("Q")),IOST["C-" D CRT Q
 I $D(IO("Q")) S ZTRTN="OUTPUT^AMEROUT5",ZTIO=ION,ZTDESC="Print patient instructions for ER system",ZTSAVE("^TMP(""AMER PRINT"",$J,")="" D ^%ZTLOAD I 1
 I  W !!,$S($D(ZTSK):"Request queued!",1:"Unable to queue job.  Request cancelled!") D ^%ZISC Q
 U IO
 D OUTPUT
 Q
 ;
OUTPUT ; PRINT INSTRUCTIONS
 N OCXI,X,T
 W !?20,"*****  HOURLY WORKLOAD REPORT  *****",!!
 S (OCXI,T)=0 F  S OCXI=$O(^TMP("AMER PRINT",$J,OCXI)) Q:'OCXI  S X=^(OCXI) D
 . I X="<>" W !! W:T @IOF S T='T Q
 . W X,!
 . Q
 I 'T W @IOF
 D EXIT^AMEROUT4
 I $D(ZTQUEUED) S ZTREQ="@" Q
 D ^%ZISC
 Q
 ;
FILTER ;ENTRY POINT FROM AMEROUT4
 ; FILTER OUT INVALID TIME VALUES
 N %
 W !!!,"Some of the times recorded in the database may be invalid; i.e., negative or",!,"excessively long intervals.",!,"Want to FILTER out data which is likely to be invalid"
 S %=2 D YN^DICN
 I %=-1 Q
 I %=1 S AMERFLTR=1
 W !!
 Q
