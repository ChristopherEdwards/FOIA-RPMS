ADGFTRP ; IHS/ADC/PDW/ENM - TRANSFERS BETWEEN FACILITIES(PRINT) ; [ 03/25/1999  11:48 AM ]
 ;;5.0;ADMISSION/DISCHARGE/TRANSFER;;MAR 25, 1999
 ;
 ;***> initialize variables
 S DGPAGE=0,DGSTOP="",DGDUZ=$P(^VA(200,DUZ,0),U,2)
 S DGFAC=$P(^DIC(4,DUZ(2),0),U)    ;set site
 S DGLINE="",$P(DGLINE,"=",80)=""
 S DGLINE2="",$P(DGLINE2,"-",80)=""
 S (DGTI,DGTO)=0  ;zero out totals
 ;
 ;***> if listing only
 G ^ADGFTRP1:DGTYP=1
 ;
STAT ;***> print stats by facility
 D HEAD S DGF=0   ;print heading
STAT1 S DGF=$O(DGCT(DGF)) G TOTAL:DGF="" S DGSV=0
 W !,$E(DGF,1,24)       ;print facility
STAT2 S DGSV=$O(DGCT(DGF,DGSV)) G STAT1:DGSV=""
 W ?26,DGSV       ;print service
 ;***> print transfer counts and increment totals
 W ?55,$P(DGCT(DGF,DGSV),U) S DGTI=DGTI+$P(DGCT(DGF,DGSV),U)
 W ?70,$P(DGCT(DGF,DGSV),U,2) S DGTO=DGTO+$P(DGCT(DGF,DGSV),U,2)
 W ! I $Y>(IOSL-6) D NEWPG G END:DGSTOP=U
 G STAT2
 ;
TOTAL ;***> print transfer totals
 W !,DGLINE,!?30,"TOTALS:",?55,DGTI,?70,DGTO,!
 G ^ADGFTRP1:DGTYP=3
 ;
END G END^ADGFTRP1
 ;
NEWPG ;***> subrtn for end of page control
 I IOST'?1"C-".E D HEAD S DGSTOP="" Q
 K DIR S DIR(0)="E" D ^DIR S DGSTOP=X
 I DGSTOP'=U D HEAD
 Q
 ;
HEAD ;***> subrtn to print heading
 I (IOST["C-")!(DGPAGE>0) W @IOF
 W !,DGLINE S DGPAGE=DGPAGE+1
 W !?11,"*****Confidential Patient Data Covered by Privacy Act*****"
 W !,DGDUZ,?80-$L(DGFAC)/2,DGFAC S DGTY="INTER-FACILITY TRANSFERS"
 W ! D TIME^ADGUTIL W ?80-$L(DGTY)/2,DGTY,?70,"Page: ",DGPAGE
 S Y=DT X ^DD("DD") W !,Y
 S DGX="STATISTICS" W ?80-$L(DGX)/2,DGX
 W !,DGLINE,!,"Facility Name",?26,"Admit/Dsch Service"
 W ?50,"Transfers In",?65,"Transfers Out"
 W !,DGLINE2,!
 Q
