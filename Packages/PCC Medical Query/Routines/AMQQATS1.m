AMQQATS1 ; IHS/CMI/THL - SETS MULTIPLES ;
 ;;2.0;IHS PCC SUITE;;MAY 14, 2009
 ;-----
MULT S %=$P(Q,U,9)
 I $P(%,";",6) S %=$P(%,";",1,5),AMQQSQNL="" S:$P(%,";",5)="" %=$P(%,";",1,4) S $P(Q,U,9)=%,AMQQQ=Q
 I $P(Q,U,3)="E"!($P(Q,U,3)="V") D BP Q
 F I=1,2,3,6,7 S AMQQF(I)=$P(%,";",I)
 I $P(Q,U,3)="I" S AMQQF(4)=$P(%,";",4),AMQQF(5)="" S:$P(%,";",5)="ANY" AMQQF(5)="ANY",AMQQF(4)=AMQQF(4)_"~~ANY" G MY ; &&& FIXES IMMUNIZATION ANY BUG
 I $P(Q,U,3)="F" S AMQQF(4)="'[",AMQQF(5)="```" D:$P(%,";",4)[":" TEXT G MY
 I $P(Q,U,3)="S" S AMQQF(4)=$P($P(%,";",4),":"),AMQQF(5)=$P($P(%,";",4),":",2) G MY
 I "QZ"'[$P(Q,U,3) S X=$P(%,":",2) I X'="",X'=+X D TEXT G MY
 I $P(Q,U,16)>1,AMQQF(2)>9990000 S AMQQF(2)=AMQQF(1)+.0000001,AMQQF(1)=0 G MX
 I $P(Q,U,16)>1,AMQQF(1)<1 S AMQQF(1)=AMQQF(2)-.0000001,AMQQF(2)=9999999
 I AMQQF(1)>0,AMQQF(2)<9990000 S:AMQQF(1)=AMQQF(2) AMQQF(2)=AMQQF(2)+.2359 S AMQQF(1)=AMQQF(1)-.76
MX I $P(Q,U,3)="Z" D ZERO G MY
 I $P(Q,U,3)="Q" D QUAL G MY
 I $P(Q,U,17) S %=$P(Q,U,9) F I=1:1:5 S:'$D(AMQQF(I)) AMQQF(I)=$P(%,";",I) I I=5 G MY
MZ D RANGE
 S AMQQF(4)=$P(X,":")
 S AMQQF(5)=$P(X,":",2)
MY S %="0^9999999^9999999^-999999999^999999999^"_AMQQUATN_U_$D(AMQQMULT)
 F I=1:1:7 I AMQQF(I)="" S AMQQF(I)=$P(%,U,I)
 I $D(AMQQSQNL)!($D(^UTILITY("AMQQ",$J,"SQ",+$G(AMQQUSQN),"NULL"))&$D(AMQQFSQN))!$D(AMQQFSQX) K AMQQFSQX,AMQQSQNL,AMQQFSQN S %=$P(Q,U,9),$P(%,";",6)="NULL",$P(Q,U,9)=%
 Q
 ;
ZERO S X=$P(%,";",4)
 I $P(X,":",4)'="",$P(Q,U,8)="'" S Y=$P(X,":",2) D ZTR S AMQQF(5)=Y S Y=$P(X,":",4) D ZTR S AMQQF(4)=Y Q
 I $P(X,":",4)'="" S Y=$P(X,":",2) D ZTR S Y=Y-.1,AMQQF(4)=Y S Y=$P(X,":",4) D ZTR S AMQQF(5)=Y Q
 S Y=$P(X,":",2)
 D ZTR
 S X=$P(X,":")
 I X=">" S AMQQF(4)=Y+.01,AMQQF(5)=9 Q
 I X="<" S AMQQF(4)=-1,AMQQF(5)=Y-.01 Q
 I X="=" S AMQQF(4)=Y,AMQQF(5)=Y Q
 I X="'>" S AMQQF(4)=-1,AMQQF(5)=Y Q
 I X="'<" S AMQQF(4)=Y,AMQQF(5)=9 Q
 I X="'=" S AMQQF(4)=Y+.01,AMQQF(5)=Y-.01 Q
 S AMQQF(4)=-1
 S AMQQF(5)=5
 Q
 ;
ZTR S Y=$E(Y)
 S Y=$S(Y="N":0,Y="T":1,1:(Y+1))
 Q
 ;
QUAL I %="" S AMQQF(4)=-1,AMQQF(5)=2 Q
 S X=$P(%,";",4)
 I X="=:POS"!(X="'=:NEG") S AMQQF(4)=1,AMQQF(5)=1 Q
 I X="=:NEG"!(X="'=:POS") S AMQQF(4)=0,AMQQF(5)=0 Q
 S AMQQF(4)=""
 S AMQQF(5)=""
 Q
 ;
RANGE S %=$P(AMQQCOMP,";",4)
 S Y=$P(%,":")
 S Z=$P(%,":",2)
 S N=.00000001
 I $P(%,":",4),$P(Q,U,16) S X=$P(%,":",4)_":"_Z Q
 I $L(Y)=1,"[]?="[Y S X=Y_":"_Z I Z'=+Z S X="=:"_Z
 I Y="=" S X=Z_":"_Z Q
 I Y="'=" S X=(Z+N)_":"_(Z-N) Q
 I $P(%,":",4) S X=(Z-N)_":"_($P(%,":",4)+.00000001) Q
 S X=-999999999
 I Y="<" S X=X_":"_(Z-N) Q
 I Y="'>" S X=X_":"_Z Q
 S X=999999999
 I Y=">" S X=Z_":"_X Q
 S X=(Z-N)_":"_X
 Q
 ;
TEXT S Y=$P(%,";",4)
 S AMQQF(4)=$P(Y,":",1)_":"_$P(Y,":",3)
 S AMQQF(5)=$P(Y,":",2)_":"_$P(Y,":",4)
 Q
 ;
BP N AMQQCOMP
 I %'["~" S (AMQQCOMP,AMQQCOM2)=">:0",AMQQBOOL="!",AMQQCOMP=%_";>:0;>:0"
 E  S AMQQCOMP=$P(%,"~"),AMQQCOM2=$P(%,"~",2),AMQQBOOL=$P(%,"~",3)
 S AMQQF(6)=$S($D(AMQQ("BP COHORT FLG")):"",1:2)
 F I=1:1:5,7 S AMQQF(I)=$P(AMQQCOMP,";",I)
 D MZ
 S AMQQF=""
 F I=1:1:7 S AMQQF=AMQQF_AMQQF(I)_U
 S AMQQF=AMQQF_AMQQBOOL
 S AMQQCOMP=";;;"_AMQQCOM2
 D MZ
 S AMQQF=AMQQF_U_AMQQF(4)_U_AMQQF(5)
 F I=1:1:10 S AMQQF(I)=$P(AMQQF,U,I)
 K AMQQBOOL,AMQQCOM2
 Q
 ;
