XBINTEG ; ROUTINE INTEGRITY CHECK 
 ;;2.6;IHS UTILITIES;;JUN 28, 1993
 ;
 ; This routine calls ^%RSEL to select a set of routines and generates
 ; an integrity checking routine for the selected routines.  The user
 ; is asked to enter the name of the generated routine.
 ;
START ;
 NEW BYTE,COUNT,QUIT,RTDATE,RTN,RTNAME,VERSION
 K ^UTILITY($J),^UTILITY("XBINTEG",$J)
 D ^XBKVAR
 ;D ^%RSEL K QUIT
 X ^%ZOSF("RSEL")
 I $O(^UTILITY($J,""))="" D EOJ Q
 S DIR(0)="F^5:8^K:X'?1U.U X",DIR("A")="Enter name of routine to be generated: ",DIR("?")="Example: APCDINTG" D ^DIR K DIR
 I $D(DIRUT) D EOJ Q
 S RTNAME=Y
 D CHECKRTN
 I 'Y D EOJ Q
 S DIR(0)="F^1:5^K:'(X?1.2N!(X?1.2N1"".""1.2N)) X",DIR("A")="Enter version number",DIR("?")="Must be n or n.n where the length of n is 1-2" D ^DIR K DIR
 I $D(DIRUT) D EOJ Q
 S VERSION=" ;;"_X
 S DIR(0)="FO^2:30",DIR("A")="Enter package name" D ^DIR K DIR
 I $D(DTOUT)!($D(DUOUT)) D EOJ Q
 S VERSION=VERSION_";"_X
 S DIR(0)="D",DIR("A")="Enter date",DIR("B")="TODAY" D ^DIR K DIR
 I $D(DIRUT) D EOJ Q
 D DD^%DT
 S RTDATE=Y
 S VERSION=VERSION_";;"_Y
 F %=1:1:11 S X=$P($T(@("LINE"_%)),";;",2,99),@("XBINTEG("_%_")=X")
 F %=1:1:3 S X=$P($T(@("CODE"_%)),";;",2,99),@("XBINTEG(""CODE"_%_""")=X")
 K %,X,Y
 X XBINTEG(1)
 Q
 ;
CHECKRTN ;
 S Y=1
 Q:'$D(^DD("OS"))#2
 Q:'$D(^DD("OS",^DD("OS"),18))#2
 S X=RTNAME X ^(18)
 E  Q
 S DIR(0)="YO",DIR("A")="Routine already exists.  Want to recreate it",DIR("B")="NO" D ^DIR K DIR
 I $D(DIRUT) S Y=0 Q
 Q
 ;
EOJ ;
 K %,X,Y,XBINTEG,^UTILITY($J)
 K DTOUT,DUOUT,DIRUT,DIROUT
 Q
 ;
 ; The only good thing I can say about the following is that it works.
LINE1 ;;X XBINTEG(2),XBINTEG(6),XBINTEG(11)
LINE2 ;;S RTN="" F  S RTN=$O(^UTILITY($J,RTN)) Q:RTN=""  W !,RTN ZL @RTN S (BYTE,COUNT)=0 S X=$T(+1),X=$P(X," [ ",1) X XBINTEG(4),XBINTEG(3),XBINTEG(5)
LINE3 ;;F I=2:1 S X=$T(+I) Q:X=""  X XBINTEG(4)
LINE4 ;;F J=1:1 S Y=$E(X,J) Q:Y=""  S BYTE=BYTE+1,COUNT=COUNT+$A(Y)
LINE5 ;;S ^UTILITY("XBINTEG",$J,RTN)=BYTE_"^"_COUNT
LINE6 ;;ZR  S X=RTNAME_" ;INTEGRITY CHECKER;"_RTDATE ZI X ZI VERSION ZI " ;" ZI "START ;" ZI " NEW BYTE,COUNT,RTN" ZI " K ^UTILITY($J)" X XBINTEG(7),XBINTEG(8),XBINTEG(9),XBINTEG(10) ZS @RTNAME
LINE7 ;;F I=1:1:3 S V="CODE"_I S Z=XBINTEG(V) Q:Z=""  ZI Z
LINE8 ;;ZI " Q" ZI " ;" ZI "LINE1 ;;X XBINTEG(2),XBINTEG(6)" F I=2:1:4 S Z="LINE"_I_" ;;"_XBINTEG(I) ZI Z
LINE9 ;;ZI "LINE5 ;;S B=$P(^(RTN),""^"",1),C=$P(^(RTN),""^"",2) I B'=BYTE!(C'=COUNT) W ""  has been modified""" ZI "LINE6 ;;K XBINTEG,B,C,I,J,R,X,Y" ZI " ;" ZI "LIST ;"
LINE10 ;;S RTN="" F  S RTN=$O(^UTILITY("XBINTEG",$J,RTN)) Q:RTN=""  S Z=^(RTN),Z=" ;;"_RTN_"^"_Z ZI Z
LINE11 ;;K %,XBINTEG,DTOUT,DUOUT,DIRUT,DIROUT,I,J,V,X,Y,Z,^UTILITY($J),^UTILITY("XBINTEG",$J)
CODE1 ;; F I=1:1 S X=$T(LIST+I) Q:X=""  S X=$P(X,";;",2),R=$P(X,"^",1),B=$P(X,"^",2),C=$P(X,"^",3),^UTILITY($J,R)=B_"^"_C
CODE2 ;; F I=1:1:6 S X=$P($T(@("LINE"_I)),";;",2,99),@("XBINTEG("_I_")=X")
CODE3 ;; X XBINTEG(1)
