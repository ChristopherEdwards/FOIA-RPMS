ADGOASP ; IHS/ADC/PDW/ENM - PRINT OUTSTANDING A SHEETS LIST ; [ 03/25/1999  11:48 AM ]
 ;;5.0;ADMISSION/DISCHARGE/TRANSFER;;MAR 25, 1999
 ;
 ;***> initialize variables
 S DGPAGE=0,DGSTOP="",DGSUB="CT"
 S DGFAC=$P(^DIC(4,DUZ(2),0),U),DGDUZ=$P(^VA(200,DUZ,0),U,2)
 S (DGLIN,DGLIN1)="",$P(DGLIN,"-",80)="",$P(DGLIN1,"=",80)=""
 D HEAD
 S (DGCT,DGCCT,DGCOT,DGERR,DGCTT,DGCCTT,DGCOTT,DGERRT,DGCTEX)=0
 I '$D(^TMP("DGZOAS",$J,"CT")) W !!?30,"NO DISCHARGES RECORDED",!! G END
 ;
 ;***> loop thru ^utility by discharge date and print counts
 S DGDT=0
A1 S DGDT=$O(^TMP("DGZOAS",$J,"CT",DGDT)) G TOTALS:DGDT=""
 W !,$P($T(MON),";;",+$E(DGDT,4,5)+1)_" "_($E(DGDT,1,3)+1700)
 W ?16,$J(^TMP("DGZOAS",$J,"CT",DGDT),4) S DGCTT=DGCTT+^(DGDT)
 I $D(^TMP("DGZOAS",$J,"CT1",DGDT)) W ?29,$J(^(DGDT),4) S DGCCTT=DGCCTT+^(DGDT)  ;coded count
 I $D(^TMP("DGZOAS",$J,"CT2",DGDT)) W ?42,$J(^(DGDT),4) S DGCOTT=DGCOTT+^(DGDT)  ;uncoded count
 I $D(^TMP("DGZOAS",$J,"CT4",DGDT)) W ?55,$J(^(DGDT),4) S DGCTEX=DGCTEX+^(DGDT)  ;exported count
 I $D(^TMP("DGZOAS",$J,"CT3",DGDT)) W ?68,$J(^(DGDT),4) S DGERRT=DGERRT+^(DGDT)  ;error count
 I $Y>(IOSL-5) D NEWPG G END1:DGSTOP=U
 G A1
 ;
TOTALS ;***> print totals
 G LIST:$E(DGMON,4,5)=$E(DGMON2,4,5)  ;no totals for one month
 W !,DGLIN
 W !?16,$J(DGCTT,4),?29,$J(DGCCTT,4),?42,$J(DGCOTT,4)
 W ?55,$J(DGCTEX,4),?68,$J(DGERRT,4)
 W !,DGLIN1,!
 ;
LIST ;***> list outstanding A Sheets
 G ERR:'$D(^TMP("DGZOAS",$J,"ZOUT"))
 S DGSUB="LST",DGDT=0 I $Y>(IOSL-6) D NEWPG G END1:DGSTOP=U G L1
 W !!?20,"*** UNCODED CLINICAL RECORD BRIEFS ***",! D HEAD1
L1 S DGDT=$O(^TMP("DGZOAS",$J,"ZOUT",DGDT)) G ERR:DGDT="" S DFN=0
L2 S DFN=$O(^TMP("DGZOAS",$J,"ZOUT",DGDT,DFN)) G L1:DFN=""
 ;
 S DGSRV=^TMP("DGZOAS",$J,"ZOUT",DGDT,DFN)
 S DGCHT=$P(^AUPNPAT(DFN,41,DUZ(2),0),U,2)
 W !,$E(DGDT,4,5)_"/"_$E(DGDT,6,7)_"/"_$E(DGDT,2,3)
 W ?12,$E($P(^DPT(DFN,0),U),1,20)
 W ?35,$J(DGCHT,6),?48,$E($P(^DIC(45.7,DGSRV,0),U),1,3)
 W ?57,$$INS^ADGMREC(DFN)
 I $Y>(IOSL-5) D NEWPG G END1:DGSTOP=U
 G L2
 ;
ERR ;***> list any errors found
 G END:'$D(^TMP("DGZOAS",$J,"ZERR"))
 S DGDT=0,DGSUB="ERR"
 W !!?33,"*** ERRORS ***",! D HEAD1
ERR1 S DGDT=$O(^TMP("DGZOAS",$J,"ZERR",DGDT)) G END:DGDT="" S DFN=0
ERR2 S DFN=$O(^TMP("DGZOAS",$J,"ZERR",DGDT,DFN)) G ERR1:DFN=""
 W !,$E(DGDT,4,5)_"/"_$E(DGDT,6,7)_"/"_$E(DGDT,2,3)
 W ?20,$E($P(^DPT(DFN,0),U),1,20)
 W ?45,$J($P(^AUPNPAT(DFN,41,DUZ(2),0),U,2),6)
 I $Y>(IOSL-5) D NEWPG G END1:DGSTOP=U
 G ERR2
 ;
 ;
END ;***> eoj
 I IOST?1"C-".E D PRTOPT^ADGVAR
END1 W @IOF D ^%ZISC D KILL^ADGUTIL
 K ^TMP("DGZOAS",$J) Q
 ;
 ;
MON ;;JAN;;FEB;;MAR;;APR;;MAY;;JUN;;JUL;;AUG;;SEP;;OCT;;NOV;;DEC
 ;
NEWPG ;***> subrtn for end of page control
 I IOST'?1"C-".E D HEAD S DGSTOP="" Q
 K DIR S DIR(0)="E" D ^DIR S DGSTOP=X
 I DGSTOP'=U D HEAD
 Q
 ;
HEAD ;***> subrtn to print heading
 I (IOST["C-")!(DGPAGE>0) W @IOF
 W !,DGLIN1 S DGPAGE=DGPAGE+1
 W !?11,"*****Confidential Patient Data Covered by Privacy Act*****"
 W !,DGDUZ,?80-$L(DGFAC)/2,DGFAC
 S DGTY="CLINICAL RECORD BRIEF STATUS REPORT"
 W ! D TIME^ADGUTIL W ?80-$L(DGTY)/2,DGTY,?70,"Page: ",DGPAGE
 S Y=DT X ^DD("DD") W !,Y
 W ?80-$L(DGRANGE)/2,DGRANGE
 W !,DGLIN1
HEAD1 W:DGSUB="CT" !,"Month/Year",?15,"# Disch",?28,"# Coded",?38,"# Not-Coded",?52,"# Exported",?66,"# Errors"
 W:DGSUB="LST" !,"Discharge",?45,"Discharge",?57,"Insurance",!?2,"Date",?17,"Patient",?35,"Chart #",?46,"Service",?59,"Type"
 W:DGSUB="ERR" !,"Discharge",?20,"Patient",?45,"Chart #",?57,"Insurance",!?2,"Date",?59,"Type"
 W !,DGLIN,!
 Q
