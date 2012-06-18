LRCAPW1 ;SLC/DCM- CAP WORKLOAD SUMMARY SORT ; 2/6/89  12:36 ;
 ;;V~5.0~;LAB;**41**;02/27/90 17:09
 K ^UTILITY($J) W !,"...HOLD ON A MOMENT PLEASE..."
II F II=LRFDT:0 S II=$N(^LRO(67.9,"B",II)) Q:II<1!(II>LRLDT)  D JJ
 K LRT,LRNOT,II,JJ,AA,KK,CH,CH1,CH2,FILE,RE,IN,URG,UW,A,X1,SUB,SEC
 Q
JJ F JJ=0:0 S JJ=$N(^LRO(67.9,"B",II,JJ)) Q:JJ<1  D CH2 I CH2 D KK
 Q
CH11 S CH1=0 F AA=0:0 S AA=$N(LRSHIFT(AA)) Q:AA<1  I CH=$P(LRSHIFT(AA),"-",1)!(CH>$P(LRSHIFT(AA),"-",1))&(CH=$P(LRSHIFT(AA),"-",2))!(CH<$P(LRSHIFT(AA),"-",2)) S CH1=AA Q
 Q
CH2 S CH2=0 Q:'$D(^LRO(67.9,JJ,0))  S X0=^(0),CH=$P($P(X0,U),".",2),CH=CH_$E("0000",($L(CH)+1),4)
 D CH11 Q:'CH1
 I LRMAJ,LRSEC S CH2=1 Q
 I 'LRMAJ F I=0:0 Q:CH2=1  S I=$N(^LRO(67.9,JJ,1,I)) Q:I<1  S X1=^(I,0),X1=$P(^LAM(X1,0),"^",4) F J=0:0 S J=$N(LRM(J)) Q:J<1  I LRM(J)=X1 S CH2=1 Q
 I 'LRSEC S CH2=0 F I=0:0 S I=$N(LRS(I)) Q:I<1  I I=$P(X0,"^",12) S CH2=1 Q
 Q
KK F KK=0:0 S KK=$N(^LRO(67.9,JJ,1,KK)) Q:KK<1  S X1=^(KK,0),X2=^LAM(X1,0),LRT=$P(X2,"^",1),X1=$P(X2,"^",4),UW=$S($P(X2,"^",3):$P(X2,"^",3),1:1),SEC=$P(X2,"^",8),SUB=$P(X2,"^",9) D UTL
 Q
UTL S LRNOT=0
 I '$L(SEC) W !,"MISSING SECTION IN FILE 64 FOR ",LRT,!,"Use the LRCAPE1 option to add missing information so that test can be included." S LRNOT=1
 I '$L(SUB) W !,"MISSING SUBSECTION IN FILE 64 FOR ",LRT,!,"Use the LRCAPE1 option to add missing information so that test can be included." S LRNOT=1
 Q:LRNOT  S:'$D(^UTILITY($J,X1,SEC,SUB,CH1)) ^(CH1)="0^0^0^0^0^0^0^0^0^0^0^0^0" S A=^(CH1)
 S FILE=$P(X0,"^",13),RE=$P(X0,"^",14),IN=$P(X0,"^",15),URG=$P(X0,"^",7)
 D:FILE=2 F2 D:FILE=62.3 F62 D:FILE'=2&(FILE'=62.3) REF S ^UTILITY($J,X1,SEC,SUB,CH1)=A
 Q
F2 I IN S $P(A,"^",1)=$P(A,"^",1)+1,$P(A,"^",2)=$P(A,"^",2)+UW S:URG=1 $P(A,"^",3)=$P(A,"^",3)+1 S:RE $P(A,"^",9)=$P(A,"^",9)+RE,$P(A,"^",10)=$P(A,"^",10)+(RE*UW) Q
 S $P(A,"^",4)=$P(A,"^",4)+1,$P(A,"^",5)=$P(A,"^",5)+UW S:URG=1 $P(A,"^",6)=$P(A,"^",6)+1 S:RE $P(A,"^",9)=$P(A,"^",9)+RE,$P(A,"^",10)=$P(A,"^",10)+(RE*UW)
 Q
F62 S $P(A,"^",9)=$P(A,"^",9)+1,$P(A,"^",10)=$P(A,"^",10)+UW S:RE $P(A,"^",9)=$P(A,"^",9)+RE,$P(A,"^",10)=$P(A,"^",10)+(UW*RE)
 Q
REF S $P(A,"^",7)=$P(A,"^",7)+1,$P(A,"^",8)=$P(A,"^",8)+UW S:RE $P(A,"^",9)=$P(A,"^",9)+RE,$P(A,"^",10)=$P(A,"^",10)+(RE*UW)
 Q
