AQAQPR1 ;IHS/ANMC/LJF - ADMITS BY PROVIDER(ADT DATA); [ 09/28/92  1:08 PM ]
 ;;2.2;STAFF CREDENTIALS;;01 OCT 1992
 ;
 W @IOF,!!?25,"ADMISSIONS BY PROVIDER",!!
 W !,"This report gives you a listing (with subcounts) of admissions "
 W !,"grouped by admitting provider for the date range specified."
 W !,"ICU admissions will be listed and counted separately.  This"
 W !,"data is entered by the ADT package.  You must be running ADT to"
 W !,"run this report.",!!
 ;
 ;***> select date range
DATE S %DT="AEQ",%DT("A")="Beginning date: ",X="" D ^%DT
 G END:Y=-1 S AQAQBDT=Y
DATE2 S %DT="AEQ",%DT("A")="Ending date: ",X="" D ^%DT
 G DATE:Y=-1 S AQAQEDT=Y
 I AQAQEDT<AQAQBDT W *7,!!?5,"Ending date MUST NOT be before beginning date",! G DATE2
 I AQAQEDT'<DT S X1=DT,X2=-1 D C^%DTC S AQAQEDT=X
 ;
 ;***> select one provider, one class or all
PRV K DIR S DIR(0)="N^1:3",DIR("A")="Choose One"
 S DIR("A",1)="1.  Print admissions for ONE PROVIDER"
 S DIR("A",2)="2.  Print admissions for ONE PROVIDER CLASS"
 S DIR("A",3)="3.  Print admissions for ALL PROVIDERS"
 D ^DIR G DATE2:X="",END:$D(DIRUT) S AQAQTYP=+Y
 I AQAQTYP=3 S AQAQPROV=0 G DEV  ;all providers
 S DIC=$S(AQAQTYP=1:6,1:7),DIC(0)="AEQMZ" D ^DIC G PRV:Y<0 S AQAQPROV=Y
 ;
 ;***> select print device
DEV S %ZIS="PQ" D ^%ZIS G END:POP,QUE:$D(IO("Q")) U IO G ^AQAQPR11
QUE K IO("Q") S ZTRTN="^AQAQPR11" S ZTDESC="ADMISSIONS BY PROVIDER"
 F AQAQI="AQAQBDT","AQAQEDT","AQAQTYP","AQAQPROV" S ZTSAVE(AQAQI)=""
 D ^%ZTLOAD D ^%ZISC K ZTSK
 ;
END K Y,AQAQBDT,AQAQEDT,AQAQI,AQAQTYP,AQAQPROV D HOME^%ZIS Q
 ;
 ;
ERR ;EP;***> entry point if error occurs
 X ^%ZOSF("NBRK")
 ;if OS is DSM or MSM, don't kill variables if not an interrupt
 ;APPROVED EXCEPTION TO STANDARDS - USE OF $ZE
 I $D(^%ZOSF("OS")),(($P(^%ZOSF("OS"),U)["MSM")!($P(^("OS"),U)["DSM")) I $ZE?1"<INRPT>".E D ^%ZISC W *7,!!?30,"Interrupt Acknowledged",!! H 3 I 1
 E  D ^%ET
 D END^AQAQPR12 Q
