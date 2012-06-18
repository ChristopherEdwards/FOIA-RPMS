BRNUSER ; IHS/PHXAO/TMJ - ROI USER INITAITED WORKLOAD REPORT AND (BY DATE RANGE) ;  
 ;;2.0;RELEASE OF INFO SYSTEM;*1*;APR 10, 2003
 ;;IHS/OIT/LJF 10/05/2007 PATCH 1 Added choice to print by
 ;             01/23/2008 PATCH 1 Added date range limits
 ;             01/242/008 PATCH 1 Added choice of facility
 ;
 ;
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
REPORT ; ask which user field to use in reporting workload ;IHS/OIT/LJF 10/05/2007 PATCH 1
 NEW BRNROLE
 W ! S DIR(0)="S^I:User Who INITIATED Request;A:User Who was ASSIGNED Request;C:User Who CLOSED Request"
 S DIR("A")="Select USER'S ROLE for Workload Reporting"
 S DIR("?")="There are 3 possible users handling request.  For which role do you want a report?"
 D ^DIR K DIR
 G:$D(DIRUT) BD
 S BRNROLE=Y
 ;IHS/OIT/LJF 10/05/2007 PATCH 1 end of code additions
 ;
ASK ;Ask if a particular User
 S BRNUSE=1,BRNUSE1=10000
 ;
 ;IHS/OIT/LJF 10/05/2007 PATCH 1
 ;W ! S DIR(0)="Y0",DIR("A")="Want to INCLUDE a particular User who Initiated the Disclosure",DIR("B")="NO"
 W ! S DIR(0)="Y0",DIR("A")="Want to INCLUDE a particular User",DIR("B")="NO"
 ;
 S DIR("?")="To RESTRICT to a particular User  - Answer Yes."
 D ^DIR K DIR
 G:$D(DIRUT) BD
 I 'Y G PRINT
USER ;ROI Disclosure USER
 S DIC=200,DIC(0)="AEMQ",DIC("A")="Enter User Name: "
 D ^DIC K DIC
 Q:$D(DIRUT)
 G:Y=0 ASK
 S BRNUSE=+Y,BRNUSE1=+Y
 ;
PRINT ;PRINT CLOSED DISCLOSURES BY DATE
 ;
 ;select facility
 NEW BRNFAC D ASKFAC^BRNU(.BRNFAC) I BRNFAC="" D END Q  ;IHS/OIT/LJF 01/24/2008 PATCH 1
 ;
 ;set up print
 S FLDS="[BRN DISCLOSURE INFO]",BY(0)="^BRNREC(""AD""," S L(0)=3,DIC="^BRNREC(",L=0
 ;
 ;IHS/OIT/LJF 10/05/2007 PATCH 1 reset print template based on user role selected
 S FLDS="[BRN DISCLOSURE "_$S(BRNROLE="I":"INFO]",BRNROLE="A":"ASSIGNED]",1:"CLOSED]")
 S BY(0)="^BRNREC"_$S(BRNROLE="I":"(""AD"",",BRNROLE="A":"(""AF"",",1:"(""AG"",")
 ;
 S FR(0,1)=BRNUSE,TO(0,1)=BRNUSE1
 S FR(0,2)=BRNBD,TO(0,2)=BRNED
 I BRNFAC>0 S DIS(0)="I $P(^BRNREC(D0,0),U,22)=BRNFAC"  ;IHS/OIT/LJF 01/24/2008 PATCH 1
 K DHIT,DIOEND,DIOBEG
 D EN1^DIP
END ;
 K BRNROLE   ;IHS/OIT/LJF 10/05/2007 PATCH 1
 K BRNBD,BRNED,BRNSD,BRNUSE,BRNUSE1,X,DD0,B Q
