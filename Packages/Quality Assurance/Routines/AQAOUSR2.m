AQAOUSR2 ; IHS/ORDC/LJF - CONTINUATION OF EDIT USER ;
 ;;1.01;QAI MANAGEMENT;;OCT 05, 1995
 ;
 ;This is a continuation of the series of questions on a user's
 ;access to various menu options.  It also contains the DIP call
 ;to print the user's profile including a comparison between which
 ;keys the user curently has assigned and those based on the answers
 ;to these questions.
 ;
QUES5 ; >> should user have access to QMAN?
 W ! K DIR S DIR(0)="Y" K AQAOARR("AMQQZMENU")
 S DIR("B")=$S($D(^XUSEC("AMQQZMENU",AQAOUSR)):"YES",1:"NO")
 S DIR("?",1)="Should "_AQAONM_" have access to the Q-Man Query System?"
 S DIR("?",2)="If you answer YES, this user will be able to use Q-Man"
 S DIR("?",3)="to run ad hoc searches on the PCC database as part of "
 S DIR("?",4)="the data collection process.  The Q-Man Query System"
 S DIR("?",5)="is duplicated in this package for convenience."
 S DIR("?")=" "
 S DIR("A")="Should "_AQAONM_" have access to Q-MAN QUERY SYSTEM"
 D ^DIR G QUES4^AQAOUSR1:$D(DIRUT) I Y=1 S AQAOARR("AMQQZMENU")=""
 ;
QUES6 ; >> should user have access to Search Template System
 W ! K DIR S DIR(0)="Y" K AQAOARR("ATSZMENU")
 S DIR("B")=$S($D(^XUSEC("ATSZMENU",AQAOUSR)):"YES",1:"NO")
 S DIR("?",1)="Should "_AQAONM_" have access to the Search Template"
 S DIR("?",2)="System?  If you answer YES, this user will be able to"
 S DIR("?",3)="compare search templates created by Q-Man as part of "
 S DIR("?",4)="the data collection and evaluation process.  The Search"
 S DIR("?",5)="Template System is available in this package for the"
 S DIR("?",6)="user's convenience. ",DIR("?")=" "
 S DIR("A")="Should "_AQAONM_" have access to SEARCH TEMPLATE SYSTEM"
 D ^DIR G QUES5:$D(DIRUT) I Y=1 S AQAOARR("ATSZMENU")=""
 ;
QUES7 ; >> should user see provider reports?
 W ! K DIR S DIR(0)="YO" K AQAOARR("AQAOZPRV")
 S DIR("B")=$S($D(^XUSEC("AQAOZPRV",AQAOUSR)):"YES",1:"NO")
 S DIR("?",1)="Should "_AQAONM_" have access to PROVIDER Reports based"
 S DIR("?",2)="on occurrences entered and reviewed?  We suggest only"
 S DIR("?",3)="giving the access to users involved in the Credentialing"
 S DIR("?",4)="process (QI staff, Clinical Director, Service Chiefs)."
 S DIR("?")=" "
 S DIR("A")="Should "_AQAONM_" have access to PROVIDER REPORTS"
 D ^DIR G QUES6:$D(DIRUT) I Y=1 S AQAOARR("AQAOZPRV")=""
 ;
 ;
PROFILE ; >> print user profile with key allocation suggestions
 W !!,"Enter your PRINTER NAME or 'HOME' to print to your screen"
 S DIC="^AQAO(9,",L=0,FLDS="[AQAO USER PROFILE]",(TO,FR)=AQAOUSR
 S BY="@NUMBER" D EN1^DIP ;print profile
 D PRTOPT^AQAOVAR
 ;
 G NAME^AQAOUSR ;return to beginning
 ;
 ;
END ; >>> eoj
 D KILL^AQAOUTIL Q
