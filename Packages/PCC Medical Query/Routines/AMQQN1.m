AMQQN1 ; IHS/CMI/THL - NATL LANGUAGE PRELIMINARY PASS ;
 ;;2.0;IHS PCC SUITE;;MAY 14, 2009
 ;-----
RUN D SUBJ
 W $C(13),?79,$C(13)
 I '$D(AMQQFAIL),$D(AMQQNSBJ),$D(AMQQFEN2) W !!,"Sorry...You cannot change the subject of your search",!!,*7 H 3 S AMQQQUIT="",AMQQFAIL=-1 G EXIT
 I '$D(AMQQNSBJ),$D(AMQQSAUT),'$D(AMQQFAIL) I $L(AMQQSAUT,U)>3 S (AMQQNSBJ,Y)=AMQQSAUT D AUTO1^AMQQ1
 I $D(AMQQQUIT) G EXIT
 I '$D(AMQQNSBJ) S AMQQFAIL=4 G EXIT
 S AMQQSAUT=AMQQNSBJ
 S AMQQCCLS="P"
EXIT ;
 Q
 ;
SUBJ S %="LIVING PATIENTS^PATIENTS^INFANTS^FEMALES^MALES^BOYS^GIRLS^MEN^WOMEN"
 F I=1:1 S A=$P(%,U,I) Q:A=""  I X[A D PAT G SUBEXIT
 I X'["OF " G SUBJ1
 F Y=1:1 S Z=$P(X," ",Y) I Z="OF" Q
 I $P(X," ",Y+3)'="" S Z=$P(X," ",Y+1,Y+3) D SB1 I $D(AMQQNSBJ) D SB2 Q
 I $P(X," ",Y+2)'="" S Z=$P(X," ",Y+1,Y+2) D SB1 I $D(AMQQNSBJ) D SB2 Q
SUBJ1 I X'["'S",X'["S'" Q
 F Y=1:1 S Z=$P(X," ",Y) I Z["S'"!(Z["'S") Q
 I Y>2 S Z=$P(X," ",Y-2,Y) D SB1 I $D(AMQQNSBJ) D SB2 Q
 S Z=$P(X," ",Y-1,Y) D SB1 I $D(AMQQNSBJ) D SB2
 Q
 ;
SB1 S %=Z
 I %["'S" S %=$P(%,"'S")_$P(%,"'S",2) G SB10
 I %["S'" S %=$P(%,"S'")_"S"_$P(%,"S'",2)
SB10 W !
 N X,Y,Z
 S X=%,AMQQXX=""
 D ^AMQQ2
 I '$D(Y) W:'$D(AMQQNECO) !!,"Sorry, I'm unable to determine the SUBJECT of the query...The search is aborted",!!,*7 S AMQQFAIL=1 Q
 S AMQQNSBJ=Y
 D AUTO1^AMQQ1
SUBEXIT K %,A,Z
 Q
 ;
SB2 S Z=Z_" "
 S X=$P(X,Z)_$P(X,Z,2,99)
 I X["OF " S X=$P(X,"OF ")
 Q
 ;
PAT S X=$P(X,A)_" "_$P(X,A,2)
 F  Q:X'["  "  S X=$P(X,"  ")_" "_$P(X,"  ",2,99)
 I $E(X)=" " S X=$E(X,2,240)
 I X[" OF " S X=$P(X," OF ",1)_" "_$P(X," OF ",2,99)
 S AMQQNSBJ=A
 S AMQQCCLS="P"
 N X
 S X=A
 S AMQQXX=""
 D AUTO^AMQQ1
 Q
 ;
