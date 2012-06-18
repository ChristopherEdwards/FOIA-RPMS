ACHSDND ; IHS/ITSC/PMF - DENIAL DELETE ;  [ 02/12/2002  10:34 AM ]
 ;;3.1;CONTRACT HEALTH MGMT SYSTEM;**3**;JUN 11, 2001
 ;ACHS*3.1*3  improve patient look up
 ;
 ;D SETCK^ACHSDF1 G END:$D(ACHS("NOTSET"))  ; ACHS*3.1*3
 D SETCK^ACHSDF1 I $D(ACHS("NOTSET")) Q  ; ACHS*3.1*3
A1 ;
 ;S DIC="^ACHSDEN("_DUZ(2)_",""D"",",DIC(0)="QAZEMI",DIC("A")="Enter the DENIAL NUMBER or PATIENT NAME : "  ; ACHS*3.1*3
 ;D ^DIC G END:+Y<1 S DA=+Y K DIC  ; ACHS*3.1*3
 ;
 S ACHDOCT="denial"  ; ACHS*3.1*3
 D ^ACHSDLK  ; ACHS*3.1*3
 I $D(ACHDLKER) D END Q  ; ACHS*3.1*3
 S DA=ACHSA  ; ACHS*3.1*3
 ;
A2 ;
 W !!,"Sure  You want to delete Denial #: ",$P($G(^ACHSDEN(DUZ(2),"D",DA,0)),U)
 W !?25," Issued for ",$S($P($G(^ACHSDEN(DUZ(2),"D",DA,0)),U,6)="N":$P($G(^ACHSDEN(DUZ(2),"D",DA,10)),U),$P($G(^ACHSDEN(DUZ(2),"D",DA,0)),U,5):$P($G(^DPT($P($G(^ACHSDEN(DUZ(2),"D",DA,0)),U,5),0)),U),1:"(Temporary)"),"  ? Delete  NO// "
 D READ^ACHSFU G NOND:"Nn"[Y!(Y="")!$D(DUOUT) I ($E(Y)="?")!("Yn"'[Y) D YN^ACHS G A2
 G A1:$D(ACHS("EDIT")) S DIK="^ACHSDEN("_DUZ(2)_",""D"",",DA(1)=DUZ(2) D ^DIK W !!,*7,"This denial has been deleted.",! G A1
END ;
 K ACHS,DA,DIC,DR
 Q
NOND ;
 W !!,*7,"<< Nothing Deleted >> ",!
 G A1
