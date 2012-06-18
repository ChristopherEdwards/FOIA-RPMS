AUTP6PRE ; IHS/ASDST/GTH - AUT 98.1 PATCH 6 ENVIRON CHECK ; [ 09/21/2000  2:18 PM ]
 ;;98.1;IHS DICTIONARIES (POINTERS);**6**;MAR 04, 1998
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
 ; If patches 1-5 have already been installed, don't load them.
 I $G(XPDENV)=0 D  ; Run only during Load of Installation.
 . NEW DA
 . S DA(1)=+Y ; Y is set from previous DIC lookup into PACKAGE.
 . S DA=$O(^DIC(9.4,DA(1),22,"B",98.1,0))
 . F %=1:1:5 I $D(^DIC(9.4,DA(1),22,DA,"PAH","B",%)) S XPDQUIT("AUT*98.1*"_%)=1
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
AUTP6MSG ;
 ;;AUT*98.1*6, Control Number in INSURER
 ;;Greetings.  You are receiving this message because you are a
 ;;programmer or hold specific Third Party Billing security keys.
 ;;This is for your information, only.  You need not do anything
 ;;in response to this message.
 ;;  
 ;;Questions can be directed to the Help Desk
 ;;
 ;;  
 ;; --- AUT v 98.1, Patch 6, has been installed into this uci ---
HELLO ;;  
 ;;AUT v 98.1, Patch 6, does the following:
 ;;  
 ;;(1)  Modifies the field definition of field CONTROL NUMBER in the
 ;;INSURER file.  The field type is changed from NUMERIC to FREE TEXT,
 ;;to allow entry of Alpha characters into this field.  This will
 ;;enable use of this field for support of clearing houses like ENVOY.
 ;;  
 ;;(2)  Modifies the PCC FILE CONVERSION DONE field in the RPMS SITE
 ;;file so that the field is uneditable.
 ;;  
 ;;This patch is issued in support of the Third Party Billing
 ;;and PCC applications.
