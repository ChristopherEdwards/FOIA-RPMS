BLRPRE22 ; IHS/ITSC/MKK - LAB PATCH 22 ENVIRONMENT/POST INSTALL ROUTINE; [ 03/31/2007  8:00 AM ]
 ;;5.2;LR;**1022**;September 20, 2007
 ;
PRECHK ; EP
 D BMES^XPDUTL("Beginning of Pre Check.")
 NEW CP                   ; Current Patch
 NEW RPMS                 ; RPMS module being patched
 NEW RPMSVER              ; Version of RPMS module being patched
 NEW STR                  ; String -- used as an array for messages.
 NEW LASTPTCH             ; Last Patch of Lab
 NEW LRSTATUS             ; Last Patch Install Status
 NEW WOTERR               ; Array of errors detected
 ;
 ; Must check for Cache environment before anything else
 I $$UP^XLFSTR($$VERSION^%ZOSV(1))'["CACHE" D SORRY("NOT A CACHE ENVIRONMENT.") Q
 ;
 S CP=$TR($P($T(+2),";",5),"*")              ; Current Patch
 S LASTPTCH=+$TR($P($T(+2),";",5),"*")-1     ; Last Patch
 S RPMS=$P($T(+2),";",4)                     ; RPMS Module
 S RPMSVER=$P($T(+2),";",3)                  ; Version of RPMS module being patched
 ;
 S XPDNOQUE="NO QUE"               ; No Queuing Allowed
 ;
 ; DISABLE THE "Disable options..." and "Move routines..."
 ; questions from being asked during install     
 S (XPDDIQ("XPZ1"),XPDDIQ("XPZ2"))=0
 ;
 S XPDDIQ("XPO1")=0                ; DISABLE "Rebuild Menu Tree" question
 ;
 S XPDABORT=0                      ; KIDS install Flag
 ;
USERID ; CHECK FOR USER ID
 I '$G(DUZ) D SORRY("DUZ UNDEFINED OR 0.")  Q
 ;
 I '$L($G(DUZ(0))) D SORRY("DUZ(0) UNDEFINED OR NULL.")  Q
 ;
 D HOME^%ZIS             ; IO Defaults
 D DTNOLF^DICRW          ; Set DT variable without doing a Line Feed
 ;
 S X=$P($G(^VA(200,DUZ,0)),U)
 I $G(X) D SORRY("Installer cannot be identified!") Q
 ;
 D OKAY("Pre Check complete.",5)
 ;
LETSGO ; USER IDENTIFIED -- LET'S GO
 D BMES^XPDUTL("Hello, "_$P(X,",",2)_" "_$P(X,","))
 ;
 D BMES^XPDUTL("Checking Environment for Patch "_CP_" of Version "_RPMSVER_" of "_RPMS_".")
 ;
FILEMAN ; CHECK FOR FILEMAN 22.0
 D NEEDIT("DI","22.0")
 ;
KERNEL ; CHECK FOR KERNEL 8.0 & PATCH 1012
 D NEEDIT("XU","8.0",1012)
 ;
LMIMAIL ; CHECK FOR LMI MAIL GROUP
 I $$CHECKLMI<1 Q
 ;
OERR ; CHECK FOR OERR 2.5
 D NEEDIT("OR","2.5")
 ;
PIMS ; CHECK FOR PIMS 5.3 & PATCH 1004
 D NEEDIT("PIMS","5.3",1004)
 ;
APCD ; CHECK FOR APCD 2.0 & PATCH 8
 D NEEDIT("APCD","2.0",8)
 ;
TIU ; CHECK FOR TIU 1.0 & PATCH 137
 D NEEDIT("TIU","1.0",137)
 ;
USR ; CHECK FOR USR 1.0 & PATCH 23
 D NEEDIT("USR","1.0",23)
 ;
LEXICON ; CHECK FOR LEXICON 2.0
 D NEEDIT("LEX","2.0")
 ;
LABVER ; CHECK FOR LAB 5.2 & PREVIOUS PATCH
 D NEEDIT("LR","5.2",LASTPTCH)
 ;
ENVOK ; ENVIRONMENT OK
 I XPDABORT<1 D BMES^XPDUTL("ENVIRONMENT OK.")
 ;
 I XPDABORT>0 D SORRYEND
 ;
 Q
 ;
