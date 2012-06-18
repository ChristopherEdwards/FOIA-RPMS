ADGLDCP ; IHS/ADC/PDW/ENM - DISCHARGES LISTING (PRINT) ; [ 03/25/1999  11:48 AM ]
 ;;5.0;ADMISSION/DISCHARGE/TRANSFER;;MAR 25, 1999
 ;
 ;***> initialize variables
 S DGPAGE=0,DGSTOP="",DGDUZ=$P(^VA(200,DUZ,0),U,2)
 S DGFAC=$P(^DIC(4,DUZ(2),0),U)    ;set site
 S DGRANGE=$E(DGBDT,4,5)_"/"_$E(DGBDT,6,7)_"/"_$E(DGBDT,2,3)_" to "
 S DGRANGE=DGRANGE_$E(DGEDT,4,5)_"/"_$E(DGEDT,6,7)_"/"_$E(DGEDT,2,3)
 S DGLINE="",$P(DGLINE,"=",80)=""
 S DGLINE2="",$P(DGLINE2,"-",80)=""
 ;
 G DATE:DGTYP=1,WARD:DGTYP=2,SERV:DGTYP=3  ;what sort order?
 ;
DATE ;***> discharge date order
 S DGDT=0
DT1 S DGDT=$O(^TMP("DGZLDC",$J,DGDT)) G END:DGDT="" S DGTM=0
 D NEWPG G END1:DGSTOP=U
DT2 S DGTM=$O(^TMP("DGZLDC",$J,DGDT,DGTM)) G DT1:DGTM="" S DFN=0
DT3 S DFN=$O(^TMP("DGZLDC",$J,DGDT,DGTM,DFN)) G DT2:DFN=""
 S DGS=^TMP("DGZLDC",$J,DGDT,DGTM,DFN)
 S DGW=$P(DGS,U),DGSV=$P(DGS,U,2),DGDX=$P(DGS,U,3)
 S DGNM=$P(^DPT(DFN,0),U),DGTIM=$E($P(DGTM,".",2)_"000",1,4)
 D LINE G END1:DGSTOP=U G DT3
 ;
WARD ;***> in order by ward
 S DGW=0
WD1 S DGW=$O(^TMP("DGZLDC",$J,DGW)) G END:DGW="" S DGDT=0
 I DGPAGE=0!(DGBDT'=DGEDT) D NEWPG G END1:DGSTOP=U
 I DGPAGE>0,DGBDT=DGEDT W !!?35,"** ",$E(DGW,1,3)," **"
WD2 S DGDT=$O(^TMP("DGZLDC",$J,DGW,DGDT)) G WD1:DGDT="" S DGNM=0
WD3 S DGNM=$O(^TMP("DGZLDC",$J,DGW,DGDT,DGNM)) G WD2:DGNM="" S DFN=0
WD4 S DFN=$O(^TMP("DGZLDC",$J,DGW,DGDT,DGNM,DFN)) G WD3:DFN=""
 S DGS=^TMP("DGZLDC",$J,DGW,DGDT,DGNM,DFN)
 S DGSV=$P(DGS,U),DGDX=$P(DGS,U,2)
 D LINE G END1:DGSTOP=U G WD4
 ;
SERV ;***> admit service order
 S DGSV=0
SV1 S DGSV=$O(^TMP("DGZLDC",$J,DGSV)) G END:DGSV="" S DGDT=0
 I DGPAGE=0!(DGBDT'=DGEDT) D NEWPG G END1:DGSTOP=U
 I DGPAGE>0,DGBDT=DGEDT W !!?35,"** ",$E(DGSV,1,3)," **"
SV2 S DGDT=$O(^TMP("DGZLDC",$J,DGSV,DGDT)) G SV1:DGDT="" S DGNM=0
SV3 S DGNM=$O(^TMP("DGZLDC",$J,DGSV,DGDT,DGNM)) G SV2:DGNM="" S DFN=0
SV4 S DFN=$O(^TMP("DGZLDC",$J,DGSV,DGDT,DGNM,DFN)) G SV3:DFN=""
 S DGS=^TMP("DGZLDC",$J,DGSV,DGDT,DGNM,DFN)
 S DGW=$P(DGS,U),DGDX=$P(DGS,U,2)
 D LINE G END1:DGSTOP=U G SV4
 ;
 ;
END ;***> eoj
 I IOST["C-" K DIR S DIR(0)="E" D ^DIR
END1 W @IOF D KILL^ADGUTIL
 D ^%ZISC K ^TMP("DGZLDC") Q
 ;
 ;
LINE ;***> subrtn to print patient data
 W !,$E(DGNM,1,20)    ;patient name
 S DGX=$P(^AUPNPAT(DFN,41,DUZ(2),0),U,2) W ?23,$J(DGX,6)  ;chart #
 I DGTYP=1 W ?32,DGTIM,?41,$E(DGSV,1,3),?48,$E(DGW,1,3)  ;time,service & ward
 I DGTYP>1 W ?32,$E(DGDT,4,5)_"/"_$E(DGDT,6,7)_"/"_$E(DGDT,2,3)_"@"_$E($P(DGDT,".",2)_"000",1,4)
 W ?48,$S(DGTYP=2:$E(DGSV,1,3),DGTYP=3:$E(DGW,1,3),1:"")
 W ?55,$E(DGDX,1,25)   ;admit dx
 I $Y>(IOSL-4) D NEWPG
 Q
 ;
NEWPG ;***> subrtn for end of page control
 I IOST'?1"C-".E D HEAD S DGSTOP="" Q
 I DGPAGE>0 K DIR S DIR(0)="E" D ^DIR S DGSTOP=X
 I DGSTOP'=U D HEAD
 Q
 ;
HEAD ;***> subrtn to print heading
 I (IOST["C-")!(DGPAGE>0) W @IOF
 W !,DGLINE S DGPAGE=DGPAGE+1
 W !?11,"*******Confidential Patient Data Covered by Privacy Act*****"
 W !,DGDUZ,?80-$L(DGFAC)/2,DGFAC S DGTY="DISCHARGES"
 W ! D TIME^ADGUTIL W ?80-$L(DGTY)/2,DGTY,?70,"Page: ",DGPAGE
 S Y=DT X ^DD("DD") W !,Y,?30,DGRANGE  ;date range
 S DGX="(SORTED BY "_$S(DGTYP=1:"DATE",DGTYP=2:"WARD",1:"SERVICE")_")"
 W !?80-$L(DGX)/2,DGX
 W !,DGLINE I DGTYP=1 W !?32,"Dsch"
 W !,"Patient Name",?24,"HRCN"
 I DGTYP=1 W ?32,"Time",?41,"Srv",?47,"Ward",?57,"Admitting Diagnosis"
 I DGTYP=2 W ?33,"Dsch Date",?48,"Srv",?57,"Admitting Diagnosis"
 I DGTYP=3 W ?33,"Dsch Date",?47,"Ward",?58,"Admitting Diagnosis"
 W !,DGLINE2
 I DGTYP=1 W !!?25,"** Discharged on ",$E(DGDT,4,5)_"/"_$E(DGDT,6,7)_"/"_$E(DGDT,2,3)," **",!
 E  I DGBDT'=DGEDT S DGX="**  "_$S(DGTYP=2:DGW,1:DGSV)_"  **" W !!?80-$L(DGX)/2,DGX
 Q
