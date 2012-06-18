ADEATT1 ; IHS/HQT/MJL  - ATTENDING DDS STMNT PT 2 ;12:26 PM  [ 03/24/1999   9:04 AM ]
 ;;6.0;ADE;;APRIL 1999
 F J=1:1:6 S ADETXT=$T(@J) D LOAD,READ Q:'Y
END K ADEVAR,X,ADETXT Q
LOAD S ADEVAR=$P(ADETXT,";",2) F K=0:1:2 S ADEVAR(K)=$P(ADETXT,";",K+3)
 Q
READ S Y=1 W !,ADEVAR(0)
 R X:DTIME
 I '$T!(X="^") S Y=0 Q
 I X["?" W !?5,ADEVAR(2) G READ
 I X=" ",$D(@ADEVAR) S X=@ADEVAR W X Q
 X ADEVAR(1) I '$D(X) W *7," ??",!?5,ADEVAR(2) G READ
 S @ADEVAR=X
 Q
 ;ADEVAR;ADEVAR(0);ADEVAR(1);ADEVAR(2)
1 ;ADECAR(1);CARRIER NAME: ;I $L(X)<3!($L(X)>30) K X;Enter name of Insurance Carrier (3-30 characters)
2 ;ADECAR(2);CARRIER ADDRESS - LINE 1: ;I X]"",$L(X)<3!($L(X)>30) K X;Enter First line of Carrier's Address (3-30 characters)
3 ;ADECAR(3);CARRIER ADDRESS - LINE 2: ;I X]"",$L(X)<3!($L(X)>30) K X;Enter Second line of Carrier's Address (3-30 characters)
4 ;ADECAR(4);CARRIER CITY: ;I $L(X)<3!($L(X)>30) K X;Enter Insurance Carrier's City
5 ;ADECAR(5);CARRIER STATE: ;K:X?.N!(X="") X I $D(X),'$D(^DIC(5,"B",X)),'$D(^DIC(5,"C",X)) K X;Enter Insurance Carrier's State
6 ;ADECAR(6);CARRIER ZIP: ;I X]"" K:X'?1.5N X;Enter Insurance Carrier's Zip Code
