ABPAPD2B ;PVT-INS PYMT ENTRY CONTINUED; [ 07/10/91  12:02 PM ]
 ;;1.4;AO PVT-INS TRACKING;*0*;IHS-OKC/KJR;JULY 25, 1991
DIC1 K DIC,DIE,DR,DA,%DT S DA(1)=ABPATDFN
 I $D(^ABPVAO(DA(1),"P",0))=0 D
 .S ^ABPVAO(DA(1),"P",0)="^9002270.22DA^^0"
 S DIC="^ABPVAO("_DA(1)_",""P"",",DIC(0)="LXZ"
 S X=ABPABDT D ^DIC
 I +$P(Y,U,3)=0 D  G @ABPACONT
 .W !!?5,*7,"*** PAYMENT ALREADY ON FILE FOR THIS BATCH DATE ***"
 .W !!,"DO YOU WANT TO CREATE ANOTHER ENTRY" S %=2
 .K ABPACONT D YN^DICN
 .I +%'=1 L ^ABPVAO(ABPATDFN) S ABPACONT="^ABPAPD1" Q
 .S X=""""_ABPABDT_"""" D ^DIC S ABPACONT="DIE1"
DIE1 K DIC,DIE,DR,DA S ABPADDFN=+Y,DA(1)=ABPATDFN,DA=ABPADDFN
 S DIE="^ABPVAO("_DA(1)_",""P"",",DR="1///T;1.01///"_DUZ
 S DR=DR_";1.03///T;1.05///"_DUZ D ^DIE
 ;S:ABPAOPT(1)="Y" DR=DR_";.03" W ! D ^DIE
 F I=0:0 D  Q:(GOTCHECK)!(('GOTCHECK)&((Y="")!(Y["^")))  W *7," ??"
 .D MAIN^ABPACKLK I GOTCHECK D
 ..S DR=".05///"_ABPACHK("NUM") D ^DIE D ^ABPAPD2C
 ..S X=ABPACHK("RAMT") D COMMA^%DTC S Y=X
 ..S X="*** Check #"_ABPACHK("NUM")_" has a remaining balance of $"
 ..S X=X_Y_"***" W !?(40-($L(X)/2)),X Q
 I 'GOTCHECK I Y'="" D  G ^ABPAPD1
 .W *7,!!?10,"NO CHECK SELECTED -- CANCELLING THIS ENTRY..." H 2
 .S DIK="^ABPVAO("_DA(1)_",""P""," D ^DIK
 .L ^ABPVAO(ABPATDFN)
 W ! I $D(^ABPVAO(ABPATDFN,"P",ABPADDFN,"A",0))=0 D
 .S ^ABPVAO(ABPATDFN,"P",ABPADDFN,"A",0)="^9002270.223A^^0"
DIR K DIR,X,Y,ABPA("ANS")
 S DIR(0)="FO^2:15",DIR("A")="  PAYMENT AMOUNT"
 S DIR("?",1)="Enter a dollar amount between .01 and 999999. You may "
 S DIR("?",1)=DIR("?",1)_"use the 'fast entry'"
 S DIR("?",2)="method if you wish by following the dollar amount with "
 S DIR("?",2)=DIR("?",2)_"the TYPE OF PAYMENT"
 S DIR("?",3)="(1:Standard 2:Deductible 3:Non-covered 4:Penalty) and "
 S DIR("?",3)=DIR("?",3)_"CLAIM ASSIGNMENT"
 S DIR("?",4)="separated by commas. Entering 20.13,2,"_ABPACCNT
 S DIR("?",4)=DIR("?",4)_" for example, creates a $20.13"
 S DIR("?",5)="transaction assigned to the last claim currently "
 S DIR("?",5)=DIR("?",5)_"displayed.",DIR("?")=" " D ^DIR
 S ABPA("ANS")=Y
 I +Y=0 I $E(Y)'="""" K DA S Y=-1,DA(1)=ABPATDFN,DA=ABPADDFN G NOENT
 K DIC,DIE,DA,DR S DA(1)=ABPATDFN,DA=ABPADDFN,X=$P(ABPA("ANS"),",")
 S DIC="^ABPVAO("_DA(1)_",""P"","_DA_",""A"",",DIC(0)="LQ" D ^DIC
NOENT I +Y<0&(+$P(^ABPVAO(DA(1),"P",DA,"A",0),"^",4)'>0) D  G ^ABPAPD1
 .W *7,!!?10,"NO PAYMENTS ENTERED -- CANCELLING THIS ENTRY..." H 2
 .S DIK="^ABPVAO("_DA(1)_",""P""," D ^DIK
 .L ^ABPVAO(ABPATDFN)
 G:+Y<0 DIE3 I +$P(Y,U,3)=0 D  G DIR
 .W *7,!!?5,"You have already made an entry of this amount. If you"
 .W !?5,"need to make another entry of the same amount for a"
 .W !?5,"different type, please put quotes around the amount."
 .W !!?20,"i.e.   ""48.23"""
DIE2 K DIC,DIE,DA,DR S DA=+Y,DA(1)=ABPADDFN,DA(2)=ABPATDFN
 S DIE="^ABPVAO("_DA(2)_",""P"","_DA(1)_",""A"",",DIE("NO^")=""
 S DIE("W")="W !,$J($P(DQ(DQ),""^""),16),"": """
 S DR="1//STANDARD" I $P(ABPA("ANS"),",",2)]"" D
 .Q:+$E($P(ABPA("ANS"),",",2))<1!(+$E($P(ABPA("ANS"),",",2))>4)
 .D @(+$E($P(ABPA("ANS"),",",2)))
 D ^DIE S ABPACOD=X K DIR I ABPACCNT=1 D  G DIR
 .S DR="2///"_ABPA("C",1) D ^DIE
 S X=+$P(ABPA("ANS"),",",3) I X'>0 D
 .S DIR(0)="NO^1:"_ABPACCNT,DIR("A")="CLAIM ASSIGNMENT" D ^DIR
 G:'X&(ABPACOD'="P") DIR I 'X D  G DIR
 .W *7,!?5,"<<< PENALTYS MUST BE APPLIED - TRANSACTION DELETED >>>"
 .K DIK S DIK="^ABPVAO("_DA(2)_",""P"","_DA(1)_",""A""," D ^DIK
 G:$D(ABPA("C",X))'=1 DIR S DR="2///"_ABPA("C",X) D ^DIE G DIR
DIE3 K DIC,DIE,DA,DR S DA=ABPADDFN,DA(1)=ABPATDFN
 S DIE="^ABPVAO("_DA(1)_",""P"",",DR="4///N;5///"_DT D ^DIE
CONT G ^ABPAPD3
1 S DR="1///S" Q
2 S DR="1///D" Q
3 S DR="1///N" Q
4 S DR="1///P" Q
