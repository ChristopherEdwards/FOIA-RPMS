BNIGVLS ; IHS/CMI/LAB - gen ret show screens ;
 ;;1.0;BNI CPHD ACTIVITY DATASYSTEM;;DEC 20, 2006
 ;
SHOWP ;EP
 I '$D(BNIGDONE) W:$D(IOF) @IOF I $G(BNIGUI) W "ZZZZZZZ",!
 W !!?6,"REPORT/OUTPUT Type:"
 I BNIGCTYP="S" W !,?12,"Report includes sub-totals by ",$G(BNIGSORV)," and total count." Q
 I BNIGCTYP="T" W !,?12,"Report will include total only." Q
 I BNIGCTYP="C" W !?12,"SEARCH TEMPLATE ",$P(^DIBT(BNIGSTMP,0),U)," will be created.",!?12,"Total record count will be displayed." Q
 I BNIGCTYP="F" W !?12,"FLAT file of Area Database formatted records will be created.",!?12,"File Name: ",BNIGFILE
 Q:'$D(^BNIRTMP(BNIGRPT,12))
 W !?12,"PRINT Items Selected:"
 S (BNIGI,BNIGTCW)=0 F  S BNIGI=$O(^BNIRTMP(BNIGRPT,12,BNIGI)) Q:BNIGI'=+BNIGI  S BNIGCRIT=$P(^BNIRTMP(BNIGRPT,12,BNIGI,0),U) D
 .W !?12,$P(^BNIGRI(BNIGCRIT,0),U)," - column width ",$P(^BNIRTMP(BNIGRPT,12,BNIGI,0),U,2) S BNIGTCW=BNIGTCW+$P(^(0),U,2)+2
 .I $Y>(BNIIOSL-5) D PAUSE^BNIGVL W:$D(IOF) @IOF I $G(BNIGUI) W "ZZZZZZZ",!
 W !?12,"Total Report width (including column margins - 2 spaces):   ",BNIGTCW
 Q
SHOW ;EP
 W:$D(IOF) @IOF I $G(BNIGUI) W "ZZZZZZZ",!
 I $D(BNIGDONE) S BNIGLHDR="REPORT SUMMARY" W ?((80-$L(BNIGLHDR))/2),BNIGLHDR,!
 W !!?6,"CPHAD Activity Record Selection Criteria:"
 W:BNIGTYPE["R" !?12," Date range:  ",BNIGBDD," to ",BNIGEDD
 Q:'$D(^BNIRTMP(BNIGRPT,11))
 S BNIGI=0 F  S BNIGI=$O(^BNIRTMP(BNIGRPT,11,BNIGI)) Q:BNIGI'=+BNIGI  D
 .I $Y>(BNIIOSL-5) D PAUSE^BNIGVL W @IOF I $G(BNIGUI) W "ZZZZZZZ",!
 .W !?12,$P(^BNIGRI(BNIGI,0),U),":  "
 .K BNIGQ
 .S BNIGY="",BNIGC=0 F  S BNIGY=$O(^BNIRTMP(BNIGRPT,11,BNIGI,11,"B",BNIGY)) S BNIGC=BNIGC+1 Q:BNIGY=""!($D(BNIGQ))  W:BNIGC'=1 " ; " S X=BNIGY X:$D(^BNIGRI(BNIGI,2)) ^(2) W X
 K BNIGC,BNIGQ
 Q
SHOWR ;EP
 I '$D(BNIGDONE) W:$D(IOF) @IOF I $G(BNIGUI) W "ZZZZZZZ",!
 W !!?6,"SORT Item:"
 I BNIGCTYP="T" W !?12,"Total only will be displayed, no sorting done.",! Q
 I BNIGCTYP="C" W !?12,"Search Template being created, no sorting done.",! Q
 Q:'$G(BNIGSORT)
 W !?12,"CPHAD Activity Records will be sorted by:  ",$P(^BNIGRI(BNIGSORT,0),U),!
 Q
