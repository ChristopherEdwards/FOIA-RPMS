ADGADSP1 ; IHS/ADC/PDW/ENM - A & D SHEET PRINT (DETAILED) ; [ 03/25/1999  11:48 AM ]
 ;;5.0;ADMISSION/DISCHARGE/TRANSFER;;MAR 25, 1999
 ;
 ;detailed version continued
 G END:'$D(^TMP("DGZADS",$J,"ZZ")) S DGCNT=^("ZZ")
 S DGK=0
 ;
 ;***> print data for admits,discharges,newborns,deaths,&seriously ill
LOOP F DGI="AA","AD","AN","DN","DT","SI" D
 .S DGK=DGK+1,DGNM=0  ;initialize variables
 .D NEWPG:$Y>(IOSL-5)  ;form feed if at end of page
 .W !,$P($T(LABEL+DGK),";;",2)," ",$P(DGCNT,U,DGK)  ;print totals
 .F  Q:DGNM=""  D   ;loop thru by patient name
 ..S DGNM=$O(^TMP("DGZADS",$J,DGI,DGNM)) Q:DGNM=""  ;
 ..S DGCHT=0 F  Q:DGCHT=""  D  ;within name loop by chart & print data
 ...S DGCHT=$O(^TMP("DGZADS",$J,DGI,DGNM,DGCHT)) Q:DGCHT=""  ;
 ...S DGADM=0 F  Q:DGADM=""  D  ;w/in chart loop by admit # & print data
 ....S DGADM=$O(^TMP("DGZADS",$J,DGI,DGNM,DGCHT,DGADM)) Q:DGADM=""
 ....S DGSTR=^TMP("DGZADS",$J,DGI,DGNM,DGCHT,DGADM) D WRITE
 ;
 ;
TRANSF ;***> print transfers
 D NEWPG:$Y>(IOSL-5) W !,"WARD TRANSFERS: ",$P(DGCNT,U,7)
 G H1:'$D(^TMP("DGZADS",$J,"WT"))  ;skip if no ward transfers
 S DGNM=0  ;get ward transfers by patient name
G2 S DGNM=$O(^TMP("DGZADS",$J,"WT",DGNM)) G H1:DGNM="" S DFN=0
G3 S DFN=$O(^TMP("DGZADS",$J,"WT",DGNM,DFN)) G G2:DFN="" S DGTRN=0
G4 S DGTRN=$O(^TMP("DGZADS",$J,"WT",DGNM,DFN,DGTRN)) G G3:DGTRN=""
 S DGSTR=^TMP("DGZADS",$J,"WT",DGNM,DFN,DGTRN) D NEWPG:$Y>(IOSL-7)
 S DGX=$P(DGSTR,U) I DGX'=""  S DGX=$P($G(^DIC(42,DGX,0)),U) ;prev ward
 S DGX1=$P(DGSTR,U,2) I DGX1'="" S DGX1=$P($G(^DIC(42,DGX1,0)),U) ;new
 W !?10,DGNM," from ",DGX," to ",DGX1 G G4
 ;
H1 D NEWPG:$Y>(IOSL-5) W !,"TREATING SPECIALTY TRANSFERS: ",$P(DGCNT,U,8)
 G END:'$D(^TMP("DGZADS",$J,"TS"))  ;skip if no service transfers
 S DGNM=0  ;get service transfers by patient name
H2 S DGNM=$O(^TMP("DGZADS",$J,"TS",DGNM)) G END:DGNM="" S DFN=0
H3 S DFN=$O(^TMP("DGZADS",$J,"TS",DGNM,DFN)) G H2:DFN="" S DGTST=0
H4 S DGTST=$O(^TMP("DGZADS",$J,"TS",DGNM,DFN,DGTST)) G H3:DGTST=""
 S DGSTR=^TMP("DGZADS",$J,"TS",DGNM,DFN,DGTST) D NEWPG:$Y>(IOSL-7)
 S DGX=$P(DGSTR,U) I DGX'="" S DGX=$P($G(^DIC(45.7,DGX,0)),U) ;old srv
 S DGX1=$P(DGSTR,U,2) I DGX1'="" S DGX1=$P($G(^DIC(45.7,DGX1,0)),U) ;new
 W !?10,DGNM," from ",DGX," to ",DGX1 G H4
 ;
 ;
END G:$D(^ADGDS("AA")) ^ADGADSP2  ;day surgery print
 ;
END1 ;EP;***> ending point for A&D print rtns
 I IOST["C-" K DIR S DIR("A")="Press RETURN to continue",DIR(0)="E" D ^DIR
 W @IOF S X=IOM X ^%ZOSF("RM")  ;restore right margin
 D KILL^ADGUTIL
 K ^TMP("DGZADS",$J)
 D ^%ZISC Q
 ;
 ;
WRITE ;***>  subrtn to print each line
 W !?10,$E(DGNM,1,24)  ;patient name
 ;S DGCHTX="00000"_DGCHT,DGCHTX=$E(DGCHTX,$L(DGCHTX)-5,$L(DGCHTX))
 ;W ?37,$E(DGCHTX,1,2)_"-"_$E(DGCHTX,3,4)_"-"_$E(DGCHTX,5,6)
 W ?37,DGCHT
 S DGPR=$P(DGSTR,U) ;admitting provider
 I DGPR'="" S DGPR=$E($P($G(^VA(200,DGPR,0)),U),1,21)
 W ?47,DGPR,?71,$P(DGSTR,U,2)  ;print provider & age
 S DGX=$P(DGSTR,U,3) I DGX'="" W ?80,$P($G(^DIC(42,DGX,0)),U) ;ward/srv
 S DGX=$P(DGSTR,U,4) I DGX'="" W ?84,$E($P($G(^DIC(45.7,DGX,0)),U),1,3)
 W ?90,$E($P(DGSTR,U,5),1,12)  ;community
 S DGDST=$P(DGSTR,U,6) G W5:DGDST=""  ;skip if no transfer facility
 S DGX=@(U_$P(DGDST,";",2)_+DGDST_",0)")  ;variable pointer
 W !?17,"Transfer Facility:  ",$P(DGX,U)
W5 D:$Y>(IOSL-5) NEWPG
W9 Q
 ;
NEWPG ;EP;***> subrtn for end of page control
 I IOST["C-" K DIR S DIR("A")="Press RETURN to continue",DIR(0)="E" D ^DIR
 W @IOF
NP9 W !?26,"*****Confidential Patient Data Covered by Privacy Act*****",!
 Q
 ;
LABEL ;;
 ;;ADMISSIONS:
 ;;DISCHARGES:
 ;;NEWBORN ADMISSIONS:
 ;;NEWBORN DISCHARGES:
 ;;DEATHS:
 ;;SERIOUSLY ILL:
