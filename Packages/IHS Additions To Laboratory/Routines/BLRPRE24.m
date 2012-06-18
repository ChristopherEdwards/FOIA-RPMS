BLRPRE24 ; IHS/OIT/MKK - LAB PATCH 1024 ENVIRONMENT/POST INSTALL ROUTINE; [ 01/04/2008  8:00 AM ]
 ;;5.2;LR;**1024**;May 02, 2008
 ;
PRECHK ; EP
 D BMES^XPDUTL("Beginning of Pre Check.")
 NEW CP                   ; Current Patch
 NEW LINE2                ; Second line of THIS Routine
 NEW RPMS                 ; RPMS module being patched
 NEW RPMSVER              ; Version of RPMS module being patched
 NEW STR                  ; String -- used as an array for messages.
 NEW LASTPTCH             ; Last Patch of Lab
 NEW LRSTATUS             ; Last Patch Install Status
 NEW WOTERR               ; Array of errors detected
 ;
 S LINE2=$T(+2)
 ;
 ; Current Patch
 S CP=$TR($P(LINE2,";",5),"*")
 ;
 ; Check for Cache environment
 I $$UP^XLFSTR($$VERSION^%ZOSV(1))'["CACHE" D SORRY("NOT A CACHE ENVIRONMENT.",,,CP) Q
 ;
 ; Last Patch
 S LASTPTCH=+$TR($P(LINE2,";",5),"*")-2
 ;
 ; RPMS Module
 S RPMS=$P(LINE2,";",4)
 ;
 ; Version of RPMS module being patched
 S RPMSVER=$P(LINE2,";",3)
 ;
 S XPDNOQUE="NO QUE"             ; No Queuing Allowed
 ;
 ; The following line prevents the "Disable Options..." and "Move
 ; Routines..." questions from being asked during the install.
 I $G(XPDENV)=1 S (XPDDIQ("XPZ1"),XPDDIQ("XPZ2"))=0
 I $G(XPDENV)=1 S (XPDDIQ("XPZ1"),XPDDIQ("XPZ2"))=0
 F X="XPO1","XPZ1","XPZ2","XPI1" S XPDDIQ(X)=0
 ;
 S XPDABORT=0                    ; KIDS install Flag
 ;
USERID ; CHECK FOR USER ID
 I '$G(DUZ) D SORRY("DUZ UNDEFINED OR 0.",,,CP)  Q
 ;
 I '$L($G(DUZ(0))) D SORRY("DUZ(0) UNDEFINED OR NULL.",,,CP)  Q
 ;
 D HOME^%ZIS             ; IO Defaults
 D DTNOLF^DICRW          ; Set DT variable without Doing a Line Feed
 ;
 S X=$P($G(^VA(200,DUZ,0)),U)
 I $G(X) D SORRY("Installer cannot be identified!",,,CP) Q
 ;
 D OKAY("Pre Check complete.",5)
 ;
LETSGO ; USER IDENTIFIED -- LET'S GO
 D BMES^XPDUTL("Hello, "_$P(X,",",2)_" "_$P(X,","))
  ;
 D BMES^XPDUTL("Checking Environment for Patch "_CP_" of Version "_RPMSVER_" of "_RPMS_".")
 ;
FILEMAN ; CHECK FOR FILEMAN 22.0
 D NEEDIT("DI","22.0",,.WOTERR,CP)
 ;
KERNEL ; CHECK FOR KERNEL 8.0 & PATCH 1013
 D NEEDIT("XU","8.0",1013,.WOTERR,CP)
 ;
LABVER ; CHECK FOR LAB 5.2 & PREVIOUS PATCH
 D NEEDIT("LR","5.2",LASTPTCH,.WOTERR,CP)
 ;
LMIMAIL ; CHECK FOR LMI MAIL GROUP
 D CHECKLMI(.WOTERR,CP)
 ;
MAILMAN ; CHECK FOR MAILMAN 7.1
 D NEEDIT("XM","7.1",,.WOTERR,CP)
 ;
