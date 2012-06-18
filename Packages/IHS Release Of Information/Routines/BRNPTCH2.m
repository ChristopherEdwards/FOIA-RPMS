BRNPTCH2 ; IHS/OIT/AR - BRN Patch 2 Environment/Post Install  ; [ 04/XX/2009  XX:YY XM ]
 ;;2.0;RELEASE OF INFO SYSTEM;**2**;APR 10, 2003
 ;
PRE ; EP
 NEW CP,RPMS,RPMSVER
 NEW STR
 NEW LASTPTCH                 ; Last Patch
 NEW LSTPISTS                 ; Last Patch Install Status
 NEW ERRARRAY                 ; Array of errors
 ;
 D BMES^XPDUTL("Beginning of Pre Check.")
 I $G(XPDNM)="" D SORRY("XPDNM not defined or 0.")  Q
 ;
 S CP=$P(XPDNM,"*",3)         ; This Patch Number
 S RPMS=$P(XPDNM,"*",1)       ; RPMS Module
 S RPMSVER=$P(XPDNM,"*",2)    ; Version of RPMS module being patched
 ;
PTCHLAST ; EP - Check for previous patch
 D MES^XPDUTL("     Need BRN*2.0*1 Patch Installed.")
 I $$PATCH^XPDUTL("BRN*2.0*1")'=1 D SORRY("BRN*2.0*1 Patch Not Installed.")  Q
 ;
 D OKAY("BRN*2.0*1 Patch Installed.",10)
 ;
 S XPDNOQUE="NO QUE"          ; No Queuing Allowed
 ;
 ; The following lines prevent the "Disable Options..." and "Move
 ; Routines..." questions from being asked during the install.
 I $G(XPDENV)=1 S (XPDDIQ("XPZ1"),XPDDIQ("XPZ2"))=0
 I $G(XPDENV)=1 S (XPDDIQ("XPZ1"),XPDDIQ("XPZ2"))=0
 F X="XPO1","XPZ1","XPZ2","XPI1" S XPDDIQ(X)=0
 ;
 S XPDABORT=0                    ; KIDS install Flag
 ;
USERID ; EP - CHECK FOR USER ID
 I '$G(DUZ) D SORRY("DUZ UNDEFINED OR 0.")  Q
 ;
 I '$L($G(DUZ(0))) D SORRY("DUZ(0) UNDEFINED OR NULL.")  Q
 ;
 D HOME^%ZIS
 D DTNOLF^DICRW          ; Set DT variable without Doing a Line Feed
 ;
 S X=$P($G(^VA(200,DUZ,0)),U)
 I $G(X) D SORRY("Installer cannot be identified!",,,CP) Q
 ;
 D MES^XPDUTL("Pre Check complete.")
 ;
LETSGO ; EP - USER IDENTIFIED -- LET'S GO
 D BMES^XPDUTL("Hello, "_$P(X,",",2)_" "_$P(X,","))
 ;
 D BMES^XPDUTL("Checking Environment for Patch "_CP_" of Version "_RPMSVER_" of "_RPMS_".")
 ;
 D NEEDIT("DI","22.0",,.ERRARRAY)        ; FILEMAN 22.0
 D NEEDIT("XM","8.0",,.ERRARRAY)         ; MAILMAN 8.0
 D NEEDIT("XU","8.0",,.ERRARRAY)         ; KERNEL 8.0
 D NEEDIT("XB","3.0",,.ERRARRAY)         ; IHS/VA Utilities
 ;
 I XPDABORT<1 D BMES^XPDUTL("Environment for Patch "_CP_" of Version "_RPMSVER_" of "_RPMS_" OK.")
 I XPDABORT>0 D SORRYEND(.ERRARRAY)      ; ENVIRONMENT HAS ERROR(S)
 D BMES^XPDUTL(" ")
 Q
 ;
 ; Generic "Find RPMS Module's Version and (perhaps) Patch number"
 ; The MODULE variable MUST be the PREFIX name from the PACKAGE file (9.4).
