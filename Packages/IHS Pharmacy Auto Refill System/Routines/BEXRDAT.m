BEXRDAT ;CMI/BJI/DAY - BEX - Transactions by Date Report ; 21 Nov 2009  7:53 PM [ 03/02/2010  11:12 AM ]
 ;;1.0;BEX TELEPHONE REFILL SYSTEM;**4**;DEC 01, 2009
 ;
 ;Prints the Transactions by Date Report
 ;
 D ^XBCLS
 ;
 W !,"Transactions by Date Report"
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
 .K DIC,DIR,DIE,DA,DD,DR,DO
 .I X="" S BEXQUIT=1 Q
 .I Y<0 S BEXQUIT=1 Q
 .S BEXSITE=+Y
 .S BEXDIV=BEXDIV+1
 .S Y=$P($G(^PS(59,BEXSITE,"INI")),U)
 .I +Y S BEXDIV(Y)=""
 ;
 W !
 K DIR
 S DIR("B")="N"
 S DIR("A")="Do you want TOTALS only"
 S DIR(0)="Y"
 S DIR("?")="Answering NO will print detailed transactions"
 D ^DIR
 K DIR
 I Y=0 S BEXRTYPE="DETAIL"
 I Y=1 S BEXRTYPE="TOTALS"
 ;
 ;
 ;--------------------------------------------------------------------------
