BJPN20PR ;GDIT/HS/BEE-Prenatal Care Module 2.0 Pre-Install ; 08 May 2012  12:00 PM
 ;;2.0;PRENATAL CARE MODULE;;Feb 24, 2015;Build 63
 ;
 Q
 ;
PRE ;EP - PRENATAL CARE MODULE 2.0 PRE-INSTALL
 ;
 NEW X,X1,X2,%H
 ;
 ;Check if PRENATAL 1.0 was installed
 ;If not, remove any existing 9000010.43 entries to clean up old file
 S X="BJPNPRL" X ^%ZOSF("TEST") I '$T D  Q
 . ;
 . NEW X,IEN,DA,DIK,DIU
 . ;
 . ;Remove any existing 9000010.43 entries
 . S IEN=0 F  S IEN=$O(^AUPNVOB(IEN)) Q:'IEN  S DA=IEN,DIK="^AUPNVOB(" D ^DIK
 . ;
 . ;Reset structure
 . S DIU="^AUPNVOB(",DIU(0)="DST" D EN^DIU2
 ;
 ;PRENATAL 1.0 was installed. Conversion is required
 ;
 ;Get a later date
 S X1=DT,X2=60 D C^%DTC
 ;
 ;Make a copy of the v1.0 files
 K ^XTMP("BJPN")
 S ^XTMP("BJPN")=X_U_DT_U_"BJPN 2.0 Installation files"
 M ^XTMP("BJPN","BJPNPL")=^BJPNPL
 M ^XTMP("BJPN","BJPNVOB")=^AUPNVOB
 ;
 Q
