BWGRVLS ; IHS/CMI/LAB - APC visit counts - show screens ;15-Feb-2003 21:54;PLS
 ;;2.0;WOMEN'S HEALTH;**6,8**;MAY 16, 1996
 ;
SHOWP ;EP
 I '$D(BWGRDONE) W:$D(IOF) @IOF
 W !!?6,"REPORT/OUTPUT Type:"
 I BWGRCTYP="S" W !,?12,"Report includes sub-totals by ",$G(BWGRSORV)," and total count." Q
 I BWGRCTYP="T" W !,?12,"Report will include total only." Q
 I BWGRCTYP="C" W !?12,"SEARCH TEMPLATE ",$P(^DIBT(BWGRSTMP,0),U)," will be created.",!?12,"Total record count will be displayed." Q
 I BWGRCTYP="F" W !?12,"FLAT file of Area Database formatted records will be created.",!?12,"File Name: ",BWGRFILE
 Q:'$D(^BWGRTRPT(BWGRRPT,12))
 W !?12,"PRINT Items Selected:"
 S (BWGRI,BWGRTCW)=0 F  S BWGRI=$O(^BWGRTRPT(BWGRRPT,12,BWGRI)) Q:BWGRI'=+BWGRI  S BWGRCRIT=$P(^BWGRTRPT(BWGRRPT,12,BWGRI,0),U) D
 .W !?12,$P(^BWGRI(BWGRCRIT,0),U)," - column width ",$P(^BWGRTRPT(BWGRRPT,12,BWGRI,0),U,2) S BWGRTCW=BWGRTCW+$P(^(0),U,2)+2
 .I $Y>(IOSL-5) D PAUSE^BWGRVL W:$D(IOF) @IOF
 W !?12,"Total Report width (including column margins - 2 spaces):   ",BWGRTCW
 Q
SHOW ;EP
 W:$D(IOF) @IOF
 I $D(BWGRDONE) S BWGRLHDR="REPORT SUMMARY" W ?((80-$L(BWGRLHDR))/2),BWGRLHDR,!
 W !!?6,$S(BWGRPTVS="R":"WH PROCEDURE",1:"PATIENT")_" Selection Criteria:"
 W:BWGRTYPE="RP" !?12,"PATIENT Search Template: ",$P(^DIBT(BWGRSEAT,0),U)
 W:BWGRTYPE["R" !?12,"Procedure Date range:  ",BWGRBDD," to ",BWGREDD
 W:BWGRTYPE="PS" !?12,"PATIENT Search Template: ",$P(^DIBT(BWGRSEAT,0),U)
 Q:'$D(^BWGRTRPT(BWGRRPT,11))
 S BWGRI=0 F  S BWGRI=$O(^BWGRTRPT(BWGRRPT,11,BWGRI)) Q:BWGRI'=+BWGRI  D
 .I $Y>(IOSL-5) D PAUSE^BWGRVL W @IOF
 .W !?12,$P(^BWGRI(BWGRI,0),U),":  "
 .K BWGRQ
 .S BWGRY="",BWGRC=0 F  S BWGRY=$O(^BWGRTRPT(BWGRRPT,11,BWGRI,11,"B",BWGRY)) S BWGRC=BWGRC+1 Q:BWGRY=""!($D(BWGRQ))  W:BWGRC'=1 " ; " S X=BWGRY X:$D(^BWGRI(BWGRI,2)) ^(2) W X
 K BWGRC,BWGRQ
 Q
SHOWR ;EP
 I '$D(BWGRDONE) W:$D(IOF) @IOF
 W !!?6,"SORT Item:"
 I BWGRCTYP="T" W !?12,"Total only will be displayed, no sorting done.",! Q
 I BWGRCTYP="C" W !?12,"Search Template being created, no sorting done.",! Q
 Q:'$G(BWGRSORT)
 W !?12,$S(BWGRPTVS="R":"WH Procedures",1:"Patients")_" will be sorted by:  ",$P(^BWGRI(BWGRSORT,0),U),!
 Q
