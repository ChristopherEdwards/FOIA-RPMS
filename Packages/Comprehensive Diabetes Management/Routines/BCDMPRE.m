BCDMPRE ; IHS/OIT/MKK -- BCDM Version 1.0 ENVIRONMENT/POST INSTALL ROUTINE;JUL 16, 2008 3:19 PM
 ;;1.0;IHS CHRONIC DISEASE MANAGEMENT;;JUN 29, 2010
 ;
PRECHK ; EP
 D BMES^XPDUTL("Beginning of Pre Check.")
 NEW CP                   ; Current Patch
 NEW LINE2                ; Second line of THIS Routine
 NEW RPMS                 ; RPMS module being patched
 NEW RPMSVER              ; Version of RPMS module being patched
 NEW STR                  ; String -- used as an array for messages.
 NEW LASTPTCH             ; Last Patch of Lab
 NEW LSTPISTS             ; Last Patch Install Status
 NEW WOTERR               ; Array of errors detected
 ;
 S LINE2=$T(+2)
 ;
 ; Check for Cache environment
 I $$UP^XLFSTR($$VERSION^%ZOSV(1))'["CACHE" D SORRY("NOT A CACHE ENVIRONMENT.") Q
 ;
 ; Current Patch
 S CP=+$TR($P(LINE2,";",5),"*")
 ;
 ; Last Patch
 S LASTPTCH=CP-1
 I LASTPTCH<1 S LASTPTCH=0
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
FILEMAN ; CHECK FOR FILEMAN 22.0
 D NEEDIT("DI","22.0",,.WOTERR)
 ;
KERNEL ; CHECK FOR KERNEL 8.0 & PATCH 1013
 D NEEDIT("XU","8.0",1013,.WOTERR)
 ;
MAILMAN ; CHECK FOR MAILMAN 7.1
 D NEEDIT("XM","7.1",,.WOTERR)
 ;
GIS ; CHECK FOR GIS 3.01 Patch 14
 D NEEDIT("GIS","3.01",14,.WOTERR)
 ;
AUPN  ; CHECK FOR AUPN 99.1 & PATCH 20
 D NEEDIT("AUPN","99.1",20,.WOTERR)
 ;
AICD  ; CHECK FOR AICD 3.51 & PATCH 7
 D NEEDIT("AICD","3.51",7,.WOTERR)
 ;
AUT  ; CHECK FOR AUT 98.1 & PATCH 16
 D NEEDIT("AUT","98.1",16,.WOTERR)
 ;
BJPC ; CHECK FOR BJPC 2.0 & Patch 4
 D NEEDIT("BJPC","2.0",4,.WOTERR)
 ;
ENVOK ; ENVIRONMENT OK
 I XPDABORT<1 D BMES^XPDUTL("ENVIRONMENT OK.")
  ;
 I XPDABORT>0 D SORRYEND(.WOTERR)
 ;
 Q
 ;
BACKUP ; EP
 D BACKUPS(0)
 Q
 ;
POST ; EP -- POST INSTALL
 NEW CP                      ; Current Patch
 S CP=$TR($P($T(+2),";",5),"*")
 ;
 D ALLDONE(CP)                     ; Complete Message
 ;
 ; Store # of times installation occurred as well as person & date/time
 D ENDINSTL(CP)
 ;
 Q
 ;
