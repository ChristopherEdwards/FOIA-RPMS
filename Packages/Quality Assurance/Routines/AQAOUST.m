AQAOUST ; IHS/ORDC/LJF - CHARTER QI TEAM ;
 ;;1.01;QAI MANAGEMENT;;OCT 05, 1995
 ;
 ;This rtn contains the user interface for creating and editing a
 ;QI team entry.  This includes assigning membership to QAI users.
 ;
TEAM ; >>> ask user for team name
 I $D(AQAOCOM) L -^AQAO1(1,AQAOCOM)
 W !! K DIC S DIC="^AQAO1(1,",DIC(0)="ALEMQZ",DLAYGO=9002169.1
 S DIC("A")="Select QI TEAM:  "
 L +(^AQAO1(1,0)):0 I '$T D  G EXIT
 .W !?5,"File is locked while another user adds an entry"
 S AQAOINAC="" D ^DIC K AQAOINAC L -(^AQAO1(1,0))
 G EXIT:$D(DTOUT),EXIT:X="",EXIT:$D(DUOUT),TEAM:Y=-1
 S AQAOCOM=Y
 L +^AQAO1(1,AQAOCOM):0 I '$T D  G TEAM
 .W !?5,"Another user editing this entry"
 ;
TEAMEDIT ; >>> edit team attributes
 K DIE S DIE="^AQAO1(1,",DA=+AQAOCOM,DR="[AQAO CHARTER TEAM]"
 D ^DIE
 ;
CURRENT ; >>> find all current members
 W @IOF,!!?20,"CURRENT MEMBERS IN ",$P(AQAOCOM,U,2),!!
 K AQAOCUR S X=0 ;get user ifn
 F  S X=$O(^AQAO(9,"AB",+AQAOCOM,X)) Q:X=""  D
 .S Y=0 ;get multiple in qi user file
 .F  S Y=$O(^AQAO(9,"AB",+AQAOCOM,X,Y)) Q:Y=""  S AQAOCUR(X)=Y
 ;
 I '$D(AQAOCUR) W !!,"NO CURRENT MEMBERS",! G ADD
 ;
 W !! S X=0
 F  S X=$O(AQAOCUR(X)) Q:X=""  D
 .S Z=$P(^AQAO(9,X,"TM",AQAOCUR(X),0),U,3) ;membership level
 .W !?2,$S(Z="L":"LEADER",1:"MEMBER"),":"
 .W ?12,$P(^VA(200,X,0),U) ;print name
 .S Y=$P(^AQAO(9,X,"TM",AQAOCUR(X),0),U,2) ;get access level
 .W ?40,"ACCESS LEVEL:  ",$S(Y=1:"INQUIRY ONLY",Y=2:"CREATE/EDIT",1:"")
 ;
EDIT ; >>> ask if user wants to edit or delete any current members
 W !! K DIR S DIR(0)="YO",DIR("B")="NO"
 S DIR("A")="Do you want to EDIT or DELETE any current members"
 D ^DIR G EXIT:Y="",ADD:Y=0
 ;
 W !!!,">>> MODIFY/DELETE MODE . . ."
CHOOSE1 W !! K DIC,DIR S DIC="^AQAO(9,",DIC(0)="AEMQZ"
 S DIC("S")="I $D(AQAOCUR(Y))" D ^DIC
 G EXIT:X=U,EXIT:$D(DTOUT),ADD:X="",CHOOSE1:Y=-1
 K DIE S DIE="^AQAO(9,"_+Y_",""TM"",",DA=AQAOCUR(+Y),DA(1)=+Y
 D DELETE S DR=".01:.03" D ^DIE
 G CHOOSE1
 ;
 ;
ADD ; >>> ask if user wants to add new members
 W !! K DIR S DIR(0)="YO",DIR("B")="NO"
 S DIR("A")="Do you want to ADD any new members"
 D ^DIR G EXIT:Y="",TEAM:Y=0
 ;
 W !!!,">>> ADD MODE . . ."
CHOOSE2 W !! K DIC,DIR S DIC="^AQAO(9,",DIC(0)="AEMQZ" D ^DIC
 G EXIT:X=U,EXIT:$D(DTOUT),TEAM:X="",CHOOSE2:Y=-1
 I '$D(^AQAO(9,+Y,"TM",0)) S ^(0)="^9002168.91P"
 K DIC S DIC="^AQAO(9,"_+Y_",""TM"",",DIC(0)="EMZQL",X=$P(AQAOCOM,U,2)
 S DA(1)=+Y,DIC("DR")=".02:.03" D ^DIC
 G CHOOSE2
 ;
 ;
EXIT ; >>> eoj
 I $D(AQAOCOM) L -^AQAO1(1,AQAOCOM)
 D KILL^AQAOUTIL Q
 ;
 ;
DELETE ;SUBRTN called before DIE call in line CHOOSE1+4
 W !!,"Enter ""@"" to delete user from this team",! Q
