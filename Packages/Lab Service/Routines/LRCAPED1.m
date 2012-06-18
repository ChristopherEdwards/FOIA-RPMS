LRCAPED1 ;SLC/DCM- MANUAL EDIT OF WORKLOAD FILE (CONT.) ;9/1/89  15:46 ;
 ;;V~5.0~;LAB;;02/27/90 17:09
 S LRTIME=LRTIM,LREND=0 S:'$D(LRTST) LRTST=""
 S II=$S(LRA>0:-1,1:1)
 I LRA>10,LRX'="R" S ZTDESC="LAB AMIS/CAP",ZTDTH=DT_"."_2200,ZTRTN="DQ^LRCAPED1",(ZTSAVE("L*"),ZTIO,ZTSAVE("II"))="" W !!,"WORKLOAD entries will be added as a background task later tonight." D ^%ZTLOAD K ZTRTN,ZTSAVE,ZTSK,DIC G ASK
 D ADD F JJ=LRA+II:II:0 D AD1 Q:LREND
ASK D LIST S %=1 W !!,"Are you finished viewing the workload data for this CAP code." D YN^DICN I %=2 D:LRX="R" CT D LIST,ADD,AD1,^LRCAPED2 G ASK
 K %,DIC,XX,KK,JJ
 Q
ADD W !!,$S(LRA>0&(LRX'="R")&(LRTIME=LRTIM):"Hold on while I create "_LRA_" WORKLOAD entries...",1:"You may select an existing workload date to edit."),!
 Q
AD1 S Y=1,DIC=67.9 S:'$D(LRURG) LRURG="" S:'$D(LRTS) LRTS="" S:'$D(LRTSA) LRTSA="" S:'$D(LRLOCAB) LRLOCAB="" L ^LRO(67.9)
AD2 S LRTIM=LRTIM+.000001 G:$D(^LRO(67.9,"B",LRTIM)) AD2 I LRA>0,LRX'="R" G B
A S DIC=67.9,DIC(0)=$S(LRA<0:"AEMQZ",1:"ALEMQZ"),DIC("S")="I $P($P(^(0),U),""."")=$P(LRTIM,""."")" D ^DIC K DIC("S") I Y<1 S LREND=1 Q
 L  S DA=+Y,DIE=DIC
 I LRX="Q",$P(Y(0),"^",13),$P(Y(0),"^",13)'=62.3 W *7,!,"THIS IS NOT A QC ENTRY" G A
 I LRX="R",'$P(Y(0),"^",14),LRA<0 W *7,!,"THIS ENTRY DOES NOT HAVE ANY REPEATS!" G A
 I LRX="R" S:LRA<0&($P(Y(0),"^",14)'>-LRA)!(LRA>0) LREND=1 W:LRA<0 !,$S(-LRA>$P(Y(0),"^",14):$P(Y(0),U,14),1:-LRA)," REPEAT(s) to be removed."
 I '$D(^LRO(67.9,+Y,1,0)) D C
 I $D(^LRO(67.9,+Y,1,0)) S DR="7///^S X=$S($D(^DIC(3,DUZ,0)):$P(^(0),U,2),1:"""");.01;2;3;5;6;9;9.1;10;12;13" D ^DIE K DIE Q
A1 I LRX="R" S DR(1,67.9,1)="12///^S X=$S($L($P(^LRO(67.9,DA,0),U,14)):$S($P(^(0),U,14)+LRA<1:""@"",1:$P(^(0),U,14)+LRA),1:LRA)"
 I $D(LRIN),LRIN S DR(1,67.9,2)="13///^S X=1"
 I LRX'="R",LRA<0 S DR=".01///^S X=""@"""
 D ^DIE K DIE
 Q
LIST W !!?5,"Do You Want To See the List " S %=2,LREND=0 D YN^DICN Q:%'=1  D HEAD
 S I=0 F A=0:0 S I=$O(^LRO(67.9,"AR",$P(LRTIM,".",1),LRCAP,I)) Q:I=""  S XX=^LRO(67.9,I,0) D J Q:LREND
 D EQUALS^LRX W !?5,"'*' MEANS THAT DATE HAS REPEATS",?40,"'#' MEANS THAT DATE IS FOR QC"
 Q
J I $Y>22 S LREND=0 R !,"Press Return .. or '^' to Escape ",X:DTIME I '$T!(X["^") S LREND=1 Q
 I $Y>22 D HEAD
 S Y=$P(XX,"^",1) X ^DD("DD") W !,Y,?18,$E($S($P(XX,"^",3):$P(^LAB(60,$P(XX,"^",3),.1),"^",1),1:$P(XX,"^",3)),1,20),?38,$E($P(XX,"^",4),1,17),?55
 W $S($D(^LAB(62.05,+$P(XX,U,7),0)):$E($P(^(0),U),1,9),1:$P(XX,U,7)),?65,$P(XX,"^",8),?72,$P(XX,"^",9) W:$P(XX,"^",14) ?77,"*" W:$P(XX,"^",13)=62.3 ?78,"#"
 Q
C S DR=$S(LRTST:"2///`"_LRTST_";",1:"")_"3///^S X=LRLOCAB;5///^S X=LRTS;5.1///^S X=LRTSA;6///^S X=LRURG;7///^S X=$S($D(^DIC(3,DUZ,0)):$P(^(0),U,2),1:"""");9///^S X=LRSB;9.1///^S X=LRM;10///`"_LRCAP_";11///^S X=$S(LRX=""Q"":62.3,1:2)"
 Q
B L  S LRIFN=$P(^LRO(67.9,0),"^",3)
B1 S LRIFN=LRIFN+1 G:$D(^LRO(67.9,LRIFN)) B1 S ^LRO(67.9,LRIFN,0)=LRTIM_"^^"_LRTST_U_LRLOCAB_"^^"_LRTS_U_LRURG_U_$S($D(^DIC(3,DUZ,0)):$P(^(0),U,2),1:"")_"^^"_LRSB_U_LRTSA_U_LRM_U_$S(LRX="Q":62.3,1:2)_"^^"_$S($D(LRIN):LRIN,1:"")
 S $P(^LRO(67.9,0),"^",3)=LRIFN,$P(^(0),U,4)=$P(^(0),U,4)+1,^LRO(67.9,"B",LRTIM,LRIFN)="" S:$L(LRSB) ^LRO(67.9,"AE",$E(LRSB,1,30),LRIFN)="" S ^LRO(67.9,LRIFN,1,0)="^67.9001P^1^1",^(1,0)=LRCAP,^LRO(67.9,"AR",$P(LRTIM,"."),LRCAP,LRIFN)=""
 Q
HEAD W @IOF,!,"Listed below are the dates' WORKLOAD file entries for this CAP code.",!
 W !,"REPORT DATE",?18,"TEST NAME",?38,"LOCATION",?55,"URGENCY",?65,"TECH",?72,"ORDER #" D DASH^LRX
 Q
CT W !,"Current workload count for next date is ",LRA,". Do you wish to change it" S %=1 D YN^DICN I %=1 R !,"Select WORKLOAD COUNT: ",LRA:DTIME
 I %=0 W !,"Enter the positive or negative amount you want entered for the next WORKLOAD." G CT
 Q
DQ K ^%ZTSK(ZTSK) F JJ=LRA+II:II:0 D AD1
 K ZTSK Q
