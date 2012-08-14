ACMTRANS ; IHS/TUCSON/TMJ - CONTROL TRANSFER OF PATIENTS TO CMS ; [ 02/19/2002  12:14 PM ]
 ;;2.0;ACM CASE MANAGEMENT SYSTEM;**5**;JAN 10, 1996
 ;UTILITY TO TRANSFER CLIENTS FROM PCC REGISTERS, TAXONOMIES AND
 ;SEARCH TEMPLATES TO THE CMS
 ;;EP;ENTRY POINT
EN D SLCT
 D PCC:'$D(ACMQUIT)&$D(ACMSLCT)
EXIT K ACMRG,ACMRGNA,ACMU,ACMTRN,ACMTRNA,ACMTRNX,ACMRGTP,ACMX,ACMI,ACMSLCT
 K ACMQUIT,ACM1,ACM2,ACM3,ACMGLB,ACMGLB1
 Q
 ;
SLCT ;D HEAD^ACMMENU
SLCT1 S ACMX="DATA TRANSFER UTILITY",ACM1="Transfer from PCC REGISTER",ACM2="Transfer from PATIENT TAXONOMY",ACM3="Transfer from SEARCH TEMPLATE"
 ;W !!,?80-$L(ACMX)\2,ACMX,!! K ACMX
 ;F X=1,2,3 W !?14,X,")  ",@("ACM"_X)
 W !!
 ;S DIR(0)="NOA^1:3",DIR("A")="Transfer option ==> ",DIR("?",1)="Type '1' for PCC Transfer,",DIR("?",2)="     '2' for Patient Taxonomy",DIR("?")="  or '3' for Search Template."
 ;D ^DIR K DIR
 ;I Y<1 S ACMQUIT="" Q
 S Y=3
 S ACMSLCT=$S(Y=1:"PCC",Y=3:"SER",1:"TAX"),ACMTRN=Y
 Q
 ;
PCC D HEAD^ACMMENU
 S ACMX="ACM"_ACMTRN
 W !!,?80-$L(@ACMX)\2,@ACMX,!! K ACMX,ACMTRN
 I ACMSLCT="SER" D TLOOK G:Y<1 EXIT G TRX
 S ACMX(5)="W:ACMJ#2=1 !?14 W:ACMJ#2=0 ?45 W ACMTRNX",ACMTRNX="",ACMGLB1=$S(ACMSLCT="PCC":"^APCRREG(""B"")",1:"^ATXAX(""B"")"),ACMGLB=$S(ACMSLCT="PCC":"^APCRREG(",1:"^ATXAX(")
 F ACMJ=1:1 S ACMTRNX=$O(@ACMGLB1@(ACMTRNX)) Q:ACMTRNX=""  S ACMTRN="",ACMTRN=$O(@ACMGLB1@(ACMTRNX,ACMTRN)) X ACMX(5)
PCCO S DIC=ACMGLB,DIC(0)="AEMQ",DIC("A")=$S(ACMSLCT="PCC":"PCC REGISTER: ",1:"    TAXONOMY: ")
 D ^DIC K DIC
 Q:Y<1
 S ACMTRN=+Y,ACMTRNA=$P(Y,U,2),ACMRGTP=""
 W !
TRX D RGTPX^ACMGTP
 I '$D(ACMRG) K ACMRG,ACMRGNA,ACMRGTP,ACMTRNX,ACMTRN,ACMJ,ACMX Q
STATUS ;get status to transfer
 S DIR(0)="S^A:ACTIVE;I:INACTIVE;U:UNREVIEWED",DIR("A")="Enter Patient Transfer Status",DIR("B")="A",DIR("?")="Enter the status that will be assigned to the patient when transfered."
 D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 Q:$D(DIRUT)
 S ACMSTAT=Y,ACMSTAT(0)=Y(0)
 W !!?10,"The following transfer has been selected:",!!?10,"From ",$S(ACMSLCT="PCC":"PCC register: ",ACMSLCT="SER":"SEARCH TEMPLATE: ",1:" PT TAXONOMY: ")
 W ?30,ACMTRNA,!?12,"To CMS register:",?30,ACMRGNA,!?10,"Transfer Status: ",?30,ACMSTAT," - ",ACMSTAT(0),!!,?10,"Is that what you want"
 S %=2 D YN^DICN
 I %<1!(%=2) D EXIT Q
 I %=1 D TSK
