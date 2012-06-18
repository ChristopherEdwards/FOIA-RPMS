BMCRLS ; IHS/PHXAO/TMJ - APC referral counts: show screens ;   
 ;;4.0;REFERRED CARE INFO SYSTEM;;JAN 09, 2006
 ;
SHOWP ;EP
 I '$D(BMCDONE) W:$D(IOF) @IOF
 W !!?6,"PRINT Items Selected:"
 I BMCCTYP="S" W !,?12,"Report includes sub-totals and total only." Q
 I BMCCTYP="T" W !,?12,"Report will includes total only." Q
 Q:'$D(^BMCRTMP(BMCRPT,12))
 S (BMCI,BMCTCW)=0 F  S BMCI=$O(^BMCRTMP(BMCRPT,12,BMCI)) Q:BMCI'=+BMCI  S BMCCRIT=$P(^BMCRTMP(BMCRPT,12,BMCI,0),U) D
 .W !?12,$P(^BMCTSORT(BMCCRIT,0),U)," - column width ",$P(^BMCRTMP(BMCRPT,12,BMCI,0),U,2) S BMCTCW=BMCTCW+$P(^(0),U,2)+2
 .I $Y>(IOSL-5) D PAUSE^BMCRL01 W:$D(IOF) @IOF
 W !!?12,"Total Report width (including column margins - 2 spaces):   ",BMCTCW
 Q
SHOW ;EP
 W:$D(IOF) @IOF
 I $D(BMCDONE) S BMCLHDR="REPORT SUMMARY" W ?((80-$L(BMCLHDR))/2),BMCLHDR,!
 ;W !!?6,$S(BMCPTVS="R":"REFERRAL",1:"PATIENT")_" Selection Criteria:"
 W !?6,"REFERRAL Selection Criteria:"
 Q:'$D(^BMCRTMP(BMCRPT,11))
 W !?12,$S(BMCTYPR="P":"PRIMARY REFERRALS",BMCTYPR="S":"SECONDARY REFERRALS",1:"PRIMARY AND SECONDARY REFERRALS")
 S BMCI=0 F  S BMCI=$O(^BMCRTMP(BMCRPT,11,BMCI)) Q:BMCI'=+BMCI  D
 .I $Y>(IOSL-5) D PAUSE^BMCRL01 W @IOF
 .W !?12,$P(^BMCTSORT(BMCI,0),U),":  "
 .K BMCQ
 .S BMCY="",BMCC=0 F  S BMCY=$O(^BMCRTMP(BMCRPT,11,BMCI,11,"B",BMCY)) S BMCC=BMCC+1 Q:BMCY=""!($D(BMCQ))  W:BMCC'=1 " ; " S X=BMCY X:$D(^BMCTSORT(BMCI,2)) ^(2) W X
 K BMCC,BMCQ
 Q
SHOWR ;EP
 I '$D(BMCDONE) W:$D(IOF) @IOF
 W !!?6,$S(BMCPTVS="R":"Referral",1:"Patient")_" SORTING Criteria:"
 Q:'$G(BMCSORT)
 W !?12,$S(BMCPTVS="R":"Referrals",1:"Patients")_" will be sorted by:  ",$P(^BMCTSORT(BMCSORT,0),U),!
 Q
