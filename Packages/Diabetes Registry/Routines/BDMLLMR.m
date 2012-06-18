BDMLLMR ; IHS/CMI/LAB - PCC HEALTH SUMMARY ; 
 ;;2.0;DIABETES MANAGEMENT SYSTEM;**4**;JUN 14, 2007
 ;
 W:$D(IOF) @IOF
 W !!,"This report will list all lab tests or medications that are used at"
 W !,$P(^DIC(4,DUZ(2),0),U),".  It will list the name, internal entry number,"
 W !,"number of occurences, units and result example (lab only) and the taxonomies"
 W !,"that the item is a member of.",!
TYPE ;
 S BDMTYPE=""
 S DIR(0)="S^L:LAB TESTS;M:MEDICATIONS (DRUGS)",DIR("A")="Do you wish to list" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) D EXIT Q
 I Y="" D EXIT Q
 S BDMTYPE=Y
 S BDMTYPEP=Y(0)
 ;
GETDATES ;
BD ;get beginning date
 W ! K DIR S DIR(0)="D^:DT:EP",DIR("A")="Enter beginning Date for Search",DIR("B")=$$FMTE^XLFDT($$FMADD^XLFDT(DT,-365)) D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) D EXIT Q
 S BDMBD=Y
ED ;get ending date
 W ! S DIR(0)="DA^"_BDMBD_":DT:EP",DIR("A")="Enter ending date for Search:  " S Y=BDMBD D DD^%DT S Y="" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) G BD
 S BDMED=Y
 S X1=BDMBD,X2=-1 D C^%DTC S BDMSD=X
 ;
 ;
ZIS ;EP
 W !! S DIR(0)="S^P:PRINT Output;B:BROWSE Output on Screen",DIR("A")="Do you wish to",DIR("B")="P" K DA D ^DIR K DIR
 I $D(DIRUT) D EXIT Q
 S BDMOPT=Y
 I Y="B" D BROWSE,EXIT Q
 S XBRP="PRINT^BDMLLMR",XBRC="EN^BDMLLMR",XBRX="EXIT^BDMLLMR",XBNS="BDM;DFN"
 D ^XBDBQUE
 D EXIT1
 Q
 ;
BROWSE ;
 S XBRP="VIEWR^XBLM(""PRINT^BDMLLMR"")"
 S XBRC="EN^BDMLLMR",XBRX="EXIT^BDMLLMR",XBIOP=0 D ^XBDBQUE
 Q
EXIT ;
 ;K ^XTMP("BDMLLMR",BDMJ,BDMH)
 D EN^XBVK("BDM")
 K DFN
 D ^XBFMK
 Q
 ;
EXIT1 ;
 D CLEAR^VALM1
 D FULL^VALM1
 D EN^XBVK("BDM")
 K DFN
 D ^XBFMK
 Q
 ;
PRINT ;
 S BDMPG=0
 K BDMQUIT
 I '$D(^XTMP("BDMLLMR",BDMJ,BDMH)) D HDR W !!,"Nothing to Report." Q
 D HDR
 S BDMNAME="" F  S BDMNAME=$O(^XTMP("BDMLLMR",BDMJ,BDMH,"TESTS",BDMNAME)) Q:BDMNAME=""!($D(BDMQUIT))  D
 .I $Y>(IOSL-3) D HDR Q:$D(BDMQUIT)
 .S BDMIEN=0 F  S BDMIEN=$O(^XTMP("BDMLLMR",BDMJ,BDMH,"TESTS",BDMNAME,BDMIEN)) Q:BDMIEN'=+BDMIEN!($D(BDMQUIT))  D
 ..S BDMD=^XTMP("BDMLLMR",BDMJ,BDMH,"TESTS",BDMNAME,BDMIEN)
 ..W $E(BDMNAME,1,30),?32,BDMIEN,?41,$$C($P(BDMD,U,1),0,9)
 ..I BDMTYPE="L" W ?51,$P(BDMD,U,3),?63,$P(BDMD,U,2)
 ..W ! S T=$$TAX(BDMIEN,BDMTYPE) I T]"" W ?5,T,!
 ..Q
 .Q
 I $E(IOST)="C",IO=IO(0) S DIR(0)="EO",DIR("A")="End of report.  PRESS ENTER" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 Q
TAX(I,TYPE) ;
 NEW X,Y,Z,N,G,A,B
 S G=""
 I TYPE="M" Q $$TAXM(I)
 S Y=0 F  S Y=$O(^BDMTAXS("B",Y)) Q:Y=""  S Z=Y
 S Y=$O(^BDMTAXS("B",Z,0))
 S X=0 F  S X=$O(^ATXLAB(X)) Q:X'=+X  D
 .S N=$P(^ATXLAB(X,0),U)
 .Q:'$D(^BDMTAXS(Y,11,"B",N))  ;not used by dms
 .Q:'$D(^ATXLAB(X,21,"B",I))  ;not in this taxonomy
 .S G=$S(G]"":"; "_N,1:N)
 .Q
 Q G
TAXM(I) ;
 NEW X,Y,Z,N,G,A,B
 S G=""
 S Y=0 F  S Y=$O(^BDMTAXS("B",Y)) Q:Y=""  S Z=Y
 S Y=$O(^BDMTAXS("B",Z,0))
 S X=0 F  S X=$O(^ATXAX(X)) Q:X'=+X  D
 .Q:$P(^ATXAX(X,0),U,15)'=50
 .S N=$P(^ATXAX(X,0),U)
 .Q:'$D(^BDMTAXS(Y,11,"B",N))  ;not used by dms
 .Q:'$D(^ATXAX(X,21,"B",I))  ;not in this taxonomy
 .S G=$S(G]"":"; "_N,1:N)
 .Q
 Q G
