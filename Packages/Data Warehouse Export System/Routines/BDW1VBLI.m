BDW1VBLI ;IHS/CMI/LAB - Initialization for DW Visit backloading;
 ;;1.0;IHS DATA WAREHOUSE;**2**;JAN 23, 2006
 ;
START ;
 W !,"This routine will generate IHS Data Warehouse HL7 messages"
 W !,"for the purpose of backloading the data warehouse with several years worth",!,"of encounter data.",!
 W !,"Due to the time it takes to process encounters for export it is suggested that",!,"you do the export in increments.  For example, you can export 6 months worth",!,"of encounters each day until you are done.",!
 ;
 D BASICS ;      Set variables like U,DT,DUZ(2) etc.
 D CHKSITE ;     Make sure Site file has correct fields.
 Q:BDW("QFLG")
 D GETLOG
 Q:BDW("QFLG")
 D VAUDIT
 D GENLOG
 D GIS
 ;
 D QUEUE
 Q
 ;
VAUDIT ;
 S BDWVA=1 Q  ;always create on backload per Lisa P. 5-5-04
 S BDWVA=""
 S DIR(0)="Y",DIR("A")="Do you want to create an ENCOUNTER AUDIT report for this batch of encounters",DIR("B")="N" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) Q
 I Y S BDWVA=1
 Q
GIS ;EP-- check background jobs for gis
 W:'$D(ZTQUEUED) !!,"Checking GIS Background Jobs..."
 N BDWGISI
 F BDWGISI="FORMAT CONTROLLER" D
 . N BDWGISS
 . S BDWGISS=$$CHK^BHLBCK(BDWGISI,0)
 Q
 ;
GETLOG ;
 W !,"Encounters from October 1, 2000 through ",$$FMTE^XLFDT($P(^BDWSITE(1,0),U,2))," will be exported",!,"to the Data Warehouse before you can begin the normal data warehouse",!,"export process."
 W "  This site has approximately ",$P(^BDWSITE(1,0),U,5)," encounters to export ",!,"via this special export process."
 I '$O(^BDWBLOG(0)) D
 .W !!,"This is the first backload run.  The beginning date for this run is 10/01/2000.",!
 I $O(^BDWBLOG(0)) D
 .W !!,"Thus far, you have backloaded the following encounters:"
 .W !,"LOG",?6,"BEG DATE",?30,"END DATE",?55,"# ENCS",?67,"ELAPSED TIME"
 .S (T,BDWX)=0 F  S BDWX=$O(^BDWBLOG(BDWX)) Q:BDWX'=+BDWX  S BDWY=^BDWBLOG(BDWX,0) D
 ..W !,BDWX,?6,$$FMTE^XLFDT($P(BDWY,U,1)),?30,$$FMTE^XLFDT($P(BDWY,U,2)),?55,$P(BDWY,U,18),?67,$P(BDWY,U,13) S T=T+$P(BDWY,U,18)
 .W !,"You have approximately ",($P(^BDWSITE(1,0),U,5)-T)," encounters left to export to complete",!,"the backloading process.",!
 .;get last log entry
 D GETLAST
 Q:BDW("QFLG")
 ;
 ;get data for this run
 D D
 Q
GETLAST ;
 S (X,BDW("LAST LOG"))=0 F  S X=$O(^BDWBLOG(X)) Q:X'=+X  S BDW("LAST LOG")=X
 I 'BDW("LAST LOG") S BDWBIEN=0,BDW("RUN BEGIN")=3001001 Q
 I $P(^BDWBLOG(BDW("LAST LOG"),0),U,15)="C" D  Q
 .S BDW("RUN BEGIN")=$P(^BDWBLOG(BDW("LAST LOG"),0),U,2),BDW("RUN BEGIN")=$$FMADD^XLFDT(BDW("RUN BEGIN"),1)
 D ERROR
 Q
ERROR ;
 S BDW("QFLG")=12
 S BDW("PREV STATUS")=$P(^BDWBLOG(BDW("LAST LOG"),0),U,15)
 I BDW("PREV STATUS")="" D EERR Q
 D @(BDW("PREV STATUS")_"ERR") Q
 Q
