BLRPRE34 ; IHS/OIT/MKK - IHS Lab PATCH 1034 Environment/Pre/Post Install Routine ; 17-Oct-2014 09:22 ; MKK
 ;;5.2;IHS LABORATORY;**1034**;NOV 01, 1997;Build 88
 ;
ENVCHK ; EP
 D BMES^XPDUTL("Beginning of Pre Check.")
 D MES^XPDUTL("")
 NEW CP,LINE2,RPMS,RPMSVER,STR
 NEW LASTPTCH                 ; Last Patch of Lab
 NEW LSTPISTS                 ; Last Patch Install Status
 NEW WOTERR                   ; Array of errors detected
 ;
 I $G(XPDNM)="" D SORRY("XPDNM not defined or 0.",,,1034)  Q
 ;
 S LINE2=$T(+2)               ; Second line of THIS Routine
 ;
 D OKAY^BLRKIDSU("XPDNM Defined.",5)
 ;
 S CP=$P(XPDNM,"*",3)         ; Current Patch Number
 S RPMS=$P(XPDNM,"*",1)       ; RPMS Module
 S RPMSVER=$P(XPDNM,"*",2)    ; Version of RPMS module being patched
 ;
 S XPDNOQUE="NO QUE"          ; No Queuing Allowed
 ;
 ; The following line prevents the "Disable Options..." and "Move
 ; Routines..." questions from being asked during the install.
 I $G(XPDENV)=1  F X="XPO1","XPZ1","XPZ2","XPI1" S XPDDIQ(X)=0
 ;
 S XPDABORT=0                 ; Initialize ABORT flag to NO
 ;
USERID ; EP - CHECK FOR USER ID
 NEW USERNAME
 ;
 I '$G(DUZ) D SORRY("DUZ UNDEFINED OR 0.",,,CP)  Q
 ;
 I '$L($G(DUZ(0))) D SORRY("DUZ(0) UNDEFINED OR NULL.",,,CP)  Q
 ;
 S USERNAME=$$GET1^DIQ(200,DUZ,"NAME")
 I $L(USERNAME)<1 D SORRY^BLRKIDSU("Installer [DUZ:"_DUZ_"] cannot be identified!",,,CP) Q
 ;
 D OKAY^BLRKIDSU("Installer: "_USERNAME_" ["_DUZ_"].",5)
 ;
 D HOME^%ZIS             ; IO Defaults
 D DTNOLF^DICRW          ; Set DT variable without Doing a Line Feed
 ;
 D BMES^XPDUTL("Pre Check complete.")
 ;
LETSGO ; EP - USER IDENTIFIED -- LET'S GO
 D BMES^XPDUTL("Checking Environment for Patch "_CP_" of Version "_RPMSVER_" of "_RPMS_".")
 D MES^XPDUTL(" ")
 ;
 D NEEDIT^BLRPRE31(CP,"AICD","4.0",,.ERRARRY)         ; IHS ICD/CPT Lookup & Grouper ICD-10 Version
 D NEEDIT^BLRPRE31(CP,"LR","5.2","1033",.ERRARRY)     ; Lab Patch Pre-Requisite
 ;
 I XPDABORT D SORRYEND^BLRKIDSU(.WOTERR,CP)
 E  D BMES^XPDUTL("ENVIRONMENT OK.")  D MES^XPDUTL("")
 ;
 Q
 ;
BACKUP ; EP
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
 I +$G(DEBUG) D  Q
 . D BOKAY^BLRPRE31("SUCCESSFUL system backup CONFIRMED by: "_$$GET1^DIQ(200,DUZ,"NAME")_".",5)
 . D OKAY^BLRKIDSU("DEBUG in process.  No Data Stored.",10)
 . H 1     ; Pause 1 second to let the user see the message.
 ;
 ; Store backup confirmation person & date/time
 S BCKUPCNT=1+$O(^BLRINSTL("LAB PATCH",CP,"BACKUP CONFIRMED BY",""),-1)
 S ^BLRINSTL("LAB PATCH",CP,"BACKUP CONFIRMED BY",BCKUPCNT)=DUZ_"^"_$P($G(^VA(200,DUZ,0)),U)
 S ^BLRINSTL("LAB PATCH",CP,"BACKUP CONFIRMED BY",BCKUPCNT,"DATE/TIME")=$$HTE^XLFDT($H,"5MZ")
 ;
 D BOKAY^BLRPRE31("SUCCESSFUL system backup CONFIRMED by: "_$$GET1^DIQ(200,DUZ,"NAME")_".",5)
 H 1     ; Pause 1 second to let the user see the message.
 Q
 ;
