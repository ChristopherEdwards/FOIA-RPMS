APSPCP ; IHS/DSD/ENM - CHRONIC MED PROFILE INPUT TRANS ;  [ 09/03/97   1:30 PM ]
 ;;6.0;IHS PHARMACY MODIFICATIONS;;09/03/97
 ;This routine was created in place of an input transform for the
 ;'SIG' field in file 52.
EP ;
 S APSPZW=$S($D(%APSITE):$P(%APSITE,U,4),$D(^APSPCTRL(PSOSITE,0)):$P(^(0),U,4),1:31),APSPZW=APSPZW-5 D:$D(X) ZZ1 K APSPZW ;IHS/DSD/ENM 08/01/96
 Q
ZZ1 S SIG="" F Z0=1:1 Q:$P(X," ",Z0,99)=""  S Z1=$P(X," ",Z0) K:$L(Z1)>APSPZW X W:$L(Z1)>APSPZW !,?5,"MAX OF ",APSPZW," CHARACTERS ALLOWED BETWEEN SPACES." Q:$L(Z1)>APSPZW  D:Z1]"" ZZ2 S SIG=SIG_$E(" ",Z0>1)_Z1
 Q
ZZ2 S Y=$O(^PS(51,"B",Z1,0)) Q:Y=""  S Z1=$P(^PS(51,Y,0),U,2) Q:'$D(^(9))  S Y=$P(X," ",Z0-1),Y=$E(Y,$L(Y)) S:Y>1 Z1=^(9)
 Q
