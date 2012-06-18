BARRERL2 ; IHS/SD/LSL - Print Synch Reports ;
 ;;1.8;IHS ACCOUNTS RECEIVABLE;**4,6**;OCT 26, 2005
 ;
 ; IHS/ASDS/LSL - 06/19/2001 - V1.5 Patch 1 - NOIS BXX-0501-150074
 ;     Modified to correct the display of dollar amounts.
 ;
 ; IHS/SD/LSL - 12/06/02 - V1.7 - NOIS NHA-0601-180049
 ;     Modified to find bill in 3PB properly
 ;
 ; IHS/SD/SDR - v1.8 p6 - DD 4.1.3
 ;   Remove Negative Balance report and make it stand-alone report
 ;
 ; *********************************************************************
 ;
RR ;EP - re-roll
 D ^BARRERL  ;BAR*1.8*4
 D RCHK
 Q:'$G(BAROK)
 S BARHDR="RE-ROLL"
 S BARXRF="ARR"
 D DEV
 Q
 ; *********************************************************************
 ;
SB ;EP - small balance
 D ^BARRERL  ;BAR*1.8*4
 D RCHK Q:'BAROK
 S BARHDR="SMALL BALANCE"
 S BARXRF="ASBL"
 D DEV
 Q
 ; *********************************************************************
 ;
 ;start old code bar*1.8*6 DD 4.1.3
NB ;EP - negative balance      
 D ^BARRERL  ;BAR*1.8*4
 D RCHK
 Q:'BAROK
 S BARHDR="NEGATIVE BALANCE"
 S BARXRF="ANEG"
 D DEV
 Q
 ;end old code DD 4.1.3
 ; *********************************************************************
 ;
MM ;EP - 3p - a/r mis-matches
 D ^BARRERL  ;BAR*1.8*4
 D RCHK
 Q:'BAROK
 S BARHDR="3P - A/R MISMATCH"
 S BARXRF="AMM"
 D DEV
 Q
 ; *********************************************************************
 ;
IEN ;EP - 3P ien wrong
 D ^BARRERL  ;BAR*1.8*4
 D RCHK
 Q:'BAROK
 S BARHDR="A/R MISSING 3P BILL"
 S BARXRF="AIEN"
 D DEV
 Q
 ; *********************************************************************
 ;
RCHK ;check for error run
 S BAROK=0
 I $G(^BARBLER(DUZ(2),"RUNNING")) D  Q
 .W !!,"A/R Bill File Error Scan is currently running. The scan"
 .W !,"must complete before printing lists.",!
 .D EOP^BARUTL(1)
 I '$G(^BARBLER(DUZ(2),"LASTRUN")) D  Q
 .W !!,"You need to run the 'Bill File Error Scan' option before printing any reports.",!
 .D EOP^BARUTL(1)
 S BAROK=1
 Q
 ; *********************************************************************
 ;
DEV ;select device
 W !
 S %ZIS="NQ"
 D ^%ZIS
 Q:POP
 I IO'=IO(0) D  Q
 .S ZTRTN="LNP^BARRERL2"
 .N I
 .F I="BARHDR","BARXRF" S ZTSAVE(I)=""
 .S ZTDESC="A/R - 3P SYNCH REPORTS"
 .D ^%ZTLOAD
 .W:$G(ZTSK) !,"Task # ",ZTSK," queued.",!
 .D HOME^%ZIS
 I $D(IO("S")) D
 .S IOP=ION
 .D ^%ZIS
 D LNP
 K BARQUIT
 Q
 ; *********************************************************************
 ;
LNP ;loop & print
 K BARQUIT
 S $P(BAREQ,"=",80)=""
 S $P(BARDSH,"-",80)=""
 S BARPG=0
 D HDR
 S DA=0
 F  S DA=$O(^BARBLER(DUZ(2),BARXRF,1,DA)) Q:'DA!($G(BARQUIT))  D
 . S Y=1
 .I $Y+5>IOSL D
 ..D EOP^BARUTL(0)
 ..I '+Y S BARQUIT=1 Q
 ..D HDR
 .Q:$G(BARQUIT)
 .K BAR
 .S DIC="^BARBL(DUZ(2),"
 .S DIQ="BAR("
 .S DIQ(0)="IE"
 .S DR=".01;3;13;15;17;22;101;102;108"
 .D EN^DIQ1
 .W !,"AR",?5,DA
 .W ?11,$P(BAR(90050.01,DA,.01,"E"),"-",1)
 .W ?20,$E(BAR(90050.01,DA,101,"E"),1,20)
 .W ?41,$$SDT^BARDUTL(BAR(90050.01,DA,102,"I"))
 .W ?52,$E(BAR(90050.01,DA,3,"E"),1,10)
 .I BARXRF="ASBL"!(BARXRF="ANEG") D
 ..W ?69,$J($FN(+$G(BAR(90050.01,DA,15,"I")),",",3),10)
 .E  D
 ..W ?69,$J($FN(BAR(90050.01,DA,13,"I"),",",2),10)
 .Q:BARXRF'="AMM"
 . S BAR("3P LOC")=$$FIND3PB^BARUTL(DUZ(2),DA)
 . Q:BAR("3P LOC")=""
 . S BAR3PDUZ=$P(BAR("3P LOC"),",")
 . S BAR3PIEN=$P(BAR("3P LOC"),",",2)
 . N I
 . F I=0,2,7 S BAR3P(I)=$G(^ABMDBILL(BAR3PDUZ,BAR3PIEN,I))
 . W !,"3P",?5,BAR3PIEN
 .W ?11,$P(BAR3P(0),"^",1)
 .W ?20,$E($P($G(^DPT(+$P(BAR3P(0),"^",5),0)),"^",1),1,20)
 .W ?41,$$SDT^BARDUTL(+BAR3P(7))
 .W ?52,$E($P($G(^AUTNINS(+$P(BAR3P(0),"^",8),0)),"^",1),1,10)
 . W ?69,$J($FN(+BAR3P(2),",",2),10)
 .W !
 .K BAR3P
 W !!,"E N D   O F   R E P O R T",!!
 D EOP^BARUTL(1)
 W $$EN^BARVDF("IOF")
 K BARHDR,BARXRF,BAR,BAR3P
 I $D(IO("S")) D ^%ZISC
 Q
 ; *********************************************************************
 ;
HDR ;report header
 S BARPG=BARPG+1
 W $$EN^BARVDF("IOF")
 W !,$$MDT^BARDUTL(DT)
 W ?30,BARHDR
 W ?70,"Page: ",BARPG
 W !,BAREQ
 W !,?5,"IEN   BILL#",?20,"PATIENT",?41,"DOS",?52,"BILLED TO"
 I BARXRF="ASBL"!(BARXRF="ANEG") D  Q
 .W ?72,"BALANCE"
 .W !,BARDSH
 W ?69,"AMT BILLED"
 W !,BARDSH
 Q
