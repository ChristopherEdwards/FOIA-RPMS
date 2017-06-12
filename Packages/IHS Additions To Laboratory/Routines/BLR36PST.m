BLR36PST ; IHS/MSC/MKK - IHS Lab Patch LR*5.2*1036 Post Routine ; 28-Jul-2015 06:30 ; MKK
 ;;5.2;IHS LABORATORY;**1036**;NOV 01, 1997;Build 10
 ;
EEP ; EP - Ersatz EP
 D EEP^BLRGMENU
 Q
 ;
PEP ; EP
POST ; EP - POST INSTALL
 NEW (DILOCKTM,DISYS,DT,DTIME,DUZ,IO,IOBS,IOF,IOM,ION,IOS,IOSL,IOST,IOT,IOXY,U,XPARSYS,XQXFLG)
 ;
 S QUIET=1
 ;
POSTDBG ; EP - POST INSTALL for DEBUG
 ;
 D SETEVARS
 ;
 S TODAY=$$DT^XLFDT
 S WOTCNT=$$WOTCNT(BLRVERN)
 ;
 D BMES^XPDUTL(CPSTR_" Post Install"),BLANK
 ;
 D ADDNOPTS        ; Add new options
 ;
 D ENDINSTL(CP),BLANK
 ;
 D BMES^XPDUTL("Laboratory Patch "_CPSTR_" INSTALL complete.")
 ;
 Q:+$G(DEBUG)
 ;
 D POSTMAIL(BLRVERN,CPSTR)
 ;
 S ^XTMP(BLRVERN,TODAY,WOTCNT,"END")=$$NOW^XLFDT
 Q
 ;
ADDNOPTS      ; EP - ADD New OPTionS
 Q:$G(DEBUG)
 ;
 S TAB=$G(TAB,$J("",5))
 ;
 D NEWOPT("BLRREFLABMENU","BLR REFLAB RESHIP NON LEDI","RSNL")  ;add reship option
 ;
 Q
 ;
NEWOPT(MENU,NEWOPTN,NEWSYNM,NEWORD) ; EP - Add Option to a Menu
 NEW BLRIEN,TAB
 ;
 S TAB=$J("",5)
 ;
 S BLRIEN=$$LKOPT^XPDMENU(MENU)
 Q:$$FIND1^DIC(19.01,","_BLRIEN_",",,NEWSYNM,"C")    ; Don't add if already on MENU
 ;
 D BMES^XPDUTL("Adding '"_NEWOPTN_"' option to "_MENU_".")
 ;
 S X=$$ADD^XPDMENU(MENU,NEWOPTN,NEWSYNM,$G(NEWORD,""))
 ;
 I X=1 D MES^XPDUTL(TAB_"'"_NEWOPTN_"' added to "_MENU_". OK."),BLANK  Q
 ;
 D MES^XPDUTL(TAB_"Error in adding '"_NEWOPTN_"' option to "_MENU_".")
 D MES^XPDUTL(TAB_TAB_"Error Message: "_$$UP^XLFSTR($P(X,"^",2))),BLANK
 ;
 Q
 ;
POSTMAIL(BLRVERN,CPSTR) ; EP - Post Install MailMan Message
 NEW STR
 ;
 S STR(1)=" "
 S STR(2)=$J("",10)_"POST INSTALL of "_BLRVERN_" Routine."
 S STR(3)=" "
 S STR(4)=$J("",15)_"Laboratory Patch "_CPSTR_" INSTALL completed."
 S STR(5)=" "
 ;
 Q:+$G(DEBUG)   ; No MailMan messages during debugging
 ;
 ; Send E-Mail to LMI Mail Group & Installer
 D MAILALMI^BLRUTIL3("Laboratory Patch "_CPSTR_" INSTALL complete.",.STR,BLRVERN)
 ;
 Q
 ;
 ; ========================= UTILITIES FOLLOW ==========================
 ;
SETEVARS ; EP - SET standard "Enviroment" VARiables.
 S (CP,PATCHNUM)=$P($T(+2),"*",3)
 S CPSTR="LR*5.2*"_CP
 S BLRVERN=$TR($P($T(+1),";")," ")
 Q
 ;
BLANK ; EP - Blank Line
 D MES^XPDUTL(" ")
 Q
 ;
MESCNTR(STR) ; EP - Center a line and use XPDUTL to display it
 D MES^XPDUTL($$CJ^XLFSTR(STR,IOM))
 Q
 ;
