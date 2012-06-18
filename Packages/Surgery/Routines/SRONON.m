SRONON ;B'HAM ISC/ADM - NON-O.R. PROCEDURE REPORT ; [ 01/29/98  6:30 AM ]
 ;;3.0; Surgery ;**48,77**;24 Jun 93
 I '$D(SRSITE) D ^SROVAR S SRSITE("KILL")=1
 S SRSOUT=0 I '$D(SRTN) D NON G:'$D(SRTN) END
 Q:'$D(SRTN)  Q:SRTN<1
 K %ZIS,IO("Q") S %ZIS="Q" D ^%ZIS G:POP END I $D(IO("Q")) K IO("Q") S ZTRTN="RPT^SRONON",ZTDESC="NON-O.R. PROCEDURE REPORT",ZTSAVE("SRSITE(")="",ZTSAVE("SRTN")=SRTN,ZTSAVE("SRT")="UL" D ^%ZTLOAD G END
RPT ; entry when queued
 S SRSOUT=0 S:$E(IOST)="P" SRT="UL" U IO S VV=0 G ^SRONON0
HDR I $D(ZTQUEUED) D ^SROSTOP I SRHALT S SRSOUT=1 Q
 S:'($D(SRT)#2) SRT="Q" S VV=VV+1 W:$Y @IOF W !!!! D UL W !,?5,"MEDICAL RECORD            |  NON-O.R. PROCEDURE REPORT   PAGE ",VV D UL W !,?30,"Case #:",SRTN W:$P($G(^SRF(SRTN,30)),"^") "  *ABORTED*" D UL
 Q
FOOT Q:SRSOUT  I $E(IOST)'="P" D PRESS Q
 W ! D UL W !,"PROVIDER'S SIG: ",?50 D NOW^%DTC S Y=% D D^DIQ W $P(Y,"@")_"  "_$E($P(Y,"@",2),1,5)
 D UL S DFN=$P(^SRF(SRTN,0),U,1) Q:DFN=""  D DEM^VADPT
 S X1=$E($P(^SRF(SRTN,0),"^",9),1,7),X2=$P(VADM(3),"^"),SRAGE=$E(X1,1,3)-$E(X2,1,3)-($E(X1,4,7)<$E(X2,4,7))
 W !,$E(VADM(1),1,30),?50,"AGE: ",SRAGE,?60,"ID#: ",VA("PID"),!,"WARD: ",$S($D(^DPT(DFN,.1)):^(.1),1:""),?50,"ROOM-BED: ",$S($D(^DPT(DFN,.101)):^(.101),1:"")
 D UL W !,"VAMC: "_SRSITE("SITE")
PRESS I SRT="Q" W ! K DIR S DIR("A")="Press RETURN to continue  ",DIR(0)="FOA" D ^DIR K DIR I $D(DTOUT)!$D(DUOUT) S SRSOUT=1
 Q
UL Q:SRT'="UL"!(SRSOUT)  I IO(0)=IO,'$D(ZTQUEUED) W !
 W $C(13) F X=1:1:79 W "_"
 Q
END W ! D ^SRSKILL D ^%ZISC W @IOF I $D(SRSITE("KILL")) K SRSITE
 Q
NON K DIC S DIC("A")="Select Patient: ",DIC=2,DIC(0)="QEAMZ" D ^DIC I Y<0 S SRSOUT=1 G END
 S DFN=+Y D DEM^VADPT S SRNM=VADM(1)
 W @IOF,!,"Non-O.R. Procedures for "_SRNM_" ("_VA("PID")_")" I $D(^DPT(DFN,.35)) S Y=$P(^(.35),"^") I Y D D^DIQ S Y=$P(Y,"@")_" "_$P(Y,"@",2) W !,"  (DIED ON "_Y_")"
 W !! S (SROP,CNT)=0 F I=0:0 S SROP=$O(^SRF("ANOR",DFN,SROP)) Q:'SROP  D LIST
SEL W !!!,"Select Procedure: " R X:DTIME I '$T!("^"[X) G END
 I '$D(SRCASE(X)) W !!,"Enter the number corresponding to the procedure for which you want to print",!,"a report." G SEL
 S SRTN=+SRCASE(X)
 Q
LIST ; list case
 I $Y+5>IOSL S SRBACK=0 D SEL^SROPER Q:$D(SRTN)!(SRSOUT)  W @IOF,!,?1,"NON-O.R. PROCEDURES FOR "_VADM(1)_" ("_VA("PID")_")",! I SRBACK S CNT=0,SROP=SRCASE(1)-1,SRDT=$P(SRCASE(1),"^",2)
 S CNT=CNT+1,SRSDATE=$P(^SRF(SROP,0),"^",9),SROPER=$P(^SRF(SROP,"OP"),"^"),SRCASE(CNT)=SROP
 K SROPS,MM,MMM S:$L(SROPER)<55 SROPS(1)=SROPER I $L(SROPER)>54 S SROPER=SROPER_"  " F M=1:1 D LOOP Q:MMM=""
 S Y=SRSDATE D D^DIQ S SRSDATE=$P(Y,"@")_" "_$P(Y,"@",2)
 W !,CNT_".",?4,SRSDATE,?25,SROPS(1) I $D(SROPS(2)) W !,?25,SROPS(2) I $D(SROPS(3)) W !,?25,SROPS(3) I $D(SROPS(4)) W !,?25,SROPS(4)
 W !
 Q
LOOP ; break procedure if greater than 55 characters
 S SROPS(M)="" F LOOP=1:1 S MM=$P(SROPER," "),MMM=$P(SROPER," ",2,200) Q:MMM=""  Q:$L(SROPS(M))+$L(MM)'<55  S SROPS(M)=SROPS(M)_MM_" ",SROPER=MMM
 Q
