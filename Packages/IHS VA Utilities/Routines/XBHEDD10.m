XBHEDD10 ;402,DJB,10/23/91,EDD - Pointers From This File and Global Listing
 ;;2.6;IHS UTILITIES;;JUN 28, 1993
 ;;David Bolduc - Togus, ME
PT ;Pointers from this file
 D INIT^XBHEDD7 S HD="HD1" D @HD,PTGET
PTEX ;
 K CNT,NAME,NODE0,NUMBER,ZDD
 Q
PTGET ;
 S ZDD="",CNT=1
 F  S ZDD=$O(^UTILITY($J,"TMP",ZDD)) Q:ZDD=""!(FLAGQ)  S NAME="" F  S NAME=$O(^DD(ZDD,"B",NAME)) Q:NAME=""  S NUMBER="",NUMBER=$O(^DD(ZDD,"B",NAME,"")) D PTLIST Q:FLAGQ
 I CNT=1 W !!!!!?20,"This file has no fields that",!?20,"point to other files."
 Q
PTLIST ;
 Q:^DD(ZDD,"B",NAME,NUMBER)=1  ;If this node equals 1 it is TITLE not NAME
 S NODE0=^DD(ZDD,NUMBER,0) Q:$P(NODE0,U,2)'["P"  Q:$P(NODE0,U,3)']""
 W !?1,$S(ZDD'=ZNUM:"MULT",1:""),?6,$J(NUMBER,8),?16,NAME S FILE="^"_$P(NODE0,U,3)_"0)" W ?48,$S($D(@FILE):$E($P(@FILE,U),1,30),1:"-->No such file")
 S CNT=CNT+1 I $Y>SIZE D PAGE Q:FLAGQ=1
 Q
GL ;List Globals in ASCII order
 D:'$D(^UTILITY("EDD/GL")) HELP
GLTOP D @$S($D(^UTILITY("EDD/GL")):"GLRANGE",1:"GLRANGE1") G:FLAGQ GLEX D INIT S HD="HD" D @HD
 D GLLIST G:FLAGQ GLEX
GLEX ;Global Exit
 K AA,BB,CNT,HD,TEMP,VAR,XXX
 Q
GLRANGE ;Starting and Ending Global
 I FLAGP W !?8,"Enter Global range...Include Starting & Ending Global:"
GLRANGE1 R !?8,"Starting Global: ^",AA:DTIME S:'$T!(AA="") AA="^" S:AA["^" FLAGQ=1 S:AA="^^" FLAGE=1 Q:FLAGQ
 I AA="?"!(AA="*R") D:AA="?" HELP1 D:AA="*R" GLLOAD G GLRANGE
 I '$D(^UTILITY("EDD/GL")) W *7,"   Enter '*R' to build your Global listing." G GLRANGE1
 S AA=$S(AA="*":0,1:"^"_AA)
 S BB="^ZZZZZZZZZ" I FLAGP R !?8,"Ending Global: ^",BB:DTIME S:'$T!(BB="") BB="^" G:BB="^" GLRANGE S BB="^"_BB I BB']AA W *7,"   Ending Global must 'follow' Starting Global" G GLRANGE1
 I FLAGP S TEMP=$O(^UTILITY("EDD/GL",AA)) I TEMP=""!(TEMP]BB) W *7,"   No globals in this range" G GLRANGE1
 Q
GLLIST ;Start listing Globals
 F  S AA=$O(^UTILITY("EDD/GL",AA)) Q:AA=""!(AA]BB)  W !?2,AA,?23,$J($P(^(AA),U),14),?40,$E($P(^(AA),U,2),1,35) I $Y>SIZE D PAGE Q:FLAGQ
 Q
GLLOAD ;
 S AA=0,CNT=1 K ^UTILITY("EDD/GL")
 F  S AA=$O(^DIC(AA)) Q:AA'>0  I $D(^DIC(AA,0,"GL")) S ^UTILITY("EDD/GL",^DIC(AA,0,"GL"))=AA_"^"_$P(^DIC(AA,0),"^") W "."
 Q
HELP ;No data in ^UTILITY("EDD/GL")
 W *7,?35,"You have no data in ^UTILITY(""EDD/GL"")."
 W !?35,"You must first build your Global listing."
 W !?35,"Enter '?' at the 'Starting Global:' prompt."
 Q
HELP1 ;"Starting Global" prompt
 W !!?8,"1. Enter Global you want listing to start with.",!?11,"Examples: ^DPT , ^L , or ^%ZIS."
 W !?8,"2. Enter '*' to list all globals."
 W !?8,"3. Enter '*R' to Build/Update your Global listing."
 W !?14,"Your Global listing is kept in ^UTILITY(""EDD/GL""). If this is the"
 W !?14,"first time you've used this utility, or if you have added or"
 W !?14,"deleted any files on your system, enter '*R' here to build/update"
 W !?14,"your listing. It will take approximately 30 seconds to run."
 Q
PAGE ;
 I FLAGP,IO'=IO(0) W @IOF,!!! D @HD Q
 R !!?2,"<RETURN> to continue, '^' to quit, '^^' to exit: ",Z1:DTIME S:'$T Z1="^" I Z1["^" S FLAGQ=1 S:Z1="^^" FLAGE=1 Q
 W @IOF D @HD
 Q
HD ;
 W !?2,"Globals in ASCII order:"
 W !?10,"GLOBAL",?28,"FILE NUM",?46,"FILE (Truncated to 35)"
 W !,?2,"----------------------",?27,"----------",?40,"-----------------------------------"
 Q
HD1 ;Pointers from this file
 W !?3,"Pointers FROM this file..",!?6,"FLD NUM",?26,"FIELD NAME",?52,"FILE (Truncated to 30)",!?6,"--------",?16,"------------------------------",?48,"------------------------------"
 Q
INIT ;
 I FLAGP,IO=IO(0),IOSL>25 D SCROLL^XBHEDD7 Q:FLAGQ
 I FLAGP W:IO'=IO(0) "  Printing.." U IO
 W @IOF Q
