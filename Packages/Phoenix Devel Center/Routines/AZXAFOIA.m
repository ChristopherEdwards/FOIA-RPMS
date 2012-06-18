AZXAFOIA ; IHS/PHXAO/TMJ - ROI FOIA DISCLOSURES BY PURPOSE (BY DATE RANGE) ;  
 ;;2.0;RELEASE OF INFORMATION;;FEB 21, 2002
 ;
 ;A Yes Answer in field 2401 determines if this is a First Party Request
ASK ;Ask For Date Range
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
PRINT ;PRINT CLOSED DISCLOSURES BY DATE
 ;W !
 S FLDS="[AZXA FOIA SUBTOTAL PRINT]",BY="'(#.01),INTERNAL(#2401)=""Y"",+.07",DIC="^AZXAREC(",L=0
 S FR=AZXABD,TO=AZXAED
 K DHIT,DIOEND,DIOBEG
 D EN1^DIP
END ;
 K AZXABD,AZXAED,X,DD0,B Q
