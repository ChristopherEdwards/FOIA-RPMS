AMQQAT1 ; IHS/CMI/THL - GETS INFO FOR RANDOM SAMPLE COLLECTION ;
 ;;2.0;IHS PCC SUITE;;MAY 14, 2009
 ;-----
 I $D(AMQQCHRT) W !!,"You cannot select a RANDOM SAMPLE and a SEARCH COHORT in the same query",!!,*7 K AMQQRAND Q
VAR S %=$S(AMQQCCLS="P":"^DPT",1:"^AUPNVSIT")
 S AMQQRNDN=$P(@%@(0),U,4)\2
 S AMQQRCNM=$S(AMQQCCLS="P":"PATIENT",1:"VISIT")
 D NP
EXIT K AMQQRNDN,AMQQRCNM,%,I
 Q
 ;
NP W !!,"There are ",(AMQQRNDN*2)," ",AMQQRCNM,"S in the database"
 W !!?5,"1) Select a certain number of ",AMQQRCNM,"S for the sample"
 W !?5,"2) Select a certain percentage of ",AMQQRCNM,"S for the sample",!
GET ; ENTRY POINT FROM AMQQAT11
 R !,"YOUR CHOICE (1-2): 1// ",X:DTIME E  S X=U
 I X?1."?" W !!,"Enter 1 or 2.  You may enter '^' to exit.",!! G GET
 I X=U S AMQQQUIT="" Q
 I X="" S X=1 W "  (1)"
 I X,X<3,$D(AMQQCRFL) K AMQQCRFL Q
 I X,X<3 D SET Q
 W "  ??",*7 G GET
 Q
 ;
SET D @("S"_X)
 I Y=-1 Q
 S ^UTILITY("AMQQ",$J,"LIST",.2)="W ?6,""A RANDOM SAMPLE OF "_$S(AMQQCNAM'["RANDOM":AMQQCNAM,1:$P(AMQQCNAM," ",4))_" WILL BE USED"""
 S AMQQRAND=(AMQQRNDN*2)_";"_Y
 S AMQQRNDF=""
 D LIST^AMQQ
 Q
 ;
S1 ; ENTRY POINT FROM AMQQAT11
 W !!,"How many ",AMQQRCNM,"S do you want in the sample: "
 R X:DTIME E  S X=U
 I X=U S Y=-1,AMQQQUIT="" Q
 I X="" S Y=-1 Q
 I X?1."?" W !!,"Enter a number between 1 and ",AMQQRNDN,!! G S1
 I X,X'>(AMQQRNDN),X?1.9N S Y=X Q
 W "  ??",*7
 G S1
 ;
S2 ; ENTRY POINT FROM AMQQAT11
 W !!,"What percent of the patients do you want in the sample: "
 R X:DTIME E  S X=U
 I X=U S Y=-1,AMQQQUIT="" Q
 I X="" S Y=-1 Q
 I X?1."?" W !!,"Enter a number between 1 and 50" G S2
 I X?1.2N,X,X<51 Q:$D(AMQQRCFL)  S Y=AMQQRNDN*X\50 W "%" Q
 W "  ??",*7
 G S2
 ;
COHORT ; ENTRY POINT FOR SEARCH TEMPLATE COHORTS
 S AMQQRCNM=$S(AMQQCCLS="P":"PATIENT",1:"VISIT")
 I AMQQATNM="FILE ENTRY" D ^AMQQAT2 Q
 I $D(AMQQRAND) W !!,"You cannot select a RANDOM SAMPLE and a SEARCH COHORT in the same query",!!,*7 K AMQQCHRT Q
 I '$D(AMQQCHRT),'$D(AMQQYYYY) S DIC="^DIBT(",DIC(0)="AEQ" G CODIC
 I $D(AMQQYYYY) S AMQQCHRT=$P(AMQQYYYY,";",3)
 S X=$E(AMQQCHRT,2,99)
 I $E(X,$L(X))="]" S X=$E(X,1,$L(X)-1)
 S DIC="^DIBT("
 S DIC(0)="EQ"
 K AMQQCHRT
 I $D(AMQQXX) S DIC(0)=""
CODIC S DIC("S")="S %=$P(^(0),U,4) I %=2!(%=9000001)"
 S %=$P(^AMQQ(1,AMQQLINK,0),U,2)
 I %'=2 S DIC("S")="I $P(^(0),U,4)="_%
 D ^DIC
 K DIC
 I Y=-1,X=U S AMQQQUIT="" Q
 I Y=-1 Q
 S AMQQCHRT=+Y,X=$P(Y,U,2)
 D COEX
 Q
 ;
COEX I $D(AMQQXX) S X=1 Q
 I '$D(^DIBT(AMQQCHRT,1)) W !!,"Sorry, this template is empty!!",!!,*7 S AMQQQUIT="" H 3 Q
 W !!,"Select one of the following =>",!!?5
 W "1) ",AMQQCNAM," must be a member of the ",X," cohort",!?5
 W "2) ",AMQQCNAM," must NOT be a member of the ",X," cohort",!?5
 W "3) Select a random sample of the ",X," cohort",!?5
 W "4) Count the number of entries in the ",X," cohort",!!
CQ W "Your choice (1-4): 1// " R X:DTIME E  S X=U
 I X=4 D COUNT^AMQQAT11 G COEX
 I X="" S X=1
 I $E(X)=U S AMQQQUIT="" Q
 I X?1N,X,X<5 G CQ1
 W "  ??",*7,!
 G CQ
CQ1 I X=2 S AMQQLINK=$S(AMQQCCLS="P":151,1:85) Q
 I X=1 Q
 D CNP
 Q
 ;
CNP S AMQQCRFG=""
 D COUNT^AMQQAT11
 K AMQQCRFG
 S AMQQCHTT=I
 S AMQQRNDN=AMQQCHTT\2
CNP1 ; ENTRY POINT FROM AMQQAT2
 D ^AMQQAT11
 Q
 ;
