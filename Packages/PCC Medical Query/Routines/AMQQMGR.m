AMQQMGR ; IHS/CMI/THL - MANAGER'S UTILITIES ;
 ;;2.0;IHS PCC SUITE;;MAY 14, 2009
 ;-----
 S IOP=0
 D ^%ZIS
 S X=$P(^AMQQ(8,DUZ(2),0),U,6)
 F %=3,6,16 S AMQQ200(%)=$S(X:"^VA(200)",1:("^DIC("_%_")"))
MENU ;
 I '$O(^AMQQ(8,0)) D INIT I '$O(^AMQQ(8,0)) Q
 S DIC="^AMQQ(8,"
 S DIC(0)=""
 S X="`"_DUZ(2)
 D ^DIC
 K DIC
 I Y=-1 W !!,*7,"DUZ(2) MUST BE SET TO THE FACILITY INDICATED IN THE QMAN SITE PARAMETERS FILE!" H 2 Q
ASK W !! S DIR(0)="SO^1:CHECK security keys;2:DEVICE management;3:INDEX setup;4:INTEG check;5:LAB setup;6:LOG of queries;7:SECONDARY facilities;8:DELETE Search Template;9:HELP;0:EXIT"
 ;W !! S DIR(0)="SO^1:CHECK security keys;2:DEVICE management;3:INDEX setup;4:INTEG check;5:LAB setup;6:LOG of queries;7:SECONDARY facilities;8:DELETE Search Template;9:HELP;11:IMMunizaiton Update;0:EXIT"
 S DIR("??")="AMQQMGR"
 S DIR("A")=$C(10)_"     Your choice"
 S DIR("?")="Enter a code from the list or type '??' for more information"
 D ^DIR
 K DIR
 D CHK
 I $D(AMQQQUIT) G EXIT
 I Y=0 G EXIT
 I Y=9 W !!,"Enter a code from the list or type '??' for more information." G ASK
 D @("M"_Y)
 I '$D(AMQQQUIT) G MENU
EXIT K AMQQQUIT,X,Y,%,AMQQMGRL,AMQQMGRN,AMQQMGRS,AMQQMGRF,AMQQLSSX
 Q
 ;
CHK I $D(DTOUT)+$D(DUOUT)+(Y=-1)+(Y="") K DIRUT,DUOUT,DTOUT S AMQQQUIT="" Q
 Q
