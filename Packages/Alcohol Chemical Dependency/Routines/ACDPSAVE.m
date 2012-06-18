ACDPSAVE ;IHS/ADC/EDE/KML - EXTRACT PROGRAM DATA TO A HOST FILE OR MAIL SERVER; 
 ;;4.1;CHEMICAL DEPENDENCY MIS;;MAY 11, 1998
 ;
EN ;EP
 ;//[ACD SUPER8]
 ;
 D EN5^ACDV4MES
 ;
 ;Chk for incomplete import.
 I $D(^ACDP1TMP) W !!,*7,*7,"A data import still exists in the ^ACDPTMP global due to a",!,"CORRUPT LOCATION FILE  ** I MUST STOP **" D K Q
 ;
 ;Initialize ^ACDPTMP
 I $D(^ACDPTMP) W !!,*7,*7,"It seems an extract is presently running." D K Q
 K ^ACDPTMP ;      kill of scratch global  SAC EXEMPTION (2.3.2.3  killing of unsubscripted globals is prohibited)
 ;
 ;Ask transmission mode
 ; commented out net mail option per Wilbur Woodis
 ;K ACDMAIL S DIR(0)="S^1:TRANSMIT DATA VIA UNIX FILE;2:TRANSMIT DATA VIA NET MAIL" D ^DIR G:X["^"!($D(DTOUT)!(X="")) K
 ;I Y=2 S ACDMAIL=1 D
 ;.I '$O(^ACDOMAIN(DUZ(2),1,0)) W !!,*7,*7,"You must set domains to send extracted data to." D EN^ACDSRV3
 ;.S ACDSRVOP=1 D DOM^ACDSRV3 I '$D(XMY) W !!,*7,*7,"No domains are defined to send the extraction data to.",!,"I cannot continue because of this." S ACDQUIT=1
 ;I $D(ACDQUIT) D K Q
 F  W !!,"OK to continue" S %=2 D YN^DICN W:%=0 "  Answer Yes or No" G:%'=1&(%'=0) K Q:%=1
 F ACDA=0:0 S ACDA=$O(^ACDQAN(ACDA)) Q:'ACDA  D
 .;
 .S ACD6PGM=$P(^AUTTLOC(ACDA,0),U,10)
 .S ACDUSER=$P(^AUTTLOC($P(^AUTTSITE(1,0),U),0),U,10)_"*"_ACD6PGM
 .S %X="^ACDQAN("_ACDA_","
 .S %Y="^ACDPTMP("""_ACDUSER_""","
 .;
 .D %XY^%RCR
 ;
 ;
 ;Create host file
 I '$D(^ACDPTMP) W !!,"No new data found." G K
 I '$D(ACDMAIL) S $P(^ACDPTMP(0),U)="PROGRAM DATA",$P(^(0),U,2)="PROGRAM DATA",$P(^(0),U,20)="IMPORT FILE",XBGL="ACDPTMP" D EN^ACDGX5
 ;Use net mail
 I $D(ACDMAIL) S (ACDFR,ACDTO)="PROGRAM DATA" D ^ACDPSRV0
 ;
 W !!,"Now deleting the ^ACDPTMP global....."
 K ^ACDPTMP ;       kill of scratch global  SAC EXEMPTION (2.3.2.3  killing of unsubscripted globals is prohibited)
 W !,"CDMIS data extraction successfully completed."
K ;
 K ACDV,ACDUSER,ACDBWP,ACDDA,ACDFR,ACDTO,ACD,ACDDRUG,ACD6PGM,ACDRUG,ACDTIME,ACDPOINT,X,Y,DIE,DIC,DIK,ACDA,DIR
