AQAOCHK3 ; IHS/ORDC/LJF - TICKLER BY USER OR TEAM ;
 ;;1.01;QAI MANAGEMENT;;OCT 05, 1995
 ;
 ;This rtn is the main entry point from the Tickler Report option.
 ;If user is QI staff member, user is given choice to print tickler
 ;for one user, for one team, or for all occurrences needing review.
 ;This rtn then calls ^AQAOCHK once user or team identity is defined.
 ;
CHECK ; >> go to ^AQAOCHK1 if not qi staff member
 I $P(AQAOUA("USER"),U,6)="" D ^AQAOCHK1 Q
 K AQAOXYZ K ^TMP("AQAOCHK",$J) ;start out clean
 ;
ASK ; >> print for user, team or all
 W !! K DIR S DIR(0)="NO^1:3"
 S DIR("A")="   Choose One",DIR("A",1)="   Print TICKLER Report"
 S DIR("A",2)="   1.  For a USER"
 S DIR("A",3)="   2.  For a QI TEAM"
 S DIR("A",4)="   3.  For ALL"
 S DIR("?",1)="As a QI Staff member, you have the choice to print the"
 S DIR("?",2)="Tickler report to show occurrences needing review for"
 S DIR("?",3)="a particular USER, or for a particular QI TEAM, or for"
 S DIR("?",4)="ALL occurrences which is how it prints when you first"
 S DIR("?",5)="enter the QAI Mgt System menu."
 S DIR("?")="Choose by number: 1, 2, or 3."
 D ^DIR G END^AQAOCHK2:Y<1 S AQAOCHC=Y
 ;
 I AQAOCHC<3 D  G ASK:Y<1
 .W !! K DIC S DIC=$S(AQAOCHC=1:"^VA(200,",1:"^AQAO1(1,")
 .S DIC(0)="AEMQZ" D ^DIC
 S AQAODUZ=$S(AQAOCHC=1:+Y,AQAOCHC=2:0,1:DUZ) ;reset duz
 I AQAOCHC=2 S AQAOXYZ(1,+Y)="",AQAOY=+Y ;set team variables
 ;
 S AQAOSUB=$S(AQAOCHC=1:"USER",AQAOCHC=2:"TEAM",1:"ALL")
 D @AQAOSUB
 ;I '$D(AQAOXYZ)#2,'$D(AQAOXYZ(1)) W !!,"*** NO INDICATORS FOUND ***" G ASK ;PATCH 4
 D OCC^AQAOCHK Q
 ;
 ;
USER ; >> SUBRTN to find indicator access for user
 W !!,"Using identity of ",$P(^VA(200,AQAODUZ,0),U)," . . .",!
 I $P($G(^AQAO(9,AQAODUZ,0)),U,6)]"" S AQAOXYZ="ALL"
 S AQAOX=0 ;find teams user has write access to
 F  S AQAOX=$O(^AQAO(9,AQAODUZ,"TM",AQAOX)) Q:AQAOX'=+AQAOX  D
 .Q:$P(^AQAO(9,AQAODUZ,"TM",AQAOX,0),U,2)'=2  ;need write access
 .S AQAOY=$P(^AQAO(9,AQAODUZ,"TM",AQAOX,0),U),AQAOXYZ(1,AQAOY)=""
 .D TEAM
 Q
 ;
TEAM ; >> SUBRTN to find indicators for team selected
 S AQAOIND=0 ;find all indicators for this team
 F  S AQAOIND=$O(^AQAO(2,"AC",AQAOY,AQAOIND)) Q:AQAOIND=""  D
 .S AQAOXYZ(2,AQAOIND)=""
 Q
 ;
ALL ; >> SUBRTN to set access level of ALL
 S AQAOXYZ="ALL" Q
