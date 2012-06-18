BRNSUSPN ; IHS/PHXAO/TMJ - ROI SUSPENDED DISCLOSURES (BY DATE RANGE) ;  
 ;;2.0;RELEASE OF INFO SYSTEM;*1*;APR 10, 2003
 ;IHS/OIT/LJF 01/18/2008 PATCH 1 Modified sort since #2404 changed to computed field
 ;            01/23/2008 PATCH 1 Added choice of facility
 ;                               Added date range limits
 ;
 ;
ASK ;Ask For Date Range
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
 NEW BRNFAC,BRNFACN D ASKFAC^BRNU(.BRNFAC) I BRNFAC="" D ED Q            ;IHS/OIT/LJF 01/23/2008 PATCH 1
 I BRNFAC>0 S BRNFACN=$$GET1^DIQ(90264.2,BRNFAC,.01)  ;IHS/OIT/LJF 01/23/2008 PATCH 1
 ;
PRINT ;PRINT CLOSED DISCLOSURES BY DATE
 ;
 ;IHS/OIT/LJF 01/18/2008 & 01/23/2008 PATCH 1
 ;S FLDS="[BRN RPT SUSPEND]",BY="@INTERNAL(#.01),INTERNAL(#2404)=""1""",DIC="^BRNREC(",L=0
 ;S FR=BRNBD,TO=BRNED
 S FLDS="[BRN RPT SUSPEND]",BY="FACILITY,@INTERNAL(#.01),@2404",DIC="^BRNREC(",L=0
 I BRNFAC=0 S FR="@,"_BRNBD_",YES",TO="ZZZ,"_BRNED_",YES"
 E  S FR=BRNFACN_","_BRNBD_",YES",TO=BRNFACN_","_BRNED_",YES"
 ;end of Patch 1 changes
 ;
 K DHIT,DIOEND,DIOBEG
 D EN1^DIP
END ;
 K BRNBD,BRNED,BRNSD,X,DD0,B
 Q
