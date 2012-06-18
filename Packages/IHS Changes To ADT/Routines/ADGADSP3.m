ADGADSP3 ; IHS/ADC/PDW/ENM - A & D SHEET PRINT (SUMMARY) ; [ 03/25/1999  11:48 AM ]
 ;;5.0;ADMISSION/DISCHARGE/TRANSFER;;MAR 25, 1999
 ;
 ;***> Summary version of ADMISSIONS & DISCHARGES SHEET
 ;
 ;***> initialize variables
 S X1=DGDATE,X2=-1 D C^%DTC S DGOLD=X  ;get prev date
 S DGZ=0 F I=1:1:7 S DGCT(I)=0  ;initialize counts
 S DGPAGE=0,DGSTOP="" D HEAD
 S DGLIN="",$P(DGLIN,"-",37)=""
 ;
 ;***> loop thru adt census-treating specialty file for census figures
A1 S DGZ=$O(^ADGTX(DGZ)) G A3:DGZ'?1N.N G:'$$AS A1
 W !,$P(^DIC(45.7,DGZ,0),U) ;print service name
 I '$D(^ADGTX(DGZ,1,DGOLD,0))!'$D(^(1)) G A1 ;skip if no data for prev
 S DGX=$P(^ADGTX(DGZ,1,DGOLD,0),U,2)+$P(^(1),U)
 S DGCT(1)=DGCT(1)+DGX W ?20,DGX ;old count
 I '$D(^ADGTX(DGZ,1,DGDATE,0))!'$D(^(1)) G A1 ;skip if no data for date
 S DGSTR=^ADGTX(DGZ,1,DGDATE,0),DGPSTR=^(1)  ;set adult & peds var
 S DGX=($P(DGSTR,U,3)+$P(DGPSTR,U,2)),DGCT(2)=DGCT(2)+DGX W ?30,DGX
 S DGX=($P(DGSTR,U,5)+$P(DGPSTR,U,4)),DGCT(3)=DGCT(3)+DGX W ?38,DGX
 S DGX=($P(DGSTR,U,7)+$P(DGPSTR,U,6)),DGCT(4)=DGCT(4)+DGX W ?47,DGX
 S DGX=($P(DGSTR,U,4)+$P(DGPSTR,U,3)),DGCT(5)=DGCT(5)+DGX W ?54,DGX
 S DGX=($P(DGSTR,U,6)+$P(DGPSTR,U,5)),DGCT(6)=DGCT(6)+DGX W ?61,DGX
 S DGX=($P(DGSTR,U,2)+$P(DGPSTR,U)),DGCT(7)=DGCT(7)+DGX W ?71,DGX
 I $Y>(IOSL-5) D NEWPG G END1:DGSTOP=U
 G A1
 ;
 ;***> print census totals
A3 W !?17,"----------------------------------------------------------"
 W !?5,"TOTALS:",?18,$J(DGCT(1),3),?28,$J(DGCT(2),3),?36,$J(DGCT(3),3)
 W ?45,$J(DGCT(4),3),?51,$J(DGCT(5),3),?59,$J(DGCT(6),3)
 W ?69,$J(DGCT(7),3)
 ;
NEXT G ^ADGADSP4  ;prints individual patient data
 ;
END I IOST["C-" K DIR S DIR("A")="Press RETURN to continue",DIR(0)="E" D ^DIR
END1 ;EP;***> ending point for summary A&D Sheets
 W @IOF D KILL^ADGUTIL
 D ^%ZISC K ^TMP("DGZADS",$J)
 Q
 ;
 ;
NEWPG ;EP;***> end of page control
 I IOST["C-" K DIR S DIR(0)="E" D ^DIR S DGSTOP=X Q:X=U
 W @IOF
 W !?11,"*****Confidential Patient Data Covered by Privacy Act*****",!
 Q
 ;
HEAD ;***> print heading
 S DGY=^AUTTLOC(DUZ(2),0),DGFAC=$P(^DIC(4,DUZ(2),0),U)
 I (IOST["C-")!(DGPAGE>0) W @IOF
 W ?11,"*****Confidential Patient Data Covered by Privacy Act*****"
 W !?(80-$L(DGFAC)/2),DGFAC  ;facility name
 S DGCITY=$P(DGY,U,13),DGSTAT=$P(DGY,U,14),DGSTAT=$P(^DIC(5,DGSTAT,0),U)
 W !?(80-$L(DGCITY_DGSTAT)/2),DGCITY_","_DGSTAT  ;city and state
 W !!!,"DAILY CENSUS REPORT"
 S X=DGDATE D DW^%DTC W !,X  ;print day of the week
 W ?10,$E(DGDATE,4,5)_"-"_$E(DGDATE,6,7)_"-"_$E(DGDATE,2,3),! ;date
 S DGLIN="",$P(DGLIN,"-",80)="" W DGLIN
 W !!!,"SERVICE",?17,"REMAINING",?28,"ADMITS",?35,"TRANSFERS"
 W ?45,"DEATHS",?52,"OTHER",?58,"TRANSFERS",?68,"REMAINING"
 W !,"Responsible",?17,"from the",?38,"IN",?53,"DIS-",?61,"OUT",?72,"At"
 W !,"for Patient",?17,"Preceding",?51,"CHARGES",?69,"11:59 pm"
 W !?20,"Day",!!
 W DGLIN,!! Q
 ;
AS() ;--admitting service (yes=1,no=0)
 Q $S($P($G(^DIC(45.7,+DGZ,9999999)),U,3)="Y":1,1:0)
