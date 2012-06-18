AQAOPR1 ; IHS/ORDC/LJF - INDICATOR LISTS & SUMMARIES ;
 ;;1.01;QAI MANAGEMENT;;OCT 05, 1995
 ;
 ;This rtn prints either listings or summaries for indicators sorted
 ;as the user selects.  This rtn contains the user interface and the
 ;calls to DIP.
 ;
STYLE ; >>> print listing or summaries
 K DIR S DIR(0)="SO^L:LISTINGS;M:MATRIX;S:SUMMARIES"
 S DIR("?",1)="Which indicator report style do you want?"
 S DIR("?",2)="     Enter L to print short listings;"
 S DIR("?",3)="     Enter M to print an indicator matrix."
 S DIR("?",4)="     Enter S to print detailed summaries."
 S DIR("?")="For more information on these styles, see the User Manual."
 S DIR("A")="Choose Report Style" D ^DIR G END:$D(DIRUT) S AQAOSTY=Y
 I AQAOSTY="M" D ^AQAOPR8 Q
 ;
SORT ; >>>  ask sort criteria
 W !! K DIR S DIR(0)="NO^1:3",DIR("A")="     Choose One"
 S DIR("A",1)="Select Sort Criteria for Report:"
 S DIR("A",2)="  ",DIR("A",7)=" "
 S DIR("A",3)=" 1.  Sort by CODE # RANGE"
 S DIR("A",4)=" 2.  Sort by QI MONITORING TEAM"
 S DIR("A",5)=" 3.  Sort by KEY FUNCTION"
 S DIR("?")="Choose how you want the report sorted.  Select by number"
 D ^DIR G END:$D(DIRUT) S AQAOSRT=+Y G INAC:AQAOSRT=1
 ;
ALL ; >>> choose one or all qi teams or function
 K DIR S DIR(0)="Y"
 S DIR("A")="Print for ALL "_$S(AQAOSRT=2:"QI TEAMS",1:"KEY FUNCTION")
 S DIR("B")="NO" D ^DIR I Y=1 S AQAONUM="" G INAC
 I $D(DIRUT) G END ;check for timeout,"^", or null
 ;
ONE ; >>> choose which qi team or function
 K DIR,AQAONUM
 S DIR(0)="PO^"_$S(AQAOSRT=2:9002169.1,1:9002168.1)_":EMQZ"
 D ^DIR G ALL:X="",END:$D(DIRUT),ONE:Y=-1
 S AQAONUM=$P(Y(0),U)
 ;
INAC ; >>> include inactive indicators?
 K DIR S DIR(0)="Y",DIR("B")="NO"
 S DIR("A")="Do you wish to print INACTIVE Indicators"
 D ^DIR G END:$D(DIRUT) I Y=1 S AQAOINAC=""
 ;
PRINT ; >>> set up print variables and call fileman to print
 I AQAOSTY="L" D  ;set listing report variables
 .S FLDS="[AQAO IND LISTING]"
 .S BY=$S(AQAOSRT=1:"CODE #",AQAOSRT=2:"[AQAO QI TEAM]",1:"[AQAO FUNCTION]")
 ;
 I AQAOSTY="S" D  ;set summary report variables
 .S FLDS="[AQAO IND DISPLAY]"
 .S BY=$S(AQAOSRT=1:"#CODE #",AQAOSRT=2:"[AQAO QI TEAM2]",1:"[AQAO FUNCTION2]")
 ;
 S L=0,DIC=9002168.2 I AQAOSRT>1 S (TO,FR)=AQAONUM
 D EN1^DIP
 ;
 D PRTOPT^AQAOVAR
END D KILL^AQAOUTIL K AQAOINAC Q