BACKUPS ; CHECK TO CONFIRM BACKUPS HAVE BEEN DONE
 NEW CP                            ; Current Patch
 ;
 S CP=$TR($P($T(+2),";",5),"*")    ; Current Patch
 ;
 D BMES^XPDUTL("BACKUPS Check Next.")
 ;
 W !!
 D ^XBFMK                          ; Clear all FileMan variables
 S DIR(0)="Y"
 S DIR("B")="NO"
 S DIR("A")="Has a SUCCESSFUL system backup been performed??"
 D ^DIR
 ;
 ; IF and ONLY IF backups not confirmed, send NONFATAL alert & e-mail.
 I $D(DIRUT)!($G(Y)=0) D  Q
 . D SORRY("Please perform a successful backup before continuing!!","NONFATAL")
 ;
 ; User stated Backup has been done, so display message.
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
 ; Generic "Find RPMS Module's Version and (perhaps) Patch number"
 ; 
 ;      NOTE: The MODULE variable MUST be the PREFIX name
 ;            from the PACKAGE file (9.4).
 ;            
NEEDIT(MODULE,VERSION,PATCH)      ; EP
 NEW NAME                ; NAME of RPMS Module
 NEW PTR                 ; PoinTeR to PACKAGE file
 NEW HEREYAGO            ; Array to store returned values from FIND^DIC
 ;
 ; Use FileMan API to get information
 D FIND^DIC(9.4,"","","",MODULE,"","C","","","HEREYAGO")
 S PTR=$G(HEREYAGO("DILIST",2,1))
 S NAME=$G(HEREYAGO("DILIST",1,1))
 ;
 S X=$$VERSION^XPDUTL(MODULE)           ; Get the Version
 D BMES^XPDUTL("Need at least "_NAME_" "_VERSION)
 I X<VERSION D  Q
 . D SORRY("Need "_NAME_" "_VERSION_" & "_NAME_" "_X_" found!")
 . S WOTERR(MODULE,NAME,VERSION)=""
 ;
 D OKAY(NAME_" "_X_" found.")
 ;
 I $G(PATCH)="" Q   ; If no Patch check, just exit
 ;
 D BMES^XPDUTL("     Need "_NAME_" "_VERSION_" Patch "_PATCH_".")
 S X=$$PATCH^XPDUTL(MODULE_"*"_VERSION_"*"_PATCH)
 I X'=1 D  Q
 . D SORRY(NAME_" Patch "_PATCH_" WAS NOT installed!")
 . S WOTERR(MODULE,NAME,VERSION)=$G(PATCH)
 ;
 D OKAY(NAME_" "_VERSION_" Patch "_PATCH_" found.",10)
 ;
 Q
 ;
 ; Error Message routine.  It will send an ALERT and a MailMan message
 ; to the people who are assigned to the LMI Mail group.
 ; ;
 ; The output array is built so that the error/warning message will
 ; also appear on the INSTALL LOG via the D BMES^XPDUTL(.STR) call.