ENVOK ; ENVIRONMENT OK
 I XPDABORT<1 D BMES^XPDUTL("ENVIRONMENT OK.")
  ;
 I XPDABORT>0 D SORRYEND(.WOTERR,CP)
 ;
 Q
 ;
BACKUP ; EP
 D BACKUPS(1024)
 Q
 ;
POST ; EP -- POST INSTALL
 NEW CP                      ; Current Patch
 S CP=$TR($P($T(+2),";",5),"*")
 ;
 D MODBLRM(CP)                     ; Modify BLRMENU option(s)
 ;
 D ALLDONE(CP)                     ; Complete Message
 ;
 ; Store # of times installation occurred as well as person & date/time
 D ENDINSTL(CP)
 ;
 Q
 ;
DEBUG ; Debugging Mode for environment checker
 NEW DEBUG
 S DEBUG="YES"
 D PRECHK
 Q
 ;
 ; Modify menu items on the BLRMENU option
MODBLRM(CP) ;
 ; Remove EDT from BLRMENU
 D DELFMENU("BLRMENU","BLREPOLR","Edit Provider/Ordering Location",CP)
 ;
 ; Add option to run the new IHS LOINC reports to BLRMENU
 D ADDTMENU("BLRMENU","BLRLOINC","LOI","IHS LOINC Percentage report",CP)
 D ADDTMENU("BLRMENU","BLRNOLER","NLO","Lab Tests Without LOINC Entries Report",CP)
 ;
 ; Add option to clear ALL BLR errors from error log regardless
 ; when the error occurred.
 D ADDTMENU("BLRMENU","BLR CLEAR ALL LINK ERRORS","RBE",,CP)
 Q
 ;
NEEDIT(MODULE,VERSION,PATCH,WOTERR,CP)      ; EP
 ; Generic "Find RPMS Module's Version and (perhaps) Patch number"
 ; 
 ;      NOTE: The MODULE variable MUST be the PREFIX name
 ;            from the PACKAGE file (9.4).
 ;            
 NEW NAME                ; NAME of RPMS Module
 NEW PTR                 ; PoinTeR to PACKAGE file
 NEW HEREYAGO            ; Array to store returned values from FIND^DIC
 NEW STR1,STR2           ; Temporary Strings
 ;
 ; Use FileMan API to get information
 D FIND^DIC(9.4,"","","",MODULE,"","C","","","HEREYAGO")
 S PTR=$G(HEREYAGO("DILIST",2,1))
 S NAME=$G(HEREYAGO("DILIST",1,1))
 ;
 S X=$$VERSION^XPDUTL(MODULE)           ; Get the Version
 D BMES^XPDUTL("Need at least "_NAME_" "_VERSION)
 I X<VERSION D  Q
 . S WOTERR(MODULE,NAME,VERSION)=""
 . S STR1="Need "_NAME_" "_VERSION_" & "_NAME_" "_X_" found!"
 . I $L(STR1)<58 D SORRY(STR1,,,CP)
 . I $L(STR1)>57 D
 .. S STR1="Need "_NAME_" "_VERSION_" & "
 .. S STR2=NAME_" "_X_" found!"
 .. D SORRY(STR1,,STR2,CP)
 ;
 D OKAY(NAME_" "_X_" found.")
 ;
 I $G(PATCH)="" Q   ; If no Patch check, just exit
 ;
 D BMES^XPDUTL("     Need "_NAME_" "_VERSION_" Patch "_PATCH_".")
 S X=$$PATCH^XPDUTL(MODULE_"*"_VERSION_"*"_PATCH)
 I X'=1 D  Q
 . S WOTERR(MODULE,NAME,VERSION)=$G(PATCH)
 . S STR1=NAME_" "_VERSION_" Patch "_PATCH_" WAS NOT installed!"
 . I $L(STR1)<58 D SORRY(STR1,,,CP)
 . I $L(STR1)>57 D
 .. S STR1=NAME_" "_VERSION
 .. S STR2="Patch "_PATCH_" WAS NOT installed!"
 .. D SORRY(STR1,,STR2,CP)
 ;
 D OKAY(NAME_" "_VERSION_" Patch "_PATCH_" found.",10)
 ;
 Q
 ;
