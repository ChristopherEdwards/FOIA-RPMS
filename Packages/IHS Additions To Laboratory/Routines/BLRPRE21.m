BLRPRE21 ; IHS/OIT/MKK - LAB PATCH 21 ENVIRONMENT/POST INSTALL ROUTINE ; [11/03/2005 9:30 PM]
 ;;5.2;LR;**1021**;Jul 27, 2006
 ;;1.0;BLR REFERENCE LAB;;MAR 14, 2005
 ;
 ;
PRECHK ; EP
 D BMES^XPDUTL("Beginning of Pre Check.")
 NEW STR      ; String variable -- used for messages.
 ;
 S $P(LINE,"*",81)=""
 S XPDNOQUE="NO QUE"  ;NO QUEUING ALLOWED
 ;
 ; DISABLE THE "Disable options..." and "Move routines..."
 ; questions from being asked during install
 S (XPDDIQ("XPZ1"),XPDDIQ("XPZ2"))=0
 ;
 S XPDDIQ("XPO1")=0  ;DISABLE "Rebuild Menu Tree" question
 S XPDABORT=0
 ;
USERID ;
 ; CHECK FOR USER ID
 I '$G(DUZ) D SORRY("DUZ UNDEFINED OR 0!")  Q
 ;
 I '$L($G(DUZ(0))) D SORRY("DUZ(0) UNDEFINED OR NULL!")  Q
 ;
 D HOME^%ZIS,DT^DICRW
 S X=$P($G(^VA(200,DUZ,0)),U)
 I $G(X) D SORRY("Installer cannot be identified!")  Q
 ;
LETSGO ;
 ; USER IDENTIFIED -- LET'S GO
 D MES^XPDUTL("Hello, "_$P(X,",",2)_" "_$P(X,","))
 ;
 D BMES^XPDUTL("Checking Environment for Patch "_$P($T(+2),";",5)_" of Version "_$P($T(+2),";",3)_" of "_$P($T(+2),";",4)_".")
 ;
FILEMAN ;
 ; CHECK FOR FILEMAN 22.0
 S X=$G(^DD("VERSION"))
 D BMES^XPDUTL("Need at least FileMan 22.0")
 I X<22 D SORRY("Need FileMan 22.0 & FileMan "_X_" found!")  Q
 D OKAY("FileMan "_X_" found.")
 ;
KERNEL ;
 ; CHECK FOR KERNEL 8.0
 S X=$G(^DIC(9.4,$O(^DIC(9.4,"C","XU",0)),"VERSION"))
 D BMES^XPDUTL("Need at least Kernel 8.0.")
 I X<8.0 D SORRY("Need Kernel 8.0 & Kernel "_X_" found!")  Q
 D OKAY("Kernel "_X_" found.")
 ;
LMIMAIL ;
 ; CHECK FOR LMI MAIL GROUP
 D BMES^XPDUTL("Must have 'LMI' mail group present.")
 I $$CHECKLMI<0 D SORRY("'LMI' mail group NOT found!")  Q
 D OKAY("'LMI' mail group found.")
 ;
OERR ;
 ; CHECK FOR OERR
 D BMES^XPDUTL("Must have Order Entry/Results Reporting.")
 I '$O(^DIC(9.4,"B","ORDER ENTRY/RESULTS REPORTING","")) D  Q
 . D SORRY("Order Entry/Results Reporting NOT found!")
 D OKAY("Order Entry/Results Reporting found.")
 ;
PIMS ;
 ; CHECK FOR PIMS 5.3
 S X=$G(^DIC(9.4,$O(^DIC(9.4,"C","PIMS",0)),"VERSION"))
 D BMES^XPDUTL("Need at least PIMS 5.3.")
 I X<5.3 D SORRY("Need PIMS 5.3 & PIMS "_X_" found!") Q
 D OKAY("PIMS "_X_" found.")
 ;
LEXICON ;
 ; CHECK FOR LEXICON 2.0
 S X=$G(^DIC(9.4,$O(^DIC(9.4,"C","LEX",0)),"VERSION"))
 D BMES^XPDUTL("Need at least LEXICON 2.0.")
 I X<2.0 D SORRY("Need LEXICON 2.0 & LEXICON "_X_" found!") Q
 D OKAY("LEXICON "_X_" found.")
 ;
GIS ;
 ; CHECK FOR GIS 3.01
 S X=$G(^DIC(9.4,$O(^DIC(9.4,"C","GIS",0)),"VERSION"))
 D BMES^XPDUTL("Need at least GIS 3.01.")
 I X<3.01 D SORRY("Need GIS 3.01 & GIS "_X_" found!") Q
 D OKAY("GIS "_X_" found.")
 ;
