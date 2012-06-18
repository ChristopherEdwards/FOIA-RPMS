ADGCEN32 ; IHS/ADC/PDW/ENM - CENSUS WARD LISTING PRINT ; [ 03/25/1999  11:48 AM ]
 ;;5.0;ADMISSION/DISCHARGE/TRANSFER;;MAR 25, 1999
 ;
 ;***> print summary page
SUM I DGWD'="A" G END  ;no summary for one ward reports
 S DGWN=0,DGW="SUMMARY" D HEAD W !!
S1 S DGWN=$O(^DIC(42,"B",DGWN)) G S3:DGWN="" S DGWDFN=0  ;get wards' names
S2 S DGWDFN=$O(^DIC(42,"B",DGWN,DGWDFN)) G S1:DGWDFN=""
 I $D(^DIC(42,DGWDFN,"I")),(^("I")="I") G S2  ;screen out inactive wards
 ;
 W !!?3,DGWN,?16,"______   +",?30,+$P(DGCN(DGWN),U)
 W ?42,($P(DGCN(DGWN),U,2)-$P(DGCN(DGWN),U,3))
 W ?49,"-",?55,$P(DGCN(DGWN),U,4),?65,"______" G S2
 ;
S3 S (DGX,DGTADM)=0
 F  S DGX=$O(DGCN(DGX)) Q:DGX=""  S DGTADM=DGTADM+$P(DGCN(DGX),U)
 S (DGX,DGTDSC)=0
 F  S DGX=$O(DGCN(DGX)) Q:DGX=""  S DGTDSC=DGTDSC+$P(DGCN(DGX),U,4)
 S (DGX,DGTTR)=0
 F  S DGX=$O(DGCN(DGX)) Q:DGX=""  S DGTTR=DGTTR+$P(DGCN(DGX),U,2)-$P(DGCN(DGX),U,3)
 S DGLIN="",$P(DGLIN,"=",80)="" W !!,DGLIN
 W !!?3,"TOTALS:",?16,"______   +  ",?30,DGTADM,?41,"(",DGTTR,")"
 W ?49,"-",?55,DGTDSC,?62,"=  ______"
 I $D(DGCT("NEWBORN")) D  ;
 .W !!?3,"NEWBORNS:",?16,"______   +  ",?30,$P(DGCT("NEWBORN"),U)
 .W ?41,"(",$P(DGCT("NEWBORN"),U,2)-$P(DGCT("NEWBORN"),U,3),")"
 .W ?49,"-",?55,$P(DGCT("NEWBORN"),U,4),?62,"=  ________"
 ;
 ;
END I IOST["C-" D PRTOPT^ADGVAR
END1 ;EP;***> end of program
 W @IOF D ^%ZISC
 D KILL^ADGUTIL K ^TMP($J) Q
 ;
 ;
HEAD ;***> subrtn to print heading
 W @IOF S DGLIN="",$P(DGLIN,"=",80)="" W !,DGLIN S DGPAGE=DGPAGE+1
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
