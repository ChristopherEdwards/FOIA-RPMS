ABMANSIT ; IHS/SD/SDR - Input transform-anes. mod field - 8/19/2005 1:28:34 PM
 ;;2.6;IHS 3P BILLING SYSTEM;;NOV 12, 2009
 ;
 ; Input transform routine for Anesthesia Modifier field
 ; It should look first in the ASA-PS Code file, then in
 ; the CPT Modifier file
 ;
 ; IHS/SD/SDR v2.6 CSV changes
 ;
EN ; EP
 S DIC="^AUTTASA("
 S DIC(0)="EMQ"
 D ^DIC
 K DIC
 I Y>0 S X=$P($G(^AUTTASA(+Y,0)),U) Q
 S Y=$$MOD^ABMCVAPI(X,"",ABMP("VDT"))  ;CSV-c
 I Y>0 S X=$P($$MOD^ABMCVAPI(X,"",ABMP("VDT")),U,2)  ;CSV-c
 ;K X
 Q
