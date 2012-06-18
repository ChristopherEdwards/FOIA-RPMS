ACDRR1 ;IHS/ADC/EDE/KML - SUBSTANCE USE REPORT;
 ;;4.1;CHEMICAL DEPENDENCY MIS;;MAY 11, 1998
 ;
 ; This routine prints a patient problem summary report for
 ; a specified time frame.
 ;
START ;
 D INIT
 Q:ACDQ
 D DBQUE
 Q
 ;
INIT ;
 S ACDQ=1
 W !,"This routine prints a patient problem summary report for a specified time frame",!
 S ACDAIEN=$O(^ACDPROB("B","ALCOHOL",0))
 Q:'ACDAIEN
 S ACDDIEN=$O(^ACDPROB("B","DRUGS",0))
 Q:'ACDDIEN
 D GETDTR^ACDDEU ;              get acddtlo & acddthi
 Q:ACDQ
 S ACDQ=0
 Q
 ;
DBQUE ; call to XBDBQUE
 S ACDQ=1
 W ! S DIR(0)="S^P:PRINT Output;B:BROWSE Output on Screen",DIR("A")="Do you wish to",DIR("B")="P" K DA D ^DIR K DIR
 Q:$D(DIRUT)
 I Y="B" D BROWSE Q
 S XBRP="^ACDRR1P",XBRC="^ACDRR1C",XBRX="EOJ^ACDRR1",XBNS="ACD"
 D ^XBDBQUE
 Q
 ;
BROWSE ;
 S XBRP="VIEWR^XBLM(""^ACDRR1P"")"
 S XBRC="^ACDRR1C",XBRX="EOJ^ACDRR1",XBIOP=0
 D ^XBDBQUE
 Q
 ;
EOJ ; EP-CALLED BY XBDBQUE
 W:IOST["P-" @IOF
 ;K ^TMP("ACDRR1",ACDJOB,ACDBTH)
 K %,%1,%2,%3,%DT,F,M,V,W,X,Y,Z
 K ACDBT,ACDBTH,ACDCMBO,ACDDIEN,ACDDTHI,ACDDTLO,ACDET,ACDJOB,ACDPRIEN,ACDTRIBE,ACDSAVEX
 Q
