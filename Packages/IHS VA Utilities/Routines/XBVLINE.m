XBVLINE ; IHS/ADC/GTH - SET LINE TWO OF SELECTED ROUTINES ; [ 10/29/2002   7:42 AM ]
 ;;3.0;IHS/VA UTILITIES;**7,9**;JULY 9, 1999
 ; XB*3*9 IHS/SET/GTH XB*3*9 10/29/2002 Cache' mods.
 ;
 ; This routine asks user to select a set of routines, asks
 ; the user for the version number, package, and the date,
 ; and sets the second line of each routine.
 ;
 ; The form of the version line will be as follows:
 ;
 ;;n;package name;patch level;date    E.G.
 ;;1.1;PCC DATA ENTRY;**1,2**;Sep 9, 1989
 ;
START ;
 NEW ASK,QUIT,RTN
 KILL ^UTILITY($J)
 D ^XBKVAR
 X ^%ZOSF("RSEL")
 I $D(^UTILITY($J,"XBVLINE")) W !,"Can't do ^XBVLINE.  Deleting." KILL ^UTILITY($J,"XBVLINE")
 I $D(^UTILITY($J,"XB")) W !,"Can't do ^XB.  Deleting." KILL ^UTILITY($J,"XB")
 I $O(^UTILITY($J,""))="" D EOJ Q
 S XBVLINE=" ;;"_$$DIR^XBDIR("F^1:5^K:'(X?1.3N!(X?1.3N.1""."".2N.1A.2N)) X","Enter version number","","","Must be n or n.n or n.nAn where the length of n is 1-3 and A is an alpha character")
 I $D(DIRUT) D EOJ Q
 S XBVLINE=XBVLINE_";"_$$DIR^XBDIR("FO^2:30","Enter package name")
 I $D(DIRUT) D EOJ Q
 S X=$$DIR^XBDIR("FO^0:20","Enter patch level")
 I $D(DUOUT)!$D(DTOUT) D EOJ Q
 S XBVLINE=XBVLINE_$S(X="":";",1:";**"_X_"**")
 ;begin Y2K fix block
 ;S Y=$$DIR^XBDIR("D","Enter date","TODAY")
 S Y=$$DIR^XBDIR("D^::E","Enter date","TODAY")
 ; end Y2K fix block
 I $D(DIRUT) D EOJ Q
 D DD^%DT
 S XBVLINE=XBVLINE_";"_Y
 S ASK=$$DIR^XBDIR("YO","Do you want to be asked ok for each routine","NO","","If you say 'YES' you will be asked if it is ok before each routine is modified.")
 I $D(DIRUT) D EOJ Q
 F %=1:1:6 S X=$P($T(@("LINE"_%)),";;",2),@("XBVLINE("_%_")=X")
 KILL %,X,Y
 X XBVLINE(1)
 Q
 ;
EOJ ;
 KILL %,X,Y,XBVLINE,^UTILITY($J),DTOUT,DUOUT,DIRUT,DIROUT
 Q
 ;IHS/SET/GTH XB*3*9 10/29/2002 Mod'd LINE2 to seed RTN with 0 vs "".
LINE1 ;;X XBVLINE(2),XBVLINE(5)
LINE2 ;;S QUIT=0,RTN=0 F  S RTN=$O(^UTILITY($J,RTN)) Q:RTN=""  W !,RTN ZL @RTN X XBVLINE(6) ZR @Y ZI X S X=$T(+2),Z=$P(X," ")_XBVLINE X XBVLINE(3):'ASK,XBVLINE(4):ASK Q:QUIT  I X ZI Z:+1 ZS
LINE3 ;;S X=$P(X," ",2,99),X=X?1.2";".1"V"1.N.E ZR:X +2 S X=1
LINE4 ;;W !,X S DIR(0)="S^R:Replace;I:Insert;S:Skip",DIR("B")="R",DIR("?")="Replace the line; Insert before the line; Skip the routine" D ^DIR K DIR ZL @RTN ZR:Y="R" +2 S:$D(DIRUT) Y="S",QUIT=1 S X=Y'="S"
LINE5 ;;K %,XBVLINE,DTOUT,DUOUT,DIRUT,DIROUT,X,Y,Z,^UTILITY($J)
LINE6 ;;S X=$T(+1),X=$P(X,"["),Y=$L(X,";") S Y=$P(X,$S(X?1.8U1"(".E:"(",1:" "),1)
