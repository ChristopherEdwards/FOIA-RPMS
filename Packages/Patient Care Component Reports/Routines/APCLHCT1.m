APCLHCT1 ; IHS/CMI/LAB - CONT OF APCLHCT 7/13/89 1:06 PM ;
 ;;2.0;IHS PCC SUITE;;MAY 14, 2009
 ;PRINT INDIAN PATIENT COUNTS FOR SERVICE UNIT
START ;
 S APCL80D="-----------------------------------------------------------------------------" ;80 DASHES
 S (APCL1,APCL2,APCL3,APCL4,APCL5,APCL6,APCL7,APCL8,APCLPG)=0 D HEAD
 S APCLMAJ=0 K APCLQUIT
 F I=0:0 S APCLMAJ=$O(^XTMP("APCLHCT",APCLJOB,APCLBT,APCLMAJ)) Q:APCLMAJ=""!($D(APCLQUIT))  D MINOR
 G:$D(APCLQUIT) DONE
 I $Y>(IOSL-8) D HEAD G:$D(APCLQUIT) DONE
 ;W !!?33,"-------",?46,"-------",?59,"-------",?70,"-------",!
 W !!
 F J=24,31,38,45,52,59,66,73 W ?J,"-------"
 W !
 W ?12,"Total:",?24,$$C(APCL1,0,7),?31,$$C(APCL2,0,7),?38,$$C(APCL3,0,7),?45,$$C(APCL4,0,7),?52,$$C(APCL5,0,7),?59,$$C(APCL6,0,7),?66,$$C(APCL7,0,7),?73,$$C(APCL8,0,7),!
DONE ;
 D DONE^APCLOSUT
 K ^XTMP("APCLHCT",APCLJOB,APCLBT),^XTMP("APCLHCTR",APCLJOB,APCLBT)
 Q
MINOR ;
 I $Y>(IOSL-$S(APCLSUB=1:9,1:6)) D HEAD Q:$D(APCLQUIT)
 W !,$E(APCLMAJ,1,28) W:APCLSUB=1 !
 S APCLMIN=0 F  S APCLMIN=$O(^XTMP("APCLHCT",APCLJOB,APCLBT,APCLMAJ,APCLMIN)) Q:APCLMIN=""!($D(APCLQUIT))  D MINOR1
 Q:$D(APCLQUIT)
 D MAJTOT
 Q
MINOR1 ;
 S:'$D(^XTMP("APCLHCTR",APCLJOB,APCLBT,"SUBTOTAL",APCLMAJ)) ^XTMP("APCLHCTR",APCLJOB,APCLBT,"SUBTOTAL",APCLMAJ)="0^0^0^0^0^0^0^0"
 F APCLI=1:1:8 S $P(^XTMP("APCLHCTR",APCLJOB,APCLBT,"SUBTOTAL",APCLMAJ),U,APCLI)=$P(^XTMP("APCLHCTR",APCLJOB,APCLBT,"SUBTOTAL",APCLMAJ),U,APCLI)+$P(^XTMP("APCLHCT",APCLJOB,APCLBT,APCLMAJ,APCLMIN),U,APCLI)
 S APCLP=1 F APCLI=1:1:8 S APCLVAR="APCLT"_APCLI,@APCLVAR=$P(^XTMP("APCLHCT",APCLJOB,APCLBT,APCLMAJ,APCLMIN),U,APCLP) S:@APCLVAR="" @APCLVAR=0 S APCLP=APCLP+1
 F APCLI=1:1:8 S APCLVAR1="APCL"_APCLI,APCLVAR2="APCLT"_APCLI S @APCLVAR1=@APCLVAR1+@APCLVAR2
 Q:APCLSUB'=1
 I $Y>(IOSL-7) D HEAD Q:$D(APCLQUIT)
 W !?1,$E(APCLMIN,1,20) F APCLI=1:1:8 S APCLVAR="APCLT"_APCLI S APCLT=$P("24,31,38,45,52,59,66,73",",",APCLI) W ?APCLT,$$C((@APCLVAR),0,7)
 Q
MAJTOT ;print major sort totals
 ;I $Y>(IOSL-7) D HEAD Q:$D(APCLQUIT)
 G:APCLSUB'=1 MAJTOT1
 W !!
 F J=24,31,38,45,52,59,66,73 W ?J,"-------"
 W !
 ;?24,"-------",?46,"-------",?59,"-------",?70,"-------",!
 W ?12,"Subtotal:"
MAJTOT1 S APCLP=1 F APCLI=24,31,38,45,52,59,66,73 W ?APCLI,$$C($P(^XTMP("APCLHCTR",APCLJOB,APCLBT,"SUBTOTAL",APCLMAJ),U,APCLP),0,7) S APCLP=APCLP+1
 W !
 Q
CTR(X,Y) ;EP - Center X in a field Y wide.
 Q $J("",$S($D(Y):Y,1:IOM)-$L(X)\2)_X
 ;---------
C(X,X2,X3) ;
 D COMMA^%DTC
 Q X
HEAD I 'APCLPG G HEAD1
 I $E(IOST)="C",IO=IO(0) W ! S DIR(0)="EO" D ^DIR K DIR I Y=0!(Y="^")!($D(DTOUT)) S APCLQUIT="" Q
HEAD1 ;
 W:$D(IOF) @IOF S APCLPG=APCLPG+1
 W $P(^DIC(4,DUZ(2),0),U),?60,APCLDTP,?72,"Page ",APCLPG,!
 W !,"Inpatient Discharges and Days for ",$S(APCLIND=1:"Indian",1:"all")," Patients."
 S X="Location of Hospitalization: "_$P(^DIC(4,APCLLOC,0),U) W !,$$CTR(X,80)
 W !,"Discharge Dates between ",APCLSDY," and ",APCLEDY,".",!
 W "The report is sorted by ",$S(APCLSORT="C":"Community of Residence",APCLSORT="T":"Tribe of Membership",1:"Service Unit of Residence"),$S(APCLSUB=1:" and by ",1:".")
 W:APCLSUB=1 $S(APCLSORT="C":"Tribe of Membership.",1:"Community of Residence.")
 W !,"A '*' after the Community name indicates a Non-Service Unit Community.",!
 W !,$S(APCLSORT="C":"Current Community of",APCLSORT="T":"Tribe of Membership",1:"Service Unit of Residence")
 W ?24,"# Adult",?32,"# Adult",?40,"# NB",?47,"# NB",?54,"# TX",?61,"# MCR",?68,"# MCD",?74,"# PI"
 W !,$S(APCLSORT="C":" residence",1:""),?24,"/Peds",?32,"/Peds",?40,"Dsch",?47,"Days",?54,"IN"
 W !?24,"Dsch",?32,"Days"
 W !,$S(APCLSUB=1&(APCLSORT="C"):" Tribe of Membership",APCLSUB=1&(APCLSORT'="C"):" Community of Residence",1:"")
 W !,$$REPEAT^XLFSTR("-",80)
 Q
