AMQQAT11 ; IHS/CMI/THL - GETS OVERFLOW FROM AMQQAT1 ;
 ;;2.0;IHS PCC SUITE;;MAY 14, 2009
 ;-----
RUN W !,"Maximum sample size allowed is 50% of this total (",AMQQRNDN,")"
 W !!,"There are 2 ways to determine sample size =>",!
 W !?5,"1) Sample a certain NUMBER of cohort members"
 W !?5,"2) Sample a certain PERCENT of cohort members",!
 S AMQQCRFL=""
 D GET^AMQQAT1
 I $D(AMQQQUIT) Q
 I X=1 D S1^AMQQAT1 Q:$D(AMQQQUIT)  S AMQQCHNN=X G RAND
 D S2^AMQQAT1
 Q:$D(AMQQQUIT)
 S X=X*.01*AMQQCHTT
 S AMQQCHNN=X\1
RAND I $D(AMQQFFIL) Q
 N I,X,Y,Z,N,I
 I IOST["C-" W !!,"Collecting a random sample",!
 I +AMQQCHRT K ^UTILITY("AMQQ RAND",$J,+AMQQCHRT)
 S X=0
 S AMQQCHRT=AMQQCHRT_";"_$J_";"_AMQQCHNN
 S I=0
 S N=AMQQCHTT-1
 S AMQQLINK=$S(AMQQCCLS="P":166,1:86)
 F  S Y=$R(N)+1,Z=$O(^UTILITY("AMQQ TEMP",$J,Y,"")) I Z,'$D(^UTILITY("AMQQ RAND",$J,+AMQQCHRT,Z)) S ^(Z)="",I=I+1 W:IOST["C-" $C(13),I I I=AMQQCHNN Q
 K ^UTILITY("AMQQ TEMP",$J),AMQQRNDN
 Q
 ;
COUNT ; ENTRY POINT FROM AMQQAT1
 I IOST["C-" W !!!,"Counting " W:$D(AMQQCRFG) "cohort before sampling" W "...",!
 S X=0
 F I=0:1 S X=$O(^DIBT(AMQQCHRT,1,X)) Q:'X  W:IOST["C-"&('(I#100)) $C(13),I I $D(AMQQCRFG) S ^UTILITY("AMQQ TEMP",$J,I+1,X)=""
 I IOST["C-" W $C(13),"        ",$C(13),!!,"There are ",I," entries in this cohort" W:'$D(AMQQCRFG) !!!
 Q
 ;
STUFF ; ENTRY POINT FROM METADICTIONARY
 S AMQQCHRT=%
 S AMQQCRFG=""
 S AMQQCHNN=%(1)
 D COUNT
 K AMQQCRFG
 S AMQQCHTT=I
 D RAND
 K %,AMQQCHNN,AMQQCHRT,AMQQCHTT
 Q
 ;
