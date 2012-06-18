AMHLRDSP ; IHS/CMI/LAB - DISPLAYS DAILY ACT RECORDS ;
 ;;4.0;IHS BEHAVIORAL HEALTH;;MAY 14, 2010
 ;
 ;Display all records for the provider, on this date.
 ;
 ;caller must pass AMHLOC - provider IEN
 ;                 AMHDATE - date in fileman format, no time or sec
 ;passed back to caller:  AMHRCNT - number of records found
 ;                        AMHVRECS(n)=record ien  n is consecutive
 ;                                                number
 ;
 I '$D(IOF) D HOME^%ZIS
 K AMHQUIT,AMHVRECS,AMHRCNT S AMHPG=0
 I '$D(^AMHREC("AA",$P(AMHDATE,"."),AMHLOC)) W !!,"No records currently on file for ",$P(^DIC(4,AMHLOC,0),U)," on " S Y=AMHDATE D DD^%DT W Y,".",! Q
 W:$D(IOF) @IOF
 D HEAD
 D DISPRECS
 K AMHQUIT,AMHPG,AMHREC,AMHV,AMHP
 Q
HEAD ;
 I 'AMHPG G HEAD1
 I $E(IOST)="C",IO=IO(0) W ! S DIR(0)="EO" D ^DIR K DIR I Y=0!(Y="^")!($D(DTOUT)) S AMHQUIT="" Q
HEAD1 ;
 S AMHPG=AMHPG+1
 W:$D(IOF) @IOF
 W !,AMHDASH
 W !,"Program:  ",AMHPROGN,?35,"Date of Encounter:  " S Y=AMHDATE D DD^%DT W Y,!,"Location of Encounter:  ",$P(^DIC(4,AMHLOC,0),U),!,AMHDASH
 W !," #",?6,"PROV",?12,"COMMUNITY",?24,"ACT",?29,"VISIT",?37,"AT",?41,"PATIENT",?51,"PROB",?58,"NARRATIVE",!,AMHDASH
 Q
DISPRECS ;
 S (AMHRCNT,AMHV)=0 F  S AMHV=$O(^AMHREC("AA",$P(AMHDATE,"."),AMHLOC,AMHV)) Q:AMHV'=+AMHV!($D(AMHQUIT))  S AMHRCNT=AMHRCNT+1,AMHVRECS(AMHRCNT)=AMHV,AMHREC=^AMHREC(AMHV,0) D
 .I $Y>(IOSL-2) D HEAD Q:$D(AMHQUIT)
 .W !,AMHRCNT,?6,$$PPINI^AMHUTIL(AMHV) W:$P(AMHREC,U,5) ?12,$E($P(^AUTTCOM($P(AMHREC,U,5),0),U),1,10)
 .W ?25,$S($P(AMHREC,U,6)]"":$P(^AMHTACT($P(AMHREC,U,6),0),U),1:""),?29,$S($P(AMHREC,U,7)]"":$E($P(^AMHTSET($P(AMHREC,U,7),0),U,2),1,7),1:""),?37,$P(AMHREC,U,12)
 .I $P(AMHREC,U,8)]""  D
 ..I $D(^AUPNPAT($P(AMHREC,U,8),41,$P(AMHREC,U,4))) W ?41,$P(^AUTTLOC($P(AMHREC,U,4),0),U,7)," ",$P(^AUPNPAT($P(AMHREC,U,8),41,$P(AMHREC,U,4),0),U,2) Q
 ..I $D(^AUPNPAT(DUZ(2),41,$P(AMHREC,U,4))) W ?41,$P(^AUTTLOC($P(AMHREC,U,4),0),U,7)," ",$P(^AUPNPAT($P(AMHREC,U,8),41,$P(AMHREC,U,4),0),U,2) Q
 ..W ?41,"<*****>"
 .E  W ?42,"-----"
 .S AMHP=$O(^AMHRPRO("AD",AMHV,0)) I AMHP="" W ?56,"No Problems recorded." Q
 .W ?51,$P(^AMHPROB($P(^AMHRPRO(AMHP,0),U),0),U) W:$P(^AMHRPRO(AMHP,0),U,4) ?58,$E($P(^AUTNPOV($P(^AMHRPRO(AMHP,0),U,4),0),U),1,21)
 .Q
 Q
