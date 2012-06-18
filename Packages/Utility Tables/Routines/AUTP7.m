AUTP7 ; IHS/ASDST/GTH - AUT 98.1 PATCH 7 ; [ 02/14/2001  2:39 PM ]
 ;;98.1;IHS DICTIONARIES (POINTERS);**7**;MAR 04, 1998
 ;
 I '$G(DUZ) W !,"DUZ UNDEFINED OR 0." D SORRY(1) Q
 ;
 I '$L($G(DUZ(0))) W !,"DUZ(0) UNDEFINED OR NULL." D SORRY(1) Q
 ;
 I '(DUZ(0)["@") W:'$D(ZTQUEUED) !,"DUZ(0) DOES NOT CONTAIN AN '@'." D SORRY(1) Q
 ;
 S X=$P(^VA(200,DUZ,0),U)
 W !!,$$C^XBFUNC("Hello, "_$P(X,",",2)_" "_$P(X,",")),!
 F %=1:1 S X=$P($T(HELLO+%),";",3) Q:X=""  W !?5,X
 ;
 W !!,$$C^XBFUNC("Checking Environment for "_$P($T(+2),";",4)_" V "_$P($T(+2),";",3)_" Patch "_$P($T(+2),";",5)_".")
 ;
 S X=$$VERSION^XPDUTL("AUT")
 W !!,$$C^XBFUNC("Need AUT v 98.1.....AUT v "_X_" Present")
 I X<98.1 D SORRY(1) Q
 ;
 S X=$$VERSION^XPDUTL("DI")
 W !,$$C^XBFUNC("Need at least FileMan 21.....FileMan "_X_" Present")
 I X<21 D SORRY(1) Q
 ;
 S X=$$VERSION^XPDUTL("XU")
 W !,$$C^XBFUNC("Need at least Kernel 8.....Kernel "_X_" Present")
 I X<8 D SORRY(1) Q
 ;
 NEW DA,DIC
 S X="AUT",DIC="^DIC(9.4,",DIC(0)="",D="C"
 D IX^DIC
 I Y<0,$D(^DIC(9.4,"C","AUT")) D  Q
 . W !!,*7,*7,$$C^XBFUNC("You Have More Than One Entry In The"),!,$$C^XBFUNC("PACKAGE File with an ""AUT"" prefix.")
 . W !,$$C^XBFUNC("One entry needs to be deleted.")
 . W !,$$C^XBFUNC("FIX IT! Before Proceeding."),!!,*7,*7,*7
 . D SORRY(1)
 . I $$DIR^XBDIR("E")
 .Q
 W !,$$C^XBFUNC("No 'AUT' dups in PACKAGE file")
 ;
 ; If patches 1-6 have already been installed, don't load them.
 I $G(XPDENV)=0 D  ; Run only during Load of Installation.
 . NEW DA
 . S DA(1)=+Y ; Y is set from previous DIC lookup into PACKAGE.
 . S DA=$O(^DIC(9.4,DA(1),22,"B",98.1,0))
 . F %=1:1:6 I $D(^DIC(9.4,DA(1),22,DA,"PAH","B",%)) S XPDQUIT("AUT*98.1*"_%)=1
 .Q
 ;
 ; The following line prevents the "Disable Options..." and "Move
 ; Routines..." questions from being asked during the install.
 I $G(XPDENV)=1 S (XPDDIQ("XPZ1"),XPDDIQ("XPZ2"))=0
 ;
 W !!,$$C^XBFUNC("ENVIRONMENT OK.")
 I '$$DIR^XBDIR("E","","","","","",1) D SORRY(1) Q
 Q
 ;
SORRY(X) ;
 KILL DIFQ
 S XPDQUIT=X
 F %=1:1:5 S XPDQUIT("AUT*98.1*"_%)=1
 W:'$D(ZTQUEUED) *7,!,$$C^XBFUNC("Sorry...."),$$DIR^XBDIR("E","Press RETURN")
 Q
 ;
PRE ;EP - From KIDS.
 D BMES^XPDUTL("Beginning pre-install routine (PRE^AUTP7).")
 S ^XTMP("AUTP7",0)=$$FMADD^XLFDT(DT,14)_"^"_DT_"^"_"AUT*98.1*7"
 I '$D(^XTMP("AUTP7",9999999.09,"DDA")) D
 . D BMES^XPDUTL("Saving dd audit value for EDUCATION TOPICS...")
 . S ^XTMP("AUTP7",9999999.09,"DDA")=$G(^DD(9999999.09,0,"DDA"))
 .Q
 D BMES^XPDUTL("Seting dd audit value for EDUCATION TOPICS 'on'...")
 S ^DD(9999999.09,0,"DDA")="Y"
 D BMES^XPDUTL("Pre-install routine is complete.")
 Q
 ;
POST ;EP - From KIDS.
 D BMES^XPDUTL("Beginning post-install routine (POST^AUTP7).")
 I $D(^XTMP("AUTP7",9999999.09,"DDA")) D
 . D BMES^XPDUTL("Restoring dd audit value for EDUCATION TOPICS...")
 . S ^DD(9999999.09,0,"DDA")=^XTMP("AUTP7",9999999.09,"DDA")
 .Q
 D BMES^XPDUTL("Delivering MailMan message to select users...")
 NEW DIFROM
 D MAIL^XBMAIL("ACHSZMGP,ACRZ MANAGERS MENU,XUMGR-XUPROGMODE","MSG^AUTP7")
 D BMES^XPDUTL("Post-install routine is complete.")
 Q
 ;
MSG ;
 ;;AUT*98.1*7, EDUCATION TOPICS dd.
 ;;Greetings.  You are receiving this message because you are a
 ;;programmer or hold specific PCC Data Entry security keys.
 ;;This is for your information, only.  You need not do anything
 ;;in response to this message.
 ;;  
 ;;Questions can be directed to the Help Desk
 ;;
 ;;  
 ;; --- AUT v 98.1, Patch 7, has been installed into this uci ---
HELLO ;;  
 ;;AUT v 98.1, Patch 7, does the following:
 ;;  
 ;;a)  AUT v 98.1, Patch 7, modifies the EDUCATION TOPICS 
 ;;    data dictionary, file # 9999999.09, to allow the adding
 ;;    of education topics using ICD Diagnosis codes.  The
 ;;    functionality of adding education topics using ICD codes
 ;;    will be part of the next patch to PCC Data Entry (APCD).
 ;;    
 ;;    Modifications to dd 9999999.09 are:
 ;;    (1)  Length of .01 (NAME) increased from 30 to 50;
 ;;    (2)  Field .04, ICD DIAGNOSIS, is added;
 ;;    (3)  Field .049, ICD DESCRIPTION, is added (this is a
 ;;         computed field, which retrieves the description
 ;;         from the ICD DIAGNOSIS file);
 ;;    (4)  Length of 1 (MNEMONIC) increased from 7 to 12;
 ;;    (5)  Pattern match in field 1 input transform
 ;;         (X?1.4UN1"-"1.4UN) is deleted.
 ;;  
 ;;b)  This patch is issued in support of the IHS Health
 ;;    Education Program, National Patient Education Project, as
 ;;    captured and implemented in PCC Data Entry.
 ;;  
 ;;c)  The KIDS transport file for Patch 7 is inclusive of patches
 ;;    1 through 6.  However, the environment check routine for
 ;;    patch 7 will prevent the loading of any or all of patches
 ;;    1 through 6 if they have already been installed on the
 ;;    target system.
