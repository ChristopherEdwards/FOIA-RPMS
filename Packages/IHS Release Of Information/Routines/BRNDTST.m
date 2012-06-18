BRNDTST ; IHS/PHXAO/TMJ - ROI SELECTED REQUEST STATUS AND (BY DATE RANGE) ;  
 ;;2.0;RELEASE OF INFO SYSTEM;*1*;APR 10, 2003
 ;IHS/OIT/LJF 01/23/2008 PATCH 1 Added date range limits
 ;            01/24/2008 Added choice of facility
 ;
 ;
BD ;get beginning date
 ;W !! S DIR(0)="D^::EP",DIR("A")="Enter beginning ROI Initiated Date" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 W !! S DIR(0)="D^:"_DT_":EP",DIR("A")="Enter beginning ROI Initiated Date" D ^DIR K DIR S:$D(DUOUT) DIRUT=1  ;IHS/OIT/LJF 01/23/2008 PATCH 1
 I $D(DIRUT) G END
 S BRNBD=Y
ED ;get ending date
 ;W ! S DIR(0)="D^"_BRNBD_"::EP",DIR("A")="Enter ending ROI Initiation Date"  D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 W ! S DIR(0)="D^"_BRNBD_":"_DT_":EP",DIR("A")="Enter ending ROI Initiation Date"  D ^DIR K DIR S:$D(DUOUT) DIRUT=1  ;IHS/OIT/LJF 01/23/2008 PATCH 1
 I $D(DIRUT) G BD
 S BRNED=Y
 S X1=BRNBD,X2=-1 D C^%DTC S BRNSD=X
 W !
 ;
 ;
ASK ;Ask if a particular Status
 S BRNSTBD="C",BRNSTED="ZZ"
 W ! S DIR(0)="Y0",DIR("A")="Would you like to INCLUDE ONLY a particular ROI Disclosure Status",DIR("B")="NO"
 S DIR("?")="To RESTRICT to a particular ROI Disclosure Status  - Answer Yes."
 D ^DIR K DIR
 G:$D(DIRUT) BD
 I 'Y G PRINT
 ;
STATUS ;ROI Disclosure STATUS
 S DIR(0)="90264,.08",DIR("A")="Enter the Status"
 K DA D ^DIR K DIR
 G:$D(DIRUT) ASK
 G:Y=0 ASK
 S BRNSTBD=Y,BRNSTED=Y
 ;
 ;
PRINT ;PRINT CLOSED DISCLOSURES BY DATE
 ;
 ;select facility
 NEW BRNFAC D ASKFAC^BRNU(.BRNFAC) I BRNFAC="" D END Q  ;IHS/OIT/LJF 01/24/2008 PATCH 1
 ;
 ;set up print
 S FLDS="[BRN PRIORITY REQUEST]",BY(0)="^BRNREC(""AC""," S L(0)=3,DIC="^BRNREC(",L=0
 S FR(0,1)=BRNSD,TO(0,1)=BRNED
 S FR(0,2)=BRNSTBD,TO(0,2)=BRNSTED
 I BRNFAC>0 S DIS(0)="I $P(^BRNREC(D0,0),U,22)=BRNFAC"  ;IHS/OIT/LJF 01/24/2008 PATCH 1
 K DHIT,DIOEND,DIOBEG
 D EN1^DIP
END ;
 K BRNBD,BRNED,BRNSD,BRNSTBD,BRNSTED,X,DD0,B Q
