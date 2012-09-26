BTIUP9 ; IHS/CIA/MGH - POST INSTALL FOR PATCH 1009;05-Jan-2012 14:45;DU
 ;;1.0;TEXT INTEGRATION UTILITIES;**1009**;SEPT 04, 2005;Build 22
 ;
ENV ;EP environment check
 N PATCH,STAT,INSTDA
 S (XPDDIQ("XPZ1"),XPDDIQ("XPZ2"))=0
 ;
 S PATCH="TIU*1.0*1007"
 I '$$PATCH(PATCH) D  Q
 . W !,"You must first install "_PATCH_"." S XPDABORT=1
 S PATCH="TIU*1.0*1008"
 I '$$PATCH(PATCH) D  Q
 . W !,"You must first install "_PATCH_"." S XPDABORT=1
 S PATCH="BJPC*2.0*6"
 I '$$PATCH(PATCH) D  Q
 . W !,"You must first install "_PATCH_"." S XPDABORT=1
 ;Check for the installation of the ICARE
 S IN="ICARE MANAGEMENT SYSTEM 2.1",INSTDA=""
 I '$D(^XPD(9.7,"B",IN)) D  Q
 .W !,"You must first install the ICARE 2.1 before this patch" S XPDABORT=1
 S INSTDA=$O(^XPD(9.7,"B",IN,INSTDA),-1)
 S STAT=+$P($G(^XPD(9.7,INSTDA,0)),U,9)
 I STAT'=3 D
 .W !,"ICARE 2.1 must be completely installed before installing this patch." S XPDABORT=1
 S (XPDDIQ("XPZ1"),XPDDIQ("XPZ2"))=0
 ;Check for EHR installation
 S IN="EHR*1.1*8",INSTDA=""
 I '$D(^XPD(9.7,"B",IN)) D  Q
 .W !,"You must first install the EHR patch 8 before installing patch TIU patch 1009" S XPDABORT=1
 S INSTDA=$O(^XPD(9.7,"B",IN,INSTDA),-1)
 S STAT=+$P($G(^XPD(9.7,INSTDA,0)),U,9)
 I STAT'=3 D  Q
 .W !,"EHR patch 8 must be completely installed before installing TIU patch 1009" S XPDABORT=1
 S (XPDDIQ("XPZ1"),XPDDIQ("XPZ2"))=0
 ;Redo the environment checker for patch 113
 N CHKOK,TIULOC S CHKOK=1,TIULOC=0
 W !!,"Checking DIVISION for all Hospital Location file (#44)"
 W !,"entries <AND> INSTITUTION FILE POINTER for all Medical"
 W !,"Center Division file (#40.8) entries..."
 W !!
 ;
 F  S TIULOC=$O(^SC(TIULOC)) Q:'TIULOC!('CHKOK)  D
 . N TIUDVHL
 . S TIUDVHL=+$P($G(^SC(TIULOC,0)),U,15) I 'TIUDVHL S CHKOK=0 Q
 I CHKOK=1 D
 . N TIUDIV,TIUIFP S TIUDIV=0
 . F  S TIUDIV=$O(^DG(40.8,TIUDIV)) Q:'TIUDIV!('CHKOK)  D
 . . S TIUIFP=+$G(^DG(40.8,"ADV",TIUDIV)) I 'TIUIFP S CHKOK=0 Q
 ;
 I 'CHKOK D
 . S XPDABORT=1 ; kill transport global from ^XTMP
 . W !,"Sorry...DIVISION cannot be determined for all Hospital"
 . W !,"Location file (#44) entries <AND/OR> INSTITUTION FILE"
 . W !,"POINTER cannot be determined for all Medical Center"
 . W !,"Division file (#40.8) entries. Please review and correct"
 . W !,"both files as necessary."
 . W !!,"** ABORTING INSTALLATION **"
 E  D
 . W !,"** Files are OK **"
 Q
 ;
PATCH(X) ;return 1 if patch X was installed, X=aaaa*nn.nn*nnnn
 ;copy of code from XPDUTL but modified to handle 4 digit IHS patch numbers
 Q:X'?1.4UN1"*"1.2N1"."1.2N.1(1"V",1"T").2N1"*"1.4N 0
 NEW NUM,I,J
 S I=$O(^DIC(9.4,"C",$P(X,"*"),0)) Q:'I 0
 S J=$O(^DIC(9.4,I,22,"B",$P(X,"*",2),0)),X=$P(X,"*",3) Q:'J 0
 ;check if patch is just a number
 Q:$O(^DIC(9.4,I,22,J,"PAH","B",X,0)) 1
 S NUM=$O(^DIC(9.4,I,22,J,"PAH","B",X_" SEQ"))
 Q (X=+NUM)
 ;
PRE ;EP; beginning of pre install code
 Q
 ;
POST ;EP; beginning of post install code
 N SECURITY
 S SECURITY("RD")="#"
 S SECURITY("DD")="@"
 S SECURITY("DEL")="#"
 S SECURITY("WR")="#"
 S SECURITY("LAYGO")="#"
 S SECURITY("AUDIT")="@"
 D FILESEC^DDMOD(8927,.SECURITY)
 ;Add the items to the menu
 D REGMENU^BEHUTIL("BTIU SPECIAL REPORTS",,"HIMS","BTIU MENU2")
 D REGMENU^BEHUTIL("BTIU BROWSE PAT BY MR",,"IPD","BTIU MENU2")
 D REGMENU^BEHUTIL("BTIU DOC LIST",,"LAD","BTIU MENU2")
 D REGMENU^BEHUTIL("BTIU BTIU REVIEW SCREEN MR",,"MPD","BTIU MENU2")
 D REGMENU^BEHUTIL("BTIU MENU PRINT DOCS",,"PDM","BTIU MENU2")
 D REGMENU^BEHUTIL("BTIU IC LISTING",,"SIG","BTIU MENU2")
 D REGMENU^BEHUTIL("BTIU SEARCH FOR MR",,"SSD","BTIU MENU2")
 D REGMENU^BEHUTIL("BTIU MENU STATS REPORTS",,"STR","BTIU MENU2")
 D REGMENU^BEHUTIL("BTIU MENU MGR",,"TMM","BTIU MENU2")
 D REGMENU^BEHUTIL("TIU UNSIGNED/UNCOSIGNED REPORT",,"UNS","BTIU MENU2")
 D REGMENU^BEHUTIL("BTIU MENU UPLOAD",,"UPL","BTIU MENU2")
 D REGMENU^BEHUTIL("BTIU VIEW USER ALERTS",,"VUA","BTIU MENU2")
 Q