C(X,X2,X3) ;
 D COMMA^%DTC
 Q X
CTR(X,Y) ;EP - Center X in a field Y wide.
 Q $J("",$S($D(Y):Y,1:IOM)-$L(X)\2)_X
 ;----------
USR() ;EP - Return name of current user from ^VA(200.
 Q $S($G(DUZ):$S($D(^VA(200,DUZ,0)):$P(^(0),U),1:"UNKNOWN"),1:"DUZ UNDEFINED OR 0")
 ;----------
LOC() ;EP - Return location name from file 4 based on DUZ(2).
 Q $S($G(DUZ(2)):$S($D(^DIC(4,DUZ(2),0)):$P(^(0),U),1:"UNKNOWN"),1:"DUZ(2) UNDEFINED OR 0")
 ;---------- 
 ;
EN ;
 S BDMJ=$J,BDMH=$H
 K ^XTMP("BDMLLMR",BDMJ,BDMH)
 S ^XTMP("BDMLLMR",0)=$$FMADD^XLFDT(DT,14)_"^"_DT_"^BDM LAB/MED REPORT"
 NEW X,Y,BDMN,L,P,T
 D PROC
 Q
PROC ;
 S BDMODAT=BDMSD_".9999" F  S BDMODAT=$O(^AUPNVSIT("B",BDMODAT)) Q:BDMODAT=""!((BDMODAT\1)>BDMED)  D V1
 Q
V1 ;
 S BDMVIEN="" F  S BDMVIEN=$O(^AUPNVSIT("B",BDMODAT,BDMVIEN)) Q:BDMVIEN'=+BDMVIEN  D
 .Q:'$D(^AUPNVSIT(BDMVIEN,0))
 .Q:'$P(^AUPNVSIT(BDMVIEN,0),U,9)
 .Q:$P(^AUPNVSIT(BDMVIEN,0),U,11)
 .D @BDMTYPE
 Q
L ;
 Q:'$D(^AUPNVLAB("AD",BDMVIEN))
 S X=0 F  S X=$O(^AUPNVLAB("AD",BDMVIEN,X)) Q:X'=+X  D
 .Q:'$D(^AUPNVLAB(X,0))
 .S I=$P(^AUPNVLAB(X,0),U)
 .S N=$$VAL^XBDIQ1(9000010.09,X,.01)
 .S R=$P(^AUPNVLAB(X,0),U,4)
 .S Y=$P($G(^AUPNVLAB(X,11)),U,1)
 .I '$D(^XTMP("BDMLLMR",BDMJ,BDMH,"TESTS",N,I)) S ^XTMP("BDMLLMR",BDMJ,BDMH,"TESTS",N,I)=0
 .S $P(^XTMP("BDMLLMR",BDMJ,BDMH,"TESTS",N,I),U,1)=$P(^XTMP("BDMLLMR",BDMJ,BDMH,"TESTS",N,I),U,1)+1
 .S $P(^XTMP("BDMLLMR",BDMJ,BDMH,"TESTS",N,I),U,2)=R
 .S $P(^XTMP("BDMLLMR",BDMJ,BDMH,"TESTS",N,I),U,3)=Y
 Q
M ;
 Q:'$D(^AUPNVMED("AD",BDMVIEN))
 S X=0 F  S X=$O(^AUPNVMED("AD",BDMVIEN,X)) Q:X'=+X  D
 .Q:'$D(^AUPNVMED(X,0))
 .S I=$P(^AUPNVMED(X,0),U)
 .S N=$$VAL^XBDIQ1(9000010.14,X,.01)
 .I '$D(^XTMP("BDMLLMR",BDMJ,BDMH,"TESTS",N,I)) S ^XTMP("BDMLLMR",BDMJ,BDMH,"TESTS",N,I)=0
 .S $P(^XTMP("BDMLLMR",BDMJ,BDMH,"TESTS",N,I),U,1)=$P(^XTMP("BDMLLMR",BDMJ,BDMH,"TESTS",N,I),U,1)+1
 Q
HDR ;
 G:BDMPG=0 HDR1
 I $E(IOST)="C",IO=IO(0) W ! S DIR(0)="EO" D ^DIR K DIR I Y=0!(Y="^")!($D(DTOUT)) S BDMQUIT="" Q
HDR1 ;
 I BDMPG W:$D(IOF) @IOF
 S BDMPG=BDMPG+1
 W $$FMTE^XLFDT(DT),?72,"Page ",BDMPG,!
 W $$CTR(BDMTYPEP_" Used at "_$P(^DIC(4,DUZ(2),0),U),80),!
 W $$CTR("Date Range:  "_$$FMTE^XLFDT(BDMBD)_" - "_$$FMTE^XLFDT(BDMED)),!
 W $S(BDMTYPE="L":"LAB TEST NAME",1:"MEDICATION/DRUG NAME"),?32,"IEN",?41,"# DONE"
 I BDMTYPE="L" W ?51,"UNITS",?64,"RESULT"
 W !,?5,"TAXONOMIES",!
 W "--------------------------------------------------------------------",!
 Q
