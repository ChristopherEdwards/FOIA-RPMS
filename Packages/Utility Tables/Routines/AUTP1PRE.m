AUTP1PRE ; IHS/ASDST/GTH - PREINIT, CHK RQMNTS, ETC. ; [ 06/28/1999  2:45 PM ]
 ;;98.1;IHS DICTIONARIES (POINTERS);**2**;MAR 04, 1998
 ;
 I '$G(DUZ) W !,"DUZ UNDEFINED OR 0." D SORRY Q
 ;
 I '$L($G(DUZ(0))) W !,"DUZ(0) UNDEFINED OR NULL." D SORRY Q
 ;
 S X=$P(^VA(200,DUZ,0),U)
 W !!,$$C("Hello, "_$P(X,",",2)_" "_$P(X,",")),!!,$$C("Checking Environment for Version "_$P($T(+2),";",3)_" of "_$P($T(+2),";",4)_".")
 ;
 S X=$G(^DIC(9.4,$O(^DIC(9.4,"C","AUT",0)),"VERSION"))
 W !!,$$C("Need AUT v 98.1.....AUT v "_X_" Present")
 I X<98.1 D SORRY Q
 ;
 S X=$G(^DD("VERSION"))
 W !!,$$C("Need at least FileMan 21.....FileMan "_X_" Present")
 I X<21 D SORRY Q
 ;
 S X=$G(^DIC(9.4,$O(^DIC(9.4,"C","XU",0)),"VERSION"))
 W !!,$$C("Need at least Kernel 8.....Kernel "_X_" Present")
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
 . I $$DIR^AUTDIR("E")
 .Q
 W !!,$$C("No 'AUT' dups in PACKAGE file")
 ;
 W !!,$$C("ENVIRONMENT OK.")
 I $D(DIFQ),'$$DIR^AUTDIR("E","","","","","",2) KILL DIFQ
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
