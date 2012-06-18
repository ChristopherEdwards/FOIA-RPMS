APCDFOSP ; IHS/CMI/LAB - PRINT FORMS TRACKING SUMMARY ;
 ;;2.0;IHS PCC SUITE;;MAY 14, 2009
 S (APCDPAGE,APCDQUIT)=0 S Y=DT D DD^%DT S APCDDT=Y S Y=APCDBD D DD^%DT S APCDBDT=Y S Y=APCDED D DD^%DT S APCDEDT=Y
 I '$D(^XTMP("APCDFOS",APCDJ,APCDBT)) D HEAD W !!,"NO DATA TO REPORT",!! G XIT
 D HEAD
 D PROC
 D XIT
 Q
PROC ;
 W !!,"This report will include counts on Visits created or appended to during the",!,"data entry process.  Data entered via the option ENTER NON-VISIT DATA are not"
 W !,"counted because no visit file is created.  The count of these forms must be",!,"tallied manually.  The counts are taken from the forms tracking file.",!,"Therefore, you must be "
 W "running forms tracking for this report to have any data.",!
TOT ;
 D:$Y>(IOSL-6) HEAD Q:APCDQUIT
 W !,"There were a total of ",APCDTOT," visits processed during the time period.",!,"specified.  Below is a further breakdown of these visits.",!
CHS ;
 G HOSP
 D:$Y>(IOSL-6) HEAD Q:APCDQUIT
 W !,"CONTRACT HEALTH SERVICES",!
 W !,"There were ",$S($G(^XTMP("APCDFOS",APCDJ,APCDBT,"CHS","TOTAL")):^("TOTAL"),1:" 0")," medical authorizations processed during this period."
 G:'$G(^XTMP("APCDFOS",APCDJ,APCDBT,"CHS","TOTAL")) HOSP
 D:$Y>(IOSL-6) HEAD Q:APCDQUIT  W !!?2,"By SERVICE CATEGORY:"
 S X="" F  S X=$O(^XTMP("APCDFOS",APCDJ,APCDBT,"CHS","CAT",X)) Q:X=""!(APCDQUIT)  D
 .D:$Y>(IOSL-6) HEAD Q:APCDQUIT
 .W !,?5,$E(X,1,30),?35,$J(^XTMP("APCDFOS",APCDJ,APCDBT,"CHS","CAT",X),8)
 .Q
 Q:APCDQUIT
 D:$Y>(IOSL-6) HEAD Q:APCDQUIT  W !!?2,"By LOCATION:"
 S X="" F  S X=$O(^XTMP("APCDFOS",APCDJ,APCDBT,"CHS","LOC",X)) Q:X=""!(APCDQUIT)  D
 .D:$Y>(IOSL-6) HEAD Q:APCDQUIT
 .W !,?5,$E(X,1,30),?35,$J(^XTMP("APCDFOS",APCDJ,APCDBT,"CHS","LOC",X),8)
 .Q
 Q:APCDQUIT
HOSP ;
 I $Y>(IOSL-8) D HEAD Q:APCDQUIT
 W !!!,"HOSPITALIZATIONS (HSA-44)",!
 W !,"There were ",$S($G(^XTMP("APCDFOS",APCDJ,APCDBT,"HOSP","TOTAL")):^("TOTAL"),1:" 0")," hospitalization documents during this period."
 G:'$G(^XTMP("APCDFOS",APCDJ,APCDBT,"HOSP","TOTAL")) INHOSP
 D:$Y>(IOSL-5) HEAD Q:APCDQUIT  W !!?2,"By TYPE:"
 S X="" F  S X=$O(^XTMP("APCDFOS",APCDJ,APCDBT,"HOSP","TYPE",X)) Q:X=""!(APCDQUIT)  D
 .D:$Y>(IOSL-6) HEAD Q:APCDQUIT
 .W !,?5,$E(X,1,30),?35,$J(^XTMP("APCDFOS",APCDJ,APCDBT,"HOSP","TYPE",X),8)
 .Q
 Q:APCDQUIT
 D:$Y>(IOSL-6) HEAD Q:APCDQUIT  W !!?2,"By LOCATION:"
 S X="" F  S X=$O(^XTMP("APCDFOS",APCDJ,APCDBT,"HOSP","LOC",X)) Q:X=""!(APCDQUIT)  D
 .D:$Y>(IOSL-6) HEAD Q:APCDQUIT
 .W !,?5,$E(X,1,30),?35,$J(^XTMP("APCDFOS",APCDJ,APCDBT,"HOSP","LOC",X),8)
 .Q
 Q:APCDQUIT
