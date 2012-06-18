LRCAP2 ;SLC/DCM- STUFF AMIS/CAP IN LAM GLOBAL CONT.; 6/23/87  12:41 ;9/1/89  15:19 ;
 ;;V~5.0~;LAB;**44**;02/27/90 17:09
A ;from LRCAP
 K LRA F LRI=0:0 S LRI=$N(^LAB(60,LRSY,9,LRI)) Q:LRI<1  S X=^(LRI,0),X1=$P(^LAM(+X,0),"^",1,2),LRA(LRI)=+X_"^"_$S($P(X,"^",3):"*"_X1,1:X1)
 D A3,A4,EDIT
 K LRENTRY,LRCNT,LRCCD,LRCCDE,LRIEN,II,JJ,J Q
EDIT ;
 W !,"(A)dd or (D)elete code: " R X:DTIME Q:X=""!(X="^")  G @($S($E(X,1)["A":"ADD",$E(X,1)["D":"DEL",1:"HELP"))
ADD ;
 W !,"Select codes to add: " R X:DTIME Q:X="^"  G:X="" EDIT I X["?" D HELP1 G ADD
 F I=1:1 S LRCCD=$P(X,",",I) Q:$P(X,",",I,99)=""  S:'$D(^LRO(68,LRAA,1,LRAD,1,LRAN,4,LRSY,1,0)) ^(0)="^68.14^^" S LRENTRY=$P(^(0),U,3),LRCNT=$P(^(0),U,4) D SET
 D A3,A4 G EDIT
SET Q:'$D(LRA(LRCCD))  S LRCCDE=$P(LRA(LRCCD),"^",1) Q:$D(^LRO(68,LRAA,1,LRAD,1,LRAN,4,"AB",LRCCDE))  S LRENTRY=LRENTRY+1
 S $P(^LRO(68,LRAA,1,LRAD,1,LRAN,4,LRSY,1,0),U,3)=LRENTRY,$P(^(0),U,4)=LRCNT+1 S ^LRO(68,LRAA,1,LRAD,1,LRAN,4,LRSY,1,LRENTRY,0)=LRCCDE,^LRO(68,LRAA,1,LRAD,1,LRAN,4,"AB",LRCCDE,LRSY,LRENTRY)=""
 Q
DEL ;
 W !,"Select codes to delete: " R X:DTIME Q:X="^"  G:X="" EDIT I X["?" D HELP1 G DEL
 Q:'$D(^LRO(68,LRAA,1,LRAD,1,LRAN,4,LRSY,1,0))  F I=1:1 S LRCCD=$P(X,",",I) Q:$P(X,",",I,99)=""  S LRCNT=$P(^LRO(68,LRAA,1,LRAD,1,LRAN,4,LRSY,1,0),U,4) D KILL
 D A3,A4 G EDIT
KILL Q:'$D(LRA(LRCCD))  S LRCCDE=$P(LRA(LRCCD),"^",1) Q:'$D(^LRO(68,LRAA,1,LRAD,1,LRAN,4,"AB",LRCCDE))  S LRIEN=$O(^LRO(68,LRAA,1,LRAD,1,LRAN,4,"AB",LRCCDE,LRSY,0)) Q:'$D(LRIEN)
 S $P(^LRO(68,LRAA,1,LRAD,1,LRAN,4,LRSY,1,0),U,4)=LRCNT-1 K ^LRO(68,LRAA,1,LRAD,1,LRAN,4,LRSY,1,LRIEN,0),^LRO(68,LRAA,1,LRAD,1,LRAN,4,"AB",LRCCDE,LRSY,LRIEN)
 I LRCNT-1<1 S $P(^LRO(68,LRAA,1,LRAD,1,LRAN,4,LRSY,1,0),U,3)=0,$P(^(0),U,4)=0
 Q
 W !!,"For test ~ "_$S($D(^LAB(60,LRSY,.1)):$P(^(.1),U),1:$P(^LAB(60,LRSY,0),U))_" ~ select from:",!
A3 W !,"The Amis/Cap codes currently captured for this test are: "
 W !!,?5,"TEST NAME",?30,"AMIS/CAP CODE",!?5,"---------",?30,"-------------"
 I $P(^LRO(68,LRAA,1,LRAD,1,LRAN,4,LRSY,0),U,5),$P(^LAB(60,+^(0),0),U,2) S II1=$P(^(0),U) W !?5,II1 D JJ
 W ! Q
JJ S J=0 F JJ=0:0 S JJ=$N(^LRO(68,LRAA,1,LRAD,1,LRAN,4,LRSY,1,JJ)) Q:JJ<1  S J=J+1 W:J>1 ! W ?30,$P(^LAM($P(^(JJ,0),U,1),0),U,1),"  ",$P(^(0),U,2)
 Q
A4 S LRI="" F A=0:0 S LRI=$O(LRA(LRI)) Q:LRI=""  W !,LRI,?4,$E($P(LRA(LRI),"^",2)_" "_$P(LRA(LRI),"^",3),1,35) I $D(LRA(LRI+1)) W ?40,LRI+1,?44,$E($P(LRA(LRI+1),"^",2)_" "_$P(LRA(LRI+1),"^",3),1,35) S LRI=1+LRI
 W !!?20," *  Indicates Default Amis/Cap Codes ",!
 Q
HELP W !!?15,"Enter an 'A' to add or 'D' to delete",!! D A3,A4 G EDIT
HELP1 W !,"Choose one (or more, separated by commas)" Q
