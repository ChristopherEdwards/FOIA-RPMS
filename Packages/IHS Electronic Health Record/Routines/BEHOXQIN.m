BEHOXQIN ;MSC/IND/DKM - Installation Support ;27-Jan-2011 22:35;PLS
 ;;1.1;BEH COMPONENTS;**002003,002005**;Mar 20, 2007
 ;=================================================================
PRE ;EP - Preinitialization
 N IEN
 S IEN=$$PRGID^CIAVMCFG("BEHNOTIFICATIONS.NOTIFICATIONS")
 I IEN D
 .K ^CIAVOBJ(19930.2,IEN,5)
 Q
POST ;EP - Postinitialization
 ;D FIXALRTS
 Q
 ; Fix bad ALERT file entries
FIXALRTS ; EP
 N USR,ADT,CNT
 D BMES^XPDUTL("Checking ALERT file for corrupted entries...")
 S (CNT,USR)=0
 F  S USR=$O(^XTV(8992,USR)) Q:USR<.1  D
 .I $D(^XTV(8992,USR,"XQA",0))#2,'$P(^(0),U,2) S $P(^(0),U,2)="8992.01DA" D
 ..D MES^XPDUTL("  Fixed bad subfile header for user #"_USR)
 ..S CNT=CNT+1
 .S ADT=0
 .F  S ADT=$O(^XTV(8992,USR,"XQA",ADT)) Q:ADT<1  D:'$D(^(ADT,0))
 ..K ^XTV(8992,USR,"XQA",ADT)
 ..D MES^XPDUTL("  Removed bad subfile entry for user #"_USR)
 ..S CNT=CNT+1
 D MES^XPDUTL("  Checking complete.  Bad entries corrected: "_CNT)
 Q
