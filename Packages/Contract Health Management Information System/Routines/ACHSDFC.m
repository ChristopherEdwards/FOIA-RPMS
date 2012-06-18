ACHSDFC ; IHS/ITSC/PMF - DEFERRED SERVICE CANCEL ;  [ 12/06/2002  10:36 AM ]
 ;;3.1;CONTRACT HEALTH MGMT SYSTEM;**18**;JUN 11, 2001
 ;ACHS*3.1*4  patient lookup changes
 ;IHS/SET/GTH ACHS*3.1*5 12/06/2002 - Prevent <UNDEF>.
 ;ACHS*3.1*18 4/1/2010;IHS/OIT/ABK;Change every occurrance of Deferred to Unmet Need
 ;
 D VIDEO^ACHS
LOOK ; --- Lookup a Deferred service, ask Cancel
 N ACHSDA,DA,DIC,DIE,DR
 W !!
 ;
 ;ACHS*3.1*4  4/19/02  pmf  change patient look up
 ;S DIC="^ACHSDEF("_DUZ(2)_",""D"","  ;  ACHS*3.1*4
 ;S DIC(0)="QAEMZ"  ;  ACHS*3.1*4
 ;S DA(1)=DUZ(2)  ;  ACHS*3.1*4
 ;S DIC("A")="Enter the DEFERRED SERVICE NUMBER or PATIENT NAME: "  ;  ACHS*3.1*4
 ;S DIC("S")="I $E($P($G(^(0)),U))'=""#"",$P($G(^(0)),U,14)'=""Y"""  ;  ACHS*3.1*4
 ;S DIC("W")="W "" ""_$S($P($G(^(0)),U,5)=""Y"":$P($G(^DPT($P($G(^(0)),U,6),0)),U),$P($G(^(0)),U,5)=""N"":$P($G(^(0)),U,7),1:""UNDEFINED"")"  ;  ACHS*3.1*4
 ;D ^DIC  ;  ACHS*3.1*4
 ;I +Y<1 D END Q  ;  ACHS*3.1*4
 ;I $D(DTOUT)!$D(DUOUT) D END Q  ;  ACHS*3.1*4
 ;S ACHSDA=+Y  ;  ACHS*3.1*4
 ;
 ;{ABK, 3/31/10}K DFN S ACHDOCT="deferral"  ;  ACHS*3.1*4
 K DFN S ACHDOCT="unmet need"  ;  ACHS*3.1*4
 D ^ACHSDFLK  ;  ACHS*3.1*4
 I $D(ACHDLKER) D RTRN^ACHS Q  ;  ACHS*3.1*4
 S ACHSDA=ACHSA  ;  ACHS*3.1*4
 ;
 ;{ABK, 3/31/10}W !!,*7,*7,IORVON,"Are You Sure You Want To Cancel This Deferred Services Document? ",IORVOFF,!!,IORVON,"Once Cancelled It Can Never Be Retrieved Again.",IORVOFF,!!
 ;{ABK, 3/31/10}S %=$$DIR^ACHS("Y","Do you want to CANCEL this Deferred Services Document","NO","Once Cancelled It Can Never Be Retrieved Again.","",2)
 W !!,*7,*7,IORVON,"Are You Sure You Want To Cancel This Unmet Needs Document? ",IORVOFF,!!,IORVON,"Once Cancelled It Can Never Be Retrieved Again.",IORVOFF,!!
 S %=$$DIR^ACHS("Y","Do you want to CANCEL this Unmet Needs Document","NO","Once Cancelled It Can Never Be Retrieved Again.","",2)
 ;
 I $D(DUOUT)!$D(DTOUT) D END Q
 G NOT:'%
 ;
SET ; --- Cancelling Deferred Service
 I '$$LOCK^ACHS("^ACHSDEF(DUZ(2),""D"",ACHSDA)","+") D END Q
 ;{ABK, 3/31/10}W !!,*7,*7,"Now Cancelling Deferred Service Number ",$$DF^ACHS(0,1),IORVOFF
 W !!,*7,*7,"Now Cancelling Unmet Need Number ",$$DF^ACHS(0,1),IORVOFF
 S DA=ACHSDA
 ;
 ;S DIE=DIC;ACHS*3.1*5 12/06/2002
 S DIE="^ACHSDEF("_DUZ(2)_",""D""," ;ACHS*3.1*5 12/06/2002
 ;
 S DR="14///Y"
 D ^DIE
 ;{ABK, 3/31/10}W !!,*7,*7,"DEFERRED SERVICES DOCUMENT CANCELLED",!!
 W !!,*7,*7,"UNMET NEEDS DOCUMENT CANCELLED",!!
 I '$$LOCK^ACHS("^ACHSDEF(DUZ(2),""D"",ACHSDA)","-")
 D END
 Q
 ;
NOT ;
 ;{ABK, 3/31/10}W !!,*7,*7,"DEFERRED SERVICE DOCUMENT NOT CANCELLED, LEFT UNCHANGED",!!
 W !!,*7,*7,"UNMET NEED DOCUMENT NOT CANCELLED, LEFT UNCHANGED",!!
END ;
 D RTRN^ACHS
 Q
 ;
