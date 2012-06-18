ADGSIL1 ; IHS/ADC/PDW/ENM - SI/DNR LISTING ; [ 03/25/1999  11:48 AM ]
 ;;5.0;ADMISSION/DISCHARGE/TRANSFER;;MAR 25, 1999
 ;
 W @IOF,!!! K ^TMP("DGZSIL",$J)
 W ?10,"PATIENTS CURRENTLY ON SERIOUSLY ILL/DO NOT RESUSCITATE LIST",!!
A ; -- main
 D ZIS I POP D Q Q
 I $D(IO("Q")) D QUE,Q Q
 D LW,WRT,Q Q
 ;
START ; -- queued output driver
 K ^TMP("DGZSIL",$J)
 D LW,WRT,Q Q
 ;
LW ; -- loop inpatients
 N WD,DFN,WARD,NAME,TS,PR,CON,CDT,UTL,N,X
 S WARD="" F  S WARD=$O(^DPT("CN",WARD)) Q:WARD=""  D
 . S DFN=0 F  S DFN=$O(^DPT("CN",WARD,DFN)) Q:'DFN  D VAR
 Q
 ;
VAR ;
 Q:'$D(^DPT(DFN,"DAC"))  Q:$P(^("DAC"),U)=""  S N=^("DAC")
 S NAME=$P($G(^DPT(DFN,0)),U),TS=$G(^(.103)),PR=$G(^(.104))
 S WD=$O(^DIC(42,"B",WARD,0)),CON=$P(N,U),CDT=$P(N,U,2)
 S UTL=$$AGE_U_TS_U_PR_U_$$HRCN^ADGF_U_WARD_U_CDT
 I CON="S"!(CON="B") S ^TMP("DGZSIL",$J,1,NAME,DFN)=UTL
 I CON="D"!(CON="B") S ^TMP("DGZSIL",$J,2,NAME,DFN)=UTL
 Q
 ;
WRT ; -- loop utl
 N WD,DFN,WARD,NAME,TS,PR,CON,CDT,UTL,N,X
 U IO D HD S SI=0 F  S SI=$O(^TMP("DGZSIL",$J,SI)) Q:'SI  D
 . W !!?28,$$HD1,!
 . S NAME="" F  S NAME=$O(^TMP("DGZSIL",$J,SI,NAME)) Q:NAME=""  D
 .. S DFN=0 F  S DFN=$O(^TMP("DGZSIL",$J,SI,NAME,DFN)) Q:'DFN  D 1 Q:$D(DIRUT)
 Q
 ;
1 S N=^TMP("DGZSIL",$J,SI,NAME,DFN)
 W !,$E(NAME,1,20),?23,$P(N,U,4)
 W ?32,$E($P($G(^VA(200,+$P(N,U,3),0)),U),1,12)
 W ?48,$P(N,U),?57,$P(N,U,5),?63,$E($G(^DIC(45.7,+$P(N,U,2),0)),1,3)
 W ?69,$E($P(N,U,6),4,5)_"/"_$E($P(N,U,6),6,7)_"/"_$E($P(N,U,6),2,3)
 I $Y>(IOSL-7) D NPG
 Q
 ;
HD ; -- heading
 I IOST["C-" W @IOF
 W ?11,"*****Confidential Patient Data Covered by Privacy Act*****"
 W !!?22,"SERIOUSLY ILL/DO NOT RESUSCITATE LIST",!
 W ?34,"for ",$E(DT,4,5)_"/"_$E(DT,6,7)_"/"_$E(DT,2,3),!!
 W !,"Patient Name",?23,"Chart #",?32,"Provider",?48,"Age"
 W ?57,"WD",?63,"SRV",?69,"Entered" Q
 ;
ZIS ; -- device selection
 S %ZIS="PQ" D ^%ZIS Q
 ;
QUE ; -- queued output
 S ZTRTN="START^ADGSIL1",ZTDESC="SI/DNR LIST" D ^%ZTLOAD Q
 ;
NPG ; -- end of page
 I IOST'?1"C-".E D HD Q
 K DIR S DIR(0)="E" D ^DIR D:'$D(DIRUT) HD Q
 ;
Q ; -- cleanup
 I IOST?1"C-".E D PRTOPT^ADGVAR
 W @IOF D ^%ZISC,HOME^%ZIS K ZTSK,IO("Q") Q
 ;
AGE() ; -- age
 N X,DIC,DR,DA
 K ^UTILITY("DIQ1",$J) S DIC=9000001,DR=1102.98,DA=DFN D EN^DIQ1
 S X=^UTILITY("DIQ1",$J,9000001,DFN,1102.98) K ^UTILITY("DIQ1",$J)
 Q X
 ;
HD1() ; -- heading
 Q $S(SI=1:"  ***SERIOUSLY ILL***",1:"***DO NOT RESUSCITATE***")
