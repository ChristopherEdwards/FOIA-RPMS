ADGCEN31 ; IHS/ADC/PDW/ENM - PRINT CENSUS AID-PATIENT LIST ; [ 03/25/1999  11:48 AM ]
 ;;5.0;ADMISSION/DISCHARGE/TRANSFER;;MAR 25, 1999
 ;
 ;rtn prints listing of admissions, discharges, and transfers
 ;for each ward specified.  Each ward on a separate page.
 ;Summary page at the end if all wards printed
 ;
 ;***> initialize variables
 S DGPAGE=0,Y=DGBDT X ^DD("DD") S DGDATE=Y,Y=DGEDT X ^DD("DD")
 S DGSITE=$P(^DIC(4,DUZ(2),0),U),DGDUZ=$P(^VA(200,DUZ,0),U,2)
 S DGX=0 F DGI="AA","TI","TO","AD","DT" S DGX=DGX+1,DGPOS(DGI)=DGX
 S DGDATE=DGDATE_" to "_Y,DGSTOP="",DGWW=0
 ;
 I DGWD="A" G INIT1  ;if all wards then loop
 E  S DGWW=$P(^DIC(42,DGWD,0),U),^TMP($J,"WARD",DGWW)="" G INIT2
INIT1 S DGWW=$O(^DIC(42,"B",DGWW)) G INIT2:DGWW=""
 S DGWW1=$O(^DIC(42,"B",DGWW,0))  ;get wards in alpha order
 I $D(^DIC(42,DGWW1,"I")),(^("I")="I") G INIT1  ;screen for inactives
 S ^TMP($J,"WARD",DGWW)="" G INIT1
INIT2 ;
 ;
 ;***> find ward and print admissions
 S DGW=0
WARD S DGW=$O(^TMP($J,"WARD",DGW)) G END:DGW="" S DGTOTL=0 D HEAD
 S DGX="AA",DGMOVE="ADMISSIONS",DGDT=0 D FIND G END1:DGSTOP=U
 ;
 ;***> print transfers in
TRANSIN S DGX="TI",DGMOVE="WARD TRANSFERS IN",DGDT=0 D FIND G END1:DGSTOP=U
 ;
 ;***> print transfers out
TRANSOUT S DGX="TO",DGMOVE="WARD TRANSFERS OUT",DGDT=0 D FIND G END1:DGSTOP=U
 ;
 ;***> print discharges
DISCH S DGX="AD",DGMOVE="DISCHARGES",DGDT=0 D FIND G END1:DGSTOP=U
 ;
 ;***> print deaths
DEATHS S DGX="DT",DGMOVE="DEATHS",DGDT=0 D FIND G END1:DGSTOP=U
 W !!?45,"CENSUS CHANGE FOR WARD:  ",$J(DGTOTL,3)
 ;
 ;***> newborns
NEWBORN I '$D(^TMP($J,"NEWA",DGW))&('$D(^TMP($J,"NEWD",DGW))) G NEXT
 S DGX="NEWA",DGDT=0,DGMOVE="NEWBORN ADMISSIONS" D FIND G END1:DGSTOP=U
 S DGX="NEWT",DGDT=0,DGMOVE="NEWBORN TRANSFER" D FIND G END1:DGSTOP=U
 S DGX="NEWD",DGDT=0,DGMOVE="NEWBORN DISCHARGES" D FIND G END1:DGSTOP=U
 S DGX=$P(DGCT("NEWBORN"),U)-$P(DGCT("NEWBORN"),U,3)-$P(DGCT("NEWBORN"),U,4)
 W !!?37,"NEWBORN CENSUS CHANGE FOR WARD: ",$J(DGX,3)
 ;
NEXT I IOST["C-" K DIR S DIR(0)="E" D ^DIR S DGSTOP=X
 G WARD     ;close loop, get next ward
 ;
 ;
END G ^ADGCEN32  ;print summary page and end
 ;
END1 G END1^ADGCEN32  ;quit
 ;
 ;
 ;***> find entries and print subrtn
FIND I $Y>(IOSL-6) D NEWPG G F4:DGSTOP=U
 W !!?80-$L(DGMOVE)/2,DGMOVE S DGCOUNT=0
F1 S DGDT=$O(^TMP($J,DGX,DGW,DGDT)) G F4:DGDT="" S DGNM=0
F2 S DGNM=$O(^TMP($J,DGX,DGW,DGDT,DGNM)) G F1:DGNM="" S DFN=0
F3 S DFN=$O(^TMP($J,DGX,DGW,DGDT,DGNM,DFN)) G F2:DFN=""
 ;
 S DGCHT=$P(^AUPNPAT(DFN,41,DUZ(2),0),U,2)  ;chart number
 I $Y>(IOSL-4) D NEWPG G F4:DGSTOP=U
 S DGTM=$P(DGDT,".",2),DGTM=$S(DGTM="":"N/A",1:$E(DGTM_"000",1,4))
 W !?3,DGTM,?20,DGNM,?50,$J(DGCHT,6) S DGCOUNT=DGCOUNT+1 G F2
 ;
F4 W !?60,"SUBTOTAL: ",$J(DGCOUNT,3)
 I DGX="AA"!(DGX="TI") D  G F9
 .S DGTOTL=DGTOTL+DGCOUNT
 .S DGY=DGPOS(DGX),$P(DGCN(DGW),U,DGY)=DGCOUNT Q
 I DGX="NEWA" S $P(DGCT("NEWBORN"),U)=DGCOUNT G F9
 I DGX="NEWT" S $P(DGCT("NEWBORN"),U,3)=DGCOUNT G F9
 I DGX="NEWD" S $P(DGCT("NEWBORN"),U,4)=DGCOUNT G F9
 E  S DGTOTL=DGTOTL-DGCOUNT,DGY=DGPOS(DGX),$P(DGCN(DGW),U,DGY)=DGCOUNT
F9 Q  ;leave subrtn
 ;
NEWPG ;***> subrtn for end of page control
 I IOST'?1"C-".E D HEAD S DGSTOP="" Q
 K DIR S DIR(0)="E" D ^DIR S DGSTOP=X
 I DGSTOP'=U D HEAD
 Q
 ;
HEAD ;***> subrtn to print heading
 I (IOST["C-")!(DGPAGE>0) W @IOF
 S DGLIN="",$P(DGLIN,"=",80)="" W !,DGLIN S DGPAGE=DGPAGE+1
 W !?11,"*****Confidential Patient Data Covered by Privacy Act*****"
 W !,DGDUZ,?80-$L(DGSITE)/2,DGSITE S DGTY="WARD CENSUS LISTING"
 W ! D TIME^ADGUTIL W ?80-$L(DGTY)/2,DGTY,?70,"Page: ",DGPAGE
 S Y=DT X ^DD("DD") W !,Y
 S DGWARD="*** "_DGW_" ***" W ?80-$L(DGWARD)/2,DGWARD
 W !?80-$L(DGDATE)/2,DGDATE,!,DGLIN
 I DGW'="SUMMARY" W !?3," Time",?20,"Patient Name",?50,"Chart #" G HD1
 W !,"Ward",?15,"Beg Census  Admits  Net Transfers  Discharges  Ending Census"
HD1 S DGLIN="",$P(DGLIN,"-",80)="" W !,DGLIN
 Q
