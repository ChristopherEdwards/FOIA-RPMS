CIAVIP10 ;MSC/IND/PLS - EHR v1.1p10 Inits;03-Jul-2012 12:26;PLS
 ;;1.1;VUECENTRIC FRAMEWORK;;23-Oct-2006
 ;;Copyright 2000-2011, Medsphere Systems Corporation
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
 I $L($$GETLOGIN^CIAVUTIL),$$ASK^CIAU("Do you want to enable EHR logins","Y") D
 .D SDABORT^CIAVUTIL(,1),BMES^XPDUTL("Application logins have been enabled.")
 I $T(EN^GMRAZDSF)'="" D EN^GMRAZDSF  ;rebuild ingredients and classes
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
 ; Rename .01 field of BEH Measurement file
BEHMSR(X,Y) ;
 N IEN,FDA
 S IEN=$O(^BEHOVM(90460.01,"B",X,0))
 Q:'IEN
 S FDA(90460.01,IEN_",",.01)=Y
 D FILE^DIE(,"FDA")
 Q
VER ;;VCQUICKNOTE.QUICKNOTE;1.1.3.0;ACB63AEF5907998055EACE95C9CAD783
 ;;BEHRXGENERATORSERVICE.RXGENERATOR;1.0.0.59;FA93CED0829209E4D454AD4E53DA4C69
 ;;
