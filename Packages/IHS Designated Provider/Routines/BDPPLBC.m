BDPPLBC ; IHS/CMI/TMJ - LISTING OF RECORDS BY DATE RANGE & CATEGORY ;
 ;;2.0;IHS PCC SUITE;**2**;MAY 14, 2009
 ;
 ;
 ;
 D INFORM ;Report Explanation
CAT ;
 W !
 K BDPPROVC
 S DIR(0)="SO^O:One Provider Category;A:All Provider Categories",DIR("A")="Do you want to report on ",DIR("B")="O" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) D END Q
 I Y="A" G ZIS
 S DIC="^BDPTCAT(",DIC(0)="AEMQ" D ^DIC K DIC,DA
 I Y=-1 G CAT
 S BDPPROVC=+Y
ZIS ;
 S XBRC="PROC^BDPPLBC",XBRP="PRINT^BDPPLBC",XBNS="BDP",XBRX="END^BDPPLBC"
 D ^XBDBQUE
 D END
 Q
PROC ;
 ;loop through file and tally by catgegory, skip inactive patients
 S BDPJ=$J,BDPH=$H,BDPTCNT=0 K BDPSCNT
 K ^XTMP("BDPPLBC",BDPJ,BDPH)
 D XTMP^APCLOSUT("BDPPLBC","DESG PROVIDER REPORT")
 S BDPX=0 F  S BDPX=$O(^BDPRECN("B",BDPX)) Q:BDPX=""  D
 .I $D(BDPPROVC),BDPX'=BDPPROVC Q
 .S BDPIEN=0 F  S BDPIEN=$O(^BDPRECN("B",BDPX,BDPIEN)) Q:BDPIEN=""  D
 ..S DFN=$P(^BDPRECN(BDPIEN,0),U,2)
 ..Q:$P($G(^AUPNPAT(DFN,41,DUZ(2),0)),U,3)  ;inactive patients
 ..S BDPD=$$VAL^XBDIQ1(90360.1,BDPIEN,.01)
 ..S ^XTMP("BDPPLBC",BDPJ,BDPH,"HITS",$$VAL^XBDIQ1(90360.1,BDPIEN,.01),$$VAL^XBDIQ1(90360.1,BDPIEN,.04),BDPIEN)=""
 ..S BDPTCNT=BDPTCNT+1 S BDPSCNT(BDPD)=$G(BDPSCNT(BDPD))+1
 ..Q
 .Q
 Q
PRINT ;PRINT RECORDS BY DATE
 S BDPPG=0 K BDPQUIT
 D PAGEHEAD
 I '$D(^XTMP("BDPPLBC",BDPJ,BDPH,"HITS")) W !,"No data to report." D END Q
 S BDPD="" F  S BDPD=$O(^XTMP("BDPPLBC",BDPJ,BDPH,"HITS",BDPD)) Q:BDPD=""!($D(BDPQUIT))  D
 .S BDPPN=0 F  S BDPPN=$O(^XTMP("BDPPLBC",BDPJ,BDPH,"HITS",BDPD,BDPPN)) Q:BDPPN=""!($D(BDPQUIT))  D
 ..S BDPI=0 F  S BDPI=$O(^XTMP("BDPPLBC",BDPJ,BDPH,"HITS",BDPD,BDPPN,BDPI)) Q:BDPI=""!($D(BDPQUIT))  D
 ...I $Y>(IOSL-3) D PAGEHEAD Q:$D(BDPQUIT)
 ...W !,$E($$VAL^XBDIQ1(90360.1,BDPI,.01),1,20),?22,$E($$VAL^XBDIQ1(90360.1,BDPI,.02),1,20),?44,$E($$VAL^XBDIQ1(90360.1,BDPI,.04),1,20),?68,$$DATE^BDPLMDSP($$VALI^XBDIQ1(90360.1,BDPI,.05))
 .I $Y>(IOSL-3) D PAGEHEAD Q:$D(BDPQUIT)
 .W !,"Subcount: ",BDPSCNT(BDPD),!
 I $D(BDPQUIT) G DONE
DONE ;
 K ^XTMP("BDPPLBC",BDPJ,BDPH)
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
 W !,$$CTR("******************************************************",80)
 W !,$$CTR("*        DESIGNATED PROVIDER LIST BY CATEGORY        *",80)
 W !,$$CTR("******************************************************",80)
 W !!,"PROVIDER CATEGORY",?22,"PATIENT NAME",?44,"LAST CURRENT PROVIDER",?68,"UPDATE DT"
 W !,$$REPEAT^XLFSTR("-",79)
 Q
CTR(X,Y) ;EP - Center X in a field Y wide.
 Q $J("",$S($D(Y):Y,1:IOM)-$L(X)\2)_X
 ;
INFORM ;Report Explanation
 ;
 W !,?25,"******************************",!
 W ?10,"This Report prints a Listing of patients by the provider category."
 W !?10,"The report output includes:",!,?10,"Category Type-Patient Name-Current Provider-Date of Last Update.",!
 W ?25,"*****************************",!
 Q
