XBHEDD1 ;402,DJB,10/23/91,EDD - FIELD Global Locations
 ;;2.6;IHS UTILITIES;;JUN 28, 1993
 ;;David Bolduc - Togus, ME
PRINT ;Called by START,LOOP
 Q:'$D(^DD(FILE(LEVEL),FLD(LEVEL),0))
 S ZDATA=^DD(FILE(LEVEL),FLD(LEVEL),0),ZZA=$S($P(ZDATA,U,4)=" ; ":"Computed",1:$P(ZDATA,U,4)),ZZB=$P(ZDATA,U)
 W !?2,$J(ZZA,12),?17,$J(FLD(LEVEL),8),?28,DASHES,ZZB
 S ZY1=$P($P(ZDATA,U,4),";",2) W:ZY1=0 ?70,"-->Mult"
 S ZMZ=" " I ZY1=0 F II=1:1:41-$L(DASHES_ZZB) S ZMZ=ZMZ_" "
 I  S ZMZ=ZMZ_"-->Mult"
 I 'FLAGP S ^UTILITY($J,"LIST",PAGE,YCNT)=ZZA_"^"_FLD(LEVEL)_"^"_DASHES_ZZB_ZMZ
 S YCNT=YCNT+1
 Q
EN ;Entry Point
 D ASK G:FLAGQ EX
 I FLAGP,IO'=IO(0),^UTILITY($J,"TOT")>100 D WARN G:FLAGQ EX
 S HD="HD" D INIT^XBHEDD7 G:FLAGQ EX D @HD D START,LOOP
EX ;
 I FLAGQ!FLAGE!FLAGP S:IO'=IO(0) FLAGQ=1 D KILL Q
 S FLAGL=1 D ^XBHEDD2 S:'FLAGQ FLAGQ=1 D KILL
 Q
ASK ;
 W !?26,"""F""........ to select starting FIELD",!?26,"<RETURN>... for all fields"
ASK1 W !?30,"Select: ALL// " R ZZX:DTIME S:'$T ZZX="^" I ZZX["^" S FLAGQ=1 S:ZZX="^^" FLAGE=1 Q
 I ZZX="?" W !?10,"Type ""^"" to quit",!?10,"<RETURN> to see all fields",!?10,"""F"" to start listing at a particular field" G ASK1
 S (LEVEL,PAGE,YCNT)=1,FILE(LEVEL)=ZNUM,DASHES=""
 I ZZX="F" W ! S DIC="^DD("_ZNUM_",",DIC(0)="QEAM",DIC("W")="I $P(^DD(ZNUM,Y,0),U,2)>0 W ?65,""  -->Mult""" D ^DIC K DIC("W") S:Y<0 FLAGQ=1 Q:Y<0  S FLD(LEVEL)=+Y
 E  S FLD(LEVEL)=0
 Q
START ;Print if data, otherwise continue to loop.
 I $D(^DD(FILE(LEVEL),FLD(LEVEL),0))#2 D PRINT I ZY1=0 S LEVEL=LEVEL+1,FILE(LEVEL)=+$P(ZDATA,U,2),FLD(LEVEL)=0
 Q
LOOP ;Start For Loop
 S FLD(LEVEL)=$O(^DD(FILE(LEVEL),FLD(LEVEL))) I +FLD(LEVEL)=0 S LEVEL=LEVEL-1 G:LEVEL LOOP Q
 S (SPACE,BAR)=""
 F II=1:1:LEVEL-1 S SPACE=SPACE_" ",BAR=BAR_"-"
 S DASHES=SPACE_BAR
 D PRINT I ZY1=0 S LEVEL=LEVEL+1,FILE(LEVEL)=+$P(ZDATA,U,2),FLD(LEVEL)=0
 I $Y>SIZE D:'FLAGP ^XBHEDD2 Q:FLAGQ  I FLAGP D PAUSE Q:FLAGQ  W @IOF W:IO'=IO(0) !!! D HD
 G LOOP
PAUSE ;
 Q:IO'=IO(0)
 W !!?2,"<RETURN> to continue, '^' to quit: "
 R Z1:DTIME S:'$T Z1="^^" I Z1["^" S FLAGQ=1 S:Z1="^^" FLAGE=1
 Q
WARN ;Warn if printing and over 100 fields in file
 W !?8,"This file has over 100 fields. Sure you want to print? YES//"
 R XX:DTIME S:'$T XX="N" S:"Yy"'[$E(XX) FLAGQ=1 I XX="?" W !?2,"[Y]es to print, [N]o to return to Main Menu." G WARN
 Q
HD ;
 W !?2,"NODE ; PIECE",?17,"FLD NUM",?48,"FIELD NAME",!?2,"------------",?17,"--------",?28,"-------------------------------------------------"
 Q
KILL ;Kill variables
 K DASHES,EDDDATE,FILE,HD,LEVEL,PAGE,PAGETEMP,YCNT,^UTILITY($J,"LIST")
 Q
