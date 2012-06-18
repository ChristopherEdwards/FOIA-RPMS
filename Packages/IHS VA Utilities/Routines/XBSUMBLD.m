XBSUMBLD ; IHS/ADC/GTH - ROUTINE INTEGRITY CHECK GENERATOR ; [ 10/29/2002   7:42 AM ]
 ;;3.0;IHS/VA UTILITIES;**7,9**;JULY 9, 1999
 ; XB*3*9 IHS/SET/GTH XB*3*9 10/29/2002 Cache' mods.
 ;
 ; This routine requests the user to select a set of routines and
 ; generates an integrity checking routine for the selected routines.
 ; The user is asked to enter the name of the generated routine.
 ;
 ; The VA's equivalent routine is XTSUMBLD, which will also create
 ; integrity checking routine(s).
 ;
START ;
 W !,"NOTE:  The VA's equivalent routine is XTSUMBLD, which"
 W !,"       will also create integrity checking routine(s).",!!
 Q:'$$DIR^XBDIR("E")
 NEW BYTE,COUNT,QUIT,RTDATE,RTN,RTNAME,VERSION
 KILL ^UTILITY($J),^TMP("XBSUMBLD",$J)
 D ^XBKVAR
 X ^%ZOSF("RSEL")
 I $O(^UTILITY($J,""))="" D EOJ Q
 S RTNAME=$$DIR^XBDIR("F^5:8^K:X'?1U.U X","Enter name of routine to be generated: ","","","Example: APCDINTG")
 I $D(DIRUT) D EOJ Q
 D CHECKRTN
 I 'Y D EOJ Q
 S VERSION=" ;;"_$$DIR^XBDIR("F^1:5^K:'(X?1.2N!(X?1.2N1"".""1.2N)) X","Enter version number","","","Must be n or n.n where the length of n is 1-2")
 I $D(DIRUT) D EOJ Q
 S VERSION=VERSION_";"_$$DIR^XBDIR("FO^2:30","Enter package name")
 I $D(DTOUT)!($D(DUOUT)) D EOJ Q
 ; begin Y2K fix block
 ;S Y=$$DIR^XBDIR("D","Enter date","TODAY")
 S Y=$$DIR^XBDIR("D^::E","Enter date","TODAY") ;Y2000
 ; end Y2K fix block
 I $D(DIRUT) D EOJ Q
 D DD^%DT
 S RTDATE=Y,VERSION=VERSION_";;"_Y
 F %=1:1:11 S X=$P($T(@("LINE"_%)),";;",2,99),@("XBSUMBLD("_%_")=X")
 F %=1:1:3 S X=$P($T(@("CODE"_%)),";;",2,99),@("XBSUMBLD(""CODE"_%_""")=X")
 KILL %,X,Y
 X XBSUMBLD(1)
 Q
 ;
CHECKRTN ;
 S Y=1,X=RTNAME
 X ^%ZOSF("TEST")
 E  Q
 S Y=$$DIR^XBDIR("YO","Routine already exists.  Want to recreate it","NO")
 I $D(DIRUT) S Y=0
 Q
 ;
EOJ ;
 KILL %,DTOUT,DUOUT,DIRUT,DIROUT,X,XBSUMBLD,Y,^UTILITY($J)
 Q
 ;IHS/SET/GTH XB*3*9 10/29/2002 LINE2 mod'd seed of RTN from "" to 0.
 ; The only good thing I can say about the following is that it works.
LINE1 ;;X XBSUMBLD(2),XBSUMBLD(6),XBSUMBLD(11)
LINE2 ;;S RTN=0 F  S RTN=$O(^UTILITY($J,RTN)) Q:RTN=""  W !,RTN ZL @RTN S (BYTE,COUNT)=0 S X=$T(+1),X=$P(X," [ ",1) X XBSUMBLD(4),XBSUMBLD(3),XBSUMBLD(5)
LINE3 ;;F I=2:1 S X=$T(+I) Q:X=""  X XBSUMBLD(4)
LINE4 ;;F J=1:1 S Y=$E(X,J) Q:Y=""  S BYTE=BYTE+1,COUNT=COUNT+$A(Y)
LINE5 ;;S ^TMP("XBSUMBLD",$J,RTN)=BYTE_"^"_COUNT
LINE6 ;;ZR  S X=RTNAME_" ;INTEGRITY CHECKER;"_RTDATE ZI X ZI VERSION ZI " ;" ZI "START ;" ZI " NEW BYTE,COUNT,RTN" ZI " K ^UTILITY($J)" X XBSUMBLD(7),XBSUMBLD(8),XBSUMBLD(9),XBSUMBLD(10) ZS @RTNAME
LINE7 ;;F I=1:1:3 S V="CODE"_I S Z=XBSUMBLD(V) Q:Z=""  ZI Z
LINE8 ;;ZI " Q" ZI " ;" ZI "LINE1 ;;X XBSUMBLD(2),XBSUMBLD(6)" F I=2:1:4 S Z="LINE"_I_" ;;"_XBSUMBLD(I) ZI Z
LINE9 ;;ZI "LINE5 ;;S B=$P(^UTILITY($J,RTN),""^"",1),C=$P(^(RTN),""^"",2) I B'=BYTE!(C'=COUNT) W ""  has been modified""" ZI "LINE6 ;;K XBSUMBLD,B,C,I,J,R,X,Y" ZI " ;" ZI "LIST ;"
LINE10 ;;S RTN="" F  S RTN=$O(^TMP("XBSUMBLD",$J,RTN)) Q:RTN=""  S Z=^(RTN),Z=" ;;"_RTN_"^"_Z ZI Z
LINE11 ;;K %,XBSUMBLD,DTOUT,DUOUT,DIRUT,DIROUT,I,J,V,X,Y,Z,^UTILITY($J),^TMP("XBSUMBLD",$J)
CODE1 ;; F I=1:1 S X=$T(LIST+I) Q:X=""  S X=$P(X,";;",2),R=$P(X,"^",1),B=$P(X,"^",2),C=$P(X,"^",3),^UTILITY($J,R)=B_"^"_C
CODE2 ;; F I=1:1:6 S X=$P($T(@("LINE"_I)),";;",2,99),@("XBSUMBLD("_I_")=X")
CODE3 ;; X XBSUMBLD(1)
