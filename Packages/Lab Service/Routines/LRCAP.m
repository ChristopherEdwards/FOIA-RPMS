LRCAP ;SLC/CJS- STUFF AMIS/CAP DATA INTO LAM GLOBAL ;9/1/89  15:29 ;
 ;;V~5.0~;LAB;**44**;02/27/90 17:09
 Q:'$D(^LR(LRDFN,LRSS,LRIDT,0))  S:'$P(LRPARAM,U,15) Z=1
 I $P(LRPARAM,U,15) S Z=0 F II=0:0 S II=$N(^LRO(68,LRAA,1,LRAD,1,LRAN,4,II)) Q:II<1  I $P(^LAB(60,II,0),"^",2),$O(^LAB(60,II,9,0)) S Z=1 Q
 I 'Z Q
 S Y=^LR(LRDFN,LRSS,LRIDT,0) S:$D(X) LRXXX=X
 K LRA
 W !,"Change or exclude any tests from workload reporting" S %=2 D YN^DICN
 I %=1,$D(^LRO(68,LRAA,1,LRAD,1,LRAN,"AE")) W *7,!!,"This accession has already been processed into the AMIS/CAP file.",!,"You will need to use the MANUAL EDIT CAP option to make any changes." Q
 D NEWCAP:%=1
 K X,%,LRLN,LRSUF,LRSITE,LRA,LRT,LRF,LRI,LRY
 S:$D(LRXXX) X=LRXXX K LRXXX Q
NEWCAP S LRCAPUD=1,LRF=0 W @IOF,!,"Listed below are the tests on this accession.",!,"Select the test for which you want to change the AMIS/CAP code."
 K LRR S LRF=0 W !!?5,"TEST NAME",!?5,"---------"
 I '$D(LRMX) F I=0:0 S I=$N(LRNAME(I)) Q:I<1  S II=$N(LRNAME(I,0)),LRMX(II)=""
 I '$D(LRMX) F I=0:0 S I=$N(LRM(I)) Q:I<1  S LRMX(LRM(I))=""
 F I=0:0 S I=$O(LRTEST(I)) Q:I=""!(LRF)  S LRMX($P(LRTEST(I),U))=""
 F LRZZ=1:1 Q:LRF  D TESTS K DIC
 I LRF,'Z K LRMX Q
 W @IOF,!,"You have selected the following AMIS/CAP codes for this accession: "
 W !!?5,"TEST NAME",?30,"AMIS/CAP CODE",!?5,"---------",?30,"-------------"
 F II=0:0 S II=$N(^LRO(68,LRAA,1,LRAD,1,LRAN,4,II)) Q:II<1  I $P(^(II,0),U,5),$P(^LAB(60,+^(0),0),U,2) S II1=$P(^(0),U) W !?5,II1 S J=0 D JJ
 S %=1 W !!,"ALL OK" D YN^DICN I %=2 G NEWCAP
 K LRMX Q
TESTS K DIC D II
 K DIC,DIE,DR,DA,LRR,II,II1,JJ,J,LRSY,LRO,LRA,LRI,LRJ,LRX1,LRIX
 Q
II S Z=0 F II=0:0 S II=$N(^LRO(68,LRAA,1,LRAD,1,LRAN,4,II)) Q:II<1  I $P(^(II,0),U,5),$P(^LAB(60,II,0),U,2) W !?5,$P(^(0),U) S Z=1
 I 'Z W !!,*7,?5,"There are not any AMIS/CAP for this Order Number",! S LRF=1 Q
 S X1=$N(^LRO(68,LRAA,1,LRAD,1,LRAN,4,0)),X=$S(X1>0:$P(^LAB(60,X1,0),"^",1),1:""),DA(4)=LRAA,DA(3)=LRAD,DA(2)=LRAN,DIC="^LRO(68,"_LRAA_",1,"_LRAD_",1,"_LRAN_",4,",DIC(0)="AEMNOQ"
 I $L(X),'$D(^LAB(60,X1,9)) S X=""
 S DIC("A")="Select ACCESSION TEST: ",DIC("S")="I $P(^(0),U,5),$P(^LAB(60,+Y,0),U,2)" D ^DIC I +Y<0 S LRF=1 Q
 S LRSY=+Y
 I '$D(^LAB(60,LRSY,9)) W !!,"There are no AMIS/CAP codes setup for this test in file 60.",!,*7 S LRZZ=LRZZ+1 K DIC("B") G II
 S LRO=0 D A^LRCAP2 Q
JJ F JJ=0:0 S JJ=$N(^LRO(68,LRAA,1,LRAD,1,LRAN,4,II,1,JJ)) Q:JJ<1  S J=J+1 W:J>1 ! W ?30,$P(^LAM($P(^(JJ,0),U,1),0),U,1),"  ",$P(^(0),U,2) I $Y>21 R !,"Press return to continue...",X:DTIME W @IOF
 Q
CLEAN F I=0:0 S I=$N(^LRO(68,I)) Q:I<1  F J=0:0 S J=$N(^LRO(68,I,1,J)) Q:J<1  F K=0:0 S K=$N(^LRO(68,I,1,J,1,K)) Q:K<1  K ^(K,"AE")
 F I=0:0 S I=$N(^LAM(I)) Q:I<1  F J=0:0 S J=$N(^LAM(I,1,J)) Q:J<1  K ^(J)
 Q
