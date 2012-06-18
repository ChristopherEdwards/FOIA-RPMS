AQAODICC ; IHS/ORDC/LJF - DATA ENTRY OPTION FOR CRITERIA ;
 ;;1.01;QAI MANAGEMENT;;OCT 05, 1995
 ;
 ;This rtn contains the code for user interface when adding and
 ;editing review criteria to indicators.
 ;
 D CRINTRO^AQAOHCRT ;display intro text
INDC ; >>> ask for indicator that will be linked to criteria
 W !!!,"Enter the INDICATOR for which you are defining review criteria:"
 S AQAOIND=+$$IND^AQAOLKP G END:AQAOIND=0,END:AQAOIND=-1
 ;
FIND ; >>> find all criteria already linked to this indicator
 S (AQAOX,AQAOCNT)=0 K AQAOARR
 F  S AQAOX=$O(^AQAO1(6,"C",AQAOIND,AQAOX)) Q:AQAOX=""  D
 .S AQAOY=0
 .F  S AQAOY=$O(^AQAO1(6,"C",AQAOIND,AQAOX,AQAOY)) Q:AQAOY=""  D
 ..Q:'$D(^AQAO1(6,AQAOX,"IND",AQAOY,0))
 ..S AQAOCNT=AQAOCNT+1,AQAOARR(AQAOCNT)=AQAOX_U_AQAOY
 ;
NONE ; >>> if none, ask to add    
 G DISPLAY:$D(AQAOARR) ;if any already linked
 W !!,"NO CRITERIA ALREADY LINKED . . .",!
 K DIR S DIR(0)="YO",DIR("A")="Do you wish to ADD NEW CRITERIA"
 D ^DIR G INDC:$D(DIRUT),INDC:Y=0
 D ADD G FIND
 ;
DISPLAY ; >> display all criteria 
 W !!?5,"<<< REVIEW CRITERIA >>>",!
 S AQAOX=0
 F  S AQAOX=$O(AQAOARR(AQAOX)) Q:AQAOX=""  D
 .W !,AQAOX,") ",$P(^AQAO1(6,$P(AQAOARR(AQAOX),U),0),U) ;criteria phrase
 .S Y=$P(^AQAO1(6,$P(AQAOARR(AQAOX),U),0),U,2)
 .S C=$P(^DD(9002169.6,.02,0),U,2) D Y^DIQ W ?65,Y ;type of criteria
 W !,(AQAOCNT+1),") ADD NEW ENTRY"
 K DIR S DIR(0)="NO^1:"_(AQAOCNT+1)
 S DIR("A")="Choose ONE from the list OR hit <return> to continue"
 S DIR("?",1)="Choose a Review Criterion from the list above,"
 S (DIR("?",2),DIR("?",4))="                  OR"
 S DIR("?",3)="Choose the option ADD NEW ENTRY.",DIR("?")=" "
 S DIR("?",5)="Press the RETURN key to choose another Indicator?"
 D ^DIR G INDC:$D(DIRUT),DISPLAY:Y=-1
 ;
 I Y=(AQAOCNT+1) D ADD G FIND
 E  S AQAOY=Y D EDIT G FIND
 ;
 ;
END ; >>> eoj
 D KILL^AQAOUTIL Q
 ;
 ;
ADD ; >> SUBRTN to add new entry
 L +^AQAO1(6,0):1 I '$T D  Q
 .W !!,"CANNOT ACCESS FILE; ANOTHER USER ADDING ENTRY. TRY AGAIN.",!
 K DIC S (DIC,DLAYGO)=9002169.6,DIC(0)="AEMQL"
 D ^DIC L -^AQAO1(6,0) Q:$D(DIRUT)  Q:Y=-1  S AQAODA=+Y
 L +^AQAO1(6,AQAODA):1 I '$T D  Q
 .W !!,"CANNOT EDIT; ANOTHER USER EDITING THIS ENTRY. TRY AGAIN.",!
 I '$D(^AQAO1(6,AQAODA,"IND",0)) S ^(0)="^9002169.699P"
 I '$D(^AQAO1(6,AQAODA,"IND","B",AQAOIND)) D
 .K DIC S DIC="^AQAO1(6,"_AQAODA_",""IND"",",DIC(0)="L"
 .S DA(1)=AQAODA,X=$P(^AQAO(2,AQAOIND,0),U),DIC("DR")=".02"
 .D ^DIC
 K DIC S DIE=9002169.6,DR="[AQAO CRITERIA EDIT-E1]",DA=AQAODA
 D ^DIE
 L -^AQAO1(6,AQAODA) Q
 ;
 ;
EDIT ; >> SUBRTN to edit or delete entry 
 W !!,"To DELETE the link between this criteria and your indicator"
 W !,"enter an '@' at the INDICATOR prompt; otherwise hit <return>."
 W ! S AQAODA1=$P(AQAOARR(AQAOY),U),AQAODA=$P(AQAOARR(AQAOY),U,2)
 S AQAODR=".01;.02",AQAODIC="^AQAO1(6,"_AQAODA1_",""IND"","
 D DIE^AQAODIC ;call dic/die driver
 Q:'$D(^AQAO1(6,"C",AQAOIND,AQAODA1))  ;link deleted
 ;
EDIT1 S AQAODIC="^AQAO1(6,",AQAODR="[AQAO CRITERIA EDIT-E1]"
 S AQAODA=$P(AQAOARR(AQAOY),U) D DIE^AQAODIC
 Q
