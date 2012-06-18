ADGDMM ; IHS/ADC/PDW/ENM - DISCHARGE M'CARE/M'CAID PRINT ; [ 03/25/1999  11:48 AM ]
 ;;5.0;ADMISSION/DISCHARGE/TRANSFER;;MAR 25, 1999
 ;
 ;
 N DGIFN,R,I,D,MCRN,MCDN,INSNM,INSN,DGED,DGBD,EED,DFN,IFN,X,Y,LN
A ; -- main
 D BD I Y=-1 D Q Q
 D ED I Y=-1 D Q Q
 D ZIS I POP D Q Q
 I $D(IO("Q")) D QUE,Q Q
 D HD,L3,PG(0),Q Q
 ;
BD ; -- beginning date
 S %DT="AEQ",%DT("A")="Select beginning date: ",X=""
 D ^%DT S DGBD=Y-.001 Q
 ;
ED ; -- ending date
 S %DT="AEQ",%DT("A")="Select ending date: ",X=""
 D ^%DT S DGED=Y+.9 Q
 ;
ZIS ; -- select device
 S %ZIS="PQ" D ^%ZIS Q
 ;
 ;
L3 ; -- loop discharges 
 S DGDT=DGBD F  S DGDT=$O(^DGPM("AMV3",DGDT)) Q:'DGDT!(DGDT>DGED)  D
 . S DFN=0 F  S DFN=$O(^DGPM("AMV3",DGDT,DFN)) Q:'DFN  D
 .. S DGIFN=0 F  S DGIFN=$O(^DGPM("AMV3",DGDT,DFN,DGIFN)) Q:'DGIFN  D 1
 Q
 ;
1 ; -- check for medicaid/care
 S (R,D,I)=0
 I $D(^AUPNMCR("B",DFN)) S IFN=$O(^(DFN,0)) D MCR
 I $D(^AUPNMCD("B",DFN)) S IFN=$O(^(DFN,0)) D MCD
 I $D(^AUPNPRVT("B",DFN)) S IFN=$O(^(DFN,0)) D INS
 I (R!D!I) D PRINT
 Q
 ;
Q ; -- cleanup
 W:IO'=IO(0)!($D(IO("S"))) @IOF D ^%ZISC Q
 ;
MCR ; -- medicare
 F ED=0:0 S ED=$O(^AUPNMCR(IFN,"11",ED)) Q:'ED  D
 . S EED=$P(^AUPNMCR(IFN,11,ED,0),U,2),R=0 I EED>DGDT!('+EED) D
 .. S R=1,MCRN=$P(^AUPNMCR(IFN,0),U,3)_$P(^AUTTMCS($P(^(0),U,4),0),U)
 Q
 ;
MCD ; -- medicaid
 F ED=0:0 S ED=$O(^AUPNMCD(IFN,"11",ED)) Q:'ED  D
 . S EED=$P(^AUPNMCD(IFN,11,ED,0),U,2),D=0
 . I EED>DGDT!('+EED) S D=1,MCDN=$P(^AUPNMCD(IFN,0),U,3)
 Q
 ;
INS ; -- private insurance 
 F ED=0:0 S ED=$O(^AUPNPRVT(IFN,"11",ED)) Q:'ED  D
 . S EED=$P(^AUPNPRVT(IFN,11,ED,0),U,7),I=0 I EED>DGDT!('+EED) D
 .. S I=1,INSN=$P(^AUPNPRVT(IFN,"11",ED,0),U,2)
 .. S INSNM=$P(^AUTNINS($P(^AUPNPRVT(IFN,"11",ED,0),U,1),0),U,1)
 Q
 ;
PRINT ; -- print
 I $Y>(IOSL-6) D PG(1)
 W !,$E($P(^DPT(DFN,0),U),1,15)  ;name
 I $D(DUZ(2))&($D(^AUPNPAT(DFN,41,DUZ(2),0))) W ?17,$J($P(^(0),U,2),6)
 I D W ?25,MCDN
 I R W ?37,MCRN
 I I W ?49,$E(INSNM,1,6),"  ",INSN
 S Y=+^DGPM(DGIFN,0) X ^DD("DD") W ?68,$P(Y,"@")  ;discharge date
 W ! Q
 ;
HDH ; -- heading
 U IO W !,"MEDICARE/MEDICAID LIST for Discharges from "
 S Y=DGBD+.001 X ^DD("DD") W Y," to " S Y=$P(DGED,".") X ^DD("DD") W Y
 W !!,"Patient Name",?19,"HRCN",?25,"MCAID #",?37,"MCARE #"
 W ?49,"Insurer /#",?68,"DISCHARGED"
 S LN="",$P(LN,"-",IOM)="" W !,LN Q
 ;
QUE ; -- queued outputs
 S ZTRTN="QUE^ADGDMM",ZTIO=ION
 S ZTDESC="DISCHARGE MEDICAID/MEDICARE REPORT"
 S ZTSAVE("DGBD")="",ZTSAVE("DGED")="" D ^%ZTLOAD D ^%ZISC K ZTSK Q
 ;
PG(Z) ; -- page
 Q:IOST'["C-"  W ! N X,Y K DIR S DIR(0)="E" D ^DIR W @IOF D HDH:Z Q
 ;
HD ;
 Q:IOST'["C-"  W @IOF D HDH Q
