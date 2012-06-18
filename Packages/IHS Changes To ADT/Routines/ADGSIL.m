ADGSIL ; IHS/ADC/PDW/ENM - SERIOUSLY ILL LIST ; [ 03/25/1999  11:48 AM ]
 ;;5.0;ADMISSION/DISCHARGE/TRANSFER;;MAR 25, 1999
 ;
 W @IOF,!!!?31,"PATIENTS CURRENTLY ON SERIOUSLY ILL LIST",!!
A ; -- driver
 D ZIS I POP D Q Q
 I $D(IO("Q")) D QUE,Q Q
 D LW,Q Q
 ;
LW ;EP; -- loop inpatients
 U IO D HD
 S WD="" F  S WD=$O(^DPT("CN",WD)) Q:WD=""  D
 . S DFN=0 F  S DFN=$O(^DPT("CN",WD,DFN)) Q:'DFN  D WRT
 Q
 ;
WRT ;
 Q:'$D(^DPT(DFN,"DAC"))  Q:$P(^("DAC"),U)'="S"
 W !,$E($P($G(^DPT(+DFN,0)),U),1,20),?25,$$HRCN^ADGF
 W ?37,$E($$PR,1,15),?55,$$AGE,?63,$$WD,?68,$E($$TS,1,3)
 I $Y>(IOSL-7) D NPG
 Q
 ;
HD ;print heading
 I IOST["C-" W @IOF
 W ?11,"*****Confidential Patient Data Covered by Privacy Act*****"
 W !!?31,"SERIOUSLY ILL LIST",!
 W ?34,"for ",$E(DT,4,5)_"/"_$E(DT,6,7)_"/"_$E(DT,2,3),!!
 W !,"Patient Name",?25,"Chart #",?37,"Provider",?55,"Age"
 W ?63,"WD",?68,"SRV",!
 Q
 ;
Q I IOST?1"C-".E K DIR S DIR(0)="E" D ^DIR
 W @IOF D ^%ZISC,HOME^%ZIS
 K ZTSK,DFN,WD Q
 ;
NPG I IOST'?1"C-".E D HD Q
 K DIR S DIR(0)="E" D ^DIR K DIR,X D:'$D(DIRUT) HD Q
 ;
ZIS ; -- device selection
 S %ZIS="PQ" D ^%ZIS Q
 ;
QUE ; -- queued output
 K IO("Q") S ZTRTN="LW^ADGSIL",ZTDESC="SI LIST" D ^%ZTLOAD Q
 ;
AGE() ; -- age
 N X,DIC,DR,DA
 K ^UTILITY("DIQ1",$J) S DIC=9000001,DR=1102.98,DA=DFN D EN^DIQ1
 S X=$G(^UTILITY("DIQ1",$J,9000001,DFN,1102.98)) K ^UTILITY("DIQ1",$J)
 Q X
 ;
PR() ; -- provider
 Q $E($P($G(^VA(200,+$G(^DPT(DFN,.104)),0)),U),1,21)
 ;
TS() ; -- treating specialty
 Q $E($P($G(^DIC(45.7,+$G(^DPT(DFN,.103)),0)),U),1,3)
 ;
WD() ; -- ward
 Q $E($P($G(^DIC(42,+$G(^DPT(DFN,.1)),0)),U),1,3)
