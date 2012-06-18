BCHRLS ; IHS/TUCSON/LAB - SHOW SCREENS ;  [ 10/28/96  2:05 PM ]
 ;;1.0;IHS RPMS CHR SYSTEM;;OCT 28, 1996
 ;
SHOWP ;EP
 I '$D(BCHDONE) W:$D(IOF) @IOF
 W !!?6,"PRINT Items Selected:"
 I BCHCTYP="S" W !?12,"Report includes sub-totals and total only." Q
 I BCHCTYP="T" W !?12,"Report will includes total only." Q
 Q:'$D(^BCHTRPT(BCHRPT,12))
 S (BCHI,BCHTCW)=0 F  S BCHI=$O(^BCHTRPT(BCHRPT,12,BCHI)) Q:BCHI'=+BCHI  S BCHCRIT=$P(^BCHTRPT(BCHRPT,12,BCHI,0),U) D
 .W !?12,$P(^BCHSORT(BCHCRIT,0),U)," - column width ",$P(^BCHTRPT(BCHRPT,12,BCHI,0),U,2) S BCHTCW=BCHTCW+$P(^(0),U,2)+2
 .I $Y>(IOSL-5) D PAUSE^BCHRL01 W:$D(IOF) @IOF
 W !!?12,"Total Report width (including column margins - 2 spaces):   ",BCHTCW
 Q
SHOW ;EP
 W:$D(IOF) @IOF
 I $D(BCHDONE) S BCHLHDR="REPORT SUMMARY" W ?((80-$L(BCHLHDR))/2),BCHLHDR,!
 W !!?6,$S(BCHPTVS="V":"VISIT",1:"PATIENT")_" Selection Criteria"
 W:BCHTYPE="D" !?12,"Date of Service range:  ",BCHBDD," to ",BCHEDD
 W:BCHTYPE="S" !?12,"Search Template: ",$P(^DIBT(BCHSEAT,0),U)
 I $D(BCHRDTR),$D(BCHBDD) W !,"Date of Service range:  ",BCHBDD," to ",BCHEDD,"."
 Q:'$D(^BCHTRPT(BCHRPT,11))
 S BCHI=0 F  S BCHI=$O(^BCHTRPT(BCHRPT,11,BCHI)) Q:BCHI'=+BCHI  D
 .I $Y>(IOSL-5) D PAUSE^BCHRL01 W @IOF
 .W !?12,$P(^BCHSORT(BCHI,0),U),":  "
 .K BCHQ
 .S BCHY=0,BCHC=0 F  S BCHY=$O(^BCHTRPT(BCHRPT,11,BCHI,11,"B",BCHY)) S BCHC=BCHC+1 Q:BCHY=""!($D(BCHQ))  W:BCHC'=1 " ; " S X=BCHY X:$D(^BCHSORT(BCHI,2)) ^(2) W X
 K BCHC,BCHQ
 Q
SHOWR ;EP
 I '$D(BCHDONE) W:$D(IOF) @IOF
 W !!?6,$S(BCHPTVS="V":"Visit",1:"Patient")_" SORTING Criteria"
 W:BCHTYPE="D"&('$D(BCHDONE)) !?12,"Date of Service range:  ",BCHBDD," to ",BCHEDD
 W:BCHTYPE="S"&('$D(BCHDONE)) !?12,"Search Template: ",$P(^DIBT(BCHSEAT,0),U)
 Q:'$G(BCHSORT)
 W !?12,$S(BCHPTVS="V":"Visits",1:"Patients")_" will be sorted by:  ",$P(^BCHSORT(BCHSORT,0),U),!
 Q
