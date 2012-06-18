ADGIP1 ; IHS/ADC/PDW/ENM - PRINT INPATIENT LIST ; [ 03/25/1999  11:48 AM ]
 ;;5.0;ADMISSION/DISCHARGE/TRANSFER;;MAR 25, 1999
 ;
 ;***> print heading
 U IO S (DGZRM,X)=110 X ^%ZOSF("RM")  ;set margin to 110
 S DGSTOP="" I IOST["C-" W @IOF
 W ?26,"*****Confidential Patient Data Covered by Privacy Act*****",!
 S %DT="R",X="NOW" D ^%DT X ^DD("DD")
 S DGDATE=$P(Y,"@",1)_"  "_$P(Y,"@",2)
 S DGTL=$P($G(^AUTTLOC(DUZ(2),0)),U,7)_" INPATIENT LIST FOR "_DGDATE
 W ?DGZRM-$L(DGTL)/2,DGTL,"  ("_DGCNT_" patients in house)",!!
 W ?2,"NAME",?31,"AGE",?37,"WARD SRVC",?47,"COMMUNITY",?61,"HRCN"
 W ?71,"ADMDATE",?82,"MEDICAID",?97,"MEDICARE",!
 ;
 ;***> loop thru ^utility by name
 G END:'$D(^TMP("DGZINP",$J)) S DGNM=0
A1 S DGNM=$O(^TMP("DGZINP",$J,DGNM)) G END:DGNM="" S DFN=0
A2 S DFN=$O(^TMP("DGZINP",$J,DGNM,DFN)) G A1:DFN=""
 ;
 ;***> get data and print it
 S DGSTR=^TMP("DGZINP",$J,DGNM,DFN)
 S DGX=$P(DGSTR,U),DGDT=$E(DGX,4,5)_"/"_$E(DGX,6,7)_"/"_$E(DGX,2,3)
 S DGX=$P(DGSTR,U,4) I DGX'="" S DGSV=$P($G(^DIC(45.7,DGX,0)),U)
 S DGHRCN=$P(DGSTR,U,6)
 W !?2,$E(DGNM,1,26),?30,$P(DGSTR,U,2),?37,$P(DGSTR,U,3)
 W ?42,$E(DGSV,1,3),?47,$E($P(DGSTR,U,5),1,12),?61,DGHRCN
 W ?71,DGDT,?82,$P(DGSTR,U,8),?97,$P(DGSTR,U,7)
 I $Y>(IOSL-7) D NEWPG G END1:DGSTOP=U
 G A2
 ;
 ;
END ;***> eoj
 I IOST["C-" D PRTOPT^ADGVAR
END1 W @IOF D KILL^ADGUTIL K ^TMP("DGZINP",$J)
 S X=IOM X ^%ZOSF("RM")  ;restore right margin
 D ^%ZISC Q
 ;
NEWPG ;***> subrtn for end of page control
 I IOST["C-" K DIR S DIR(0)="E" D ^DIR S DGSTOP=X Q:X=U
 W @IOF Q
