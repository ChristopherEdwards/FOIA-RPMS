AQAQPR4 ;IHS/ANMC/LJF - OUTPT DX BY PROVIDER; [ 09/28/92  1:10 PM ]
 ;;2.2;STAFF CREDENTIALS;;01 OCT 1992
 ;
 W @IOF,!!?25,"AMBULATORY DIAGNOSES BY PROVIDER",!!
 W !,"This report gives you SUBCOUNTS BY DIAGNOSTIC CATEGORY for"
 W !,"outpatient visits.  You can choose counts of PRIMARY diagnoses"
 W !,"only or BOTH primary and secondary diagnoses.  You will be asked"
 W !,"for a DATE RANGE.  You can get the report for ALL PROVIDERS or"
 W !,"only ONE PROVIDER; for ONE CLASS such as all pediatricians; or"
 W !,"for one STAFF CATEGORY.  The report is SUBTOTALED by provider"
 W !,"with the total number of diagnoses at the end of the report.",!
 ;
 ;***> select date range
DATE S %DT="AEQ",%DT("A")="Earliest visit date: ",X="" D ^%DT
 G END:Y=-1 S AQAQBDT=Y
DATE2 S %DT="AEQ",%DT("A")="Last visit date: ",X="" D ^%DT
 G DATE:Y=-1 S AQAQEDT=Y
 I AQAQEDT<AQAQBDT W *7,!!?5,"Ending date MUST NOT be before beginning date",! G DATE2
 I AQAQEDT'<DT S X1=DT,X2=-1 D C^%DTC S AQAQEDT=X
 ;
DX ;***> primary dx only or primary & secondary
 W ! K DIR S DIR(0)="NO^1:2",DIR("A")="Select"
 S DIR("A",1)=" 1)  PRIMARY Diagnoses only"
 S DIR("A",2)=" 2)  BOTH Primary & Secondary Diagnoses"
 D ^DIR G PRV:X="",END:$D(DIRUT),END:Y=-1 S AQAQCDX=Y
 ;
 ;***> select one provider, by class or by category
PRV W ! K DIR S DIR(0)="NO^1:3",DIR("A")="Choose One"
 S DIR("A",1)="1.  Print diagnostic category counts by PROVIDER"
 S DIR("A",2)="2.  Print diagnostic category counts for one PROVIDER CLASS"
 S DIR("A",3)="3.  Print diagnostic category counts for one STAFF CATEGORY"
 D ^DIR G DATE2:X="",END:$D(DIRUT) S AQAQTYP=+Y
 I AQAQTYP>1 G ONE
 ;
ALL ;***> choose one or all classes or categories
 W ! K DIR S DIR(0)="Y" S DIR("A")="Print for ALL PROVIDERS"
 S DIR("B")="NO" D ^DIR I Y=1 S AQAQSRT="" G DEV
 I $D(DIRUT) G END  ;check for timeout,"^", or null
 ;
ONE ;***> choose which class or category to print
 W ! K DIR,AQAQSRT
 S DIR(0)="PO^"_$S(AQAQTYP=1:6,AQAQTYP=2:7,1:"")_":EMQZ"
 I AQAQTYP=3 S DIR(0)="9002165,.02"
 D ^DIR G PRV:X="",END:$D(DIRUT)
 S AQAQSRT=Y
 ;
 ;***> select print device
DEV W ! S %ZIS="PQ" D ^%ZIS G END:POP,QUE:$D(IO("Q")) U IO G ^AQAQPR41
QUE K IO("Q") S ZTRTN="^AQAQPR41" S ZTDESC="DX CATEGORIES BY PROVIDER"
 F AQAQI="AQAQBDT","AQAQEDT","AQAQTYP","AQAQSRT","AQAQCDX" S ZTSAVE(AQAQI)=""
 D ^%ZTLOAD D ^%ZISC K ZTSK
 ;
END K Y,AQAQBDT,AQAQEDT,AQAQTYP,AQAQSRT,AQAQI,AQAQCDX,DIR D HOME^%ZIS Q
 ;
 ;
ERR ;EP;***> entry point to handle errors
 X ^%ZOSF("NBRK")
 ;if OS is DSM or MSM, don't kill variables if not an interrupt
 ;APPROVED EXCEPTION TO STANDARDS - USE OF $ZE
 I $D(^%ZOSF("OS")),(($P(^%ZOSF("OS"),U)["MSM")!($P(^("OS"),U)["DSM")) I $ZE?1"<INRPT>".E D ^%ZISC W *7,!!?30,"Interrupt Acknowledged",!! H 3 I 1
 E  D ^%ET
 D END^AQAQPR42 Q
