BEXREXC ;IHS/CMI/DAY - Print reports [ 07/14/2011  1:01 AM ] ; 12 Mar 2012  9:18 PM
 ;;1.0;BEX TELEPHONE REFILL SYSTEM;**4,5**;MAR 12, 2012;Build 1
 ;
 ;Prints the Exceptions/Non-Refillable Transactions by Date Report
 ;
 ;IHS/CMI/DAY - New routine released in patch 5
 ;
 W #
 ;
 W !,"Exceptions/Non-Refillable Transaction Report"
 W !
 W !,"This option prints a list of Exceptions/Non-Refillable transactions that"
 W !,"were received within a selected date/time range."
 W !
 ;
 K BEXDIV
 S BEXDIV=0
 S BEXSITE=0
 S BEXQUIT=0
 ;
 ;
 W !,"Press Enter to select ALL Pharmacy Divisions, or"
 F  D  Q:BEXQUIT=1
 .K DIC,DIR,DIE,DA,DR,DO,DD
 .S DIC(0)="AEQMZ"
 .S DIC("A")="Select a Pharmacy Division: "
 .S DIC=59
 .D ^DIC
 .K DIC,DIE,DIR,DR,DA,DD,DO
 .I X="" S BEXQUIT=1 Q
 .I Y<0 S BEXQUIT=1 Q
 .S BEXSITE=+Y
 .S BEXDIV=BEXDIV+1
 .S Y=$P($G(^PS(59,BEXSITE,"INI")),U)
 .I +Y S BEXDIV(Y)=""
 ;
 W !
 K DIR,DIRUT
 S DIR("A")="Select Window, Local Mail, or Mail"
 S DIR(0)="S^A:All Entries;W:Window Only;L:Local Mail Only;M:Mail Only (CMOP)"
 D ^DIR
 K DIR
 S BEXWIND=Y
 ;
BEGDATE ;EP - Come here if end date is before begin date
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
 S XBRP="LIST^BEXREXC"
 S XBNS="BEX"
 D ^XBDBQUE
 Q
 ;
 ;
 ;---------------------------------------------------------------
EOJ ;-->  End of Job Processing
 ;---------------------------------------------------------------
 ;
 X ^%ZIS("C")
 I $E(IOST)="C" W ! K DIR S DIR(0)="E" D ^DIR K DIR
 K BEX
 K ^BEXREXC($J)
 D EN^XBVK("BEX")
 K DIR,DIE,DIC,DD,DA,DR
 Q
 ;
 ;
 ;---------------------------------------------------------------
