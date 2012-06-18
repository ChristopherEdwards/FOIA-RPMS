AQAQPR2 ;IHS/ANMC/LJF - PROCEDURES BY PROVIDER(PCC DATA); [ 09/28/92  1:08 PM ]
 ;;2.2;STAFF CREDENTIALS;;01 OCT 1992
 ;
 W @IOF,!!?25,"PROCEDURES BY PROVIDER",!!
 W !,"This report gives you a listing (with subcounts) of INPATIENT "
 W !,"procedures by operating provider and OUTPATIENT procedures by"
 W !,"primary provider.  You will be asked for a DATE RANGE.  You can"
 W !,"get the report for ALL PROVIDERS or only ONE PROVIDER, for ONE"
 W !,"CLASS such as all pediatricians; or one STAFF CATEGORY."
 W !,"The report is SUBTOTALED by provider and within each provider"
 W !,"by procedure category.",!!
 ;
 ;***> select date range
DATE S %DT="AEQ",%DT("A")="Beginning date: ",X="" D ^%DT
 G END:Y=-1 S AQAQBDT=Y
DATE2 S %DT="AEQ",%DT("A")="Ending date: ",X="" D ^%DT
 G DATE:Y=-1 S AQAQEDT=Y
 I AQAQEDT<AQAQBDT W *7,!!?5,"Ending date MUST NOT be before beginning date",! G DATE2
 I AQAQEDT'<DT S X1=DT,X2=-1 D C^%DTC S AQAQEDT=X
 ;
 ;***> select one provider, by class or by category
PRV K DIR S DIR(0)="NO^1:3",DIR("A")="Choose One"
 S DIR("A",1)="1.  Print procedures by PROVIDER"
 S DIR("A",2)="2.  Print procedures by PROVIDER CLASS"
 S DIR("A",3)="3.  Print procedures by STAFF CATEGORY"
 D ^DIR G DATE2:X="",END:$D(DIRUT) S AQAQTYP=+Y
 I AQAQTYP>1 G ONE
 ;
ALL ;***> choose one or all classes or categories
 K DIR S DIR(0)="Y" S DIR("A")="Print for ALL PROVIDERS"
 S DIR("B")="NO" D ^DIR I Y=1 S AQAQSRT="" G DEV
 I $D(DIRUT) G END  ;check for timeout,"^", or null
 ;
ONE ;***> choose which class or category to print
 K DIR,AQAQSRT
 S DIR(0)="PO^"_$S(AQAQTYP=1:6,AQAQTYP=2:7,1:"")_":EMQZ"
 I AQAQTYP=3 S DIR(0)="9002165,.02"
 D ^DIR G PRV:X="",END:$D(DIRUT)
 S AQAQSRT=Y
 ;
 ;***> select print device
DEV S %ZIS="PQ" D ^%ZIS G END:POP,QUE:$D(IO("Q")) U IO G ^AQAQPR21
QUE K IO("Q") S ZTRTN="^AQAQPR21" S ZTDESC="PROCEDURES BY PROVIDER"
 F AQAQI="AQAQBDT","AQAQEDT","AQAQTYP","AQAQSRT" S ZTSAVE(AQAQI)=""
 D ^%ZTLOAD D ^%ZISC K ZTSK
 ;
END K Y,AQAQBDT,AQAQEDT,AQAQTYP,AQAQSRT,AQAQI,DIR D HOME^%ZIS Q
 ;
 ;
ERR ;EP;***> entry point to handle errors
 X ^%ZOSF("NBRK")
 ;if OS is DSM or MSM, don't kill variables if not an interrupt
 ;APPROVED EXCEPTION TO STANDARDS - USE OF $ZE
 I $D(^%ZOSF("OS")),(($P(^%ZOSF("OS"),U)["MSM")!($P(^("OS"),U)["DSM")) I $ZE?1"<INRPT>".E D ^%ZISC W *7,!!?30,"Interrupt Acknowledged",!! H 3 I 1
 E  D ^%ET
 D END^AQAQPR22 Q
