AMHNAVR ; IHS/CMI/LAB - REF FORM ;
 ;;4.0;IHS BEHAVIORAL HEALTH;;MAY 14, 2010
 ;
 ;
 D EN^XBVK("AMH")
 W:$D(IOF) @IOF
 W !!,$$CTR^AMHNAVRP("*****  NAVAJO PSYCHIATRIC HOSPITALIZATION REFERRAL  *****",80),!
 S DIR(0)="S^A:Add a new Psychiatric Hospitalization Referral;E:Edit an Existing Psychiatric Hospitalization Referral;P:Print a Referral Form",DIR("A")="Action",DIR("B")="A" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) D XIT Q
 S AMHACT=Y
 D @AMHACT
 D XIT
 Q
A ;
 W:$D(IOF) @IOF
 W !!,"This option should be used to add a visit to the BH system and then to",!,"complete a Psychiatric Referral Form.",!!
 D EN^XBVK("AMH")
 D GETPAT
 I 'AMHPAT D XIT Q
1 ; -- add visit
 D ^AMHLEIN
 S AMHPATCE=1
 S AMHNAVR=1
 ;get defaults
 D GETTYPE^AMHLE
 I $G(AMHPTYPE)="" D XIT Q
 D GETDATE^AMHLE
 I $G(AMHDATE)="" D XIT Q
 S AMHVTYPE="R"
 D ADD^AMHLEP2
 I '$G(AMHR) W !!,"Record IEN missing!" D XIT Q
 S AMHCC=$P($G(^AMHREC(AMHR,21)),U)
 D ADDFORM
 D SUIC^AMHLEA
 D OTHER^AMHLEP2
 D PCCLINK^AMHLEP2
 D XIT
 D EN2^AMHEKL
 Q
 ;
GETPAT ;
 K DIC,DFN S AMHPAT="" S DIC=9000001,DIC(0)="AEMQZ" D ^DIC I Y>0 S (AMHPAT,DFN)=+Y
 Q
XIT ;
 D EN^XBVK("AMH")
 D KILL^AUPNPAT
 D ^XBFMK
 Q
ADDFORM ;
 W !!,"Now creating referral form...."
 W !,"Creating new record..." K DD,D0,DO,DINUM,DIC,DA,DR
 S DIC(0)="EL",DIC="^AMHRNRF(",DLAYGO=9002011.11,DIADD=1,X=AMHDATE,DIC("DR")=".02////^S X=$G(AMHPAT);.03////"_AMHR
 D FILE^DICN K DIC,DR,DIE,DIADD,DLAYGO,X,D0
 I Y=-1 W !!,$C(7),$C(7),"Behavioral Health Referral form is NOT complete!!  Deleting Record.",! D PAUSE^AMHLEP2 Q
 S AMHREF=+Y
 I AMHVTYPE="R" S DA=AMHREF,DDSFILE=9002011.11,DR="[AMH ADD NAV REFERRAL]" D ^DDS
 ;print form
 S DIR(0)="Y",DIR("A")="Do you wish to print this referral form",DIR("B")="Y" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) Q
 I 'Y Q
 S XBRC="",XBRP="^AMHNAVRP",XBNS="AMH",XBRX=""
 D ^XBDBQUE
 Q
P ;PRINT form
 W !!,"Print a Psychiatric Hospitalization Referral Form",!!
 D GETPAT
 I 'AMHPAT D XIT Q
 S AMHRDATE=""
 S DIR(0)="D^::EP",DIR("A")="Enter Referral Date" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) D XIT Q
 S AMHRDATE=Y
 ;get referral form
 S AMHREF="",X=0 F  S X=$O(^AMHRNRF("AC",AMHPAT,X)) Q:X'=+X  I $P(^AMHRNRF(X,0),U)=AMHRDATE S AMHREF=X
 I 'AMHREF W !!,"No referral form on file for that date." G P
 S DIR(0)="Y",DIR("A")="Do you wish to print this referral form",DIR("B")="Y" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) Q
 S XBRC="",XBRP="^AMHNAVRP",XBNS="AMH",XBRX=""
 D ^XBDBQUE
 D XIT
 Q
E ;EP
 W !!,"Edit a Psychiatric Hospitalization Referral Form",!!
 D GETPAT
 I 'AMHPAT D XIT Q
 S AMHRDATE=""
 S DIR(0)="D^::EP",DIR("A")="Enter Referral Date" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) D XIT Q
 S AMHRDATE=Y
 ;get referral form
 S AMHREF="",X=0 F  S X=$O(^AMHRNRF("AC",AMHPAT,X)) Q:X'=+X  I $P(^AMHRNRF(X,0),U)=AMHRDATE S AMHREF=X
 I 'AMHREF W !!,"No referral form on file for that date." G E
 S DA=AMHREF,DDSFILE=9002011.11,DR="[AMH ADD NAV REFERRAL]" D ^DDS
 S DIR(0)="Y",DIR("A")="Do you wish to print this referral form",DIR("B")="Y" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) Q
 I 'Y Q
 S XBRC="",XBRP="^AMHNAVRP",XBNS="AMH",XBRX=""
 D ^XBDBQUE
 D XIT
 Q
