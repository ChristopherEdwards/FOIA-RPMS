ACDVSAVE ;IHS/ADC/EDE/KML - EXTRACT VISIT DATA; 
 ;;4.1;CHEMICAL DEPENDENCY MIS;;MAY 11, 1998
 ;
 ;
EN ;EP
 ;//[ACD RE-EXT]
 ;Options locked
 D EN^ACDGLOCK
 ;
 ;Chk for incomplete import.
 I $D(^ACDV1TMP) W !!,*7,*7,"Data still exists in the ^ACDV1TMP global due to a",!,"CORRUPT LOCATION FILE.  * I MUST STOP *" D K Q
 ;
 ;
 I $D(^ACDVTMP) W !!,*7,*7,"An extract is presently running." D K Q
 K ^ACDVTMP ;       kill of scratch global  SAC EXEMPTION (2.3.2.3  killing of unsubscripted globals is prohibited)
 ;
 W !!,*7,*7,"Once a CDMIS DATA RECORD is extracted,",!,"the record may NOT be 'DELETED' or 'EDITED'."
 ;
 D EN1^ACDV4MES
 I $E(ACD6DIG)="9" W !!,"OK, Headquarters is Archiving",!!,"Be sure to delete the data when the archive is finished."
 ;
D ;Ask start/stop date
 K ACDQUIT D D^ACDWRQ I $D(ACDQUIT) D K Q
 S ACDDTF=ACDFR,ACDDTT=ACDTO
 ;
 W !!,"Extracting all CDMIS visit/prevention data",!,"from: ",$$DD^ACDFUNC(ACDFR)," through: ",$$DD^ACDFUNC(ACDTO)
 ;
 ;
T ;Ask transmission mode
 ; commented out net mail option per Wilbur Woodis
 ;K ACDMAIL S DIR(0)="S^1:TRANSMIT DATA VIA HOST OS FILE;2:TRANSMIT DATA VIA NET MAIL" D ^DIR G:X["^"!($D(DTOUT)!(X="")) K
 ;I Y=2 S ACDMAIL=1 D
 ;.I '$O(^ACDOMAIN(DUZ(2),1,0)) W !!,*7,*7,"You must set domains to send extracted data to." D EN^ACDSRV3
 ;.S ACDSRVOP=2 D DOM^ACDSRV3 I '$D(XMY) W !!,*7,*7,"No domains are defined to send the extraction data to.",!,"I cannot continue because of this." S ACDQUIT=1
 ;I $D(ACDQUIT) D K Q
 F  W !!,"OK to continue" S %=2 D YN^DICN W:%=0 "  Answer Yes or No" G:%'=1&(%'=0) K Q:%=1
 ;
 ;Clean up incomplete entries prior to extracting data.
 D EN^ACDCLN
 ;
 ;Get backfilled data to export
 S X1=ACDFR,X2=-600 D C^%DTC S ACDFR=X
 ;
 W !!,"Looking for visit data to extract....."
 ;
VIS ;Get visits
 F ACD=ACDFR-.01:0 S ACD=$O(^ACDVIS("B",ACD)) Q:'ACD!(ACD>ACDTO)  F ACDV=0:0 S ACDV=$O(^ACDVIS("B",ACD,ACDV)) Q:'ACDV  D V D:ACDVHIT L W "."
 D CLN
 ;
 ;Get preventions
 W !!,"Looking for prevention data to extract....."
 F ACD=ACDFR-.01:0 S ACD=$O(^ACDPD("B",ACD)) Q:'ACD!(ACD>ACDTO)  F ACDV=0:0 S ACDV=$O(^ACDPD("B",ACD,ACDV)) Q:'ACDV  I $D(^ACDPD(ACDV,0)) D P
 ;
 ;Create host file
 I '$D(^ACDVTMP) W !!,"No new data found." G K
 I '$D(ACDMAIL) S XBGL="ACDVTMP",$P(^ACDVTMP(0),U)=ACDDTT,$P(^(0),U,2)=ACDDTF,$P(^(0),U,20)="IMPORT FILE" D ^ACDGX5
 ;Use net mail
 I $D(ACDMAIL) D ^ACDVSRV0
 ;
 W !!,"Now deleting the ^ACDVTMP global....."
 K ^ACDVTMP ;       kill of scratch global  SAC EXEMPTION (2.3.2.3  KILLING of unsubscripted globals is prohibited)
 W !,"CDMIS data extraction successfully completed."
 D PAUSE^ACDDEU
 G K
 ;
L ;Get visit link file
 F ACDDA=0:0 S ACDDA=$O(^ACDIIF("C",ACDV,ACDDA)) Q:'ACDDA  I $D(^ACDIIF(ACDDA,0)) D IIF
 F ACDDA=0:0 S ACDDA=$O(^ACDTDC("C",ACDV,ACDDA)) Q:'ACDDA  I $D(^ACDTDC(ACDDA,0)) D TDC
 F ACDDA=0:0 S ACDDA=$O(^ACDCS("C",ACDV,ACDDA)) Q:'ACDDA  I $D(^ACDCS(ACDDA,0)) D CS
 Q
 ;
