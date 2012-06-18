ACDRR3 ;IHS/ADC/EDE/KML - OUTCOME REPORT (STAGE);
 ;;4.1;CHEMICAL DEPENDENCY MIS;;MAY 11, 1998
 ;
 ; This routine prints a patient outcome report listing the
 ; stages over time.
 ;
START ;
 D INIT
 Q:ACDQ
 D DBQUE
 Q
 ;
INIT ;
 S ACDQ=1
 W !,"This routine prints a patient outcome report for a specified time frame",!
 D GETDTR^ACDDEU ;              get acddtlo & acddthi
 Q:ACDQ
 D GETPAT^ACDDEGP ;             get patient
 Q:ACDQ
 S ACDQ=0
 Q
 ;
DBQUE ; call to XBDBQUE
DEBUG D ^ACDRR3C,^ACDRR3P Q
 S ACDQ=1
 W ! S DIR(0)="S^P:PRINT Output;B:BROWSE Output on Screen",DIR("A")="Do you wish to",DIR("B")="P" K DA D ^DIR K DIR
 Q:$D(DIRUT)
 I Y="B" D BROWSE Q
 S XBRP="^ACDRR3P",XBRC="^ACDRR3C",XBRX="EOJ^ACDRR3",XBNS="ACD"
 D ^XBDBQUE
 Q
 ;
BROWSE ;
 S XBRP="VIEWR^XBLM(""^ACDRR3P"")"
 S XBRC="^ACDRR3C",XBRX="EOJ^ACDRR3",XBIOP=0
 D ^XBDBQUE
 Q
 ;
EOJ ; EP-CALLED BY XBDBQUE
 W:IOST["P-" @IOF
 ;K ^TMP("ACDRR3",ACDJOB,ACDBTH)
 K %,%1,%2,%3,%DT,F,M,V,W,X,Y,Z
 K ACDBT,ACDBTH,ACDDTHI,ACDDTLO,ACDET,ACDJOB
 Q
