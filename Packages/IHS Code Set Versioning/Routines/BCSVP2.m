BCSVP2 ;IHS/MSC/BWF - CSV Patch 1 ;3-Mar-2010 19:05;BF
 ;;1.0;BCSV;**2**;APR 23,2010
 ;=================================================================
 ;  BCSV patch 2 post install
PRE ;
 I '$D(^XPD(9.6,"B","BCSV*1.0*1")) S XPDABORT=1
 I $G(XPDABORT) D BMES^XPDUTL("BCSV*1.0*1 must be installed to continue!") Q
 Q
POST ;
 N ICDCODE,SIEN,AGELOW,AGEHIGH,ICD90,OALOW,OAHIGH,ICDCODE
 S REPONLY=$G(REPONLY)
 I $G(REPONLY) D DISPHDR
 ; grab old age ranges and put them back into the ICD file.
 S X=0 F  S X=$O(^ICD9(X)) Q:'X  D
 .S ICDCODE=$P(^ICD9(X,0),U,1)_" "
 .; get source ien
 .S SIEN=$O(^XCSVICD9("BA",ICDCODE,0)) Q:'SIEN
 .S IHSIEN=$O(^ICD9("BA",ICDCODE,0)) Q:'IHSIEN
 .S AGELOW=$$AGELOW(SIEN,IHSIEN),AGEHIGH=$$AGEHIGH(SIEN,IHSIEN)
 .S ICD90=$G(^ICD9(IHSIEN,0)),OALOW=$P(ICD90,U,14),OAHIGH=$P(ICD90,U,15)
 .I OALOW="",AGELOW="",OAHIGH="",AGEHIGH="" Q
 .I OALOW=AGELOW,OAHIGH=AGEHIGH Q
 .I REPONLY D DISP(ICDCODE,AGELOW,AGEHIGH,OALOW,OAHIGH) Q
 .S FDA(80,X_",",14)=AGELOW
 .S FDA(80,X_",",15)=AGEHIGH
 .D FILE^DIE(,"FDA","ERR")
 D FIXICM
 D ICDUPD
 Q
FIXICM ; kill off entries that were added in the wrong place
 N QUIT,LINE,KIEN,NIEN
 S QUIT=0
 F I=1:1 D  Q:QUIT
 .S LINE=$P($T(DAT+I),";;",2) I LINE=" Q"!(LINE']"") S QUIT=1 Q
 .K KIEN,NIEN
 .S KIEN=$P(LINE,":"),NIEN(1)=$P(LINE,":",2)
 .S DIK="^ICM(",DA=KIEN D ^DIK
 .; if an entry already exists here, do not file it again
 .I '$D(^ICM(NIEN(1))) D
 ..K FDA S FDA(80.3,"+1,",.01)=$P($G(^XCSV("ICM","DATA",NIEN(1),0)),U,1)
 ..D UPDATE^DIE(,"FDA","NIEN","BCSVERR") K FDA
 .; add data back into entry
 .M ^ICM(NIEN(1))=^XCSV("ICM","DATA",NIEN(1))
 .; reindex
 S DIK="^ICM(" D IXALL^DIK
 Q
 ;
ICDUPD ;
 N DRG,BCSVDT,BCSVSIEN,BCSVDESC
 S DRG=0 F  S DRG=$O(^ICD(DRG)) Q:'DRG  D
 .S BCSVDT=$O(^ICD(DRG,68,"B",9999999),-1) Q:'BCSVDT
 .S BCSVSIEN=$O(^ICD(DRG,68,"B",BCSVDT,0)) Q:'BCSVSIEN
 .S BCSVDESC=$$GET1^DIQ(80.2681,"1,"_BCSVSIEN_","_DRG_",",.01,"E")
 .S FDA(80.21,"1,"_DRG_",",.01)=BCSVDESC
 .D FILE^DIE(,"FDA") K FDA
 Q
AGELOW(IEN,IHSIEN) ;
 N ALOW
 Q:'IEN
 ; first check to see if there is a value in piece 14
 S ALOW=$P(^XCSVICD9(IEN,0),U,14)
 I 'ALOW S ALOW=$P($G(^ICD9(IHSIEN,9999999)),U)
 Q ALOW
AGEHIGH(IEN,IHSIEN) ;
 N AHIGH
 Q:'IEN
 S AHIGH=$P(^XCSVICD9(IEN,0),U,15)
 I 'AHIGH S AHIGH=$P($G(^ICD9(IHSIEN,9999999)),U,2)
 Q AHIGH
 ;
DISP(CODE,NALOW,NAHIGH,OALOW,OAHIGH) ;
 W !,CODE,?20,OALOW,?35,NALOW,?50,OAHIGH,?65,NAHIGH
 Q
DISPHDR ;
 W @IOF
 W !,"ICD CODE",?20,"CSV AGE LOW",?35,"IHS AGE LOW",?50,"CSV AGE HIGH",?65,"IHS AGE HIGH"
 W !,"--------",?20,"-----------",?35,"-----------",?50,"------------",?65,"------------"
 Q
DAT ;
 ;;100:26
 ;;101:27
 ;;102:28
 ;;103:98
 Q
