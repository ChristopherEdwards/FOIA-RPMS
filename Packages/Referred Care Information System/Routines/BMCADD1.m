BMCADD1 ; IHS/PHXAO/TMJ - add a referral part 2 ;      
 ;;4.0;REFERRED CARE INFO SYSTEM;**3**;JAN 09, 2006
 ;
 ;IHS/ITSC/FCJ ADD REQUEST TO SEND A MESSAGE
 ;    MODIFIED COMMENTS SECTION, TO ALLOW
 ;    BUS OFF AND MED HX TO CALL FROM BMCADD
 ;4.0*3 9.27.2007 IHS/OIT/FCJ Added test to send Alert to Physicians
 ;
DXPX ;EP GET PROVIDIONAL DIAGNOSES/PROCEDURES IF WANTED
 D MEDHX
 Q:'BMCDXPR  ;            quit if site not entering dx/px
 D DX
 D PX
 Q
 ;
MEDHX ; GET PROVISIONAL DIAGNOSES
 W:$D(IOF) @IOF
 W !?5,"Referral #: ",$$GETR^BMC
 W !?5,"Referral Date: " S Y=$P(^BMCREF(BMCRIEN,0),U) D DD^%DT W Y
 W ?40,"Patient Name: ",$P(^DPT(BMCDFN,0),U)
 W !!
 D MEDCOM^BMCADD ;IHS/ITSC/FCJ ADDED FOR MED HX COM NO LONGER ON FORM
 Q
DX I $G(BMCRR),$O(^BMCRTNRF(BMCRR,61,0)) D ADDDX^BMCADD1,DX^BMCMOD Q
 S DIR(0)="Y",DIR("A")="Do you want to enter a Provisional Diagnosis",DIR("B")="N",DIR("?")="Enter 'YES' to enter provisional diagnoses now."
 D ^DIR K DIR
 Q:$D(DIRUT)
 S BMCASK=Y
 I BMCASK=1,BMCDXCPT=1 S BMCQ=0 D ^BMCDXSTF G DXASK
 I BMCASK=1 S BMCQ=0 F  D  Q:BMCQ
 . S BMCLOOK=1
 .;IHS/ITSC/FCJ REQUEST TO DSPLY ICD INSTEAD OF DX PROMPTS;MOD NXT SEC
 . S DIC="^ICD9(",DIC(0)="AMEQ",DIC("A")="Enter ICD-9 DX code: "
 . D ^DIC
 . I Y=-1 S BMCQ=1 Q
 . S X="`"_$P(Y,U),DIADD=1,DIC(0)="L",DIC="^BMCDX(",DLAYGO=90001.01 D ^DIC
 . S DA=$P(Y,U),DR=".02////"_BMCDFN_";.03////"_BMCRIEN_";.04////P"_";.05;.06"
 . S DIE="^BMCDX("
 . D DIE^BMCFMC
 . K BMCLOOK
 . W !
 K BMCDX,DIC,DIE,DR,DA,DIC("A"),DIADD,DIC(0)
DXASK ;
 S BMCDXASK=0
 D ^BMCRCHK
 I BMCDXASK=1 D DX^BMCMOD S BMCDXASK=0
 S BMCQ=0
 Q
 ;
PX ; GET PROVISIONAL PROCEDURES
 W !
 I $G(BMCRR),$O(^BMCRTNRF(BMCRR,62,0)) D ADDPX^BMCADD1,PROC^BMCMOD Q
 S DIR(0)="Y",DIR("A")="Do you want to enter a Provisional Procedure",DIR("B")="N",DIR("?")="Enter 'YES' to enter provisional procedures now."
 D ^DIR K DIR
 Q:$D(DIRUT)
 S BMCASK=Y
 I BMCASK=1,BMCDXCPT=1 S BMCQ=0 D ^BMCPXSTF G PXASK
 I BMCASK=1 S BMCQ=0 F  D  Q:BMCQ
 . S BMCLOOK=1
 . S BMCPXT="P"
 . S DIE="^BMCREF(",DA=BMCRIEN,DR="[BMC PROCEDURE ADD]"
 . D DIE^BMCFMC
 . K BMCLOOK
 . I $G(BMCPX) ;*************
 . S:'$G(BMCPX) BMCQ=1
 . K BMCPX
PXASK ;Check Existence of Primary PX
 S BMCPXASK=0
 D ^BMCRCHK1
 I BMCPXASK=1 D PROC^BMCMOD S BMCPXASK=0
 S BMCQ=0
 Q
 ;
COMMENTS ;EP ADD COMMENTS ;CALLED FR BMCADD,BMCADDFY,BMCADDS,BMCMOD,BMCMODS
 ;IHS/ITSC/FCJ MOD TO ALLOW FOR CALL BY BO COM AND MED HX COM FOR DATA ETRY
 S BMCQ=0,BMCLOOK=1
 S X=DT,DLAYGO=90001.03,DIADD=1,DIC(0)="L",DIC="^BMCCOM(" D ^DIC
 S DA=+Y,DIE=DIC
 ;S DR=".01;.02////"_BMCDFN_";.03////"_BMCRIEN_";.04////"_DUZ_";.05////"_BMCCTYP_";1"
 S DR=".02////"_BMCDFN_";.03////"_BMCRIEN_";.04////"_DUZ_";.05////"_BMCCTYP_";1"
 D ^DIE
 I '$D(^BMCCOM(DA,1)) S DIK="^BMCCOM(" D ^DIK
 E  S $P(^BMCCOM(DA,1,0),U,2)="90001.031"
 K BMCLOOK,DIE,DR,DLAYGO,DIADD,DIC,DA
 Q:BMCCTYP'="C"
 S DIE="^BMCREF(",DA=BMCRIEN,DR=".31"
 D DIE^BMCFMC
 S BMCQ=0
 Q
 ;
