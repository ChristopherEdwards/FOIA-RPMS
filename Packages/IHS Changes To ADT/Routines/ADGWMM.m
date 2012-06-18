ADGWMM ; IHS/ADC/PDW/ENM - INPT INSURANCE LISTING ; [ 03/25/1999  11:48 AM ]
 ;;5.0;ADMISSION/DISCHARGE/TRANSFER;;MAR 25, 1999
 ;
 D ^XBCLS W !!?15,"INPATIENT MEDICARE/MEDICAID/INSURANCE LISTING",!!
RANGE ; -- ask if user wants current inpts or range of disch dates
 K DIR S DIR("A")="Select Report Type"
 S DIR(0)="SO^1:CURRENT INPATIENTS ONLY;2:BY DISCHARGE DATE"
 D ^DIR G Q:$D(DIRUT) S DGT=Y
 I DGT=1 D 1 I $D(DIRUT) D Q Q
 I DGT=2 D 1,2 I $D(DIRUT) D Q Q
 ;
ZIS ; -- select device    
 S %ZIS="PQ" D ^%ZIS G:POP Q I $D(IO("Q")) D TM Q
 S X=$S(DGT=2:"DATE^ADGWMM1",DGW=0:"WALL^ADGWMM1",1:"WONE^ADGWMM1") D @X
 Q
 ;
TM ; -- queued outputs
 S ZTRTN=$S(DGT=2:"DATE^ADGWMM1",DGW=0:"WALL^ADGWMM1",1:"WONE^ADGWMM1")
 S ZTIO=ION,ZTDESC="WARD MEDICAID/MEDICARE REPORT"
 F I="DGT","DGW","DGBD","DGED" S ZTSAVE(I)=""
 D ^%ZTLOAD
 D HOME^%ZIS G Q
 ;
 ;
1 ; -- current inpts only: all or one ward
 NEW DIR S DIR(0)="Y0",DIR("B")="NO"
 S DIR("A")="Print for ALL WARDS" D ^DIR Q:$D(DIRUT)
 I Y=1 S DGW=0 Q
 ; -- select ward
 NEW DIR S DIR(0)="PO^42:EMQ" D ^DIR Q:$D(DIRUT)  S DGW=$P(Y,U,2)
 Q
 ;
2 ; -- discharge date range
 Q:$D(DIRUT)
 K DIR S DIR(0)="DO^::EQ",DIR("A")="Enter Earliest DISCHARGE DATE"
 D ^DIR Q:$D(DIRUT)  S DGBD=Y
 K DIR S DIR(0)="DO^::EQ",DIR("A")="Enter Latest DISCHARGE DATE"
 D ^DIR Q:$D(DIRUT)
 I Y<DGBD D  G 2
 . W !!,*7,"Ending date cannot be earlier than beginning date!"
 . W !,"Let's start over . . ",!
 S DGED=Y
 Q
 ;
Q ; -- cleanup
 I $G(DGSTOP)="",IOST["C-" D PRTOPT^ADGVAR
 D ^%ZISC
 K DGT,DGW,DGTYP,DGBD,DGED,DIR
 K W,R,I,D,MCRN,MCDN,INSNM,INSN,ED,EED,DFN,IFN,X,Y,DIC,DIC(0),T,LN Q
