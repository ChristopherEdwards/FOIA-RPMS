BLRPRE33 ; IHS/MSC/MKK - IHS Lab Patch Pre/Post/Environment Routine ; 22-Oct-2013 09:22 ; MKK
 ;;5.2;IHS LABORATORY;**1033**;NOV 01, 1997
 ;
ENVICHEK ; Environment Checker
 NEW CP,PREREQ,RPMS,RPMSVER,QFLG,ROWSTARS,STR,TODAY,WOTCNT
 NEW ERRARRAY                 ; Errors array
 NEW BLRVERN,BEGTIME,ENDTIME,PATCHNUM,WHATCNT
 ;
 S PATCHNUM=$TR($P($T(+2),";",5),"*")
 S BLRVERN=$TR($P($T(+1),";")," ")
 S TODAY=$$DT^XLFDT
 S WOTCNT=$$WOTCNT()
 ;
 S ^XTMP(BLRVERN,0)=$$HTFM^XLFDT(+$H+90)_"^IHS Lab Patch "_PATCHNUM_"^"_$$DT^XLFDT
 M ^XTMP(BLRVERN,TODAY,WOTCNT,"DUZ")=DUZ
 S ^XTMP(BLRVERN,TODAY,WOTCNT,"BEGIN")=$$NOW^XLFDT
 ;
 S XUMF=1
 ;
 I $G(XPDNM)="" D  Q
 . S CP=$TR($P($T(+2),";",5),"*")
 . D SORRY^BLRPRE31(CP,"XPDNM not defined or 0.")
 ;
 S CP=$P(XPDNM,"*",3)        ; Patch Number
 S RPMS=$P(XPDNM,"*",1)      ; RPMS Module
 S RPMSVER=$P(XPDNM,"*",2)   ; RPMS Version
 ;
 S ROWSTARS=$TR($J("",65)," ","*")     ; Row of asterisks
 ;
USERID ; EP - CHECK FOR USER ID
 I +$G(DUZ)<1 D SORRY^BLRPRE31(CP,"DUZ UNDEFINED OR 0.")  Q
 ;
 I $L($$GET1^DIQ(200,DUZ,"NAME"))<1 D SORRY^BLRPRE31(CP,"Installer cannot be identified!")  Q
 ;
GETREADY ; EP
 S XPDNOQUE=1           ; No Queuing Allowed
 ;
 ; The following line prevents the "Disable Options..." and "Move
 ; Routines..." questions from being asked during the install.
 F X="XPO1","XPZ1","XPZ2","XPI1" S XPDDIQ(X)=0,XPDDIQ(X,"B")="NO"
 ;
 S XPDABORT=0           ; KIDS install Flag
 ;
 D HOME^%ZIS            ; Reset/Initialize IO variables
 D DTNOLF^DICRW         ; Set DT variable without a Line Feed
 ;
 D ENVHEADR^BLRPRE31(CP,RPMSVER,RPMS)
 ;
 D MES^XPDUTL
 ;
 D CHKLABMG                                        ; Check Lab Mail Groups
 ;
 D NEEDIT^BLRPRE31(CP,"BSTS","1.0",,.ERRARRY)      ; IHS Standard Terminology Pre-Requisite
 D NEEDIT^BLRPRE31(CP,"BJPC","2.0",10,.ERRARRAY)   ; PCC Pre-Requisite
 D NEEDIT^BLRPRE31(CP,"LR","5.2",1032,.ERRARRAY)   ; Lab Pre-Requisite
 D NEEDIT^BLRPRE31(CP,"XU","8.0",1017,.ERRARRAY)   ; Kernel Pre-Requisite
 ;
 D MES^XPDUTL
 ;
 I XPDABORT>0 D SORRYEND(.ERRARRAY,CP)   Q   ; ENVIRONMENT HAS ERROR(S)
 ;
 D BOKAY^BLRPRE31("ENVIRONMENT")
 ;
 S XUMF=1
 ;
 Q
 ;
