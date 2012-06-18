ABMP2515 ; IHS/SD/SDR - 3P BILLING 2.5 Patch 15 PRE/POST INIT ;  [ 03/09/2004  3:25 PM ]
 ;;2.5;IHS 3P BILLING SYSTEM;**15**;OCT 9, 2007
 ;
POST ;
 D ERRCODES  ;new error codes in 3P Error Codes file
 Q
ERRCODES ;
 ;232 - Provider NPI missing so facility NPI being used
 K DIC,X
 S DIC="^ABMDERR("
 S DIC(0)="LM"
 S DINUM=232
 S X="Provider NPI missing so facility NPI being used"
 S DIC("DR")=".02///Ensure correct NPI is being used"
 S DIC("DR")=DIC("DR")_";.03///W"
 K DD,DO
 D FILE^DICN
 D SITE(232)
 Q
SITE(ABMX) ;Add SITE multiple
 S DUZHOLD=DUZ(2)
 S DUZ(2)=0
 F  S DUZ(2)=$O(^ABMDCLM(DUZ(2))) Q:'+DUZ(2)  D
 .S DIC(0)="LX"
 .S DA(1)=ABMX
 .S DIC="^ABMDERR("_DA(1)_",31,"
 .S DIC("P")=$P(^DD(9002274.04,31,0),U,2)
 .S DINUM=DUZ(2)
 .S X=$P($G(^DIC(4,DUZ(2),0)),U)
 .S DIC("DR")=".03////"_$S((DA(1)=232):"W",1:"E")
 .D ^DIC
 .K DA,DIC,DINUM
 S DUZ(2)=DUZHOLD
 K DUZHOLD,DLAYGO,ABMX
 Q
