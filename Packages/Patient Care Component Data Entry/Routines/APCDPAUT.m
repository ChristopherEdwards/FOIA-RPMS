APCDPAUT ; IHS/CMI/LAB - LOOKUP UP V CHS BY AUTHORIZATION ;
 ;;2.0;IHS PCC SUITE;;MAY 14, 2009
 ;
 W !!,"This routine will find and display a V CHS entry for a given",!,"Authorization Number.",!!
READ ;
 K DIR S (APCDX,APCDY)=""
 S DIR("?")="   "
 S DIR("?",1)="The number entered must be a 10 digit Authorization Number in the form:",DIR("?",2)="   2 digit FY, then a 3 digit alphanumeric location code, then a 5 digit number.",DIR("?",3)="   For example:  8700112345"
 S DIR(0)="F^10:10",DIR("A")="Enter an Authorization Number" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 G:$D(DIRUT) XIT
 I Y'?2N3AN5N W $C(7),$C(7),!!,DIR("?",1),!,DIR("?",2),!,DIR("?",3) G READ
 K DIR
PROCESS ;
 S APCDY=Y
 S APCDN=$O(^AUPNVCHS("AUTHNO",APCDY,""))
 I APCDN="" W !!,$C(7),$C(7),"That Authorization Number has not been used, Please re-enter",! G READ
 I '$D(^AUPNVCHS(APCDN)) W !,$C(7),$C(7),"ERROR in Authorization Number Cross Reference -- Notify your supervisor",!!
 W !!,"This CHS entry has been entered with Authorization Number ",APCDY,!!
 S DA=APCDN,DR=0,DIC="^AUPNVCHS(" D EN^DIQ
 ;
 S DIR(0)="E",DIR("A")="Press Enter to Continue" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
XIT ;
 K DIRUT,DUOUT,DIR,DTOUT
 K APCDY,APCDX,APCDN
 Q
