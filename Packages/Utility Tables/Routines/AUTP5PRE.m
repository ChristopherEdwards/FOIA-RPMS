AUTP5PRE ; IHS/ASDST/GTH - AUT 98.1 PATCH 5 ENVIRON CHECK ; [ 02/10/2000  1:36 PM ]
 ;;98.1;IHS DICTIONARIES (POINTERS);**5**;MAR 04, 1998
 ;
 I '$G(DUZ) W !,"DUZ UNDEFINED OR 0." D SORRY Q
 ;
 I '$L($G(DUZ(0))) W !,"DUZ(0) UNDEFINED OR NULL." D SORRY Q
 ;
 S X=$P(^VA(200,DUZ,0),U)
 W !!,$$C("Hello, "_$P(X,",",2)_" "_$P(X,",")),!
 F %=1:1 S X=$P($T(HELLO+%),";",3) Q:X=""  W !?5,X
 ;
 W !!,$$C("Checking Environment for "_$P($T(+2),";",4)_" V "_$P($T(+2),";",3)_" Patch "_$P($T(+2),";",5)_".")
 ;
 S X=$G(^DIC(9.4,$O(^DIC(9.4,"C","AUT",0)),"VERSION"))
 W !!,$$C("Need AUT v 98.1.....AUT v "_X_" Present")
 I X<98.1 D SORRY Q
 ;
 S X=$G(^DD("VERSION"))
 W !,$$C("Need at least FileMan 21.....FileMan "_X_" Present")
 I X<21 D SORRY Q
 ;
 S X=$G(^DIC(9.4,$O(^DIC(9.4,"C","XU",0)),"VERSION"))
 W !,$$C("Need at least Kernel 8.....Kernel "_X_" Present")
 I X<8 D SORRY Q
 ;
 NEW DA,DIC
 S X="AUT",DIC="^DIC(9.4,",DIC(0)="",D="C"
 D IX^DIC
 I Y<0,$D(^DIC(9.4,"C","AUT")) D  Q
 . W !!,*7,*7,$$C("You Have More Than One Entry In The"),!,$$C("PACKAGE File with an ""AUT"" prefix.")
 . W !,$$C("One entry needs to be deleted.")
 . W !,$$C("FIX IT! Before Proceeding."),!!,*7,*7,*7
 . D SORRY
 . I $$DIR^XBDIR("E")
 .Q
 W !,$$C("No 'AUT' dups in PACKAGE file")
 ;
 W !!,$$C("ENVIRONMENT OK.")
 I '$$DIR^XBDIR("E","","","","","",1) KILL DIFQ Q
 Q
 ;
C(X,Y) ; Center X in field length Y/IOM/80.
 Q $J("",$S($D(Y):Y,$G(IOM):IOM,1:80)-$L(X)\2)_X
 ;
SORRY ;
 KILL DIFQ
 W *7,!,$$C("Sorry....")
 Q
 ;
AUTP5MSG ;
 ;;AUT*98.1*5, modify YTD PAID field in VENDOR file.
 ;;Greetings.  You are receiving this message because you are a
 ;;programmer or are a manager of the ARMS or CHS applications.
 ;;This is for your information, only.  You need not do anything
 ;;in response to this message.
 ;;  
 ;;Questions can be directed to the Help Desk
 ;;
 ;;  
 ;; --- AUT v 98.1, Patch 5, has been installed into this uci ---
HELLO ;;  
 ;;AUT v 98.1, Patch 5, modifies the field definition of field
 ;;YTD PAID in the VENDOR file, to increase the allowable values in
 ;;the field from a penny short of one million dollars (999999.99)
 ;;to a penny short of one billion dollars (999999999.99).
 ;;  
 ;;The ARMS and CHS applications are the primary users of the VENDOR
 ;;file.  This patch is issued in support of processing the forms
 ;;1099s in ARMS for CY 1999, scheduled for late January 2000.
