FHCTF1 ; HISC/REL/NCA - Display Tickler File ;4/6/01  08:43
 ;;5.0;Dietetics;**29**;Oct 11, 1995
E0 W !!,"Select CLINICIAN (or ALL): ",$P($G(^VA(200,DUZ,0)),"^",1)," // " R X:DTIME G:'$T!(X="^") KIL
 I X="" S FHDUZ=DUZ G DISP
 D TR^FH I X="ALL" S FHDUZ=0 G DISP
 K DIC S DIC="^VA(200,",DIC(0)="AQEM",DIC("A")="Select CLINICIAN: ",DIC("B")=$P($G(^VA(200,DUZ,0)),"^",1) W ! D ^DIC K DIC G KIL:"^"[X!$D(DTOUT),E0:Y<1 S FHDUZ=+Y
DISP ; Display Tickler File
E1 S %DT="AEFX",%DT("A")="Through Date: ",%DT("B")="TODAY" W ! D ^%DT S:$D(DTOUT) X="^" G KIL:U[X,E1:Y<1 S EDT=+Y+.3
E2 W ! K IOP,%ZIS S %ZIS("A")="Select LIST PRINTER: ",%ZIS="MQ" D ^%ZIS K %ZIS,IOP G:POP KIL
 I $D(IO("Q")) S FHPGM="Q0^FHCTF1",FHLST="EDT^FHDUZ" D EN2^FH G KIL
 U IO D Q0 D ^%ZISC K %ZIS,IOP G KIL
Q0 ; Process Displaying Tickler File Entries
 D ^FHCTF4 S (CNT,PG)=0,YN="" G:FHDUZ Q1
 F FHDUZ=0:0 S FHDUZ=$O(^FH(119,FHDUZ)) Q:FHDUZ<1  I $O(^FH(119,FHDUZ,"I",EDT+1),-1) D Q1 Q:YN="^"
 Q
Q1 D HDR F K=0:0 S K=$O(^FH(119,FHDUZ,"I",K)) Q:K<1!(K>EDT)  S FHTF=^(K,0) D:$Y>(IOSL-5) HDR Q:YN="^"  D D2
 I 'CNT W !!,"No Tickler File Entries"
 W ! Q
D2 S DTP=$P(FHTF,"^",1),TYP=$P(FHTF,"^",2),X=$P(FHTF,"^",3),DFN=$P(FHTF,"^",4),ADM=$P(FHTF,"^",5),FHOR=$P(FHTF,"^",6)
 D DTP W !!,DTP,?18,$S(TYP="C":"Consult",TYP="S":"SF Review",TYP="D":"Diet Review",TYP="X":"Personal",TYP="T":"Tubefeed",TYP="N":"Status",1:""),": ",X
 I DFN W !?18,$P($G(^DPT(DFN,0)),"^",1)," (",$E($P($G(^(0)),"^",9),6,9),")  "
 I DFN S FHWRD=$P($G(^FHPT(DFN,"A",ADM,0)),"^",8) W $P($G(^FH(119.6,+FHWRD,0)),"^",1),"  ",$P($G(^DPT(DFN,.101)),"^",1)
 S CNT=CNT+1 Q
DTP ; Printable Date/Time
 S %=DTP,DTP=$J(+$E(DTP,6,7),2)_"-"_$P("Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec"," ",+$E(DTP,4,5))_"-"_$E(DTP,2,3)
 S:%#1 %=+$E(%_"0",9,10)_"^"_$E(%_"000",11,12),DTP=DTP_$J($S(%>12:%-12,1:+%),3)_":"_$P(%,"^",2)_$S(%<12:"am",%<24:"pm",1:"m") K % Q
HDR ; Display Header
 I PG,IOST?1"C-".E R !!,"Press RETURN to continue or ""^"" to exit. ",YN:DTIME S:'$T!(YN["^") YN="^" Q:YN="^"  I "^"'[YN W !,"Enter Return or ""^""." G HDR
 W:'($E(IOST,1,2)'="C-"&'PG) @IOF
 S PG=PG+1,DTP=NOW D DTP^FH W !,DTP,?28,"T I C K L E R   F I L E",?73,"Page ",PG
 W !!,$P(^VA(200,FHDUZ,0),"^",1) S DTP=EDT\1 D DTP^FH W ?64,"Thru: ",DTP
 S $P(LN,"-",80)="" W !,LN,! Q
KIL G KILL^XUSCLEAN
