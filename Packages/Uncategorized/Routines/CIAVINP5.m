CIAVINP5 ;MSC/IND/PLS - EHR v1.1p5 Inits;01-May-2009 12:54;PLS
 ;;1.1;VUECENTRIC FRAMEWORK;;23-Oct-2006
 ;;Copyright 2000-2008, Medsphere Systems Corporation
 ;=================================================================
EC ;EP - Environment check
 Q
PRE ;EP - Preinit
 Q
POST ;EP - Postinit
 N VER,FDA,PID,IEN,X
 D BMES^XPDUTL("Updating version numbers...")
 F VER=0:1 S X=$P($T(VER+VER),";;",2) Q:'$L(X)  D
 .S PID=$$PRGID^CIAVMCFG($P(X,";"))
 .S:PID FDA(19930.2,PID_",",2)=$P(X,";",2),FDA(19930.2,PID_",",7)=$P(X,";",3)
 D:$D(FDA) FILE^DIE(,"FDA")
 Q
VER ;;CIA_VIM.VIM;1.7.4.26
 ;;
