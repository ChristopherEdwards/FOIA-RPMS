APCLACC1 ; IHS/CMI/LAB - process active user report ; 
 ;;2.0;IHS PCC SUITE;;MAY 14, 2009
 ;IHS/CMI/LAB - added template creation
 ;PRINT INDIAN PATIENT COUNTS FOR SERVICE UNIT
START ;
 K APCLSUP
 S APCL80D="--------------------------------------------------------------------------------" ;80 DASHES
 ;S:APCLFS="S" (APCLSUP,APCLSUN)=$P(^AUTTSU(APCLSU,0),U)
 I APCLFS="S" S X=0 F  S X=$O(APCLSU(X)) Q:X'=+X  S APCLSUP($P(^AUTTSU(X,0),U))=$P(^AUTTSU(X,0),U)
 ;I APCLFS="F" S APCLSUP=$P(^DIC(4,APCLSU,0),U),APCLSUN=$P(^AUTTSU(APCLSUF,0),U)
 I APCLFS="F" S X=0 F  S X=$O(APCLSU(X)) Q:X'=+X  S APCLSUP($P(^DIC(4,X,0),U))=$S($P(^AUTTLOC(X,0),U,5):$P(^AUTTSU($P(^AUTTLOC(X,0),U,5),0),U),1:"??")
 S (APCL1,APCL2,APCLPG)=0 D HEAD
 I APCLRPTT="T" D TEMPLATE G DONE
 S APCLMAJ=0 K APCLQUIT
 F I=0:0 S APCLMAJ=$O(^XTMP("APCLACC",APCLJOB,APCLBT,APCLMAJ)) Q:APCLMAJ=""!($D(APCLQUIT))  D MINOR
 G:$D(APCLQUIT) DONE
 I $Y>(IOSL-7) D HEAD G:$D(APCLQUIT) DONE
 W !!?50,"------",?67,"------",!
 W ?39,"Total:",?50,$J(APCL1,6),?67,$J(APCL2,6),!
DONE ;
 D DONE^APCLOSUT
 K ^XTMP("APCLACC",APCLJOB,APCLBT),^XTMP("APCLACCR",APCLJOB,APCLBT),^XTMP("APCLACC SU",APCLJOB,APCLBT)
 Q
MINOR ;
 I $Y>(IOSL-$S(APCLSUB=1:9,1:6)) D HEAD Q:$D(APCLQUIT)
 W !,APCLMAJ W:APCLSUB=1 !
 S APCLMIN=0 F  S APCLMIN=$O(^XTMP("APCLACC",APCLJOB,APCLBT,APCLMAJ,APCLMIN)) Q:APCLMIN=""!($D(APCLQUIT))  D MINOR1
 Q:$D(APCLQUIT)
 D MAJTOT
 Q
MINOR1 ;
 S:'$D(^XTMP("APCLACCR",APCLJOB,APCLBT,"SUBTOTAL",APCLMAJ)) ^XTMP("APCLACCR",APCLJOB,APCLBT,"SUBTOTAL",APCLMAJ)="0^0"
 F APCLI=1:1:2 S $P(^XTMP("APCLACCR",APCLJOB,APCLBT,"SUBTOTAL",APCLMAJ),U,APCLI)=$P(^XTMP("APCLACCR",APCLJOB,APCLBT,"SUBTOTAL",APCLMAJ),U,APCLI)+$P(^XTMP("APCLACC",APCLJOB,APCLBT,APCLMAJ,APCLMIN),U,APCLI)
 S APCLP=1 F APCLI=1:1:2 S APCLVAR="APCLT"_APCLI,@APCLVAR=$P(^XTMP("APCLACC",APCLJOB,APCLBT,APCLMAJ,APCLMIN),U,APCLP) S:@APCLVAR="" @APCLVAR=0 S APCLP=APCLP+1
 F APCLI=1:1:2 S APCLVAR1="APCL"_APCLI,APCLVAR2="APCLT"_APCLI S @APCLVAR1=@APCLVAR1+@APCLVAR2
 Q:APCLSUB'=1
 I $Y>(IOSL-6) D HEAD Q:$D(APCLQUIT)
 W !?5,$E(APCLMIN,1,45) F APCLI=1:1:2 S APCLVAR="APCLT"_APCLI S APCLT=$P("50,67",",",APCLI) W ?APCLT,$J((@APCLVAR),6)
 Q
