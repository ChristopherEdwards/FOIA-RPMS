BLR35PST ; IHS/MSC/MKK - IHS Lab Patch LR*5.2*1035 Post Routine ; 28-Jul-2015 06:30 ; MKK
 ;;5.2;IHS LABORATORY;**1035**;NOV 01, 1997;Build 5
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
 D NOSNAPS^BLRKIDS2(QUIET)   ; Make sure TAKE SNAPSHOTS field in BLR MASTER CONTROL is OFF
 D LABJRNL              ; Get rid of extraneous LAB JOURNAL pointers in file 61.2
 D OERRSTSC^BLR7OB1     ; Change Any Order's deleted test's OERR Status from PENDING (LR*5.2*1033 Bug)
 D NOPCEON              ; Make sure LABORATORY SITE (#69.9) file's PCE/VSIT ON field is OFF
 D CLEANUP              ; Make sure ^BLRENTRY global is Reset
 D BADOERRC             ; Clean up BAD OE/RR Numbers in File 69
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
ADDNOPTS ; EP - ADD New OPTionS
 Q:$G(DEBUG)
 ;
 S TAB=$G(TAB,$J("",5))
 ;
 D NEWOPT("BLRMENU","BLR PURGE ALERTS","PURG",90)     ; Purge Alerts
 D NEWOPT("BLRMENU","BLRGUIER","GUIR")                ; Lab GUI Accession Reports
 D NEWOPT("BLRMENU","BLRLROS","LROS")                 ; RPMS Lab Order/Test Status
 D NEWOPT("BLRMENU","BLRHLMIR","MONJ")                ; Monitor Jobs & HLZTCP
 D NEWOPT("LRSUPERVISOR","BLR Parameter Utilities","EPAR") ; Edit IHS Laboratory XPAR Parameters
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
LABJRNL ; EP - Get rid of pointers in file 61.2 that point to an empty File 95.
 NEW (DILOCKTM,DISYS,DT,DTIME,DUZ,IO,IOBS,IOF,IOM,ION,IOS,IOSL,IOST,IOT,IOXY,U,XPARSYS,XQXFLG)
 ;
 Q:+$O(^LAB(95,0))      ; If there is no data in file 95, don't do anything
 ;
 S CNT=0,IEN=.9999999
 F  S IEN=$O(^LAB(61.2,IEN))  Q:IEN<1  D
 . S JOURN=0  F  S JOURN=$O(^LAB(61.2,IEN,"JR",JOURN))  Q:JOURN<1  D
 .. S CNT=CNT+1
 .. I CNT=1 D
 ... S ^XTMP("LABJOURNL",0)=$$HTFM^XLFDT(+$H+365)_"^"_$$DT^XLFDT_"^Entries In File 61.2 that Pointed to (Empty) File 95"
 .. S ^XTMP("LABJOURNL","61.2","IEN",IEN)=""
 .. M ^XTMP("LABJOURNL","61.2","IEN",IEN,"JOURN",JOURN)=^LAB(61.2,IEN,"JR",JOURN)
 .. ;
 .. K DA
 .. S DA(1)=IEN,DA=JOURN
 .. S DIK="^LAB(61.2,"_DA(1)_",""JR"","
 .. D ^DIK
 ;
 S:CNT ^XTMP("LABJOURNL","61.2")=CNT
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
CHKBCKUP ; EP - Check to determine if BACKUP has been performed.
 NEW CP                       ; Current Patch
 S CP=$TR($P($T(+2),";",5),"*")
 ;
 D PASSMESG^BLRPRE31("ATTENTION")
 W !
 ;
 D ^XBFMK
 S DIR(0)="Y"
 S DIR("B")="NO"
 S DIR("A")=$J("",10)_"Has a >> SUCCESSFUL << backup been performed?"
 D ^DIR
 W !
 ;
 I +$G(Y)'=1 D  Q    ; If BACKUP not performed, then ABORT installation.
 . S XPDABORT=1
 . D PASSMESG^BLRPRE31("ATTENTION")
 . D BMES^XPDUTL($J("",15)_"SUCCESSFUL system backup has >>> NOT <<< been confirmed.")
 . D BMES^XPDUTL($J("",25)_"Installer: "_$$GET1^DIQ(200,DUZ,"NAME")_" ["_DUZ_"].")
 . D BMES^XPDUTL($J("",15)_"Install Aborting.")
 . H 1   ; Pause 1 second to let the user see the message.
 ;
 ; Store backup confirmation person & date/time
 S BCKUPCNT=1+$O(^BLRINSTL("LAB PATCH",CP,"BACKUP CONFIRMED BY",""),-1)
 S ^BLRINSTL("LAB PATCH",CP,"BACKUP CONFIRMED BY",BCKUPCNT)=DUZ_"^"_$P($G(^VA(200,DUZ,0)),U)
 S ^BLRINSTL("LAB PATCH",CP,"BACKUP CONFIRMED BY",BCKUPCNT,"DATE/TIME")=$$HTE^XLFDT($H,"5MZ")
 ;
 D BOKAY^BLRKIDS2("SUCCESSFUL system backup CONFIRMED by: "_$$GET1^DIQ(200,DUZ,"NAME")_".",5)
 H 1     ; Pause 1 second to let the user see the message.
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
NOPCEON ; EP - Ensure LABORATORY SITE (#69.9) file's PCE VISIT ON field is OFF if PCE not installed.
 NEW FDA,ERRS
 ;
 Q:+$$PATCH^BLRUTIL4("PX*1.0*200")     ; Skip if PCE is installed.
 ;
 ; PCE not installed.
 S FDA(69.9,"1,",615)=0
 D UPDATE^DIE("S","FDA",,"ERRS")
 I $D(ERRS)<1 D  Q
 . D BOKAY^BLRKIDS2("LABORATORY SITE (#69.9) file's PCE VISIT ON field is OFF.",5)
 ;
 D BMES^XPDUTL("LABORATORY SITE (#69.9) file's PCE VISIT ON field was NOT set to OFF.")
 Q
 ;
CLEANUP ; EP - Ensure ^BLRENTRY global is purged
 NEW DEBUGGLO
 ;
 Q:$D(^BLRENTRY)<1      ; Skip if ^BLRENTRY is null
 ;
 S DEBUGGLO="^BLRENTRY"
 K @DEBUGGLO
 Q
 ;
BADOERRC ; EP - Clean Up OERR Data in File 69
 NEW (DILOCKTM,DISYS,DT,DTIME,DUZ,IO,IOBS,IOF,IOM,ION,IOS,IOSL,IOST,IOT,IOXY,U,XPARSYS,XQXFLG)
 ;
 D BMES^XPDUTL("Lab Order Entry (#69) File Analysis.")
 S LRODT=.9999999,(BADCNT,BADOCNT,BADTCNT,CNT,DELCNT,ERRSCNT,ORDCNT)=0
 W ?4
 F  S LRODT=$O(^LRO(69,LRODT))  Q:LRODT<1  D
 . S LRSP=0
 . F  S LRSP=$O(^LRO(69,LRODT,1,LRSP))  Q:LRSP<1  D
 .. D WARMFZZY(.ORDCNT)
 .. D CHKOERRO(LRODT,LRSP)
 .. S LROT=0
 .. F  S LROT=$O(^LRO(69,LRODT,1,LRSP,2,LROT))  Q:LROT<1  D
 ... D CHKOERRT(LRODT,LRSP,LROT)
 ;
 W:$X>4 !
 ;
 D BOKAY^BLRKIDS2(ORDCNT_" Orders analyzed.",5)
 I BADCNT<1 D TABMENU^BLRKIDSU(" No anomalies detected.",10)  Q
 ;
 D:BADCNT TABMENU^BLRKIDSU(BADCNT_" Bad Entr"_$$PLURALI^BLRUTIL7(BADCNT)_".",10)
 D:BADOCNT TABMENU^BLRKIDSU(BADOCNT_"Bad Entr"_$$PLURALI^BLRUTIL7(BADOCNT)_" at the Order Level.",15)
 D:BADTCNT TABMENU^BLRKIDSU(BADOCNT_"Bad Entr"_$$PLURALI^BLRUTIL7(BADTCNT)_" at the Test Level.",15)
 D:DELCNT TABMENU^BLRKIDSU(DELCNT_" Bad Entr"_$$PLURALI^BLRUTIL7(DELCNT)_" Deleted.",10)
 D:ERRSCNT TABMENU^BLRKIDSU(ERRSCNT_" Error"_$$PLURAL^BLRUTIL7(ERRSCNT)_" occurred during FILE^DIE.",15)
 ;
 Q
 ;
WARMFZZY(ORDCNT) ; EP - "Warm Fuzzy" for user
 S ORDCNT=ORDCNT+1
 W:(ORDCNT#1000)=0 "."
 W:$X>74 !,?4
 Q
 ;
CHKOERRO(LRODT,LRSP) ; EP - Delete invalid OERR #'s at the Order level
 NEW ERRS,FDA,OERRNUM
 ;
 S OERRNUM=+$P($G(^LRO(69,LRODT,1,LRSP,0)),U,11)
 Q:OERRNUM<1                 ; If no OERR number, skip
 Q:+$G(^OR(100,OERRNUM,0))   ; Skip if OERR # valid
 ;
 S BADCNT=BADCNT+1
 S BADOCNT=BADOCNT+1
 K FDA,ERRS
 S FDA(69.01,LRSP_","_LRODT_",",.11)="@"
 D FILE^DIE("KS","FDA","ERRS")
 ;
 I $D(ERRS)<1 S DELCNT=DELCNT+1  Q
 ;
 D SAVERRS(.FDA,.ERRS,"Order OERR Number Error.")
 Q
 ;
CHKOERRT(LRODT,LRSP,LROT) ; EP - Delete invalid OERR #'s at the Test level
 NEW ERRS,FDA,OERRNUM
 ;
 S OERRNUM=+$P($G(^LRO(69,LRODT,1,LRSP,2,LROT,0)),U,7)
 Q:OERRNUM<1                 ; If no OERR number, skip
 Q:+$G(^OR(100,OERRNUM,0))   ; Skip if OERR # valid
 ;
 S BADCNT=BADCNT+1
 S BADTCNT=BADTCNT+1
 K FDA,ERRS
 S FDA(69.03,LROT_","_LRSP_","_LRODT_",",6)="@"
 D FILE^DIE("KS","FDA","ERRS")
 ;
 I $D(ERRS)<1 S DELCNT=DELCNT+1  Q
 ;
 D SAVERRS(.FDA,.ERRS,"Test OERR Number Error.")  S ERRSCNT=ERRSCNT+1
 Q
 ;
SAVERRS(FDA,ERR,MSG) ; EP
 NEW DAYSPURG,NOW
 ;
 S DAYSPURG=$$HTFM^XLFDT(+$H+180)
 S:$P($G(^XTMP("BLRPRE35",0)),U)<DAYSPURG ^XTMP("BLRPRE35",0)=DAYSPURG_U_DT_U_"LR*5.2*1035"
 S:$G(^XTMP("BLRPRE35","69"))'["BLR35PST Routine." ^XTMP("BLRPRE35","69")="BLR35PST Routine.  Lab Order Entry Anamolies"_U_DT
 S NOW=$H
 M ^XTMP("BLRPRE35","69",NOW,"A FDA")=FDA
 M ^XTMP("BLRPRE35","69",NOW,"B ERRS")=ERRS
 S ^XTMP("BLRPRE35","69",NOW,"C MSG")=MSG
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
