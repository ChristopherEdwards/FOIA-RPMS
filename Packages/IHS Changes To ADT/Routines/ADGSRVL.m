ADGSRVL ; IHS/ADC/PDW/ENM - PRINT PATIENTS BY SERVICE ; [ 03/25/1999  11:48 AM ]
 ;;5.0;ADMISSION/DISCHARGE/TRANSFER;;MAR 25, 1999
 ;
 W @IOF,!!!!?25,"Print Patient List by Treating Specialty",!!
 ;
 ;***> choose all services or just one
ALL K DIR S DIR(0)="YO",DIR("B")="NO"
 S DIR("A")="Print for ALL Treating Specialties?" D ^DIR
 G:$D(DIRUT) END I Y=1 S DGZSRT="A" G DEV
 ;
SRV K DIR S DIR(0)="PO^45.7:EMQZ",DIR("A")="Select Treating Specialty"
 D ^DIR G END:$D(DTOUT),ALL:$D(DUOUT),END:$D(DIROUT),SRV:Y=-1
 S DGZSRT=+Y
 ;
 ;***> get print device
DEV S %ZIS="PQ" D ^%ZIS G END:POP,QUE:$D(IO("Q")) U IO G START
QUE K IO("Q") S ZTRTN="START^ADGSRVL",ZTDESC="PRINT PATIENT LIST"
 S ZTSAVE("DGZSRT")="" D ^%ZTLOAD D ^%ZISC K ZTSK
END K Y,DGZSRT,DIR D HOME^%ZIS Q
 ;
 ;
START ;***> initialize variables
 S DGTY="INPATIENT LIST BY SERVICE"
 S (DGLIN,DGLIN2)="",$P(DGLIN,"=",80)="",$P(DGLIN2,"-",80)=""
 S DGDUZ=$P(^VA(200,DUZ,0),U,2),DGFAC=$P(^DIC(4,DUZ(2),0),U)
 S DGPAGE=0 D HEAD
 S DGSTOP="" S DGSV=$S(DGZSRT="A":0,1:DGZSRT) G FIND1:DGSV>0
 ;
 ;***> get services, then all patients in each service
FIND S DGSV=$O(^DPT("ATR",DGSV)) G END1:DGSV=""
FIND1 S DFN=0 W !,$P(^DIC(45.7,DGSV,0),U)  ;print service name
 I $Y>(IOSL-5) D NEWPG G END2:DGSTOP=U
FIND2 S DFN=$O(^DPT("ATR",DGSV,DFN)) W "." G PRINT:DFN=""
 G FIND2:'$D(^DPT(DFN,.103)),FIND2:'$D(^DPT(DFN,0))
 S DGCHT=$S($D(^AUPNPAT(DFN,41,DUZ(2),0)):$P(^(0),U,2),1:"??")  ;chart#
 S:+DGCHT DGX=6-$L(DGCHT) F DGI=1:1:DGX S DGCHT="0"_DGCHT
 S DGCHT=$E(DGCHT,1,2)_"-"_$E(DGCHT,3,4)_"-"_$E(DGCHT,5,6)
 S DGNM=$P(^DPT(DFN,0),U),DGA(DGNM,DFN)=DGCHT G FIND2  ;set DGA array
 ;
 ;***> print all patients for this srv, then get another or go to end
PRINT I '$D(DGA) W !!?10,"*** NO PATIENTS CURRENTLY ADMITTED TO THIS SERVICE ***",!! G END1
 S DGNM=0 D WRITE K DGA G END2:DGSTOP=U,FIND:DGZSRT="A",END1
 ;
 ;***> print patient info
WRITE S DGNM=$O(DGA(DGNM)) Q:DGNM=""  S DFN=0
W1 S DFN=$O(DGA(DGNM,DFN)) G WRITE:DFN="" S DGX=DGA(DGNM,DFN)
 W !?20,$E(DGNM,1,25),?50,DGX  ;patient name & chart #
 W ?60,$E($G(^DPT(DFN,.1)),1,3)  ;ward
 W ?70,$G(^DPT(DFN,.101))  ;room-bed
 I $Y>(IOSL-5) D NEWPG Q:DGSTOP=U
 G W1
 ;
 ;
END1 ;***> eoj
 I IOST["C-" D PRTOPT^ADGVAR
END2 D ^%ZISC I $D(ZTQUEUED) Q
 K DFN,DGSTOP,DGNM,DGA,DGSV,DGPAGE,DGTIME,DGCITY,DGTY,DGX,DGCHT,DGZSRT
 K DGDUZ,DGFAC,DGLIN,DGLIN2,DIR
 Q
 ;
NEWPG ;***> subrtn for end of page control
 I IOST'?1"C-".E D HEAD S DGSTOP="" Q
 K DIR S DIR(0)="E" D ^DIR S DGSTOP=X
 I DGSTOP'=U D HEAD
 Q
 ;
HEAD ;***> subrtn to print heading
 I (IOST["C-")!(DGPAGE>0) W @IOF
 S DGPAGE=DGPAGE+1
 W ?11,"*****Confidential Patient Data Covered by Privacy Act*****"
 W !?80-$L(DGFAC)/2,DGFAC,!,DGDUZ
 W ?80-$L(DGTY)/2,DGTY,?70,"Page: ",DGPAGE,! D ^%T
 S Y=DT X ^DD("DD") W ?80-$L(Y)/2,Y,!,DGLIN
 W !,"Service",?20,"Patient",?50,"Chart #"
 W ?60,"Ward",?70,"Room-Bed",!,DGLIN2,!
 Q
