BMCFDRA ; IHS/PHXAO/TMJ - DRIVER TO PRINT ALT RESOURCE LETTER ;  
 ;;4.0;REFERRED CARE INFO SYSTEM;**4**;JAN 09, 2006
START ;
 W:$D(IOF) @IOF
 W "**********  REFERRAL FORM PRINT  **********",!!
 W "This report will produce a hard copy computer generated Alternate Resource",!,"Application Letter",!
 S BMCQUIT=0
GETTYPE ;Select Alternate Resource Contact & set Text Verbiage
 S BMCFTYPE=3
 S DIC="^BMCALT(",DIC(0)="AEMQ",DIC("A")="Select Letter Contact Point: " D ^DIC K DA,DIC
 G:Y=-1 XIT
 S BMCCPRV=+Y
 S BMCCPRVP=$P($G(^BMCALT(BMCCPRV,0)),U)
GETREF ;get referral entry
 W !! S BMCREF=""
 S DIC="^BMCREF(",DIC(0)="AEMQ",DIC("A")="Select Referral by Patient Name, date of referral or referral #: " D ^DIC K DA,DIC
 G:Y=-1 XIT
 S BMCREF=+Y
 I $D(^BMCTFORM(BMCFTYPE,11)) X ^BMCTFORM(BMCFTYPE,11) G:BMCQUIT GETREF
 ;
 ;Alt Resource Documentation Information
 S DA=BMCREF,DIE="^BMCREF(",DR="1501Enter Appointment Documentation" D ^DIE K DA,DIE,DIU,DIVDR
 ;
TYPE ;Get Type of Letter Dissemination
 S BMCLTYP=""
 S DA=BMCREF,DIE="^BMCREF(",DR="1404Select Type of Distribution" D ^DIE K DA,DIE,DIU,DIVDR
 ;
 S BMCLTYP=X
 I BMCLTYP'="M" G ZIS
 ;
 ;Alt Resource Mail Certified Receipt Number
 S DA=BMCREF,DIE="^BMCREF(",DR="1403Enter Certified Mail Receipt" D ^DIE K DA,DIE,DIU,DIVDR
 ;
ZIS ;
 W !! S XBRC="COMP^BMCFDRA",XBRP="PRINT^BMCFDRA",XBNS="BMC",XBRX="XIT^BMCFDRA"
 D ^XBDBQUE
 Q
 ;
PRINT ;EP
 X:$D(^BMCTFORM(BMCFTYPE,12)) ^BMCTFORM(BMCFTYPE,12)
 Q
XIT ;
 ;BMC*4.0*4 IHS/OIT/FCJ ADDED BMCSIR
 K BMCCAP,BMCCHSR,BMCDA,BMCFILE,BMCFTYPE,BMCIOM,BMCKPDA,BMCNODE,BMCPG,BMCQUIT,BMCR0,BMCREF,BMCRNS,BMCV,BMCWP,BMCX,BMCY,BMCI,BMCDFN,BMCCHSAS
 K A,C,D,D0,D1,DA,DD,DDSFILE,DI,DIADD,DIC,DICR,DIE,DIK,DINUM,DIPGM,DIQ,DIR,DIWF,DIWL,DIWR,DLAYGO,DO,DQ,DR,DTOUT,F,G,I,J,N,P,T,X,Y,Z
 K BMCPROUT,BMCN,BMCNUM,BMCAGE,BMCFIRST,BMCLAST,BMCLTYP,BMCSIR
 Q
COMP ;
 Q
WP ;EP - Entry point to print wp fields pass node in BMCWP
 ;PASS FILE IN BMCFILE, ENTRY IN BMCREF
 NEW G,P,BMCX
 K BMCWP
 K ^UTILITY($J,"W")
 S BMCX=0,P=0
 S G=$S($G(G)]"":G,1:^DIC(BMCFILE,0,"GL")),G=G_BMCDA_","_BMCNODE_",BMCX)"
 S DIWR=$S($G(BMCIOM):BMCIOM,1:IOM),DIWL=0 F  S BMCX=$O(@G) Q:BMCX'=+BMCX  D
 .S Y=$P(G,")")_",0)"
 .S X="" I $G(BMCCAP)]"",BMCX=1 S X=BMCCAP
 .S X=X_@Y D ^DIWP
 .Q
WPS ;EP
 S Z=0 F  S Z=$O(^UTILITY($J,"W",DIWL,Z)) Q:Z'=+Z  S P=P+1,BMCWP(P)=^UTILITY($J,"W",DIWL,Z,0)
 K DIWL,DIWR,DIWF,Z
 K ^UTILITY($J,"W"),BMCNODE,BMCFILE,BMCDA,G,BMCCOL,BMCCAP
 Q
CHSSTAT ;EP
 Q:BMCFTYPE'=1
 Q  ;Quit - No longer ask for CHS Preliminary Review per Stan 8/28/96
 Q:$P(^BMCREF(BMCREF,0),U,4)'="C"
 I $P($G(^BMCREF(BMCREF,11)),U,20)]"" S BMCCHSR=$P(^BMCREF(BMCREF,11),U,20) Q
 W !!,$C(7),$C(7),"The CHS Preliminary Review has not been entered.  Please enter it now.",!
 S DIE="^BMCREF(",DA=BMCREF,DR=1120 D ^DIE K DIE,DA
 S BMCCHSR=$P($G(^BMCREF(BMCREF,11)),U,20) I BMCCHSR="" S BMCCHSR="3" W !!,"No entry made.  Defaulting to 'TO BE DETERMINED'.",!!
 Q
AHCCCS ;EP
 W !!,$C(7),$C(7),"This letter must be printed on a printer capable of 132 character print.",!!
 Q
