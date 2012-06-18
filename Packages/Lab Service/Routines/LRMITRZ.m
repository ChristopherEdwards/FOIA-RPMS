LRMITRZ ;AVAMC/REG,SLC/BA- MICRO TREND SHEET ; 2/14/89  17:11 ;
 ;;V~5.0~;LAB;;02/27/90 17:09
 ;from option LRMITRZ
BEGIN K ^UTILITY($J) S U="^",LRLOS=0 S:'$D(DTIME) DTIME=99 S IOP="HOME" D ^%ZIS,TREND W ! X ^%ZIS("C")
END K ^UTILITY($J),%,%DT,B,C,DFN,DIC,DTOUT,DUOUT,I,J,K,LAST,LRAB,LRADMD,LRADMS,LRANTI,LRAO,LRAP,LRASK,LRATS,LRBA,LRBEG,LRBG,LRBI,LRBN,LRBO,LRBUG,LRCBA,LRCOL,LRCT
 K LRCTB,LRDAT,LRDCHD,LRDFN,LRDOC,LREND,LRFIN,LRIDT,LRLLOC,LRLOS,LRM,LRND,LRNO,LRNUM,LROK,LRPAT,LRPG,LRPNM,LRPROMPT,LRSEQ,LRSGL,LRSINGLE,LRSM,LRSSP,LRST,LRSTAR
 K LRT,LRTOT,LRTSAL,LRTYPE,LRYY,O,P,PNM,POP,R,S,X,Y,Z,ZTDTH,ZTIO,ZTRTN,ZTSAVE,ZTSK,LRLIN,LRZ
 Q
TREND W @IOF,?20,"MICROBIOLOGY ANTIMICROBIAL TREND SHEET"
 F I=0:0 S %=1 W !!,"Use default reports" D YN^DICN Q:%'=0  D INFO
 Q:%<0
 S (LRM("O","S"),LRM("S","S"),LRM("L","S"),LRM("D","S"),LRM("P","S"),LRM("C","S"))="Unknown" F I="O","S","L","D","P","C" S LRM(I)=$S($D(^LAB(69.9,1,"MIT","B",I)):"A",1:"N")
 I %=2 S LREND=0 D ^LRMITRZA Q:LREND
 I LRM("O")="N",LRM("S")="N",LRM("L")="N",LRM("D")="N",LRM("P")="N",LRM("C")="N" W !,"No reports were selected!" Q
 S %DT="AE",%DT("A")="Start with Month/Year: " D ^%DT K %DT Q:Y<1  S LRSTAR=$E(Y,1,5)_"00"
 S %DT="AE",%DT("A")="End with Month/Year: " D ^%DT K %DT Q:Y<1  S LAST=$E(Y,1,5)_"00"
 I LAST<LRSTAR S X=LRSTAR,LRSTAR=LAST,LAST=X
 S Y=LRSTAR D D^LRU S LRBEG=Y,Y=LAST D D^LRU S LRFIN=Y,LAST=$E(LAST,1,5)_99
 S LRATS=9999999-LRSTAR,LRTSAL=9999999-LAST
DEVICE S %ZIS="MNQ",%ZIS("B")="",IOP="Q" W ! D ^%ZIS K %ZIS Q:POP  S %DT="AET",%DT("A")="TIME TO RUN: T+1@1AM//" D ^%DT S:Y>0 ZTDTH=Y I Y'>0 S %DT="T",X="T+1@1AM" D ^%DT S ZTDTH=Y
 I '$D(IO("Q")) D DQ^LRMITRZ1 Q
 S ZTRTN="DQ^LRMITRZ1",ZTSAVE("L*")="" D ^%ZTLOAD K IO("Q"),ZTRTN,ZTIO,ZTSAVE,Z,ZTSK
 Q
INFO W !,"Default reports are setup in the Laboratory Site file, 69.9."
 W !,"If you answer 'NO', you can select individual antibiotic trend reports",!,"grouped by: organism, site/specimen, location, patient, physician, and/or",!,"collection sample.  You can select all items or a single item for each group."
 W !,"Example: a trend report on a single patient."
 Q