BEGDATE ;EP - Come here if end date is before begin date
 ;--------------------------------------------------------------------------
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
 I $P(BEXEND,".",2)="" S BEXEND=BEXEND_".24"
 ;
 I BEXBEG>BEXEND W !!,"Beginning Date is later than the Ending Date.  Try Again!",! G BEGDATE
 ;
 W !
 S XBRP="LIST^BEXRDAT"
 S XBRX="EOJ^BEXRDAT"
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
 I $E(IOST)="C",$G(BEXEXIT)'=1 W ! K DIR S DIR(0)="E" D ^DIR K DIR
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
 S BEXTOT=0
 K BEXSUM
 S BEXSUM="0^0^0^0^0^0^0"
 ;
 S BEXQUIT=0
 S BEXEXIT=0
 ;
 S BEXDATE=$O(^VEXHRX0(19080.1,"C",BEXBEG),-1)
 F  S BEXDATE=$O(^VEXHRX0(19080.1,"C",BEXDATE)) Q:'BEXDATE  D  Q:BEXQUIT=1  Q:BEXEXIT=1
 .;
 .I BEXDATE>BEXEND S BEXQUIT=1 Q
 .;
 .;This loops around to some non-numeric dates
 .I +BEXDATE<BEXBEG S BEXQUIT=1 Q
 .;
 .S BEXIEN=0
 .F  S BEXIEN=$O(^VEXHRX0(19080.1,"C",BEXDATE,BEXIEN)) Q:'BEXIEN  D  Q:BEXQUIT=1  Q:BEXEXIT=1
 ..;
 ..S BEX(0)=$G(^VEXHRX0(19080.1,BEXIEN,0))
 ..I BEX(0)="" Q
 ..;
 ..D PARSE^BEXRUTL
 ..;
 ..;Screen by Division
 ..I +BEXDIV,$G(BEXDVIEN)="" Q
 ..I +BEXDIV,'$D(BEXDIV(BEXDVIEN)) Q
 ..;
 ..D DETAIL
 ;
 ;Write Totals
 ;
 I BEXEXIT=1 Q
 ;
 I BEXTOT>0 D
 .W !
 .W "-------------------------------------------------------------------------------"
 .W !
 .W "TRANSACTION TOTALS by Date"
 .W !
 .W "-------------------------------------------------------------------------------"
 .W !
 ;
 S BEXDAT=""
 F  S BEXDAT=$O(BEXTOT(BEXDAT)) Q:'BEXDAT  D  Q:BEXEXIT=1
 .S X=BEXDAT
 .W $E(X,4,5),"/",$E(X,6,7)
 .W ?8,"REFILL: "
 .W $J($P(BEXTOT(BEXDAT),U),5)
 .W ?23,"STATUS: "
 .W $J($P(BEXTOT(BEXDAT),U,2),5)
 .W ?38,"PHARM: "
 .W $J($P(BEXTOT(BEXDAT),U,3),5)
 .;W ?52,"INFO: "
 .;W $J($P(BEXTOT(BEXDAT),U,4),5)
 .W ?52,"TOTAL: "
 .W $J($P(BEXTOT(BEXDAT),U,5),5)
 .W !
 .;
 .I $Y>(IOSL-4) D
 ..I $E(IOST)="C" K DIR S DIR(0)="E" D ^DIR S:X="^" BEXEXIT=1 K DIR
 ..I BEXEXIT=1 Q
 ..S BEXRTYPE="TOTALS"
 ..D HEADER
 ..W !
 ..W "-------------------------------------------------------------------------------"
 ..W !
 ..W "TRANSACTION TOTALS by Date"
 ..W !
 ..W "-------------------------------------------------------------------------------"
 ..W !
 ;
 I BEXTOT>0 D
 .W "TOTAL"
 .W ?14,$J($P(BEXSUM,U),7)
 .W ?29,$J($P(BEXSUM,U,2),7)
 .W ?43,$J($P(BEXSUM,U,3),7)
 .;W ?56,$J($P(BEXSUM,U,4),7)
 .W ?57,$J($P(BEXSUM,U,5),7)
 .W !
 ;
 I BEXEXIT=1 Q
 ;
 I BEXTOT>0 D
 .;
 .W !
 .W "-------------------------------------------------------------------------------"
 .W !
 .W "REFILL TOTALS by Originating Transaction Date"
 .W !
 .W "-------------------------------------------------------------------------------"
 .W !
 ;
 S BEXDAT=""
 F  S BEXDAT=$O(BEXTOT(BEXDAT)) Q:'BEXDAT  D  Q:BEXEXIT=1
 .S X=BEXDAT
 .W $E(X,4,5),"/",$E(X,6,7)
 .W ?12,"MAIL:"
 .W $J($P(BEXTOT(BEXDAT),U,6),7)
 .W ?30,"WINDOW:"
 .W $J($P(BEXTOT(BEXDAT),U,7),7)
 .W ?50,"TOTAL: "
 .W $J(($P(BEXTOT(BEXDAT),U,6)+$P(BEXTOT(BEXDAT),U,7)),7)
 .W !
 .;
 .I $Y>(IOSL-4) D
 ..I $E(IOST)="C" K DIR S DIR(0)="E" D ^DIR S:X="^" BEXEXIT=1 K DIR
 ..I BEXEXIT=1 Q
 ..S BEXRTYPE="TOTALS"
 ..D HEADER
 ..W !
 ..W "-------------------------------------------------------------------------------"
 ..W !
 ..W "REFILL TOTALS by Originating Transaction Date"
 ..W !
 ..W "-------------------------------------------------------------------------------"
 ..W !
 ;
 I $P(BEXSUM,U,7)>0 D
 .W "TOTAL"
 .W ?17,$J($P(BEXSUM,U,6),7)
 .W ?37,$J($P(BEXSUM,U,7),7)
 .W ?57,$J(($P(BEXSUM,U,6)+$P(BEXSUM,U,7)),7)
 .W !
 ;
 W !,"TOTAL Transactions:",?25,$J(BEXTOT,8)
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
 W !,"REPORT:      Transactions by Date Report"
 W " for "
 I BEXSITE>0 W $$GET1^DIQ(59,BEXSITE,.01)
 I BEXSITE=0 W "all Divisions"
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
 ;Quit if totals only
 I BEXRTYPE="TOTALS" Q
 ;
 W "Date of TX"
 W ?15,"HRNO"
 W ?23,"RX #"
 W ?33,"Date Filled"
 W ?47,"Type"
 W ?57,"Result/[Status]"
 W !
 W "-------------------------------------------------------------------------------"
 W !
 Q
 ;
 ;
 ;-----------------------------------------------------------------
