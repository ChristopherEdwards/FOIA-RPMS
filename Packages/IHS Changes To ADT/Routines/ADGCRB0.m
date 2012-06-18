ADGCRB0 ; IHS/ADC/PDW/ENM - A SHEET driver ; [ 03/25/1999  11:48 AM ]
 ;;5.0;ADMISSION/DISCHARGE/TRANSFER;;MAR 25, 1999
 ;
 S DIC="^DPT(",DIC(0)="AQZEM",DIC("A")="Select PATIENT NAME: "
 D ^DIC K DIC G:Y'>0 Q S DFN=+Y
MAIN ; -- main
 I '$D(DFN)!('$D(^DPT(DFN,0)))!('$D(^AUPNPAT(DFN,0))) Q
 S DGDS=0,DGFN=$S($G(DGFN):$G(DGFN),1:0)
 ;D ASK:DGFN,1:'DGFN I 'DGFN D Q Q
 N X S X=$S(DGFN:"ASK",1:1) D @X I 'DGFN D Q Q
 D BOT I $D(DIRUT) D Q Q
 D NOC I $D(DIRUT) D Q Q
 D ZIS I POP D Q Q
 I $D(IO("Q")) D QUE,Q Q
 D A,Q Q
 ;
EN(DFN,DGFN) ;EP; -- predefined DFN entry point
 D MAIN Q
 ;
ASK ; -- print?
 S DIR(0)="Y",DIR("A")="Do you want to print A sheet",DIR("B")="YES"
 D ^DIR S:'Y DGFN=0 Q
 ;
A U IO F DGZCNT=1:1:DGZC D
 . D ^ADGCRB1
 . I $D(DGZP) D ^ADGCRB5 D:DGVSDA ^ADGCRB6   ;2nd half (clinical data)
 . D:$D(DGZN) ^ADGCRB7 W @IOF                ;2nd half (form outline)
 Q
 ;
1 ; --  admission
 N I,J,ID,Y,X
 I '$D(^DGPM("APCA",DFN)) D  Q
 . W !?5,"No admissions on file." D PRTOPT^ADGVAR
 W !!,"Admission(s)" S I=0
 S ID=0 F  S ID=$O(^DGPM("ATID1",DFN,ID)) Q:'ID  D
 . S DGFN=0 F  S DGFN=$O(^DGPM("ATID1",DFN,ID,DGFN)) Q:'DGFN  D
 .. S Y=+^DGPM(DGFN,0),I=I+1,J(I)=DGFN X ^DD("DD") W !?5,I,".  ",Y
 I I=1 S DGFN=J(I) Q
 K DIR S DIR("B")=1,DIR("A")="Select One",DIR(0)="NO^1:"_I D ^DIR K DIR
 I Y="" S DGFN=J(1) Q
 I $D(DIRUT)!(Y=-1) S DGFN=0 Q
 S DGFN=J(+Y)
 Q
 ;
BOT ; -- bottom half form?
 Q:$D(DGZP)  K DIR,DGZN W !
 S DIR("A")="Print bottom half of form"
 S DIR("B")=$S($G(DGDS):"NO",1:"YES"),DIR("?")="",DIR(0)="Y"
 S DIR("?",1)="Enter YES if you wish to print the headings for"
 S DIR("?",2)="         the second half of the A Sheet form,"
 S DIR("?",3)="Enter NO to leave second half blank."
 D ^DIR S:Y DGZN="" Q
 ;
NOC ; -- number of copies
 K DIR S DIR(0)="N^1:10",DIR("B")=1 S DIR("A")="Print How Many Copies"
 D ^DIR S DGZC=Y Q
 ;
ZIS ; -- select device
 S %ZIS="PQ" D ^%ZIS Q
 ;
QUE ; -- queued output
 S ZTRTN="A^ADGCRB0",ZTDESC="PRINT FORM 44-1"
 F I="DFN","DGDS","DGFN","DGZC","DGZN","DGZP" S ZTSAVE(I)=""
 D ^%ZTLOAD Q
 ;
Q ; -- cleanup
 K DGFN,DGZC,ZTSK,X,Y,DIC,IO("Q"),DGZCNT,%ZIS,DGLIN,DGLIN1,DIR
 K DGVSDA,DGPOVN0,DGPOVDA,DGN,DGN0,DGN11,DGN21,DGN33,DGDS,DFN,DGZP
 D ^%ZISC,HOME^%ZIS Q
 ;
DS ;EP; -- day surgery
 S DIC="^DPT(",DIC(0)="AQZEM",DIC("A")="Select PATIENT NAME: "
 D ^DIC K DIC G:Y'>0 Q S DFN=+Y
DS1 ;EP; -- ds main
 D DSSD I Y<1 D Q Q
 I $$DSV^ADGCRB5 S DGZP="" K DGZN
 D BOT I $D(DIRUT) D Q Q
 D NOC I $D(DIRUT) D Q Q
 D ZIS I POP D Q Q
 I $D(IO("Q")) D QUE,Q Q
 D A,Q Q
 ;
DSSD ; -- select day surgery date
 I '$D(^ADGDS(DFN,"DS")) D  S Y=0 Q
 . W !,"No Day Surgery for ",$P(^DPT(DFN,0),U),!
 S DIC="^ADGDS("_DFN_",""DS"",",DIC(0)="AEFMNQ"
 S DIC("B")=$S($D(^ADGDS(DFN,"DS",0)):$P(^(0),U,3),1:"")
 D ^DIC S DGDS=+Y
 Q
 ;
EN1 ;EP; -- A Sheet by Admission date
 W @IOF,!!!?24,"PRINT A SHEETS BY ADMISSION DATE",!! S DGDS=0
 D DT I X["^"!($D(DTOUT))!(X="") D Q Q
 D BOT I $D(DIRUT) D Q Q
 D NOC I $D(DIRUT) D Q Q
 D ZIS I POP D Q Q
 I $D(IO("Q")) D QUE1,Q Q
EN2 D LP1,Q Q
 ;
QUE1 ; -- queued output
 S ZTRTN="EN2^ADGCRB0",ZTDESC="PRINT FORM 44-1"
 F I="DFN","DGDS","DGFN","DGZC","DGZN" S ZTSAVE(I)=""
 D ^%ZTLOAD Q
 ;
DT ; -- Admission date
 S %DT="AEQ",%DT("A")="Select admission date: " D ^%DT  Q:Y<0
 S SD=Y-.0001,ED=Y+.2400 Q
 ;
LP1 ; -- loop admission date
 S DGDT=SD F  S DGDT=$O(^DGPM("AMV1",DGDT)) Q:'DGDT!(DGDT>ED)  D
 . S DFN=0 F  S DFN=$O(^DGPM("AMV1",DGDT,DFN)) Q:'DFN  D
 .. S DGFN=0 F  S DGFN=$O(^DGPM("AMV1",DGDT,DFN,DGFN)) Q:'DGFN  D A
 Q
