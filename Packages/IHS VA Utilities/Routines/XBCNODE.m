XBCNODE ; IHS/ADC/GTH - COUNT ENTRIES IN GLOBAL NODE ; [ 02/07/97   3:02 PM ]
 ;;3.0;IHS/VA UTILITIES;;FEB 07, 1997
 ;
 ; This program counts unique values in a selected global
 ; node.
 ;
START ;
 NEW GBL,CC,NXT,L
 W !!,"This program counts unique values in a global node.",!
LOOP ;
 R !,"Enter global reference like '^DPT(""B"",' ",GBL:$G(DTIME,300)
 Q:GBL=""
 S:$E(GBL,$L(GBL))=")" GBL=$E(GBL,1,$L(GBL)-1)
 S:$E(GBL)'="^" GBL="^"_GBL
 S:$F(GBL,"(")<1 GBL=GBL_"("
 I $E(GBL,$L(GBL))'=",",$E(GBL,$L(GBL)-1)'="(",$E(GBL,$L(GBL))'="(" S GBL=GBL_","
 S CC=0,NXT=""
 F L=0:0 X "S NXT=$O("_GBL_"NXT))" Q:NXT=""  S CC=CC+1 W:'(CC#50) "."
 W !!,"Count for ",GBL," is ",CC,!
 G LOOP
 ;
