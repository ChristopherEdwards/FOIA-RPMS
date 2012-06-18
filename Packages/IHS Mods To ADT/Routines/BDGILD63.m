BDGILD63 ; IHS/ANMC/LJF - TRANSFERS BETWEEN FACILITIES(PRINT) ; 
 ;;5.3;PIMS;;APR 26, 2002
 ;
 S DGSTOP=""
 ;***> print admissions by date, service, then facility
 S DGDT=0 D NEWPG:BDGTYP=3,HEAD:BDGTYP=1 W !?30,"ADMISSIONS",!
ADM1 S DGDT=$O(^TMP("BDGILD61A",$J,DGDT)) G DSCH:DGDT="" S DGSV=0
ADM2 S DGSV=$O(^TMP("BDGILD61A",$J,DGDT,DGSV)) G ADM1:DGSV="" S DGF=0
ADM3 S DGF=$O(^TMP("BDGILD61A",$J,DGDT,DGSV,DGF)) G ADM2:DGF="" S DFN=0
ADM4 S DFN=$O(^TMP("BDGILD61A",$J,DGDT,DGSV,DGF,DFN)) G ADM3:DFN=""
 D LINE G END1:DGSTOP=U,ADM4
 ;
 ;
DSCH ;***> print discharges by date, service, then facility
 S DGDT=0 D NEWPG:$Y>(IOSL-6) W !!?30,"DISCHARGES",!
DSCH1 S DGDT=$O(^TMP("BDGILD61D",$J,DGDT)) G END:DGDT="" S DGSV=0
DSCH2 S DGSV=$O(^TMP("BDGILD61D",$J,DGDT,DGSV)) G DSCH1:DGSV="" S DGF=0
DSCH3 S DGF=$O(^TMP("BDGILD61D",$J,DGDT,DGSV,DGF)) G DSCH2:DGF="" S DFN=0
DSCH4 S DFN=$O(^TMP("BDGILD61D",$J,DGDT,DGSV,DGF,DFN)) G DSCH3:DFN=""
 D LINE G END1:DGSTOP=U,DSCH4
 ;
 ;
END ;EP; ***> eoj
 I IOST["C-" K DIR S DIR(0)="E" D ^DIR
END1 ;EP;
 W @IOF D KILL^ADGUTIL
 D ^%ZISC K ^TMP("BDGILD61A") K ^TMP("BDGILD61D") Q
 ;
LINE ;***> subrtn to print line
 S DGTM=$E(DGDT,9,12),DGTM=$E(DGTM_"0000",1,4)  ;time in readable form
 W !,$E(DGDT,4,5)_"/"_$E(DGDT,6,7)_"/"_$E(DGDT,2,3)_"@"_DGTM  ;date
 W ?17,$E($P(^DPT(DFN,0),U),1,20)   ;patient
 S DGHR=$P(^AUPNPAT(DFN,41,DUZ(2),0),U,2) W ?40,$J(DGHR,6)  ;chart #
 W ?52,$E(DGSV,1,3),?60,$E(DGF,1,18)  ;service & facility
 I $Y>(IOSL-6) D NEWPG  ;end of page check
 Q
 ;
NEWPG ;***> subrtn for end of page code
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
 S DGX="PATIENT LISTING" W ?80-$L(DGX)/2,DGX
 W !,DGLINE,!,"Date/Time",?17,"Patient Name",?40,"Chart #"
 W ?50,"Service",?60,"Facility",!,DGLINE2,!
 Q
