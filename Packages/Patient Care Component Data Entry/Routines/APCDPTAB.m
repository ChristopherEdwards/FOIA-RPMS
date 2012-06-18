APCDPTAB ; IHS/CMI/LAB - Provider table print
 ;;2.0;IHS PCC SUITE;**2**;MAY 14, 2009
 ;
 ;
 ;
EP ;EP - called from option interactive
 D EOJ
 W:$D(IOF) @IOF
 S APCDTEXT="INTROT" F APCDJ=1:1 S APCDX=$T(@APCDTEXT+APCDJ) Q:$P(APCDX,";;",2)="END"  S APCDT=$P(APCDX,";;",2) W !,APCDT
PROVKEY ;
 K APCDTRIM S APCDTRIT=""
 S DIR(0)="S^A:All Users;P:Providers Only (defined by having the PROVIDER key)",DIR("A")="List which set of entries",DIR("B")="P" K DA D ^DIR K DIR
 I $D(DIRUT) G EOJ
 S APCDPKEY=Y
ACTIVE ;
 K APCDSTAT
 S DIR(0)="S^A:Active Providers;I:Inactive Providers;B:Both Active and Inactive Providers",DIR("A")="List which set of providers",DIR("B")="A" K DA D ^DIR K DIR
 I $D(DIRUT) G PROVKEY
 S APCDSTAT=Y,APCDSTAN=Y(0)
AFFL ;
 K APCDAFFM S APCDAFFT=""
 S DIR(0)="S^O:One or a Set of Affiliations;A:Any/All Affiliations",DIR("A")="Include Providers with which Affiliation",DIR("B")="A" K DA D ^DIR K DIR
 I $D(DIRUT) G ACTIVE
 S APCDAFFT=Y
 I APCDAFFT="A" W !!,"Providers of all affiliations will be included in the report.",! G DISC
 S X="AFFILIATION",DIC="^AMQQ(5,",DIC(0)="FM",DIC("S")="I $P(^(0),U,14)" D ^DIC K DIC,DA I Y=-1 W "OOPS - QMAN NOT CURRENT - QUITTING" S APCDERR=1 D EOJ Q Q
 D PEP^AMQQGTX0(+Y,"APCDAFFM(")
 I '$D(APCDAFFM) G AFFL
 I $D(APCDAFFM("*")) K APCDAFFM G AFFL
DISC ;
 K APCDDISM S APCDDIST=""
 S DIR(0)="S^O:One or a Set of Disciplines/Provider Classes;A:Any/All Disciplines/Provider Classes",DIR("A")="Include Providers with which Provider Class",DIR("B")="A" K DA D ^DIR K DIR
 I $D(DIRUT) G ACTIVE
 S APCDDIST=Y
 I APCDDIST="A" W !!,"Providers of all Disciplines will be included in the report.",! G DIVC
 S X="DISCIPLINE",DIC="^AMQQ(5,",DIC(0)="FM",DIC("S")="I $P(^(0),U,14)" D ^DIC K DIC,DA I Y=-1 W "OOPS - QMAN NOT CURRENT - QUITTING" S APCDERR=1 D EOJ Q Q
 D PEP^AMQQGTX0(+Y,"APCDDISM(")
 I '$D(APCDDISM) G DISC
 I $D(APCDDISM("*")) K APCDDISM G DISC
DIVC ;
 W !!,"You can select just providers who have access to a particular"
 W !,"division.  Since there is no designation in file 200 to specify"
 W !,"which facility a provider works knowing which Division they have"
 W !,"access to may help determine where they work."
 W !
 K APCDDIVM S APCDDIVT=""
 S DIR(0)="S^O:One or a Set of Divisions/Locations;A:Any/All Divisions/Locations",DIR("A")="Include Providers with access to which division",DIR("B")="A" K DA D ^DIR K DIR
 I $D(DIRUT) G ACTIVE
 S APCDDIVT=Y
 I APCDDIVT="A" W !!,"All will be included in the report.",! G SORTR
 S X="LOCATION OF ENCOUNTER",DIC="^AMQQ(5,",DIC(0)="FM",DIC("S")="I $P(^(0),U,14)" D ^DIC K DIC,DA I Y=-1 W "OOPS - QMAN NOT CURRENT - QUITTING" S APCDERR=1 D EOJ Q Q
 D PEP^AMQQGTX0(+Y,"APCDDIVM(")
 I '$D(APCDDIVM) G DIVC
 I $D(APCDDIVM("*")) K APCDDIVM G DIVC
