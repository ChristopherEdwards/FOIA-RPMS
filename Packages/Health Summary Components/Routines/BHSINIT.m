BHSINIT ;IHS/CIA/MGH - Initializations for build ;17-Mar-2006 10:36;MGH
 ;;1.0;HEALTH SUMMARY COMPONENTS;;March 17, 2006
 ;===================================================================
ENV ;EP
 S (XPDDIQ("XPZ1"),XPDDIQ("XPZ2"))=0
 ;
 ;Check for released versions of both VA and IHS health summaries
 NEW IEN,PKG
 S PKG="GMTS*2.7*68"
 S IEN=$O(^XPD(9.6,"B",PKG,0))
 I 'IEN W !,"You must first install "_PKG_"; before updating health summary" S XPDQUIT=2 Q
 ;
 I $$LAST^XPDUTL("IHS RPMS/PCC Health Summary","2.00")<12 D
 .I $$LAST^XPDUTL("IHS RPMS/PCC Health Summary","2.0")<12 D
 ..S XPDQUIT=2 W !,"Health summary must be at least up to patch 12"
 Q
 ;
PRE ;EP
 Q
 ;
POST ;EP
 ; Fix Out of Order Message for GMTS routines
 ; except for a select few
LOOP N HNAM,FROM,HIEN
 S HNAM="GMTS",FROM=HNAM
 F  S HNAM=$O(^DIC(19,"B",HNAM)) Q:HNAM=""!($E(HNAM,1,$L(FROM))'=FROM)  D
 .S HIEN=0 F  S HIEN=$O(^DIC(19,"B",HNAM,HIEN)) Q:'HIEN  D
 ..D FIXOMSG(HIEN,HNAM)
 Q
FIXOMSG(OPT,NAME) ;
 N VAL,FDA,IEN
 S IEN=$$FIND1^DIC(19,,"X",NAME)
 I IEN D
 .S VAL=""
 .S FDA(19,IEN_",",2)=VAL
 .D FILE^DIE("K","FDA")
 Q
