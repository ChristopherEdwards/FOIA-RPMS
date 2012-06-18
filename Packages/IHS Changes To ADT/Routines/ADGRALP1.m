ADGRALP1 ; IHS/ADC/PDW/ENM - READMISSION LISTING (PRINT) ; [ 03/25/1999  11:48 AM ]
 ;;5.0;ADMISSION/DISCHARGE/TRANSFER;;MAR 25, 1999
 ;
WARD ;EP;***> in order by ward
 S DGW=0
WD1 S DGW=$O(^TMP("DGZRAL",$J,DGW)) G END:DGW="" S DGDT=0
 I DGPAGE=0!(DGBDT'=DGEDT) D NEWPG^ADGRALP G END1:DGSTOP="^"
 I DGPAGE>0,DGBDT=DGEDT W !!?35,"** ",$E(DGW,1,3)," **"
WD2 S DGDT=$O(^TMP("DGZRAL",$J,DGW,DGDT)) G WD1:DGDT="" S DGNM=0
WD3 S DGNM=$O(^TMP("DGZRAL",$J,DGW,DGDT,DGNM)) G WD2:DGNM="" S DFN=0
WD4 S DFN=$O(^TMP("DGZRAL",$J,DGW,DGDT,DGNM,DFN)) G WD3:DFN=""
 S DGS=^TMP("DGZRAL",$J,DGW,DGDT,DGNM,DFN)
 S DGSV=$P(DGS,U),DGDX=$P(DGS,U,2),DGRE=$P(DGS,U,3)
 S DGDSA=$P(DGS,U,4),DGDS=$P(DGS,U,5),DGLST=$P(DGS,U,6),DGA=$P(DGS,U,7)
 D LINE G END1:DGSTOP="^" G WD4
 ;
SERV ;EP;***> admit service order
 S DGSV=0
SV1 S DGSV=$O(^TMP("DGZRAL",$J,DGSV)) G END:DGSV="" S DGDT=0
 I DGPAGE=0!(DGBDT'=DGEDT) D NEWPG^ADGRALP G END1:DGSTOP="^"
 I DGPAGE>0,DGBDT=DGEDT W !!?35,"** ",$E(DGSV,1,3)," **"
SV2 S DGDT=$O(^TMP("DGZRAL",$J,DGSV,DGDT)) G SV1:DGDT="" S DGNM=0
SV3 S DGNM=$O(^TMP("DGZRAL",$J,DGSV,DGDT,DGNM)) G SV2:DGNM="" S DFN=0
SV4 S DFN=$O(^TMP("DGZRAL",$J,DGSV,DGDT,DGNM,DFN)) G SV3:DFN=""
 S DGS=^TMP("DGZRAL",$J,DGSV,DGDT,DGNM,DFN)
 S DGW=$P(DGS,U),DGDX=$P(DGS,U,2),DGRE=$P(DGS,U,3)
 S DGDSA=$P(DGS,U,4),DGDS=$P(DGS,U,5),DGLST=$P(DGS,U,6),DGA=$P(DGS,U,7)
 D LINE G END1:DGSTOP="^" G SV4
 ;
 ;***> eoj
END I IOST["C-" K DIR S DIR(0)="E" D ^DIR
END1 G END1^ADGRALP
 ;
LINE ;***> subrtn to print patient data
 W !!,$E(DGNM,1,20)    ;patient name
 W ?32,$E(DGDT,4,5)_"/"_$E(DGDT,6,7)_"/"_$E(DGDT,2,3)  ;admit date
 W "@"_$E($P(DGDT,".",2)_"000",1,4)  ;admit time
 W ?48,$S(DGTYP=2:$E(DGSV,1,3),DGTYP=3:$E(DGW,1,3),1:"")
 W ?53,$E(DGDX,1,25)   ;admit dx
 S DGX=$P(^AUPNPAT(DFN,41,DUZ(2),0),U,2) W !,"[#",$J(DGX,6),"]"  ;chart
 I DGRE["A" D       ;if readmission
 .W ?11,"Last Admission:"
 .W ?32,$E(DGLST,4,5)_"/"_$E(DGLST,6,7)_"/"_$E(DGLST,2,3)  ;last admit
 .W "@"_$E($P(DGLST,".",2)_"000",1,4)  ;last admit time
 .S DGSVL=$P($G(^DIC(45.7,+$$TS,0)),U)
 .S DGWRD=$P(^DIC(42,$P(^DGPM(+DGA,0),U,6),0),U)
 .W ?48,$S(DGTYP=2:$E(DGSVL,1,3),DGTYP=3:$E(DGWRD,1,3),1:"")
 .S DGDX=$P(^DGPM(DGA,0),U,10) W ?53,$E(DGDX,1,25)   ;admit dx
 E  D       ;if admission is after day surgery
 .W:DGRE["DS" ?11,"Admit from DS:"
 .W:DGRE'["S" ?11,"Day Surgery:"
 .W ?32,$E(DGDS,4,5)_"/"_$E(DGDS,6,7)_"/"_$E(DGDS,2,3)  ;ds date
 .W "@"_$E($P(DGDS,".",2)_"000",1,4)  ;ds time
 .S DGDSTR=^ADGDS(DFN,"DS",DGDSA,0)
 .S DGSRVL=$P(^DIC(45.7,$P(DGDSTR,U,5),0),U)  ;ds srv
 .S DGPROC=$P(DGDSTR,U,2)  ;ds procedure
 .W ?48,$S(DGTYP=2:$E(DGSV,1,3),1:"")
 .W ?53,$E(DGPROC,1,25)   ;admit proc
 I $Y>(IOSL-4) D NEWPG^ADGRALP
 Q
 ;
TS() ; -- treating specialty ifn    
 Q $P($G(^DGPM(+$O(^DGPM("APHY",+DGA,0)),0)),U,9)
