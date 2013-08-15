BJPN10PR ;GDIT/HS/BEE-Prenatal Care Module Pre-Install ; 08 May 2012  12:00 PM
 ;;1.0;PRENATAL CARE MODULE;;Dec 06, 2012;Build 61
 ;
 Q
 ;
PRE ;EP - PRENATAL CARE MODULE 1.0 PRE-INSTALL
 ;
 NEW X,IEN,DA,DIK,DIU
 ;
 ;First Install - Remove any existing 9000010.43 entries
 ;
 ;Reset main problem file structure
 S DIU="^BJPNPL(",DIU(0)="ST" D EN^DIU2
 ; 
 ;Look for routine BJPNPRL (Present in build) - Skip if present
 S X="BJPNPRL" X ^%ZOSF("TEST") I '$T D
 . S IEN=0 F  S IEN=$O(^AUPNVOB(IEN)) Q:'IEN  S DA=IEN,DIK="^AUPNVOB(" D ^DIK
 . ;
 . ;Reset structure
 . S DIU="^AUPNVOB(",DIU(0)="DST" D EN^DIU2
 ;
 ;BJPN(90680.02) Cleanup - Switch to new code set
 ;Make backup copy of current SNOMED code set build has already been installed
 ;If routine BJPNPRL (Present in build) - Loaded before - we need to convert
 S X="BJPNPRL" X ^%ZOSF("TEST") I $T D SAVE
 ;
 ;Clear out BJPN SNOMED TERMS
 S IEN=0 F  S IEN=$O(^BJPN(90680.02,IEN)) Q:'IEN  S DA=IEN,DIK="^BJPN(90680.02," D ^DIK
 ;
 ;Clear out BJPN PICK LIST CATEGORIES
 S IEN=0 F  S IEN=$O(^BJPN(90680.03,IEN)) Q:'IEN  S DA=IEN,DIK="^BJPN(90680.03," D ^DIK
 ;
 Q
 ;
SAVE ;Save copy of current BJPN SNOMED TERMS (if re-install)
 K ^XTMP("BJPNSMD")
 I $D(^BJPN(90680.02)) D
 . S ^XTMP("BJPNSMD",0)=DT_U_DT_U_"BJPN INSTALLATION PATCH"
 . M ^XTMP("BJPNSMD",90680.02)=^BJPN(90680.02)
 Q