LIST ;-->  EP - Entry Point from XBDBQUE
 ;---------------------------------------------------------------
 ;
 W #
 D HEADER
 ;
 K ^BEXREXC($J)
 K BEXTOT
 S BEXTOT=0
 ;
 S BEXQUIT=0,BEXEXIT=0
 ;
 ;Loop to build sorted array
 S BEXDATE=BEXBEG
 F  S BEXDATE=$O(^VEXHRX0(19080.1,"C",BEXDATE)) Q:'BEXDATE  D  Q:BEXQUIT=1
 .;
 .I BEXDATE<BEXBEG Q
 .I BEXDATE>BEXEND S BEXQUIT=1 Q
 .;
 .S BEXIEN=0
 .F  S BEXIEN=$O(^VEXHRX0(19080.1,"C",BEXDATE,BEXIEN)) Q:'BEXIEN  D  Q:BEXQUIT=1
 ..;
 ..S BEX(0)=$G(^VEXHRX0(19080.1,BEXIEN,0))
 ..I BEX(0)="" Q
 ..;
 ..D PARSE^BEXRUTL
 ..;
 ..;Only want to look at refill requests
 ..I BEXTYPE'="R" Q
 ..;
 ..;Screen by Division
 ..I +BEXDIV,BEXDVIEN="" Q
 ..I +BEXDIV,'$D(BEXDIV(BEXDVIEN)) Q
 ..;
 ..S BEXHRNO=$$HRN^AUPNPAT(BEXPTIEN,BEXDVIEN)
 ..I BEXHRNO="" Q
 ..;
 ..S BEXNAME=$$GET1^DIQ(2,BEXPTIEN,.01)
 ..;
 ..;No RX # for Deceased, and other conditions
 ..I BEXRXNUM="" S BEXRXNUM=0
 ..;
 ..I BEXMAIL="W" S BEXSORT=1
 ..I BEXMAIL="L" S BEXSORT=3
 ..I BEXMAIL="M" S BEXSORT=2
 ..I BEXMAIL="" S BEXSORT=4
 ..;
 ..;If this was refilled within the date range - remove it
 ..;Because we sort by M/W you may see an RX that was refillable
 ..;not get removed if the Exception was under a different M/W
 ..I BEXRESLT["REFILLABLE" K ^BEXREXC($J,BEXSORT,BEXNAME,BEXRXNUM) Q
 ..;
 ..;Screen by Mail or Window
 ..I BEXWIND="M",BEXMAIL="L" Q
 ..I BEXWIND="M",BEXMAIL="W" Q
 ..I BEXWIND="L",BEXMAIL="M" Q
 ..I BEXWIND="L",BEXMAIL="W" Q
 ..I BEXWIND="W",BEXMAIL="M" Q
 ..I BEXWIND="W",BEXMAIL="L" Q
 ..;
 ..;
 ..;Sort by Mail/Window, then Name and RXNUM
 ..S ^BEXREXC($J,BEXSORT,BEXNAME,BEXRXNUM)=BEXIEN
 ;
 ;
 ;Loop to write out detail and add to totals counters
 S BEXSORT=""
 F  S BEXSORT=$O(^BEXREXC($J,BEXSORT)) Q:BEXSORT=""  D  Q:BEXEXIT=1
 .;
 .S BEXNAME=""
 .F  S BEXNAME=$O(^BEXREXC($J,BEXSORT,BEXNAME)) Q:BEXNAME=""  D  Q:BEXEXIT=1
 ..;
 ..S BEXRXN=""
 ..F  S BEXRXN=$O(^BEXREXC($J,BEXSORT,BEXNAME,BEXRXN)) Q:BEXRXN=""  D  Q:BEXEXIT=1
 ...;
 ...S BEXIEN=$G(^BEXREXC($J,BEXSORT,BEXNAME,BEXRXN))
 ...I BEXIEN="" Q
 ...;
 ...S BEX(0)=$G(^VEXHRX0(19080.1,BEXIEN,0))
 ...I BEX(0)="" Q
 ...;
 ...D PARSE^BEXRUTL
 ...;
 ...D DETAIL
 ;
 ;Write Totals
 ;
 I BEXEXIT=1 Q
 ;
 W !
 W "----------------------------------------------------------------"
 W !
 W "TOTALS by Date"
 W !
 W "---------------------------------------------------------------------"
 W !
 ;
 S BEXDAT=""
 F  S BEXDAT=$O(BEXTOT(BEXDAT)) Q:'BEXDAT  D
 .S X=BEXDAT
 .W $E(X,4,5),"/",$E(X,6,7),"/",$E(X,2,3)
 .W ?10,"EXCEPTIONS: "
 .W ?29,$J(BEXTOT(BEXDAT),4)
 .W !
 ;
 W !,"TOTAL Exceptions:",?25,$J(BEXTOT,8)
 W !
 ;
 I $E(IOST)="C" K DIR S DIR(0)="E" D ^DIR K DIR
 ;
 Q
 ;
 ;
 ;---------------------------------------------------------------
HEADER ;-->  Write the Header
 ;---------------------------------------------------------------
 ;
 W #
 W !,"REPORT:      Exceptions/Non-Refillable Report"
 W " for "
 I BEXSITE>0 W $$GET1^DIQ(59,BEXDIV,.01)
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
 ;
 W "Date"
 W ?7,"Name"
 W ?27,"HRNO"
 W ?36,"RX #"
 W ?44,"Drug"
 W ?60,"M/W"
 W ?65,"Result"
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
 ;Initialize Counter for this date
 I '$D(BEXTOT(BEXDAT)) S BEXTOT(BEXDAT)=0
 ;
 ;Add to Counters by Type
 ;
 ;Refills
 I BEXTYPE="R" S BEXTOT(BEXDAT)=BEXTOT(BEXDAT)+1
 ;
 ;Quit if totals only
 ;
 ;-->  Let's write out the record detail
 ;
 ;Write Transaction Date/Time
 S Y=BEXTXDAT
 I Y]"" D
 .W $E(Y,4,5),"/",$E(Y,6,7)
 .;Remove Time
 .;X ^DD("DD")
 .;W "@"
 .;I $P(Y,"@",2)]"" W $E($P(Y,"@",2),1,5)
 .;I $P(Y,"@",2)="" W "00:00"
 ;
 ;Patient Name
 S Y=$$GET1^DIQ(2,BEXPTIEN,.01)
 W ?7,$E(Y,1,16)
 ;
 ;Write Patient HRNO
 S Y=$$HRN^AUPNPAT(BEXPTIEN,BEXDVIEN)
 I Y>0 W ?25,$J(Y,6)
 ;
 ;Write RX Number
 I $E(BEXRXNUM,$L(BEXRXNUM))?1A W ?33,$J(BEXRXNUM,9)
 I $E(BEXRXNUM,$L(BEXRXNUM))?1N W ?32,$J(BEXRXNUM,9)
 ;
 ;Drug Name
 S Y=$$GET1^DIQ(50,BEXDRIEN,.01)
 W ?44,$E(Y,1,16)
 ;
 ;Write Mail/Window
 W ?62,BEXMAIL
 ;
 ;Write Results
 W ?65,$E(BEXRESLT,1,14)
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