GIS11 ;
 ; CHECK FOR GIS 3.01 Patch 11
 I $$GISPATCH(11)'["Y" D SORRY("GIS 3.01 Patch 11 IS NOT installed!")  Q
 D OKAY("GIS 3.01 Patch 11 found.")
 ;
GIS13 ;
 ; CHECK FOR GIS 3.01 Patch 13
 I $$GISPATCH(13)'["Y" D SORRY("GIS 3.01 Patch 13 IS NOT installed!")  Q
 D OKAY("GIS 3.01 Patch 13 found.")
 ;
GIS14 ;
 ; CHECK FOR GIS 3.01 Patch 14
 I $$GISPATCH(14)'["Y" D SORRY("GIS 3.01 Patch 14 IS NOT installed!")  Q
 D OKAY("GIS 3.01 Patch 14 found.")
 ;
LABVER ;
 ;CHECK FOR PREVIOUS LAB PATCH NEEDED
 D BMES^XPDUTL("Need Lab Patch LR*5.2*1020 installed.")
 I $$LABPATCH(1020)'["Y" D SORRY("Patch 1020 WAS NOT installed!")  Q
 D OKAY("Lab Patch 1020 found.")
 ;
ENVOK ;
 ; ENVIRONMENT OK
 D BMES^XPDUTL("ENVIRONMENT OK.")
 ;
BACKUPS ;
 ; CHECK TO CONFIRM BACKUPS HAVE BEEN DONE
 D BMES^XPDUTL("BACKUPS Check Next.")
 ;
 W !!
 S DIR(0)="Y"
 S DIR("B")="NO"
 S DIR("A")="Has a SUCCESSFUL system backup been performed??"
 D ^DIR
 I $D(DIRUT)!($G(Y)=0) D  Q
 . D SORRY("Please perform a successful backup before continuing!!")
 ;
 S %DT="R",X="NOW" D ^%DT X ^DD("DD")
 S STR="BACKUPS CONFIRMED BY "_$P($G(^VA(200,DUZ,0)),U)_" ON "
 S STR=STR_$P(Y,"@")_" AT "_$P(Y,"@",2)
 D BMES^XPDUTL(STR)
 D MES^XPDUTL(" ")
 ;
 ; Store backup confirmation person & date/time
 NEW CP,BCKUPCNT                  ; Current Patch,Backup count
 S CP=$TR($P($T(+2),";",5),"*")   ; Current Patch
 S BCKUPCNT=1+$O(^BLRINSTL("LAB PATCH",CP,"BACKUP CONFIRMED BY",""),-1)
 S ^BLRINSTL("LAB PATCH",CP,"BACKUP CONFIRMED BY",BCKUPCNT)=$P($G(^VA(200,DUZ,0)),U)
 S ^BLRINSTL("LAB PATCH",CP,"BACKUP CONFIRMED BY",BCKUPCNT,"DATE/TIME")=$$HTE^XLFDT($H,"5Z")
 Q
 ;
