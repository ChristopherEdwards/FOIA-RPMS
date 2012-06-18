AMQQQE ; IHS/CMI/THL - SCRIPT EDITOR ;
 ;;2.0;IHS PCC SUITE;;MAY 14, 2009
 ;-----
LOOP F  D SEL I $D(AMQQQUIT) Q
 Q
 ;
SEL S Y=5
 D CHKOUT I  Q
 I Y=-1 Q
 I Y=0 S AMQQQUIT="" Q
 W !!
 D @$P("COPY^EDIT^IMPORT^PURGE^RUN^VIEW^WRITE^^HELPME",U,Y)
 Q
EXIT K X,Y,%,%Y,AMQQXX,AMQQYY,AMQQFAIL,I
 Q
 ;
WRITE S DIR("A")="Script name"
 K AMQQFAIL
W1 W !
 S DIR(0)="9009072,.01"
 D ^DIR
 K DIR
 D CHKOUT
 I  Q
CR1 ; ENTRY POINT FROM AMQQE1
 S Y=$O(^AMQQ(2,"B",X,""))
 S Y=$S('Y:-1,1:(Y_U_X))
 I Y=-1 D ADD Q
 I DUZ'=$P(^AMQQ(2,+Y,0),U,2) W !!,*7,"This script already exists...Try another name.",!! G WRITE
 W !!,*7,"This script already exists.  Want to overwrite"
 S %=2
 D YN^DICN
 I $D(DTOUT)+$D(DUOUT) Q
 I "Nn"[$E(%Y) W ! G WRITE
 S DIK="^AMQQ(2,"
 S DA=+Y
 S AMQQQENA=$P(Y,U,2)
 D ^DIK
 K DIK,DA,DIC
 S X=AMQQQENA
 K AMQQQENA
ADD W !!
 S DIC="^AMQQ(2,"
 S DIC(0)="L"
 S DIC("DR")="1////"_DUZ_";2///"_DT_";5"
 I $D(AMQQESN) S DIC("DR")="1////"_DUZ_";2///"_DT
 D ^DIC
 K DIC
 I $D(AMQQESN) Q
 I $D(DUOUT)+$D(DTOUT)+(Y=-1) K DUOUT,DTOUT Q
 I '$P($G(^AMQQ(2,+Y,1,0)),U,4) S AMQQQUIT="" Q
COMPILE ; ENTRY POINT FROM ^AMQQQE1
 S AMQQXX="^AMQQ(2,"_+Y_",1,"
 S AMQQYY=Y
 W !!
 D WAIT^DICD
 W !!
 D SEARCH^AMQQ
 I $D(AMQQFAIL) D FAIL K AMQQFAIL S AMQQQUIT="" G PAUSE
 I $D(AMQQQUIT) Q
 W !,"OK, I have saved your script """,$P(AMQQYY,U,2),""" and its compiled"
 W !,"search code in the Q-Man Script file.  It is ready for use at any time!"
PAUSE W !!! S DIR(0)="E" D ^DIR K DIR
 Q
 ;
FAIL S %=AMQQFAIL
 S %=$S(%<5:"SUBJECT",%=5:"TAXONOMY",%=6:"ATTRIBUTE",%=7:"CONDITION",8:"VALUE",9:"OR GROUP",1:"SUBQUERY")
 W !!,"Script error detected...Unable to compile...Request terminated"
 W !,"Source of error: ",%,!,"Use the EDIT function to correct script error.",*7
 K AMQQFAIL
 Q
 ;
HELPME W !!!,"Select a code from the list or type '??' for more information",!!
 S DIR(0)="E"
 D ^DIR
 K DIR
 Q
 ;
CHK ; ENTRY POINT FROM AMQQE1
 I +Y,$P($G(^AMQQ(2,+Y,0)),U,2)'=DUZ
 Q
 ;
GET S DIC("A")="Enter the name of the Q-Man script: "
 K AMQQFAIL
GET1 S DIC="^AMQQ(2,"
 S DIC(0)="AEQ"
 S DIC("S")="I $P($G(^AMQQ(2,Y,1,0)),U,4)"
 D ^DIC
 K DIC
CHKOUT I $D(DTOUT)+$D(DUOUT)+(Y=-1) K DIRUT,DUOUT,DTOUT S AMQQQUIT="" Q
 I Y="" S Y=-1 Q
 Q
 ;
RUN ;EP;TO RUN A SCRIPT
 W:$D(IOF) @IOF
 S DIC("A")="Enter the name of the search logic to be run: "
 S DIC="^AMQQ(2,"
 S DIC(0)="AEQ"
 D ^DIC
 K DIC
 D CHKOUT
 I  Q
 D RUN^AMQQQE1
 Q
 ;
PURGE D GET
 Q:$T
 D PURGE^AMQQQE1
 Q
 ;
VIEW D GET
 I  Q
 S (I,%)=0
 F  S %=$O(^AMQQ(2,+Y,1,%)) Q:'%  S I=I+1,Z="" W ! X:'(I#(IOSL-4)) "I I>1 W ""<>"" R Z:DTIME S:'$T Z=U W $C(13),?9,$C(13)" Q:Z=U  W ^(%,0)
 W !!
 S DIR(0)="E"
 D ^DIR
 K DIR
 Q
 ;
IMPORT D IMPORT^AMQQQE1
 Q
 ;
EDIT D GET
 Q:$T
 D EDIT^AMQQQE1
 Q
 ;
COPY S DIC("A")="Copy from what script: "
 D GET1
 Q:$T
 D COPY^AMQQQE1
 Q
 ;
STORE ; ENTRY POINT FROM AMQQCMPL
 S DIR("A")="Store logic under what name"
 S AMQQESN=""
 D W1
 I $D(AMQQQUIT) Q
 K AMQQESN
 S AMQQCPLF=""
 S AMQQYY=Y
 W "OK, I will store this search logic for future use.",!!!
 H 2
 Q
 ;
