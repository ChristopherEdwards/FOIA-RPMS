BDWRDRI ; IHS/CMI/LAB - INIT FOR DW ;
 ;;1.0;IHS DATA WAREHOUSE;**1,2**;JAN 23, 2006
 ;
START ;
 D BASICS ;      Set variables like U,DT,DUZ(2) etc.
 D CHKSITE ;     Make sure Site file has correct fields.
 Q:BDW("QFLG")
 ;
 D:BDWO("RUN")="NEW" ^BDWRDRI2 ;  Do new run initialization.
 Q:$D(ZTQUEUED)
 Q:BDW("QFLG")
 D:BDWO("RUN")="NEW" QUEUE
 Q
 ;
BASICS ;EP - BASIC INITS
 K ^BDWDATA ;export global
 S BDWVA("COUNT")=0
 D HOME^%ZIS S BDWBS=$S('$D(ZTQUEUED):IOBS,1:"")
 K BDW,BDWS,BDWV,BDWT,BDWE,BDWERRC
 S BDW("RUN LOCATION")=$P(^AUTTLOC($P(^AUTTSITE(1,0),U),0),U,10),BDW("QFLG")=0
 S APCDOVRR=1 ; Allow VISIT lookup with 0 'dependent entry count'.
 S (BDW("SKIP"),BDW("TXS"),BDW("VPROC"),BDW("COUNT"),BDW("VISITS"),BDWERRC,BDW("REG"),BDW("DEMO"),BDW("ZERO"),BDW("DEL"),BDW("NO PAT"),BDW("NO LOC"),BDW("NO TYPE"),BDW("NO CAT"),BDW("MFI"),BDWVA("COUNT"))=0
 S (BDW("MODS"),BDW("ADDS"),BDW("DELS"))=0
 S BDWIEDST=$O(^INRHD("B","HL IHS DW1 IE",0))
 D TAXCHK
 Q
 ;
CHKSITE ;EP
 S BDWS("PROV FILE")=$S($P(^DD(9000010.06,.01,0),U,2)[200:200,1:6)
 I '$D(^AUTTSITE(1,0)) W:'$D(ZTQUEUED) !!,"*** RPMS SITE FILE has not been set up! ***" S BDW("QFLG")=1 Q
 I $P(^AUTTLOC($P(^AUTTSITE(1,0),U),0),U,10)="" W:'$D(ZTQUEUED) !!,"No ASUFAC for facility in RPMS Site file!!" S BDW("QFLG")=1 Q
 I '$D(^BDWSITE(1,0)) W:'$D(ZTQUEUED) !!,"*** Site file has not been setup! ***" S BDW("QFLG")=1 Q
 I $P(^BDWSITE(1,0),U)'=DUZ(2) W:'$D(ZTQUEUED) !!,"*** RUN LOCATION not in SITE file!" S BDW("QFLG")=2 Q
 I $P(^BDWSITE(1,0),U,6)="" W:'$D(ZTQUEUED) !!,"VISIT backloading has not been completed.  Must be finished first." S BDW("QFLG")=3 Q
 I $P($G(^BDWSITE(1,11)),U) S BDW("DNS")=1
 S X=$O(^INRHD("B","HL IHS DW1 IE",0))
 I $D(^BDWTMP(X)) W:'$D(ZTQUEUED) !!,"previous DW export not written to host file" S BDW("QFLG")=4 Q
 K ^BDWTMP(X)
 Q
QUEUE ;EP
 K ZTSK
 S DIR(0)="Y",DIR("A")="Do you want to QUEUE this to run at a later time",DIR("B")="N" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I Y=1 D QUEUE1 Q
 I BDWO("RUN")="NEW",$D(DIRUT) S BDW("QFLG")=99 S DA=BDW("RUN LOG"),DIK="^BDWXLOG(" W !,"Okay, you '^'ed out or timed out so I'm deleting the Log entry and quitting.",! D ^DIK K DIK,DA
 I BDWO("RUN")="REDO",$D(DIRUT) S BDW("QFLG")=99 Q
 Q
QUEUE1 ;
 S ZTRTN=$S(BDWO("RUN")="NEW":"DRIVER^BDWRDR",1:"EN^BDWREDO")
 S ZTIO="",ZTDTH="",ZTDESC="DATA WAREHOUSE DATA TRANSMISSION" S ZTSAVE("BDW*")="",ZTSAVE("APCD*")=""
 D ^%ZTLOAD
 W !!,$S($D(ZTSK):"Request Queued!!",1:"Request cancelled")
 I '$D(ZTSK),BDWO("RUN")="NEW" S BDW("QFLG")=99 S DA=BDW("RUN LOG"),DIK="^BDWXLOG(" W !,"Okay, you '^'ed out or timed out so I'm deleting the Log entry and quitting.",! D ^DIK K DIK,DA Q
 S BDWO("QUEUE")=""
 S DIE="^BDWXLOG(",DA=BDW("RUN LOG"),DR=".15///Q" D ^DIE K DIE,DA,DR
 K ZTSK
 Q
TAXCHK ;EP
 I $D(BDWO("SCHEDULED")) Q  ;don't do this if scheduled
 K BDWQUIT
 I '$D(ZTQUEUED) W !,"Checking for Taxonomies to support the Data Warehouse Extract...",!
 NEW A,BDWX,I,Y,Z,J
 K A
 S T="TAXS" F J=1:1 S Z=$T(@T+J),BDWX=$P(Z,";;",2),Y=$P(Z,";;",3) Q:BDWX=""  D
 .I '$D(^ATXAX("B",BDWX)) S A(BDWX)=Y_"^is Missing" Q
 .S I=$O(^ATXAX("B",BDWX,0))
 .I '$D(^ATXAX(I,21,"B")) S A(BDWX)=Y_"^has no entries "
 S T="LAB" F J=1:1 S Z=$T(@T+J),BDWX=$P(Z,";;",2),Y=$P(Z,";;",3) Q:BDWX=""  D
 .I '$D(^ATXLAB("B",BDWX)) S A(BDWX)=Y_"^is Missing " Q
 .S I=$O(^ATXLAB("B",BDWX,0))
 .I '$D(^ATXLAB(I,21,"B")) S A(BDWX)=Y_"^has no entries "
 I '$D(A) W:'$D(ZTQUEUED) !,"All okay.",! K A,BDWX,Y,I,Z Q
 I $D(ZTQUEUED) Q
 W:'$D(ZTQUEUED) !!,"In order for the Data Warehouse software to find all necessary data, several",!,"taxonomies must be established.  The following taxonomies are missing or have",!,"no entries:"
 S BDWX="" F  S BDWX=$O(A(BDWX)) Q:BDWX=""!($D(BDWQUIT))  D
 .I $Y>(IOSL-2) D PAGE Q:$D(BDWQUIT)
 .W !,$P(A(BDWX),U)," [",BDWX,"] ",$P(A(BDWX),U,2)
 .Q
DONE ;
 I $E(IOST)="C",IO=IO(0) S DIR(0)="EO",DIR("A")="End of taxonomy check.  HIT ENTER" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 Q
PAGE ;
 I $E(IOST)="C",IO=IO(0) W ! S DIR(0)="EO" D ^DIR K DIR I Y=0!(Y="^")!($D(DTOUT)) S BDWQUIT="" Q
 Q
TAXS ;
 ;;DM AUDIT DIET EDUC TOPICS;;Diabetes Diet Education Topics
 ;;DM AUDIT ACE INHIBITORS;;ACE Inhibitor Drug Taxonomy
 ;;
LAB ;
 ;;DM AUDIT URINE PROTEIN TAX;;Urine Protein Lab Taxonomy
 ;;DM AUDIT MICROALBUMINURIA TAX;;Microalbuminuia Lab Taxonomy
 ;;DM AUDIT HGB A1C TAX;;HGB A1C Lab Taxonomy
 ;;DM AUDIT GLUCOSE TESTS TAX;;Glucose Tests Taxonomy
 ;;DM AUDIT LDL CHOLESTEROL TAX;;LDL Cholesterol Lab Taxonomy
 ;;DM AUDIT HDL TAX;;HDL Lab Taxonomy
 ;;DM AUDIT TRIGLYCERIDE TAX;;Triglyceride Lab Taxonomy
 ;;APCH FECAL OCCULT BLOOD
 ;;BDW PAP SMEAR LAB TESTS
 ;;BDW PSA TESTS TAX
 ;;