MESS W !!?10,"Transfer of patients will be done in background mode.",!?10,"All patients will be entered as "_ACMSTAT(0),".  All cases",!?10,"should be reviewed and all patient data updated in the",!?10,@ACMRVON,ACMRGNA,@ACMRVOFF," register."
 W !
 D PAUSE^ACMMENU
 Q
TRANS S $P(^ACM(41.1,ACMRG,0),U,9)=1,ACMU=$S(ACMSLCT="PCC":"",1:0),ACMGLB=$S(ACMSLCT="PCC":"^APCRREG("_ACMTRN_",1,""B"")",ACMSLCT="SER":"^DIBT("_ACMTRN_",1)",1:"^ATXPAT("_ACMTRN_",11)")
 F  S ACMU=$O(@ACMGLB@(ACMU)) Q:ACMU=""  D:'$D(^ACM(41,"AC",ACMU,ACMRG)) MOVE
 S $P(^ACM(41.1,ACMRG,0),U,9)=""
 K ACMRG,ACMRGNA,ACMU,ACMTRN,ACMTRNA,ACMTRNX,ACMRGTP,ACMX,ACMI,ACMSLCT,DIC,DIE,DA,DR,DD
 S ZTREQ="@"
 Q
MOVE Q:$D(^ACM(41,"AC",ACMU,ACMRG))
 S:$P(^ACM(41.1,ACMRG,0),U,9)="" $P(^(0),U,9)=1
 S DIC="^ACM(41,",DIC(0)="L",DIC("DR")=".02////"_ACMU_";1////"_ACMSTAT_";2////"_DT_";4////"_DT,X=ACMRG
 K DD,DO D FILE^DICN K DIC,DA,DR,DIE
 D DECEASED^ACMLPAT(ACMU,+Y) ;IHS/CIM/THL PATCH 5
 Q
TSK S ZTRTN="TRANS^ACMTRANS",ZTDESC="TRANSFER PCC REGISTER OR TAXONOMY DATA TO CMS REGISTER",ZTSAVE("ACM*")="",ZTIO="",ZTDTH=$H
 D ^%ZTLOAD
 Q
TLOOK K DIC
 ;S DIC="^DIBT(",DIC(0)="AEQZ",DIC("A")="Select SEARCH TEMPLATE: ",DIC("S")="I (($P(^(0),U,4)=2!($P(^(0),U,4)=9000001))) Q:'$D(DS(2))  I $D(^DIBT(DS(2),1))"
 S DIC="^DIBT(",DIC(0)="AEQZ",DIC("A")="Select SEARCH TEMPLATE: ",DIC("S")="I ($P(^(0),U,4)=2!($P(^(0),U,4)=9000001)),$D(^DIBT(+$G(Y),1))" ;IHS/CIM/THL/PATCH 5
 D ^DIC K DIC,DA,DR
 Q:+Y<1
 W !
 S ACMTRN=+Y,ACMTRNA=$P(Y,U,2),(ACMRGTP,ACMI)=""
 F ACMYI=1:1 S ACMI=$O(^DIBT(ACMTRN,1,ACMI)) Q:ACMI=""
 W !!?10,"There are ",ACMYI-1," patients in this SEARCH TEMPLATE."
 K ACMI,ACMYI
 W !
 S ACMYI=0
 F  S ACMYI=$O(^DIBT(ACMTRN,"%D",ACMYI)) Q:'ACMYI  W !,?3,^(ACMYI,0)
 K ACMYI
 W !
 Q