BLRPRE20 ; IHS/ITSC/MKK - ENVIRONMENT CHECK FOR PATCH 20; [ 07/22/2005 ]
 ;;5.2;LR;**1020**;Sep 13, 2005
 ;
 NEW CP                      ; Current Patch
 S CP=$TR($P($T(+2),";",5),"*")
 ;
 NEW LRSTATUS                ; Install Status
 ;
 S $P(LINE,"*",81)=""
 S XPDNOQUE="NO QUE"  ;NO QUEUING ALLOWED
 ; DISABLE THE "Disable options..." and "Move routines..."
 ; questions from being asked during install     
 S (XPDDIQ("XPZ1"),XPDDIQ("XPZ2"))=0
 S XPDDIQ("XPO1")=0  ;DISABLE "Rebuild Menu Tree" question
 S XPDABORT=0
 ;
 I '$G(DUZ) D SORRY("DUZ UNDEFINED OR 0.")  Q
 ;
 I '$L($G(DUZ(0))) D SORRY("DUZ(0) UNDEFINED OR NULL.")  Q
 ;
 D HOME^%ZIS,DT^DICRW
 S X=$P($G(^VA(200,DUZ,0)),U)
 I $G(X) D SORRY("Installer cannot be identified!") Q
 ;
 D BMES^XPDUTL("Hello, "_$P(X,",",2)_" "_$P(X,","))
 ;
 D BMES^XPDUTL("Checking Environment for Patch "_$P($T(+2),";",5)_" of Version "_$P($T(+2),";",3)_" of "_$P($T(+2),";",4)_".")
 ;
 S X=$G(^DD("VERSION"))
 D BMES^XPDUTL("Need at least FileMan 22.0")
 I X<22 D SORRY("Need FileMan 22.0 & FileMan "_X_" found!")  Q
 D OKAY("FileMan "_X_" found.")
 ;
 S X=$G(^DIC(9.4,$O(^DIC(9.4,"C","XU",0)),"VERSION"))
 D BMES^XPDUTL("Need at least Kernel 8.0.")
 I X<8.0 D SORRY("Need Kernel 8.0 & Kernel "_X_" found!")  Q
 D OKAY("Kernel "_X_" found.")
 ;
 D BMES^XPDUTL("Must have 'LMI' mail group present.")
 I $$CHECKLMI<0 D SORRY("'LMI' mail group NOT found!")  Q
 D OKAY("'LMI' mail group found.")
 ;
 D BMES^XPDUTL("Must have Order Entry/Results Reporting.")
 I '$O(^DIC(9.4,"B","ORDER ENTRY/RESULTS REPORTING","")) D  Q
 . D SORRY("Order Entry/Results Reporting NOT found!")
 D OKAY("Order Entry/Results Reporting found.")
 ;
 S X=$G(^DIC(9.4,$O(^DIC(9.4,"C","PIMS",0)),"VERSION"))
 D BMES^XPDUTL("Need at least PIMS 5.3.")
 I X<5.3 D SORRY("Need PIMS 5.3 & PIMS "_X_" found!")  Q
 D OKAY("PIMS "_X_" found.")
 ;
 ; First, make sure Lexicon, in some form, exists
 S X=$O(^DIC(9.4,"C","LEX",0))
 I $G(X)="" D  Q
 . D BMES^XPDUTL("Must have Lexicon.")
 . D SORRY("Need LEXICON and LEXICON NOT FOUND!")
 ;
 ; Now, check the Lexicon version number
 S X=$G(^DIC(9.4,$O(^DIC(9.4,"C","LEX",0)),"VERSION"))
 I X="" S X="Version Number NOT"
 D BMES^XPDUTL("Need at least LEXICON 2.0.")
 I X<2.0 D SORRY("Need LEXICON 2.0 & LEXICON "_X_" found!")  Q
 D OKAY("LEXICON "_X_" found.")
 ;
 ; Check for the existance of the REPORTABLE LAB TESTS dictionary.
 ; If it exists & current patch  has NOT installed successfully, quit
 S LRSTATUS=""
 S %=$O(^XPD(9.7,"B","LR*5.2*"_CP,""))     ; Check if 1020 already installed.
 I %'="" S LRSTATUS=$P($G(^XPD(9.7,%,0)),U,9)
 I $D(^DD(90475))>0&(LRSTATUS'=3) D SORRY("DD 90475 Exists Prior to Install.")  Q
 ;
 ; Check for the existance of the LAB PROV LOC CHANGE dictionary.
 ; If it exists & current patch  has NOT installed successfully, quit
 I $D(^DD(90475.2))>0&(LRSTATUS'=3) D SORRY("DD 90475.2 Exists Prior to Install.")  Q
 ;
VERSION ;
 ;CHECK FOR PREVIOUS PATCH NEEDED
 NEW LASTPTCH
 S LASTPTCH=+$TR($P($T(+2),";",5),"*")-1
 D BMES^XPDUTL("Need Lab Patch "_LASTPTCH_" to have been installed.")
 I $D(^XPD(9.7,"B","LR*5.2*"_LASTPTCH))<1 D SORRY("Patch "_LASTPTCH_" WAS NOT installed!")  Q
 ;
 ;GET INSTALL STATUS
 NEW LRSTATUS
 S LRSTATUS=0
 S %=$O(^XPD(9.7,"B","LR*5.2*"_LASTPTCH,""))
 I %'="" S LRSTATUS=$P($G(^XPD(9.7,%,0)),U,9)
 I LRSTATUS'=3 D  Q
 . D SORRY("Install of Lab Patch "_LASTPTCH_" NOT complete.  Status: "_LRSTATUS_"!")
 ;
 D OKAY("Lab Patch "_LASTPTCH_" installed & Status complete.")
 ;
ENVOK ; If this is just an environ check, end here.
 D BMES^XPDUTL("ENVIRONMENT OK.")
 ;
 ; The following line prevents the "Disable Options..." and "Move 
 ; Routines..." questions from being asked during the install. 
 I $G(XPDENV)=1 S (XPDDIQ("XPZ1"),XPDDIQ("XPZ2"))=0
 ;
 ;VERIFY BACKUPS HAVE BEEN DONE
 W !!
 D ^XBFMK
 S DIR(0)="Y"
 S DIR("B")="NO"
 S DIR("A")="Has a SUCCESSFUL system backup been performed??"
 D ^DIR
 I $D(DIRUT)!($G(Y)=0) D BMES^XPDUTL("Please perform a successful backup before continuing!!") S XPDABORT=1 Q
 S %DT="R",X="NOW" D ^%DT X ^DD("DD")
 D BMES^XPDUTL("BACKUPS CONFIRMED BY "_$P($G(^VA(200,DUZ,0)),U)_" ON "_$P(Y,"@")_" AT "_$P(Y,"@",2))
 S ^BLRINSTL(CP,"INSTALLED BY")=$P($G(^VA(200,DUZ,0)),U)
 ;
 Q
 ;
SORRY(MSG,MODE)       ;
 NEW MESSAGE
 I $G(MODE)'["NONFATAL" D
 . S MESSAGE="Install Aborting due to the following Systems Environment issue:"
 . S XPDABORT=1
 ;
 I $G(MODE)["NONFATAL" S MESSAGE="*** WARNING *** WARNING *** WARNING ***"
 ;
 K DIFQ
 ;
 NEW STR
 S STR(1)=""
 S STR(2)=$TR($J("",65)," ","*")
 S STR(3)=" "
 S STR(4)=$$CJ^XLFSTR("Site: "_$$LOC^XBFUNC,65)
 S STR(5)=" "
 S STR(6)=$$CJ^XLFSTR(MESSAGE,65)
 S STR(7)=" "
 S STR(8)=$$CJ^XLFSTR(">>> "_MSG_" <<<",65)
 S STR(9)=" "
 S STR(10)=$$CJ^XLFSTR("Please print/capture this screen and",65)
 S STR(11)=$$CJ^XLFSTR("notify the Support Center at",65)
 S STR(12)=""
 S STR(13)=$$CJ^XLFSTR("1-999-999-9999.",65)
 S STR(14)=" "
 S STR(15)=$G(STR(2))
 S STR(16)=""
 D BMES^XPDUTL(.STR)
 ;
 S XQAMSG="FATAL >> "_MSG
 I $G(MODE)["NONFATAL" S XQAMSG=MODE_" - "_MSG
 S XQA("G.LMI")=""
 D SETUP^XQALERT
 Q
 ;
OKAY(MSG,TAB)       ;
 NEW MESSAGE
 I $G(TAB)="" S TAB=5
 S MESSAGE=$J("",TAB)_MSG_" OK."
 D MES^XPDUTL(MESSAGE)
 Q
 ;
 ;CHECK FOR LMI MAIL GROUP
CHECKLMI() ;
 S DIC="^XMB(3.8,"
 S X="LMI"
 D ^DIC
 Q +Y
 ;
 ; POST-INSTALL
POST ;
 NEW CP                      ; Current Patch
 S CP=$TR($P($T(+2),";",5),"*")
 ;
 NEW CRLF     ; Carriage-Return-Line-Feed
 S CRLF=$C(13)_$C(10)
 ;
 D BMES^XPDUTL("Laboratory Patch "_CP_" POST INSTALL...")
 ;
 D LABFIXLU   ; Fix lookup in COMPUTED AGE field
 ; 
 D LAB60FIX   ; Fix File 60's invalid Urgency entries.
 ;
 ; Add Options to the BLRMENU
 D BMES^XPDUTL("     Updating OPTIONS")
 D ADDBMENU("BLREPOLR","EDT")     ; Change Provider/Location Menu
 D ADDBMENU("BLRSHDRC","SHDR")    ; State Health Dept Report
 D OKAY("Updating OPTIONS.",5)
 ;
 ; Change the Default maximum Max Order Freq of ordering tests to 365.
 D CHNGMOFD
 ; 
 D BMES^XPDUTL("Laboratory Patch "_CP_" POST INSTALL complete."_CRLF_CRLF)
 ;
 S XQAMSG="Laboratory Patch "_CP_" INSTALL complete."
 S XQA("G.LMI")=""
 D SETUP^XQALERT
 Q
 ;
LABFIXLU ;
 ; Fix issue with strange things occurring when people use FileMan
 ; to look up Lab Data and want computed values.  This is a flaw in the
 ; lookup routine.  Need to change the "NMF" below to "INMF"
 ; ^DD(63.04,999999901,9.3)=X ^DD(63.04,999999901,9.2) S Y=$P(Y(63.04,999999901,1),
 ; VU,3) X:$D(^DD(63,.03,2)) ^(2) S X=Y K DIC S DIC="^AUPNPAT(",DIC(0)="NMF" D ^DIC
 ; S (D,D0)=+Y
 ;
 I $D(^DD(63.04,999999901,9.3))<1 Q    ; If it doesn't exist, skip
 ;
 ; If field doesn't exist, skip
 I $P($G(^DD(63.04,999999901,9.3)),$C(34),4)="" Q
 ;
 D BMES^XPDUTL("     Correcting ^DD(63.04,999999901,9.3) entry")
 I $P($G(^DD(63.04,999999901,9.3)),$C(34),4)="INMF" D
 . D OKAY("^DD(63.04,999999901,9.3) entry Already Corrected.",10)
 I $P($G(^DD(63.04,999999901,9.3)),$C(34),4)'="INMF" D
 . S $P(^DD(63.04,999999901,9.3),$C(34),4)="INMF"  ; Ignore special lookup
 . D OKAY("^DD(63.04,999999901,9.3) entry Corrected.",10)
 ;
 Q
 ;
LAB60FIX ;
 ; Fix File 60's invalid Urgency entries.  Left over from 
 ; 5.1 to 5.2 Upgrade, I believe.
 ;
 D BMES^XPDUTL("     Checking File 60 (Laboratory Test) for invalid")
 D MES^XPDUTL("     HIGHEST URGENCY ALLOWED entries.")
 ;
 NEW IEN,CNT
 S IEN="",CNT=0
 F  S IEN=$O(^LAB(60,IEN))  Q:IEN=""!(CNT>0)  D
 . I $P($G(^LAB(60,IEN,0)),"^",16)'=2 Q     ; 2 is invalid.
 . ;
 . S $P(^LAB(60,IEN,0),"^",16)=9       ; Set to ROUTINE urgency
 ;
 I CNT<1 D OKAY("No invalid HIGHEST URGENCY ALLOWED entries detected.",10)
 ;
 I CNT=1 D       ; Single change verbage
 . S STR="          In File 60 (Laboratory Test) there was "_CNT_CRLF
 . S STR=STR_"          invalid HIGHEST URGENCY ALLOWED entry."_CRLF
 . S STR=STR_"          This URGENCY has been changed to ROUTINE.  OK."_CRLF
 ;
 I CNT>1 D       ; Multiple change verbage
 . S STR="          In File 60 (Laboratory Test) there were "_CNT_CRLF
 . S STR=STR_"          invalid HIGHEST URGENCY ALLOWED entries."_CRLF
 . S STR=STR_"          They have been changed to ROUTINE.  OK."_CRLF
 ;
 I CNT>0 D MES^XPDUTL(STR)
 ;
 Q
 ;
 ; Add item to BLRMENU
ADDBMENU(ADDM,SYNM) ;
 NEW FDA,ERR,HEREYAGO,MIEN,BLRIEN
 ;
 D MES^XPDUTL("          Adding "_ADDM_" to BLRMENU.")
 ;
 ; First, Get BLRMENU IEN
 D FIND^DIC(19,"","","","BLRMENU","","","","","HEREYAGO")
 S BLRIEN=$G(HEREYAGO("DILIST",2,1))
 ;
 ; Cleanup
 D ^XBFMK
 K HEREYAGO
 ;
 ; Next, get IEN for Option
 D FIND^DIC(19,"","","",ADDM,"","","","","HEREYAGO")
 S MIEN=$G(HEREYAGO("DILIST",2,1))
 ;
 ; Make sure OPTION exists
 I $G(MIEN)="" D SORRY("Could not find "_ADDM_" Option","NONFATAL")  Q
 ;
 ; Now, check to see if Option already there -- if so, Quit
 I $D(^DIC(19,BLRIEN,10,"B",MIEN)) D  Q
 . D OKAY(ADDM_" already on BLRMENU.  No further processing.",15)
 ;
 S FDA(42,19,"?1,",.01)="BLRMENU"
 S FDA(42,19.01,"+2,?1,",.01)=MIEN
 S FDA(42,19.01,"+2,?1,",2)=SYNM       ; SYNONYM (1-4 Chars)
 ;
 D UPDATE^DIE("","FDA(42)",,"")
 ;
 I $D(^TMP("DIERR",$J))>0  D  Q
 . D SORRY("Error in adding "_ADDM_" to BLRMENU.  $J="_$J_".","NONFATAL")
 ;
 D OKAY(ADDM_" added to BLRMENU.  $J="_$J_".",15)
 ;
 Q
 ;
CHNGMOFD ;
 NEW SPEC,STR,SUBSTR
 NEW WOTDD
 ;
 D BMES^XPDUTL("     Changing Max Order Freq Default for Lab Tests to 365.")
 S STR=$G(^DD(60.03,4,0))
 S SUBSTR=$P($P($P(STR,"^",5),">",2),")",1)
 I $L(SUBSTR)'=3 D  Q
 . D SORRY("Could not change Max Order Freq Default String","NONFATAL")
 ;
 I +SUBSTR=365 D  Q
 . D OKAY("Max Order Freq Default already 365.",10)
 ;
 I +SUBSTR'=365  D
 . S SPEC(SUBSTR)=365
 . S STR=$$REPLACE^XLFSTR(STR,.SPEC)
 . S WOTDD="^DD(60.03,4,0)"
 . S @WOTDD=STR
 . D OKAY("Changed Max Order Freq Default.",10)
 ;
 K SPEC
 S STR=$G(^DD(60.03,4,3))
 S SUBSTR=$RE($P($RE($P(STR,",",1))," ",1))
 I $L(SUBSTR)'=3 D  Q
 . D SORRY("Could not change Max Order Freq Default HELP String","NONFATAL")
 ;
 I +SUBSTR=365 D
 . D OKAY("Max Order Freq Default HELP String already 365.",10)
 ;
 I +SUBSTR'=365  D
 . S SPEC(SUBSTR)=365
 . S STR=$$REPLACE^XLFSTR(STR,.SPEC)
 . S WOTDD="^DD(60.03,4,3)"
 . S @WOTDD=STR
 . D OKAY("Changed Max Order Freq Default HELP.",10)
 ;
 D OKAY("Max Order Freq Default.")
 ;
 Q
