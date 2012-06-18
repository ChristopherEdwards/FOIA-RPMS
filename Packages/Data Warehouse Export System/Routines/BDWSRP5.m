BDWSRP5 ; IHS/CMI/LAB - DW REPORT PRINT CONT ;
 ;;1.0;IHS DATA WAREHOUSE;;JAN 23, 2006
 I $Y>(IOSL-10) D HEAD^BDWSRP Q:$D(BDWSR("QUIT"))
 W !!!,"DATA WAREHOUSE RECORDS EXPORTED"
 I '$P(^BDWXLOG(BDWSR("LOG"),0),U,18) W !,"There were NO DATA WAREHOUSE VISIT transactions generated.",!! G EOJ
 W !,"Following is a breakdown of all encounters that generated DATA WAREHOUSE",!,"transactions by Visit Date, Type, Location, Service Category, Clinic and",!,"Primary Provider Discipline."
INPT ;
 S BDWSR("INPT CNT")=0
 S X=0 F  S X=$O(^BDWXLOG(BDWSR("LOG"),21,X)) Q:X'=+X  I $D(^AUPNVSIT(X,0)) S V=^AUPNVSIT(X,0) I $P(^BDWXLOG(BDWSR("LOG"),21,X,0),U,2),$P(V,U,7)="H",$P(V,U,6)=DUZ(2) S BDWSR("INPT CNT")=BDWSR("INPT CNT")+1
 I $Y>(IOSL-4) D HEAD^BDWSRP Q:$D(BDWSR("QUIT"))
 W !!,"Total # of Hospitalization Encounters to this Facility that were exported: ",BDWSR("INPT CNT"),!
VD ;
 ;
 S BDWSR("PTR")=0,BDWSR("T")="By Visit Date:",BDWSR("1")="V DATE STATDB",BDWSR("2")="V DATE STATDB",BDWSR("WC")=0
 D PROC Q:$D(BDWSR("QUIT"))
TYPE ;
 S BDWSR("PTR")=0,BDWSR("T")="By Type:",BDWSR("1")="TYPE STATDB",BDWSR("2")="TYPE STATDB CC",BDWSR("WC")=0
 D PROC Q:$D(BDWSR("QUIT"))
LOC ;
 S BDWSR("PTR")=1,BDWSR("T")="By Location:",BDWSR("1")="LOC STATDB",BDWSR("2")="LOC STATDB CC",BDWSR("WC")=0,BDWSR("GLOBAL")="^DIC(4,",BDWSR("PIECE")=1
 D PROC Q:$D(BDWSR("QUIT"))
SC ;
 S BDWSR("PTR")=0,BDWSR("T")="By Service Category:",BDWSR("1")="SC STATDB",BDWSR("2")="SC STATDB CC",BDWSR("WC")=0
 D PROC Q:$D(BDWSR("QUIT"))
CLINIC ;
 S BDWSR("PTR")=0,BDWSR("T")="By Clinic Type:",BDWSR("1")="CLINIC STATDB",BDWSR("2")="CLINIC STATDB CC",BDWSR("WC")=0
 D PROC Q:$D(BDWSR("QUIT"))
PROVDISC ;
 S BDWSR("PTR")=0,BDWSR("T")="By Provider Type (Primary Provider only):",BDWSR("1")="PROV STATDB",BDWSR("2")="PROV STATDB CC",BDWSR("WC")=0
 D PROC Q:$D(BDWSR("QUIT"))
