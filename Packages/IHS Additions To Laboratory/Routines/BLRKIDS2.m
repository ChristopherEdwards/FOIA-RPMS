BLRKIDS2 ; IHS/OIT/MKK - IHS Lab KIDS utilities, part 2 ; 27-Apr-2015 06:30 ; MKK
 ;;5.2;LR;**1035**;Nov 1, 1997;Build 5
 ;
EEP ; EP - Ersatz EP
 D EEP^BLRGMENU
 Q
 ;
 ;
BOKAY(MSG,TAB)       ; EP -- Write out Blank line, then "OKAY" message
 ;    MSG = Message String
 ;    TAB = Indent Amount
 ;
 D BMES^XPDUTL($J("",+$G(TAB))_MSG_" OK.")
 Q
 ;
 ;
ENVHEADR(CP,RPMSVER,RPMS) ; EP -- Environment Header
 ;       CP = Patch Number to be installed
 ;  RPMSVER = RPMS Version of Module (e.g.: for Lab, it's 5.2)
 ;     RPMS = RPMS Module (i.e., LA, LR, etc.)
 ;
 NEW STARS,STR,TIMESTR
 S STARS=$TR($J("",IOM)," ","*")
 ;
 S STR="@Checking@Environment@for@Patch@"
 S STR=STR_CP_"@of@Version@"
 S STR=STR_RPMSVER_"@of@"
 S STR=STR_$TR(RPMS," ","@")_".@"
 ;
 S TIMESTR=$TR($$CJ^XLFSTR("At "_$$UP^XLFSTR($$HTE^XLFDT($H,"5MPZ")),$L(STR))," ","@")
 ;
 D ^XBCLS
 W STARS,!
 W $TR($$CJ^XLFSTR(STR,IOM)," @","* "),!
 W $TR($$CJ^XLFSTR(TIMESTR,IOM)," @","* "),!
 W STARS,!
 Q
 ;
ENVIVARS(CP,BLRVERN) ; EP - Setup the Environment variables
 ;       CP = Patch Number to be installed
 ;  BLRVERN = Current Routine Name
 ;
 S TODAY=$$DT^XLFDT
 S WOTCNT=$$WOTCNT(BLRVERN)
 S ROWSTARS=$TR($J("",65)," ","*")     ; Row of asterisks
 ;
 S ^XTMP(BLRVERN,0)=$$HTFM^XLFDT(+$H+90)_"^"_$$DT^XLFDT_"^IHS Lab Patch "_CPSTR
 M ^XTMP(BLRVERN,TODAY,WOTCNT,"DUZ")=DUZ
 S ^XTMP(BLRVERN,TODAY,WOTCNT,"BEGIN")=$$NOW^XLFDT
 ;
 S XUMF=1
 ;
 I $G(XPDNM)="" D SORRY(CP,"XPDNM not defined or 0.")  Q "Q"
 ;
 S RPMS=$P(XPDNM,"*",1)      ; RPMS Module
 S RPMSVER=$P(XPDNM,"*",2)   ; RPMS Version
 ;
 I +$G(DUZ)<1 D SORRY(CP,"DUZ UNDEFINED OR 0.")  Q "Q"
 I $$GET1^DIQ(200,DUZ,"NAME")="" D SORRY(CP,"Installer cannot be identified!")  Q "Q"
 ;
 S XPDNOQUE=1        ; No Queuing Allowed
 ;
 ; The following line prevents the "Disable Options..." and "Move
 ; Routines..." questions from being asked during the install.
 F X="XPO1","XPZ1","XPZ2","XPI1" S XPDDIQ(X)=0,XPDDIQ(X,"B")="NO"
 ;
 S XPDABORT=0        ; KIDS install Flag
 ;
 D HOME^%ZIS         ; Reset/Initialize IO variables
 D DTNOLF^DICRW      ; Set DT variable without a Line Feed
 ;
 Q "OK"
 ;
 ;
BLANK ; EP - Blank Line using XPDUTL
 D MES^XPDUTL(" ")
 Q
 ;
NLBLANK ; EP - Newline, then Blank Line using XPDUTL
 D BMES^XPDUTL(" ")
 Q
 ;
TABLINE(LINE,TAB) ; EP - Use XPDUTL to display line, tabbed over TAB spaces.  Default 5 spaces.
 S TAB=$G(TAB,5)
 D MES^XPDUTL($J("",TAB)_LINE)
 Q
 ;
NTABLINE(LINE,TAB) ; EP - Newline, then use XPDUTL to display line, tabbed over TAB spaces.  Default 5 spaces.
 S TAB=$G(TAB,5)
 D BMES^XPDUTL($J("",TAB)_LINE)
 Q
 ;
MESCNTR(STR) ; EP - Center a line and use XPDUTL to display it
 D MES^XPDUTL($$CJ^XLFSTR(STR,IOM))
 Q
 ;
NMESCNTR(STR) ; EP - Newline, then Center a line and use XPDUTL to display it
 D MES^XPDUTL($$CJ^XLFSTR(STR,IOM))
 Q
 ;
 ;
WOTCNT(BLRVERN) ; EP - Counter for ^XTMP
 ;     BLRVERN = Current Routine Name
 ;
 NEW CNT,TODAY
 ;
 S TODAY=$$DT^XLFDT
 ;
 S CNT=1+$G(^XTMP(BLRVERN,0,TODAY))
 S ^XTMP(BLRVERN,0,TODAY)=CNT
 Q $TR($J(CNT,3)," ","0")
 ;
 ;
NOSNAPS(QUIET) ; EP - Make certain TAKE SNAPSHOTS field in BLR MASTER CONTROL file is OFF
 ;      QUIET = Boolean.  If YES (1), then do NOT print any information.
 ;                        If NO (0), then do print information.
 NEW CNT,DESC,FDA,IEN
 ;
 S (CNT,IEN)=0
 F  S IEN=$O(^BLRSITE(IEN))  Q:IEN<1  D
 . Q:+$$GET1^DIQ(9009029,IEN,"TAKE SNAPSHOTS","I")<1
 . ;
 . S CNT=CNT+1,CNT(IEN)=""
 . K FDA
 . S FDA(9009029,IEN_",",1)=0
 . D FILE^DIE(,"FDA","ERRS")
 ;
 Q:CNT<1   ; If no update, just return
 Q:+$G(QUIET)      ; If QUIET is true, just return
 ;
 D BMES^XPDUTL("File 9009029 'TAKE SNAPSHOTS' Field Set to OFF for the following:")
 S IEN=0
 F  S IEN=$O(CNT(IEN))  Q:IEN<1  D TABMENU^BLRKIDSU($$GET1^DIQ(9009029,IEN,.01),5)
 D BMES^XPDUTL
 Q
 ;
 ; Generic "Find RPMS Module's Version and (perhaps) Patch number"
 ; The MODULE variable MUST be the PREFIX name from the PACKAGE file (9.4).
NEEDIT(CP,MODULE,VERSION,PATCH,ERRARRAY)      ; EP
 ;           CP = Patch Number to be installed
 ;       MODULE = RPMS Module (i.e., LA, LR, etc.)
 ;      VERSION = RPMS Version of Module (e.g.: for Lab, it's 5.2)
 ;        PATCH = Patch Number to Check
 ;     ERRARRAY = Error Array.  Pass by Reference.
 ;
 NEW NAME                    ; NAME of PACKAGE
 NEW PTR                     ; PoinTeR to PACKAGE file
 NEW HEREYAGO,STR1,STR2      ; Scratch variables/arrays
 NEW SYSVER,SYSPATCH         ; System Version & System Patch variables
 NEW NAMEVER,NAMESYS
 ;
 D FIND^DIC(9.4,"",,,MODULE,,"C",,,"HEREYAGO")
 S PTR=$G(HEREYAGO("DILIST",2,1))
 S NAME=$G(HEREYAGO("DILIST",1,1))
 ;
 S SYSVER=+$$VERSION^XPDUTL(MODULE)    ; Get Current Version #
 ;
 S NAMEVER=NAME_" "_VERSION,NAMESYS=NAME_" "_SYSVER
 ;
 ; If Current Version < Needed Version, write message and quit
 I SYSVER<VERSION D  Q
 . S ERRARRAY(MODULE,NAME,VERSION)=SYSVER_"^VERSION"
 . D:SYSVER>0 NEEDMSG("Need "_NAMEVER_" & "_NAMESYS_" found!")
 . D:SYSVER<1 NEEDMSG("Need "_MODULE_" & "_MODULE_" Not Installed!")
 ;
 ; If System Version > Needed Version, write message and quit
 I VERSION<SYSVER D OKAY^BLRKIDSU("Need "_NAMEVER_" & "_NAMESYS_" found.",5)  Q
 ;
 I $G(PATCH)="" D  Q   ; If no Patch check, write message and quit
 . D OKAY^BLRKIDSU(NAMEVER_" found.",5)
 ;
 S SYSPATCH=$$PATCH^XPDUTL(MODULE_"*"_VERSION_"*"_PATCH)
 I SYSPATCH'=1 D  Q
 . S ERRARRAY(MODULE,NAME,VERSION)=$G(PATCH)_"^PATCH"
 . D NEEDMSG(NAMEVER_" ("_MODULE_") & Patch "_PATCH_" WAS NOT installed!")
 ;
 D OKAY^BLRKIDSU(NAMEVER_" Patch "_PATCH_" found.",5)
 ;
 Q
 ;
PASSMESG(WOT) ; EP -- Splash message
 ;       WOT = String to display    
 ;
 NEW CRTLINE,MAXIT,AROUND
 ;
 F CRTLINE=1:1:20 W $J("",80),!
 D EN^XBVIDEO("HOM")
 S MAXIT="@"
 F J=1:1:$L(WOT) S MAXIT=MAXIT_$E(WOT,J,J)_"@"
 S AROUND=$TR($J("",8+$L(MAXIT))," ","@")
 S MAXIT="@@!!"_$TR(MAXIT," ","@")_"!!@@"
 ;
 W !!
 W $TR($J("",IOM)," ","*"),!
 W $TR($J("",IOM)," ","*"),!
 W $TR($$CJ^XLFSTR(AROUND,IOM)," @","* "),!
 W $TR($$CJ^XLFSTR(MAXIT,IOM)," @","* "),!
 W $TR($$CJ^XLFSTR(AROUND,IOM)," @","* "),!
 W $TR($J("",IOM)," ","*"),!
 W $TR($J("",IOM)," ","*"),!
 Q
 ;
NEEDMSG(MESSAGE) ; EP
 ;      MESSAGE = String to display    
 ;
 NEW STR1,STR2
 ;
 S STR1=MESSAGE
 I $L(STR1)<58 D SORRY(CP,STR1)  Q
 ;
 S STR1=$P(MESSAGE,"&")_" &"
 S STR2=$$TRIM^XLFSTR($P(MESSAGE,"&",2),"L"," ")
 D SORRY(CP,STR1,,STR2)
 Q
 ;
 ; Error Message routine.
SORRY(CP,MSG,MODE,MSG2)    ; EP
 ;       CP = Patch Number to be installed
 ;      MSG = String to display
 ;     MODE = Type of message.  FATAL or WARNING.
 ;     MSG2 = Additional Line of Message. (If Needed.)
 ;
 NEW MESSAGE,ROWSTARS
 ;
 S ROWSTARS=$TR($J("",65)," ","*")     ; Row of asterisks
 ;
 S MODE=$G(MODE,"FATAL")
 ;
 I $G(MODE)="FATAL" D
 . S MESSAGE="Install Aborting due to the following Systems Environment issue:"
 . S XPDABORT=1    ; Fatal Error Flag Set
 ;
 I $G(MODE)["NONFATAL" S MESSAGE="*** WARNING *** WARNING *** WARNING ***"
 ;
 K DIFQ
 ;
 ; STR Array will be used to write to the screen, send E-Mail & Alert
 NEW STR,LINECNT,MODESTR
 S LINECNT=1
 D ADDLINE(.LINECNT)
 D ADDLINE(.LINECNT,ROWSTARS)
 D ADDLINE(.LINECNT)
 D ADDLINE(.LINECNT,"Site: "_$$LOC^XBFUNC,"YES")
 D ADDLINE(.LINECNT)
 D ADDLINE(.LINECNT,MESSAGE,"YES")
 D ADDLINE(.LINECNT)
 D BANNERL(.LINECNT,MSG)
 D:$D(MSG2) BANNERL(.LINECNT,MSG2)
 D ADDLINE(.LINECNT)
 ;
 I $G(MODE)["NONFATAL" D ADDLINE(.LINECNT,MESSAGE,"YES")
 ;
 I $G(MODE)="FATAL" D
 . D ADDLINE(.LINECNT,"Please print/capture this screen and","YES")
 . D ADDLINE(.LINECNT,"notify the Support Center at","YES")
 . D ADDLINE(.LINECNT)
 . D ADDLINE(.LINECNT,"1-888-830-7280.","YES")
 . D ADDLINE(.LINECNT)
  ;
 D ADDLINE(.LINECNT,ROWSTARS)
 D ADDLINE(.LINECNT)
 ;
 D BMES^XPDUTL(.STR)
 ;
 I $G(DEBUG)="YES" Q
 ;
 D MAILALMI^BLRUTIL3("IHS Lab Patch "_CP_" Install "_MODE_" Error",.STR,"Laboratory Patch "_CP)
 Q
 ;
ADDLINE(LC,ASTR,CENTER) ; EP -- Add a line to the STR array; CENTER if requested
 ;      LC = Line Counter.  Pass by Reference.
 ;    ASTR = String to Add to STR array
 ;  CENTER = Boolean.  If YES, then Center ASTR, else don't.
 ; 
 I $G(ASTR)="" S ASTR=" "
 S STR(LC)=$S($G(CENTER)="YES":$$CJ^XLFSTR(ASTR,65),1:$G(ASTR))
 S LC=LC+1
 Q
 ;
BANNERL(LC,ASTR) ; EP -- Stores "Banner" Line in STR array
 ;      LC = Line Counter.  Pass by Reference.
 ;    ASTR = String to Add to STR array
 ;
 S STR(LC)=$$MKBANNRL(ASTR)
 S LC=LC+1
 Q
 ;
MKBANNRL(ASTR) ; EP - MaKe the BANNeR Line
 ;       ASTR = String to Manipulate
 ;
 NEW HALFLEN,J,RM,STRLEN,TMPSTR
 ;
 S RM=65      ; Right Margin
 ;
 S HALFLEN=(RM\2)-(($L(ASTR)+2)\2)
 S TMPSTR=$TR($J("",HALFLEN)," ",">")
 S TMPSTR=TMPSTR_" "_ASTR_" "
 S STRLEN=$L(TMPSTR)
 F J=STRLEN:1:(RM-1) S TMPSTR=TMPSTR_"<"
 Q TMPSTR
 ;
SORRYEND(WOTERR,CP) ; EP -- ALL the errors detected during the environment check.
 ;       WOTERR = Error Array.  Pass by Reference.
 ;           CP = Patch Number to be installed
 ;
 NEW STR,MODULE,NAME,VERSION,PATCH,LINECNT,TMP
 ;
 D SORRYHED
 ;
 S (MODULE,NAME,VERSION)=""
 F  S MODULE=$O(WOTERR(MODULE))  Q:MODULE=""  D
 . F  S NAME=$O(WOTERR(MODULE,NAME))  Q:NAME=""  D
 .. F  S VERSION=$O(WOTERR(MODULE,NAME,VERSION))  Q:VERSION=""  D ADDMESG
 ;
 D SORRYFIN
 ;
 D BMES^XPDUTL(.STR)
 ;
 Q
 ;
SORRYHED ; EP -- "Header" of Final Fatal Message
 S LINECNT=1
 D ADDLINE(.LINECNT)
 D ADDLINE(.LINECNT,ROWSTARS)
 D ADDLINE(.LINECNT)
 D ADDLINE(.LINECNT,"Systems Environment Error Detected","YES")
 D ADDLINE(.LINECNT,"KIDS build will be deleted","YES")
 D ADDLINE(.LINECNT)
 D ADDLINE(.LINECNT,"Modules with Version or Patch errors","YES")
 D ADDLINE(.LINECNT)
 Q
 ;
ADDMESG ; EP
 NEW WOT,WOTWRONG
 ;
 D ADDLINE(.LINECNT,NAME_" ("_MODULE_")","YES")
 ;
 S WOT=$G(WOTERR(MODULE,NAME,VERSION))
 S TMP="Version:"_VERSION
 S WOTWRONG=$P(WOT,"^",2)
 ;
 I WOTWRONG="VERSION" D
 . S TMP="Needed Version:"_VERSION
 . S TMP=TMP_"  Found Version:"_$P(WOT,"^")
 ;
 I WOTWRONG="PATCH" D
 . S TMP=TMP_"  Needed Patch:"_$P(WOT,"^")
 ;
 I WOTWRONG'="PATCH"&(WOTWRONG'="VERSION") D
 . D ADDLINE(.LINECNT,TMP,"YES")
 . S TMP=WOT
 ;
 D ADDLINE(.LINECNT,TMP,"YES")
 D ADDLINE(.LINECNT)
 Q
 ;
SORRYFIN ; EP -- "Fin" of Final Fatal Message
 D ADDLINE(.LINECNT,"Re-Installation will be necessary.","YES")
 D ADDLINE(.LINECNT)
 D ADDLINE(.LINECNT,"If assistance is needed, please call","YES")
 D ADDLINE(.LINECNT,"1-888-830-7280.","YES")
 D ADDLINE(.LINECNT)
 D ADDLINE(.LINECNT,ROWSTARS)
 D ADDLINE(.LINECNT)
 Q
 ;
 ;
DEBUG(PATCH,ROUTINE) ; EP - Debug Environment/Backup/Post Install sections of ROUTINE
 NEW (DILOCKTM,DISYS,DT,DTIME,DUZ,IO,IOBS,IOF,IOM,ION,IOS,IOSL,IOST,IOT,IOXY,PATCH,ROUTINE,U,XPARSYS,XQXFLG)
 ;
 ; ROUTINE **MUST** have the following line Labels:
 ;     ENVICHEK - Environment Checking Section
 ;       BACKUP - Backup Section
 ;         POST - Post Install Section
 ;
 S (CP,PATCHNUM)=$P(PATCH,"*",3)
 S CPSTR=PATCH
 S BLRVERN=ROUTINE
 S DEBUG=1      ; ROUTINE must handle DEBUG = 1
 S XPDNM=PATCH
 S XPDENV=0
 S ROWPLUS=$TR($J("",IOM)," ","+")
 ;
 D ^XBCLS,PASSMESG^BLRKIDS2("DEBUG: ENVCHK Check")
 ;
 D @("ENVICHEK^"_ROUTINE)
 ;
 W !!,"DEBUG: ENVCHK^",ROUTINE," Completed."
 W !!,ROWPLUS
 D PRESSKEY^BLRGMENU
 ;
 D ^XBCLS,PASSMESG^BLRKIDS2("DEBUG: BACKUP Check.")
 D @("BACKUP^"_ROUTINE)
 W !!,"DEBUG: BACKUP^",ROUTINE," Completed."
 W !!,ROWPLUS
 D PRESSKEY^BLRGMENU
 ;
 D ^XBCLS,PASSMESG^BLRKIDS2("DEBUG: POST Check")
 D @("POST^"_ROUTINE)
 W !!,"DEBUG: POST^",ROUTINE," Completed."
 W !!,ROWPLUS
 D PRESSKEY^BLRGMENU
 ;
 D ^XBCLS,PASSMESG^BLRKIDS2("DEBUG: COMPLETED")
 D PRESSKEY^BLRGMENU
 Q
 ;
ADDOPTS(TOMENU,OPTION,SYNONYM,TAB) ; EP - Add new OPTION to TOMENU with SYNONYM synonym
 Q:$$DEONARDY(TOMENU,OPTION,SYNONYM)
 ;
 ; Add it
 S TAB=$J(" ",$G(TAB,5))
 S X="Adding '"_OPTION_"' option"
 S:$D(SYNONYM) X=X_" with "_SYNONYM_" synonym"
 S X=X_" to "_TOMENU_"."
 D BMES^XPDUTL(X)
 S X=$$ADD^XPDMENU(TOMENU,OPTION,SYNONYM)
 D:X=1 BMES^XPDUTL(TAB_"'"_OPTION_"' added to "_TOMENU_". OK.")
 I X'=1 D
 . D BMES^XPDUTL(TAB_"Error in adding '"_OPTION_"' option to "_TOMENU_".")
 . D MES^XPDUTL(TAB_TAB_"Error Message: "_$$UP^XLFSTR($P(X,"^",2)))
 ;
 D MES^XPDUTL("")
 Q
 ;
DEONARDY(TOMENU,OPTION,SYNONYM) ; EP - Checks Options
 ; Returns 1 if TOMENU doesn't exist OR
 ;           if OPTION doesn't exist OR
 ;           if OPTION already on TOMENU with SYNONYM
 ;
 NEW OPTIEN,SYNIEN,TOIEN
 S TOIEN=$$LKOPT^XPDMENU(TOMENU)
 Q:TOIEN<1 1       ; Return 1 if TOMENU doesn't exist
 S OPTIEN=$$LKOPT^XPDMENU(OPTION)
 Q:OPTIEN<1 1      ; Return 1 if OPTION doesn't exist
 S SYNIEN=+$O(^DIC(19,TOIEN,10,"C",$G(SYNONYM),0))
 Q $S($G(^DIC(19,TOIEN,10,SYNIEN,0))=OPTIEN:1,1:0)
 ;
 ;
INACTOPT(SEED,OUTMSG,EXCPTION) ; EP - Inactivate/Activate options.
 ; If the OUTMSG variable is NOT NULL, then the the OUT^XPDMENU routine
 ; will put the string into the OUT OF ORDER MESSAGE field of the options.
 ;
 ; If the OUTMSG variable is NULL, then the OUT^XPDMENU routine will 
 ; remove any text from the OUT OF ORDER field of the options.
 ;
 NEW OPTION,SEEDLEN
 ;
 S OPTION=SEED,SEEDLEN=$L(SEED)
 F  S OPTION=$O(^DIC(19,"B",OPTION))  Q:OPTION=""!($E(OPTION,1,SEEDLEN)'=SEED)  D
 . Q:OPTION=$G(EXCPTION)     ; Exception: Do not modify this option.
 . Q:$D(EXCPTION(OPTION))    ; If EXCPTION is an array, Do not modify if option is in the array. 
 . ;
 . D OUT^XPDMENU(OPTION,$G(OUTMSG))
 Q
