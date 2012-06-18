%AUCNODE ; COUNT ENTRIES IN GLOBAL NODE [ 02/20/87  9:17 AM ]
 ;
 W !!,"This program counts unique values in a global node.",!
LOOP ;
 R !,"Enter global reference like '^DPT(""B"",' ",GBL Q:GBL=""
 S:$E(GBL,$L(GBL))=")" GBL=$E(GBL,1,$L(GBL)-1)
 S:$E(GBL)'="^" GBL="^"_GBL
 S:$F(GBL,"(")<1 GBL=GBL_"("
 I $E(GBL,$L(GBL))'=",",$E(GBL,$L(GBL)-1)'="(",$E(GBL,$L(GBL))'="(" S GBL=GBL_","
 S %CC=0,NXT="" F L=0:0 X "S NXT=$O("_GBL_"NXT))" Q:NXT=""  S %CC=%CC+1 W "."
 W !!,"Count for ",GBL," is ",%CC,!
 G LOOP
