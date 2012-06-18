BLRPRE25 ; IHS/OIT/MKK - IHS Lab PATCH 1025 Environment/Post Install Routine ;DEC 09, 2008 8:30 AM
 ;;5.2;IHS LABORATORY;**1025**;NOV 01, 1997
 ;
PRECHK ; EP
 D BMES^XPDUTL("Beginning of Pre Check.")
 NEW CP,LINE2,RPMS,RPMSVER
 NEW STR                      ; String -- used as an array for messages.
 NEW LASTPTCH                 ; Last Patch of Lab
 NEW LSTPISTS                 ; Last Patch Install Status
 NEW WOTERR                   ; Array of errors detected
 ;
 S LINE2=$T(+2)               ; Second line of THIS Routine
 ;
 I $G(XPDNM)="" D SORRY("XPDNM not defined or 0.",,,1025)  Q
 ;
 S CP=$P(XPDNM,"*",3)         ; Current Patch Number
 S RPMS=$P(XPDNM,"*",1)       ; RPMS Module
 S RPMSVER=$P(XPDNM,"*",2)    ; Version of RPMS module being patched
 ;
PTCHLAST ; EP - Check for previous patch
 D MES^XPDUTL("     Need LR*5.2*1024 Patch Installed.")
 I $$PATCH^XPDUTL("LR*5.2*1024")'=1 D SORRY("LR*5.2*1024 Patch Not Installed.",,,1025)  Q
 ;
 D OKAY^BLRKIDSU("LR*5.2*1024 Patch Installed.",10)
 ; I $$LASTPTCH(1024)'="OK" Q   ; Abort if Lab Patch 1024 NOT Installed
 ;
 S XPDNOQUE="NO QUE"          ; No Queuing Allowed
 ;
 ; The following line prevents the "Disable Options..." and "Move
 ; Routines..." questions from being asked during the install.
 I $G(XPDENV)=1 S (XPDDIQ("XPZ1"),XPDDIQ("XPZ2"))=0
 I $G(XPDENV)=1 S (XPDDIQ("XPZ1"),XPDDIQ("XPZ2"))=0
 F X="XPO1","XPZ1","XPZ2","XPI1" S XPDDIQ(X)=0
 ;
 S XPDABORT=0                    ; KIDS install Flag
 ;
USERID ; EP - CHECK FOR USER ID
 I '$G(DUZ) D SORRY("DUZ UNDEFINED OR 0.",,,CP)  Q
 ;
 I '$L($G(DUZ(0))) D SORRY("DUZ(0) UNDEFINED OR NULL.",,,CP)  Q
 ;
 D HOME^%ZIS             ; IO Defaults
 D DTNOLF^DICRW          ; Set DT variable without Doing a Line Feed
 ;
 S X=$P($G(^VA(200,DUZ,0)),U)
 I $G(X) D SORRY^BLRKIDSU("Installer cannot be identified!",,,CP) Q
 ;
 D MES^XPDUTL("Pre Check complete.")
 ; D MES^XPDUTL(" ")
 ;
LETSGO ; EP - USER IDENTIFIED -- LET'S GO
 D BMES^XPDUTL("Hello, "_$P(X,",",2)_" "_$P(X,","))
 ;
 D BMES^XPDUTL("Checking Environment for Patch "_CP_" of Version "_RPMSVER_" of "_RPMS_".")
 ;
 D NEEDIT("DI","22.0",,.WOTERR,CP)      ; CHECK FOR FILEMAN 22.0
 ;
 D NEEDIT("XU","8.0",1013,.WOTERR,CP)   ; CHECK FOR KERNEL 8.0 & PATCH 1013
 ;
 D CHECKLMI(.WOTERR,CP)                 ; CHECK FOR LMI MAIL GROUP
 ;
 D NEEDIT("XM","7.1",1005,.WOTERR,CP)   ; CHECK FOR MAILMAN 7.1
 ;
 I XPDABORT<1 D BMES^XPDUTL("ENVIRONMENT OK.")    ; ENVIRONMENT OK
 ;
 I XPDABORT>0 D SORRYEND^BLRKIDSU(.WOTERR,CP)     ; ENVIRONMENT HAS ERROR(S)
 ;
 Q
 ;
