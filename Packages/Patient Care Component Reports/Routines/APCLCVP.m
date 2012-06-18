APCLCVP ; IHS/CMI/LAB - Indian Beneficiary Calendar Year Visit Summary ;
 ;;2.0;IHS PCC SUITE;;MAY 14, 2009
 ;IHS/CMI/LAB - reformatted to include a 2nd column
START ;
 S APCLBDD=$$FMTE^XLFDT(APCLBD)
 S APCL80="_____________________________________________________________________________"
 S APCLFAC=""
 I $D(DUZ(2)) S:$D(^DIC(4,DUZ(2),0)) APCLFAC=$P(^(0),U)
 S APCLPG=0
 D HEAD
 D P
 D DONE
 Q
HEAD I 'APCLPG G HEAD1
 I $E(IOST)="C",IO=IO(0) W ! S DIR(0)="EO" D ^DIR K DIR I Y=0!(Y="^")!($D(DTOUT)) S APCLQUIT="" Q
HEAD1 ;
 W:$D(IOF) @IOF
 S APCLPG=APCLPG+1
 W ?19,"MONTHLY PROGRESS - VISIT SUMMARY REPORT",!
 W ?25,"INDIAN/ALASKA NATIVE VISITS",!
 W ?33,$$FMTE^XLFDT(DT),!
 W !?5,"FACILITY:  ",?20,APCLFAC,"      ",?67,"Page ",APCLPG
 W !?5,"DATE RANGE: ",?20,APCLBDD," TO ",APCLEDD
 I APCLLOC'="" S:$D(^DIC(4,APCLLOC,0)) APCLLOCP=$P(^(0),U)
 I APCLLOC="" S APCLLOCP="All Locations"
 W !?5,"LOCATION: ",?20,APCLLOCP,!
 I $D(APCLCLNT) W ?5,"CLINIC(S):     " S X=0,C=0 F  S X=$O(APCLCLNT(X)) Q:X=""  W:C "," W $P(^DIC(40.7,X,0),U,2) S C=C+1
 I APCLCL="",'$D(APCLCLNT) W ?5,"CLINIC:        All Clinics"
 W !,APCL80,!
 W !,"Report Dates:",?51,"Non-Indian mem"
 W !?5,APCLBDD," to ",APCLEDD,?43,"Indian",?51,"Ind. Household",?68,"All Other"
 W !,APCL80
 Q
 ;
DONE ;
 ;KILL SOME STUFF
 D DONE^APCLOSUT
 K APCL1,APCL2,APCL3,APCL4,APCL5,APCL1O,APCL2O,APCL3O,APCL4O,APCLG,APCLGO,APCL80
 K ^XTMP("APCLCV",APCLJOB)
 Q
 ;
P ;
 I $Y>(IOSL-5) D HEAD Q:$D(APCLQUIT)
 W !!,?1,"Date Range Visit Summary",!!
 W ?1,"1.  New Patient's First Visit",?39,$J($FN(APCL1,","),10),?52,$J($FN(APCL1N,","),10),?65,$J($FN(APCL1O,","),10),!!
 W ?1,"2.  Established Patient's First Visit",?39,$J($FN(APCL2,","),10),?52,$J($FN(APCL2N,","),10),?65,$J($FN(APCL2O,","),10),!!
 W ?1,"3.  Total First Visits (1-2)",?39,$J($FN(APCL3,","),10),?52,$J($FN(APCL3N,","),10),?65,$J($FN(APCL3O,","),10),!!
 W ?1,"4.  Additional Visits (2nd,3rd,etc.)",?39,$J($FN(APCL4,","),10),?52,$J($FN(APCL4N,","),10),?65,$J($FN(APCL4O,","),10),!
 W ?43,"______",?57,"______",?70,"______",!!
 S APCLG=APCL1+APCL2+APCL4
 S APCLGO=APCL1O+APCL2O+APCL4O
 S APCLGN=APCL1N+APCL2N+APCL4N
 W ?1,"5.  SUB-TOTAL",?39,$J($FN(APCLG,","),10),?52,$J($FN(APCLGN,","),10),?65,$J($FN(APCLGO,","),10),!!
 W ?5,"GRAND TOTAL-ALL VISITS: ",?20,$J($FN(APCL5,","),10)
 Q
