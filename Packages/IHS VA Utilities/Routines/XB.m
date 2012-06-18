XB ; IHS/ADC/GTH - UTILITY MENU ; [ 04/28/2003  9:38 AM ]
 ;;3.0;IHS/VA UTILITIES;**9**;FEB 07, 1997
 ;
 ; SEE ROUTINE XB1 FOR FURTHER DOCUMENTATION AND THE MENU
 ; OPTIONS.
 ;
 ; This routine lists available utilities in the form of a
 ; menu with a brief description of what the utility does.
 ; New utilities may be added to this routine by adding the
 ; appropriate ";;" entries to the bottom of routine XB1.
 ;
START ;
 I '$D(^%ZOSF("TEST"))!('$D(^%ZOSF("TRAP"))) W !!,"Missing ^%ZOSF nodes!",! Q
 S X="%ZIS"
 D RCHK
 I XBFAIL D EOJ Q
 D ^XBKSET
 S X="XBRPTL"
 D RCHK
 S:XBFAIL XBNH=""
 S XBLBL="M",XBQ=0
 F  D MENU Q:XBQ
 D EOJ
 Q
 ;
MENU ;
 D LIST
 W !!,"Choose: "
 R XBY:$G(DTIME,999)
 S:XBY="^" XBY=""
 I XBY["?" D HELP Q
 I XBY="" S XBQ=1 Q
 I XBY'=+XBY D LETTERS
 I XBY'<1,XBY'>(XBI-1) D OPTION D:XBP="P" PAUSE S XBP="" Q
 W *7
 Q
 ;
HELP ;
 I XBY="?" D  Q
 . S XBH=""
 . D LIST
 . KILL XBH
 . W !!,"To get help on a non-menu option enter '?n' where n is the option number.",!
 . D PAUSE
 .Q
 I XBY?1"?"1N.N S XBY=$P(XBY,"?",2) I XBY,XBY'>(XBI-1) D  D PAUSE Q
 . I $D(XBNH) W !!,"No help available.  Routine ^XBRPTL not in UCI.",! Q
 . KILL ^UTILITY($J)
 . S XBX=$P($T(@XBLBL+XBY^XB1),";;",3)
 . I XBX W !!,"No help available for menus." Q
 . I XBX?1"!".E W !!,"No help available for executable code :",!,"[",$E(XBX,2,99),"]." Q
 . S XBX=$P(XBX,"^",2),X=XBX
 . D RCHK
 . I XBFAIL W !!,"No help available.  Routine ^",XBX," not in ",$S($E(XBX)="%":"MGR",1:"UCI"),".",! Q
 . S %=$$RSEL^ZIBRSEL(XBX,"^UTILITY($J,")
 . D EN^XBRPTL
 . KILL ^UTILITY($J)
 .Q
 W *7
 Q
 ;
LIST ; List menu options.
 KILL XBTBL
 ;W !!?5,$P($T(XB+1),";",4)," v ",$$CV^XBFUNC("XB");IHS/SET/GTH XB*3*9 10/29/2002
 W !!?5,$P($T(XB+1),";",4)," v ",$$VERSION^XPDUTL("XB") ;IHS/SET/GTH XB*3*9 10/29/2002
 W !!?5,$P($T(@XBLBL^XB1),";;",2),!
 F XBI=1:1 S XBX=$T(@XBLBL+XBI^XB1) Q:$E(XBX)'=" "  S XBY=$P(XBX,";;",3),XBX=$P(XBX,";;",2) D
 . S X=$$UP^XLFSTR(XBX)
 . S XBTBL(X)=XBI_"^"_XBX
 . W !,XBI,?5,XBX,"    ",$S($D(XBH):$S(XBY:"[menu]",1:XBY),1:$S(XBY:"[menu]",1:""))
 .Q
 Q
 ;
LETTERS ;
 KILL XBC
 S XBY=$$UP^XLFSTR(XBY)
 I $D(XBTBL(XBY)) S XBY=XBTBL(XBY) Q
 S XBC=0,X=XBY
 F  S X=$O(XBTBL(X)) Q:X=""!($E(X,1,$L(XBY))'=XBY)  S XBC=XBC+1,XBC(XBC)=+XBTBL(X)_"^"_$P(XBTBL(X),"^",2)
 W !
 I XBC=0 S XBY=0 Q
 I XBC=1 S XBY=$P(XBC(1),"^",1) Q
 F I=1:1:XBC W !,I,"  ",$P(XBC(I),"^",2)
 W !!,"Which one? "
 R XBY:$G(DTIME,999)
 I XBY]"",$D(XBC(XBY)) W " ",$P(XBC(XBY),"^",2) S XBY=$P(XBC(XBY),"^",1) Q
 W *7
 S XBY=0
 Q
 ;
OPTION ;
 S XBX=$T(@XBLBL+XBY^XB1),XBP=$P(XBX,";;",4),XBX=$P(XBX,";;",3)
 I XBX D RECURSE Q
 W !
 I XBX?1"!".E S XBX=$E(XBX,2,250)
 E  S X=$P(XBX,"^",2),XBX="D "_XBX D RCHK I XBFAIL W "Routine ",X," not in ",$S($E(X)="%":"MGR!",1:"UCI!") Q
 S X="TRAP^XB",@^%ZOSF("TRAP")
 ; D ^XBNEW("CALL^XB:XBX;DT;DTIME;U;DUZ") ;IHS/SET/GTH XB*3*9 10/29/2002
 D EN^XBNEW("CALL^XB","XBX;DT;DTIME;U;DUZ") ;IHS/SET/GTH XB*3*9 10/29/2002
 Q
 ;
CALL ;
 S IOP=$I
 D ^%ZIS
 X XBX
 U 0
 Q
 ;
RECURSE ;
 I $L(XBLBL)>6 W !,"Maximum menu depth exceeded." S XBQ=1 Q
 S XBLBL=XBLBL_XBX
 W !
 F  D MENU Q:XBQ
 S XBQ=0,XBLBL=$E(XBLBL,1,$L(XBLBL)-1)
 W !
 Q
 ;
TRAP ; ERROR TRAP
 W !!,"The following error has occurred: ",$$Z^ZIBNSSV("ERROR"),!
 D:XBP="" PAUSE
 Q
 ;
PAUSE ;EP
 Q:'(IO=IO(0))
 Q:'($E(IOST,1,2)="C-")
 S Y=$$DIR^XBDIR("EO")
 S:$D(DUOUT) XBQ=1
 Q
 ;
CHECK ; CHECK XB OPTION ROUTINES (EXECUTED FROM ^XB MENU OPTION)
 W !,"Patch ",$$PATS," is the highest XB/ZIB patch installed." ;IHS/SET/GTH XB*3*9 10/29/2002
 F XBII=1:1 S X=$T(M+XBII^XB1) Q:X=""  I $P(X,";;",1)=" " S X=$P(X,";;",3) I X'=+X,X'?1"!".E D
 . I X'?.8UN1"^"1.8UN,X'?.8UN1"^"1"%"1.7UN S XBII(4,XBII)=$P($T(M+XBII^XB1),";;",2,9) Q
 . S X=$P(X,"^",2)
 . D RCHK
 . I XBFAIL S XBII($S($E(X)'="%":1,$E(X,2,4)="ZIB":2,1:3),X)=""
 .Q
 I '$O(XBII(0)) W !,"All options seem to be ok.",! KILL XBII Q
 I $D(XBII(1)) W !,"The following routines are not in this UCI:" S X="" F  S X=$O(XBII(1,X)) Q:X=""  W !?3,X
 I $D(XBII(2)) W !,"The following ZIB* routines must be moved to MGR as % routines:" S X="" F  S X=$O(XBII(2,X)) Q:X=""  W !?3,X
 I $D(XBII(3)) W !,"The following % routines are not in ",$S($$VERSION^%ZOSF(1)["Cache":"this Namespace",1:"MGR"),":" S X="" F  S X=$O(XBII(3,X)) Q:X=""  W !?3,X ;IHS/SET/GTH XB*3*9 10/29/2002
 I $D(XBII(4)) W !,"The following options have invalid routine names:" S X="" F  S X=$O(XBII(4,X)) Q:X=""  W !?3,XBII(4,X)
 W !
 KILL XBII
 Q
 ;
RCHK ;EP - Check Existence of Routine in X
 S XBRTN=X,XUSLNT=1
 ; I $E(XBRTN)="%" X ^%ZOSF("UCI") S XBUCI=Y,%UCI="MGR" D 2^%XUCI ; IHS/SET/GTH XB*3*9 10/29/2002
 I ^%ZOSF("OS")["MSM",$E(XBRTN)="%" X ^%ZOSF("UCI") S XBUCI=Y,%UCI="MGR" D 2^%XUCI ; IHS/SET/GTH XB*3*9 10/29/2002
 S X=XBRTN
 X ^%ZOSF("TEST")
 S XBFAIL='$T
 ; I $E(XBRTN)="%" S %UCI=XBUCI D 2^%XUCI ; IHS/SET/GTH XB*3*9 10/29/2002
 I ^%ZOSF("OS")["MSM",$E(XBRTN)="%" S %UCI=XBUCI D 2^%XUCI ; IHS/SET/GTH XB*3*9 10/29/2002
 W:XBFAIL !!,"Routine ",XBRTN," missing!"
 S X=XBRTN
 KILL XUSLNT
 Q
 ;
EOJ ;
 D ^XBKTMP,EN^XBVK("XB")
 KILL ^UTILITY($J)
 KILL DIRUT,DTOUT,DUOUT
 KILL X,Y
 Q
 ;
OSNO ;EP
 W $C(7),!,"Sorry...",!,"Operating System '",$P(^%ZOSF("OS"),"^",1),"' is not supported."
 I $$DIR^XBDIR("EO","Press RETURN") ;IHS/SET/GTH XB*3*9 10/29/2002
 Q
 ;
 ;Begin New Code;IHS/SET/GTH XB*3*9 10/29/2002
PATS() ;Display patches installed for XB.    
 NEW I,P,V
 S I=$O(^DIC(9.4,"C","XB",0))
 Q:'I "??"
 S V=$O(^DIC(9.4,I,22,"B",$P($T(+2),";",3),0))
 Q:'V "??"
 S P=0
 F %=0:0 S %=$O(^DIC(9.4,I,22,V,"PAH",%)) Q:'%  I $P(^(%,0),"^",1)>P S P=$P(^(0),"^",1)
 Q P
 ;End New Code;IHS/SET/GTH XB*3*9 10/29/2002
