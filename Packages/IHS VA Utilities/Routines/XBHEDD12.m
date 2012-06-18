XBHEDD12 ;402,DJB,10/23/91,EDD - File Characteristics
 ;;2.6;IHS UTILITIES;;JUN 28, 1993
 ;;David Bolduc - Togus, ME
CHAR ;Identifiers, Post Selection Actions, Special Look-up Program
 I '$D(^DD(ZNUM,0,"ID")),'$D(^DD(ZNUM,0,"ACT")),'$D(^DD(ZNUM,0,"DIC")) W !?10,"No Identifiers, Post Selection Actions, or Special Look-up Program." S FLAGG=1 Q
 D INIT^XBHEDD7 G:FLAGQ EX
 W !?21,"F I L E   C H A R A C T E R I S T I C S",!?20,"-----------------------------------------"
 ;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 W !!?2,"1. POST SELECTION ACTION:" I $D(^DD(ZNUM,0,"ACT")) D
 .W "  The following code is executed after an entry to"
 .W !?29,"this file has been selected. If Y=-1 entry will"
 .W !?29,"not be selected:"
 .W !?14,"CODE:" S STRING=^DD(ZNUM,0,"ACT") D STRING
 ;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 W !!?2,"2. SPECIAL LOOK-UP PROGRAM: " I $D(^DD(ZNUM,0,"DIC")) W "^",^DD(ZNUM,0,"DIC")
 ;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 W !!?2,"3. IDENTIFIERS:"
 I $D(^DD(ZNUM,0,"ID")) D NOTE,HD S XX="" F  S XX=$O(^DD(ZNUM,0,"ID",XX)) Q:XX=""!FLAGQ  D   W !
 .W !?1,$J(XX,12),?15,$S(+XX=XX:"Yes",1:"No") S STRING=^DD(ZNUM,0,"ID",XX) D STRING
 ;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
EX ;Exit
 Q
STRING ;String=code - Prints a string in lines of 55 characters
 S LINE(1)=$E(STRING,1,55) W ?M3,LINE(1) I $Y>SIZE D PAGE Q:FLAGQ
 I $L(STRING)>55 S LINE(2)=$E(STRING,56,110) W !?M3,LINE(2) I $Y>SIZE D PAGE Q:FLAGQ
 I $L(STRING)>110 S LINE(3)=$E(STRING,111,165) W !?M3,LINE(3) I $Y>SIZE D PAGE Q:FLAGQ
 I $L(STRING)>165 S LINE(4)=$E(STRING,166,220) W !?M3,LINE(4) I $Y>SIZE D PAGE Q:FLAGQ
 I $L(STRING)>220 S LINE(5)=$E(STRING,221,275) W !?M3,LINE(5) I $Y>SIZE D PAGE Q:FLAGQ
 I $L(STRING)>275 S LINE(6)=$E(STRING,276,330) W !?M3,LINE(6) I $Y>SIZE D PAGE Q:FLAGQ
 Q
PAGE ;
 I FLAGP,$E(IOST)="P" W @IOF,!!! D HD Q
 R !!?2,"<RETURN> to continue, ""^"" to quit, ""^^"" to exit:  ",Z1:DTIME S:'$T Z1="^" I Z1["^" S FLAGQ=1 S:Z1="^^" FLAGE=1 Q
 W @IOF D HD
 Q
NOTE ;
 W "  If ASK=Yes, field is asked when a new entry is added.",!
 Q
HD ;Heading
 W !?8,"FIELD",?15,"ASK",?(M3+10),"WRITE STATEMENT TO GENERATE DISPLAY",!?8,"-----",?15,"---",?M3,"-------------------------------------------------------"
 Q
