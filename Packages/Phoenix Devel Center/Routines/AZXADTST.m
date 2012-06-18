AZXADTST ; IHS/PHXAO/TMJ - ROI SELECTED REQUEST STATUS AND (BY DATE RANGE) ; 
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
ASK ;Ask if a particular Status
 S AZXASTBD="C",AZXASTED="ZZ"
 W ! S DIR(0)="Y0",DIR("A")="Would you like to INCLUDE ONLY a particular ROI Disclosure Status",DIR("B")="NO"
 S DIR("?")="To RESTRICT to a particular ROI Disclosure Status  - Answer Yes."
 D ^DIR K DIR
 G:$D(DIRUT) BD
 I 'Y G PRINT
STATUS ;ROI Disclosure STATUS
 S DIR(0)="1991075,.08",DIR("A")="Enter the Status"
 K DA D ^DIR K DIR
 G:$D(DIRUT) ASK
 G:Y=0 ASK
 S AZXASTBD=Y,AZXASTED=Y
 ;
 ;
PRINT ;PRINT CLOSED DISCLOSURES BY DATE
 ;W !
 S FLDS="[AZXA PRIORITY REQUEST]",BY(0)="^AZXAREC(""AC""," S L(0)=3,DIC="^AZXAREC(",L=0
 S FR(0,1)=AZXASD,TO(0,1)=AZXAED
 S FR(0,2)=AZXASTBD,TO(0,2)=AZXASTED
 K DHIT,DIOEND,DIOBEG
 D EN1^DIP
END ;
 K AZXABD,AZXAED,X,DD0,B Q