SORRY(MSG,MODE,MSG2,CP)       ; EP
 ; Error Message routine.  It will send an ALERT and a MailMan message
 ; to the people who are assigned to the LMI Mail group (if it exists).
 ;
 ; The STR array is built so that the error/warning message will
 ; also appear on the INSTALL LOG via the D BMES^XPDUTL(.STR) call.
 ;
 NEW MESSAGE
 I $G(MODE)'["NONFATAL" D
 . S MESSAGE="Install Aborting due to the following Systems Environment issue:"
 . S XPDABORT=1     ; Fatal Error Flag Set
 ;
 I $G(MODE)["NONFATAL" S MESSAGE="*** WARNING *** WARNING *** WARNING ***"
 ;
 K DIFQ
 ;
 NEW STR,LINECNT
 S LINECNT=1
 D ADDLINE($TR($J("",65)," ","*"),.LINECNT)    ; Row of asterisks
 D ADDLINE(" ",.LINECNT)
 D ADDLINE($$CJ^XLFSTR("Site: "_$$LOC^XBFUNC,65),.LINECNT)
 D ADDLINE(" ",.LINECNT)
 D ADDLINE($$CJ^XLFSTR(MESSAGE,65),.LINECNT)
 D ADDLINE(" ",.LINECNT)
 D ADDLINE($$CJ^XLFSTR(">>> "_MSG_" <<<",65),.LINECNT)
 I $D(MSG2) D ADDLINE($$CJ^XLFSTR(">>> "_MSG2_" <<<",65),.LINECNT)
 D ADDLINE(" ",.LINECNT)
 ;
 I $G(MODE)["NONFATAL" D ADDLINE($$CJ^XLFSTR(MESSAGE,65),.LINECNT)
 ;
 I $G(MODE)'["NONFATAL" D
 . D ADDLINE($$CJ^XLFSTR("Please print/capture this screen and",65),.LINECNT)
 . D ADDLINE($$CJ^XLFSTR("notify the Support Center at",65),.LINECNT)
 . D ADDLINE(" ",.LINECNT)
 . D ADDLINE($$CJ^XLFSTR("1-999-999-9999.",65),.LINECNT)
 . D ADDLINE(" ",.LINECNT)
 ;
 D ADDLINE($TR($J("",65)," ","*"),.LINECNT)    ; Row of asterisks
 D ADDLINE(" ",.LINECNT)
 ;
 D BMES^XPDUTL(.STR)               ; Display the message
 ;
 ; If Debugging, just exit -- Don't send e-mail nor alert
 I $G(DEBUG)="YES" Q
 ;
 I $G(MODE)'="NONFATAL" D  Q
 . D SNDALERT("Laboratory Patch "_CP_" >> FATAL >> "_MSG)
 . D SENDMAIL("IHS Lab Patch "_CP_" Install FATAL Error")
 ;
 I $G(MODE)="NONFATAL" D
 . D SNDALERT("Laboratory Patch "_CP_" - "_MODE_" - "_MSG)
 . D SENDMAIL("IHS Lab Patch "_CP_" Install NONFATAL Error")
 Q
 ;
SNDALERT(ALERTMSG) ; EP
 ; Send alert to LMI group
 S XQAMSG=ALERTMSG
 S XQA("G.LMI")=""
 D SETUP^XQALERT
 K XQA,XQAMSG
 Q
 ;
SENDMAIL(MAILMSG) ; EP
 ; Send MailMan E-mail to LMI group -- message is in the STR array
 K XMY
 S XMY("G.LMI")=""            ; Group
 S %DT="T"
 S X="NOW"
 D ^%DT
 D DD^LRX
 S LRBLNOW=Y
 ;
 S XMSUB=MAILMSG
 S XMTEXT="STR("
 S XMDUZ=$P($G(^VA(200,DUZ,0)),U)
 ;
 D ^XMD                       ; Send the MailMan e-mail
 ;
 K X,XMDUZ,XMSUB,XMTEXT,Y     ; Cleanup
 Q
 ;
SORRYEND(WOTERR,CP) ; EP
 ; Output a listing of ALL the errors detected during
 ; the environment check.  The STR array will be
 ; displayed by the BMES^XPDUTL call.
 ; 
 NEW STR,MODULE,NAME,VERSION,PATCH,LINECNT,TMP
 ;
 D SORRYHED
 ;
 ; Add ALL the errors detected to the STR array
 S (MODULE,NAME,VERSION)=""
 F  S MODULE=$O(WOTERR(MODULE))  Q:MODULE=""  D
 . F  S NAME=$O(WOTERR(MODULE,NAME))  Q:NAME=""  D
 .. F  S VERSION=$O(WOTERR(MODULE,NAME,VERSION))  Q:VERSION=""  D
 ... D ADDMESG
 ;
 D SORRYFIN
 ;
 D BMES^XPDUTL(.STR)     ; Display the message in the STR array
 ;
 Q
 ;
SORRYHED ; EP
 ; "Header" of Final Fatal Message
 S LINECNT=1
 D ADDLINE(" ",.LINECNT)
 D ADDLINE($TR($J("",65)," ","*"),.LINECNT)
 D ADDLINE(" ",.LINECNT)
 D ADDLINE($$CJ^XLFSTR("Systems Environment Error Detected",65),.LINECNT)
 D ADDLINE($$CJ^XLFSTR("KIDS build will be deleted",65),.LINECNT)
 D ADDLINE(" ",.LINECNT)
 D ADDLINE($$CJ^XLFSTR("Modules with Version or Patch errors",65),.LINECNT)
 D ADDLINE(" ",.LINECNT)
 Q
 ;
SORRYFIN ; EP
 ; "Fin" of Final Fatal Message
 D ADDLINE($$CJ^XLFSTR("Re-Installation will be necessary.",65),.LINECNT)
 D ADDLINE(" ",.LINECNT)
 D ADDLINE($$CJ^XLFSTR("If assistance is needed, please call 1-999-999-9999.",65),.LINECNT)
 D ADDLINE(" ",.LINECNT)
 D ADDLINE($TR($J("",65)," ","*"),.LINECNT)
 D ADDLINE(" ",.LINECNT)
 Q
 ;
ADDMESG ; EP
 ; Add to the STR array
 S PATCH=$G(WOTERR(MODULE,NAME,VERSION))
 D ADDLINE($$CJ^XLFSTR(NAME_" ("_MODULE_")",65),.LINECNT)
 ;
 S TMP="Version:"_VERSION
 I $G(PATCH)'="" S TMP=TMP_"  Patch:"_$G(PATCH)
 ;
 D ADDLINE($$CJ^XLFSTR(TMP,65),.LINECNT)
 D ADDLINE(" ",.LINECNT)
 Q
 ;
ADDLINE(ASTR,LC) ; EP
 ; Add a line to the STR array
 I $G(ASTR)="" S ASTR=" "
 S STR(LC)=ASTR
 S LC=LC+1
 Q
 ;
OKAY(MSG,TAB)       ; EP
 ; Write out "OKAY" message
 NEW MESSAGE
 I $G(TAB)="" S TAB=5
 S MESSAGE=$J("",TAB)_MSG_" OK."
 D MES^XPDUTL(MESSAGE)
 Q
 ;
CHECKLMI(WOTERR,CP) ; EP
 ;CHECK FOR LMI MAIL GROUP
 NEW OKAY
 D BMES^XPDUTL("Must have 'LMI' mail group present.")
 S DIC="^XMB(3.8,"
 S X="LMI"
 D ^DIC
 S OKAY=+Y
 I OKAY>0 D OKAY("'LMI' mail group found.")
 I OKAY<1 D
 . D SORRY("'LMI' mail group NOT found!",,,CP)
 . S WOTERR("XMB(3.8","Mail Group","3.8")="LMI Mail Group"
 Q
 ;
BACKUPS(CP) ; EP - CHECK TO CONFIRM BACKUPS HAVE BEEN DONE
 ; CP  = Current Patch
 ;
 D BMES^XPDUTL("BACKUPS Check Next.")
 ;
 W !!
 D ^XBFMK                         ; Clear all FileMan variables
 S DIR(0)="Y"
 S DIR("B")="NO"
 S DIR("A")="Has a SUCCESSFUL system backup been performed??"
 D ^DIR
 ;
 ; IF and ONLY IF backups not confirmed, send NONFATAL alert & e-mail.
 I $D(DIRUT)!($G(Y)=0) D  Q
 . D SORRY("Please perform a successful backup before continuing!!","NONFATAL")
 ;
 ; User stated Backup has been Done, so display message.
 NEW DTT
 S DTT=$$UP^XLFSTR($$HTE^XLFDT($H,"MZ"))
 S STR="BACKUPS CONFIRMED BY "_$P($G(^VA(200,DUZ,0)),U)_" ON "
 S STR=STR_$P(DTT,"@")_" AT "_$P(DTT,"@",2)
 D BMES^XPDUTL(STR)
 D MES^XPDUTL(" ")
 ;
 ; Store backup confirmation person & date/time
 NEW BCKUPCNT                   ; Current Patch,Backup count
 S BCKUPCNT=1+$O(^BLRINSTL("LAB PATCH",CP,"BACKUP CONFIRMED BY",""),-1)
 S ^BLRINSTL("LAB PATCH",CP,"BACKUP CONFIRMED BY",BCKUPCNT)=$P($G(^VA(200,DUZ,0)),U)
 S ^BLRINSTL("LAB PATCH",CP,"BACKUP CONFIRMED BY",BCKUPCNT,"DATE/TIME")=$$HTE^XLFDT($H,"5MZ")
 ;
 Q
 ;
TABMESG(MSG,TAB,TAIL) ; EP
 ; Generic message output WITH blank line BEFORE messsage & TAB
 NEW MESSAGE
 I $G(TAB)="" S TAB=5
 S MESSAGE=$J("",TAB)_MSG
 I $G(TAIL)'="" S MESSAGE=MESSAGE_" "_TAIL
 D BMES^XPDUTL(MESSAGE)
 Q
 ;
TABMENU(MSG,TAB,TAIL) ; EP
 ; Generic message output WITHOUT blank line BEFORE messsage & TAB
 NEW MESSAGE
 I $G(TAB)="" S TAB=5
 S MESSAGE=$J("",TAB)_MSG
 I $G(TAIL)'="" S MESSAGE=MESSAGE_" "_TAIL
 D MES^XPDUTL(MESSAGE)
 Q
 ;
ADDTMENU(ADDER,ADDEE,ITM,IMSG,CP)    ; EP
 ; Procedure that adds the options to Menus.
 ; Uses Kernel's ADD^XPDMENU function
 NEW ADDOPT,CHKIT,STR1,STR2,STR3
 ;
 ; ADDOPT String set to ADDEE string or Interactive MeSsaGe string
 S ADDOPT=$S($D(IMSG):IMSG,1:ADDEE)
 ;
 D BMES^XPDUTL("Adding "_ADDOPT_" to "_ADDER_".")
 ;
 S CHKIT=$$ADD^XPDMENU(ADDER,ADDEE,ITM)
 ;
 I CHKIT=1 D  Q
 . D OKAY(ADDOPT_" added to "_ADDER_".",5)
 . D MES^XPDUTL(" ")
 ;
 I CHKIT'=1 D
 . S STR1="Error in adding "_ADDOPT_" to "_ADDER_"."
 . I $L(STR1)<58 D SORRY(STR1,"NONFATAL",,CP)
 . I $L(STR1)>57 D
 .. S STR1="Error in adding "_ADDOPT
 .. S STR2="to "_ADDER
 .. D SORRY(STR1,"NONFATAL",STR2,,CP)
 ;
 Q
 ;
DELFMENU(DMENU,DOPTION,IMSG,CP)    ; EP
 ; Procedure that deletes from a Menu.
 ; It is OKAY if the option doesn't exist on the Menu.
 ; Uses Kernel's DELETE^XPDMENU function
 NEW CHKIT,DELOPT,STR1,STR2
 NEW DMENUIEN,HEREYAGO
 ;
 ; DELOPT String set to DOPTION string or Interactive MeSsaGe string
 S DELOPT=$S($D(IMSG):IMSG,1:DOPTION)
 ;
 D BMES^XPDUTL("Removing "_DELOPT_" from "_DMENU_".")
 ;
 ; First, Find IEN of MENU from which option will be deleted
 D FIND^DIC(19,,,,"BLRMENU",,,,,"HEREYAGO")
 S DMENUIEN=+$G(HEREYAGO("DILIST",2,1))
 ;
 ; If MENU doesn't exist, just write a message and return
 I DMENUIEN<1 D  Q
 . D OKAY("MENU "_DMENU_" NOT Found in Option File.",5)
 . D MES^XPDUTL(" ")
 ;
 ; Find out if Option still on the MENU from which it is to be deleted.
 K HEREYAGO
 D FIND^DIC(19.01,","_DMENUIEN_",",,,DOPTION,,,,,"HEREYAGO")
 ;
 ; If Option is not on MENU, then just write a message and return
 I +$G(HEREYAGO("DILIST",2,1))<1  D  Q
 . S STR1=DELOPT_" not found on "_DMENU_"."
 . I $L(STR1)<58 D  Q
 .. D OKAY(STR1,5)
 .. D MES^XPDUTL(" ")
 . ;
 . S STR1=DELOPT_" not found"
 . S STR2="on "_DMENU_"."
 . D TABMESG(STR1,5)
 . D OKAY(STR2,5)
 . D MES^XPDUTL(" ")
 ;
 S CHKIT=$$DELETE^XPDMENU(DMENU,DOPTION)
 ;
 I CHKIT=1 D  Q
 . D OKAY(DELOPT_" removed from "_DMENU_".",5)
 . D MES^XPDUTL(" ")
 ;
 I CHKIT'=1 D
 . S STR1="Error removing "_DELOPT_" from "_DMENU_"."
 . I $L(STR1)<58 D SORRY(STR1,"NONFATAL",,CP)
 . I $L(STR1)>57 D
 .. S STR1="Error removing "_DELOPT
 .. S STR2="from "_DMENU
 .. D SORRY(STR1,"NONFATAL",STR2,CP)
 ;
 Q
 ;
ALLDONE(CURPATCH) ; EP
 ; Complete Message
 NEW STR,LINECNT,MSG
 ;
 S MSG="Laboratory Patch "_CURPATCH_" INSTALL complete."
 ;
 K STR
 S LINECNT=1
 D ADDLINE($TR($J("",65)," ","*"),.LINECNT)    ; Row of asterisks
 D ADDLINE(" ",.LINECNT)
 D ADDLINE($$CJ^XLFSTR("Site: "_$$LOC^XBFUNC,65),.LINECNT)
 D ADDLINE(" ",.LINECNT)
 D ADDLINE($$CJ^XLFSTR(MSG,65),.LINECNT)
 D ADDLINE(" ",.LINECNT)
 D ADDLINE($TR($J("",65)," ","*"),.LINECNT)
 D ADDLINE(" ",.LINECNT)
 ;
 D BMES^XPDUTL(.STR)               ; Display the message
 D SNDALERT(MSG)
 D SENDMAIL(MSG)
 ;
 Q
 ;
ENDINSTL(CURPATCH)       ; EP
 ; Procedure that stores information into the ^BLRINSTL global
 ; regarding # of times instllation occurred as well as the
 ; person who is installaing and the date/time of the install.
 ; 
 NEW INSTCNT                        ; Installation count
 ;
 S INSTCNT=1+$O(^BLRINSTL("LAB PATCH",CURPATCH,"INSTALLED BY",""),-1)
 ;
 S ^BLRINSTL("LAB PATCH",CURPATCH,"INSTALLED BY",INSTCNT)=$P($G(^VA(200,DUZ,0)),U)
 S ^BLRINSTL("LAB PATCH",CURPATCH,"INSTALLED BY",INSTCNT,"DATE/TIME")=$$HTE^XLFDT($H,"5Z")
 Q
