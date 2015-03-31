BGOIN012 ; IHS/MSC/PLS - BGO*1.1*12 ;17-Apr-2013 16:11;PLS
 ;;1.1;BGO COMPONENTS;**12**;Mar 20, 2007
EC Q
 ; Preinit
PRE ;
 Q
 ; Postinit
POST ;
 ; Clean up menu items
 ;D CLNMNU
 ; Register RPCs
 D REGNMSP^CIAURPC("BGO","CIAV VUECENTRIC")
 ; Update BGO component versions
 N VER,FDA,PID,IEN,X
 D BMES^XPDUTL("Updating version numbers...")
 F VER=0:1 S X=$P($T(VER+VER),";;",2) Q:'$L(X)  D
 .S PID=$$PRGID^CIAVMCFG($P(X,";"))
 .S:PID FDA(19930.2,PID_",",2)=$P(X,";",2),FDA(19930.2,PID_",",7)=$P(X,";",3)
 D:$D(FDA) FILE^DIE(,"FDA")
 Q
 ;
CLNMNU ;
 ; Remove option from menu
 N OPTION,MENU,DA,DIK,PAR,ERR,X
 S (OPTION,MENU)=""
 S OPTION="BGO IMM STOP ADDING CPT CODES"
 S MENU="BGOIMM MAIN"
 S X=$$DELETE^XPDMENU(MENU,OPTION)
 Q:'+X
 ;Inactivate the option
 D OUT^XPDMENU(OPTION,"No longer used")
 ;Clean out the parameter
 S PAR=""
 S PAR=$O(^XTV(8989.51,"B","BGO IMM STOP ADDING CPT CODES",PAR))
 Q:'+PAR
 S ERR=0
 D NDEL^XPAR("USR",PAR,.ERR)
 Q:ERR>0
 D NDEL^XPAR("DIV",PAR,.ERR)
 Q:ERR>0
 D NDEL^XPAR("PKG",PAR,.ERR)
 Q:ERR>0
 ;Delete the parameter
 S DA=PAR,DIK="^XTV(8989.51," D ^DIK
 Q
VER ;;IHSBGOSKINTEST.IHSBGOSK;1.2.0.128;8B38D8C09E4FE3A445F1A198733F5C24
 ;;
USES ;;
 ;;
