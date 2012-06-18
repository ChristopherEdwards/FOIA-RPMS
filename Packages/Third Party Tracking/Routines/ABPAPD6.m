ABPAPD6 ;EDIT PAYMENT TRANSACTIONS; [ 06/25/91  4:54 PM ]
 ;;1.4;AO PVT-INS TRACKING;*0*;IHS-OKC/KJR;JULY 25, 1991
A0 W !,"Select TRANSACTION #// " D SBRS
 I $D(DFOUT)!$D(DTOUT)!$D(DLOUT)!$D(DUOUT) G DISP^ABPAPD3
 I $D(DQOUT) D  G A0
 .W !!?10,"Enter the payment TRN number you wish to edit as it is"
 .W !?10,"listed in the far left column of the 'Payment Information'"
 .W !?10,"section of the edit screen above.",!
 K DIE,DA,DR S DA(2)=ABPATDFN,DA(1)=ABPADDFN,ABPAADFN=+Y,DA=+Y
 I $D(^ABPVAO(DA(2),"P",DA(1),"A",DA,0))'=1 D  G A0
 .W *7,!!?10,"<<< TRANSACTION NOT FOUND >>>",!
 D ^ABPAPD2C S DA(2)=ABPATDFN,DA(1)=ABPADDFN,DA=ABPAADFN
 S DIE="^ABPVAO("_DA(2)_",""P"","_DA(1)_",""A"",",DR=".01;1"
 S DIE("NO^")="" W ! D ^DIE G:$D(DA)'=11 DISP^ABPAPD3
 I ABPACCNT=1 D  G DISP^ABPAPD3
 .S DR="2///"_ABPA("C",1) D ^DIE
 K DIR S DIR(0)="NO^1:"_ABPACCNT,DIR("A")="Apply to which claim"
 S ABPATPTR=$P(^ABPVAO(DA(2),"P",DA(1),"A",DA,0),"^",3)
 F ABPA("I")=1:1 Q:$D(ABPA("C",ABPA("I")))'=1!($D(DIR("B"))=1)  D
 .S:ABPA("C",ABPA("I"))=ABPATPTR DIR("B")=ABPA("I")
 D ^DIR G:'X&(X'["@") DISP^ABPAPD3
 I X["@" S DR="2///@" D ^DIE G DISP^ABPAPD3
 G:$D(ABPA("C",X))'=1 DISP^ABPAPD3 S DR="2///"_ABPA("C",X) D ^DIE
 G DISP^ABPAPD3
SBRS K DFOUT,DTOUT,DUOUT,DQOUT,DLOUT
 R Y:DTIME I '$T W *7 R Y:5 G SBRS:Y="." I '$T S (DTOUT,Y)="" Q
 I Y="/.," S (DFOUT,Y)="" Q
 I Y="" S DLOUT="" Q
 I Y="^" S (DUOUT,Y)="" Q
 I Y?1"?".E!(Y["^") S (DQOUT,Y)="" Q
 Q
