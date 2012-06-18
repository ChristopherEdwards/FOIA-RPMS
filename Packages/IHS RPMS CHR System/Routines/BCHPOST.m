BCHPOST ; IHS/TUCSON/LAB - POST-INIT TO CHR PACKAGE ;  [ 10/28/96  2:05 PM ]
 ;;1.0;IHS RPMS CHR SYSTEM;;OCT 28, 1996
 ;
 S BCHPKG=$O(^DIC(9.4,"C","BCH",""))
 D ^XBKVAR
VALM ;
 W !,"Unloading List Manager Templates"
 D ^BCHL
PROTO1 ;
 W !,"Unloading PROTOCOL entries"
 D ^BCHONIT
PCCMC ;
 W !!,"Updating PCC Master Control file."
 S DIR(0)="Y",DIR("A")="Do you want to turn on the CHR to PCC Link (pass data from CHR to PCC)",DIR("B")="Y" K DA D ^DIR K DIR
 G:$D(DIRUT) XIT
 G:'Y SITE
 S BCHX=Y
LOC ;
 S BCHLOC=""
 S DIC="^AUTTLOC(",DIC(0)="AEMQ",DIC("A")="Enter Facility:  ",DIC("B")=$P(^DIC(4,DUZ(2),0),U) D ^DIC K DIC,DA
 G:X="" SITE
 G:Y=-1 LOC
 S BCHLOC=+Y
 ;SET MASTER CONTROL
 I '$D(^APCCCTRL(+Y)) S DLAYGO=9001000,X="`"_BCHLOC,DIC(0)="L",DIADD=1,DIC="^APCCCTRL(" D ^DIC ;add entry is none exists
 S ^APCCCTRL(BCHLOC,11,BCHPKG,0)=BCHPKG_U_BCHX
 S DIK="^APCCCTRL(",DA=BCHLOC D IX1^DIK
SITE ;update chr site parameters
 W !,"You must now update the CHR Site Parameter File",!
 S:DUZ(0)'["@" DUZ(0)="@"
 S DIC="^BCHSITE(",DIC(0)="AEMQL" D ^DIC
 G:Y=-1 MAIL
 S DA=+Y,DIE="^BCHSITE(",DR="[BCH E SITE PARAMETERS]" D ^DIE
 ;
MAIL ;
 D MAILGRP ;                 find/create CHR MANAGER mail grp
 D BULLETIN ;                add CHR MANAGER mail grp to bulletins
 ;
ADDEN ;EP - Adding 1-99 CHRPC## entries to the HL7 APPLICATION PARAMETER file
 S BCHHL7=$O(^DIC(9.4,"B","HEALTH LEVEL SEVEN",0))
 I 'BCHHL7 D  G XIT
 .  W !?5,"Cannot find the HEALTH LEVEL SEVEN package entry.  Unable to install",!
 .  W ?5,"the required 1-99 CHRPC## entries to the following files:",!
 .  W !?30,"HL7 APPLICATION PARAMETER",!?30,"PROTOCOL",!!
 .  W !!?5,"Once the HL7 Package has been installed, this process can"
 .  W !?5,"be restarted with the following command:  D ADDEN^BCHPOST",!!
 .  K BCHHL7
 .  Q
 K BCHHL7
 W !,"Adding required entries to the HL7 APPLICATION PARAMETER file."
 D ^BCHPOS1
 ;
PROTO2 ; Add 1-99 BCH HL7 SERVER CHRPC## entries to the PROTOCOL file
 W !,"Adding 1-99 BCH HL7 SERVER CHRPC## entries to the PROTOCOL file."
 D ^BCHPOS2
HLLOG ;add CHRPEN entry to HL7 LOWER LEVEL PROTOCOL file
 I $D(^HLCS(869.2,"B","CHRPEN")) W !!,"HL7 Lower Level Protocol Parameter exists" G HLLOG1
 S DIC(0)="L",DIC="^HLCS(869.2,",DLAYGO=869.2,DIADD=1,X="CHRPEN",DIC("DR")=".02///MAILMAN;100.01///CHR MANAGER" D FILE^DICN
 I Y=-1 W !!,"Entry of HL7 Lower Level Protocol Entry FAILED!"
HLLOG1 ;
 ;add to HL LOGICAL LINK
 I $D(^HLCS(870,"B","CHRPEN")) W !!,"HL Logical Link already exists." G XIT
 S DIC(0)="L",DIC="^HLCS(870,",X="CHRPEN",DLAYGO=870,DIADD=1,DIC("DR")="2///CHRPEN;21///1000" D FILE^DICN
 I Y=-1 W !!,"Entry of HL7 Logical Link FAILED!",!!
XIT ;
 W !!,$C(7),$C(7),"Please make sure that the XQSERVER Bulletin entry has a MAIL GROUP assigned",!,"to it.",!!
 K DA,DIC,DR,Y,X,D0,DD,DI,DIE,DIX,DIY,DIZ,DO,DQ,DZ
 K BCHPKG,BCHX,BCHLOC,BCHY1,BCHY2,BCHY3,BCHY,BCHMGRP
 W !,"ALL DONE WITH POST-INIT"
 Q
MAILGRP ; finds or creates the CHR MANAGER mail group
 S BCHMGRP=$O(^XMB(3.8,"B","CHR MANAGER",0))
 I BCHMGRP W !,"CHR MANAGER Mail Group already exists.  Nothing added.",!! Q
 K DD,DO
 S DIC="^XMB(3.8,",DIC(0)="L",DLAYGO=3.8
 S DIC("DR")="4////PU;5////"_DUZ_";5.1////"_DUZ_";10////0;3///This is the CHR MANAGER Mail Group."
 S X="CHR MANAGER"
 D FILE^DICN K DIC
 I Y<0 W !,"Entry was unsuccessful:  ",X K X Q
 W:+Y !!?5,"I created a CHR MANAGER Mail Group entry.  Please add appropriate",!?5,"members to this group.",!
 S BCHMGRP=+Y
 K X,Y,DLAYGO
 Q
 ;
BULLETIN ; add CHR MANAGER mail group to bulletins
 S BCHBULL1="BCH CHR TRANSMISSION ERROR"
 S BCHBULL2="BCH PCC PACKAGE LINK FAIL"
 F BCHBULL=BCHBULL1,BCHBULL2 D
 .  S BCHBIEN=$O(^XMB(3.6,"B",BCHBULL,0))
 .  I 'BCHBIEN W !,BCHBULL," bulletin not found.....I was unable to add this bulletin to the CHR MANAGER mail group." Q
 . Q:$D(^XMB(3.6,BCHBIEN,2,"B",BCHMGRP))  ;quit if already there
 .  S DIC="^XMB(3.6,"_BCHBIEN_",2,"
 .  S DIC(0)="L"
 .  S DIC("P")=$P(^DD(3.6,4,0),U,2)
 .  S DA(1)=BCHBIEN
 .  S X=BCHMGRP
 .  K DD,DO
 .  D FILE^DICN K DIC
 .  I +Y<0 W !?5,"Multiple entry was unsuccessful:  ",X K X Q
 .  W !?5,"CHR MANAGER Mail Group added to the "_BCHBULL_" Bulletin."
 .  K X,Y,DA
 .  Q
 K BCHBIEN,BCHBULL,BCHBULL1,BCHBULL2
 W !!
 Q
 ;