SORTR ;
 S APCDSORT=""
 S DIR(0)="S^N:Provider Name;A:Affiliation;D:Discipline/Class;S:Active/Inactive Status",DIR("A")="Sort the list by",DIR("B")="N"
 KILL DA D ^DIR KILL DIR
 I $D(DIRUT) G DIVC
 S APCDSORT=Y
ZIS ;
 S XBRP="PRINT^APCDPTAB",XBRC="PROC^APCDPTAB",XBRX="EOJ^APCDPTAB",XBNS="APCD"
 D ^XBDBQUE
 Q
EOJ ;
 D ^XBFMK
 K DIC,DIR
 D EN^XBVK("APCD")
 Q
 ;
PROC ;
 S APCDJ=$J,APCDH=$H
 K ^XTMP("APCDPTAB",APCDJ,APCDH)
 S ^XTMP("APCDPTAB",0)=$$FMADD^XLFDT(DT,14)_"^"_DT_"^"_"PCC PROVIDER REPORT"
 S APCDIEN=0 F  S APCDIEN=$O(^VA(200,APCDIEN)) Q:APCDIEN'=+APCDIEN  D
 .I APCDPKEY="P",'$D(^XUSEC("PROVIDER",APCDIEN)) Q  ;no provider key
 .I APCDSTAT="I",$P($G(^VA(200,APCDIEN,"PS")),U,4)="" Q
 .I APCDSTAT="A",$P($G(^VA(200,APCDIEN,"PS")),U,4)]"" Q
 .I $D(APCDAFFM) S X=$P($G(^VA(200,APCDIEN,9999999)),U,1) Q:X=""   I X]"",'$D(APCDAFFM(X)) Q  ;not correct AFF
 .I $D(APCDDISM) S X=$P($G(^VA(200,APCDIEN,"PS")),U,5) Q:X=""  I X,'$D(APCDDISM(X)) Q  ;not correct DIS
 .I $D(APCDDIVM) D  I 'G Q
 ..S G=0,X=0 F  S X=$O(^VA(200,APCDIEN,2,"B",X)) Q:X'=+X!(G)  I $D(APCDDIVM(X)) S G=1
 .S X=$$SORT(APCDIEN,APCDSORT)
 .I X="" S X="---"
 .S ^XTMP("APCDPTAB",APCDJ,APCDH,"PTS",X,APCDIEN)=""
 .Q
 Q
DONE ;
 I $E(IOST)="C",IO=IO(0) S DIR(0)="EO",DIR("A")="End of report.  PRESS ENTER" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 K APCDTS,APCDS,APCDM,APCDET
 K ^XTMP("APCDPTAB",APCDJ,APCDH),APCDJ,APCDH
 Q
 ;
 ;
PRINT ;EP - called from xbdbque
 S APCDQ=0,APCDPG=0
 D HEADER
 S APCDSV="" F  S APCDSV=$O(^XTMP("APCDPTAB",APCDJ,APCDH,"PTS",APCDSV)) Q:APCDSV=""!(APCDQ)  D
 .I APCDSORT'="N" D
 ..I APCDSV="ZZZZZZZ" W !!,"UNKNOWN",! Q
 ..W !!,APCDSV,!
 .S APCDIEN=0 F  S APCDIEN=$O(^XTMP("APCDPTAB",APCDJ,APCDH,"PTS",APCDSV,APCDIEN)) Q:APCDIEN'=+APCDIEN  D
 ..I $Y>(IOSL-3) D HEADER Q:APCDQ
 ..W !,$E($P(^VA(200,APCDIEN,0),U),1,25),?27,$E($$VAL^XBDIQ1(200,APCDIEN,9999999.01),1,8)
 ..W ?36,$E($$VAL^XBDIQ1(200,APCDIEN,53.5),1,17)
 ..W ?54,$$VAL^XBDIQ1(200,APCDIEN,9999999.039)
 ..S APCDX=0 S APCDX=$O(^VA(200,APCDIEN,2,APCDX)) I APCDX,$P($G(^AUTTLOC(APCDX,0)),U,7)]"" W ?61,$P($G(^AUTTLOC(APCDX,0)),U,7)
 ..W ?72,$$DATE($$VALI^XBDIQ1(200,APCDIEN,53.4))
 ..F  S APCDX=$O(^VA(200,APCDIEN,2,APCDX)) Q:APCDX'=+APCDX  I APCDX,$P($G(^AUTTLOC(APCDX,0)),U,7)]"" W !?61,$P($G(^AUTTLOC(APCDX,0)),U,7)
 D DONE
 Q