WOTCNT(BLRVERN) ; EP - Counter for ^XTMP
 NEW CNT,TODAY
 ;
 S TODAY=$$DT^XLFDT
 ;
 S CNT=1+$G(^XTMP(BLRVERN,0,TODAY))
 S ^XTMP(BLRVERN,0,TODAY)=CNT
 Q $TR($J(CNT,3)," ","0")
 ;
INITSCR ; EP - Initialize screen. Cloned from INIT^XPDID
 N X,XPDSTR
 I IO'=IO(0)!(IOST'["C-VT") S XPDIDVT=0 Q
 I $T(PREP^XGF)="" S XPDIDVT=0 Q
 D PREP^XGF
 S XPDIDVT=1,X="IOSTBM",XPDSTR=""
 D ENDR^%ZISS
 S IOTM=3,IOBM=IOSL-4
 W @IOSTBM
 D FRAME^XGF(IOTM-2,0,IOTM-2,IOM-1) ; Top line
 ; D FRAME^XGF(IOBM+1,0,IOBM+1,IOM-1) ; Bottom line
 D IOXY^XGF(IOTM-2,0)
 Q
 ;
DEBUG ; EP - Debugging Line Label for environment checker
 NEW (DILOCKTM,DISYS,DT,DTIME,DUZ,IO,IOBS,IOF,IOM,ION,IOS,IOSL,IOST,IOT,IOXY,U,XPARSYS,XQXFLG)
 ;
 ; NOTE: DEBUG will not store "Backup" data.
 ;
 D SETEVARS
 ;
 W !!
 W "Debug Routine ",BLRVERN," Begins:",!!
 ;
 ; Note -- DEBUG is a negative flag:
 ;         1="Don't Send Alerts"; 0="Send Alerts"
 ;
 ; D ^XBFMK
 ; S DIR(0)="YO"
 ; S DIR("B")="NO"
 ; S DIR("A")="Send Alerts/E-Mails"
 ; D ^DIR
 ; S:+$G(Y)=1 DEBUGA="YES"
 ;
 S DEBUG=1      ; At this time, DO NOT ASK -- just DO NOT send alerts
 ;
 W !
 S XPDNM=CPSTR
 S XPDENV=0
 ;
 D ENVICHEK^BLRPRE35
 D PRESSKEY^BLRGMENU(4)
 ;
 Q:XPDABORT
 ;
 D PRE^BLRPRE35
 W !!!
 ;
 D ^XBFMK
 S DIR(0)="YO"
 S DIR("B")="NO"
 S DIR("A")="Test Post Install Code"
 D ^DIR
 ;
 S QUIET=0
 D:+$G(Y)=1 POSTDBG
 ;
 W !!,"Debug Routine ",BLRVERN," Ends.",!!
 Q
 ;
ENDINSTL(CURPATCH) ; EP - End Installation
 NEW INSTCNT            ; Installation count
 ;
 S INSTCNT=1+$O(^BLRINSTL("LAB PATCH",CURPATCH,"INSTALLED BY",""),-1)
 ;
 S ^BLRINSTL("LAB PATCH",CURPATCH,"INSTALLED BY",INSTCNT)=DUZ_"^"_$$GET1^DIQ(200,DUZ,"NAME")
 S ^BLRINSTL("LAB PATCH",CURPATCH,"INSTALLED BY",INSTCNT,"DATE/TIME")=$$HTE^XLFDT($H,"5Z")
 Q
 ;
WARMFZZY(ORDCNT) ; EP - "Warm Fuzzy" for user
 S ORDCNT=ORDCNT+1
 W:(ORDCNT#1000)=0 "."
 W:$X>74 !,?4
 Q
 ;
POSTIT(CP,MSG,BL) ; EP - Write the MSG string and store into the INSTALL file
 NEW (BL,CP,DILOCKTM,DISYS,DT,DTIME,DUZ,IO,IOBS,IOF,IOM,ION,IOS,IOSL,IOST,IOT,IOXY,MSG,U,XPARSYS,XQXFLG)
 ;
 S BL=$G(BL,0)
 D:BL BMES^XPDUTL(MSG)
 D:'BL MES^XPDUTL(MSG)
 ;
 ; Write message into the INSTALL file
 S IEN=$O(^XPD(9.7,"B",CP,"A"),-1)  ; Get Patch IEN
 ;
 S LINE=$O(^XPD(9.7,IEN,"MES","A"),-1)+1
 I BL S ^XPD(9.7,IEN,"MES",LINE,0)=" "  S LINE=LINE+1
 S ^XPD(9.7,IEN,"MES",LINE,0)=MSG
 Q