SORRY(MSG,MODE) ;
 ; MESSAGE TO DISPLAY WHEN SOMETHING GOES WRONG
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
 S STR(2)=$TR($J("",65)," ","*")    ; Row of asterisks
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
 S STR(15)=$G(STR(2))               ; Row of asterisks
 S STR(16)=""
 D BMES^XPDUTL(.STR)
 ;
 ; Send alert to LMI MAIL GROUP
 I $G(MODE)["NONFATAL" S XQAMSG="Lab Patch 21 "_MODE_" - "_MSG
 I $G(MODE)'["NONFATAL" S XQAMSG="Lab Patch 21 >> FATAL >> "_MSG
 S XQA("G.LMI")=""
 D SETUP^XQALERT
 Q
 ;
OKAY(MSG,TAB) ;
 ; MESSAGE WITH "OK" AT THE END
 NEW MESSAGE
 I $G(TAB)="" S TAB=5
 S MESSAGE=$J("",TAB)_MSG_" OK."
 D MES^XPDUTL(MESSAGE)
 Q
 ;
CHECKLMI() ;
 ; CHECK FOR LMI MAIL GROUP
 S DIC="^XMB(3.8,"
 S X="LMI"
 D ^DIC
 Q +Y
 ;
POSTCHK ; cmi/anch/maw - BLR Reference Lab Post Init ;
POST     ; PEP - Main Routine Driver
 ; POST INSTALL
 D BMES^XPDUTL("Beginning Lab Patch 1021 POST INSTALL.")
 D MES^XPDUTL(" ")
 ;
 D ADDMENU                   ; Add BLREFLABLMENU to BLRMENU
 ;
 ; D REFLGLOI                ; Will NOT be needed after Beta testing
 ;
 D CHNGAUTO                  ; Change AUTO INSTRUMENT File
 ;
 ; Give User instructions on how to enter Reference Lab parameters.
 ; D BMES^XPDUTL(" ")
 ; D BMES^XPDUTL($$CJ^XLFSTR("***--->>> NOTICE <<<---***",70))
 ; D BMES^XPDUTL("Use the Reference Lab Site Parameter Add/Edit menu to Set Up Ref Lab.")
 ; D BMES^XPDUTL(" ")
 D POSTDONE
 D BMES^XPDUTL("End of Lab Patch 1021 POST INSTALL.")
 D BMES^XPDUTL(" ")
 ;
 ; Store # of times instllation occurred as well as person & date/time
 NEW CP,INSTCNT                   ; Current Patch,Installation count
 S CP=$TR($P($T(+2),";",5),"*")   ; Current Patch
 S INSTCNT=1+$O(^BLRINSTL("LAB PATCH",CP,"INSTALLED BY",""),-1)
 S ^BLRINSTL("LAB PATCH",CP,"INSTALLED BY",INSTCNT)=$P($G(^VA(200,DUZ,0)),U)
 S ^BLRINSTL("LAB PATCH",CP,"INSTALLED BY",INSTCNT,"DATE/TIME")=$$HTE^XLFDT($H,"5Z")
 ;	
 Q
 ;
CHNGAUTO ;
 ; IHS Modifications to the AUTO INSTRUMENT file
 ; 
 ; Delete Programmer only access to FILE BUILD ENTRY field
 I $G(^DD(62.4,93,0))["K:$L(X)>8!($L(X)<1)!'(X?1A.7AN) X" D
 . S STR="^DD(62.4,93,9)"
 . S @STR=""
 ;
 ; If FILE BUILD ENTRY field damaged by previous Patch 21 install, correct it
 I $G(^DD(62.4,93,0))'["K:$L(X)>8!($L(X)<1)!'(X?1A.7AN) X" D
 . S STR="^DD(62.4,93,0)"
 . S @STR="FILE BUILD ENTRY^F^^9;3^K:$L(X)>8!($L(X)<1)!'(X?1A.7AN) X"
 ;
 ; Delete Programmer only access on FILE BUILD ROUTINE field
 I $G(^DD(62.4,94,0))["K:$L(X)>8!($L(X)<1)!'(X?1A.7AN) X" D
 . S STR="^DD(62.4,94,9)"
 . S @STR=""
 ;
 ; If FILE BUILD ROUTINE field damaged by previous Patch 21 install, correct it
 I $G(^DD(62.4,94,0))'["K:$L(X)>8!($L(X)<1)!'(X?1A.7AN) X" D
 . S STR="^DD(62.4,94,0)"
 . S @STR="FILE BUILD ROUTINE^F^^9;4^K:$L(X)>8!($L(X)<1)!'(X?1A.7AN) X"
 ;
 ; Delete Programmer only acces on PARAM 1 field
 I $G(^DD(62.41,2,0))["K:$L(X)>100!($L(X)<2)!(X[U) X D:$D(X) ^DIM" D
 . S STR="^DD(62.41,2,9)"
 . S @STR=""
 ;
 ; If PARAM 1 field damaged by previous Patch 21 install, correct it
 I $G(^DD(62.41,2,0))'["K:$L(X)>100!($L(X)<2)!(X[U) X D:$D(X) ^DIM" D
 . S STR="^DD(62.41,2,0)"
 . S @STR="PARAM 1^FX^^0;2^K:$L(X)>100!($L(X)<2)!(X[U) X D:$D(X) ^DIM"
 ;
 Q
 ;
POSTDONE ;
 ; POST INSTALL COMPLETE
 X ^%ZOSF("EOFF")
 D EN^XBVK("BLR")
 ;
 ; Send alert
 ; S XQAMSG="Use the Reference Lab Site Parameter Add/Edit menu to Set Up Ref Lab."
 ; S XQA("G.LMI")=""
 ; D SETUP^XQALERT
 ;
 ; Send alert
 S XQAMSG="Lab Patch 21 Install Completed"
 S XQA("G.LMI")=""
 D SETUP^XQALERT
 ;
 Q
 ;
ADDMENU ;
 ; ADD REFERENCE LAB MEN TO BLRMENU
 NEW HEREYAGO
 ;
 D BMES^XPDUTL("Adding BLRREFLABMENU to BLRMENU.")
 ;
 S HEREYAGO=$$ADD^XPDMENU("BLRMENU","BLRREFLABMENU","REFL")
 ;
 I HEREYAGO=1 D
 . D OKAY("BLRREFLABMENU added to BLRMENU.")
 ;
 I HEREYAGO'=1 D
 . S HEREYAGO=$P($$UP^XLFSTR(HEREYAGO),"^",2)      ; Uppercase Error Message
 . D TABMENU("Error in adding BLRREFLABMENU to BLRMENU.")
 . I $L(HEREYAGO)>0 D TABMENU("Error Message: "_$P(HERYAGO,"^",2),10)
 ;
 D BMES^XPDUTL("Adding BLR REFLAB REPRINT SHIP MAN to BLRREFLABMENU.")
 S HEREYAGO=$$ADD^XPDMENU("BLRREFLABMENU","BLR REFLAB REPRINT SHIP MAN","REP")
 ;
 I HEREYAGO=1 D
 . D OKAY("BLR REFLAB REPRINT SHIP MAN added to BLRREFLABMENU.")
 ;
 I HEREYAGO'=1 D
 . S HEREYAGO=$P($$UP^XLFSTR(HEREYAGO),"^",2)      ; Uppercase Error Message
 . D TABMENU("Error in adding BLR REFLAB REPRINT SHIP MAN to BLRREFLABMENU.")
 . I $L(HEREYAGO)>0 D TABMENU("Error Message: "_$P(HERYAGO,"^",2),10)
 ;
 D BMES^XPDUTL("Adding BLR EDIT LABORATORY TEST FILE to BLRREFLABMENU.")
 S HEREYAGO=$$ADD^XPDMENU("BLRREFLABMENU","BLR EDIT LABORATORY TEST FILE","E60")
 ;
 I HEREYAGO=1 D
 . D OKAY("BLR EDIT LABORATORY TEST FILE added to BLRREFLABMENU.")
 ;
 I HEREYAGO'=1 D
 . S HEREYAGO=$P($$UP^XLFSTR(HEREYAGO),"^",2)      ; Uppercase Error Message
 . D TABMENU("Error in adding BLR EDIT LABORATORY TEST FILE to BLRREFLABMENU.")
 . I $L(HEREYAGO)>0 D TABMENU("Error Message: "_$P(HERYAGO,"^",2),10)
 ;
 D MES^XPDUTL(" ")
 ;
 Q
 ;
TABMENU(MSG,TAB,TAIL) ;
 ; GENERIC MESSAGE OUTPUT
 NEW MESSAGE
 I $G(TAB)="" S TAB=5
 S MESSAGE=$J("",TAB)_MSG
 I $G(TAIL)'="" S MESSAGE=MESSAGE_" "_TAIL
 D MES^XPDUTL(MESSAGE)
 Q
 ;
 ; CHECK FOR GIS Patches
GISPATCH(CHK) ;
 NEW PAT,PATCH,GISPTR,OKGIS,OKPATCH
 S GISPTR=$O(^DIC(9.4,"C","GIS",0))
 S PAT="",OKPATCH="NO"
 F  S PAT=$O(^DIC(9.4,GISPTR,22,PAT))  Q:PAT=""!(OKPATCH["Y")  D
 . S PATCH=""
 . F  S PATCH=$O(^DIC(9.4,GISPTR,22,PAT,"PAH",PATCH))  Q:PATCH=""!(OKPATCH["Y")  D
 .. I +$G(^DIC(9.4,GISPTR,22,PAT,"PAH",PATCH,0))[CHK S OKPATCH="YES"
 Q OKPATCH
 ;
 ; CHECK FOR LAB Patches
LABPATCH(CHK) ;
 NEW PAT,PATCH,LABPTR,OKLAB,OKPATCH
 S LABPTR=$O(^DIC(9.4,"C","LR",0))
 S PAT="",OKPATCH="NO"
 F  S PAT=$O(^DIC(9.4,LABPTR,22,PAT))  Q:PAT=""!(OKPATCH["Y")  D
 . S PATCH=""
 . F  S PATCH=$O(^DIC(9.4,LABPTR,22,PAT,"PAH",PATCH))  Q:PATCH=""!(OKPATCH["Y")  D
 .. I $G(^DIC(9.4,LABPTR,22,PAT,"PAH",PATCH,0))[CHK S OKPATCH="YES"
 Q OKPATCH
