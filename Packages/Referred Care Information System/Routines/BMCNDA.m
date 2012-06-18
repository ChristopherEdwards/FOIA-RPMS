BMCNDA ; IHS/PHXAO/TMJ - Number of Days Authorized Modifications 
 ;;4.0;REFERRED CARE INFO SYSTEM;;JAN 09, 2006
 ;
 ;
ASK ;Ask For Date Range
 ;
 ;
BD ;get beginning date
 W !! S DIR(0)="D^::EP",DIR("A")="Enter beginning Modified Date" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) G END
 S AZXABD=Y
ED ;get ending date
 W ! S DIR(0)="D^"_AZXABD_"::EP",DIR("A")="Enter ending Modified Date"  D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) G BD
 S AZXAED=Y
 S X1=AZXABD,X2=-1 D C^%DTC S AZXASD=X
 W !
 ;
PRINT ;PRINT MASTER DISCLOSURE LOG
 ;W !
 S FLDS="[BMC NUMBER DAYS AUTH]",BY="@INTERNAL(#1126)",DIC="^BMCREF(",L=0
 S FR=AZXABD,TO=AZXAED
 K DHIT,DIOEND,DIOBEG
 D EN1^DIP
END ;
 K AZXABD,AZXAED,X,DD0,B Q
