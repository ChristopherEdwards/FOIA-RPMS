ADGICUT ; IHS/ADC/PDW/ENM - PRINT TRANSFERS TO ICU ; [ 03/25/1999  11:48 AM ]
 ;;5.0;ADMISSION/DISCHARGE/TRANSFER;;MAR 25, 1999
 ;
 W @IOF,!!?20,"TRANSFERS TO ICU REPORT",!!
 ;***> get date range
BDATE S %DT="AEQ",%DT("A")="Select beginning date: ",X="" D ^%DT
 G END:Y=-1 S DGBDT=Y
EDATE S %DT="AEQ",%DT("A")="Select ending date: ",X="" D ^%DT
 G END:Y=-1 S DGEDT=Y
 ;
 ;***> get print device
 S %ZIS="PQ" D ^%ZIS G END:POP,QUE:$D(IO("Q")) U IO G INIT
QUE K IO("Q") S ZTRTN="INIT^ADGICUT",ZTDESC="INPATIENT STATS"
 S ZTSAVE("DGBDT")="",ZTSAVE("DGEDT")=""
 D ^%ZTLOAD D ^%ZISC K ZTSK
END K Y,DGBDT,DGEDT D HOME^%ZIS Q
 ;
INIT ;***> initialize variables
 S DGDUZ=$P(^VA(200,DUZ,0),U,2),DGFAC=$P(^DIC(4,DUZ(2),0),U),DGPAGE=0
 S DGLINE="",$P(DGLINE,"=",81)="",DGLIN1="",$P(DGLIN1,"-",81)=""
 S DGSTOP=""
 ;
 ;***> find ICU wards for facility
 S DGX=0 K DGICU
ICU S DGX=$O(^DIC(42,DGX)) G DATES:DGX'=+DGX
 I $D(^DIC(42,DGX,"I")),^("I")="I" G ICU  ;check for inactive wards
 ;G ICU:$P(^DIC(42,DGX,"IHS"),U)=""  ;not an ICU ward;IHS/ORDC/LJF 3/3/93 changed code for new field definition
 ;G ICU:$P(^DIC(42,DGX,"IHS"),U)'="I"  ;not an ICU ward;IHS/ORDC/LJF 3/9/93 not using PCU at this time
 G ICU:$P(^DIC(42,DGX,"IHS"),U)'="Y"  ;not an ICU ward;IHS/ORDC/LJF 3/9/93 not using PCU at this time;IHS/ORDC/LJF 4/7/94 changed again 'causefield def overwritten
 S DGICU(DGX)="" G ICU  ;set ICU dfn into array
 ;
DATES D HDR G NOICU:'$D(DGICU)  ;no ICU at your facility
 ;***> loop thru transfer dates
 S DGDT=DGBDT-.0001
 F  S DGDT=$O(^DGPM("AMV2",DGDT)) Q:DGDT=""!(DGDT>(DGEDT_.2400))  D
 . S DFN=0 Q:DGSTOP=U
 . F  S DFN=$O(^DGPM("AMV2",DGDT,DFN)) Q:'DFN!(DGSTOP=U)  D
 .. S DGTR=0
 .. F  S DGTR=$O(^DGPM("AMV2",DGDT,DFN,DGTR)) Q:'DGTR!(DGSTOP=U)  D 2
END1 ;***> eoj
 I IOST?1"C-".E D PRTOPT^ADGVAR
 W @IOF D KILL^ADGUTIL D ^%ZISC Q
 Q
 ;
2 Q:'$D(^DGPM(DGTR,0))  S DGX=^(0)  ;set transfer
 Q:$P(DGX,U,6)=""  ;not an interward transfer
 Q:'$D(DGICU($P(DGX,U,6)))  ;was transfer to an ICU?
 S DGADM=$P(^DGPM(DGTR,0),U,14) Q:'DGADM
 ;
 ;***> print transfers
 W !!,$E($P(^DPT(DFN,0),U),1,18)   ;print patient name
 W ?20,$J($P(^AUPNPAT(DFN,41,DUZ(2),0),U,2),6)  ;print chart #
 S DGY=^DGPM(DGADM,0)  ;set admission node variable
 S DGAD=$P($P(DGY,U),"."),DGTM=$P($P(DGY,U),".",2)_"000"  ;adm dat/tim
 W ?30,$E(DGAD,4,5)_"/"_$E(DGAD,6,7)_"/"_$E(DGAD,2,3)_"@"_$E(DGTM,1,4)
 S DGTD=$P(DGDT,"."),DGTM=$P(DGDT,".",2)_"000"  ;trans date/time
 W ?45,$E(DGTD,4,5)_"/"_$E(DGTD,6,7)_"/"_$E(DGTD,2,3)_"@"_$E(DGTM,1,4)
 W ?61,$E($P(DGY,U,10),1,15)  ;admiting dx
 I $Y>(IOSL-6) D NEWPG
 Q
 ;
NOICU ;***> subrtn called if facility doesn't have an ICU
 W !!,"***** THERE IS NO ICU WARD SET UP ON YOUR SYSTEM ****",!!!
 G END1
 ;
NEWPG ;***> subrtn for end of page control
 I IOST'?1"C-".E D HDR S DGSTOP="" Q
 K DIR S DIR(0)="E" D ^DIR S DGSTOP=X I DGSTOP'=U D HDR Q
 ;
HDR ;***> subrtn to print heading
 W:IOST?1"C-".E @IOF I IOST?1"P-".E W:DGPAGE @IOF
 W !,DGLINE S DGPAGE=DGPAGE+1
 W !?11,"*****Confidential Patient Data Covered by Privacy Act*****"
 W !,DGDUZ,?80-$L(DGFAC)/2,DGFAC S DGTY="TRANSFERS TO ICU"
 W ! D TIME^ADGUTIL W ?80-$L(DGTY)/2,DGTY,?70,"Page: ",DGPAGE
 S Y=DT X ^DD("DD") W !,Y,!,DGLINE
 W !,"Patient",?21,"Chart #",?32,"Admit Date",?45,"Transfer Date"
 W ?60,"Admitting Diagnosis",!,DGLIN1,!
 Q