DEBUG ; Debugging node for environment checker
 NEW DEBUG
 S DEBUG="YES"
 D PRECHK
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
 I $G(NAME)="" S NAME=MODULE
 ;
 S X=$$VERSION^XPDUTL(MODULE)           ; Get the Version
 D BMES^XPDUTL("Need at least "_NAME_" "_VERSION)
 I X<VERSION D  Q
 . S WOTERR(MODULE,NAME,VERSION)=""
 . S STR1="Need "_NAME_" "_VERSION_" & "_NAME_" "_X_" found!"
 . I $L(STR1)<58 D SORRY(STR1)
 . I $L(STR1)>57 D
 .. S STR1="Need "_NAME_" "_VERSION_" & "
 .. S STR2=NAME_" "_X_" found!"
 .. D SORRY(STR1,,STR2)
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
 . I $L(STR1)<58 D SORRY(STR1)
 . I $L(STR1)>57 D
 .. S STR1=NAME_" "_VERSION
 .. S STR2="Patch "_PATCH_" WAS NOT installed!"
 .. D SORRY(STR1,,STR2)
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
 . D ADDLINE($$CJ^XLFSTR("1-888-830-7280.",65),.LINECNT)
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
 . D SNDALERT(RPMS_" Version "_RPMSVER_" >> FATAL >> "_MSG)
 . D SENDMAIL(RPMS_" Version "_RPMSVER_" Install FATAL Error")
 ;
 I $G(MODE)="NONFATAL" D
 . D SNDALERT(RPMS_" Version "_RPMSVER_" - "_MODE_" - "_MSG)
 . D SENDMAIL(RPMS_" Version "_RPMSVER_" Install NONFATAL Error")
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
 D ADDLINE($$CJ^XLFSTR("If assistance is needed, please call 1-888-830-7280.",65),.LINECNT)
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
BACKUPS(CURPATCH) ; EP - CHECK TO CONFIRM BACKUPS HAVE BEEN DONE
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
 S STR="BACKUPS CONFIRMED BY "_$P($G(^VA(200,DUZ,0)),U)_" ("_DUZ_") "
 S STR=STR_$$UP^XLFSTR($$HTE^XLFDT($H,"MP"))
 D TABMESG(STR,,". OK.","YES")
 ;
 ; Store backup confirmation person & date/time
 NEW RPMS,RPMSVER                      ; Package & Version
 NEW CP,BCKUPCNT                       ; Current Patch,Backup count
 ;
 S RPMS=$P($T(+2),";",4)               ; RPMS Module
 S RPMSVER=$P($T(+2),";",3)            ; Version of RPMS module
 ;
 S CP=+$G(CURPATCH)
 ;
 S BCKUPCNT=1+$O(^BCDMINST(RPMS,RPMSVER,+$G(CP),"BACKUP CONFIRMED BY",""),-1)
 S ^BCDMINST(RPMS,RPMSVER,CP,"BACKUP CONFIRMED BY",BCKUPCNT,+$G(DUZ))=$P($G(^VA(200,DUZ,0)),U)
 S ^BCDMINST(RPMS,RPMSVER,CP,"BACKUP CONFIRMED BY",BCKUPCNT,+$G(DUZ),"DATE/TIME")=$$UP^XLFSTR($$HTE^XLFDT($H,"MP"))
 ;
 Q
 ;
TABMESG(MSG,TAB,TAIL,XTRALINE) ; EP
 ; Generic message output WITH blank line BEFORE messsage & TAB
 NEW MESSAGE
 I $G(TAB)="" S TAB=5
 S MESSAGE=$J("",TAB)_MSG
 I $G(TAIL)'="" S MESSAGE=MESSAGE_TAIL
 D BMES^XPDUTL(MESSAGE)
 I $D(XTRALINE) D MES^XPDUTL(" ")      ; Write Blank line AFTER message, also
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
ALLDONE(CURPATCH) ; EP
 ; Complete Message
 NEW LINE2,LINECNT,MSG,RPMS,RPMSVER,STR
 ;
 S LINE2=$T(+2)
 ;
 ; RPMS Module
 S RPMS=$P(LINE2,";",4)
 ;
 ; Version of RPMS module
 S RPMSVER=$P(LINE2,";",3)
 ;
 S MSG=RPMS_" Version "_RPMSVER_" INSTALL complete."
 ;
 I $G(CURPATCH)'="" S MSG=RPMS_" Version "_RPMSVER_" Patch "_CURPATCH_" INSTALL complete."
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
 ;
 I $G(DEBUG)="YES" Q
 ;
 D SNDALERT(MSG)
 D SENDMAIL(MSG)
 ;
 Q
 ;
ENDINSTL(CURPATCH)       ; EP
 ; Procedure that stores information into the ^BCDMINSTL global
 ; regarding # of times instllation occurred as well as the
 ; person who is installaing and the date/time of the install.
 ; 
 NEW INSTCNT,LINE2,MSG,CP,RPMS,RPMSVER
 ;
 S LINE2=$T(+2)
 ;
 S RPMS=$P(LINE2,";",4)           ; RPMS Module
 ;
 S RPMSVER=$P(LINE2,";",3)        ; Version of RPMS module
 ;
 S CP=+$G(CURPATCH)               ; Current Patch Number
 ;
 ; Installation count
 S INSTCNT=1+$O(^BCDMINST(RPMS,RPMSVER,CP,"INSTALLED BY",""),-1)
 ;
 S ^BCDMINST(RPMS,RPMSVER,CP,"INSTALLED BY",INSTCNT,+$G(DUZ))=$P($G(^VA(200,+$G(DUZ),0)),U)
 S ^BCDMINST(RPMS,RPMSVER,CP,"INSTALLED BY",INSTCNT,+$G(DUZ),"DATE/TIME")=$$UP^XLFSTR($$HTE^XLFDT($H,"MP"))
 Q