POST ; EP -- POST INSTALL
 NEW BLRVERN,CP,STR
 ;
 S CP=$TR($P($T(+2),";",5),"*")        ; Current Patch
 S BLRVERN=$TR($P($T(+1),";")," ")     ; Routine Name
 ;
 D CLEANSET^BLRICDO                    ; Creates BLRICDO global
 ;
 D ADDOPTS("BLRMENU","BLROTSCH","REPL")
 D ADDOPTS("BLRMENU","BLRLROS","LROS")
 D CHNGOPTT("LROE","Accessioning tests ordered by provider order entry")
 D BMXPO                               ; Add RPCs to Option
 D UPGIS                               ; Change Labcorp DG1.2 to @DG12LABO
 ;
 D LABJRNL                             ; Get rid of extraneous LAB JOURNAL pointers in file 61.2
 ;
 D BMES^XPDUTL("Need to Reset Ref Lab Accession X-Ref Global.")
 K ^XTMP("BLRLINKU")
 D REFLAB68^BLRLINKU                   ; Reset Ref Lab Accession X-Ref Global
 D OKAY^BLRKIDSU("Ref Lab Accession X-Ref Global Reset.")
 ;
 D BMES^XPDUTL("Laboratory Patch "_CP_" INSTALL complete.")
 ;
 ; The VistA Lab's Emerging Pathogen Initiative module is not used
 ; by IHS.  Inactivate the options so that users do not, inadvertantly,
 ; go into any of the EPI menus.
 D INACTOPT("LREP","Lab EPI Module Not Used by IHS","LREPILK")
 ;
 ; Store # of times installation occurred as well as person & date/time
 D ENDINSTL^BLRKIDSU(CP)
 ;
 Q:+$G(DEBUG)
 ;
 S STR(1)=" "
 S STR(2)=$J("",10)_"POST INSTALL of "_BLRVERN_" Routine."
 S STR(3)=" "
 S STR(4)=$J("",15)_"Laboratory Patch "_CP_" INSTALL completed."
 S STR(5)=" "
 ;
 ; Send Alert & E-Mail to LMI Mail Group & Installer
 D MAILALMI^BLRUTIL3("Laboratory Patch "_CP_" INSTALL complete.",.STR,BLRVERN)
 Q
 ;
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
BMXPO ;-- update the RPC file
 N BLRRPC
 S BLRRPC=$O(^DIC(19,"B","BLRRLRPC",0))
 Q:'BLRRPC
 D CLEAN(BLRRPC)
 D GUIEP^BMXPO(.RETVAL,BLRRPC_"|BLR")
 Q
 ;
CLEAN(APP) ;-- clean out the RPC multiple first
 S DA(1)=APP
 S DIK="^DIC(19,"_DA(1)_","_"""RPC"""_","
 N BLRDA
 S BLRDA=0 F  S BLRDA=$O(^DIC(19,APP,"RPC",BLRDA)) Q:'BLRDA  D
 . S DA=BLRDA
 . D ^DIK
 K ^DIC(19,APP,"RPC","B")
 Q
 ;
UPGIS ;-- update the GIS definition
 N BLRX,BLRM
 S BLRX=$O(^INTHL7F("B","HL IHS LAB ORM DG1-2 LC",0))
 Q:'BLRX
 S ^INTHL7F(BLRX,"C")="@DG12LABO"
 S BLRM=$O(^INTHL7M("B","HL IHS LAB O01 LABCORP",0))
 Q:'BLRM
 D COMPILE^BHLU(BLRM)
 Q
 ;
DEONARDY(TOMENU,OPTION,SYNONYM) ; EP
 ; Returns 1 if TOMENU doesn't exist OR
 ;           if OPTION doesn't exist OR
 ;           if OPTION already on TOMENU with SYNONYM
 ;
 NEW OPTIEN,SYNIEN,TOIEN
 S TOIEN=$$LKOPT^XPDMENU(TOMENU)
 Q:TOIEN<1 1       ; Return 1 if TOMENU doesn't exist
 ;
 S OPTIEN=$$LKOPT^XPDMENU(OPTION)
 Q:OPTIEN<1 1      ; Return 1 if OPTION doesn't exist
 ;
 S SYNIEN=+$O(^DIC(19,TOIEN,10,"C",$G(SYNONYM),0))
 Q $S($G(^DIC(19,TOIEN,10,SYNIEN,0))=OPTIEN:1,1:0)
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
 ;