SORRY(MSG,MODE)       ;
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
 S STR(1)=" "
 S STR(2)=$TR($J("",65)," ","*")    ; Row of asterisks
 S STR(3)=" "
 S STR(4)=$$CJ^XLFSTR("Site: "_$$LOC^XBFUNC,65)
 S STR(5)=" "
 S STR(6)=$$CJ^XLFSTR(MESSAGE,65)
 S STR(7)=" "
 S STR(8)=$$CJ^XLFSTR(">>> "_MSG_" <<<",65)
 S STR(9)=" "
 ;
 I $G(MODE)["NONFATAL" D
 . S STR(10)=$$CJ^XLFSTR(MESSAGE,65)
 . S STR(11)=" "
 . S LINECNT=12
 ;
 I $G(MODE)'["NONFATAL" D
 . S STR(10)=$$CJ^XLFSTR("Please print/capture this screen and",65)
 . S STR(11)=$$CJ^XLFSTR("notify the Support Center at",65)
 . S STR(12)=" "
 . S STR(13)=$$CJ^XLFSTR("1-999-999-9999.",65)
 . S STR(14)=" "
 . S LINECNT=15
 ;
 S STR(LINECNT)=$G(STR(2))         ; Row of asterisks
 S LINECNT=LINECNT+1
 S STR(LINECNT)=" "
 ;
 D BMES^XPDUTL(.STR)               ; Display the message
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
 ; Send alert to LMI group
SNDALERT(ALERTMSG) ;
 S XQAMSG=ALERTMSG
 S XQA("G.LMI")=""
 D SETUP^XQALERT
 K XQA,XQAMSG
 Q
 ;
 ; Send MailMan E-mail to LMI group -- message is in the STR array
SENDMAIL(MAILMSG) ;
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
 ; Output a listing of ALL the errors detected during
 ; the environment check.
SORRYEND ;
 NEW STR,MODULE,NAME,VERSION,PATCH,LINECNT,TMP
 ;
 D BMES^XPDUTL(" ")
 ; 
 S STR(1)=$TR($J("",65)," ","*")
 S STR(2)=" "
 S STR(3)=$$CJ^XLFSTR("Systems Environment Error Detected",65)
 S STR(4)=$$CJ^XLFSTR("KIDS build will be deleted",65)
 S STR(5)=" "
 S STR(6)=$$CJ^XLFSTR("Modules with Version or Patch errors",65)
 S STR(7)=" "
 S LINECNT=8
 ;
 ; Continue building the STR array that will be displayed via the 
 ; BMES^XPDUTL call.
 S (MODULE,NAME,VERSION)=""
 F  S MODULE=$O(WOTERR(MODULE))  Q:MODULE=""  D
 . F  S NAME=$O(WOTERR(MODULE,NAME))  Q:NAME=""  D
 .. F  S VERSION=$O(WOTERR(MODULE,NAME,VERSION))  Q:VERSION=""  D
 ... S PATCH=$G(WOTERR(MODULE,NAME,VERSION))
 ... S STR(LINECNT)=$$CJ^XLFSTR(NAME_" ("_MODULE_")",65)
 ... S LINECNT=LINECNT+1
 ... S TMP="Version:"_VERSION
 ... I $G(PATCH)'="" S TMP=TMP_"  Patch:"_$G(PATCH)
 ... S STR(LINECNT)=$$CJ^XLFSTR(TMP,65)
 ... S LINECNT=LINECNT+1
 ... S STR(LINECNT)=" "
 ... S LINECNT=LINECNT+1
 S STR(LINECNT)=$$CJ^XLFSTR("Re-Installation will be necessary.",65)
 S LINECNT=LINECNT+1
 S STR(LINECNT)=" "
 S LINECNT=LINECNT+1
 S STR(LINECNT)=$$CJ^XLFSTR("If assistance is needed, please call 1-999-999-9999.",65)
 S LINECNT=LINECNT+1
 S STR(LINECNT)=" "
 S LINECNT=LINECNT+1
 S STR(LINECNT)=$TR($J("",65)," ","*")
 ;
 D BMES^XPDUTL(.STR)             ; Display the message
 ;
 Q
 ;
 ; Write out "OKAY" message
OKAY(MSG,TAB)       ;
 NEW MESSAGE
 I $G(TAB)="" S TAB=5
 S MESSAGE=$J("",TAB)_MSG_" OK."
 D MES^XPDUTL(MESSAGE)
 Q
 ;
 ;CHECK FOR LMI MAIL GROUP
CHECKLMI() ;
 NEW OKAY
 D BMES^XPDUTL("Must have 'LMI' mail group present.")
 S DIC="^XMB(3.8,"
 S X="LMI"
 D ^DIC
 S OKAY=+Y
 I OKAY>0 D OKAY("'LMI' mail group found.")
 I OKAY<1 D SORRY("'LMI' mail group NOT found!")
 Q OKAY
 ;
 ; POST-INSTALL
 ;      Just installs Menu items & changes size of RESULTS
 ;      field in V MICRO and UNIT ID in BLOOD INVENTORY files.
 ;
 ;      If anything goes wrong, it's NOT fatal -- just keep trucking.
POST ; EP
 NEW CP                      ; Current Patch
 S CP=$TR($P($T(+2),";",5),"*")
 ;
 D BMES^XPDUTL("Laboratory Patch "_CP_" POST INSTALL...")
 ;
 D ADDMENU
 ;
 D CHVMICRO
 ;
 D BMES^XPDUTL("Laboratory Patch "_CP_" POST INSTALL complete.")
 ;
 S XQAMSG="Laboratory Patch "_CP_" INSTALL complete."
 S XQA("G.LMI")=""
 D SETUP^XQALERT
 ;
 ; Store # of times instllation occurred as well as person & date/time
 NEW CP,INSTCNT                        ; Current Patch,Installation count
 S CP=$TR($P($T(+2),";",5),"*")
 S INSTCNT=1+$O(^BLRINSTL("LAB PATCH",CP,"INSTALLED BY",""),-1)
 S ^BLRINSTL("LAB PATCH",CP,"INSTALLED BY",INSTCNT)=$P($G(^VA(200,DUZ,0)),U)
 S ^BLRINSTL("LAB PATCH",CP,"INSTALLED BY",INSTCNT,"DATE/TIME")=$$HTE^XLFDT($H,"5Z")
 ;
 Q
 ;
 ; Add OPTION(s) to MENU(s)
ADDMENU ;
 ; Add option to purge HL7 error messages to BLRMENU
 D ADDTMENU("BLRMENU","BLRETPUR","ETP")
 ;
 ; If Lab E-SIG menu exists, add new item
 I $$LKOPT^XPDMENU("BLRA Lab E-SIG Menu") D ADDTMENU("BLRA Lab E-SIG Menu","BLRA LAB ES REPORTS","RPT")
 ;
 Q
 ;
 ; Procedure that really adds the options --
 ; uses Kernel'S ADD^XPDMENU function
ADDTMENU(ADDER,ADDEE,ITM)    ; EP
 NEW CHKIT
 ;
 D BMES^XPDUTL("Adding "_ADDEE_" to "_ADDER_".")
 ;
 S CHKIT=$$ADD^XPDMENU(ADDER,ADDEE,ITM)
 ;
 I CHKIT=1 D
 . D OKAY(ADDEE_" added to "_ADDER_".",5)
 . D MES^XPDUTL(" ")
 ;
 I CHKIT'=1 D SORRY("Error in adding "_ADDEE_" to "_ADDER_".","NONFATAL")
 ;
 Q
 ;
 ; Generic message output WITH blank line BEFORE messsage & TAB
TABMESG(MSG,TAB,TAIL) ;
 NEW MESSAGE
 I $G(TAB)="" S TAB=5
 S MESSAGE=$J("",TAB)_MSG
 I $G(TAIL)'="" S MESSAGE=MESSAGE_" "_TAIL
 D BMES^XPDUTL(MESSAGE)
 Q
 ;
 ; Generic message output WITHOUT blank line BEFORE messsage & TAB
TABMENU(MSG,TAB,TAIL) ;
 NEW MESSAGE
 I $G(TAB)="" S TAB=5
 S MESSAGE=$J("",TAB)_MSG
 I $G(TAIL)'="" S MESSAGE=MESSAGE_" "_TAIL
 D MES^XPDUTL(MESSAGE)
 Q
 ;
 ; Change Maximum string length for the RESULT field in the V MICRO
 ; file to 80 characters.  Permission granted by Lori Butcher.
CHVMICRO ;
 NEW SPEC,STR,SUBSTR
 NEW WOTDD
 ;
 S STR=$G(^DD(9000010.25,.07,0))
 S SUBSTR=$P(STR,"^",5)
 ;
 D TABMESG("Changing RESULT field max string length & HELP in V MICRO file to 80.")
 ;
 I +($P($P(STR,">",2),"!",1))>79 D  Q
 . D OKAY("RESULT field max string length in V MICRO file already > 79.")
 ;
 I +$L(SUBSTR)<1!($L($P(STR,">",2))<1) D  Q
 . D SORRY("RESULT field in V MICRO file damaged: examine with FileMan.","NONFATAL")
 ;
 S $P(STR,"^",5)="K:$L(X)>80!($L(X)<1) X"
 S WOTDD="^DD(9000010.25,.07,0)"
 S @WOTDD=STR
 ;
 I $P($P($G(^DD(9000010.25,.07,0)),">",2),"!",1)'=80  D
 . D SORRY("Could not change RESULT field max string length in V MICRO file","NONFATAL")
 ;
 D OKAY("Changed RESULT field max string length in V MICRO file.",10)
 ;
 S WOTDD="^DD(9000010.25,.07,3)"
 S STR="Answer must be 1-80 characters in length."
 S @WOTDD=STR
 ;
 I $G(^DD(9000010.25,.07,3))'[80  D  Q
 . D SORRY("Could not change RESULT field HELP in V MICRO file","NONFATAL")
 ;
 D OKAY("Changed RESULT field HELP in V MICRO file.",10)
 ;
 D OKAY("Changed RESULT field max string length & HELP in V MICRO file.")
 ;
 Q