BACKUP ; EP
 NEW CP                       ; Current Patch
 S CP=$TR($P($T(+2),";",5),"*")
 ;
 D BACKUPS^BLRKIDSU(CP)
 Q
 ;
POST ; EP -- POST INSTALL
 NEW CP                       ; Current Patch
 S CP=$TR($P($T(+2),";",5),"*")
 ;
 D MODBLRM                    ; Modify BLRMENU option(s)
 ;
 D ADDDELTA                   ; Add 4 new Delta Checks
 ;
 D BBMOD                      ; Blood Bank Modification
 ;
 ; I $$EXIST^%R("BEHOLPCI.INT")  D
 ; . D POSTINIT^BEHOLPCI        ; EHR Point-of-Care Initialization
 ;
 D BMES^XPDUTL("Laboratory Patch "_CP_" INSTALL complete.")
 ;
 ; Store # of times installation occurred as well as person & date/time
 D ENDINSTL^BLRKIDSU(CP)
 ;
 ; Complete Message
 S XQAMSG="Laboratory Patch "_CP_" INSTALL complete."
 S XQA("G.LMI")=""
 D SETUP^XQALERT
 ;
 Q
 ;
BBMOD ; Blood Bank Module Modification -- Change the length of the UNIT ID field.
 NEW MAXSTR,OKAY,SPEC,STR,SUBSTR
 NEW WOTDD
 ;
 D TABMESG^BLRKIDSU("Changing UNIT ID & HELP field max length in BLOOD PRODUCT file.",5)
 S MAXSTR=30
 S OKAY=0
 ;
 S STR=$G(^DD(65,.01,0))
 S SUBSTR=$P($P($P($P(STR,"^",5),">",2),")",1),"!",1)
 ;
 I +SUBSTR'<MAXSTR D  Q
 . D OKAY^BLRKIDSU("UNIT ID field max length already CHANGED.",10)
 ;
 I +$L(SUBSTR)<1!($L($P(STR,">",2))<1) D  Q
 . D SORRY("UNIT ID field in BLOOD PRODUCT file damaged: examine with FileMan.","NONFATAL")
 ;
 S SPEC(SUBSTR)=MAXSTR
 S STR=$$REPLACE^XLFSTR(STR,.SPEC)
 S WOTDD="^DD(65,.01,0)"
 S @WOTDD=STR
 ;
 S SUBSTR=$P($P($P($P($G(^DD(65,.01,0)),"^",5),">",2),")",1),"!",1)
 ;
 I +SUBSTR'<MAXSTR D
 . D OKAY^BLRKIDSU("UNIT ID field max length in BLOOD PRODUCT file changed.",10)
 . S OKAY=OKAY+1
 ;
 I +SUBSTR<MAXSTR D
 . D TABMESG^BLRKIDSU("UNIT ID field max length in BLOOD PRODUCT file NOT changed.",10)
 ;
 S STR=$G(^DD(65,.01,3))
 S SUBSTR=$P($P(STR,"-",2)," ",1)
 ;
 I +SUBSTR'<MAXSTR D  Q
 . D OKAY^BLRKIDSU("UNIT ID field HELP String in BLOOD PRODUCT file already >="_MAXSTR_".",10)
 ;
 S SPEC(SUBSTR)=MAXSTR
 S STR=$$REPLACE^XLFSTR(STR,.SPEC)
 S WOTDD="^DD(65,.01,3)"
 S @WOTDD=STR
 ;
 S SUBSTR=$P($P($G(^DD(65,.01,3)),"-",2)," ",1)
 ;
 I +SUBSTR'<MAXSTR D
 . D OKAY^BLRKIDSU("UNIT ID field HELP String in BLOOD PRODUCT file Changed.",10)
 . S OKAY=OKAY+1
 ;
 I +SUBSTR<MAXSTR D  Q
 . D TABMESG^BLRKIDSU("UNIT ID field HELP String in BLOOD PRODUCT file NOT changed.",10)
 ;
 D OKAY^BLRKIDSU("Changed UNIT ID & HELP field max length in BLOOD PRODUCT file.")
 Q
 ;
DEBUG ; EP - Debugging Line Label for environment checker
 NEW CP,DEBUG,LINE2,XPDNM
 S DEBUG="YES"
 S XPDNM="LR*5.2*1025"
 D PRECHK
 Q
 ;