EERR ;
 S BDW("QFLG")=13
 W $C(7),$C(7),!!,"*****ERROR ENCOUNTERED*****",!,"The last DW DW never successfully completed to end of job!!!",!,"This must be resolved before any other exports can be done.",!
 Q
RERR ;
 S BDW("QFLG")=15
 W $C(7),$C(7),!!,"Data Warehouse Export is currently running!!"
 Q
QERR ;
 S BDW("QFLG")=16
 W !!,$C(7),$C(7),"Data Warehouse Export is already queued to run!!"
 Q
 ;
D ;
 S DIR(0)="D^:"_$P(^BDWSITE(1,0),U,2)_":EP",DIR("A")="Export encounters from "_$$FMTE^XLFDT(BDW("RUN BEGIN"))_" to what ending date" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) S BDW("QFLG")=7 Q
 S BDW("RUN END")=Y
 Q
BASICS ;EP BASIC INITS
 D HOME^%ZIS S BDWBS=$S('$D(ZTQUEUED):IOBS,1:"")
 K BDW,BDWS,BDWV,BDWT,BDWE,BDWERRC
 S BDW("RUN LOCATION")=$P(^AUTTLOC(DUZ(2),0),U,10),BDW("QFLG")=0
 I $P($G(^BDWSITE(1,11)),U) S BDW("DNS")=1
 S APCDOVRR=1 ; Allow VISIT lookup with 0 'dependent entry count'.
 S (BDW("SKIP"),BDW("TXS"),BDW("VPROC"),BDW("COUNT"),BDW("VISITS"),BDWERRC,BDW("REG"),BDW("DEMO"),BDW("ZERO"),BDW("DEL"),BDW("NO PAT"),BDW("NO LOC"),BDW("NO TYPE"),BDW("NO CAT"),BDW("MFI"),BDWVA("COUNT"))=0
 S BDWIEDST=$O(^INRHD("B","HL IHS DW1 IE",0))
 D TAXCHK
 Q
 ;
CHKSITE ;EP
 I $D(^XTMP("BDWBLOG")) W:'$D(ZTQUEUED) !!,"** XTMP Nodes exist from previous run" S BDW("QFLG")=1 Q
 I '$D(^AUTTSITE(1,0)) W:'$D(ZTQUEUED) !!,"*** RPMS SITE FILE has not been set up! ***" S BDW("QFLG")=1 Q
 I $P(^AUTTLOC($P(^AUTTSITE(1,0),U),0),U,10)="" W:'$D(ZTQUEUED) !!,"No ASUFAC for facility in RPMS Site file!!" S BDW("QFLG")=1 Q
 I '$D(^BDWSITE(1,0)) W:'$D(ZTQUEUED) !!,"*** Site file has not been setup! ***" S BDW("QFLG")=1 Q
 I $P(^BDWSITE(1,0),U)'=DUZ(2) W:'$D(ZTQUEUED) !!,"*** RUN LOCATION not in SITE file!" S BDW("QFLG")=2 Q
 I $P(^BDWSITE(1,0),U,4)="" D
 .W:'$D(ZTQUEUED) !!,"*** The Full Patient registration DW export has not been completed."
 .W !,"Cannot continue.",!,"Please complete option 'Data Warehouse Full Registration Export'",!,"before you begin the encounter backload.",! S BDW("QFLG")=3 Q
 Q
QUEUE ;EP
 K ZTSK
 S DIR(0)="Y",DIR("A")="Do you want to QUEUE this to run at a later time",DIR("B")="N" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I Y=1 D QUEUE1 Q
 I $D(DIRUT) S BDW("QFLG")=99 S DA=BDW("RUN LOG"),DIK="^BDWBLOG(" W !,"Okay, you '^'ed out or timed out so I'm deleting the Log entry and quitting.",! D ^DIK K DIK,DA
 Q
QUEUE1 ;
 S ZTRTN="DRIVER^BDW1VBL"
 S ZTIO="",ZTDTH="",ZTDESC="DW DATA WAREHOUSE DATA TRANSMISSION" S ZTSAVE("BDW*")="",ZTSAVE("APCD*")=""
 D ^%ZTLOAD
 W !!,$S($D(ZTSK):"Request Queued!!",1:"Request cancelled")
 I '$D(ZTSK) S BDW("QFLG")=99 S DA=BDW("RUN LOG"),DIK="^BDWBLOG(" W !,"Okay, you '^'ed out or timed out so I'm deleting the Log entry and quitting.",! D ^DIK K DIK,DA Q
 S BDWO("QUEUE")=""
 S DIE="^BDWBLOG(",DA=BDW("RUN LOG"),DR=".15///Q" D ^DIE K DIE,DA,DR
 K ZTSK
 Q
TAXCHK ;EP
 K BDWQUIT
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
 I '$D(A) K A,BDWX,Y,I,Z Q
 W !!,"In order for the Data Warehouse software to find all necessary data, several",!,"taxonomies must be established.  The following taxonomies are missing or have",!,"no entries:"
 S BDWX="" F  S BDWX=$O(A(BDWX)) Q:BDWX=""!($D(BDWQUIT))  D
 .I $Y>(IOSL-2) D PAGE Q:$D(BDWQUIT)
 .W !,$P(A(BDWX),U)," [",BDWX,"] ",$P(A(BDWX),U,2)
 .Q
DONE ;
 I $E(IOST)="C",IO=IO(0) S DIR(0)="EO",DIR("A")="End of taxonomy check.  Press ENTER" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 Q
WRITE() ;EP use XBGSAVE to save the temp global (BDWDATA) to a delimited
 ; file that is exported to the DW system at 127.0.0.1
 ;
 N XBGL,XBQ,XBQTO,XBNAR,XBMED,XBFLT,XBUF,XBFN
 N BDWASU,BDWJUL,DT,X2,X1,X
 S BDWVA("COUNT")=BDWVA("COUNT")+1,^BDWDATA(BDWVA("COUNT"))="T0^"_$P($$DATE^INHUT($$NOW^XLFDT,1),"-")
 S XBGL="BDWDATA",XBMED="F",XBQ="N",XBFLT=1
 S XBNAR="DW Encounter Audit"
 I '$D(DT) D DT^DICRW     ;get julian date for file name
 S X2=$E(DT,1,3)_"0101",X1=DT
 D ^%DTC
 S BDWJUL=X+1
 S BDWASU=$P($G(^AUTTLOC($P(^AUTTSITE(1,0),U),0)),U,10)  ;asufac for file name
 S XBFN="BDWDWVX"_BDWASU_"."_BDW("RUN LOG")
 NEW DA,DIE,DR
 S DA=BDW("RUN LOG"),DIE="^BDWBLOG(",DR=".21///"_XBFN D ^DIE K DA,DIE,DR
 ;S XBUF="/usr3/dsd/ljara/"  ;used in testing to make it fail
 ;S XBQTO="-l dwxfer:regpcc 127.0.0.1"
 S XBS1="DATA WAREHOUSE SEND"
 D ^XBGSAVE
 ;
 I XBFLG=0 D
 . W:'$D(ZTQUEUED) !,"Encounter audit file successfully created and transferred.",!!
 . K ^BDWDATA
 ;
 I XBFLG'=0 D
 . I XBFLG(1)="" W:'$D(ZTQUEUED) !!,"VISIT audit file successfully created",!! K ^BDWDATA
 . I XBFLG(1)]"" W:'$D(ZTQUEUED) !!,"VISIT audit file NOT successfully created",!!
 . W:'$D(ZTQUEUED) !,"File was NOT successfully transferred to the data warehouse",!,"you will need to manually ftp it.",!
 . W:'$D(ZTQUEUED) !,XBFLG(1),!!
 ;
 ;
 Q XBFLG
GENLOG ;
 D ^XBFMK
 K DD,D0,DO
 S X=BDW("RUN BEGIN"),DIC(0)="L",DIADD=1,DLAYGO=90214,DIC="^BDWBLOG(",DIC("DR")=".02////"_BDW("RUN END")_";.09////"_DUZ(2)_";8801////"_DUZ_";.23///EBL" D FILE^DICN
 K DIADD,DLAYGO,DIC,DD,DO,D0
 I Y=-1 W !!,"Error generating new log entry." S BDW("QFLG")=8 D ^XBFMK Q
 S BDW("RUN LOG")=+Y
 D ^XBFMK
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
