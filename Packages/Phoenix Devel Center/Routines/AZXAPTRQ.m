AZXAPTRQ ; IHS/PHXAO/TMJ - ROI REQUESTING PARTY (BY DATE RANGE) ; 
 ;;2.0;RELEASE OF INFORMATION;;FEB 21, 2002
 ;
 ;
 ;
 ;
BD ;get beginning date
 W !! S DIR(0)="D^::EP",DIR("A")="Enter beginning ROI Initiated Date" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) G END
 S AZXABD=Y
ED ;get ending date
 W ! S DIR(0)="D^"_AZXABD_"::EP",DIR("A")="Enter ending ROI Initiation Date"  D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) G BD
 S AZXAED=Y
 S X1=AZXABD,X2=-1 D C^%DTC S AZXASD=X
 W !
 ;
 ;
ASK ;Ask if a particular Requesting Party
 S AZXAUSE=1,AZXAUSE1=10000
 W ! S DIR(0)="Y0",DIR("A")="Want to INCLUDE a particular Party Who Requested the Disclosure",DIR("B")="NO"
 S DIR("?")="To RESTRICT to a particular Requesting Party  - Answer Yes."
 D ^DIR K DIR
 G:$D(DIRUT) BD
 I 'Y G PRINT
USER ;ROI Disclosure USER
 S DIC=1991077,DIC(0)="AEMQ",DIC("A")="Enter Requesting Party Name: "
 D ^DIC K DIC
 ;
 Q:$D(DIRUT)
 G:Y=0 ASK
 S AZXAUSE=+Y,AZXAUSE1=+Y
 ;
 ;
PRINT ;PRINT CLOSED DISCLOSURES BY DATE
 ;W !
 S FLDS="[AZXA DISCLOSURE INFO]",BY(0)="^AZXAREC(""AP""," S L(0)=3,DIC="^AZXAREC(",L=0
 S FR(0,1)=AZXAUSE,TO(0,1)=AZXAUSE1
 S FR(0,2)=AZXABD,TO(0,2)=AZXAED
 K DHIT,DIOEND,DIOBEG
 D EN1^DIP
END ;
 K AZXABD,AZXAED,X,DD0,B Q