NEEDIT(MODULE,VERSION,PATCH,ERRARRAY)      ; EP
 NEW NAME                ; Name of PACKAGE
 NEW HEREYAGO,STR1,STR2  ; Scratch variables/arrays
 NEW SYSVER,SYSPATCH     ; System Version & System Patch variables
 ;
 D FIND^DIC(9.4,"","","",MODULE,"","C","","","HEREYAGO")
 S NAME=$G(HEREYAGO("DILIST",1,1))
 ;
 D BMES^XPDUTL("Need at least "_NAME_" "_VERSION)
 ;
 S SYSVER=$$VERSION^XPDUTL(MODULE)     ; Get the System's Version
 ; If System Version < Needed Version, write message and quit
 I SYSVER<VERSION D  Q
 . S ERRARRAY(MODULE,NAME,VERSION)=""
 . D NEEDMSG("Need "_NAME_" "_VERSION_" & "_NAME_" "_SYSVER_" found!")
 ;
 D OKAY(NAME_" "_SYSVER_" found.")
 I VERSION<SYSVER Q     ; If Version needed is lower, skip Patch check
 ;
 I $G(PATCH)="" Q   ; If no Patch check, just exit
 ;
 D BMES^XPDUTL("     Need "_NAME_" "_VERSION_" Patch "_PATCH_".")
 S SYSPATCH=$$PATCH^XPDUTL(MODULE_"*"_VERSION_"*"_PATCH)
 I SYSPATCH'=1 D  Q
 . S ERRARRAY(MODULE,NAME,VERSION)=$G(PATCH)
 . D NEEDMSG(NAME_" "_VERSION_" & Patch "_PATCH_" WAS NOT installed!")
 ;
 D OKAY(NAME_" "_VERSION_" Patch "_PATCH_" found.",10)
 ;
 Q
  ;
NEEDMSG(MESSAGE) ; EP
 NEW STR1,STR2
 ;
 S STR1=MESSAGE
 I $L(STR1)<58 D SORRY(STR1,,,CP)  Q
 ;
 S STR1=$P(MESSAGE,"&")_" &"
 S STR2=$$TRIM^XLFSTR($P(MESSAGE,"&",2),"L"," ")
 D SORRY(STR1,,STR2,CP)
 Q
 ;
POST ; EP
 D BMES^XPDUTL("POST INSTALL Begins.")
 ;
 D BMES^XPDUTL("     Deleting FOIA Option from BRN MENU RPT")
 S OK=$$DELETE^XPDMENU("BRN MENU RPT","BRN FOIA REPORTING")
 S STR=$J("",10)_"FOIA Option "_$S(OK=1:"WAS",1:"WAS NOT")
 S STR=STR_" Deleted from ROI Reports Menu"
 S STR=STR_$S(OK=1:". OK",1:".")
 D MES^XPDUTL(STR)
 D BMES^XPDUTL("POST INSTALL Complete.")
 Q
 ;
DEBUG ; EP - Debugging
 NEW CP,DEBUG,XPDNM
 S DEBUG="YES"
 S XPDNM="BRN*2.0*2"
 S CP=$P($T(+2),"*",3)        ; This Patch
 D PRE
 Q
 ;