INHOSP ;
 I $Y>(IOSL-8) D HEAD Q:APCDQUIT
 W !!!,"IN-HOSPITAL VISITS (NON-CHS):",!
 W !,"There were ",$S($G(^XTMP("APCDFOS",APCDJ,APCDBT,"INHOSP","TOTAL")):^("TOTAL"),1:" 0")," in-hospital documents during this period."
 G:'$G(^XTMP("APCDFOS",APCDJ,APCDBT,"INHOSP","TOTAL")) AMB
 I $Y>(IOSL-5) D HEAD Q:APCDQUIT
 W !!?2,"By TYPE:"
 S X="" F  S X=$O(^XTMP("APCDFOS",APCDJ,APCDBT,"INHOSP","TYPE",X)) Q:X=""!(APCDQUIT)  D
 .D:$Y>(IOSL-6) HEAD Q:APCDQUIT
 .W !,?5,$E(X,1,30),?35,$J(^XTMP("APCDFOS",APCDJ,APCDBT,"INHOSP","TYPE",X),8)
 .Q
 Q:APCDQUIT
 D:$Y>(IOSL-6) HEAD Q:APCDQUIT  W !!?2,"By LOCATION:"
 S X="" F  S X=$O(^XTMP("APCDFOS",APCDJ,APCDBT,"INHOSP","LOC",X)) Q:X=""!(APCDQUIT)  D
 .D:$Y>(IOSL-6) HEAD Q:APCDQUIT
 .W !,?5,$E(X,1,30),?35,$J(^XTMP("APCDFOS",APCDJ,APCDBT,"INHOSP","LOC",X),8)
 .Q
 Q:$G(APCDQUIT)
AMB ;
 D AMB^APCDFOS2
 Q:APCDQUIT
 Q
XIT ;
 I 'APCDQUIT,$E(IOST)="C",IO=IO(0) S DIR("A")="End of report.  Press return.",DIR(0)="E" D ^DIR K DIR
 W:$D(IOF) @IOF
 K ^XTMP("APCDFOS",APCDJ,APCDBT)
 K APCDJ,APCDBT
 Q
HEAD ;EP
 I 'APCDPAGE G HEAD1
 NEW X
 I $E(IOST)="C",IO=IO(0) W ! S DIR(0)="EO" D ^DIR K DIR I Y=0!(Y="^")!($D(DTOUT)) S APCDQUIT=1 Q
 S APCDPAGE=APCDPAGE+1
 W:$D(IOF) @IOF W !,?35,"Data Entry Forms Summary   Page ",APCDPAGE,!
 Q
HEAD1 ;
 W:$D(IOF) @IOF S APCDPAGE=APCDPAGE+1
 W !,"Report Run Date: ",APCDDT,?70,"Page ",APCDPAGE
 W !!?15,"SUMMARY COUNT OF VISITS PROCESSED BY DATA ENTRY",!
 W ?20,"FOR:  ",APCDBDT,"  TO  ",APCDEDT,!
 S L=$L($P(^DIC(4,DUZ(2),0),U)) W ?((80-L)/2),$P(^DIC(4,DUZ(2),0),U),!
 Q