DETAIL ;EP -  Write Detail for each Record and Add up totals
 ;-----------------------------------------------------------------
 ;
 S BEXTOT=BEXTOT+1
 ;
 ;Initialize Counters for this date
 I '$D(BEXTOT(BEXDAT)) S BEXTOT(BEXDAT)="0^0^0^0^0^0^0"
 ;
 ;Add to Counters by Type
 ;
 ;Refills
 I BEXTYPE="R" S $P(BEXTOT(BEXDAT),U)=$P(BEXTOT(BEXDAT),U)+1
 I BEXTYPE="R" S $P(BEXSUM,U)=$P(BEXSUM,U)+1
 ;
 ;Status
 I BEXTYPE="S" S $P(BEXTOT(BEXDAT),U,2)=$P(BEXTOT(BEXDAT),U,2)+1
 I BEXTYPE="S" S $P(BEXSUM,U,2)=$P(BEXSUM,U,2)+1
 ;
 ;Pharmacy
 I BEXTYPE="P" S $P(BEXTOT(BEXDAT),U,3)=$P(BEXTOT(BEXDAT),U,3)+1
 I BEXTYPE="P" S $P(BEXSUM,U,3)=$P(BEXSUM,U,3)+1
 ;
 ;RX Info
 I BEXTYPE="I" S $P(BEXTOT(BEXDAT),U,4)=$P(BEXTOT(BEXDAT),U,4)+1
 I BEXTYPE="I" S $P(BEXSUM,U,4)=$P(BEXSUM,U,4)+1
 ;
 ;Total (for this date)
 S $P(BEXTOT(BEXDAT),U,5)=$P(BEXTOT(BEXDAT),U,5)+1
 S $P(BEXSUM,U,5)=$P(BEXSUM,U,5)+1
 ;
 ;Calculate Mail/Windows
 I $G(BEXRFDAT)]"",$G(BEXMLWIN)="M" S $P(BEXTOT(BEXDAT),U,6)=$P(BEXTOT(BEXDAT),U,6)+1 S $P(BEXSUM,U,6)=$P(BEXSUM,U,6)+1
 I $G(BEXRFDAT)]"",$G(BEXMLWIN)="W" S $P(BEXTOT(BEXDAT),U,7)=$P(BEXTOT(BEXDAT),U,7)+1 S $P(BEXSUM,U,7)=$P(BEXSUM,U,7)+1
 ;
 ;Quit if totals only
 I BEXRTYPE="TOTALS" Q
 ;
 ;-->  Let's write out the record detail
 ;
 ;Write Transaction Date/Time
 S Y=BEXTXDAT
 I Y]"" D
 .W $E(Y,4,5),"/",$E(Y,6,7)
 .X ^DD("DD")
 .W "@"
 .I $P(Y,"@",2)]"" W $E($P(Y,"@",2),1,5)
 .I $P(Y,"@",2)="" W "00:00"
 ;
 ;Write Patient HRNO
 I +BEXDVIEN S Y=$$HRN^AUPNPAT(BEXPTIEN,BEXDVIEN)
 I BEXDVIEN="" S Y=$$HRN^AUPNPAT(BEXPTIEN,DUZ(2))
 I Y>0 W ?13,$J(Y,6)
 ;
 ;Write RX Number
 ;Align numbers, then add any alpha to the end
 I BEXRXNUM W ?22,$J(+BEXRXNUM,8)
 S Y=$E(BEXRXNUM,$L(BEXRXNUM)) I Y?1A W Y
 ;
 ;Write Date Filled
 S Y=BEXRFDAT
 I Y]"" W ?33,$E(Y,4,5),"/",$E(Y,6,7),"/",$E(Y,2,3)
 ;
 ;Mail/Window Code
 I $G(BEXRDDAT)]"",$G(BEXMLWIN)="M" W " (M)"
 I $G(BEXRFDAT)]"",$G(BEXMLWIN)="W" W " (W)"
 ;
 ;Write Type
 S Y=""
 I BEXTYPE="R" S Y="REFILL"
 I BEXTYPE="S" S Y="STATUS"
 I BEXTYPE="I" S Y="RX INFO"
 I BEXTYPE="P" S Y="PHARMACY"
 W ?47,Y
 ;
 ;Write Results
 W ?57,$E(BEXRESLT,1,22)
 I BEXTYPE="P",BEXRESLT="" S Y=$$GET1^DIQ(52,BEXRXIEN,100) W ?57,"[",$E(Y,1,20),"]"
 ;
 W !
 ;
 I $Y>(IOSL-4) D
 .I $E(IOST)="C" K DIR S DIR(0)="E" D ^DIR K DIR
 .I X="^" S BEXEXIT=1 Q
 .D HEADER
 ;
 Q
 ;
