XBHEDD5 ;402,DJB,10/23/91,EDD - Individual Field Summary
 ;;2.6;IHS UTILITIES;;JUN 28, 1993
 ;;David Bolduc - Togus, ME
STRING ;String=code - Prints a string in lines of 55 characters
 S LINE(1)=$E(STRING,1,55) W ?M3,LINE(1) I $Y>SIZE D PAGE Q:FLAGQ
 I $L(STRING)>55 S LINE(2)=$E(STRING,56,110) W !?M3,LINE(2) I $Y>SIZE D PAGE Q:FLAGQ
 I $L(STRING)>110 S LINE(3)=$E(STRING,111,165) W !?M3,LINE(3) I $Y>SIZE D PAGE Q:FLAGQ
 I $L(STRING)>165 S LINE(4)=$E(STRING,166,220) W !?M3,LINE(4) I $Y>SIZE D PAGE Q:FLAGQ
 I $L(STRING)>220 S LINE(5)=$E(STRING,221,275) W !?M3,LINE(5) I $Y>SIZE D PAGE Q:FLAGQ
 I $L(STRING)>275 S LINE(6)=$E(STRING,276,330) W !?M3,LINE(6) I $Y>SIZE D PAGE Q:FLAGQ
 Q
WORD ;String=text - Prints a string in lines of 55 characters
 S LINE(1)=$E(STRING,1,55)
 I $L(STRING)>55 S LINE(1)=$P(LINE(1)," ",1,$L(LINE(1)," ")-1)
 W ?M3,LINE(1) I $Y>SIZE D PAGE Q:FLAGQ
 S LENGTH=$L(LINE(1))
 Q:$L(STRING)'>LENGTH
 S LINE(2)=$E(STRING,LENGTH+2,LENGTH+57)
 I $L(STRING)>(LENGTH+2+55) S LINE(2)=$P(LINE(2)," ",1,$L(LINE(2)," ")-1)
 W !?M3,LINE(2) I $Y>SIZE D PAGE Q:FLAGQ
 S LENGTH=LENGTH+2+$L(LINE(2))
 Q:$L(STRING)'>LENGTH
 S LINE(3)=$E(STRING,LENGTH+2,LENGTH+57)
 I $L(STRING)>(LENGTH+2+55) S LINE(3)=$P(LINE(3)," ",1,$L(LINE(3)," ")-1)
 W !?M3,LINE(3) I $Y>SIZE D PAGE Q:FLAGQ
 S LENGTH=LENGTH+2+$L(LINE(3))
 S LINE(4)=$E(STRING,LENGTH+2,LENGTH+57)
 I $L(STRING)>(LENGTH+2+55) S LINE(4)=$P(LINE(4)," ",1,$L(LINE(4)," ")-1)
 W !?M3,LINE(4) I $Y>SIZE D PAGE Q:FLAGQ
 S LENGTH=LENGTH+2+$L(LINE(4))
 S LINE(5)=$E(STRING,LENGTH+2,LENGTH+57)
 I $L(STRING)>(LENGTH+2+55) S LINE(5)=$P(LINE(5)," ",1,$L(LINE(5)," ")-1)
 W !?M3,LINE(5) I $Y>SIZE D PAGE Q:FLAGQ
 S LENGTH=LENGTH+2+$L(LINE(5))
 S LINE(6)=$E(STRING,LENGTH+2,LENGTH+57)
 I $L(STRING)>(LENGTH+2+55) S LINE(6)=$P(LINE(6)," ",1,$L(LINE(6)," ")-1)
 W !?M3,LINE(6) I $Y>SIZE D PAGE Q:FLAGQ
 Q
DTYPE1 ;Called by DATATYPE^XBHEDD4
 W !?M3,$S(ZDSUB["B":"True-False (""Boolean"")",ZDSUB["I":"Uneditable",ZDSUB["O":"Has output transform",ZDSUB["R":"Required field",ZDSUB["X":"Input Transform has been modified in Utility Option",1:"")
 Q
DTYPE2 ;Called by DATATYPE^XBHEDD4
 W !?M3,$S(ZDSUB["a":"Marked for auditing",ZDSUB["m":"Multilined",ZDSUB["*":"Field has a screen",ZDSUB["'":"LAYGO to ""pointed to"" file not allowed",1:"")
 Q
PAGE ;
 I FLAGP,IO'=IO(0) W @IOF,!!! Q
 I $Y'>SIZE F I=$Y:1:SIZE W !
 W:'FLAGP !,$E(ZLINE,1,IOM) W:FLAGP !
 R !?2,"<RETURN> to continue, ""^"" to quit, ""^^"" to exit:  ",Z1:DTIME S:'$T Z1="^" I Z1["^" S FLAGQ=1 S:Z1="^^" FLAGE=1 Q
 W @IOF W:'FLAGP !?55,"FLD NUMBER: ",FNUM,!,$E(ZLINE,1,IOM),!
 Q
