BRNRUS ; IHS/OIT/LJF - SHOW LOGIC SO FAR
 ;;2.0;RELEASE OF INFO SYSTEM;*1*;APR 10, 2003
 ;IHS/OIT/LJF 10/25/2007 PATCH 1 Added routine
 ;
SHOWP ;EP - display print item selections
 NEW BRNI
 I '$D(BRNDONE) W:$D(IOF) @IOF
 W !!?6,"REPORT/OUTPUT Type:"
 I BRNCTYP="S" W !,?12,"Report includes sub-totals by ",$G(BRNSORV)," and total count." Q
 I BRNCTYP="T" W !,?12,"Report will include total only." Q
 Q:'$D(^BRNRPT(BRNRPT,12))
 W !?12,"PRINT Items Selected:"
 S (BRNI,BRNTCW)=0 F  S BRNI=$O(^BRNRPT(BRNRPT,12,BRNI)) Q:BRNI'=+BRNI  S BRNCRIT=$P(^BRNRPT(BRNRPT,12,BRNI,0),U) D
 . W !?12,$P(^BRNSORT(BRNCRIT,0),U)," - column width ",$P(^BRNRPT(BRNRPT,12,BRNI,0),U,2)
 . S BRNTCW=BRNTCW+$P(^BRNRPT(BRNRPT,12,BRNI,0),U,2)+2
 . I $Y>(IOSL-5) D PAUSE^BRNU W:$D(IOF) @IOF
 W !?12,"Total Report width (including column margins - 2 spaces):   ",BRNTCW
 Q
 ;
SHOW ;EP - display selection criteria so far
 NEW X,BRNI,BRNC,BRNQ,BRNY,BRNC
 W:$D(IOF) @IOF
 I $D(BRNDONE) S X="REPORT SUMMARY" W ?((80-$L(X))/2),X,!
 W !!?6,"Disclosure Request Selection Criteria:"
 W !?12,"Request Date range:  ",BRNBDD," to ",BRNEDD
 Q:'$D(^BRNRPT(BRNRPT,11))
 ;
 S BRNI=0 F  S BRNI=$O(^BRNRPT(BRNRPT,11,BRNI)) Q:BRNI'=+BRNI  D
 . I $Y>(IOSL-5) D PAUSE^BRNU W @IOF
 . W !?12,$P(^BRNSORT(BRNI,0),U),":  "
 . S BRNY="",BRNC=0
 . F  S BRNY=$O(^BRNRPT(BRNRPT,11,BRNI,11,"B",BRNY)) S BRNC=BRNC+1 Q:BRNY=""!($D(BRNQ))  D
 . . W:BRNC'=1 " ; " S X=BRNY X:$D(^BRNSORT(BRNI,2)) ^(2) W X
 Q
 ;
SHOWR ;EP - display sorting criteria
 I '$D(BRNDONE) W:$D(IOF) @IOF
 W !!?6,"SORTING Item:"
 I BRNCTYP="T" W !?12,"Total only will be displayed, no sorting done.",! Q
 I BRNCTYP="C" W !?12,"Search Template being created, no sorting done.",! Q
 Q:'$G(BRNSORT)
 W !?12,"Disclosure requests will be sorted by:  ",$P(^BRNSORT(BRNSORT,0),U),!
 Q
