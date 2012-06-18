ADGDSST ; IHS/ADC/PDW/ENM - DAY SURGERY STATISTICS BY SERVICE ; [ 12/16/2003  3:14 PM ]
 ;;5.0;ADMISSION/DISCHARGE/TRANSFER;**3**;MAR 25, 1999
 ;IHS/ITSC/WAR 12/16/03 Added call to 'old'(?) init of IHS variales
 I '$D(DGOPT("GEN"))&($D(^DG(43,1,9999999))) D VAR^ADGVAR
 I '$D(DGOPT("GEN")) D
 .S DGOPT("GEN")=$P(^BDGPAR(1,0),U,5)  ;Last attempt to get min age
 ;IHS/ITSC/WAR 12/16/03 end of mod
 ;
 W @IOF,!!!?18,"DAY SURGERY STATISTICS BY SERVICE",!!
 ;***> get date range
BDATE S %DT="AEQ",%DT("A")="Select beginning date: ",X="" D ^%DT
 G END:Y=-1 S DGBDT=Y
EDATE S %DT="AEQ",%DT("A")="Select ending date: ",X="" D ^%DT
 G END:Y=-1 S DGEDT=Y
 ;
 ;***> get print device
 S %ZIS="PQ" D ^%ZIS G END:POP,QUE:$D(IO("Q")) U IO G CALC
QUE K IO("Q") S ZTRTN="CALC^ADGDSST",ZTDESC="DAY SURGERY STATS"
 ;IHS/DSD/ENM 07/16/99 NEXT LINE COPIED/MOD
 ;S ZTSAVE("DGBDT")="",ZTSAVE("DGEDT")=""
 F DGI="DGBDT","DGEDT","DGPV","DGOPT(""GEN"")","DGOPT(""QA"")","DGOPT(""QA1"")" S ZTSAVE(DGI)=""
 D ^%ZTLOAD D ^%ZISC K ZTSK
END K Y,DGBDT,DGEDT D HOME^%ZIS Q
 ;
 ;
CALC ;***> sort by surgery date and find service and age
 S DGDT=DGBDT-.9999
C1 S DGDT=$O(^ADGDS("AA",DGDT)) G PRINT:DGDT="",PRINT:DGDT>(DGEDT_.2400) S DFN=0
C2 S DFN=$O(^ADGDS("AA",DGDT,DFN)) G C1:DFN="" S DGN=0
C3 S DGN=$O(^ADGDS("AA",DGDT,DFN,DGN)) G C2:DGN=""
 G C3:'$D(^ADGDS(DFN,"DS",DGN,0)) S DGSRV=$P(^(0),U,5)
 I $D(^ADGDS(DFN,"DS",DGN,2)) G C3:$P(^(2),U,3)="Y" G C3:$P(^(2),U,4)="Y"
 S:DGSRV'="" DGSRV=$S($D(^DIC(45.7,DGSRV,0)):$P(^(0),U),1:"")
 S AGE=$$VAL^XBDIQ1(9000001,DFN,1102.99)
 I AGE="" S ^TMP($J,"ERR",DFN)="Date of Birth missing or invalid" G C3
 ;IHS/ITSC/WAR 12/16/03 added $G to avoid undefined if the OLD DS
 ;      varialbes were not able to be setup by the VAR^ADGVAR call
 ;I AGE'<$P(DGOPT("GEN"),U,5) S DGA(DGSRV,"A")=$S($D(DGA(DGSRV,"A")):DGA(DGSRV,"A")+1,1:1) S:'$D(DGA(DGSRV,"P")) DGA(DGSRV,"P")=0
 I AGE'<$P($G(DGOPT("GEN")),U,5) S DGA(DGSRV,"A")=$S($D(DGA(DGSRV,"A")):DGA(DGSRV,"A")+1,1:1) S:'$D(DGA(DGSRV,"P")) DGA(DGSRV,"P")=0
 E  S DGA(DGSRV,"P")=$S($D(DGA(DGSRV,"P")):DGA(DGSRV,"P")+1,1:1) S:'$D(DGA(DGSRV,"A")) DGA(DGSRV,"A")=0
 G C3
 ;
PRINT ;***> print
 S DGFAC=$P(^DIC(4,DUZ(2),0),U),DGDUZ=$P(^VA(200,DUZ,0),U,2)
 S (DGLIN,DGLIN1)="",$P(DGLIN,"-",80)="",$P(DGLIN1,"=",80)=""
 ;
 S (DGSRV,DGPAGE)=0 D HEAD
P1 S DGSRV=$O(DGA(DGSRV)) G EXIT:DGSRV=""
 W !?3,DGSRV W ?29,$J(DGA(DGSRV,"A"),3),?41,$J(DGA(DGSRV,"P"),3)
 W ?63,$J(DGA(DGSRV,"A")+DGA(DGSRV,"P"),4) G P1
 ;
 ;***> print totals
EXIT W !,DGLIN,!!!?3,"TOTALS:"
 S (DGX,DGY)=0 F  S DGX=$O(DGA(DGX)) Q:DGX=""  S DGY=DGY+DGA(DGX,"A")
 S (DGX1,DGY1)=0
 F  S DGX1=$O(DGA(DGX1)) Q:DGX1=""  S DGY1=DGY1+DGA(DGX1,"P")
 W ?28,$J(DGY,4),?40,$J(DGY1,4),?63,$J((DGY+DGY1),4)
 ;
END1 ;***> eoj
 I IOST["C-" D PRTOPT^ADGVAR
 W @IOF D KILL^ADGUTIL D ^%ZISC Q
 ;
 ;
HEAD ;***> subrtn to print heading
 I (IOST["C-")!(DGPAGE>0) W @IOF
 W !,DGDUZ,?82-$L(DGFAC)\2,DGFAC S DGPAGE=DGPAGE+1
 W ! D TIME^ADGUTIL W ?23,"DAY SURGERY STATISTICS BY SERVICE"
 S DGX=$E(DGBDT,4,5)_"/"_$E(DGBDT,6,7)_"/"_($E(DGBDT,1,3)+1700)
 S DGY=$E(DGEDT,4,5)_"/"_$E(DGEDT,6,7)_"/"_($E(DGEDT,1,3)+1700)
 W !,$E(DT,4,5)_"/"_$E(DT,6,7)_"/"_$E(DT,2,3),?24,"from ",DGX," to ",DGY
 W !!?5,"SERVICE",?29,"ADULT",?41,"PEDS",?57,"TOTAL FOR SERVICE"
 W !,DGLIN1,! Q
