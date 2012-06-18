APCLIPC1 ; IHS/OHPRD/TMJ - CONT OF APCLPCT 7/13/89 1:06 PM ;  [ 03/19/01  9:28 AM ]
 ;;3.0;IHS PCC REPORTS;;FEB 05, 1997
 ;PRINT INDIAN PATIENT COUNTS FOR SERVICE UNIT
START ;
 S APCL80D="--------------------------------------------------------------------------------" ;80 DASHES
 S:APCLFS="S" (APCLSUP,APCLSUN)=$P(^AUTTSU(APCLSU,0),U)
 I APCLFS="F" S APCLSUP=$P(^DIC(4,APCLSU,0),U),APCLSUN=$P(^AUTTSU(APCLSUF,0),U)
 S (APCL1,APCL2,APCL3,APCL4,APCL5,APCLPG)=0 D HEAD
 S APCLMAJ=0 K APCLQUIT
 F I=0:0 S APCLMAJ=$O(^XTMP("APCLPCT",APCLJOB,APCLBT,APCLMAJ)) Q:APCLMAJ=""!($D(APCLQUIT))  D MINOR
 G:$D(APCLQUIT) DONE
 I $Y>(IOSL-8) D HEAD G:$D(APCLQUIT) DONE
 W !!?33,"------",?46,"------",?56,"------",?65,"------",?73,"------",!
 W ?21,"Total:",?33,$J(APCL1,6),?46,$J(APCL2,6),?56,$J(APCL3,6),?65,$J(APCL4,6),?73,$J(APCL5,6),!
DONE ;
 D DONE^APCLOSUT
 K ^XTMP("APCLPCT",APCLJOB,APCLBT),^XTMP("APCLPCTR",APCLJOB,APCLBT)
 Q
MINOR ;
 I $Y>(IOSL-$S(APCLSUB=1:9,1:6)) D HEAD Q:$D(APCLQUIT)
 W !,$E(APCLMAJ,1,28) W:APCLSUB=1 !
 S APCLMIN=0 F  S APCLMIN=$O(^XTMP("APCLPCT",APCLJOB,APCLBT,APCLMAJ,APCLMIN)) Q:APCLMIN=""!($D(APCLQUIT))  D MINOR1
 Q:$D(APCLQUIT)
 D MAJTOT
 Q
MINOR1 ;
 S:'$D(^XTMP("APCLPCTR",APCLJOB,APCLBT,"SUBTOTAL",APCLMAJ)) ^XTMP("APCLPCTR",APCLJOB,APCLBT,"SUBTOTAL",APCLMAJ)="0^0^0^0^0"
 F APCLI=1:1:5 S $P(^XTMP("APCLPCTR",APCLJOB,APCLBT,"SUBTOTAL",APCLMAJ),U,APCLI)=$P(^XTMP("APCLPCTR",APCLJOB,APCLBT,"SUBTOTAL",APCLMAJ),U,APCLI)+$P(^XTMP("APCLPCT",APCLJOB,APCLBT,APCLMAJ,APCLMIN),U,APCLI)
 S APCLP=1 F APCLI=1:1:5 S APCLVAR="APCLT"_APCLI,@APCLVAR=$P(^XTMP("APCLPCT",APCLJOB,APCLBT,APCLMAJ,APCLMIN),U,APCLP) S:@APCLVAR="" @APCLVAR=0 S APCLP=APCLP+1
 F APCLI=1:1:5 S APCLVAR1="APCL"_APCLI,APCLVAR2="APCLT"_APCLI S @APCLVAR1=@APCLVAR1+@APCLVAR2
 Q:APCLSUB'=1
 I $Y>(IOSL-7) D HEAD Q:$D(APCLQUIT)
 W !?3,$E(APCLMIN,1,25) F APCLI=1:1:5 S APCLVAR="APCLT"_APCLI S APCLT=$P("33,46,57,65,73",",",APCLI) W ?APCLT,$J((@APCLVAR),6)
 Q
MAJTOT ;print major sort totals
 ;I $Y>(IOSL-7) D HEAD Q:$D(APCLQUIT)
 G:APCLSUB'=1 MAJTOT1
 W !!?33,"------",?46,"------",?56,"------",?65,"------",?73,"------",!
 W ?19,"Subtotal:"
MAJTOT1 S APCLP=1 F APCLI=33,46,57,65,73 W ?APCLI,$J($P(^XTMP("APCLPCTR",APCLJOB,APCLBT,"SUBTOTAL",APCLMAJ),U,APCLP),6) S APCLP=APCLP+1
 W !
 Q
HEAD I 'APCLPG G HEAD1
 I $E(IOST)="C",IO=IO(0) W ! S DIR(0)="EO" D ^DIR K DIR I Y=0!(Y="^")!($D(DTOUT)) S APCLQUIT="" Q
HEAD1 ;
 W:$D(IOF) @IOF S APCLPG=APCLPG+1
 W $P(^DIC(4,DUZ(2),0),U),?60,APCLDTP,?72,"Page ",APCLPG,!
 W !,"Registration and Visit Counts for ",$S(APCLIND=1:"Indian",1:"all")," Patients registered ",$S(APCLFS="F":"at ",1:"in ")
 W !,APCLSUP," ",$S(APCLFS="F":"Facility",1:"Service Unit"),".",!
 W "The report is sorted by ",$S(APCLSORT="C":"Community of Residence",APCLSORT="T":"Tribe of Membership",1:"Service Unit of Residence"),$S(APCLSUB=1:" and by ",1:".")
 W:APCLSUB=1 $S(APCLSORT="C":"Tribe of Membership.",1:"Community of Residence.")
 W !,"A '*' after the Community name indicates a Non-Service Unit Community.",!
 W "Visit Counts between ",APCLSDY," and ",APCLEDY,".",!
 W !,$S(APCLSORT="C":"Current Community of",APCLSORT="T":"Tribe of Membership",1:"Service Unit of Residence"),?30,"Reg Pts",?46,"Patients",?56,"   All"
 W !,$S(APCLSORT="C":" residence",1:""),?30,"Living",?46,"Rec'ing",?56,"   PCC",?65," APC",?73,"PCP"
 W !,$S(APCLSUB=1&(APCLSORT="C"):"   Tribe of Membership",APCLSUB=1&(APCLSORT'="C"):"   Community of Residence",1:""),?30,"As of Today",?46,"Service",?56,"  Srvs",?65,"Visits",?73,"Visits"
 W !,APCL80D
 Q
