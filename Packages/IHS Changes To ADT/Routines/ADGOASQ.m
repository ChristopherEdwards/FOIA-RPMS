ADGOASQ ; IHS/ADC/PDW/ENM - QUEUE OUTSTANDING A SHEET LIST ; [ 03/25/1999  11:48 AM ]
 ;;5.0;ADMISSION/DISCHARGE/TRANSFER;;MAR 25, 1999
 ;
 W @IOF,!!!?30,"A SHEET STATUS REPORT",!!
 ;
 ;***> choose which months to print
DATE S %DT="AEQ",%DT("A")="Start report with which month: ",X="" D ^%DT
 G END:Y=-1 S DGMON=Y
DATE2 S %DT("A")="End report through which month: ",X="" D ^%DT
 G DATE:Y=-1 S DGMON2=Y
 I DGMON2<DGMON W *7,!!?5,"Ending date MUST NOT be before beginning date",! G DATE
 I DGMON2'<DT S X1=DT,X2=-1 D C^%DTC S DGMON2=X
 ;
 W !!?10,"Print Report on the Status of A Sheets"
 S DGM=$P($T(MON),";;",2)
 S DGRANGE=$P(DGM," ",+$E(DGMON,4,5))_" "_$E(DGMON,2,3)_" through "_$P(DGM," ",+$E(DGMON2,4,5))_" "_$E(DGMON2,2,3)
 W !?10,"for Discharges from ",DGRANGE,!!
 ;
 K DIR S DIR("A")="Is This Correct",DIR("B")="YES",DIR(0)="Y"
 D ^DIR G END:$D(DIRUT) G DATE2:Y=0
 ;
 ;***> get print device
DEV S %ZIS="PQ" D ^%ZIS G END:POP,QUE:$D(IO("Q")) U IO G ^ADGOASC
QUE K IO("Q") S ZTRTN="^ADGOASC",ZTDESC="OUTSTANDING A SHEETS"
 F DGI="DGMON","DGMON2","DGRANGE" S ZTSAVE(DGI)=""
 D ^%ZTLOAD D ^%ZISC K ZTSK
 ;
END K Y,DGMON,DGMON2,DGRANGE,DGM,DIR D HOME^%ZIS Q
 ;
MON ;;JAN FEB MAR APR MAY JUN JUL AUG SEP OCT NOV DEC