MGDCARE ;EP;Prompt for Managed Care Committee Action
 W !
 Q:BMCMGCR'=1
 S DIR(0)="Y",DIR("A")="Do you want to enter Managed Care Committee Action",DIR("B")="N",DIR("?")="Enter 'YES' to enter Managed Care Committee Actions now."
 D ^DIR K DIR
 Q:$D(DIRUT)
 I Y S BMCQ=0 D
 . S BMCLOOK=1
 . S DIE="^BMCREF(",DA=BMCRIEN,DR="[BMC COMMITTEE ACTION ADD]"
 . D DIE^BMCFMC
 S BMCQ=0
 Q
 ;
STATIC ;EP - STORE STATIC DATA
 W !,"Storing static fields....",!
 S BMCREC=^BMCREF(BMCRIEN,0)
 S Y=^DPT(BMCDFN,0)
 S DR="5101///"_$P(Y,U) ;          name
 S DR=DR_";5103///"_$P(Y,U,3) ;    dob
 S DR=DR_";5104///"_$P(Y,U,9) ;    ssn
 S DR=DR_";5107///"_$P(Y,U,2) ;    sex
 S %=$P(BMCREC,U,5)
 I % D
 . S DR=DR_";5102///"_$P($G(^AUPNPAT(BMCDFN,41,%,0)),U,2) ; chart #
 . S DR=DR_";5113///"_$P($G(^DIC(4,%,0)),U) ;              facility
 . S DR=DR_";5114///"_$P($G(^AUTTLOC(%,0)),U,10) ;         asufac
 S Y=$G(^AUPNPAT(BMCDFN,51))
 I $P(Y,U,18)'="" S DR=DR_";5105///"_$P(Y,U,18) ;   comm
 I $P(Y,U,8) S DR=DR_";5106///"_$P($G(^AUTTTRI($P(Y,U,8),0)),U,2) ; tribe
 S %=$P(BMCREC,U,7)
 I % D
 . S DR=DR_";5108///"_$P($G(^AUTTVNDR(%,0)),U) ;    vendor
 . S DR=DR_";5109///"_$P($G(^AUTTVNDR(%,51)),U) ;   ein
 S %=$P(BMCREC,U)
 S DR=DR_";5110///"_$$MCR^AUPNPAT(BMCDFN,%) ;   medicare
 S DR=DR_";5111///"_$$MCD^AUPNPAT(BMCDFN,%) ;   medicaid
 S DR=DR_";5112///"_$$PI^AUPNPAT(BMCDFN,%) ;    private insurance
 ;
 S DIE="^BMCREF(",DA=BMCRIEN
 D DIE^BMCFMC
 W !,"Entry of Referral ",$P(^BMCREF(BMCRIEN,0),U,2)," is complete.",!
 ;IHS/ITSC/FCJ REQUEST TO SEND A MESSAGE NXT 4 LNES
 I BMCCHSA,BMCRTYPE="C" D ENMM^BMCMM
 I BMCIHSA,BMCRTYPE="I" D ENMM^BMCMM
 I BMCOTHRA,BMCRTYPE="O" D ENMM^BMCMM
 I BMCHOUSA,BMCRTYPE="N" D ENMM^BMCMM
 ;BMC 4.0*3 9.27.2007 IHS/OIT/FCJ ADDED NXT LINE TO TEST TO SEND ALERT TO PHYS
 I ($P($G(^BMCPARM(DUZ(2),4100)),U,9)="Y")!($P($G(^BMCPARM(DUZ(2),4100)),U,10)="Y") NEW XQA S BMCRHDR="New" D PALRT1^BMCALERT
 D EOP^BMC
 Q
 ;
ADDDX ;EP auto stuff dx and proc from routine referral
 W !,"Adding referral diagnoses.."
 K BMCAR D ENPM^XBDIQ1(90001.61,BMCRR_",0",".01","BMCAR(","I")
 Q:'$D(BMCAR)
 S BMCI=0 F  S BMCI=$O(BMCAR(BMCI)) Q:BMCI'=+BMCI  S X=$G(BMCAR(BMCI,.01,"I")) I X S DLAYGO=90001.01,DIC="^BMCDX(",DIC(0)="L" K DD,DA,D0 D FILE^DICN D
 .I Y=-1 W !!,"bad news -- error creating dx record - notify programmer" Q
 .S DIE="^BMCDX(",DA=+Y,DR=".02////"_BMCDFN_";.03////"_BMCRIEN_";.04////P" D ^DIE
 .I $D(Y) W !!,"ADDING DX FAILED" Q
 .D ^XBFMK
 K BMCAR,X,BMCI
 Q
ADDPX ;EP auto stuff proc from routine referral
 W !,"Adding referral procedures.."
 K BMCAR D ENPM^XBDIQ1(90001.62,BMCRR_",0",".01","BMCAR(","I")
 Q:'$D(BMCAR)
 S BMCI=0 F  S BMCI=$O(BMCAR(BMCI)) Q:BMCI'=+BMCI  S X=$G(BMCAR(BMCI,.01,"I")) I X S DLAYGO=90001.02,DIC="^BMCPX(",DIC(0)="L" K DD,DA,D0 D FILE^DICN D
 .I Y=-1 W !!,"bad news -- error creating proc record - notify programmer" Q
 .S DIE="^BMCPX(",DA=+Y,DR=".02////"_BMCDFN_";.03////"_BMCRIEN_";.04////P" D ^DIE
 .I $D(Y) W !!,"ADDING PROC FAILED" Q
 .D ^XBFMK
 K BMCAR,BMCI
 Q
