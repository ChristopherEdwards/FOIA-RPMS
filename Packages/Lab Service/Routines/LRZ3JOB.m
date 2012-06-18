LRJOB ;SLC/DCM- JOB AUTOMATED LAB ROUTINES ; 8/22/88  11:48 ;6/22/88  4:39 PM
 ;;V~3.051~
INST S U="^" W !,"This is an option to manually start automated Lab routines that "
 W !,"for some reason did not get started by the master lab program."
 W !!,"Have you checked the status of the Lab computer (LSI)?" S %=1 D YN^DICN G LA2:%=1
LA3 D ASK^LR1103 W !!,"Is the Lab computer working?" S %=1 D YN^DICN G LA3:%'=1
LA2 W !,?5,"AUTOMATED INSTRUMENT",?35,"ROUTINE NAME",!,?5,"--------------------",?35,"------------"
 F I=0:0 S I=$N(^LAB(62.4,I)) Q:I<1!(I>98)  W !,I,?5,$P(^LAB(62.4,I,0),U,1),?35,$P(^(0),U,3) W:$D(^LA(I)) ?45,"Has data." W:$D(^LA("LOCK",I)) ?55,"Running flag set."
 S DIC=62.4,DIC(0)="AEMQ",DIC("S")="I Y<99" D ^DIC K DIC I Y<1 W !,"NO JOB SELECTED",! G END
 S LRJOB="^"_$P(^LAB(62.4,+Y,0),U,3),LRJOBN=+Y
 S DIC=3.5,DIC(0)="EM",X=$S(LRJOBN>10:$E(LRJOBN-1,1)_1,1:1),X=$P(^LAB(62.4,X,0),U,2) D ^DIC G RONG:Y<0,RONG:^%ZOSF("VOL")'=$P(^%ZIS(1,+Y,0),U,9)&($P(^(0),U,9)]"") ;AC/SFISC
A W !!!,"System status will tell you if the automated routine is running."
 W !,"Look for the name of the routine in the system status.",!
 X ^LAB("X","%SS")
 W !,"Is the routine name listed in the system status?" S %=2 D YN^DICN I %=1 W !,"You do not want to start a job that is running!!",*7 G END
 W !,"Do you want to start the automated ",LRJOB," routine now?" S %=1 D YN^DICN G END:%'=1
 I LRJOBN#10=1 S T=LRJOBN D SET^LAB
JOB I '$D(^LA(LRJOBN,"I")) W !!,*7,"There is no data in that file to be processed!!!  JOB NOT STARTED!!!",*7 G END
 K ^LA("LOCK",LRJOBN) S ZTRTN=LRJOB,ZTDTH=$H,ZTIO="" D ^%ZTLOAD K ZTSK,ZTRTN,LRJOB,ZTDTH W !,"Check system status to see if job started."
 H 2 W "." H 2 X ^LAB("X","%SS")
END K I,LRPGM,LRTIME,LRIO,Y,DIC,LRJOB,LRJOBN,% Q
RONG W !!,*7,"The job selected is not interfaced to this computer!",! G END
 ;*** NOTE***
 ;PATCHES HAVE BEEN INSERTED INTO THIS ROUTINE IN ORDER TO RUN WITH KERNEL V6.
 ;INSERTED BY AC/SFISC 10-30-88.  UNVERIFIED PATCHES.
 ;Line> LA2+4
 ;replace> $L($P(^%ZIS(1,+Y,0),U,9))
 ;with> ^%ZOSF("VOL")'=$P(^%ZIS(1,+Y,0),U,9)&($P(^(0),U,9)]"")
