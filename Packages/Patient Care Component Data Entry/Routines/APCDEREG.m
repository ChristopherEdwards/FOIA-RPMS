APCDEREG ; IHS/CMI/LAB - HS IN DATA ENTRY ;
 ;;2.0;IHS PCC SUITE;;MAY 14, 2009
 ;
 N DIC,DA,D0,X,Y,DP,DI,DL
 I $G(AUPNPAT)="" W !!,$C(7),$C(7),"Sorry I don't know the patient.",! Q
 D GETTYPE
 Q
GETTYPE ;
 S APCDREGT=""
 W !,"The following is a list of registers this patient can be added to."
 W !,"If you choose a CASE MANAGEMENT REGISTER you will be prompted to"
 W !,"enter which of the ",$$CNTCMS," CMS registers to add the patient to.",!
 NEW APCDX,APCDC S (APCDX,APCDC)=0 F  S APCDX=$O(^APCDREGA(APCDX)) Q:APCDX'=+APCDX  D
 .S APCDC=APCDC+1 I $P(^APCDREGA(APCDX,0),U)="CASE MANAGEMENT REGISTER" S APCDYY=APCDC
 .S APCDY(APCDC)=APCDX
 .W !?2,APCDC,") ",$P(^APCDREGA(APCDX,0),U)
 S DIR(0)="N^1:99999:0",DIR("A")="Enter the REGISTER you wish to add "_$P(^DPT(AUPNPAT,0),U)_"  to",DIR("B")="" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) Q
 S APCDREGT=Y
 I Y=APCDYY D CMSREG I APCDCMS="" W !,"CMS Register not selected." G GETTYPE
 X ^APCDREGA(APCDY(APCDREGT),11)
 K APCDYY,APCDY,APCDX,APCDC
 Q
CMSREG ;GET WHICH CMS REGISTER
 W !!
 S APCDCMS=""
 D ^XBFMK
 S DIC("A")="Enter the name of the CASE MANAGEMENT Register: ",DIC="^ACM(41.1,",DIC(0)="AEMQ" D ^DIC
 I Y=-1 D ^XBFMK Q
 S APCDCMS=+Y
 D ^XBFMK
 Q
CMS(PATIENT,REGISTER) ;EP
 I $D(^ACM(41,"AC",PATIENT,REGISTER)) W !!?14,$P(^DPT(PATIENT,0),U)," is already on the ",$P(^ACM(41.1,REGISTER,0),U)," register." Q
 W !!?10,"Adding ",$P(^DPT(PATIENT,0),U),!?13," to the ",$P(^ACM(41.1,REGISTER,0),U)," CMS Register."
 K DIC,DD
 S X=REGISTER,(DIE,DIC)="^ACM(41,",DIC(0)="L",DIC("DR")=".02////"_PATIENT_";1////A;2////"_DT_";4////"_DT
 K DD,DO D FILE^DICN K DIC,DIE,DR,DA
 W !!,$P(^DPT(PATIENT,0),U)," has been added to the ",$P(^ACM(41.1,REGISTER,0),U)," Register."
 Q
ASTHMA(PATIENT) ;
 I $D(^BATREG(PATIENT)) W !!,$P(^DPT(PATIENT,0),U)," is already in the Asthma Register.",! Q
 I $P($G(^BATSITE(DUZ(2),0)),U,7)'=1 W !!
 S (DINUM,X)=PATIENT,DIC(0)="L",DIC="^BATREG(",DIC("DR")=".02///U",DLAYGO=90181.01,DIADD=1 K DD,DO D FILE^DICN K DINUM,DLAYGO,DIADD
 I Y=-1 W !!,"Error encountered when attempting to add this patient to the asthma register." Q
 W !!,$P(^DPT(PATIENT,0),U)," has been added to the Asthma Register."
 ;send bulletin
 K XMB
 S XMB(1)=$P(^DPT(PATIENT,0),U),XMB(2)=$$DOB^AUPNPAT(PATIENT,"E"),XMB(3)=$$HRN^AUPNPAT(PATIENT,DUZ(2)),XMB(4)="",XMB(5)=$$LASTSEV^BATU(PATIENT,5)
 S XMB="BAT NEW PATIENT ON REGISTER"
 D ^XMB K XMB
 Q
WH(PATIENT) ;
 I $P(^DPT(PATIENT,0),U,2)'="F" W !!,"Females Only..." Q
 I $D(^BWP(PATIENT)) W !!,$P(^DPT(PATIENT,0),U)," is already in the WH Register.",! Q
 S (DINUM,X)=PATIENT
 ;---> SET CASE MANAGER DEFAULT.
 N APCDCMGR,DIC
 S APCDCMGR=$S($D(SITE):$P(^BWSITE(SITE,0),U,2),1:"")
 S:'$G(APCDPRMT) APCDPRMT=0
 S DIC("DR")=".1////"_APCDCMGR_";.11///Undetermined;.16///Undetermined"
 S DIC("DR")=DIC("DR")_";.18///Undetermined"
 S DIC("DR")=DIC("DR")_";.2////"_$$CDCID^BWUTL5(PATIENT,DUZ(2))_";.21////"_DT
 K DD,DO S DIC="^BWP(",DIC(0)="ML",DLAYGO=9002086
 D FILE^DICN K DIC
 ;---> IF Y<0, CHECK PERMISSIONS.
 I Y<0,APCDPRMT D  Q
 .W !!?5,"* UNABLE to add this patient to the Women's Health database."
 .W !?5,"  Please contact your site manager to check permissions."
 S Y=+Y
 W !!,$P(^DPT(PATIENT,0),U)," has been added to the Women's Health Register."
 Q
IMM(PATIENT) ;
 I $D(^BIP(PATIENT)) W !!,$P(^DPT(PATIENT,0),U)," is already in the Immunization Register.",! Q
 D AUTOADD^BIPATE(PATIENT,DUZ(2),.ERR)
 I $G(ERR)]"" W !!,ERR Q
 W !!,$P(^DPT(PATIENT,0),U)," has been added to the immunization Register."
 Q
CNTCMS() ;
 NEW X S (X,C)=0 F  S X=$O(^ACM(41.1,X)) Q:X'=+X  S C=C+1
 Q C
