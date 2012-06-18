BEXRRPH ;CMI/BJI/DAY - BEX - Refills Processed by RPHS Report ; 19 Nov 2009  10:57 AM [ 03/02/2010  11:13 AM ]
 ;;1.0;BEX TELEPHONE REFILL SYSTEM;**4**;DEC 01, 2009
 ;
 ;Prints the Refills Processed by RPH Report
 ;
 D ^XBCLS
 ;
 W !,"Refills Processed by RPH Report"
 W !
 W !,"This option prints a list of Transactions that were processed within"
 W !,"a selected date/time range."
 W !
 ;
 K BEXDIV
 S BEXDIV=0
 S BEXSITE=0
 S BEXQUIT=0
 ;
 W !,"Press Enter to select ALL Pharmacy Divisions, or"
 F  D  Q:BEXQUIT=1
 .K DIC,DIR,DIE,DA,DR,DO,DD
 .S DIC(0)="AEQMZ"
 .S DIC("A")="Select a Pharmacy Division: "
 .S DIC=59
 .D ^DIC
 .K DIC,DIE,DIR,DA,DD,DR,DO
 .I X="" S BEXQUIT=1 Q
 .I Y<0 S BEXQUIT=1 Q
 S BEXSITE=+Y
 .S BEXDIV=BEXDIV+1
 .S Y=$P($G(^PS(59,BEXSITE,"INI")),U)
 .I +Y S BEXDIV(Y)=""
 ;
 ;
 ;--------------------------------------------------------------------
BEGDATE ;EP - Come here if end date is before begin date
 ;--------------------------------------------------------------------
 ;
 W !
 K DIRUT
 K %DT
 S %DT("A")="Select the Beginning Date/Time: "
 S %DT="AET"
 D ^%DT
 K %DT
 I ($D(DIRUT))!(Y<0) W !!,"No Beginning Date selected" G EOJ
 S BEXBEG=Y
 ;
 W !
 K DIRUT
 K %DT
 S %DT("A")="Select the Ending Date/Time: "
 S %DT="AET"
 D ^%DT
 K %DT
 I ($D(DIRUT))!(Y<0) W !!,"No Ending Date selected" G EOJ
 S BEXEND=Y
 I $P(BEXEND,".",2)="" S BEXEND=BEXEND_".240000"
 ;
 I BEXBEG>BEXEND W !!,"Beginning Date is later than the Ending Date.  Try Again!",! G BEGDATE
 ;
 W !
 S XBRP="LIST^BEXRRPH"
 S XBRX="EOJ^BEXRRPH"
 S XBNS="BEX"
 D ^XBDBQUE
 Q
 ;
 ;
 ;---------------------------------------------------------------
EOJ ;EP - End of Job Processing
 ;---------------------------------------------------------------
 ;
 X ^%ZIS("C")
 I $E(IOST)="C" W ! K DIR S DIR(0)="E" D ^DIR K DIR
 K BEX
 D EN^XBVK("BEX")
 K DIR,DIE,DIC,DD,DA,DR
 Q
 ;
 ;
 ;---------------------------------------------------------------
LIST ;EP - Entry Point from XBDBQUE
 ;---------------------------------------------------------------
 ;
 ;
 D ^XBCLS
 D HEADER
 ;
 K BEXTOT
 S BEXTOT="0^0^0"
 ;
 S BEXQUIT=0
 S BEXEXIT=0
 ;
 ;Loop Date Xref to get totals and build sort array
 S BEXDATE=$O(^VEXHRX0(19080.1,"C",BEXBEG),-1)
 F  S BEXDATE=$O(^VEXHRX0(19080.1,"C",BEXDATE)) Q:'BEXDATE  D  Q:BEXQUIT=1
 .;
 .I BEXDATE>BEXEND S BEXQUIT=1 Q
 .;
 .;This loops around to some non-numeric dates
 .I +BEXDATE<BEXBEG S BEXQUIT=1 Q
 .;
 .S BEXIEN=0
 .F  S BEXIEN=$O(^VEXHRX0(19080.1,"C",BEXDATE,BEXIEN)) Q:'BEXIEN  D  Q:BEXQUIT=1
 ..;
 ..S BEX(0)=$G(^VEXHRX0(19080.1,BEXIEN,0))
 ..I BEX(0)="" Q
 ..;
 ..;Only want pharmacy type transactions
 ..I $P(BEX(0),U,4)'="P" Q
 ..D PARSE^BEXRUTL
 ..;
 ..;Screen by Division
 ..I +BEXDIV,BEXDVIEN="" Q
 ..I +BEXDIV,'$D(BEXDIV(BEXDVIEN)) Q
 ..D TOTAL
 ;
 ;
 S BEXQUIT=0
 ;
 ;Loop the sort array
 S BEXRPH=0
 F  S BEXRPH=$O(BEXTOT(BEXRPH)) Q:'BEXRPH  D  Q:BEXQUIT=1  Q:BEXEXIT=1
 .;
 .D SUBHEAD
 .;
 .S BEXDAT=0
 .F  S BEXDAT=$O(BEXTOT(BEXRPH,BEXDAT)) Q:'BEXDAT  D  Q:BEXQUIT=1  Q:BEXEXIT=1
 ..;
 ..D DETAIL
 .;
 .W "TOTAL"
 .W ?18,$J($P(BEXTOT(BEXRPH),U),7)
 .W ?36,$J($P(BEXTOT(BEXRPH),U,2),7)
 .W ?53,$J($P(BEXTOT(BEXRPH),U,3),7)
 .W !
 ;
 ;
 ;Write Totals
 ;
 W !,?21,"MAIL",?37,"WINDOW",?55,"TOTAL"
 W !,"GRAND TOTAL",?18,$J($P(BEXTOT,U),7)
 W ?36,$J($P(BEXTOT,U,2),7)
 W ?53,$J($P(BEXTOT,U,3),7)
 W !
 ;
 Q
 ;
 ;
 ;---------------------------------------------------------------
