XBHEDD11 ;402,DJB,10/23/91,EDD - Templates and Description
 ;;2.6;IHS UTILITIES;;JUN 28, 1993
 ;;David Bolduc - Togus,ME
EN ;Templates
 I '$D(^DIBT("F"_ZNUM)),'$D(^DIPT("F"_ZNUM)),'$D(^DIE("F"_ZNUM)) W ?30,"No Templates" S FLAGG=1 G EX
 S Z1="" D INIT^XBHEDD7 G:FLAGQ EX D HD
 D DIPT G:FLAGQ EX D DIBT G:FLAGQ EX D DIE
EX ;
 K A,DISYS,DIW,DIWI,DIWTC,DIWX,DIWT,DIWL,DIWF,DIWR,DN,HEAD,II,VAR
 Q
DIPT ;Print Templates
 S HEAD="A.)  PRINT TEMPLATES:" W !?2,HEAD
 S A="",VAR="^DIPT"
 F II=1:1 S A=$O(^DIPT("F"_ZNUM,A)) Q:A=""  W !?12,$J(II,4),".  ",A S B=$O(^DIPT("F"_ZNUM,A,"")) W:$D(^DIPT(B,"ROU")) ?60,"Compiled: ",^DIPT(B,"ROU") I $Y>SIZE D PAGE Q:FLAGQ!(Z1="S")
 I II=1 W ?25,"No print templates..."
 Q
DIBT ;Sort Templates
 S HEAD="B.)  SORT TEMPLATES:" W !?2,HEAD
 S A="",VAR="^DIBT"
 F II=1:1 S A=$O(^DIBT("F"_ZNUM,A)) Q:A=""  W !?12,$J(II,4),".  ",A I $Y>SIZE D PAGE Q:FLAGQ!(Z1="S")
 I II=1 W ?25,"No sort templates..."
 Q
DIE ;Edit Templates
 S HEAD="C.)  INPUT TEMPLATES:" W !?2,HEAD
 S A="",VAR="^DIE"
 F II=1:1 S A=$O(^DIE("F"_ZNUM,A)) Q:A=""  W !?12,$J(II,4),".  ",A S B=$O(^DIE("F"_ZNUM,A,"")) W:$D(^DIE(B,"ROU")) ?60,"Compiled: ",^DIE(B,"ROU") I $Y>SIZE D PAGE Q:FLAGQ!(VAR="")
 I II=1 W ?25,"No input templates..."
 Q
PAGE ;Templates
 I VAR="^DIE" S ZX=VAR_"(""F"_ZNUM_""","""_A_""")" I $O(@ZX)="" S VAR="" Q
 I FLAGP,IO'=IO(0) W @IOF,!!! D HD Q
 W !!?2,"<RETURN> to continue, 'S' to skip, '^' to quit, '^^' to exit: "
 R Z1:DTIME S:'$T Z1="^" I Z1["^" S FLAGQ=1 S:Z1="^^" FLAGE=1 Q
 I Z1="S",VAR="^DIE" S FLAGQ=1 Q
 S ZX=VAR_"(""F"_ZNUM_""","""_A_""")"
 W @IOF D HD I Z1="S"!($O(@ZX)="") Q
 W !?2,HEAD," continued..." Q
PAGE1 ;File Description
 I FLAGP,IO'=IO(0) W @IOF,!!! D HD1 Q
 R !!?2,"<RETURN> to continue, '^' to quit, '^' to exit: ",Z1:DTIME
 S:'$T Z1="^" I Z1["^" S FLAGQ=1 S:Z1="^^" FLAGE=1 Q
 W @IOF D HD1
 Q
DES ;File Description
 I FLAGP D PRINT^XBHEDD7 ;Shut off printing
 I '$D(^DIC(ZNUM,"%D")) W ?30,"No description available." S FLAGG=1 Q
 W @IOF D HD1
 K ^UTILITY($J,"W")
 S A=0 F  S A=$O(^DIC(ZNUM,"%D",A)) Q:A=""  S X=^DIC(ZNUM,"%D",A,0),DIWL=5,DIWR=75,DIWF="W" D ^DIWP I $Y>SIZE D PAGE1 Q:FLAGQ
 D:'FLAGQ ^DIWW
 G EX
HD ;Templates
 W !?2,"T E M P L A T E S        PRINT  *  SORT  *  INPUT",!,$E(ZLINE,1,IOM)
 Q
HD1 ;File description
 W !?2,"File description for ",ZNAM," file.",!,$E(ZLINE1,1,IOM)
 Q
