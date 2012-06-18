BDPPHXD ; IHS/CMI/TMJ - LISTING OF RECORDS BY DATE RANGE & CATEGORY ;
 ;;2.0;IHS PCC SUITE;**2**;MAY 14, 2009
 ;
 ;
 ;
 D INFORM ;Report Explanation
 ;
 W !
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
 S XBRC="PROC^BDPPHXD",XBRP="PRINT^BDPPHXD",XBNS="BDP",XBRX="END^BDPPHXD"
 D ^XBDBQUE
 D END
 Q
PROC ;
 ;loop through file and tally by catgegory, skip inactive patients
 S BDPJ=$J,BDPH=$H,BDPTCNT=0 K BDPSCNT
 K ^XTMP("BDPPHXD",BDPJ,BDPH)
 D XTMP^APCLOSUT("BDPPHXD","DESG PROVIDER REPORT")
 S BDPX=0 F  S BDPX=$O(^BDPRECN("B",BDPX)) Q:BDPX=""  D
 .I $D(BDPPROVC),BDPPROVC'=BDPX Q
 .S BDPIEN=0 F  S BDPIEN=$O(^BDPRECN("B",BDPX,BDPIEN)) Q:BDPIEN=""  D
 ..S DFN=$P(^BDPRECN(BDPIEN,0),U,2)
 ..Q:$P($G(^AUPNPAT(DFN,41,DUZ(2),0)),U,3)  ;inactive patients
 ..S BDPD=$$VAL^XBDIQ1(90360.1,BDPIEN,.01)
 ..S ^XTMP("BDPPHXD",BDPJ,BDPH,"HITS",$$VAL^XBDIQ1(90360.1,BDPIEN,.01),$$VAL^XBDIQ1(90360.1,BDPIEN,.02),DFN,BDPIEN)=""
 ..S BDPTCNT=BDPTCNT+1 S BDPSCNT(BDPD)=$G(BDPSCNT(BDPD))+1
 ..Q
 .Q
 Q
PRINT ;PRINT RECORDS BY DATE
 S BDPPG=0 K BDPQUIT
 D PAGEHEAD
 I '$D(^XTMP("BDPPHXD",BDPJ,BDPH,"HITS")) W !,"No data to report." D END Q
 S BDPD="" F  S BDPD=$O(^XTMP("BDPPHXD",BDPJ,BDPH,"HITS",BDPD)) Q:BDPD=""!($D(BDPQUIT))  D
 .I $Y>(IOSL-3) D PAGEHEAD Q:$D(BDPQUIT)
 .W !!,"PROVIDER CATEGORY: ",BDPD
 .S BDPPN=0 F  S BDPPN=$O(^XTMP("BDPPHXD",BDPJ,BDPH,"HITS",BDPD,BDPPN)) Q:BDPPN=""!($D(BDPQUIT))  D
 ..S DFN=0 F  S DFN=$O(^XTMP("BDPPHXD",BDPJ,BDPH,"HITS",BDPD,BDPPN,DFN)) Q:DFN=""!($D(BDPQUIT))  D
 ...S BDPI=0 F  S BDPI=$O(^XTMP("BDPPHXD",BDPJ,BDPH,"HITS",BDPD,BDPPN,DFN,BDPI)) Q:BDPI=""!($D(BDPQUIT))  D
 ....I $Y>(IOSL-8) D PAGEHEAD Q:$D(BDPQUIT)
 ....W !!?3,"PATIENT NAME:  ",$$VAL^XBDIQ1(90360.1,BDPI,.02),?50,"HEALTH RECORD: ",$$HRN^AUPNPAT(DFN,DUZ(2))
 ....W !?3,"PROVIDER CATEGORY:  ",$$VAL^XBDIQ1(90360.1,BDPI,.01)
 ....W !?12,"CURRENT PROVIDER:  ",$$VAL^XBDIQ1(90360.1,BDPI,.03)
 ....W !?12,"DATE UPDATED:  ",$$VAL^XBDIQ1(90360.1,BDPI,.05),"     USER UPDATED: ",$$VAL^XBDIQ1(90360.1,BDPI,.04)
 ....W !?8,"HISTORY DETAIL:"
 ....S BDPX=0 F  S BDPX=$O(^BDPRECN(BDPI,1,BDPX)) Q:BDPX'=+BDPX  D
 .....S BDPN=^BDPRECN(BDPI,1,BDPX,0)
 .....;I $P(BDPN,U,1)=$P(^BDPRECN(BDPI,0),U,3),$P(BDPN,U,2)=$P(^BDPRECN(BDPI,0),U,4),$P(BDPN,U,3)=$P(^BDPRECN(BDPI,0),U,5) Q  ;already listed last one
 .....W !?8,"OLD PROVIDER: ",$E($P(^VA(200,$P(BDPN,U,1),0),U,1),1,20),?42,$$DATE^BDPLMDSP($P(BDPN,U,3)),?53,"USER: ",$E($P(^VA(200,$P(BDPN,U,2),0),U,1),1,18)
 .I $Y>(IOSL-3) D PAGEHEAD Q:$D(BDPQUIT)
 .W !,"Subcount: ",BDPSCNT(BDPD),!
 I $D(BDPQUIT) G DONE
 ;I $Y>(IOSL-3) D PAGEHEAD G:$D(BDPQUIT) DONE
 ;W !!,"Total # of patients: ",BDPTCNT,!
DONE ;
 K ^XTMP("BDPPHXD",BDPJ,BDPH)
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
 W !,$$CTR("*****************************************************************",80)
 W !,$$CTR("*        DESIGNATED PROVIDER PATIENT HISTORY BY CATEGORY        *",80)
 W !,$$CTR("*****************************************************************",80)
 ;W !!,"PROVIDER CATEGORY",?22,"PATIENT NAME",?44,"LAST CURRENT PROVIDER",?68,"UPDATE DT"
 W !,$$REPEAT^XLFSTR("-",79)
 Q
CTR(X,Y) ;EP - Center X in a field Y wide.
 Q $J("",$S($D(Y):Y,1:IOM)-$L(X)\2)_X
 ;
INFORM ;Report Explanation
 ;
 W !?25,"******************************",!
 W ?10,"This Report prints a Listing of patients by the provider category."
 W !?10,"The report output includes a detailed history of that patient's"
 W !?10,"provider history."
 W !?25,"*****************************",!
 Q
