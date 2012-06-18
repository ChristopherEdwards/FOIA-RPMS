AQAOUSR1 ; IHS/ORDC/LJF - ENTER/EDIT QI USER ;
 ;;1.01;QAI MANAGEMENT;;OCT 05, 1995
 ;
 ;This is a continuation of the user edit option.  This rtn asks
 ;what the user's access to various options should be.  From this
 ;a list of the appropriate security keys to assign is printed.
 ;
KEYS ; >> do you want to see a list of appropriate security keys for user
 W ! K DIR S DIR(0)="Y",DIR("B")="YES"
 S DIR("?",1)="A QI User's PROFILE gives you a quick look at the type"
 S DIR("?",2)="of access the user has to the QAI Management System."
 S DIR("?",3)="After answering the next couple of questions, it can"
 S DIR("?",4)="also give you a list of SECURITY KEYS for your site"
 S DIR("?",5)="manager to allocate to this user.",DIR("?")=" "
 S DIR("A")="Do you wish to see this QI User's Profile"
 D ^DIR G NAME^AQAOUSR:$D(DIRUT),NAME^AQAOUSR:Y=0
 ;
QUES1 ; >> should user have access to indicator data entry?
 W ! K DIR S DIR(0)="Y" K AQAOARR("AQAOZIED")
 S DIR("B")=$S($D(^XUSEC("AQAOZIED",AQAOUSR)):"YES",1:"NO")
 S DIR("?",1)="Should "_AQAONM_" have access to INDICATOR DATA ENTRY"
 S DIR("?",2)="options?  If you answer YES, this user will be able to"
 S DIR("?",3)="ENTER and EDIT Key Functions, Indicators, and Review"
 S DIR("?",4)="Criteria for any QI Team to which he/she is a "
 S DIR("?",5)="'CREATE/EDIT' member.",DIR("?")=" "
 S DIR("A")="Should "_AQAONM_" have access to add/change INDICATORS"
 D ^DIR G KEYS:$D(DIRUT) I Y=1 S AQAOARR("AQAOZIED")=""
 ;
QUES2 ; >> should user have access to occurrence data entry?
 W ! K DIR S DIR(0)="Y" K AQAOARR("AQAOZOCC")
 S DIR("B")=$S($D(^XUSEC("AQAOZOCC",AQAOUSR)):"YES",1:"NO")
 S DIR("?",1)="Should "_AQAONM_" have access to OCCURRENCE DATA ENTRY"
 S DIR("?",2)="options?  If you answer YES, this user will be able to"
 S DIR("?",3)="ENTER and EDIT Occurrences and their Reviews which are"
 S DIR("?",4)="linked to the Indicators for his/her QI Team for which"
 S DIR("?",5)="this user has 'CREATE/EDT' access."
 S DIR("?")=" "
 S DIR("A")="Should "_AQAONM_" have access to OCCURRENCE DATA ENTRY"
 D ^DIR G KEYS:$D(DIRUT) I Y=1 S AQAOARR("AQAOZOCC")=""
 ;
QUES3 ; >> should user have access to document action plans?
 W ! K DIR S DIR(0)="Y" K AQAOARR("AQAOZAPL")
 S DIR("B")=$S($D(^XUSEC("AQAOZAPL",AQAOUSR)):"YES",1:"NO")
 S DIR("?",1)="Should "_AQAONM_" have access to the ACTION EVALUATION"
 S DIR("?",2)="EDIT options?  If you answer YES, this user will be able"
 S DIR("?",3)="to ENTER and EDIT Actions taken (the implementation and"
 S DIR("?",4)="evaluation) linked to Indicators for the QI Team for"
 S DIR("?",5)="which this user has 'CREATE/EDIT' access",DIR("?")=" "
 S DIR("A")="Should "_AQAONM_" have access to add/change ACTION PLANS"
 D ^DIR G KEYS:$D(DIRUT) I Y=1 S AQAOARR("AQAOZAPL")=""
 ;
QUES4 ;ENTRY POINT can user have access to close/delete/reopen occ /actions?
 K AQAOARR("AQAOZVAL"),AQAOARR("AQAOZCLS")
 W ! K DIR S DIR(0)="SB^A:ALL;P:PARTIAL;N:NONE"
 S DIR("B")=$S($D(^XUSEC("AQAOZVAL",AQAOUSR)):"ALL",$D(^XUSEC("AQAOZCLS",AQAOUSR)):"PARTIAL",1:"NONE")
 S DIR("?",2)="Answer ALL if this user can close ALL occurrences linked"
 S DIR("?",3)="to indicators for his/her QI team."
 S DIR("?",5)="Answer PARTIAL if this user can close occurrences ONLY"
 S DIR("?",6)="after the INITIAL REVIEW.  The user will NOT be able to"
 S DIR("?",7)="DELETE or REOPEN occurences."
 S DIR("?",9)="Answer NONE for users who should NOT be able to close"
 S DIR("?",10)="any occurrences."
 S DIR("?",1)=" ",DIR("?",4)=" ",DIR("?",8)=" ",DIR("?",11)=" "
 S DIR("?")="Choose A for ALL, P for PARTIAL, or N for NONE."
 S DIR("A")="Should "_AQAONM_" have access to CLOSE OCCURRENCES?"
 D ^DIR G KEYS:$D(DIRUT)
 S:Y="A" AQAOARR("AQAOZVAL")=""  S:Y'="N" AQAOARR("AQAOZCLS")=""
 ;
 ;
 G ^AQAOUSR2
