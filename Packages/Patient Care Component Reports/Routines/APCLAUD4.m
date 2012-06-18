APCLAUD4 ; IHS/CMI/LAB - MORE AUDIT SEARCH ;
 ;;2.0;IHS PCC SUITE;;MAY 14, 2009
 ;
 ;cmi/anch/maw 9/7/2007 code set versioning in ICDDSP
 ;
TOP ;EP
 W !!,"This Audit Search is based on the following criteria:",!
 W !!,"1.  Ambulatory Visits from ",APCLBDY," through ",APCLEDY
 I '$D(APCLLAGE) W !!,"2.  All Patient Ages included." G SEX
 W !!,"2.  Patient Age Range (as of Visit Date) from ",APCLLAGE," - ",APCLHAGE,"."
SEX ;
 W !!,"3.  ",$S($D(APCLSEX):APCLSEXP,1:"ALL")," Patient Sex"
SC ;
 W !!,"4.  ",$S($D(APCLSC):APCLSCP,1:"ALL")," Visit Service Categor",$S($D(APCLSC):"y.",1:"ies.")
TYPE W !!,"5.  ",$S($D(APCLTYPE):APCLTYPP,1:"ALL")," Visit Type",$S($D(APCLTYPE):".",1:"s.")
CLN W !!,"6.  ",$S($D(APCLCLN):APCLCLNP,1:"ALL")," Visit Clinic Type",$S($D(APCLCLN):"s.",1:".")
LOC W !!,"7.  ",$S($D(APCLLOC):APCLLOCP,1:"ALL")," Location of Encounter"
ICD I $D(APCLALLI) W !!,"8.  ALL ICD Codes." G TOP1
 W !!,"8.  The following ICD Code ranges: ",!
 S APCLDSP=0
 F  S APCLDSP=$O(^XTMP("APCLAUD",APCLJOB,APCLBT,APCLDSP)) Q:APCLDSP'=+APCLDSP  W !,"ICD Code Range ",APCLDSP,": ",^XTMP("APCLAUD",APCLJOB,APCLBT,APCLDSP,"ICDB")," through ",^XTMP("APCLAUD",APCLJOB,APCLBT,APCLDSP,"ICDE"),"."
TOP1 I $Y>(IOSL-4) D TOPHD I $D(APCLQ) K APCLQ Q
 I $D(APCLALLP),'$D(APCLNOSP) W !!,"9.  ALL Primary Providers." G TOP2
 I $D(APCLNOSP) W !!,"9.  NOT by Primary Provider." G TOP2
 W !!,"9.  The following Primary Providers:",!
 S APCLPRV=0
 F JJ=0:0 S APCLPRV=$O(^XTMP("APCLAUD",APCLJOB,APCLBT,"PROV",APCLPRV)) Q:APCLPRV'=+APCLPRV  D PRVDSP
TOP2 I $Y>(IOSL-4) D TOPHD I $D(APCLQ) K APCLQ Q
 I $D(APCLALLR) W !!,"10. ALL Diagnoses that match the Search Criteria." G TOP3
 W !!,"9.  Limited to ",APCLLIM," randomized Diagnoses " W:'$D(APCLNOSP) "per Provider " W !,"    that match the Search Criteria."
TOP3 D TOPHD I $D(APCLQ) K APCLQ Q
 Q
TOPHD ;EP
 S APCLPG=APCLPG+1 G:APCLPG=1 TOPHD1
 I $E(IOST)="C",IO(0)=IO S DIR(0)="EO" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) S APCLQ="" Q
TOPHD1 W:$D(IOF) @IOF
 W $P(^DIC(4,APCLSITE,0),"^"),?58,APCLDTP,?72,"Page ",APCLPG,!
 W !?30,"Audit Search Criteria",!!,APCL80D
 Q
ICDDSP I $Y>(IOSL-4) D TOPHD I $D(APCLQ) K APCLQ Q
 ;W:$D(^ICD9(APCLDSP,0)) !?4,$P(^ICD9(APCLDSP,0),"^"),?11,$P(^(0),"^",3)
 W !?4,$P($$ICDDX^ICDCODE(APCLDSP),"^",2),?11,$P($$ICDDX^ICDCODE(APCLDSP),"^",4)
 ;W:$D(^ICD9(APCLDSP,1)) !?11,$E($P(^(1),"^"),1,67),!  ;NO API IN CSV
 Q
PRVDSP I $Y>(IOSL-4) D TOPHD I $D(APCLQ) K APCLQ Q
 W !?4,$S($P(^DD(9000010.06,.01,0),U,2)[200:$P(^VA(200,APCLPRV,0),U),1:$P(^DIC(16,$P(^DIC(6,APCLPRV,0),"^"),0),"^")),!
 Q
ICDLN ;EP
 I $Y>(IOSL-9) D HEAD^APCLAUD2
 W !!!,"---> ICD Code Range: "
 I $D(APCLALLI) W "ALL ICD Codes." G ICDLN1
 W ^XTMP("APCLAUD",APCLJOB,APCLBT,APCLIRNG,"ICDB")," through ",^("ICDE")
ICDLN1 W !?6,"Total Matches: ",APCLCNT W "    Matches Selected: ",APCLGOT
 Q