HEADER ;EP - Write the Header
 ;---------------------------------------------------------------
 ;
 D ^XBCLS
 W !,"REPORT:      Refills Processed by RPH Report"
 W " for "
 I +BEXSITE W $$GET1^DIQ(59,BEXSITE,.01)
 I +BEXSITE=0 W "all Divisions"
 W !,"DATE RUN:    " S Y=DT X ^DD("DD") W Y
 W !,"PARAMETERS:  "
 ;
 W "Between "
 S Y=BEXBEG
 W $E(Y,4,5),"/",$E(Y,6,7),"/",$E(Y,2,3)
 X ^DD("DD")
 W "@"
 I $P(Y,"@",2)]"" W $E($P(Y,"@",2),1,5)
 I $P(Y,"@",2)="" W "00:00"
 ;
 W " and "
 S Y=BEXEND
 W $E(Y,4,5),"/",$E(Y,6,7),"/",$E(Y,2,3)
 X ^DD("DD")
 W "@"
 I $P(Y,"@",2)]"" W $E($P(Y,"@",2),1,5)
 I $P(Y,"@",2)="" W "00:00"
 ;
 W !
 W "-------------------------------------------------------------------------------"
 W !
 ;
 Q
 ;
 ;
 ;-----------------------------------------------------------------
SUBHEAD ;EP - Write Subheader for each pharmacist
 ;-----------------------------------------------------------------
 ;
 W !
 W "-------------------------------------------------------------------------------"
 W !
 ;
 W $$GET1^DIQ(200,BEXRPH,.01)
 ;
 W !
 W "-------------------------------------------------------------------------------"
 W !
 ;
 Q
 ;
 ;
 ;-----------------------------------------------------------------
TOTAL ;EP -  Add up totals and build sort array
 ;-----------------------------------------------------------------
 ;
 I BEXRPH="" Q
 ;
 S $P(BEXTOT,U,3)=$P(BEXTOT,U,3)+1
 ;
 ;Initialize Total Counter for this Pharmacist
 I '$D(BEXTOT(BEXRPH)) S BEXTOT(BEXRPH)="0^0^0"
 ;
 ;Add to Total Counter for this Pharmacist
 S $P(BEXTOT(BEXRPH),U,3)=$P(BEXTOT(BEXRPH),U,3)+1
 ;
 ;Initialize Date Counter for this Pharmacist
 I '$D(BEXTOT(BEXRPH,BEXDAT)) S BEXTOT(BEXRPH,BEXDAT)="0^0^0"
 ;
 ;Add to Date Counter for this Pharmacist
 S $P(BEXTOT(BEXRPH,BEXDAT),U,3)=$P(BEXTOT(BEXRPH,BEXDAT),U,3)+1
 ;
 ;Check for Mail/Window
 I $G(BEXMLWIN)="M" D
 .S $P(BEXTOT(BEXRPH),U)=$P(BEXTOT(BEXRPH),U)+1
 .S $P(BEXTOT(BEXRPH,BEXDAT),U)=$P(BEXTOT(BEXRPH,BEXDAT),U)+1
 .S $P(BEXTOT,U)=$P(BEXTOT,U)+1
 ;
 I $G(BEXMLWIN)="W" D
 .S $P(BEXTOT(BEXRPH),U,2)=$P(BEXTOT(BEXRPH),U,2)+1
 .S $P(BEXTOT(BEXRPH,BEXDAT),U,2)=$P(BEXTOT(BEXRPH,BEXDAT),U,2)+1
 .S $P(BEXTOT,U,2)=$P(BEXTOT,U,2)+1
 ;
 Q
 ;
 ;
 ;-----------------------------------------------------------------
DETAIL ;EP - Write Detail
 ;-----------------------------------------------------------------
 ;
 ;-->  Let's write out the record detail
 ;
 S Y=BEXDAT
 W $E(Y,4,5),"/",$E(Y,6,7),"/",$E(Y,2,3)
 ;
 W ?14,"MAIL"
 W $J($P(BEXTOT(BEXRPH,BEXDAT),U),7)
 W ?30,"WINDOW"
 W $J($P(BEXTOT(BEXRPH,BEXDAT),U,2),7)
 W ?48,"TOTAL"
 W $J($P(BEXTOT(BEXRPH,BEXDAT),U,3),7)
 W !
 ;
 I $Y>(IOSL-7) D
 .I $E(IOST)="C" K DIR S DIR(0)="E" D ^DIR S:X="^" BEXEXIT=1 K DIR
 .I X="^" S BEXQUIT=1 Q
 .D HEADER
 ;
 Q
 ;
