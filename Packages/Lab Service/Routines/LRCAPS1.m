LRCAPS1 ;SLC/DCM- CAP STATISTICS SUMMARY ; 2/6/89  11:46 ;
 ;;V~5.0~;LAB;;02/27/90 17:09
 K ^UTILITY($J) W !,"...HOLD ON, JUST A MINUTE PLEASE..."
II F II=0:0 S II=$N(^LAM(II)) Q:II<1  S X=^(II,0),LRT=$P(X,"^",1),LRUW=$P(X,"^",3),LRM=$P(X,"^",4),LRS=$P(X,"^",8),LRSB=$P(X,"^",9) D CHECK I LRCHECK D:LRALL JJ D:'LRALL LRA
 K LRT,LRNOT,II,JJ,KK,LRUW,LRM,LRS,LRSB,T4,T8,TO,TOS,T9,T6,T2,T3,T5,LRCHECK,S2,S3,S4,S5,S6,S7,S8,S9 Q
JJ F JJ=0:0 S JJ=$N(^LAM(II,1,JJ)) Q:JJ<1  D DATES
 Q
LRA F JJ=0:0 S JJ=$N(LRA(JJ)) Q:JJ<1  Q:'$D(^LAM(II,1,JJ))  D DATES
 Q
DATES S T2=0,T4=0,T5=0,T6=0,T8=0,T9=0,TO=0,TOS=0
 F KK=LRFDT:0 S KK=$N(^LAM(II,1,JJ,1,KK)) Q:KK<1!(KK>LRLDT)  D COUNT
 D UTL Q
COUNT S S2=$S($D(^LAM(II,1,JJ,1,KK,2)):^(2),1:0),S3=$S($D(^(3)):^(3),1:0),S6=$S($D(^(6)):^(6),1:0),S4=$S($D(^(4)):^(4),1:0),S8=$S($D(^(8)):^(8),1:0),S5=$S($D(^(5)):^(5),1:0),S9=$S($D(^(9)):^(9),1:0),S7=$S($D(^(7)):^(7),1:0)
 S S10=$S($D(^(10)):^(10),1:0)
 S T2=S2+T2+S3,T6=T6+S6,T4=T4+S4,T8=T8+S8
 S TO=TO+S10,TOS=TOS+(S7-S8) S T5=T5+S5,T9=T9+S9
 Q
CHECK ;from LRCAPL1
 S LRCHECK=0 I LRMAJ,LRSEC S LRCHECK=1 Q
 I 'LRMAJ F I=0:0 S I=$N(LRM(I)) Q:I<1  I LRM(I)=$P(^LAM(II,0),"^",4) S LRCHECK=1 Q
 I 'LRSEC S LRCHECK=0 F I=0:0 S I=$N(LRS(I)) Q:I<1  I I=$P(^LAM(II,0),"^",8) S LRCHECK=1 Q
 Q
UTL S LRNOT=0 I '$L(LRM) W !,"MISSING MAJOR SECTION IN FILE 64 FOR ",LRT,!,"Use the LRCAPE1 option to add missing information so that test can be included." S LRNOT=1
 I '$L(LRS) W !,"MISSING SECTION IN FILE 64 FOR ",LRT,!,"Use the LRCAPE1 option to add missing information so that test can be included." S LRNOT=1
 I '$L(LRSB) W !,"MISSING SUBSECTION IN FILE 64 FOR ",LRT,!,"Use the LRCAPE1 option to add missing information so that test can be included." S LRNOT=1
 I 'LRNOT,(T4+T8+TO+TOS+T9+T6+T2+T5) S ^UTILITY($J,JJ,LRM,LRS,LRSB,$P(^LAM(II,0),U))=LRUW_"^"_T4_"^"_T8_"^"_TO_"^"_TOS_"^"_T9_"^"_T6_"^"_T2_"^"_T5
 Q
