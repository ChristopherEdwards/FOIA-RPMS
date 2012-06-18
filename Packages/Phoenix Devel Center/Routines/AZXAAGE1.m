AZXAAGE1 ; IHS/PHXAO/TMJ - ROI AGING REPORT (BY AGE STARTING POINT) ;
 ;;2.0;RELEASE OF INFORMATION;;FEB 21, 2002
 ;
 ;
ASK ;Ask For Beginning Aging Range
 ;
 S AZXAOLDB=0,AZXAOLDE=1000
 W ! S DIR(0)="Y0",DIR("A")="Would you like to include a particular Aging Starting Range",DIR("B")="NO"
 S DIR("?")="To Include a Particular Number of Days Old Starting Point-Answer Yes."
 D ^DIR K DIR
 G:$D(DIRUT) END
 I 'Y G PRINT
 ;
OLD1 ;ROI Disclosure DAYS OLD SCREEN
 S DIR(0)="S^30:30 DAYS +;60:60 DAYS +;90:90 DAYS +;120:120 DAYS +",DIR("A")="Enter the Number Starting Point"
 K DA D ^DIR K DIR
 G:$D(DIRUT) ASK
 G:Y=0 ASK
 S AZXAOLDB=Y
 ;
 ;
PRINT ;PRINT MASTER DISCLOSURE LOG
 ;W !
 S FLDS="[AZXA GS AGING RPT]",BY="@23,(#.04),.08,@.01",DIC="^AZXAREC(",L=0
 S FR=AZXAOLDB,TO=AZXAOLDE
 K DHIT,DIOEND,DIOBEG
 D EN1^DIP
END ;
 K AZXAOLDB,AZXAOLDE,DD0,B,X Q
