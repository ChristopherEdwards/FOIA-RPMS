ABMP263 ; IHS/SD/SDR - 3P BILLING 2.6 Patch 3 PRE/POST INIT ;  
 ;;2.6;IHS Third Party Billing System;**3**;NOV 12, 2009
 ;
PRE ;
 Q
POST ;
 D TURNON^DIAUTL(9002274.5,.09,"y")  ;audit 3P Parameters, current default fee sched
 D TURNON^DIAUTL(9002274.091,.05,"y")  ;audit 3P Insurer file, visit type mult, fee sched
 D ERRCD  ;error codes for claim editor
 D REINDEX  ;run new cross reference for 3P Bill file, Re-export multiple
 Q
ERRCD ;
 ;234 - tribal self-insured
 K DIC,X
 S DIC="^ABMDERR("
 S DIC(0)="LM"
 S DINUM=234
 S X="INSURER DESIGNED AS BEING A TRIBAL SELF-INSURED PLAN"
 S DIC("DR")=".03///W"
 K DD,DO
 D FILE^DICN
 D SITE(234)
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
 .S DIC("DR")=".03////W"
 .D ^DIC
 .K DA,DIC,DINUM
 S DUZ(2)=DUZHOLD
 K DUZHOLD,DLAYGO,ABMX
 Q
REINDEX ;
 S ABMHOLD=DUZ(2)
 S DUZ(2)=0
 F  S DUZ(2)=$O(^ABMDBILL(DUZ(2))) Q:'DUZ(2)  D
 .S ABMBDFN=0
 .F  S ABMBDFN=$O(^ABMDBILL(DUZ(2),ABMBDFN)) Q:'ABMBDFN  D
 ..S ABMXMT=0
 ..F  S ABMXMT=$O(^ABMDBILL(DUZ(2),ABMBDFN,74,ABMXMT)) Q:'ABMXMT  D
 ...S DA(1)=ABMBDFN
 ...S DA=ABMXMT
 ...S DIK="^ABMDBILL("_DUZ(2)_","_DA(1)_",74,"
 ...S DIK(1)=".01^AX"
 ...D EN1^DIK
 S DUZ(2)=ABMHOLD
 Q
