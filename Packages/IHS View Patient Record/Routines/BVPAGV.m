BVPAGV ; IHS/ITSC/LJF - PATIENT DATA VIEW ;
 ;;1.0;VIEW PATIENT RECORD;;NOV 17, 2004
 ;Copy of AGSEENLY, modified to remove user interaction
 ;IHS/ITSC/LJF 08/21/2003 added L2 line label and changed references from L1 to L2
 ;
 D ^AGVAR
L1 ;D ^AG W !!!?27,"Patient Data View System",!!
 ;D PTLK^AG
 I $D(DFN) S AGSEENLY="",AGPAGE=1 G L5
L2 ;Added line label
 K AG,AGSEENLY,DIC,AG("LKDATA"),AG("LKERR"),AG("LKPRINT"),AGPAGE
 Q
L5 ;
 D @($P($T(@AGPAGE),";;",2)) W !,AGLINE("EQ")
 I AGPAGE<10 S DIR("A")="                               Press RETURN " D READ
 ;G L1:$D(DTOUT)!$D(DFOUT)
 G L2:$D(DTOUT)!$D(DFOUT)
 ;I $D(DUOUT) S AGPAGE=AGPAGE-1 G L5:AGPAGE>0,L1
 I $D(DUOUT) S AGPAGE=AGPAGE-1 G L5:AGPAGE>0,L2
 I $D(AG("ED")) S AGPAGE=AG("ED") G L5
 ;S AGPAGE=AGPAGE+1 G L5:AGPAGE<10,L1
 S AGPAGE=AGPAGE+1 G L5:AGPAGE<10,L2
READ ;
 K DFOUT,DTOUT,DUOUT,DQOUT,DLOUT,AG("ED"),AG("ERR"),DIROUT
 S DIR(0)="FO^1:3"
 D ^DIR
 Q:$D(DTOUT)
 S:Y="/.,"!(Y="^^") DFOUT=""
 S:Y="" DLOUT=""
 S:Y="^" (DUOUT,Y)=""
 S:Y?1"?".E!(Y["^") (DQOUT,Y)=""
 I $E(Y,1)="P" D
 . S AG("ED")=+$E(Y,2,99)
 . I AG("ED")<1!(AG("ED")>9) D
 .. W *7,!!,"Use only pages 1 through 9."
 .. H 2
 .. K AG("ED")
 .. S AG("ERR")=""
 Q
1 ;;^AGED1
2 ;;DRAW^AGED2
3 ;;DRAW^AGED3
4 ;;^AGED4A
5 ;;^AGED4B
6 ;;^AGED13
7 ;;^AGED8
8 ;;^AGED11
9 ;;^AGED11A
