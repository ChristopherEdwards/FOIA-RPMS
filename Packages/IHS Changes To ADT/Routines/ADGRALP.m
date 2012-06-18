ADGRALP ; IHS/ADC/PDW/ENM - READMISSION LISTING (PRINT) ; [ 03/25/1999  11:48 AM ]
 ;;5.0;ADMISSION/DISCHARGE/TRANSFER;;MAR 25, 1999
 ;
 ;***> initialize variables
 S DGPAGE=0,DGSTOP="",DGDUZ=$P(^VA(200,DUZ,0),U,2)
 S DGSITE=$P(^DIC(4,DUZ(2),0),U)    ;set site
 S DGRANGE=$E(DGBDT,4,5)_"/"_$E(DGBDT,6,7)_"/"_$E(DGBDT,2,3)_" to "
 S DGRANGE=DGRANGE_$E(DGEDT,4,5)_"/"_$E(DGEDT,6,7)_"/"_$E(DGEDT,2,3)
 S DGLINE="",$P(DGLINE,"=",80)=""
 S DGLINE2="",$P(DGLINE2,"-",80)=""
 ;
 G DATE:DGTYP=1,WARD^ADGRALP1:DGTYP=2,SERV^ADGRALP1:DGTYP=3  ;sort?
 ;
DATE ;***> admit date order
 S DGDT=0
DT1 S DGDT=$O(^TMP("DGZRAL",$J,DGDT)) G END:DGDT="" S DGTM=0
 I DGPAGE=0 D NEWPG G END1:DGSTOP=U
DT2 S DGTM=$O(^TMP("DGZRAL",$J,DGDT,DGTM)) G DT1:DGTM="" S DFN=0
DT3 S DFN=$O(^TMP("DGZRAL",$J,DGDT,DGTM,DFN)) G DT2:DFN=""
 S DGS=^TMP("DGZRAL",$J,DGDT,DGTM,DFN)
 S DGW=$P(DGS,U),DGSV=$P(DGS,U,2),DGDX=$P(DGS,U,3)
 S DGNM=$P(^DPT(DFN,0),U),DGTIM=$E($P(DGTM,".",2)_"000",1,4)
 S DGRE=$P(DGS,U,4),DGDSA=$P(DGS,U,5),DGDS=$P(DGS,U,6)
 S DGLST=$P(DGS,U,7),DGA=$P(DGS,U,8)
 D LINE G END1:DGSTOP=U G DT3
 ;
 ;
END ;***> eoj
 I IOST["C-" K DIR S DIR(0)="E" D ^DIR
END1 ;EP;
 W @IOF D KILL^ADGUTIL
 D ^%ZISC K ^TMP("DGZRAL") Q
 ;
LINE ;***> subrtn to print patient data
 W !!,$E(DGNM,1,20)    ;patient name
 W ?27,$E(DGTM,4,5)_"/"_$E(DGTM,6,7)_"/"_$E(DGTM,2,3)  ;admit date
 W "@"_$E($P(DGTM,".",2)_"000",1,4)  ;admit time
 W ?41,$E(DGSV,1,3),?48,$E(DGW,1,3)  ;service & ward
 W ?53,$E(DGDX,1,25)                 ;admit dx
 S DGX=$P(^AUPNPAT(DFN,41,DUZ(2),0),U,2) W !,"[#",$J(DGX,6),"]"  ;chart
 I DGRE["A" D       ;if readmission
 .W ?11,"Last Admission:"
 .W ?27,$E(DGLST,4,5)_"/"_$E(DGLST,6,7)_"/"_$E(DGLST,2,3)  ;last admit
 .W "@"_$E($P(DGLST,".",2)_"000",1,4)  ;last admit time
 .S DGSVL=$P($G(^DIC(45.7,+$$TS,0)),U)  ;srv
 .S DGWRD=$P(^DIC(42,$P(^DGPM(DGA,0),U,6),0),U)  ;ward
 .W ?41,$E(DGSVL,1,3),?48,$E(DGWRD,1,3)  ;last srv & wrd
 .S DGDX=$P(^DGPM(DGA,0),U,10) W ?53,$E(DGDX,1,25)   ;admit dx
 E  D       ;if admission is after day surgery
 .W:DGRE["DS" ?11,"Admit from DS:"
 .W:DGRE'["S" ?11,"Day Surgery:"
 .W ?27,$E(DGDS,4,5)_"/"_$E(DGDS,6,7)_"/"_$E(DGDS,2,3)  ;ds date
 .W "@"_$E($P(DGDS,".",2)_"000",1,4)  ;ds time
 .S DGDSTR=^ADGDS(DFN,"DS",DGDSA,0)
 .S DGSRVL=$P(^DIC(45.7,$P(DGDSTR,U,5),0),U)  ;ds service
 .S DGPROC=$P(DGDSTR,U,2)  ;ds procedure
 .W ?41,$E(DGSRVL,1,3),?53,$E(DGPROC,1,25)   ;print srv & proc
 I $Y>(IOSL-4) D NEWPG
 Q
 ;
NEWPG ;EP;***> subrtn for end of page control
 I IOST'?1"C-".E D HEAD S DGSTOP="" Q
 I DGPAGE>0 K DIR S DIR(0)="E" D ^DIR S DGSTOP=X
 I DGSTOP'=U D HEAD
 Q
 ;
HEAD ;***> subrtn to print heading
 I (IOST["C-")!(DGPAGE>0) W @IOF
 W !,DGLINE S DGPAGE=DGPAGE+1
 W !?11,"*****Confidential Patient Data Covered by Privacy Act*****"
 W !,DGDUZ,?80-$L(DGSITE)/2,DGSITE S DGTY="READMISSIONS"
 W ! D TIME^ADGUTIL W ?80-$L(DGTY)/2,DGTY,?70,"Page: ",DGPAGE
 S Y=DT X ^DD("DD") W !,Y,?30,DGRANGE  ;date range
 S DGX="(SORTED BY "_$S(DGTYP=1:"DATE",DGTYP=2:"WARD",1:"SERVICE")_")"
 W !?80-$L(DGX)/2,DGX
 W !,DGLINE I DGTYP=1 W !?32,"Admit",?57,"Admitting Diagnosis /"
 W !?54,"Admitting Diagnosis /",!,"Patient Name"
 I DGTYP=1 W ?29,"Date/Time",?41,"Srv",?47,"Ward"
 I DGTYP=2 W ?33,"Admit Date",?48,"Srv"
 I DGTYP=3 W ?33,"Admit Date",?47,"Ward"
 W:$O(^ADGDS(0)) ?58,"Day Surg Procedure" W !,DGLINE2
 I DGTYP>1 S DGX="**  "_$S(DGTYP=2:DGW,1:DGSV)_"  **" W !!?80-$L(DGX)/2,DGX
 Q
 ;
TS() ; -- treating specialty ifn
 Q $P($G(^DGPM(+$O(^DGPM("APHY",DGA,0)),0)),U,9)
