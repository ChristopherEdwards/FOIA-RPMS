APCPSRP ; IHS/TUCSON/LAB - print Operational summary AUGUST 14, 1992 ; [ 08/17/03  8:19 PM ]
 ;;2.0;IHS PCC DATA EXTRACTION SYSTEM;**1,6**;APR 03, 1998
 ;IHS/CMI/LAB - XTMP
START ;
 D CHKSITE^APCPDRI
 S APCPSR("FAC PRINT")=$P(^DIC(4,DUZ(2),0),U)
 S Y=$P(^APCPLOG(APCPSR("LOG"),0),U,3) D DD^%DT S APCPSR("RUN DATE")=Y
 S APCPSR("PG")=0
 D HEAD
 K APCPSR("QUIT")
 D PRINT
 I $E(IOST)="C",IO=IO(0) W ! S DIR("A")="End of Report - Hit return",DIR(0)="EO" D ^DIR K DIR
EOJ ;
 K APCP1,APCP2,APCP3,APCPX,APCPTOTO,APCPTOTC,APCPLC,APCPT
 K APCPPTR,APCPWC,APCP3,APCPT,APCPTOTC,APCPTOTO
 K X,Z,G,Y
 Q
PRINT ;
OVERVIEW ;
 I $Y>(IOSL-12) D HEAD Q:$D(APCPSR("QUIT"))
 W !!
 W !,"Your site is currently set up to generate the following record types: "
 ;W:$D(APCPS("APC")) !?10,"- Ambulatory Patient Care (APC) records"
 ;W:$D(APCPS("INPT")) !?10,"- Direct Inpatient System records"
 ;W:$D(APCPS("CHA")) !?10,"- Community Health Activity Reporting System (CHA) records"
 W:$D(APCPS("STAT")) !?10,"- Statistical Database Records"
 W !!,"This PCC Export was processed on ",APCPSR("RUN DATE")," for Posting Dates",!,APCPSR("PRINT BEGIN")," to ",APCPSR("PRINT END"),".  A total of ",$P(^APCPLOG(APCPSR("LOG"),0),U,8)," visits were processed, exporting "
 W !,"the following ",$P(^APCPLOG(APCPSR("LOG"),0),U,6)," transaction records:",!
 ;W:$P(^APCPLOG(APCPSR("LOG"),0),U,13) !?5,"- ",$J($P(^APCPLOG(APCPSR("LOG"),0),U,13),6),?15,"Ambulatory Patient Care (APC) Records"
 ;W:$P(^APCPLOG(APCPSR("LOG"),0),U,11) !?5,"- ",$J($P(^APCPLOG(APCPSR("LOG"),0),U,11),6),?15,"Direct Inpatient Records"
 ;W:$P(^APCPLOG(APCPSR("LOG"),0),U,14) !?5,"- ",$J($P(^APCPLOG(APCPSR("LOG"),0),U,14),6),?15,"Community Health Activity (CHA) Records"
 W:$P(^APCPLOG(APCPSR("LOG"),0),U,18) !?5,"- ",$J($P(^APCPLOG(APCPSR("LOG"),0),U,18),6),?15,"Visits were exported (",$P(^(0),U,17)," total records/transactions)"
GEN ;
 G STATDB
 ;I '$P(^APCPLOG(APCPSR("LOG"),0),U,6) G INPT
 W !!,"APC VISITS EXPORTED"
 W !,"Following is a breakdown of all visits that generated APC transactions by Visit",!,"Date, Type, Location, Service Category, Clinic and Primary Provider Discipline."
 D APC^APCPSRP2
 Q:$D(APCPSR("QUIT"))
INPT ;
 G:'$P(^APCPLOG(APCPSR("LOG"),0),U,11) DENT
 W !!!,"VISITS EXPORTED TO THE IHS DIRECT INPATIENT SYSTEM"
 W !,"Following is a breakdown of all visits that generated Direct Inpatient",!,"Transactions:",!
 D INPT^APCPSRP2
 Q:$D(APCPSR("QUIT"))
 ;
DENT ;
 G:'$D(^XTMP("APCPSR",APCPJOB,APCPBTH,"GEN","DENTWMEDS")) CHA
 W !!,"DENTAL VISITS"
 W !,^XTMP("APCPSR",APCPJOB,APCPBTH,"GEN","DENTWMEDS")," of the above PHARMACY Clinic visits were actually DENTAL Clinic visits",!,"on which a medication was prescribed.  The DENTAL Clinic visits were ",!
 W "converted to PHARMACY Clinic prior to generating the APC transaction record.",!
CHA ;PRINT CHA TOTALS
 I '$D(APCPS("CHA")) G STATDB
 W !!!,"COMMUNITY HEALTH NURSING ACTIVITY (CHA) TRANSACTIONS"
 D ^APCPSRP4
 Q:$D(APCPSR("QUIT"))
STATDB ;
 ;G:'$P(^APCPLOG(APCPSR("LOG"),0),U,17) SKIPPED
 D ^APCPSRP5
 Q:$D(APCPSR("QUIT"))
SKIPPED ;
 ;G:'$D(^XTMP("APCPSR",APCPJOB,APCPBTH,"SKIPPED","TOTAL")) TAPE
 D ^APCPSRP3
 Q:$D(APCPSR("QUIT"))
TAPE ;
 W !!,"The Transmission Status for this Export is:  "
 K DIQ,DIC,DA,DR
 S DIC="^APCPLOG(",DR=".15",DA=APCPSR("LOG"),DIQ(0)="E" D EN^DIQ1 K DIC,DA,DR,DIQ
 W ^UTILITY("DIQ1",$J,9001005,APCPSR("LOG"),.15,"E"),!
 Q
HEAD ;EP
 I 'APCPSR("PG") G HEAD1
 I $E(IOST)="C",IO=IO(0) W ! K DIR S DIR(0)="EO" D ^DIR K DIR I Y=0!(Y="^")!($D(DTOUT)) S APCPSR("QUIT")="" Q
 S APCPSR("PG")=APCPSR("PG")+1
 W:$D(IOF) @IOF W !?45,"PCC Transmission Summary   Page ",APCPSR("PG")
 Q
HEAD1 ;
 W:$D(IOF) @IOF S APCPSR("PG")=APCPSR("PG")+1
 S APCPSR("LENG")=30+$L(APCPSR("FAC PRINT"))
 W !,"Report Run Date: ",APCPSR("DTP"),?70,"Page ",APCPSR("PG")
 W !!?((80-APCPSR("LENG"))/2),"DATA TRANSMISSION SUMMARY FOR ",APCPSR("FAC PRINT")
 W !?20,"Date Export Run: ",APCPSR("RUN DATE")
 Q