MODBLRM ; EP
 ; Add Lab Version/Patch report option to the BLRMENU
 D ADDTMENU^BLRKIDSU("BLRMENU","BLRVPTCH","LVP",,CP)
 ;
 ; Add "Busy Device" Report option to BLRMENU
 D ADDTMENU^BLRKIDSU("BLRMENU","BLRPCCBD","BZY",,CP)
 ;
 ; Add Lab Description File Abbreviation Report to BLRMENU
 D ADDTMENU^BLRKIDSU("BLRMENU","BLRLDFAR","MMR",,CP)
 ;
 Q
 ;
ADDDELTA ; EP
 NEW DESC,DESC1STR,DESC2STR,NAME,OVER1,OVER1STR,XCODE,XCODESTR
 ; Add 4 new Delta Checks to the Delta Check dictionary.
 ; This is to accomodate the Estimated GFR calculations required by
 ; the National Kidney Foundation: 
 ;      www.nkdep.nih.gov/resources/laboratory_reporting.htm
 ;
 S DESC1STR="This delta check, when added to a test named CREATININE (NKDF), will calculate an"
 S DESC2STR="estimated Glomerular Filtration Rate (GFR) using the standard MDRD Study"
 S XCODESTR="S %X="""" X:$D(LRDEL(1)) LRDEL(1) W:$G(%X)'="""" ""  Calculated GFR:"",%X S:LRVRM>10 LRSB($$GETDNAM^BLREXEC2(""EST GFR""))=%X K %,%X,%Y,%Z,%ZZ"
 S OVER1STR="S %ZZ=$$GETDNAM^BLREXEC2(""CREATININE (NKDF)"") X:LRVRM>10 ""F %=%ZZ S %X(%)=$S(%=LRSB:X,$D(LRSB(%)):+LRSB(%),1:0)"" X:LRVRM>10 ""F %=%ZZ S %X(%)=$S($D(LRSB(%)):LRSB(%),1:0)"""
 ;
 S NAME="GFRSE1CU"
 S XCODE=XCODESTR
 S OVER1=OVER1STR_" S %X=$$GFRSE1CU^BLREXEC2(X)"
 S DESC(1)=DESC1STR
 S DESC(2)=DESC2STR
 S DESC(3)="Equation 1 with conventional Units and stuff the result into the test called"
 S DESC(4)="EST GFR"
 D DLTADICA(NAME,XCODE,OVER1,.DESC)
 ;
 S NAME="GFRSE1SI"
 S XCODE=XCODESTR
 S OVER1=OVER1STR_" S %X=$$GFRSE1SI^BLREXEC2(X)"
 K DESC(3),DESC(4)
 S DESC(3)="Equation 1 with SI Units and stuff the result into the test called EST GFR"
 D DLTADICA(NAME,XCODE,OVER1,.DESC)
 ;
 S NAME="GFRSE2CU"
 S XCODE=XCODESTR
 S OVER1=OVER1STR_" S %X=$$GFRSE2CU^BLREXEC2(X)"
 K DESC(3),DESC(4)
 S DESC(3)="Equation 2 with conventional Units and stuff the result into the test called"
 S DESC(4)="EST GFR"
 D DLTADICA(NAME,XCODE,OVER1,.DESC)
 ;
 S NAME="GFRSE2SI"
 S XCODE=XCODESTR
 S OVER1=OVER1STR_" S %X=$$GFRSE2SI^BLREXEC2(X)"
 K DESC(3),DESC(4)
 S DESC(3)="Equation 2 with SI Units and stuff the result into the test called EST GFR"
 D DLTADICA(NAME,XCODE,OVER1,.DESC)
 ;
 Q
 ;
