CIAVIP20 ;MSC/IND/PLS - EHR v1.1p20 Inits;28-Jun-2016 12:48;PLS
 ;;1.1;VUECENTRIC FRAMEWORK;;23-Oct-2006
 ;;Copyright 2000-2015, Medsphere Systems Corporation
 ;=================================================================
EC ;EP - Environment check
 Q
PRE ;EP - Preinit
 Q
POST ;EP - Postinit
 N VER,FDA,PID,IEN,X,TYPE
 D BMES^XPDUTL("Updating version numbers...")
 F VER=0:1 S X=$P($T(VER+VER),";;",2) Q:'$L(X)  D
 .S PID=$$PRGID^CIAVMCFG($P(X,";"))
 .S:PID FDA(19930.2,PID_",",2)=$P(X,";",2),FDA(19930.2,PID_",",7)=$P(X,";",3)
 D:$D(FDA) FILE^DIE(,"FDA")
 W !!!
 ;Update help file references
 D UPDCHM
 ;Mark menu out of order
 ;Change friendly names of objects
 ;Prompt to enable logins
 I $L($$GETLOGIN^CIAVUTIL),$$ASK^CIAU("Do you want to enable EHR logins","Y") D
 .D SDABORT^CIAVUTIL(,1),BMES^XPDUTL("Application logins have been enabled.")
 Q
 ;Register RPCs to context
REGRPC ;EP-
 I $$REGRPC^CIAURPC("MAGJ USER2","CIAV VUECENTRIC")
 I $$REGRPC^CIAURPC("MAGG CPRS RAD EXAM","CIAV VUECENTRIC")
 I $$REGRPC^CIAURPC("MAG3 CPRS TIU NOTE","CIAV VUECENTRIC")
 Q
 ; Update the friendly name of an existing object
UPDOBJNM(OBJ,NAME) ;EP-
 N PID,FDA
 S PID=$$PRGID^CIAVMCFG(OBJ)
 Q:'PID
 S FDA(19930.2,PID_",",1)=NAME
 D FILE^DIE(,"FDA")
 Q
 ; Attach Event Protocols to Event Types
EVTPRTL(TYPE) ;
 N EVTNM,PRT,EVT,FDA
 S EVTNM="CIAV "_TYPE_" EVENT"
 S EVT=$$EVENTIEN^CIANBEVT(TYPE)
 Q:'EVT
 S PRT=$$FIND1^DIC(101,,,EVTNM)
 Q:'PRT
 S FDA(19941.21,EVT_",",7)=PRT
 D FILE^DIE(,"FDA")
 Q
 ; Delete a USES item
DELUSES(PARENT,ITM) ;EP-
 N PID,ITMIEN,FDA
 S PID=$$PRGID^CIAVMCFG(PARENT)
 I PID D
 .S ITMIEN=$$FIND1^DIC(19930.221,","_PID_",","B",ITM)
 .I ITMIEN D
 ..S FDA(19930.221,ITMIEN_","_PID_",",.01)="@"
 ..D FILE^DIE(,"FDA")
 Q
 ;
UPDCHM ;EP-
 N CHM,PID
 F CHM=0:1 S X=$P($T(CHM+CHM),";;",2) Q:'$L(X)  D
 .S PID=$$PRGID^CIAVMCFG($P(X,";"))
 .D AECHM(PID,$P(X,";",2,99))
 W !!
 Q
 ;
AECHM(PID,VAL) ;EP-
 N LN,FN,IDX,TXT,ARY,CNT,IENS
 S FN=$P(VAL,";"),CNT=0
 S LN=0 F  S LN=$O(^CIAVOBJ(19930.2,PID,6,LN)) Q:'LN  D  Q:$G(IDX)
 .S TXT=^CIAVOBJ(19930.2,PID,6,LN,0)
 .S ARY(LN,0)=TXT,CNT=CNT+1
 .I $$UP^XLFSTR(TXT)[$$UP^XLFSTR($P(VAL,";")) S IDX=LN
 I $G(IDX) D
 .S ^CIAVOBJ(19930.2,PID,6,IDX,0)=VAL
 E  D
 .S ARY($S('CNT:1,1:CNT+1),0)=VAL
 .S IENS=PID_","
 .S FDA(19930.2,IENS,10)="ARY"
 .D FILE^DIE(,"FDA")
 Q
 ; Rename .01 field of BEH Measurement file
BEHMSR(X,Y) ;
 N IEN,FDA
 S IEN=$O(^BEHOVM(90460.01,"B",X,0))
 Q:'IEN
 S FDA(90460.01,IEN_",",.01)=Y
 D FILE^DIE(,"FDA")
 Q
VER ;;
 ;;
CHM ;;
 ;;
