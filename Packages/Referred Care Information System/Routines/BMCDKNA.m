BMCDKNA ; IHS/PHXAO/TMJ - DID NOT KEEP APPOINTMENT DKNA REPORT ; 
 ;;4.0;REFERRED CARE INFO SYSTEM;;JAN 09, 2006
 ;
 ;
 ;
START ;
 D INFORM
 ;
BD ;get beginning date
 W !! S DIR(0)="D^::EP",DIR("A")="Enter beginning Referral Initiation Date" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) G END
 S AZXABD=Y
ED ;get ending date
 W ! S DIR(0)="D^"_AZXABD_"::EP",DIR("A")="Enter ending Referral Initiation Date"  D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) G BD
 S AZXAED=Y
 S X1=AZXABD,X2=-1 D C^%DTC S AZXASD=X
 W !
 ;
 ;
ASK ;Ask if a particular Reason Not Complete
 S AZXASTBD=1,AZXASTED=10
 W ! S DIR(0)="Y0",DIR("A")="Would you like to INCLUDE ONLY a particular Reason NOT Completed",DIR("B")="NO"
 S DIR("?")="To RESTRICT to a particular REASON NOT COMPLETED  - Answer Yes."
 D ^DIR K DIR
 G:$D(DIRUT) BD
 I 'Y G PRINT
STATUS ;RCIS REASON NOT COMPLETED
 S DIR(0)="90001,.16",DIR("A")="Enter the REASON NOT COMPLETED"
 K DA D ^DIR K DIR
 G:$D(DIRUT) ASK
 G:Y=0 ASK
 S AZXASTBD=Y,AZXASTED=Y
 ;
 ;
 ;
 ;
PRINT ;PRINT CLOSED DISCLOSURES BY DATE
 ;W !
 S FLDS="[BMC DKNA REPORT]",BY(0)="^BMCREF(""AF""," S L(0)=3,DIC="^BMCREF(",L=0
 S FR(0,1)=AZXASTBD,TO(0,1)=AZXASTED
 S FR(0,2)=AZXABD,TO(0,2)=AZXAED
 ;S FR(0,3)=AZXADKB,TO(0,3)=AZXADKE
 K DHIT,DIOEND,DIOBEG
 D EN1^DIP
END ;
 K AZXABD,AZXAED,X,DD0,B Q
 ;
INFORM ;User Report Information
 ;
 ;
 W !,?20,"*********RCIS-REASON NOT COMPLETED REPORT**********"
 W !!,"The Purpose of this report is to print a listing of Referrals"
 W " that have not been",! W "completed for a given date range.",!!  W "The User is asked to select a"
 W " specific REASON NOT COMPLETED or list ALL Reasons",!,"Completed."
 Q
