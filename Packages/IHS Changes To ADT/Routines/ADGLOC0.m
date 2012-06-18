ADGLOC0 ; IHS/ADC/PDW/ENM - LOCATOR CARD ; [ 03/25/1999  11:48 AM ]
 ;;5.0;ADMISSION/DISCHARGE/TRANSFER;;MAR 25, 1999
 ;
 N DFN,IFN,Y
 S DIC="^DPT(",DIC(0)="AQZEM",DIC("A")="Select PATIENT NAME: "
 D ^DIC K DIC G:Y'>0 Q S DFN=+Y
A ;EP; -- main
 S IFN=$S($G(IFN):IFN,1:0)
 N X S X=$S(IFN:"ASK",1:1) D @X I 'IFN D Q Q
 D DEV I POP D Q Q
 I $D(IO("Q")) D QUE,Q Q
 D ^ADGLOC1,Q Q
 ;
EN(DFN,IFN)        ;EP
 D A Q
 ;
ASK ; -- print?
 S DIR(0)="Y",DIR("A")="Print Locator Card",DIR("B")="YES"
 D ^DIR S:'Y IFN=0 Q
 ;
1 ; --  admission
 N ID,Y,I,J,X
 I '$D(^DGPM("APCA",DFN)) W !?5,"No admissions on file." S IFN=0 Q
 W !!,"Admission(s)" S I=0
 S ID=0 F  S ID=$O(^DGPM("ATID1",DFN,ID)) Q:'ID  D
 . S IFN=0 F  S IFN=$O(^DGPM("ATID1",DFN,ID,IFN)) Q:'IFN  D
 .. S Y=+^DGPM(IFN,0),I=I+1,J(I)=IFN X ^DD("DD") W !?5,I,".  ",Y
 I I=1 S IFN=J(I) Q
 K DIR S DIR("B")=1,DIR("A")="Select One",DIR(0)="NO^1:"_I D ^DIR
 I Y="" S IFN=J(1) Q
 I $D(DIRUT)!(Y=-1) S IFN=0 Q
 S IFN=J(X) Q
 ;
DEV ; -- select device
 W ! S %ZIS="PQ" D ^%ZIS Q
 ;
QUE ; -- queued output
 S ZTRTN="^ADGLOC1",ZTDESC="PRINT FORM 44-1A"
 N I F I="DFN","IFN" S ZTSAVE(I)=""
 D ^%ZTLOAD,^%ZISC K ZTSK,IO("Q") Q
 ;
Q ; -- cleanup
 D ^%ZISC Q
