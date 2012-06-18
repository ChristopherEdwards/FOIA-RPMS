XBPRE ; IHS/ADC/GTH - PREINIT, CHK RQMNTS, ETC. ; [ 01/22/2001  11:54 AM ]
 ;;3.0;IHS/VA UTILITIES;**8**;FEB 07, 1997
 ; XB*3*8 - IHS/ASDST/GTH Add KIDS check to suppress questions.
 ;
 I '$G(DUZ) W !,"DUZ UNDEFINED OR 0." D SORRY Q
 ;
 I '$L($G(DUZ(0))) W !,"DUZ(0) UNDEFINED OR NULL." D SORRY Q
 ;
 S X=$P(^VA(200,DUZ,0),U)
 W !!,$$C("Hello, "_$P(X,",",2)_" "_$P(X,",")),!!,$$C("Checking Environment for Version "_$P($T(+2),";",3)_" of XB/ZIB.")
 ;
 S X=$G(^DD("VERSION"))
 W !!,$$C("Need at least FileMan 20.....FileMan "_X_" Present")
 I X<20 D SORRY Q
 ;
 S X=$G(^DIC(9.4,$O(^DIC(9.4,"C","XU",0)),"VERSION"))
 W !!,$$C("Need at least Kernel 7.....Kernel "_X_" Present")
 I X<7 D SORRY Q
 ;
 S X=$S($L($T(STATUS^%ZISH)):"STATUS^%ZISH is Present",1:"")
 W !!,$$C("Need Patch 25 to Kernel 7 (^%ZISH)....."_X)
 I '$L($T(STATUS^%ZISH)) D SORRY Q
 ;
 NEW DA,DIC
 S X="XB",DIC="^DIC(9.4,",DIC(0)="",D="C"
 D IX^DIC
 I Y<0,$D(^DIC(9.4,"C","XB")) D  Q
 . W !!,*7,*7,$$C("You Have More Than One Entry In The"),!,$$C("PACKAGE File with an ""XB"" prefix.")
 . W !,$$C("One entry needs to be deleted.")
 . W !,$$C("FIX IT! Before Proceeding."),!!,*7,*7,*7
 . D SORRY
 . I $$DIR^XBDIR("E")
 .Q
 W !!,$$C("No 'XB' dups in PACKAGE file")
 ;
 W !!,$$C("ENVIRONMENT OK.")
 I $D(DIFQ),'$$DIR^XBDIR("E","","","","","",2) KILL DIFQ
 ; The following line prevents the "Disable Options..." and "Move ; XB*3*8 - IHS/ASDST/GTH
 ; Routines..." questions from being asked during the install. ; XB*3*8 - IHS/ASDST/GTH
 I $G(XPDENV)=1 S (XPDDIQ("XPZ1"),XPDDIQ("XPZ2"))=0 ; XB*3*8 - IHS/ASDST/GTH
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