MAJTOT ;print major sort totals
 ;I $Y>(IOSL-7) D HEAD Q:$D(APCLQUIT)
 G:APCLSUB'=1 MAJTOT1
 W !?50,"------",?67,"------",!
 W ?39,"Subtotal:"
MAJTOT1 S APCLP=1 F APCLI=50,67 W ?APCLI,$J($P(^XTMP("APCLACCR",APCLJOB,APCLBT,"SUBTOTAL",APCLMAJ),U,APCLP),6) S APCLP=APCLP+1
 W !
 Q
TEMPLATE ;create template
 ;create search template
 K DD,D0,DO,DIC S DIC="^DIBT(",DIC(0)="LM",X="ACTIVE USERS AS OF "_$$FMTE^XLFDT(APCLFYE,"2E") D ^DIC K DIC,DA,D0,DD
 I Y=-1 W !!,"SEARCH TEMPLATE CREATION FAILED." Q
 K ^DIBT(+Y,1)
 S APCLSTMP=+Y
 S DIE="^DIBT(",DA=APCLSTMP,DR="2////"_DT_";3////M;4////9000001;5////"_DUZ_";6////M"
 D ^DIE
 K DIE,DA,DR S Y=0 F  S Y=$O(^XTMP("APCLACC",APCLJOB,APCLBT,"TEMPLATE PATIENTS",Y)) Q:Y'=+Y  S ^DIBT(APCLSTMP,1,Y)=""""
 Q
HEAD I 'APCLPG G HEAD1
 I $E(IOST)="C",IO=IO(0) W ! S DIR(0)="EO" D ^DIR K DIR I Y=0!(Y="^")!($D(DTOUT)) S APCLQUIT="" Q
HEAD1 ;
 W:$D(IOF) @IOF S APCLPG=APCLPG+1
 W $P(^DIC(4,DUZ(2),0),U),?60,APCLDTP,?72,"Page ",APCLPG,!
 W !,"Registration and Active Patient Counts for ",$S(APCLIND=1:"Indian",1:"all")," Patients registered ",$S(APCLFS="F":"at ",1:"in ")
 S %="the following "_$S(APCLFS="F":"Facilities",1:"Service Units")_":"
 W !,%
 S %="",X="" F  S X=$O(APCLSUP(X)) Q:X=""  S %=%_"   "_X
 W !?((80-$L(%))/2),%
 W:APCLRPTT'="T" !,"The report is sorted by ",$S(APCLSORT="C":"Community of Residence",APCLSORT="T":"Tribe of Membership",1:"Service Unit of Residence"),$S(APCLSUB=1:" and by ",1:".")
 I $G(APCLSUB)=1,APCLRPTT'="T" W $S(APCLSORT="C":"Tribe of Membership.",1:"Community of Residence.")
 W !
 W:APCLSSUR=0 !,"A '*' after the Community name indicates a Non-Service Unit Community.",!
 W:APCLSSUR=1 !,"Report includes only those patients who reside in a Service Unit Community.",!
 W "Active Patient were those seen between ",APCLFYBY," and ",APCLFYEY,".",!
 I APCLRPTT="T" W !!!,"***** SEARCH TEMPLATE 'ACTIVE USERS AS OF "_$$FMTE^XLFDT(APCLFYE,"2E")_"' HAS BEEN CREATED ****" Q
 W !,$S(APCLSORT="C":"Current Community of Residence",APCLSORT="T":"Tribe of Membership",1:"Service Unit of Residence"),?50,"Reg Pts Living",?67,"Active"
 W !,$S(APCLSUB=1&(APCLSORT="C"):"     Tribe of Membership",APCLSUB=1&(APCLSORT'="C"):"      Community of Residence",1:""),?50,"As of Today",?67,"Patients"
 W !,APCL80D
 Q
