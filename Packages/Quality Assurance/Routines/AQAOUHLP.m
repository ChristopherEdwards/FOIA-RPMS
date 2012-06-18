AQAOUHLP ; IHS/ORDC/LJF - HELP OPTION ON MAIN MENU ;
 ;;1.01;QAI MANAGEMENT;;OCT 05, 1995
 ;
 ;This rtn is the help option from the mian menu.  It contains an
 ;introduction to the package, a list of manuals available, a list
 ;of a facility's package administrator, and a user's access level.
 ;In future version it will contain a list of enhancements.
 ;
 W @IOF,!!?20,"HELP IN USING QAI MGT SYSTEM",!
 ;
MENU ; >>> create 4 option menu of help
 W !!! K DIR S DIR("A")="Select HELP Option"
 S DIR(0)="SO^1:ON-LINE HELP;2:PATCHES;3:ENHANCEMENTS;4:MANUALS AVAILABLE;5:WHO IS THE PKG ADMINISTRATOR?;6:YOUR ACCESS LEVEL"
 D ^DIR G EXIT:Y<1,EXIT:Y>6
 S AQAOLIN=$S(Y=1:"INTRO",Y=2:"PATCH",Y=3:"ENHANCE",Y=4:"MANUAL",Y=5:"ADMIN",1:"ACCESS")
 D @AQAOLIN
 G MENU
 ;
EXIT ; >>> eoj
 D KILL^AQAOUTIL W @IOF Q
 ;
 ;
INTRO ; >> SUBRTN to print intro to pkg
 S XQH="AQAO MAIN MENU" D EN^XQH
 N DIR S DIR(0)="E",DIR("A")="Press RETURN when ready to continue"
 D ^DIR
 Q
 ;
 ;
PATCH ; -- SUBRTN calls help frames detailing patches ;PATCH 2
 D ASK("AQAO QAI PATCHES","AQAO QAI PATCH ")
 Q
 ;
ENHANCE ; -- SUBRTN calls hlep frames detailing enhancements
 D ASK("AQAO ENHANCE MAIN","AQAO ENHANCE ")
 Q
 ;
ASK(AQAOHF,AQAOHF1) ; -- SUBRTN to ask user to view or print help
 NEW DIR,X,Y,XQH
 W @IOF,!!?20,"QUICK ON-LINE HELP UTILITY",!!
 K DIR S DIR(0)="NO^1:2",DIR("A")="   Select option by number"
 S DIR("A",1)="   How do you want me to present this help?"
 S DIR("A",2)=" "
 S DIR("A",3)="     1.  DISPLAY help to your screen"
 S DIR("A",4)="     2.  PRINT help to your printer"
 S DIR("A",5)=" " D ^DIR G EXIT:$D(DIRUT)
 ;
 I Y=1 S XQH=AQAOHF D EN^XQH Q
 I Y=2 D CHOOSE(AQAOHF1)
 Q
 ;
CHOOSE(AQAOH) ; -- SUBRTN so user can choose which help to print
 NEW DIR,Y,I,J,XQHFY,XQFMT
 S J=0 F I=1:1 Q:'$D(^DIC(9.2,"B",AQAOH_I))  S J=I
 Q:J=0  I J=1 S Y=1 D SEND Q
 W !! K DIR S DIR(0)="NO^1:"_J
 S DIR("A")="   Print which "_$S(AQAOH["PATCH":"PATCH",1:"ENHANCEMENT")
 D ^DIR Q:Y<1
SEND S XQHFY=AQAOH_Y,XQFMT="T" D ACTION^XQH4
 Q
 ;
MANUAL ; >> SUBRTN to list manuals available for pkg
 W @IOF,!!?20,"MANUALS AVAILABLE FOR YOUR USE",!!
 W !!,"QI TOOLS IN RPMS INDEX:"
 W ?30,"Last update was in November 1994."
 W !?30,"Lists all QI options in each RPMS package."
 W !!,"USER MANUAL:"
 W ?30,"For use by all QAI users;"
 W !?30,"Provides details of each menu option"
 W !?30,"and when to use each."
 W !!,"TECHNICAL MANUAL:"
 W ?30,"For site managers and RPMS developers;"
 W !?30,"Provides information on system structure, links"
 W !?30,"with other packages, and system requirements."
 W !!
 N DIR S DIR(0)="E",DIR("A")="Press RETURN when ready to continue"
 D ^DIR
 Q
 ;
 ;
ADMIN ; >> SUBRTN to list all pkg administrators and phone numbers
 W @IOF,!!?20,"QAI PACKAGE ADMINISTRATOR(S) FOR YOUR FACILITY",!!
 K AQAO S X=0
 F  S X=$O(^AQAO(9,X)) Q:X'=+X  D
 .Q:'$D(^AQAO(9,X,0))  Q:$P(^(0),U,4)]""  Q:$P(^(0),U,6)'="QA"
 .S AQAO(X)=""
 I '$D(AQAO) D  Q
 .W !!,"NO PACKAGE ADMINISTRATOR DEFINED!"
 .W "  NOTIFY YOUR SITE MANAGER IMMEDIATELY!!",!!
 S X=0
 F  S X=$O(AQAO(X)) Q:X=""  D
 .W !,"NAME:  ",$P(^VA(200,X,0),U)
 .W ?35,"OFFICE PHONE:  ",$P($G(^VA(200,X,.13)),U,2)
 N DIR S DIR(0)="E",DIR("A")="Press RETURN when ready to continue"
 D ^DIR
 Q
 ;
 ;
ACCESS ; >> SUBRTN to show user their access level
 W @IOF,!!?20,"YOUR ACCESS LEVEL IN THE QAI MGT SYSTEM",!!
 K DIC S L=0,DIC="^AQAO(9,",FLDS="[AQAO USER INQ]",BY="@NUMBER"
 S (TO,FR)=DUZ,DHD="@@",IOP="HOME" D EN1^DIP
 N DIR S DIR(0)="E",DIR("A")="Press RETURN when ready to continue"
 D ^DIR
 Q
