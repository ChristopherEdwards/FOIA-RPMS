A4A7P603 ; ; 14-JUL-1993
 ;;1.01;A4A7;**6**;JUL 14, 1993
 F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) S @X=Y
Q Q
 ;;^DD(200,0,"IX","PS1",200,53.2)
 ;;=
 ;;^DD(200,0,"IX","PS2",200,53.3)
 ;;=
 ;;^DD(200,.01,1,10,0)
 ;;=200^AH^MUMPS
 ;;^DD(200,.01,1,10,1)
 ;;=N % S:'$P(^VA(200,DA,0),U,16) %=$P($G(^DIC(3,DA,0)),U,16) S:$G(%) $P(^VA(200,DA,0),U,16)=%,^VA(200,"A16",%,DA)=""
 ;;^DD(200,.01,1,10,2)
 ;;=I 0 S X=X
 ;;^DD(200,.01,1,10,3)
 ;;=Special PERSON FILE POINTER
 ;;^DD(200,.01,1,10,"%D",0)
 ;;=^^2^2^2920810^
 ;;^DD(200,.01,1,10,"%D",1,0)
 ;;=This MUMPS cross-reference sets the PERSON FILE POINTER in place and sets
 ;;^DD(200,.01,1,10,"%D",2,0)
 ;;=the 'A16' X-ref of that field. See the field description for more details.
 ;;^DD(200,.01,1,10,"DT")
 ;;=2920810
 ;;^DD(200,53.2,0)
 ;;=DEA#^FX^^PS;2^K:X[""""!($A(X)=45) X I $D(X) K:$L(X)>9!($L(X)<9)!'(X?2U7N) X I $D(X),$D(^VA(200,"PS1",X)),$O(^(X,0))'=DA W !,*7,?5,"DUPLICATE DEA NUMBER",! K X
 ;;^DD(200,53.2,1,0)
 ;;=^.1
 ;;^DD(200,53.2,1,1,0)
 ;;=200^PS1
 ;;^DD(200,53.2,1,1,1)
 ;;=S ^VA(200,"PS1",$E(X,1,30),DA)=""
 ;;^DD(200,53.2,1,1,2)
 ;;=K ^VA(200,"PS1",$E(X,1,30),DA)
 ;;^DD(200,53.2,1,1,3)
 ;;=Lookup providers by there DEA number
 ;;^DD(200,53.2,1,1,"%D",0)
 ;;=^^1^1^2930924^
 ;;^DD(200,53.2,1,1,"%D",1,0)
 ;;=This was 'APS1' before.  Also used to stop duplicate numbers.
 ;;^DD(200,53.2,1,1,"DT")
 ;;=2930924
 ;;^DD(200,53.2,1,2,0)
 ;;=200^ACX38^MUMPS
 ;;^DD(200,53.2,1,2,1)
 ;;=N % S %=$P(^DIC(3,DA,0),U,16) I %,$D(^DIC(6,%,0)) S $P(^DIC(6,%,0),U,3)=X
 ;;^DD(200,53.2,1,2,2)
 ;;=N % S %=$P(^DIC(3,DA,0),U,16) I %,$D(^DIC(6,%,0)) S $P(^DIC(6,%,0),U,3)=""
 ;;^DD(200,53.2,1,2,3)
 ;;=Used to keep 3-16-200 in sync.
 ;;^DD(200,53.2,1,2,"DT")
 ;;=2920629
 ;;^DD(200,53.2,3)
 ;;=Enter the DEA number 2 letters 7 numbers.
 ;;^DD(200,53.2,4)
 ;;=W:$X>5 ! W ?5,"Enter the DEA number as two upper case letters followed by 7 digits",!,?5,"e.g. AA1234567.  Each provider must have a unique number.",!
 ;;^DD(200,53.2,20,0)
 ;;=^.3LA^1^1
 ;;^DD(200,53.2,20,1,0)
 ;;=PS
 ;;^DD(200,53.2,21,0)
 ;;=^^1^1^2930506^
 ;;^DD(200,53.2,21,1,0)
 ;;=This field is used to enter the drug enforcement agency number.
 ;;^DD(200,53.2,"DT")
 ;;=2930924
 ;;^DD(200,53.3,0)
 ;;=VA#^FX^^PS;3^K:X[""""!($A(X)=45) X I $D(X) K:$L(X)>10!($L(X)<3) X I $D(X),$D(^VA(200,"PS2",X)),$O(^(X,0))'=DA,$S('$D(^VA(200,+$O(^VA(200,"PS2",X,0)),"PS")):0,'$P(^("PS"),"^",4):1,1:$P(^("PS"),"^",4)'<DT) K X W !,*7,?5,"DUPLICATE VA #",!
 ;;^DD(200,53.3,1,0)
 ;;=^.1
 ;;^DD(200,53.3,1,1,0)
 ;;=200^PS2
 ;;^DD(200,53.3,1,1,1)
 ;;=S ^VA(200,"PS2",$E(X,1,30),DA)=""
 ;;^DD(200,53.3,1,1,2)
 ;;=K ^VA(200,"PS2",$E(X,1,30),DA)
 ;;^DD(200,53.3,1,1,3)
 ;;=Lookup providers by there VA number
 ;;^DD(200,53.3,1,1,"%D",0)
 ;;=^^1^1^2930924^
 ;;^DD(200,53.3,1,1,"%D",1,0)
 ;;=This was 'APS2' before. Also used to stop duplicate numbers.
 ;;^DD(200,53.3,1,1,"DT")
 ;;=2930924
 ;;^DD(200,53.3,1,2,0)
 ;;=200^ACX39^MUMPS
 ;;^DD(200,53.3,1,2,1)
 ;;=N % S %=$P(^DIC(3,DA,0),U,16) I %,$D(^DIC(6,%,0)) S $P(^DIC(6,%,0),U,6)=X
 ;;^DD(200,53.3,1,2,2)
 ;;=N % S %=$P(^DIC(3,DA,0),U,16) I %,$D(^DIC(6,%,0)) S $P(^DIC(6,%,0),U,6)=""
 ;;^DD(200,53.3,1,2,3)
 ;;=Used to keep 3-16-200 in sync.
 ;;^DD(200,53.3,1,2,"DT")
 ;;=2920629
 ;;^DD(200,53.3,3)
 ;;=Enter the VA number 3 to 10 characters.
 ;;^DD(200,53.3,4)
 ;;=W !,?5,"Enter the VA number.  VA number must be unique among active providers.",!
 ;;^DD(200,53.3,20,0)
 ;;=^.3LA^1^1
 ;;^DD(200,53.3,20,1,0)
 ;;=PS
 ;;^DD(200,53.3,21,0)
 ;;=^^1^1^2930506^
 ;;^DD(200,53.3,21,1,0)
 ;;=This field is used to enter the VA number.
 ;;^DD(200,53.3,"DT")
 ;;=2930924