IIF ;Bld node
 I $P(^ACDIIF(ACDDA,0),U,25) Q
 I '$D(^ACDVTMP(ACDUSER,ACDV,"V")) Q
 S ACD("IIF")=^ACDIIF(ACDDA,0)
 S ^ACDVTMP(ACDUSER,ACDV,"IIF",ACDDA)=ACD("IIF")
 F ACDRUG=0:0 S ACDRUG=$O(^ACDIIF(ACDDA,2,ACDRUG)) Q:'ACDRUG  I $D(^(ACDRUG,0)) S ACDPOINT=^(0) S ^ACDVTMP(ACDUSER,ACDV,"IIF",ACDDA,"DRUG",ACDPOINT)=ACDPOINT
 F ACDSCND=0:0 S ACDSCND=$O(^ACDIIF(ACDDA,3,ACDSCND)) Q:'ACDSCND  I $D(^(ACDSCND,0)) S ACDPOINT=^(0) S ^ACDVTMP(ACDUSER,ACDV,"IIF",ACDDA,"SECPROB",ACDPOINT)=ACDPOINT
 S DIE="^ACDIIF(",DA=ACDDA,DR="25///T" D DIE^ACDFMC
 Q
TDC ;Bld node
 I $P(^ACDTDC(ACDDA,0),U,25) Q
 I '$D(^ACDVTMP(ACDUSER,ACDV,"V")) Q
 S ACD("TDC")=^ACDTDC(ACDDA,0)
 S ^ACDVTMP(ACDUSER,ACDV,"TDC",ACDDA)=ACD("TDC")
 F ACDRUG=0:0 S ACDRUG=$O(^ACDTDC(ACDDA,2,ACDRUG)) Q:'ACDRUG  I $D(^(ACDRUG,0)) S ACDPOINT=^(0) S ^ACDVTMP(ACDUSER,ACDV,"TDC",ACDDA,"DRUG",ACDPOINT)=ACDPOINT
 F ACDSCND=0:0 S ACDSCND=$O(^ACDTDC(ACDDA,3,ACDSCND)) Q:'ACDSCND  I $D(^(ACDSCND,0)) S ACDPOINT=^(0) S ^ACDVTMP(ACDUSER,ACDV,"TDC",ACDDA,"SECPROB",ACDPOINT)=ACDPOINT
 S DIE="^ACDTDC(",DA=ACDDA,DR="25///T" D DIE^ACDFMC
 Q
CS ;Bld node
 I $P(^ACDCS(ACDDA,0),U,5) Q
 I '$D(^ACDVTMP(ACDUSER,ACDV,"V")) Q
 S ACD("CS")=^ACDCS(ACDDA,0)
 S ^ACDVTMP(ACDUSER,ACDV,"CS",ACDDA)=ACD("CS")
 S DIE="^ACDCS(",DA=ACDDA,DR="5///T" D DIE^ACDFMC
 Q
P ;Bld node
 S ACD("P")=^ACDPD(ACDV,0)
 Q:ACDPGM'=$P(ACD("P"),U,4)  ;  quit if not signon site
 ;S ACDBWP=$P(ACD("P"),U,4),ACDBWP=$P(^ACDF5PI(ACDBWP,0),U),ACDBWP=$P(^AUTTLOC(ACDBWP,0),U),ACD6PGM=$P(^AUTTLOC(ACDBWP,0),U,10)
 S ACDBWP=$P(ACD("P"),U,4),ACDBWP=$P(^AUTTLOC(ACDBWP,0),U),ACD6PGM=$P(^AUTTLOC(ACDBWP,0),U,10)
 S ACDUSER=$P(^AUTTLOC($P(^AUTTSITE(1,0),U),0),U,10)_"*"_ACD6PGM
 I $P(^ACDPD(ACDV,0),U,25) Q
 S ^ACDVTMP(ACDUSER,ACDV,"P")=ACD("P")
 F ACDAY=0:0 S ACDAY=$O(^ACDPD(ACDV,1,ACDAY)) Q:'ACDAY  I $D(^(ACDAY,0)) S ACD("P")=^(0),^ACDVTMP(ACDUSER,ACDV,"P","DAY",ACDAY)=ACD("P")
 S DIE="^ACDPD(",DA=ACDV,DR="25///T" D DIE^ACDFMC
 W "."
 Q
V ;V node
 D V^ACDVSAV2
 Q
CLN ;Make pass to clean incomplete entries
 D CLN^ACDVSAV2
 Q
K ;
 ;Unlock options
 D EN1^ACDGLOCK
 K ACDDTF,ACDDTT
 K ACDV,ACDUSER,ACDBWP,ACDDA,ACDFR,ACDTO,ACD,ACDDRUG,ACD6PGM,ACDRUG,ACDTIME,ACDPOINT
 K ACDSCND ;          3-31-95 EDE
 Q
