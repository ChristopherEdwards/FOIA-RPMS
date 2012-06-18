LRJOB ;SLC/DCM- JOB AUTOMATED LAB ROUTINES ;4/27/89  09:41 ;
 ;;V~5.0~;LAB;;02/27/90 17:09
INST S U="^",$P(LRDASH,"-",79)="" W !,"This is an option to manually start automated Lab routines that "
 W !,"for some reason did not get started by the master lab program."
 W !!,"Have you checked the status of the Lab computer (LSI)?" S %=1 D YN^DICN G LA2:%=1
LA3 D ASK^LR1103 W !!,"Is the Lab computer working?" S %=1 D YN^DICN G LA3:%'=1
LA2 D STATUS
 S DIC=62.4,DIC(0)="AEZMQ",DIC("S")="I Y<99" D ^DIC K DIC I Y<1 W !,"NO JOB SELECTED",! G END
 S LRJOB=$P(^LAB(62.4,+Y,0),U,3),LRJOBN=+Y,ZTIO=""
 S X=$S(LRJOBN>10:$E(LRJOBN-1,1)_1,1:1),(LRJOBIO,X)=$S($D(^LAB(62.4,X,0)):$P(^(0),U,2),1:"") G RONG:X']""
 S IOP=X,%ZIS="NQ" D ^%ZIS G RONG:POP I ^%ZOSF("VOL")'=$P(^%ZIS(1,IOS,0),U,9),$P(^(0),U,9)]"" S ZTIO=X G RONG ; This line contains a patch for V6
A ;
 S (LREND,TOT,LAB)=0 D EN1^LRSTATUS
 W !,"Is the automated instrument routine running?" S %=2 D YN^DICN I %=1 W !,"You do not want to start a job that is running!!",*7 G END
 W !,"Do you want to start the automated ** { ",LRJOB," } ** routine now?" S %=1 D YN^DICN G END:%'=1
 I LRJOBN#10=1 S T=LRJOBN,ZTIO=LRJOBIO D SET^LAB
JOB I '$D(^LA(LRJOBN,"I")) W !!,*7,"There is no data in that file to be processed!!!  JOB NOT STARTED!!!",*7 G END
 K ^LA("LOCK",LRJOBN) S ZTRTN=LRJOB,ZTDTH=$H S:'$D(ZTIO) ZTIO="" D ^%ZTLOAD K ZTSK,ZTRTN,ZTDTH W !,"Re-check later to see if job is running."
END K I,LRPGM,LRTIME,LRIO,Y,DIC,LRJOB,LRJOBIO,LRJOBN,%,LRDASH,LREND Q
RONG W !!,*7,"The job selected is not interfaced to this computer!",! G END
STATUS ;DISPLAY LSI STATUS.
 W !! W LRDASH,! W !,?30,"LSI INTERFACE STATUS" W LRDASH,!
 W !,?6,"INST.",?18,"DATA",?25,"DATA",?34,"++ PROGRAM STATUS LINK +++",?67,"DEVICE"
 W !,?1," #",?6,"NAME",?18,"IN LA?",?25,"IN LAH?",?34,"NAME",?44,"ACTIVE",?52,"BY",?58,"TO",?67,"NAME"
 W LRDASH,! F IX=0:0 S IX=$O(^LAB(62.4,IX)) Q:IX<1!(IX>90)  D STA2
 W !! K IX Q
STA2 S X=$S($D(^LAB(62.4,IX,0)):^(0),1:"") W !,?1,$J(IX,2),?6,$E($P(X,"^",1),1,10),?18,$S($D(^LA(IX,"I")):"Yes",1:"No"),?25,$S($D(^LAH(+$P(X,"^",4))):"Yes",1:"No")
 W ?34,$P(X,"^",3),?44,$S($D(^LA("LOCK",IX)):"Yes",1:"No"),?52,$E($P(X,"^",7),1,3),?58 S Y=$P(X,"^",6) W $S(Y["LOG":"Acc.",Y["SEQN":"Seq.",Y["IDEN":"Invoice",Y["LLIST":"T/C",1:"")
 W ?67,$E($P(X,"^",2),1,10)
 Q
