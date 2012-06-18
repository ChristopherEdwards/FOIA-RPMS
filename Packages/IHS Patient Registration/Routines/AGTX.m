AGTX ; IHS/ASDS/EFG - EXPORT REG DATA ;   
 ;;7.1;PATIENT REGISTRATION;;AUG 25,2005
 S:'$D(DTIME) DTIME=300 S:DTIME="" DTIME=300
 G START
HEADER ;EP -
 D:'$D(AGOPT) ^AGVAR
 U IO(0) W $$S^AGVDF("IOF"),! F I=1:1:79 W "*"
 W !,"*",?27,"EXPORT REGISTRATION DATA",?78,"*",! F I=1:1:79 W "*"
 W !
 Q
START S:'$D(DUZ) DUZ=1
 S:'$G(AGTXSITE) AGTXSITE=$P(^AUTTSITE(1,0),"^")
 S (AG("TOT"),AGBAD16,AGBAD26,AGBAD51,AGROUT)=0,IOP=ION D ^%ZIS,VIDEO^AG,HEADER
 F %=1:1:8 S AG("TOT",%)=0
 W !?10,"SITE NAME IS:  ",$P(^DIC(4,AGTXSITE,0),U)
 W !!,"The following are ""Parent Facilites for Registration""."
 W !!,"ONLY their Demographic and HRN Changes, Deletes, and Merges",!,"will be sent to NPIRS :",!
 S AGPSITE=0 F  S AGPSITE=$O(^AGFAC("AC",AGPSITE)) Q:'AGPSITE  W !,?10,$P(^DIC(4,AGPSITE,0),"^")
L11A W !!,"DO YOU WANT TO DISPLAY OUTPUT RECORDS ON SCREEN (Y/N) Y// " D READ^AG S Y=$E(Y_"Y") S AGOUTFLG=$S(Y="Y":1,Y="N":0,1:2) Q:$D(DUOUT)!$D(DTOUT)!$D(DFOUT)  I AGOUTFLG=2 D YN^AG G L11A
 D ^AGTX0
S2 G JOBEND^AGTX4:'$D(AGRR1) S AGRCT=0,AGLDATE=AGRR1 X XY,XYER
 G S2A^AGTX1
RESET ;EP -
 ;This function contained in agr1^agtxst
 W !,*7,"GOT TO RESET^AGTX IN ERROR",!
 Q
 S AG("X")=$P(^AGTXST(AGTXSITE,1,0),U,3)
 K ^AGTXST(AGTXSITE,1,AG("X"),0)
 S AG("X")=AG("X")-1 S $P(^AGTXST(AGTXSITE,1,0),U,3)=AG("X"),$P(^AGTXST(AGTXSITE,1,0),U,4)=AG("X")
 K AG("X")
 Q
REGEN ;EP - (from option) - Regenerate old tape.
 S AGTXSITE=$P(^AUTTSITE(1,0),"^")
 I '$D(^AGTXST(AGTXSITE)) W !,*7,"No export records for this facility.",! G ENTRETRN^AGTX4
 S DIC="^AGTXST(AGTXSITE,1,",DIC(0)="AEFMQZ",D="B",DZ="??" D DQ^DICQ,^DIC K DIC,D,DZ Q:Y<1
 S AG("REGEN")=Y(0)
 G AGTX
TEST ;EP - Test a transmission with a small date range
 S %DT="AE",%DT("A")="Start date: " D ^%DT Q:Y'>0  S AGBDT=Y
 S %DT="AE",%DT("A")="Stop date: ",%DT(0)=Y D ^%DT Q:Y'>0  S AGEDT=Y
 K %DT(0)
 S AG("REGEN")="^"_AGBDT_"^"_AGEDT
 S AGBDT=AGBDT,AGEDT=AGEDT+.9
 S AGLO="^AGPATCH("_AGBDT_")" F  S AGLO=$Q(@AGLO) Q:(AGLO=""!(AGLO["ER"))  S AGDT=$P(AGLO,"(",2),AGDT=$P(AGDT,",") Q:(AGDT>AGEDT)  W !,AGLO," = ",@AGLO
 K AGBDT,AGEDT
 W !,"EXITING WILL KILL AG(""REGEN"")",!
 S DIR(0)="E" D ^DIR I X["^" K AG("REGEN") Q
 G AGTX
