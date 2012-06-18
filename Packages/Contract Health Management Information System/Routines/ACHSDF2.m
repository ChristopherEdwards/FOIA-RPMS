ACHSDF2 ; IHS/ITSC/PMF - UNMET NEED CAPTIONED DISPLAY ;   [ 10/16/2001   8:16 AM ]
 ;;3.1;CONTRACT HEALTH MGMT SYSTEM;**18**;JUN 11, 2001
 ;ACHS*3.1*18 4/1/2010;IHS/OIT/ABK;Change every occurrance of Deferred to Unmet Need
 ;
DUMP ;EP - From Option.
 ;SKIP INCOMPLETE AND CANCELLED DOCUMENTS
 S DIC("S")="I $E($P($G(^(0)),U))'=""#"",$P($G(^(0)),U,14)'=""Y"""
 S DIC("W")="W "" ""_$S($P($G(^(0)),U,5)=""Y"":$P($G(^DPT($P($G(^(0)),U,6),0)),U),$P($G(^(0)),U,5)=""N"":$P($G(^(0)),U,7),1:""UNDEFINED"")"
 ;{ABK,6/30/10}S DIC="^ACHSDEF("_DUZ(2)_",""D"",",DIC(0)="QAZEMI",DIC("A")="Enter the DEFERRED SERVICE NUMBER or PATIENT NAME : "
 S DIC="^ACHSDEF("_DUZ(2)_",""D"",",DIC(0)="QAZEMI",DIC("A")="Enter the UNMET NEED NUMBER or PATIENT NAME : "
 D ^DIC
 G K:+Y<1
 S DA=+Y
 K DIC
DEV ;
 S %ZIS="OPQ"
 D ^%ZIS
 I POP D HOME^%ZIS G K
 G:'$D(IO("Q")) START
 K IO("Q")
 I $D(IO("S"))!($E(IOST)'="P") W *7,!,"Please queue to system printers." D ^%ZISC G DEV
 ;{ABK,6/30/10}S ZTRTN="START^ACHSDF2",ZTDESC="CAPTIONED DISPLAY DEFERRED SERVICE DOC "_$P($G(^ACHSDEF(DUZ(2),"D",DA,0)),U)_"."
 S ZTRTN="START^ACHSDF2",ZTDESC="CAPTIONED DISPLAY UNMET NEED DOC "_$P($G(^ACHSDEF(DUZ(2),"D",DA,0)),U)_"."
 F %="DA" S ZTSAVE(%)=""
 D ^%ZTLOAD
 G DEV:'$D(ZTSK)
 K ZTSK
 G K
 ;
START ;EP - TaskMan.
 U IO
 S DIC="^ACHSDEF("_DUZ(2)_",""D"","
 D EN^DIQ
 I IO'=$G(ACHDIO) W @IOF
K ;
 K DA,DIC
 D ^%ZISC,ERPT^ACHS:$D(ZTSK)
 Q
 ;
