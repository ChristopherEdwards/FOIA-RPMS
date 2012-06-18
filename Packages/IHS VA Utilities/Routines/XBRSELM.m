%RSEL ;DJM;ROUTINE SELECTOR;  
 ;;2.6;IHS UTILITIES;;JUN 28, 1993
 ;COPYRIGHT MICRONETICS DESIGN CORP. @1985
 ;IHS/THL MODIFIED TO ALLOW ROUTINE SELECTION BY DATE LAST EDITED
 S $ZT="ERROR^%RSEL"
INT ;
 N %P,%RN,%RS,%RSN,FIRST,LAST,X S %RSN=0
L0 ;
 R !!,"Routine selector: ",%RS:$S($D(DTIME):DTIME,1:999)
 I %RS="."!(%RS=" "),%RSN=0 D LIST S %RSN=1 G L0
 I %RS="^L"!(%RS="^l") D:%RSN LIST G L0
 I %RS="^"!(%RS="^Q")!(%RS="^q") K ^UTILITY($J) G EXIT
 I %RS="" K:%RSN=0 ^UTILITY($J) G EXIT
 I %RS="^D"!(%RS="^d") D DISPLAY G L0
 I %RS="?" D HELP G L0
L1 ;
 I %RSN=0 K ^UTILITY($J) S %RSN=1
 G:$E(%RS)="-" DEL
 S %P=$$%SRCHPAT^%SRCHPAT(%RS)
 I $D(FIRST)=0 W *7,"  ...Invalid routine name selection criteria, Specify '?' for help" G L0
 S %RN=0,X=FIRST D:FIRST'=""
 .Q:$D(^ (X))=0  Q:X]LAST  X %P S:$T %RN=%RN+1,^UTILITY($J,FIRST)=""
 F  S X=$O(^ (X)) Q:X=""!(X]LAST)  X %P S:$T %RN=%RN+1,^UTILITY($J,X)=""
 W !!,?10,%RN," routine",$S(%RN=1:"",1:"s")," selected." W:%RN=0 *7
 G L0
DEL ;
 S %P=$$%SRCHPAT^%SRCHPAT($E(%RS,2,$L(%RS))),%RN=0
 I $D(FIRST)=0 W *7,"  ...Invalid routine name selection criteria, Specify '?' for help" G L0
 S %RN=0,X=FIRST D:FIRST'=""
 .Q:$D(^UTILITY($J,X))=0  Q:X]LAST  X %P I $T S %RN=%RN+1 K ^UTILITY($J,X)
 F  S X=$O(^UTILITY($J,X)) Q:X=""!(X]LAST)  X %P I $T S %RN=%RN+1 K ^UTILITY($J,X)
 W !!,?10,%RN," routine",$S(%RN=1:"",1:"s")," de-selected." W:%RN=0 *7
 G L0
DOTS W $E("..............................",1,24-$X) Q
EXIT ;
IHS1 I $D(^UTILITY($J)) D DATE I $D(XB) X XB W !!?10,%RN," routines edited after ",XBDAT D OUT ;IHS/THL ALLOWS SELECTION OF ROUTINES BY DATE LAST EDITED
 S:'$D(^UTILITY($J)) QUIT="" Q
LIST ;
 I $D(^UTILITY($J))<10 W !,"No routines selected" Q
 W !! S %RN=0,%RS=-1 F X=1:1 S %RS=$N(^UTILITY($J,%RS)) Q:%RS<0  W:'(X-1#8) ! W ?(X-1)#8*10,%RS S %RN=%RN+1
 W !!,?10,%RN," routine",$S(%RN=1:"",1:"s")," selected so far.",!
 Q
DISPLAY ;
 W !! S %RN=0,%RS="" F X=1:1 S %RS=$O(^ (%RS)) Q:%RS=""  W:'(X-1#8) ! W ?(X-1)#8*10,%RS S %RN=%RN+1
 W !!,?10,%RN," routine",$S(%RN=1:"",1:"s"),"."
 Q
ERROR ;
 I $F($ZE,"<INRPT>") U 0 W !!,"...Aborted." D EXIT V 0:$J:$ZB($V(0,$J,2),#0400,7):2
 ZQ
HELP ;
 W !,"Respond with routine selection criteria.",!,"Valid responses:"
 W !?5,"Routine name" D DOTS W "Eg: ABC"
 W !?5,"Routine range" D DOTS W "Eg: AAA-HZZZ"
 W !?5,"Routine pattern" D DOTS W "Eg: PROG?  PRG*AA  A*C?D  *XYZ  ?"
 W !?24,"Where '?' matches any single character,"
 W !?24,"and '*' matches zero or more characters"
 W !?5,"All routines" D DOTS W "    *     (selects ALL routines)"
 W !,"Precede any of the above with a '-' to unselect previously selected routines."
 W:%RSN=0 !,"Enter '.' or ' ' to retain previously selected range(s)."
 W !,"Enter '^L' for display of previously selected routines."
 W !,"Enter '^D' to display all routine names."
 W !,"Enter '^' or '^Q' to exit."
 Q
DATE ;IHS/THL ALLOWS SELECTION OF ROUTINES BY DATE LAST EDITED
 R !!,"Screen ROUTINES by date last edited? NO// ",X:300 Q:'$T
 I "^N"[$E(X)!(X="") W !!,"No date selected." Q
 I "^Y?N"'[$E(X)!("?"[$E(X)) W !!,"Type 'Y'es to select ROUTINES edited on or after a specified date.",!,"Type '^' or strike <RETURN> to continue without selecting by date." G DATE
 I X'="" D  Q
 .S %DN=$H
 .D ^%DO
 .S %DT("B")=%DS,%DT="AEQ",%DT("A")="ROUTINES last edited on or after: "
 .W ! D ^%DT
 .I Y<1 D OUT Q
 .S XBX=$T(XBX),XBX=$P(XBX,";;",2)
 .X XBX
 .S (XBDAT,%DS)=Y D ^%DI
 .D:%DN&'$D(%ER)
 ..S DN1=%DN
 ..S XB=$T(XB),XB=$P(XB,";;",2)
 ..S XB1=$T(XB1),XB1=$P(XB1,";;",2)
 .D:$D(%ER) OUT
 Q
XB ;;S %RN=0,(RTN,%DN)="" F  S RTN=$O(^UTILITY($J,RTN)) Q:RTN=""  ZL @RTN X XB1 D:%DS?1.2N1"/"1.2N1"/"2N ^%DI K:$D(%ER)!'%DN!(%DN<(DN1)) ^UTILITY($J,RTN) K %ER I %DN>(DN1-1) D ^%DO W !,RTN,?10,"last edited on ",%DS S %RN=%RN+1
XB1 ;;S X=$T(@RTN),X=$P($P(X,";",2,99)," ",2,99) F I=1:1:$L(X," ") S %DS=$P(X," ",I) Q:%DS?1.2N1"/"1.2N1"/"2N
XBX ;;S:Y Y=$S($E(Y,4,5):$P("JAN^FEB^MAR^APR^MAY^JUN^JUL^AUG^SEP^OCT^NOV^DEC","^",+$E(Y,4,5))_" ",1:"")_$S($E(Y,6,7):+$E(Y,6,7)_",",1:"")_($E(Y,1,3)+1700)
OUT K %DT,XB,XB1,%RN,XBX,DN1,RTN,X,Y,%DA,%DN,%DS,I,XBDAT Q