DLTADICA(NAME,XCODE,OVER1,DESC) ; EP
 NEW DICT0,DICT1,FDA,ERRS,PTR
 NEW HEREYAGO
 ;
 D BMES^XPDUTL("Adding "_NAME_" to Delta Check Dictionary")
 ;
 D ^XBFMK
 K ERRS,FDA,IENS,DIE
 ; 
 S DICT1="62.1"
 S FDA(DICT1,"?+1,",.01)=NAME   ; Find the Name node, or create it.
 S FDA(DICT1,"?+1,",10)=XCODE   ; Execute Code
 S FDA(DICT1,"?+1,",20)=OVER1   ; Overflow 1
 D UPDATE^DIE("S","FDA",,"ERRS")
 ;
 I $D(ERRS("DIERR"))>0 D  Q
 . D SORRY^BLRKIDSU("Error in adding "_NAME_" to the Delta Check Dictionary.","NONFATAL",,CP)
 ;
 D OKAY^BLRKIDSU(NAME_" Delta Check added to Delta Check Dictionary.",5)
 ;
 ; Now, add the Description
 K ERRS
 D FIND^DIC(62.1,"","","",NAME,"","","","","HEREYAGO") ; Get Pointer
 S PTR=$G(HEREYAGO("DILIST",2,1))
 M WPARRAY("WP")=DESC
 D WP^DIE(62.1,PTR_",",30,"K","WPARRAY(""WP"")","ERRS")
 ;
 I $D(ERRS("DIERR"))>0 D  Q
 . D SORRY^BLRKIDSU("Error in adding DESCRIPTION to "_NAME_" Delta Check in the Delta Check Dictionary.","NONFATAL",,CP)
 ;
 D OKAY^BLRKIDSU(NAME_" Delta Check DESCRIPTION added to Delta Check Dictionary.",5)
 ;
 ; Now, add the SITE NOTES DATE
 K ERRS,FDA
 S FDA(62.131,"?+1,"_PTR_",",.01)=$P($$NOW^XLFDT,".",1)
 D UPDATE^DIE("S","FDA",,"ERRS")
 ;
 I $D(ERRS("DIERR"))>0 D  Q
 . D SORRY^BLRKIDSU("Error in adding SITES NOTES DATE to "_NAME_" Delta Check in the Delta Check Dictionary.","NONFATAL",,CP)
 ;
 ; Now, add the TEXT
 K ERRS,WPARRAY
 S WPARRAY("WP",1)="Created by IHS Lab Patch 1025"
 D WP^DIE(62.131,"1,"_PTR_",",1,"K","WPARRAY(""WP"")","ERRS")
 ;
 I $D(ERRS("DIERR"))>0 D  Q
 . D SORRY^BLRKIDSU("Error in adding TEXT to "_NAME_" Delta Check in the Delta Check Dictionary.","NONFATAL",,CP)
 ;
 D OKAY^BLRKIDSU(NAME_" Delta Check TEXT added to Delta Check Dictionary.",5)
 Q
 ;
LASTPTCH(CP) ; EP
 NEW COMPFLAG,COMPPTCH,LASTPTCH,LRPATCH,LPIEN,STR
 ;
 S LASTPTCH=CP-1
 ;
 D BMES^XPDUTL("Need at least IHS Lab Patch "_LASTPTCH)
 ;
 S LRPATCH="LR*5.2*1099",COMPFLAG="NO"
 F  S LRPATCH=$O(^XPD(9.7,"B",LRPATCH),-1)  D  Q:LRPATCH=""!(COMPFLAG="YES")!($E(LRPATCH,1,2)'="LR")!($P(LRPATCH,"*",3)<LASTPTCH)
 . S LPIEN=$O(^XPD(9.7,"B",LRPATCH,""),-1)
 . I $P($G(^XPD(9.7,+$G(LPIEN),0)),"^",9)=3 S COMPFLAG="YES",COMPPTCH=LRPATCH
 ;
 I COMPFLAG'="YES"!($P(COMPPTCH,"*",3)<LASTPTCH)  D  Q "NOT OK"
 . D SORRY("Need at least IHS Lab Patch "_LASTPTCH,,"Latest IHS Lab Patch Found is "_COMPPTCH_".",CP)
 ;
 D OKAY^BLRKIDSU("IHS Lab Patch "_LASTPTCH_" Installed.",10)
 ;
 Q "OK"
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
 D ADDLINE(" ",.LINECNT)
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
 ; If no DUZ, it's impossible to send e-mail & alert, so just quit
 I '$G(DUZ)!('$L($G(DUZ(0)))) Q
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
SNDALERT(ALERTMSG) ; EP  -Send alert to LMI group
 S XQAMSG=ALERTMSG
 S XQA("G.LMI")=""
 D SETUP^XQALERT
 K XQA,XQAMSG
 Q
 ;