LABJRNL ; EP - Get rid of pointers in file 61.2 that point to an empty File 95.
 NEW (DILOCKTM,DISYS,DT,DTIME,DUZ,IO,IOBS,IOF,IOM,ION,IOS,IOSL,IOST,IOT,IOXY,U,XPARSYS,XQXFLG)
 ;
 Q:+$O(^LAB(95,0))      ; If there is data in file 95, don't do anything
 ;
 S CNT=0,IEN=.9999999
 F  S IEN=$O(^LAB(61.2,IEN))  Q:IEN<1  D
 . S JOURN=0  F  S JOURN=$O(^LAB(61.2,IEN,"JR",JOURN))  Q:JOURN<1  D
 .. S CNT=CNT+1
 .. I CNT=1 D
 ... S ^XTMP("LABJRNAL",0)=$$HTFM^XLFDT(+$H+365)_"^"_$$DT^XLFDT_"^Entries In File 61.2 that Pointed to (Empty) File 95"
 ... D BMES^XPDUTL("There are entries In File 61.2 that Point to (Empty) LAB JOURNAL (#95) File.")
 .. S ^XTMP("LABJRNAL","61.2","IEN",IEN)=""
 .. M ^XTMP("LABJRNAL","61.2","IEN",IEN,"JOURN",JOURN)=^LAB(61.2,IEN,"JR",JOURN)
 .. D TABMENU^BLRKIDSU("File 61.2 IEN:"_IEN_"; JOURN IEN:"_JOURN)
 .. D TABMENU^BLRKIDSU("File 61.2 Journal Reference:"_$G(^LAB(61.2,IEN,"JR",JOURN,0)),10)
 .. ;
 .. K DA
 .. S DA(1)=IEN,DA=JOURN
 .. S DIK="^LAB(61.2,"_DA(1)_",""JR"","
 .. D ^DIK
 ;
 S:CNT ^XTMP("LABJRNAL","61.2")=CNT
 Q
 ;
DEBUG ; EP - Debugging Line Label for environment checker
 NEW CP,DEBUG,LINE2,ROWPLUS,ROWSTARS,XPDNM
 S DEBUG=1
 S XPDNM="LR*5.2*1034"
 ;
 S ROWSTARS=$TR($J("",IOM)," ","*")
 S ROWPLUS=$TR($J("",IOM)," ","+")
 ;
 D ^XBCLS,PASSMESG^BLRPRE31("DEBUG: ENVCHK Check")
 ;
 D ENVCHK^BLRPRE34
 ;
 W !!,"DEBUG: ENVCHK^BLRPRE34 Completed."
 W !!,ROWPLUS
 D PRESSKEY^BLRGMENU
 ;
 D ^XBCLS,PASSMESG^BLRPRE31("DEBUG: BACKUP Check.")
 D BACKUP^BLRPRE34
 W !!,"DEBUG: BACKUP^BLRPRE34 Completed.",!
 W !,ROWPLUS
 D PRESSKEY^BLRGMENU
 ;
 D ^XBCLS,PASSMESG^BLRPRE31("DEBUG: POST Check")
 D POST^BLRPRE34
 W !!,"DEBUG: POST^BLRPRE34 Completed."
 W !!,ROWPLUS
 D PRESSKEY^BLRGMENU
 ;
 D ^XBCLS,PASSMESG^BLRPRE31("DEBUG: COMPLETED")
 D PRESSKEY^BLRGMENU
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
 ; to the people who are assigned to the LMI Mail group.
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
 . D ADDLINE($$CJ^XLFSTR("1-888-830-7280.",65),.LINECNT)
 . D ADDLINE(" ",.LINECNT)
 ;
 D ADDLINE($TR($J("",65)," ","*"),.LINECNT)    ; Row of asterisks
 D ADDLINE(" ",.LINECNT)
 ;
 D BMES^XPDUTL(.STR)              ; Display the message
 ;
 Q:+$G(DEBUG)                     ; Skip if DEBUG
 ;
 I '$G(DUZ)!('$L($G(DUZ(0)))) Q   ; Skip if no DUZ
 ;
 Q:$$FIND1^DIC(3.8,,,"LMI")<1     ; Skip if no LMI Mail group
 ;
 I $G(MODE)="FATAL" D MAILALMI^BLRUTIL3("IHS Lab Patch "_CP_" Install FATAL Error",.STR,"BLRPRE34")
 I $G(MODE)="NONFATAL" D MAILALMI^BLRUTIL3("IHS Lab Patch "_CP_" Install NONFATAL Error",.STR,"BLRPRE34")
 ;
 Q
 ;
ADDLINE(ASTR,LC) ; EP
 ; Add a line to the STR array
 I $G(ASTR)="" S ASTR=" "
 S STR(LC)=ASTR
 S LC=LC+1
 Q
 ;
CHNGOPTT(OPTION,TEXT) ; EP - Change the MENU Text of an Option
 NEW ERRS,FDA,OLDMTEXT,OPTIEN
 ;
 S OPTIEN=$$FIND1^DIC(19,,,OPTION)
 Q:OPTIEN<1     ; Skip if cannot determine OPTION's IEN in file 19
 ;
 S OLDMTEXT=$$GET1^DIQ(19,OPTIEN,"MENU TEXT")
 ;
 D BMES^XPDUTL("Attempting to modify MENU TEXT on Option "_OPTION_" from")
 D MES^XPDUTL($J("",10)_$E(OLDMTEXT,1,50))
 D MES^XPDUTL("     to")
 D MES^XPDUTL($J("",10)_$E(TEXT,1,50))
 ;
 S FDA(19,OPTIEN_",",1)=TEXT
 D UPDATE^DIE("SE","FDA",,"ERRS")
 D MES^XPDUTL("")
 I $D(ERRS)<1 D OKAY^BLRKIDSU("MENU TEXT modified.")
 I $D(ERRS) D MES^XPDUTL("     MENU TEXT was *NOT* modified.")
 Q
