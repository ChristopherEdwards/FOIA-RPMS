BEXRREJ ;CMI/BJI/DAY - BEX - Refill Rejections Percentage Report ; 19 Nov 2009  10:56 AM [ 03/02/2010  11:13 AM ]
 ;;1.0;BEX TELEPHONE REFILL SYSTEM;**4**;DEC 01, 2009
 ;
 ;Prints the Refill Rejections Percentage Report
 ;
 D ^XBCLS
 ;
 W !,"Refill Rejections Percentage Report"
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
 .S BEXSITE=+Y
 .S BEXDIV=BEXDIV+1
 .S Y=$P($G(^PS(59,BEXSITE,"INI")),U)
 .I +Y S BEXDIV(Y)=""
 ;
 ;
 ;
 ;--------------------------------------------------------------------
BEGDATE ;EP - Come here if end date is before begin date
 ;---------------------------------------------------------------------
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
 S XBRP="LIST^BEXRREJ"
 S XBRX="EOJ^BEXRREJ"
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
 S BEXTOT=0
 S BEXTOT("REJECTS")=0
 S BEXTOT("TOO EARLY")=0
 S BEXTOT("DISCONTINUED")=0
 S BEXTOT("CANCELLED")=0
 S BEXTOT("NO REFILLS")=0
 S BEXTOT("EXPIRED")=0
 S BEXTOT("DUE EXPIRE")=0
 S BEXTOT("RESTOCKED")=0
 ;
 S BEXQUIT=0
 S BEXEXIT=0
 ;
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
 ..;Restrict to non-Pharmacy Type
 ..I $P(BEX(0),U,4)="P" Q
 ..;
 ..D PARSE^BEXRUTL
 ..;
 ..;Screen by Division
 ..I +BEXDIV,BEXDVIEN="" Q
 ..I +BEXDIV,'$D(BEXDIV(BEXDVIEN)) Q
 ..;
 ..D TOTAL
 ;
 S BEXQUIT=0
 ;Loop through sort array
 S BEXDAT=0
 F  S BEXDAT=$O(BEXTOT(BEXDAT)) Q:'BEXDAT  D  Q:BEXQUIT=1  Q:BEXEXIT=1
 .;
 .W !
 .S Y=BEXDAT
 .W $E(Y,4,5),"/",$E(Y,6,7),"/",$E(Y,2,3)
 .;
 .W ?30,"TOO EARLY",?49,$J($P(BEXTOT(BEXDAT),U,3),6)
 .W ?58,"PERCENT  "
 .W $$PERCENT($P(BEXTOT(BEXDAT),U,3),$P(BEXTOT(BEXDAT),U,2)),!
 .;
 .W ?30,"DISCONTINUED",?49,$J($P(BEXTOT(BEXDAT),U,4),6)
 .W ?58,"PERCENT  "
 .W $$PERCENT($P(BEXTOT(BEXDAT),U,4),$P(BEXTOT(BEXDAT),U,2)),!
 .;
 .W ?30,"CANCELLED",?49,$J($P(BEXTOT(BEXDAT),U,5),6)
 .W ?58,"PERCENT  "
 .W $$PERCENT($P(BEXTOT(BEXDAT),U,5),$P(BEXTOT(BEXDAT),U,2)),!
 .;
 .W ?30,"NO REFILLS",?49,$J($P(BEXTOT(BEXDAT),U,6),6)
 .W ?58,"PERCENT  "
 .W $$PERCENT($P(BEXTOT(BEXDAT),U,6),$P(BEXTOT(BEXDAT),U,2)),!
 .;
 .W ?30,"EXPIRED",?49,$J($P(BEXTOT(BEXDAT),U,7),6)
 .W ?58,"PERCENT  "
 .W $$PERCENT($P(BEXTOT(BEXDAT),U,7),$P(BEXTOT(BEXDAT),U,2)),!
 .;
 .W ?30,"DUE EXPIRE",?49,$J($P(BEXTOT(BEXDAT),U,8),6)
 .W ?58,"PERCENT  "
 .W $$PERCENT($P(BEXTOT(BEXDAT),U,8),$P(BEXTOT(BEXDAT),U,2)),!
 .;
 .W ?30,"RESTOCKED",?49,$J($P(BEXTOT(BEXDAT),U,9),6)
 .W ?58,"PERCENT  "
 .W $$PERCENT($P(BEXTOT(BEXDAT),U,9),$P(BEXTOT(BEXDAT),U,2)),!
 .;
 .;
 .W ?2,"TOTAL TRANSACTIONS "
 .W $J($P(BEXTOT(BEXDAT),U,2),6)
 .;
 .W ?30,"TOTAL REJECTS      "
 .W $J($P(BEXTOT(BEXDAT),U),6)
 .;
 .W ?58,"PERCENT  "
 .W $$PERCENT($P(BEXTOT(BEXDAT),U),$P(BEXTOT(BEXDAT),U,2))
 .;
 .W !
 .W "----------------------------------------------------------------------------"
 .W !
 .;
 .I $Y>(IOSL-12) D
 ..I $E(IOST)="C" K DIR S DIR(0)="E" D ^DIR S:X="^" BEXEXIT=1 K DIR
 ..I BEXEXIT=1 Q
 ..D HEADER
 ;
 W !
 ;
 W "GRAND TOTALS"
 ;Write Totals for each type
 W ?30,"TOO EARLY"
 W ?49,$J(BEXTOT("TOO EARLY"),6)
 W ?58,"PERCENT  "
 W $$PERCENT(BEXTOT("TOO EARLY"),BEXTOT),!
 ;
 W ?30,"DISCONTINUED"
 W ?49,$J(BEXTOT("DISCONTINUED"),6)
 W ?58,"PERCENT  "
 W $$PERCENT(BEXTOT("DISCONTINUED"),BEXTOT),!
 ;
 W ?30,"CANCELLED"
 W ?49,$J(BEXTOT("CANCELLED"),6)
 W ?58,"PERCENT  "
 W $$PERCENT(BEXTOT("CANCELLED"),BEXTOT),!
 ;
 W ?30,"NO REFILLS"
 W ?49,$J(BEXTOT("NO REFILLS"),6)
 W ?58,"PERCENT  "
 W $$PERCENT(BEXTOT("NO REFILLS"),BEXTOT),!
 ;
 W ?30,"EXPIRED"
 W ?49,$J(BEXTOT("EXPIRED"),6)
 W ?58,"PERCENT  "
 W $$PERCENT(BEXTOT("EXPIRED"),BEXTOT),!
 ;
 W ?30,"DUE EXPIRE"
 W ?49,$J(BEXTOT("DUE EXPIRE"),6)
 W ?58,"PERCENT  "
 W $$PERCENT(BEXTOT("DUE EXPIRE"),BEXTOT),!
 ;
 W ?30,"RESTOCKED"
 W ?49,$J(BEXTOT("RESTOCKED"),6)
 W ?58,"PERCENT  "
 W $$PERCENT(BEXTOT("RESTOCKED"),BEXTOT),!
 ;
 W !
 W ?2,"TOTAL TRANSACTIONS "
 W $J(BEXTOT,6)
 W ?30,"TOTAL REJECTS      "
 W $J(BEXTOT("REJECTS"),6)
 W ?58,"PERCENT  ",$$PERCENT(BEXTOT("REJECTS"),BEXTOT)
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
 W !,"REPORT:      Refill Rejections Percentage Report"
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
 ;---------------------------------------------------------------