SORRY(MSG,MODE,MSG2)       ; EP -- Error Message routine.
 NEW LINECNT,STR,MESSAGE,WHATMSG
 ; The STR array is built so that the error/warning message will
 ; also appear on the INSTALL LOG via the D BMES^XPDUTL(.STR) call.
 ;
 I $G(MODE)="FATAL" D
 . S MESSAGE="Install Aborting due to the following Systems Environment issue:"
 . S XPDABORT=1     ; Fatal Error Flag Set
 ;
 I $G(MODE)="NONFATAL" S MESSAGE="*** WARNING *** WARNING *** WARNING ***"
 ;
 K DIFQ
 ;
 S LINECNT=1
 D ADDLINE($TR($J("",65)," ","*"),.LINECNT)    ; Row of asterisks
 D ADDLINE(" ",.LINECNT)
 ;
 D ADDLINE($$CJ^XLFSTR("Site: "_$$LOC^XBFUNC,65),.LINECNT)
 D ADDLINE(" ",.LINECNT)
 ;
 D ADDLINE($$CJ^XLFSTR(MESSAGE,65),.LINECNT)
 D ADDLINE(" ",.LINECNT)
 ;
 D ADDLINE($$CJ^XLFSTR(">>> "_MSG_" <<<",65),.LINECNT)
 I $D(MSG2) D ADDLINE($$CJ^XLFSTR(">>> "_MSG2_" <<<",65),.LINECNT)
 D ADDLINE(" ",.LINECNT)
 ;
 I $G(MODE)["NONFATAL" D ADDLINE($$CJ^XLFSTR(MESSAGE,65),.LINECNT)
 ;
 I $G(MODE)='"FATAL" D
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
 S WHATMSG=RPMS_" Patch "_CP_" Install "
 S WHATMSG=WHATMSG_$S(MODE="NONFATAL":MODE,MODE="FATAL":">>FATAL<<",1:"<UNK>")
 S WHATMSG=WHATMSG_" Error."
  ;
 D SNDALERT(WHATMSG)
 D SENDMAIL(WHATMSG)
 Q
 ;
ADDLINE(ASTR,LC) ; EP -- Add a line to the STR array
 I $G(ASTR)="" S ASTR=" "
 S STR(LC)=ASTR
 S LC=LC+1
 Q
 ;
SNDALERT(ALERTMSG) ; EP -- Send alert to installer
 NEW XQA,XQAARCH,XQACNDEL,XQADATA,XQAFLG,XQAGUID
 NEW XQAID,XQAMSG,XQAOPT,XQAREVUE,XQAROU,XQASUPV
 NEW XQASURO,XQATEXT,OK,NAME
 ;
 S XQAMSG=ALERTMSG
 S XQA(DUZ)=""
 D SETUP^XQALERT
 Q
 ;
SENDMAIL(MAILMSG) ; EP -- E-mail to Installer; message in STR array
 NEW CP,RPMS,XMDUZ,XMSUB,XMTEXT,XMY
 ;
 S CP=$P($T(+2),"*",3)
 S RPMS=$P($T(+2),"*",4)
 ;
 S XMY(DUZ)=""
 S XMSUB=MAILMSG
 S XMTEXT="STR("
 S XMDUZ=RPMS_" Patch "_CP
 ;
 D ^XMD    ; Send the MailMan e-mail
 Q
 ;
OKAY(MSG,TAB)       ; EP  -- Write out "OKAY" message
 I $G(TAB)="" S TAB=5
 D MES^XPDUTL($J("",TAB)_MSG_" OK.")
 Q
 ;
SORRYEND(WOTERR) ; EP -- Final Error Message
 NEW STR,MODULE,NAME,VERSION,PATCH,LINECNT,TMP
 ;
 ; Output a listing of ALL the errors detected during
 ; the environment check.  The STR array will be
 ; displayed by the BMES^XPDUTL call.
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
SORRYHED ; EP  -- "Header" of Final Fatal Message
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
ADDMESG ; EP -- Add to the STR array
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
SORRYFIN ; EP -- "Fin" of Final Fatal Message
 D ADDLINE($$CJ^XLFSTR("Re-Installation will be necessary.",65),.LINECNT)
 D ADDLINE(" ",.LINECNT)
 D ADDLINE($$CJ^XLFSTR("If assistance is needed, please call 1-999-999-9999.",65),.LINECNT)
 D ADDLINE(" ",.LINECNT)
 D ADDLINE($TR($J("",65)," ","*"),.LINECNT)
 D ADDLINE(" ",.LINECNT)
 Q
 ;
RESET ; EP -- For debugging only
 NEW OK
 ;
 D BMES^XPDUTL("Adding FOIA Option Back to BRN MENU RPT.")
 S OK=$$ADD^XPDMENU("BRN MENU RPT","BRN FOIA REPORTING","FOIA",)
 S STR=$J("",5)_"FOIA Option "_$S(OK=1:"WAS",1:"WAS NOT")
 S STR=STR_" Added Back to ROI Reports Menu"
 S STR=STR_$S(OK=1:". OK",1:".")
 D MES^XPDUTL(STR)
 D MES^XPDUTL("Adding FOIA Option Back to BRN MENU RPT Complete.")
 D BMES^XPDUTL(" ")
 Q
