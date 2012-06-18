BDPUPDT ; IHS/CMI/TMJ - LISTING OF RECORDS BY DATE RANGE & CATEGORY ;
 ;;2.0;IHS PCC SUITE;**2**;MAY 14, 2009
 ;
 ;
 ;
 D INFORM ;Report Explanation
 ;
ASK ;Ask For Date Range
 ;
 ;
BD ;get beginning date
 W !! S DIR(0)="D^::EP",DIR("A")="Enter beginning Update Date" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) G END
 S BDPBD=Y
ED ;get ending date
 W ! S DIR(0)="DA^"_BDPBD_":DT:EP",DIR("A")="Enter ending Update Date:  "  D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) G BD
 S BDPED=Y
 S X1=BDPBD,X2=-1 D C^%DTC S BDPSD=X
 W !
ZIS ;
 S XBRC="PROC^BDPUPDT",XBRP="PRINT^BDPUPDT",XBNS="BDP",XBRX="END^BDPUPDT"
 D ^XBDBQUE
 D END
 Q
PROC ;
 ;loop through file and tally by catgegory, skip inactive patients
 S BDPJ=$J,BDPH=$H,BDPTCNT=0
 K ^XTMP("BDPUPDT",BDPJ,BDPH)
 D XTMP^APCLOSUT("BDPUPDT","DESG PROVIDER REPORT")
 S BDPX=0 F  S BDPX=$O(^BDPRECN("B",BDPX)) Q:BDPX=""  D
 .S BDPIEN=0 F  S BDPIEN=$O(^BDPRECN("B",BDPX,BDPIEN)) Q:BDPIEN=""  D
 ..S DFN=$P(^BDPRECN(BDPIEN,0),U,2)
 ..Q:$P($G(^AUPNPAT(DFN,41,DUZ(2),0)),U,3)  ;inactive patients
 ..S D=$P(^BDPRECN(BDPIEN,0),U,5)
 ..Q:D=""
 ..Q:D<BDPBD
 ..Q:D>BDPED
 ..S ^XTMP("BDPUPDT",BDPJ,BDPH,"HITS",D,$$VAL^XBDIQ1(90360.1,BDPIEN,.01),BDPIEN)=""
 ..S BDPTCNT=BDPTCNT+1
 ..Q
 .Q
 Q
PRINT ;PRINT RECORDS BY DATE
 ;W !
 S BDPPG=0 K BDPQUIT
 D PAGEHEAD
 I '$D(^XTMP("BDPUPDT",BDPJ,BDPH,"HITS")) W !,"No data to report." D END Q
 S BDPD="" F  S BDPD=$O(^XTMP("BDPUPDT",BDPJ,BDPH,"HITS",BDPD)) Q:BDPD=""!($D(BDPQUIT))  D
 .S BDPX=0 F  S BDPX=$O(^XTMP("BDPUPDT",BDPJ,BDPH,"HITS",BDPD,BDPX)) Q:BDPX=""!($D(BDPQUIT))  D
 ..S BDPI=0 F  S BDPI=$O(^XTMP("BDPUPDT",BDPJ,BDPH,"HITS",BDPD,BDPX,BDPI)) Q:BDPI=""!($D(BDPQUIT))  D
 ...I $Y>(IOSL-3) D PAGEHEAD Q:$D(BDPQUIT)
 ...W !,$E($$VAL^XBDIQ1(90360.1,BDPI,.01),1,20),?22,$E($$VAL^XBDIQ1(90360.1,BDPI,.02),1,20),?44,$E($$VAL^XBDIQ1(90360.1,BDPI,.04),1,20),?68,$$DATE^BDPLMDSP(BDPD)
 I $D(BDPQUIT) G DONE
 I $Y>(IOSL-3) D PAGEHEAD G:$D(BDPQUIT) DONE
 W !!,"Total # of patients: ",BDPTCNT,!
DONE ;
 K ^XTMP("BDPUPDT",BDPJ,BDPH)
 D END
 Q
END ;
 D EN^XBVK("BDP")
 Q
 ;
PAGEHEAD ;
HEAD ;EP;HEADER
 G:$D(BDPDEM)!($D(BDPDEMM)) HEAD2
 I 'BDPPG G HEAD1
HEAD2 I $E(IOST)="C",IO=IO(0) W ! S DIR(0)="EO" D ^DIR K DIR I Y=0!(Y="^")!($D(DTOUT)) S BDPQUIT="" Q
HEAD1 ;
 W:$D(IOF) @IOF S BDPPG=BDPPG+1
 W !,$$FMTE^XLFDT(DT),?70,"Page: ",BDPPG
 W !,$$CTR("***************************************************************",80)
 W !,$$CTR("*        DESIGNATED PROVIDER LIST BY DATE LAST UPDATED        *",80)
 W !,$$CTR("***************************************************************",80)
 S X="Date Range: "_$$FMTE^XLFDT(BDPBD)_" through "_$$FMTE^XLFDT(BDPED) W !,$$CTR(X,80)
 W !!,"PROVIDER CATEGORY",?22,"PATIENT NAME",?44,"LAST CURRENT PROVIDER",?68,"UPDATE DT"
 W !,$$REPEAT^XLFSTR("-",79)
 Q
CTR(X,Y) ;EP - Center X in a field Y wide.
 Q $J("",$S($D(Y):Y,1:IOM)-$L(X)\2)_X
 ;
INFORM ;Report Explanation
 ;
 W !,?25,"******************************",!
 W ?10,"This Report prints a Listing of Records updated for a",!,?10,"specific date range - entered by the User.",!
 W !?10,"The report output includes:",!,?10,"Category Type-Patient Name-Current Provider-Date of Last Update.",!
 W ?25,"*****************************",!
 Q
