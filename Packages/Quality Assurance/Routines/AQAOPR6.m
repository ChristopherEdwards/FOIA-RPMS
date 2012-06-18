AQAOPR6 ; IHS/ORDC/LJF - PRINT OCC WORKSHEET ;
 ;;1.01;QAI MANAGEMENT;;OCT 05, 1995
 ;
 ;This rtn contains the user interface and DIP call to print occ
 ;worksheets based on an indicator. It contains an entry point called
 ;by the print template to list initial review questions and possible
 ;answers.
 ;
INDCTR ; >>> ask user which indicator to print worksheet for
 S AQAOIND=$$IND^AQAOLKP G END:AQAOIND=U,INDCTR:AQAOIND=-1
 S AQAOIND=+AQAOIND
 ;
LEVEL ; >>> ask user which review level will be used for inital review
 I $P(^AQAO(2,AQAOIND,0),U,4)="R",$P(^(1),U,4)]"",$P(^(1),U,5)]"",$P(^(1),U,6)]"" G PRINT ;don't print review questions for ind with default revw answers
 W !! K DIR S DIR(0)="PO^9002168.7:EMZ"
 S DIR("A")="Select REVIEW STAGE for the worksheets" D ^DIR
 G END:$D(DIRUT),END:Y=-1 S AQAORLEV=Y
 ;
PRINT ; >>> set print varialbes and call dip
 W !! S L=0,DIC="^AQAO(2,",FLDS="[AQAO WORKSHEET]"
 S BY="@NUMBER",(FR,TO)=AQAOIND
 S DIS(0)="D INDCHK^AQAOSEC I $D(AQAOCHK(""OK""))"
 S DIOEND="D:Y'=U REVIEW^AQAOPR6" D EN1^DIP
 ;
END ; >>> eoj
 I '$D(ZTQUEUED),$G(AQAOSTOP)'=U D PRTOPT^AQAOVAR
 D KILL^AQAOUTIL Q
 ;
 ;
REVIEW ;EP; >>> print review level data
 I $P(^AQAO(2,AQAOIND,0),U,4)="R",$P(^(1),U,4)]"",$P(^(1),U,5)]"",$P(^(1),U,6)]"" Q  ;don't print review questions for ind with default revw answers
 S AQAOLINE="",$P(AQAOLINE,"=",80)=""
 S AQAOLIN2="",$P(AQAOLIN2,"_",20)=""
 S AQAOSTOP="" D NEWPG Q:AQAOSTOP=U
 S X=$P(AQAORLEV,U,2)_" REVIEW QUESTIONS"
 W !!?(80-$L(X))/2,X,!
 W !,"REVIEWER/TEAM NAME: " W AQAOLIN2,?47,"REVIEW DATE: ",AQAOLIN2
 ;
RISK ; >>> print all risk of outcomes in file
 G FIND:(+AQAORLEV=1) ;no outcome levels at non-clin review level
 F AQAOI=2,4,5 D  Q:AQAOSTOP=U
 .W !!,$S(AQAOI=2:"POTENTIAL OF ADVERSE OUTCOME:",AQAOI=4:"ADVERSE OUTCOME OF OCCURRENCE:",1:"ULTIMATE PATIENT OUTCOME (Only asked when closing occurrence"),!
 .S AQAOX=0 F  S AQAOX=$O(^AQAO1(3,AQAOX)) Q:AQAOX'=+AQAOX  Q:AQAOSTOP=U  D
 ..Q:'$D(^AQAO1(3,AQAOX,0))  S AQAOX1=^(0)
 ..Q:$P(AQAOX1,U,3)="I"  Q:$P(AQAOX1,U,AQAOI)=""  ;inactive/othr scale
 ..W !?5,"_________  ",$P(AQAOX1,U),"  ",$P(AQAOX1,U,AQAOI)
 ..I $Y>(IOSL-4) D NEWPG
 Q:AQAOSTOP=U
 ;
FIND ; >>> print findings available for this review level
 W !!,"FINDING:",!
 S AQAOX=0 F  S AQAOX=$O(^AQAO(8,AQAOX)) Q:AQAOX'=+AQAOX  Q:AQAOSTOP=U  D
 .Q:'$D(^AQAO(8,AQAOX,0))  S AQAOX1=^(0) Q:$P(AQAOX1,U,4)="I"  ;inactiv
 .Q:$P(AQAOX1,U,3)'[+AQAORLEV  ;not for this review level
 .W !?5,"_____  ",$P(AQAOX1,U)
 .I $Y>(IOSL-4) D NEWPG
 Q:AQAOSTOP=U
 ;
ACTION ; >>> print actions available for this review level
 W !!,"ACTION:",!
 S AQAOX=0 F  S AQAOX=$O(^AQAO(6,AQAOX)) Q:AQAOX'=+AQAOX  Q:AQAOSTOP=U  D
 .Q:'$D(^AQAO(6,AQAOX,0))  S AQAOX1=^(0) Q:$P(AQAOX1,U,5)="I"  ;inactiv
 .Q:$P(AQAOX1,U,3)'[+AQAORLEV  ;not for this review level
 .W !?5,"_____  ",$P(AQAOX1,U)
 .I $Y>(IOSL-4) D NEWPG
 Q:AQAOSTOP=U
 ;
 ;preformance levels by provider
 W !!,"PERFORMANCE LEVELS BY PROVIDER (Only asked when closing occurrence)",!
 S AQAOX=0 F  S AQAOX=$O(^AQAO1(3,AQAOX)) Q:AQAOX'=+AQAOX  Q:AQAOSTOP=U  D
 .Q:'$D(^AQAO1(3,AQAOX,0))  S AQAOX1=^(0)
 .Q:$P(AQAOX1,U,3)="I"  Q:$P(AQAOX1,U,6)=""  ;inactive/othr scale
 .W !?5,$P(AQAOX1,U),"  ",$P(AQAOX1,U,6)
 .I $Y>(IOSL-4) D NEWPG
 G END:AQAOSTOP=U
 F I=1:1:4 D
 .I $Y>(IOSL-4) D NEWPG
 .W !,"PROVIDER: _______  LEVEL: _____",!
 G END:AQAOSTOP=U
 ;
COMMENT ; >>> print comments area
 I $Y>(IOSL-4) D NEWPG Q:AQAOSTOP=U
 W !!,"COMMENTS:  "
 Q
 ;
NEWPG ; >>> SUBRTN for end of page control
 I IOST?1"C-".E K DIR S DIR(0)="E" D ^DIR S AQAOSTOP=X
 I AQAOSTOP=U Q
 W @IOF,!,"QI OCCURRENCE WORKSHEET"
 W !,AQAOLINE,!
 Q
