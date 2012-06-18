AUZTI ;MOVE TO "MGR" AND REMOVE THIS LINE [ 05/05/86  10:56 AM ]
%ZTI ;TIME INPUT
 ;CFL/OKC
Z S:'$D(%TI(0)) %TI(0)="" I '$D(X) S X=""
A1 I %TI(0)["A" R !!,"TIME: ",%TS S X=%TS
 S (Y,%Z)="" G END:X=""
 G MIL:X?4N,NOW:("NOW"[X),HELP:X?1"?"."?"
 F %I=$L(X):-1:1 I $E(X,%I)?1A,"APap"[$E(X,%I) S %Z=$E(X,%I),X=$E(X,1,%I-1)
 I X?3N!(X?3N.AP) S %H=$E(X,1),%M=$E(X,2,3) G A11
 S %H=+$P(X,":",1),%M=+$P(X,":",2)
A11 I '(%H?1N!(%H?2N))!(%H<1)!(%H>23) G ERR
 I %M,'(%M?2N)!(%M>59) G ERR
 G A2:%Z'="",ERR:%TI(0)["X" I %H>6,%H<12 S %Z="A" G A2
 S %Z="P"
A2 I %Z["P" S:%H<12 %H=%H+12
 I %Z["A",%H=12 S %H=0
B1 S Y=%H*3600+(%M*60) D ECHO
 G END
MIL S %H=$E(X,1,2),%M=$E(X,3,4) I %H<23,%M<60 G B1
NOW S %H=$P($H,",",2),%M=%H#3600\60,%H=%H\3600 G B1
ERR I %TI(0)["Q" W *7,"  ??"
 I %TI(0)["A" G A1
END K %H,%M,%Z,%TS,%TI
 Q
ECHO S %H=Y\3600,%M=Y#3600\60,%Z=$S(Y>43199:"PM",1:"AM"),%M=$E(%M+100,2,3) S:%H>12 %H=%H-12 I '%H S %H=12
 S %E="   ("_%H_":"_%M_" "_%Z_")" I %TI(0)["E" W %E
 Q
HELP W !!,"Enter The Time In One Of The Following Formats:",!
 W !,?5,"10:00 AM",?25,"10:00A",?50,"10A",?65,"1000"
 W !!,?5," 2:30 PM",?25," 2:30P",?50,"230P",?65,"1430"
 W !!,"Enter 'NOW' For The Current Time."
 W !!,?3,"If 'AM' or 'PM' is Ommitted, The Time Is Assumed To Be"
 W !!,?3,"Between 7:00 AM and 6:00 PM (Except For Military Time)."
 G A1:%TI(0)["A",END