M1 ;
 D ^%ZIS
 I POP W:$D(IOF) @IOF Q
 U IO
 W:IOST["C-" @IOF
 W ?15,"*****  SECURITY KEY ASSIGNMENT CRITERIA  *****",!!
 W "Q-MAN DEMOGRAPHIC DATA ACCESS   Key = AMQQZMENU  Assign to all Q-Man users",!
 W "Q-MAN CLINICAL DATA ACCESS  Key = AMQQZCLIN  Assign to health professionals only",!
 W "Q-MAN PROGRAMMER ACCESS  Key = AMQQZPROG  Assign to PCC developers only",!
 W "Q-MAN MANAGERS UTILITIES   Key = AMQQZMGR   Only the site manager should hold it"
 W "PROMPT FOR WHO REPORT IS FOR   Key = AMQQZRPT   Assign to users running reports",!,"for others"
 S AMQQMGRL=6
 S Z=""
 F X="AMQQZMENU^Q-MAN ACCESS","AMQQZCLIN^CLINICAL DATA ACCESS","AMQQZPROG^Q-MAN PROGRAMMER ACCESS","AMQQZMGR^SITE MANAGER'S UTILITIES","AMQQZRPT^REPORT GENERATORS" D KEY I $G(Z)=U G M10
 I IOST["C-" R !,"<Press the ENTER key to go on>",X:DTIME K DUOUT,DTOUT,DIRUT Q
M10 W @IOF
 K AMQQMGRL
 D ^%ZISC
 Q
 ;
KEY S AMQQMGRL=AMQQMGRL+3
 W !!,?10,"*****  ",$P(X,U,2),"  *****",!
 S X=$P(X,U)
 F %=0:0 S %=$O(^XUSEC(X,%)) Q:'%  S AMQQMGRL=AMQQMGRL+1 W ! D WAIT Q:$G(Z)=U  W $S($D(@AMQQ200(3)@(%,0)):$P(^(0),U),1:(%_"  ??"))
 Q
 ;
WAIT I (AMQQMGRL<(IOSL-3)) Q
 S AMQQMGRL=0
 I IOST'["C-" W IOF Q
 R "<>",Z:DTIME E  S AMQQQUIT="",%=99999999999 W @IOF Q
 W @IOF
 Q
 ;
M2 D ^AMQQMGR5
 Q
 ;
M7 W @IOF,!!,?20,"*****  SECONDARY FACILITIES  *****",!!
 W !,"Normally, when the user requests patient reports, s/he will only see the chart"
 W !,"number at this facility.  The user may request other chart numbers provided"
 W !,"that you enter the other local facilities now.  You may enter up to three",!,"facilities, but do not enter this one!",!
 I $P(^AMQQ(8,DUZ(2),0),U,2) W !,"OTHER FACILITIES' CHART NUMBERS NOW DISPLAYED =>",! D
 .F %=2:1:4 Q:'$P(^AMQQ(8,DUZ(2),0),U,%)  W !,$P(^DIC(4,$P(^(0),U,%),0),U)
ASKFAC .W !!,"You may recreate this list if you want.  Do you want to remove this list"
 .W !,"and enter other local facilities"
 .S %=2
 .D YN^DICN
 .G:%=0 ASKFAC
 .I %=-1!(%=2) S AMQQSTP=""
 I $D(AMQQSTP) K AMQQSTP Q
 W !
 I $P(^AMQQ(8,DUZ(2),0),U,2) D
 .S DA=DUZ(2)
 .S DIE="^AMQQ(8,"
 .S DR=".02///@;.03///@;.04///@"
 .D ^DIE
 .K DIE,DR,DA
 .S DIE="^AMQQ(1,256,4,"
 .S DA=1
 .S DA(1)=256
 .S DR="4///@;5///@"
 .D ^DIE
 .K DIE,DR,DA
 S AMQQMGRF="@^@^@"
 F  D FAC Q:"^@"[X  I $G(AMQQMGRN)=3 Q
 I X="@" S AMQQMGRN=0 G SETM7
 I '+AMQQMGRF Q
SETM7 S %=AMQQMGRF
 S DA=DUZ(2)
 S DIE="^AMQQ(8,"
 S DR=".02////"_$P(%,U)_";.03////"_$P(%,U,2)_";.04////"_$P(%,U,3)
 D ^DIE
 K DIE,DR,DA
 S %=AMQQMGRN*10
 S DIE="^AMQQ(1,256,4,"
 S DA=1
 S DA(1)=256
 S DR="4///"_%_";5///"_%
 D ^DIE
 K DIE,DR,DA
 W !!,"Okay, the entered local facility or facilities' chart numbers will now appear"
 W !,"on all outputs"
 H 2
 K AMQQMGRF,AMQQMGRN,DIC
 Q
 ;
FAC S DIR(0)="PO^9999999.06:EMQ"
 D ^DIR
 I +Y=DUZ(2) W !,*7,"Enter a facility other than your local facility.",! G FAC
 I X=""!(X=U)!(X="@") Q
 D CHK
 I $D(AMQQQUIT) K AMQQQUIT Q
 S AMQQMGRN=$G(AMQQMGRN)+1
 S $P(AMQQMGRF,U,AMQQMGRN)=+Y
 Q
 ;
M3 D ^AMQQMGR1
 Q
 ;
M6 D ^AMQQMGR2
 Q
 ;
M4 D ^AMQQNTEG
 Q
 ;
M5 D ^AMQQMGR6
 Q
 ; 
VER W @IOF,!,?15,"*****  LAB RESULTS FOR Q-MAN  *****",!!
M51 W !
 S DIR(0)="SO^1:TOP 40 tests;2:INDIVIDUAL tests;3:VIEW Q-Man lab tests;9:HELP;0:EXIT"
 S DIR("A")=$C(10)_"Your choice"
 S DIR("??")="AMQQLABSTART"
 D ^DIR
 K DIR
 I Y=9 W !!,"Select a code from the list or type '??' for more info",!! G M51
 I 'Y Q
 I Y=1 D TOP^AMQQMGR4 G M5
 I Y=2 D GET^AMQQMGR4 G M5
 I Y=3 D LIST^AMQQMGR4 R !!,"<>",X:DTIME G M5
 G M5
 ;
INIT ;
 I '$D(DUZ(2)) W !!,"KERNEL VARIABLES NOT SET!!,",!! Q
 W !!,"Is the site where Q-Man is being installed ",$P(^DIC(4,DUZ(2),0),U)
 S %=0
 D YN^DICN
 I $E(%Y)?1A,"yYnN"[$E(%Y) D ISET
 K DUOUT,DTOUT,%,%Y
 Q
 ;
ISET I "nN"[$E(%Y) W !!,"Well then, you must log in again, and this time enter the correct site!",!!,*7 Q
 S X="`"_DUZ(2)
 S DIC="^AMQQ(8,"
 S DIC(0)="L"
 S DLAYGO=9009078
 D ^DIC
 I Y'=-1 D
 .S X="0:1;2:4;5:10;11:19;20:39;40:59;60:79;80:199"
 .X $P(^DD(9009078,30,0),U,5,99)
 .D:$D(X)
 ..S ^AMQQ(8,+Y,3)=X
 ..S DIK="^AMQQ(8,"
 ..S DIK(1)=30
 ..S DA=DUZ(2)
 ..D EN^DIK
 Q
 ;
TERMS ;EP;PROGRAMMER ENTRY POINT TO CREATE NEW METADICTIONARY ENTRIES
 S DIR(0)="NO^1:999"
 S DIR("A")="Enter the IEN to create"
 W !
 D ^DIR
 K DIR
 Q:'Y
 I $D(^AMQQ(5,Y)) W !!,"Entry already exists.",! G TERMS
 S IEN=+Y
 S DIC="^AMQQ(5,"
 S DIC(0)="AEMQZ"
 S DIC("A")="Pattern after which TERM: "
 W !
 D ^DIC
 K DIC
 Q:+Y<1
 S TERM=+Y
 S DIC="^AMQQ(1,"
 S DIC(0)="AEMQZ"
 S DIC("A")="Pattern after which LINK: "
 W !
 D ^DIC
 K DIC
 Q:+Y<1
 S LINK=+Y
 W !,"IEN: ",IEN," will be created patterned after"
 W !,"TERM: ",$P(^AMQQ(5,TERM,0),U)," and"
 W !,"LINK: ",$P(^AMQQ(1,LINK,0),U),"."
 S DIR(0)="YO"
 S DIR("A")="Are you certain"
 S DIR("B")="NO"
 W !
 D ^DIR
 K DIR
 Q:Y'=1
T1 M ^AMQQ(5,IEN)=^AMQQ(5,TERM)
 M ^AMQQ(1,IEN)=^AMQQ(1,LINK)
 Q
XXX F IEN=697,698 S TERM=690,LINK=690 D T1
 Q
M8 ;EP;TO DELETE A SEARCH TEMPLATE
 K AMQQQUIT
 F  D M81 Q:$D(AMQQQUIT)
 K AMQQQUIT
 Q
M81 ;
 W @IOF
 W !?10,"Qman Search Template Deletion Utility"
 W !!?10,"Select a Search Template to Delete.",!
 S DIC="^DIBT("
 S DIC(0)="AEMQZ"
 S DIC("A")="Delete which Template: "
 W !
 D ^DIC
 I Y<0 S AMQQQUIT="" Q
 S AMQQDA=+Y
 S X=$P(^DIBT(+Y,0),U)
 S DIR(0)="YO"
 S DIR("A")="Sure you want to delete Search Template ** "_X_" **"
 S DIR("B")="NO"
 W !
 D ^DIR
 K DIR
 Q:Y'=1
 S DA=AMQQDA
 S DIK="^DIBT("
 D ^DIK
 K DA,DIK
 Q
M11 ;EP;TO UPDATE IMMUNIZATIONS ENTRIES IN THE QMAN DICTIONARY OF TERMS
 D IMM^AMQQMGR9
 Q
