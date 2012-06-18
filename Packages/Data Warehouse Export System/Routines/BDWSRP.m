BDWSRP ; IHS/CMI/LAB - DW REPORT PRINT ;
 ;;1.0;IHS DATA WAREHOUSE;;JAN 23, 2006
 ;IHS/CMI/LAB - XTMP
START ;
 ;D CHKSITE^BDWRDRI
 S BDWSR("FAC PRINT")=$P(^DIC(4,DUZ(2),0),U)
 S Y=$P(^BDWXLOG(BDWSR("LOG"),0),U,3) D DD^%DT S BDWSR("RUN DATE")=Y
 S BDWSR("PG")=0
 D HEAD
 K BDWSR("QUIT")
 D PRINT
 I $E(IOST)="C",IO=IO(0) W ! S DIR("A")="End of Report - Press ENTER",DIR(0)="EO" D ^DIR K DIR
EOJ ;
 K BDW1,BDW2,BDW3,BDWX,BDWTOTO,BDWTOTC,BDWLC,BDWT
 K BDWPTR,BDWWC,BDW3,BDWT,BDWTOTC,BDWTOTO
 K X,Z,G,Y
 Q
PRINT ;
OVERVIEW ;
 I $Y>(IOSL-12) D HEAD Q:$D(BDWSR("QUIT"))
 W !!
 W !!,"This Data Warehouse Export was processed on ",BDWSR("RUN DATE")," for Posting ",!,"Dates ",BDWSR("PRINT BEGIN")," to ",BDWSR("PRINT END"),".  The following transactions were exported:"
 W !!?5,"Patient Registration updates:  ",$P(^BDWXLOG(BDWSR("LOG"),0),U,11)
 W !?5,"              PCC Encounters:  ",$P(^BDWXLOG(BDWSR("LOG"),0),U,18)
 W !?5," Total transactions exported:  ",$P(^BDWXLOG(BDWSR("LOG"),0),U,6)
GEN ;
STATDB ;
 D ^BDWSRP5
 Q:$D(BDWSR("QUIT"))
TAPE ;
 W !!,"The Transmission Status for this Export is:  "
 K DIQ,DIC,DA,DR
 S DIC="^BDWXLOG(",DR=".15",DA=BDWSR("LOG"),DIQ(0)="E" D EN^DIQ1 K DIC,DA,DR,DIQ
 W ^UTILITY("DIQ1",$J,90213,BDWSR("LOG"),.15,"E"),!
 Q
HEAD ;EP
 I 'BDWSR("PG") G HEAD1
 I $E(IOST)="C",IO=IO(0) W ! K DIR S DIR(0)="EO" D ^DIR K DIR I Y=0!(Y="^")!($D(DTOUT)) S BDWSR("QUIT")="" Q
 S BDWSR("PG")=BDWSR("PG")+1
 W:$D(IOF) @IOF W !?31,"Data Warehouse Transmission Summary   Page ",BDWSR("PG")
 Q
HEAD1 ;
 W:$D(IOF) @IOF S BDWSR("PG")=BDWSR("PG")+1
 S BDWSR("LENG")=40+$L(BDWSR("FAC PRINT"))
 W !,"Report Run Date: ",BDWSR("DTP"),?72,"Page ",BDWSR("PG")
 W !!?((80-BDWSR("LENG"))/2),"DATA WAREHOUSE TRANSMISSION SUMMARY FOR ",BDWSR("FAC PRINT")
 W !?20,"Date Export Run: ",BDWSR("RUN DATE")
 Q