PERCENT(X,Y) ;EP - Calculate Percent
 ;---------------------------------------------------------------
 ;
 I X=0 Q " 0.00%"
 I Y=0 Q " 0.00%"
 S Z=X/Y
 S Z=$J(Z,4,4)
 S Z=$E(Z,3,4)_"."_$E(Z,5,6)_"%"
 I $E(Z)=0 S Z=" "_$E(Z,2,99)
 Q Z
 ;
 ;
 ;-----------------------------------------------------------------
TOTAL ;EP -  Add up totals
 ;-----------------------------------------------------------------
 ;
 ;We are adding up individual totals by reject type, but are not
 ;writing them at this time.  In the future, the users may want them.
 ;
 S BEXTOT=BEXTOT+1
 ;
 ;Initialize Counters for this date
 I '$D(BEXTOT(BEXDAT)) S BEXTOT(BEXDAT)="0^0^0^0^0^0^0^0^0"
 ;
 ;Add to Total Transactions for this date
 S $P(BEXTOT(BEXDAT),U,2)=$P(BEXTOT(BEXDAT),U,2)+1
 ;
 ;Reject - Too Early (piece 3)
 I BEXRESLT="TOO EARLY" D  Q
 .S $P(BEXTOT(BEXDAT),U)=$P(BEXTOT(BEXDAT),U)+1
 .S BEXTOT("REJECTS")=BEXTOT("REJECTS")+1
 .S BEXTOT("TOO EARLY")=BEXTOT("TOO EARLY")+1
 .S $P(BEXTOT(BEXDAT),U,3)=$P(BEXTOT(BEXDAT),U,3)+1
 ;
 ;Reject - Discontinued (piece 4)
 I BEXRESLT="DISCONTINUED" D  Q
 .S $P(BEXTOT(BEXDAT),U)=$P(BEXTOT(BEXDAT),U)+1
 .S BEXTOT("REJECTS")=BEXTOT("REJECTS")+1
 .S BEXTOT("DISCONTINUED")=BEXTOT("DISCONTINUED")+1
 .S $P(BEXTOT(BEXDAT),U,4)=$P(BEXTOT(BEXDAT),U,4)+1
 ;
 ;Reject - Canceled (piece 5) - yes it is misspelled 
 I BEXRESLT="CANCELED" D  Q
 .S $P(BEXTOT(BEXDAT),U)=$P(BEXTOT(BEXDAT),U)+1
 .S BEXTOT("REJECTS")=BEXTOT("REJECTS")+1
 .S BEXTOT("CANCELLED")=BEXTOT("CANCELLED")+1
 .S $P(BEXTOT(BEXDAT),U,5)=$P(BEXTOT(BEXDAT),U,5)+1
 ;
 ;Reject - No Refills (piece 6) 
 I BEXRESLT="NO REFILLS" D  Q
 .S $P(BEXTOT(BEXDAT),U)=$P(BEXTOT(BEXDAT),U)+1
 .S BEXTOT("REJECTS")=BEXTOT("REJECTS")+1
 .S BEXTOT("NO REFILLS")=BEXTOT("NO REFILLS")+1
 .S $P(BEXTOT(BEXDAT),U,6)=$P(BEXTOT(BEXDAT),U,6)+1
 ;
 ;Reject - Expired (piece 7)
 I BEXRESLT="EXPIRED" D  Q
 .S $P(BEXTOT(BEXDAT),U)=$P(BEXTOT(BEXDAT),U)+1
 .S BEXTOT("REJECTS")=BEXTOT("REJECTS")+1
 .S BEXTOT("EXPIRED")=BEXTOT("EXPIRED")+1
 .S $P(BEXTOT(BEXDAT),U,7)=$P(BEXTOT(BEXDAT),U,7)+1
 ;
 ;Reject - Due Expire
 I BEXRESLT="DUE EXPIRE" D  Q
 .S $P(BEXTOT(BEXDAT),U)=$P(BEXTOT(BEXDAT),U)+1
 .S BEXTOT("REJECTS")=BEXTOT("REJECTS")+1
 .S BEXTOT("DUE EXPIRE")=BEXTOT("DUE EXPIRE")+1
 .S $P(BEXTOT(BEXDAT),U,8)=$P(BEXTOT(BEXDAT),U,8)+1
 ;
 ;Reject - Restocked
 I BEXRESLT="RESTOCKED" D  Q
 .S $P(BEXTOT(BEXDAT),U)=$P(BEXTOT(BEXDAT),U)+1
 .S BEXTOT("REJECTS")=BEXTOT("REJECTS")+1
 .S BEXTOT("RESTOCKED")=BEXTOT("RESTOCKED")+1
 .S $P(BEXTOT(BEXDAT),U,9)=$P(BEXTOT(BEXDAT),U,9)+1
 ;
 Q
 ;
