SRODICT ;B'HAM ISC/MAM - ENTER DATE OF DICTATION ; [ 07/27/98   2:33 PM ]
 ;;3.0; Surgery ;**50**;24 Jun 93
HDR W @IOF,!,?10,"Undictated Operations for "_$P(^VA(200,DUZ,0),"^"),! F CURLEY=1:1:80 W "-"
 Q
PRINT ; print operation information
 D:FLG HDR S FLG=0,Y=$P(^SRF(SRTN,0),"^",9) D D^DIQ S SRODT=Y
OPS S SROPER="Procedure(s): "_$P(^SRF(SRTN,"OP"),"^"),OPER=0 F I=0:0 S OPER=$O(^SRF(SRTN,13,OPER)) Q:OPER=""  D OTHER
 K SROPS,MM,MMM S:$L(SROPER)<50 SROPS(1)=SROPER I $L(SROPER)>49 S SROPER=SROPER_"  " F M=1:1 D LOOP Q:MMM=""
 D DEM^VADPT W !!,CNT_".",?6,"Case Number: "_SRTN,!,?10,"Patient: "_VADM(1)_"  ("_VA("PID")_")"
 W !,?13,"Date: ",$P(SRODT,"@",1)_"  "_$P(SRODT,"@",2),!,?13,"Ward: "_$S($D(^DPT(DFN,.101)):^DPT(DFN,.1)_"  "_^DPT(DFN,.101),1:"NOT AN INPATIENT")
 W !,?5,SROPS(1) W:$D(SROPS(2)) !,?19,SROPS(2) W:$D(SROPS(3)) !,?19,SROPS(3) W:$D(SROPS(4)) " ..."
 Q
ASK K X S TOT=SRTN("TOT") W !!,"Enter the number desired, or RETURN to continue  " R X:DTIME S:'$T X="^" S:X["^" SRFLG=1 D:X["?" Q G:X["?" ASK Q:X["^"
 I X,+X\1'=X W !!,"Please enter a whole number." G ASK
 S:X=""!(X<0)!(X>TOT) FLG=1 I X>0,(X<(TOT+1)) D OPTOP Q:SRFLG  D ANOTHER
 Q
EN1 ; find operations not dictated
 D HDR S (CNT,SRFLG,FLG,SRQ,SRTN)=0
 F  S SRTN=$O(^SRF("AUD",SRTN)) Q:SRTN=""!SRFLG  I $D(^SRF(SRTN,.1)),$P(^(.1),"^",4)=DUZ,$$DIV^SROUTL0(SRTN) S C=$S('$D(^SRF(SRTN,31)):1,$P(^(31),"^",6)="":1,1:0) I C S CNT=CNT+1,SRTN(CNT)=SRTN
 S SRTN("TOT")=CNT,CNT=0
CASES F  S CNT=$O(SRTN(CNT)) Q:'CNT!SRFLG  S SRTN=SRTN(CNT),DFN=$P(^SRF(SRTN,0),"^") D PRINT D:$Y+8>IOSL!'$O(SRTN(CNT)) ASK Q:SRQ!SRFLG
 I SRTN("TOT")=0 W !,"No undictated cases.",!!! K DIR S DIR(0)="E" D ^DIR
END D ^SRSKILL K SRTN W @IOF
 Q
OTHER ; other operations
 S SRLONG=1 I $L(SROPER)+$L($P(^SRF(SRTN,13,OPER,0),"^"))>250 S SRLONG=0,OPER=999,SROPERS=" ..."
 I SRLONG S SROPERS=$P(^SRF(SRTN,13,OPER,0),"^")
 S SROPER=SROPER_$S(SROPERS=" ...":SROPERS,1:", "_SROPERS)
 Q
LOOP ; break procedure if greater than 70 characters
 S SROPS(M)="" F LOOP=1:1 S MM=$P(SROPER," "),MMM=$P(SROPER," ",2,200) Q:MMM=""  Q:$L(SROPS(M))+$L(MM)'<50  S SROPS(M)=SROPS(M)_MM_" ",SROPER=MMM
 Q
OPRPT W !!,"Do you need to view the Operation Report ?  NO// " R SRYN:DTIME I '$T!(SRYN["^") S SRFLG=1 Q
 S SRYN=$E(SRYN) S:SRYN="" SRYN="N"
 I "YyNn"'[SRYN W !!,"Enter 'YES' to display the Operation Report for this case.  Enter 'NO' if you",!,"do not need to review the Operation Report prior to entering the date of",!,"dictation." G OPRPT
 I "Yy"[SRYN D ^SROPRPT1 S (SRFLG,SRQ)=0
 Q
Q W !!,"If you wish to enter a Date/Time of Dictation, enter the number of the operation",!,"desired.  NOTE:  Do NOT enter the case number.  Entering RETURN will continue",!,"the list.  Enter '^' to quit this option." Q
OPTOP S SRTN("NUM")=X,SRTN=SRTN(X),SRTN("CNT")=CNT S SRSOUT=0 D OPRPT Q:SRFLG
 W !! K DIE,DR,DA S DIE=130,DR="15T",DA=SRTN D ^DIE K DR,DIE,DA S:$D(DTOUT)!$D(Y) SRFLG=1
 Q
ANOTHER S CNT=SRTN("NUM") I '$O(SRTN(CNT)) S (SRFLG,SRQ)=1 Q
 W !!!,"Do you want to select another surgery case ?  YES//  " R SRYN:DTIME I '$T!(SRYN["^") S SRFLG=1 Q
 S SRYN=$E(SRYN) I "YyNn"'[SRYN W !!,"Enter 'YES' to enter the date of dictation for another case, or 'NO' to leave",!,"this option." G ANOTHER
 I "Yy"'[SRYN S SRFLG=1 Q
 S FLG=1,(SRFLG,SRQ)=0,SRTN=SRTN(CNT)
 Q