WOTCNT() ; EP - Counter for ^XTMP
 NEW BLRVERN,CNT,TODAY
 ;
 S BLRVERN=$TR($P($T(+1),";")," ")
 S TODAY=$$DT^XLFDT
 ;
 S CNT=1+$G(^XTMP(BLRVERN,0,TODAY))
 S ^XTMP(BLRVERN,0,TODAY)=CNT
 Q $TR($J(CNT,3)," ","0")
 ;
CHKLABMG ; EP - Check Lab Mail Groups
 NEW FNAME,LNAME,USERNAME
 ;
 S USERNAME=$$UP^XLFSTR($$GET1^DIQ(200,DUZ,"NAME")),LNAME=$P(USERNAME,","),FNAME=$P(USERNAME,",",2)
 ;
 Q:LNAME["WALKER"&((FNAME["MIKE")!(FNAME["MICHAEL"))
 ;
 D CHKMAILG(CP,"LMI",.ERRARRAY)              ; Check for LMI Mail Group
 D CHKMAILG(CP,"LAB MESSAGING",.ERRARRAY)    ; Check for LAB MESSAGING Mail Group
 D CHKMAILG(CP,"BLRLINK",.ERRARRAY)          ; Check for BLRLINK Mail Group
 Q
 ;
 ; Determine if required Mail Group Exists AND the Mail Group has at least
 ; one member who has logged onto RPMS in the past year
CHKMAILG(CP,MAILGRP,ERRARRAY)   ; EP
 NEW MEM,MEMBER,MGRPIEN,MEMOKAY,VALIDMBR
 ;
 D CHKGROUP^XMBGRP(MAILGRP,.MGRPIEN)   ; VA DBIA 1146
 ;
 I +$G(MGRPIEN)<1 D  Q
 . D SORRY^BLRPRE31(CP,MAILGRP_" Mail Group Does NOT Exist!")
 . S ERRARRAY("XMB","Mail Group","3.8")=MAILGRP_" Mail Group Does NOT Exist!"
 ;
 D OKAY^BLRKIDSU(MAILGRP_" Mail Group Exists.")
 ;
 I $$VALIDMBR(MGRPIEN) D OKAY^BLRKIDSU(MAILGRP_" Mail Group Has a Valid Member.",10)  Q
 ;
 D SORRY^BLRPRE31(CP,"The "_MAILGRP_" Mail Group Exists but no Member of","FATAL",MAILGRP_" has logged onto RPMS within the past year!")
 S ERRARRAY("XMB","Mail Group","3.8")=MAILGRP_" Mail Group Exists, but Does NOT have a Valid Member"
 Q
 ;
VALIDMBR(MGRPIEN) ; EP - Determine if Mail Group has at least one valid member
 S MEM=.9999999,VALIDMBR=0
 ;
 F  S MEM=$O(^XMB(3.8,MGRPIEN,1,MEM))  Q:MEM<1!(VALIDMBR)  D
 . S MEMBER=+$$GET1^DIQ(3.81,MEM_","_MGRPIEN_",","MEMBER","I")
 . Q:+$$GET1^DIQ(200,MEMBER,"DISUSER")                ; If DISUSERed, not a Valid Member
 . Q:+$$GET1^DIQ(200,MEMBER,"TERMINATION DATE","I")   ; If Terminated, not a Valid Member
 . S LASTLOGI=$$GET1^DIQ(200,MEMBER,202,"I")          ; Last Login Date
 . Q:$$FMDIFF^XLFDT($$NOW^XLFDT,LASTLOGI)>364         ; If Last Login > 364 days ago, not a Valid Member
 . ;
 . S VALIDMBR=MEMBER      ; None of the above true, so valid member
 ;
 Q VALIDMBR
 ;
DEBUG ; EP - Debugging Line Label for environment checker
 NEW CP,DEBUG,RPMS,RPMSVER,QFLG,STR
 W !!
 W "Debug Begins:",$$TRIM^XLFSTR($P($T(+1),";"),"LR"," "),!!
 ;
 ; Note -- DEBUG is a negative flag:
 ;         YES="Don't Send Alerts"; NO="Send Alerts"
 ;
 S DEBUG="YES"     ; At this time, DO NOT send alerts
 ;
 ; D ^XBFMK
 ; S DIR(0)="YO"
 ; S DIR("B")="NO"
 ; S DIR("A")="Send Alerts/E-Mails"
 ; D ^DIR
 ; S:+$G(Y)=1 DEBUG="NO"
 ;
 W !
 S XPDNM="LR*5.2*"_$P($T(+2),"*",3)
 S XPDENV=0
 ;
 D ENVICHEK
 D PRESSKEY^BLRGMENU(4)
 ;
 Q:XPDABORT
 ;
 D PRE
 W !!!
 ;
 D ^XBFMK
 S DIR(0)="YO"
 S DIR("B")="NO"
 S DIR("A")="Test Post Install Code"
 D ^DIR
 ;
 D EXIT^XPDID
 ;
 I +$G(Y)=1 D
 . F MENUOPT="LRLIAISON","LR IHS LIAISON" S X=$$ADD^XPDMENU(MENUOPT,"LRLOINC")
 . D POST
 W !!!
 ;
 ; Delete DEBUG Backup confirmation
 ; K ^BLRINSTL("LAB PATCH",$P(XPDNM,"*",3))
 ;
 W !!,"Debug Ends:",$$TRIM^XLFSTR($P($T(+1),";"),"LR"," ")
 Q
 ;
PRE ; EP -- Ask for confirmation of Backup
 NEW BLRVERN,CNT,CP,CRTLINE,DIRASTR,FDAROOT,IEN,IENS,MSGROOT
 NEW BCKUPCNT                   ; Current Patch,Backup count
 ;
 S CP=$TR($P($T(+2),";",5),"*")
 S BLRVERN=$TR($P($T(+1),";")," ")
 ;
 S XUMF=1
 ;
 D INIT^XPDID
 D TITLE^XPDID("LR*5.2*1033")
 W !!
 D BMES^XPDUTL("Pre-Install of "_BLRVERN_" Begins.")
 ;
 D PASSMESG^BLRPRE31("ATTENTION")
 W !
 ;
 D ^XBFMK
 S DIR(0)="Y"
 S DIR("B")="NO"
 S:$G(IOST)["C-VT" DIRASTR=$J("",10)_"Has a "_$C(27)_"[1;7;5m"_">> SUCCESSFUL <<"_$C(27)_"[0m"_" backup been performed?"
 S:$G(IOST)'["C-VT" DIRASTR=$J("",10)_"Has a >> SUCCESSFUL << backup been performed?"
 S DIR("A")=DIRASTR
 D ^DIR
 W !
 ;
 I +$G(Y)'=1 D  Q    ; If BACKUP not performed, then ABORT installation.
 . S XPDABORT=1
 . D PASSMESG^BLRPRE31("ATTENTION")
 . D BMES^XPDUTL($J("",15)_"SUCCESSFUL system backup has >>> NOT <<< been confirmed.")
 . D BMES^XPDUTL($J("",25)_"Installer: "_$$GET1^DIQ(200,DUZ,"NAME")_" ["_DUZ_"].")
 . D BMES^XPDUTL($J("",15)_"Install Aborting.")
 ;
 ; Store backup confirmation person & date/time
 S BCKUPCNT=1+$O(^BLRINSTL("LAB PATCH",CP,"BACKUP CONFIRMED BY",""),-1)
 S ^BLRINSTL("LAB PATCH",CP,"BACKUP CONFIRMED BY",BCKUPCNT)=DUZ_"^"_$P($G(^VA(200,DUZ,0)),U)
 S ^BLRINSTL("LAB PATCH",CP,"BACKUP CONFIRMED BY",BCKUPCNT,"DATE/TIME")=$$HTE^XLFDT($H,"5MZ")
 ;
 D BOKAY^BLRPRE31("SUCCESSFUL system backup CONFIRMED by: "_$$GET1^DIQ(200,DUZ,"NAME")_".",5)
 H 1     ; Pause 1 second to let the user see the message.
 ;
 D INIT^XPDID
 D TITLE^XPDID("LR*5.2*1033")
 W !!
 D BMES^XPDUTL("Pre-Install of "_BLRVERN_" Continues.")
 ;
 D FILESDEL
 ;
 D COPYPROT
 ;
 D BMES^XPDUTL($J("",5)_"Pre-Install Processing Ends at "_$$UP^XLFSTR($$HTE^XLFDT($H,"5MPZ"))_".")
 H 1     ; Pause 1 second to let the user see the message.
 ;
 Q
 ;
FILESDEL ; EP - The following deletions are necessatry in order to prevent errors during installation
 NEW CNT,FILENUM,IEN
 ;
 S XUMF=1          ; Supposedly allows updating "locked down" dictionaries.  Doesn't appear to work.
 ;
 D DISABLE^%NOJRN            ; Disable Journaling prior to deletions
 ;
 ; Delete Files' entries
 ;      95.3   = LOINC
 ;      95.31  = LAB LOINC COMPONENT
 ;      64.061 = LAB ELECTRONIC CODES
 ;      64.2   = WKLD SUFFIX CODES
 F FILENUM=95.3,95.31,64.061,64.2  D
 . S IEN=.9999999,CNT=0
 . W !,?4,FILENUM
 . F  S IEN=$O(^LAB(FILENUM,IEN))  Q:IEN<1  D
 .. I CNT#100=0  W "."  W:$X>75 !,?4
 .. S CNT=CNT+1
 .. D ^XBFMK
 .. S DIK="^LAB("_FILENUM_",",DA=IEN
 .. Q:$G(DEBUG)="YES"        ; If DEBUG set, don't delete anything
 .. D ^DIK
 ;
 W !
 ;
 D ENABLE^%NOJRN             ; Restore Journaling
 ;
 Q
 ;
COPYPROT ; EP - Have to copy the entries for LR7O ALL EVSEND RESULTS Protocol
 NEW ERRS,FOUND,IEN,PATCHNUM
 D FIND^DIC(101,,,,"LR7O ALL EVSEND RESULTS",,,,,"FOUND","ERRS")
 Q:$D(ERRS)
 ;
 S IEN=+$G(FOUND("DILIST",2,1))
 Q:IEN<1
 ;
 S PATCHNUM=$TR($P($T(+2),";",5),"*")
 ;
 S ^XTMP("LR7O ALL EVSEND RESULTS",0)=$$HTFM^XLFDT(+$H+90)_"^"_$$DT^XLFDT_"^LR*5.2*"_PATCHNUM_" PRE-INSTALL SAVE"
 M ^XTMP("LR7O ALL EVSEND RESULTS",IEN)=^ORD(101,IEN)
 Q
 ;
POST ; EP -- POST INSTALL
 NEW BLRVERN,CHKIT,CP,ERRS,FDA,IEN,MENUOPT,NEWOPT,NEWOPTM,PATCHNUM,STR,TAB,TODAY,WOTCNT
 ;
 S CP=$P($T(+2),"*",3)  ; Current Patch
 ;
 S PATCHNUM=$TR($P($T(+2),";",5),"*")
 S BLRVERN=$TR($P($T(+1),";")," ")
 S TODAY=$$DT^XLFDT
 S WOTCNT=$$WOTCNT()
 ;
 D BMES^XPDUTL("LR*5.2*"_CP_" Post Install")
 D MES^XPDUTL(" ")
 ;
 ; Get rid of LOINC option on LRLIAISON & LR IHS LIAISON menus since it's deactivated
 F MENUOPT="LRLIAISON","LR IHS LIAISON"  D
 . Q:$$DELETE^XPDMENU(MENUOPT,"LRLOINC")<1
 . ;
 . ; Deletion successful. Give feedback
 . D OKAY^BLRKIDSU("Obsolete VA LOINC option removed from "_MENUOPT_" menu.",0)
 . D MES^XPDUTL(" ")
 ;
 S TAB=$J("",5)
 ;
 D ADDOPTS    ; Add new options to BLRMENU
 D ADDHLOPT   ; Add new option to BLRREFLABMENU
 D TURNOFF    ; LA7HDR entry in file 62.48 must be set to INACTIVE
 D NEWKEYON   ; Add new BLRZZ Security Key to BLRREFLABMENU option
 D NEWKEYLA   ; Add LRSUPER Security Key to LA MI VERIFY AUTO option
 D NOSNAPS    ; Make sure TAKE SNAPSHOTS field in BLR MASTER CONTROL is OFF
 D GLUCACHE   ; Make sure GLUCOMETER is in the Terminolgoy Server Cache
 ;
 ; Run MAILMAN version of BLRLTRRR routine if DEBUG not YES
 D:$G(DEBUG)'="YES" EMAIL^BLRLTRRR
 ;
 ; Setup Instance of new parameter.  Initially its value is NO.
 D EN^XPAR("PKG","BLR CC DATA",,"NO",.ERRS)
 D:+$G(ERRS)=0 MES^XPDUTL("Parameter 'BLR CC DATA' Instance set to NO.")
 ;
 D ENDINSTL^BLRPRE31(CP)
 ;
 D BMES^XPDUTL(" ")
 ;
 D BMES^XPDUTL("Laboratory Patch "_CP_" INSTALL complete.")
 ;
 I $G(DEBUG)="YES" S ^XTMP(BLRVERN,TODAY,WOTCNT,"END")=$$NOW^XLFDT  Q
 ;
 S STR(1)=" "
 S STR(2)=$J("",10)_"POST INSTALL of "_BLRVERN_" Routine."
 S STR(3)=" "
 S STR(4)=$J("",15)_"Laboratory Patch "_CP_" INSTALL completed."
 S STR(5)=" "
 ;
 ; Send E-Mail to LMI Mail Group & Installer
 D MAILALMI^BLRUTIL3("Laboratory Patch "_CP_" INSTALL complete.",.STR,$TR($P($T(+1),";")," "))
 ;
 S ^XTMP(BLRVERN,TODAY,WOTCNT,"END")=$$NOW^XLFDT
 Q
 ;
ADDOPTS ; EP - Add new options to the BLRMENU
 F MENUOPT="BLR ADD COMPLETED DATE^DADD","BLR LAB TESTS REF RANGES^LTRR","BLR 62.49 HL7 SEGMENTS^6249","BLR LRAS MICRO REPORT^LRAS","BLR MU2 MICRO REPORT^IHSM","BLRSCRNTASKS^LABT"  D
 . S NEWOPT=$P(MENUOPT,"^")
 . S NEWOPTM=$P(MENUOPT,"^",2)
 . D BMES^XPDUTL("Adding '"_NEWOPT_"' option to BLRMENU.")
 . S X=$$ADD^XPDMENU("BLRMENU",NEWOPT,NEWOPTM)
 . D:X=1 MES^XPDUTL(TAB_"'"_NEWOPT_"' added to BLRMENU. OK.")
 . I X'=1 D
 .. D MES^XPDUTL(TAB_"Error in adding '"_NEWOPT_"' option to BLRMENU.")
 .. D MES^XPDUTL(TAB_TAB_"Error Message: "_$$UP^XLFSTR($P(X,"^",2)))
 ;
 D MES^XPDUTL(" ")
 Q
 ;
ADDHLOPT ; EP - Add new option to the BLRREFLABMENU
 F MENUOPT="BLR REFLAB HL7 TABLE LOOKUP^TBLL","BLR REFLAB MONITOR PARAMS^MON"  D
 . S NEWOPT=$P(MENUOPT,"^")
 . S NEWOPTM=$P(MENUOPT,"^",2)
 . D BMES^XPDUTL("Adding '"_NEWOPT_"' option to BLRREFLABMENU.")
 . S X=$$ADD^XPDMENU("BLRREFLABMENU",NEWOPT,NEWOPTM)
 . D:X=1 MES^XPDUTL(TAB_"'"_NEWOPT_"' added to BLRREFLABMENU. OK.")
 . I X'=1 D
 .. D MES^XPDUTL(TAB_"Error in adding '"_NEWOPT_"' option to BLRMENU.")
 .. D MES^XPDUTL(TAB_TAB_"Error Message: "_$$UP^XLFSTR($P(X,"^",2)))
 ;
 D MES^XPDUTL(" ")
 Q
 ;
TURNOFF ; EP - LA7HDR entry in file 62.48 must be set to INACTIVE
 NEW ERRS,FDA,IEN
 ;
 S IEN=+$$FIND1^DIC(62.48,,,"LA7HDR")
 Q:IEN<1      ; Skip if LA7HDR parameter does not exist
 ;
 D BMES^XPDUTL("Inactivating 'LA7HDR' parameter in 62.48.")
 ;
 D ^XBFMK
 K FDA
 S FDA(62.48,IEN_",",2)=0         ; Setting STATUS field to INACTIVE
 D FILE^DIE("KS","FDA","ERRS")
 ;
 I $D(ERRS)<1 D  Q
 . D OKAY^BLRKIDSU("'LA7HDR' parameter in 62.48 Inactivated.",5)
 . D MES^XPDUTL(" ")
 ;
 D NOTOKAY("'LA7HDR' parameter in 62.48 *NOT* Inactivated.",5)
 D SNDALERT^BLRUTIL3("'LA7HDR' parameter in 62.48 *NOT* Inactivated.")
 ;
 Q
 ;
NEWKEYON ; EP - Make sure new BLRRLZ Security Key is added to BLRREFLABMENU option
 NEW ERRS,FDA,IEN
 S IEN=+$$LKOPT^XPDMENU("BLRREFLABMENU")
 Q:IEN<1    ; Skip if cannot find Ref Lab Menu option
 ;
 D ^XBFMK
 S FDA(19,IEN_",",3)="BLRRLZ"
 D FILE^DIE(,"FDA","ERRS")
 Q
 ;
NEWKEYLA ; EP - Add LRSUPER Security Key to LA MI VERIFY AUTO option
 NEW ERRS,FDA,IEN
 S IEN=+$$LKOPT^XPDMENU("LA MI VERIFY AUTO")
 Q:IEN<1    ; Skip if cannot find Ref Lab Menu option
 ;
 D ^XBFMK
 S FDA(19,IEN_",",3)="LRSUPER"
 D FILE^DIE(,"FDA","ERRS")
 Q
 ;
NOSNAPS ; EP - Make certain TAKE SNAPSHOTS field in BLR MASTER CONTROL file is OFF
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
 ;
 D BMES^XPDUTL("File 9009029 'TAKE SNAPSHOTS' Field Set to OFF for the following:")
 S IEN=0
 F  S IEN=$O(CNT(IEN))  Q:IEN<1  D TABMENU^BLRKIDSU($$GET1^DIQ(9009029,IEN,.01),5)
 D BMES^XPDUTL
 Q
 ;
NOTOKAY(MSG,TAB)       ; EP -- Write out Blank line, then "NOT OKAY" message
 D BMES^XPDUTL($J("",+$G(TAB))_MSG_" NOT OK.")
 Q
 ;
GLUCACHE ; EP - Make sure IHS Terminology Server has GLUCOMETER in its cache
 NEW IN,OUT,VARS
 S OUT="VARS",IN="GLUCOMETER^F^^ALL"
 S X=$$SEARCH^BSTSAPI(OUT,IN)
 Q
 ;
SORRYEND(WOTERR,CP) ; EP -- ALL the errors detected during the environment check.
 NEW STR,MODULE,NAME,VERSION,PATCH,LINECNT,TMP
 ;
 D SORRYHED^BLRPRE31
 ;
 S (MODULE,NAME,VERSION)=""
 F  S MODULE=$O(WOTERR(MODULE))  Q:MODULE=""  D
 . F  S NAME=$O(WOTERR(MODULE,NAME))  Q:NAME=""  D
 .. F  S VERSION=$O(WOTERR(MODULE,NAME,VERSION))  Q:VERSION=""  D ADDMESG
 ;
 D SORRYFIN^BLRPRE31
 ;
 D BMES^XPDUTL(.STR)
 ;
 Q
 ;
ADDMESG ; EP
 NEW WOT,WOTWRONG
 ;
 D ADDLINE^BLRPRE31(.LINECNT,NAME_" ("_MODULE_")","YES")
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
 . D ADDLINE^BLRPRE31(.LINECNT,TMP,"YES")
 . S TMP=WOT
 ;
 D ADDLINE^BLRPRE31(.LINECNT,TMP,"YES")
 D ADDLINE^BLRPRE31(.LINECNT)
 Q