HEADER ;EP
 G:'APCDPG HEADER1
 K DIR I $E(IOST)="C",IO=IO(0) W ! S DIR(0)="EO" D ^DIR K DIR I Y=0!(Y="^")!($D(DTOUT)) S APCDQ=1 Q
HEADER1 ;
 W:$D(IOF) @IOF S APCDPG=APCDPG+1
 W !?3,$P(^VA(200,DUZ,0),U,2),?35,$$FMTE^XLFDT(DT),?70,"Page ",APCDPG,!
 W $$CTR($P(^DIC(4,DUZ(2),0),U),80),!
 W !,$$CTR("PROVIDER LISTING",80)
 S X="Status:  "_APCDSTAN W !,$$CTR(X,80)
 S X="Affiliations: "
 I APCDAFFT="A" S X=X_"All Affiliations"
 I APCDAFFT="S" D
 .S Y="" F  S Y=$O(APCDAFFM(Y)) Q:Y'=+Y  S X=X_" "_Y
 W !,$$CTR(X,80)
 I APCDDIST="A" S X=X_"All Disciplines/Provider Classes"
 I APCDDIST="S" D
 .S Y="" F  S Y=$O(APCDDISM(Y)) Q:Y'=+Y  S X=X_" "_$P($G(^DIC(7,Y,9999999)),U)
 W !,$$CTR(X,80)
 W !!,"NAME",?27,"AFFL",?36,"PROV CLASS",?54,"ADC",?72,"INACTIVE"
 W !,$TR($J("",80)," ","-")
 Q
D(D) ;
 Q $E(D,4,5)_"/"_$E(D,6,7)_"/"_(1700+$E(D,1,3))
C(X,X2,X3) ;
 D COMMA^%DTC
 Q X
CTR(X,Y) ;EP - Center X in a field Y wide.
 Q $J("",$S($D(Y):Y,1:IOM)-$L(X)\2)_X
 ;----------
 ;----------
USR() ;EP - Return name of current user from ^VA(200.
 Q $S($G(DUZ):$S($D(^VA(200,DUZ,0)):$P(^(0),U),1:"UNKNOWN"),1:"DUZ UNDEFINED OR 0")
 ;----------
LOC() ;EP - Return location name from file 4 based on DUZ(2).
 Q $S($G(DUZ(2)):$S($D(^DIC(4,DUZ(2),0)):$P(^(0),U),1:"UNKNOWN"),1:"DUZ(2) UNDEFINED OR 0")
 ;----------
SORT(P,S) ;
 NEW R
 S R=""
 D @(S_"SORT")
 I R="" S R="ZZZZZZZ"
 Q R
 ;
ASORT ;
 S R=$$VAL^XBDIQ1(200,P,9999999.01)
 Q
NSORT ;
 S R=$$VAL^XBDIQ1(200,P,.01)
 Q
DSORT ;
 S R=$$VAL^XBDIQ1(200,P,53.5)
 Q
SSORT ;
 S R=$$VALI^XBDIQ1(200,P,53.4)
 I R="" S R="ACTIVE" Q
 S R="INACTIVE"
 Q
DATE(D) ;
 I D="" Q ""
 Q $E(D,4,5)_"/"_$E(D,6,7)_"/"_$E((1700+$E(D,1,3)),3,4)
INTROT ;
 ;;                 PROVIDER LISTING
 ;;
 ;;This option will produce a report of all entries in File 200.
 ;;You will be able to select which entries to print based on any of the
 ;;following criteria:
 ;;     Providers Only or all entries (providers are defined as those holding
 ;;        the PROVIDER key, general users will not hold this key)
 ;;     Active/Inactive Status
 ;;     Provider Affiliation
 ;;     Provider Discipline (Class)
 ;;     Division the person has access to (this is an attempt to determine which
 ;;        facility the provider works at, there currently no field to designate
 ;;        where the provider works.)
 ;;The report can be sorted by name, affiliation, discipline, active/inactive
 ;;status or division.
 ;;END