SENDMAIL(MAILMSG) ; EP - Send MailMan E-mail to LMI group
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
 D ^XMD                       ; Send the MailMan e-mail
 K X,XMDUZ,XMSUB,XMTEXT,Y     ; Cleanup
 Q
 ;
ADDLINE(ASTR,LC) ; EP
 ; Add a line to the STR array
 I $G(ASTR)="" S ASTR=" "
 S STR(LC)=ASTR
 S LC=LC+1
 Q
 ;
CHECKLMI(WOTERR,CP) ; EP  -CHECK FOR LMI MAIL GROUP
 NEW OKAY
 D BMES^XPDUTL("Must have 'LMI' mail group present.")
 S DIC="^XMB(3.8,"
 S X="LMI"
 D ^DIC
 S OKAY=+Y
 I OKAY>0 D OKAY^BLRKIDSU("'LMI' mail group found.")
 I OKAY<1 D
 . D SORRY^BLRKIDSU("'LMI' mail group NOT found!",,,CP)
 . S WOTERR("XMB(3.8","Mail Group","3.8")="LMI Mail Group"
 Q
 ;
NEEDIT(MODULE,VERSION,PATCH,WOTERR,CP)      ; EP
 ; Generic "Find RPMS Module's Version and (perhaps) Patch number"
 ;      NOTE: The MODULE variable MUST be the PREFIX name
 ;            from the PACKAGE file (9.4).
 NEW NAME                ; NAME of RPMS Module
 NEW PTR                 ; PoinTeR to PACKAGE file
 NEW HEREYAGO            ; Array to store returned values from FIND^DIC
 NEW STR1,STR2           ; Temporary Strings
 NEW SYSVER,SYSPATCH     ; System Version & System Patch variables
 ;
 ; Use FileMan API to get information
 D FIND^DIC(9.4,"","","",MODULE,"","C","","","HEREYAGO")
 S PTR=$G(HEREYAGO("DILIST",2,1))
 S NAME=$G(HEREYAGO("DILIST",1,1))
 ;
 D BMES^XPDUTL("Need at least "_NAME_" "_VERSION)
 ;
 S SYSVER=$$VERSION^XPDUTL(MODULE)     ; Get the System's Version
 ; If System Version < Needed Version, write message and quit
 I SYSVER<VERSION D  Q
 . S WOTERR(MODULE,NAME,VERSION)=""
 . S STR1="Need "_NAME_" "_VERSION_" & "_NAME_" "_SYSVER_" found!"
 . I $L(STR1)<58 D SORRY^BLRKIDSU(STR1,,,CP)
 . I $L(STR1)>57 D
 .. S STR1="Need "_NAME_" "_VERSION_" & "
 .. S STR2=NAME_" "_SYSVER_" found!"
 .. D SORRY^BLRKIDSU(STR1,,STR2,CP)
 ;
 D OKAY^BLRKIDSU(NAME_" "_SYSVER_" found.")
 I VERSION<SYSVER Q     ; If Version needed is lower, skip Patch check
 ;
 I $G(PATCH)="" Q   ; If no Patch check, just exit
 ;
 D BMES^XPDUTL("     Need "_NAME_" "_VERSION_" Patch "_PATCH_".")
 S SYSPATCH=$$PATCH^XPDUTL(MODULE_"*"_VERSION_"*"_PATCH)
 I SYSPATCH'=1 D  Q
 . S WOTERR(MODULE,NAME,VERSION)=$G(PATCH)
 . S STR1=NAME_" "_VERSION_" Patch "_PATCH_" WAS NOT installed!"
 . I $L(STR1)<58 D SORRY^BLRKIDSU(STR1,,,CP)
 . I $L(STR1)>57 D
 .. S STR1=NAME_" "_VERSION
 .. S STR2="Patch "_PATCH_" WAS NOT installed!"
 .. D SORRY^BLRKIDSU(STR1,,STR2,CP)
 ;
 D OKAY^BLRKIDSU(NAME_" "_VERSION_" Patch "_PATCH_" found.",10)
 ;
 Q
