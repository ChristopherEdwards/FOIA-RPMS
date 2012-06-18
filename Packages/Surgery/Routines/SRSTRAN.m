SRSTRAN ;B'HAM ISC/MAM,AM - TRANSCRIPTION ; 26 Jan 1989  7:35 AM
 ;;3.0; Surgery ;**48**;24 Jun 93
 D DT^DICRW S IOP="" D ^%ZIS K IOP
 I '$D(SRSITE) D ^SROVAR
EN2 S SRSOUT=0 K SRTN D SROPS G:'$D(SRTN) END W ! S SRNON=$S($P($G(^SRF(SRTN,"NON")),"^")="Y":1,1:0) D
 .I SRNON D ^SRONON Q
 .D EN2^SROPRPT
ASK S SRNON=$S($P($G(^SRF(SRTN,"NON")),"^")="Y":1,1:0) K DIR W ! S DIR("A")="Is this the correct "_$S(SRNON:"procedure",1:"operation")_" ?  ",DIR("B")="YES",DIR(0)="YA"
 S DIR("?",1)="If this is the "_$S(SRNON:"procedure",1:"operation")_" which you intend to transcribe, enter RETURN.",DIR("?")="Enter NO to select another case." D ^DIR K DIR G:$D(DTOUT)!$D(DUOUT) END I 'Y W @IOF G EN2
 S SRTQ=$S('$D(^SRF(SRTN,12,0)):0,1:$P(^(0),U,4))
 S DA=SRTN,DIE=130,DR=$S(SRNON:"1.15"_"Provider's Procedure Notes",1:"1.15T") D ^DIE K:$D(^SRF(SRTN,12)) ^SRF("ADIC",SRTN)
 W ! I $O(^SRF(SRTN,12,0)) S X="N",%DT="T" D ^%DT X ^DD("DD") S SRTDATE=Y,DIE=130,DA=SRTN,DR="39T//"_SRTDATE D ^DIE K DR
 W ! K DIR S DIR("A")="Do you want to print the "_$S(SRNON:"Non-OR Procedure",1:"Operative")_" Report ?  ",DIR("B")="YES",DIR(0)="YA" D ^DIR K DIR G:$D(DTOUT)!$D(DUOUT) END I Y D
 .I SRNON D ^SRONON Q
 .D ^SROPRPT
 W @IOF G EN2
END D ^SRSKILL K SRTN W @IOF
 Q
SROPS ; select patient and case
 W ! S SRSOUT=0 K DIC S DIC("A")="Select Patient: ",DIC=2,DIC(0)="QEAM" D ^DIC K DIC I Y<0 S SRSOUT=1 G END
 S DFN=+Y D DEM^VADPT D HDR
ADT S (SRDT,CNT,SRBACK)=0 F  S SRDT=$O(^SRF("ADT",DFN,SRDT)) Q:'SRDT!SRSOUT!$D(SRTN)!SRBACK  S SROP=0 F  S SROP=$O(^SRF("ADT",DFN,SRDT,SROP)) Q:'SROP!$D(SRTN)!SRSOUT!SRBACK  D LIST
 G:SRBACK ADT Q:$D(SRTN)
 I '$D(SRCASE(1)) W !!,"There are no cases entered for "_VADM(1)_".",!!,"Press RETURN to continue  " R X:DTIME G END
OPT S SRSOUT=0 W !!,"Select Case: " R X:DTIME I '$T!("^"[X) S SRSOUT=1 G END
 I '$D(SRCASE(X)) W !!,"Enter the number of the desired operation." G OPT
 S SRTN=+SRCASE(X)
 Q
LIST ; list cases
 S SRNON=0 I $P($G(^SRF(SROP,"NON")),"^")="Y" S SRNON=1
 I 'SRNON,'$P($G(^SRF(SROP,.2)),"^",10) Q
 I $D(^SRF(SROP,37)),$P(^(37),"^") Q
 I $Y+5>IOSL S SRBACK=0 D SEL Q:$D(SRTN)!(SRSOUT)  D HDR Q:SRBACK
 S CNT=CNT+1,SRSDATE=$P(^SRF(SROP,0),"^",9) W !,CNT_". "
CASE W $E(SRSDATE,4,5)_"-"_$E(SRSDATE,6,7)_"-"_$E(SRSDATE,2,3)
 S SROPER=$P(^SRF(SROP,"OP"),"^") I $O(^SRF(SROP,13,0)) S SROTHER=0 F I=0:0 S SROTHER=$O(^SRF(SROP,13,SROTHER)) Q:'SROTHER  D OTHER
 I SRNON S SROPER=SROPER_" (NON-OR PROCEDURE)"
 D:'SRNON ^SROP1 D LOCK K SROPS,MM,MMM S:$L(SROPER)<65 SROPS(1)=SROPER I $L(SROPER)>64 S SROPER=SROPER_"  " F M=1:1 D LOOP Q:MMM=""
 W ?14,SROPS(1) I $D(SROPS(2)) W !,?14,SROPS(2) I $D(SROPS(3)) W !,?14,SROPS(3) W:$D(SROPS(4)) !,?14,SROPS(4)
 W ! S SRCASE(CNT)=SROP_"^"_SRDT
 Q
SEL ; select case
 W ! K DIR S DIR("A")="Select case or enter RETURN to continue listing cases: ",DIR(0)="FOA" D ^DIR K DIR I $D(DTOUT)!$D(DUOUT) S SRSOUT=1 Q
 I X="" Q
 I '$D(SRCASE(X)) W ! S DIR("A",1)="Please enter the number corresponding to the case you want to edit.",DIR("A",2)="If the case desired does not appear, enter RETURN to continue listing",DIR("A",3)="additional cases."
 I '$D(SRCASE(X)) S DIR("A",4)="",DIR("A")="Press RETURN to continue  " D ^DIR K DIR S:$D(DTOUT)!$D(DUOUT) SRSOUT=1 S SRBACK=1 Q
 S SRTN=+SRCASE(X)
 Q
LOCK ; case locked?
 I $D(SRTN),$P($G(^SRF(SRTN,"LOCK")),"^") S SROPER=SROPER_" **LOCKED**"
 Q
OTHER ; other operations
 S SRLONG=1 I $L(SROPER)+$L($P(^SRF(SROP,13,SROTHER,0),"^"))>235 S SRLONG=0,SROTHER=999,SROPERS=" ..."
 I SRLONG S SROPERS=$P(^SRF(SROP,13,SROTHER,0),"^")
 S SROPER=SROPER_$S(SROPERS=" ...":SROPERS,1:", "_SROPERS)
 Q
LOOP ; break procedure
 S SROPS(M)="" F LOOP=1:1 S MM=$P(SROPER," "),MMM=$P(SROPER," ",2,200) Q:MMM=""  Q:$L(SROPS(M))+$L(MM)'<65  S SROPS(M)=SROPS(M)_MM_" ",SROPER=MMM
 Q
HDR ; print heading
 W @IOF,!,?1,VADM(1)_"   "_VA("PID") S X=$P($G(VADM(6)),"^") W:X "        * DIED "_$E(X,4,5)_"/"_$E(X,6,7)_"/"_$E(X,2,3)_" *" W !
 Q