ERRS ;
 I $Y>(IOSL-3) D HEAD^BDWSRP Q:$D(BDWSR("QUIT"))
 W !!?18,"Number of encounters skipped:",?50,$$VAL^XBDIQ1(90213,BDWSR("LOG"),.05)
 I $Y>(IOSL-3) D HEAD^BDWSRP Q:$D(BDWSR("QUIT"))
 I $P($G(^BDWXLOG(BDWSR("LOG"),31)),U,3) W !?20,"Deleted encounters skipped:",?50,$$VAL^XBDIQ1(90213,BDWSR("LOG"),3103)
 I $Y>(IOSL-3) D HEAD^BDWSRP Q:$D(BDWSR("QUIT"))
 I $P($G(^BDWXLOG(BDWSR("LOG"),31)),U,2) W !?17,"Zero dep entry visits skipped:",?50,$$VAL^XBDIQ1(90213,BDWSR("LOG"),3102)
 I $Y>(IOSL-3) D HEAD^BDWSRP Q:$D(BDWSR("QUIT"))
 I $P($G(^BDWXLOG(BDWSR("LOG"),31)),U,11) W !?28,"MFI visits skipped:",?50,$$VAL^XBDIQ1(90213,BDWSR("LOG"),3111)
 I $Y>(IOSL-3) D HEAD^BDWSRP Q:$D(BDWSR("QUIT"))
 I $P($G(^BDWXLOG(BDWSR("LOG"),31)),U,4) W !?17,"NO PATIENT encounters skipped:",?50,$$VAL^XBDIQ1(90213,BDWSR("LOG"),3104)
 I $Y>(IOSL-3) D HEAD^BDWSRP Q:$D(BDWSR("QUIT"))
 I $P($G(^BDWXLOG(BDWSR("LOG"),31)),U,5) W !?13,"NO LOCATION of encounters skipped:",?50,$$VAL^XBDIQ1(90213,BDWSR("LOG"),3105)
 I $Y>(IOSL-3) D HEAD^BDWSRP Q:$D(BDWSR("QUIT"))
 I $P($G(^BDWXLOG(BDWSR("LOG"),31)),U,6) W !?11,"NO TYPE OF VISIT encounters skipped:",?50,$$VAL^XBDIQ1(90213,BDWSR("LOG"),3106)
 I $Y>(IOSL-3) D HEAD^BDWSRP Q:$D(BDWSR("QUIT"))
 I $P($G(^BDWXLOG(BDWSR("LOG"),31)),U,7) W !?8,"NO SERVICE CATEGORY encounters skipped:",?50,$$VAL^XBDIQ1(90213,BDWSR("LOG"),3107)
 I $Y>(IOSL-3) D HEAD^BDWSRP Q:$D(BDWSR("QUIT"))
 I $P($G(^BDWXLOG(BDWSR("LOG"),31)),U,1) W !?15,"DEMO PATIENT encounters skipped:",?50,$$VAL^XBDIQ1(90213,BDWSR("LOG"),3101)
TEXT ;
 I $Y>(IOSL-3) D HEAD^BDWSRP Q:$D(BDWSR("QUIT"))
 W !!,"To list the encounters that were skipped, use option DWER."
 ;show trailer report
 I $Y>(IOSL-3) D HEAD^BDWSRP Q:$D(BDWSR("QUIT"))
 W !!,"The following 'trailer report' was included with the export ",!,"to the Data Warehouse:",!
 S BDWX=0 F  S BDWX=$O(^BDWXLOG(BDWSR("LOG"),99,BDWX)) Q:BDWX'=+BDWX!($D(BDWSR("QUIT")))  D
 .I $Y>(IOSL-3) D HEAD^BDWSRP Q:$D(BDWSR("QUIT"))
 .W !?3,^BDWXLOG(BDWSR("LOG"),99,BDWX,0)
EOJ ;
 Q
PROC ;
 I $Y>(IOSL-9) D HEAD^BDWSRP Q:$D(BDWSR("QUIT"))
 W !!?10,BDWSR("T")
 S BDWSR("N")=0 F  S BDWSR("N")=$O(^XTMP("BDWSR",BDWJOB,BDWBTH,"GEN",BDWSR("2"),BDWSR("N"))) Q:BDWSR("N")=""!($D(BDWSR("QUIT")))  D PROC1
 Q
PROC1 ;
 I BDWSR("2")["DATE" D PRNT Q
 S BDWSR("D")=0 F  S BDWSR("D")=$O(^XTMP("BDWSR",BDWJOB,BDWBTH,"GEN",BDWSR("2"),BDWSR("N"),BDWSR("D"))) Q:BDWSR("D")=""  D PRNT
 Q
PRNTDATE ;
 S Y=BDWSR("N") D DD^%DT W !?13,Y,?45,$J(^XTMP("BDWSR",BDWJOB,BDWBTH,"GEN",BDWSR("2"),BDWSR("N")),7) S BDWSR("WC")=BDWSR("WC")+1
 Q
PRNT ;
 I $Y>(IOSL-5) D HEAD^BDWSRP Q:$D(BDWSR("QUIT"))  W !!?10,BDWSR("T") W:BDWSR("WC")>0 " (cont.)"
 I BDWSR("1")="V DATE STATDB" D PRNTDATE Q
 S X=^XTMP("BDWSR",BDWJOB,BDWBTH,"GEN",BDWSR("2"),BDWSR("N"),BDWSR("D"))
 I BDWSR("PTR")=1 D PRNTPTR Q
 W !?13,BDWSR("D"),?45,$J(X,7) S BDWSR("WC")=BDWSR("WC")+1
 Q
PRNTPTR ;
 S G=BDWSR("GLOBAL")_BDWSR("D")_")"
 W !
 I $D(@G@(0)) W ?13,$P(@G@(0),U,BDWSR("PIECE"))
 W ?45,$J(X,7)
 S BDWSR("WC")=BDWSR("WC")+1
 I BDWSR("1")="LOC STATDB" W ?55,"(IHS CODE: ",$P(^AUTTLOC(BDWSR("D"),0),U,10),")"
 K G
 Q
