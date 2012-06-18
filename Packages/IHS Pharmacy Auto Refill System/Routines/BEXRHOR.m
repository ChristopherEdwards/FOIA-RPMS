BEXRHOR ;CMI/BJI/DAY - BEX - Transactions by Hour Report ; 21 Nov 2009  7:37 PM [ 03/02/2010  11:13 AM ]
 ;;1.0;BEX TELEPHONE REFILL SYSTEM;**4**;DEC 01, 2009
 ;
 ;Prints the Transactions by Hour Report
 ;
 D ^XBCLS
 ;
 W !,"Transactions by Hour Report"
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
 W !,"Press Enter for ALL Pharmacy Divisions or you may"
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
 ;---------------------------------------------------------------
BEGDATE ;EP - Come here if end date is before begin date
 ;---------------------------------------------------------------
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
 S XBRP="LIST^BEXRHOR"
 S XBRX="EOJ^BEXRHOR"
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
 I BEXEXIT=0 I $E(IOST)="C" W ! K DIR S DIR(0)="E" D ^DIR K DIR
 K ^BEXTMP($J,"BEXRHOR")
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
 K ^BEXTMP($J,"BEXRHOR")
 K BEXTOT
 S BEXTOT=0
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
 ..D PARSE^BEXRUTL
 ..;
 ..;Screen by Division
 ..I +BEXDIV,BEXDVIEN="" Q
 ..I +BEXDIV,'$D(BEXDIV(BEXDVIEN)) Q
 ..;
 ..D TOTAL
 ;
 ;Now we loop the TMP global to write out detail within each time slot
 I BEXRTYPE="DETAIL" D
 .;
 .S BEXHOR=0
 .F  S BEXHOR=$O(^BEXTMP($J,"BEXRHOR",BEXHOR)) Q:'BEXHOR  D  Q:BEXEXIT=1
 ..;
 ..D SUBHEAD
 ..D DETHEAD
 ..;
 ..S BEXIEN=0
 ..F  S BEXIEN=$O(^BEXTMP($J,"BEXRHOR",BEXHOR,BEXIEN)) Q:'BEXIEN  D  Q:BEXEXIT=1
 ...;
 ...S BEX(0)=$G(^VEXHRX0(19080.1,BEXIEN,0))
 ...I BEX(0)="" Q
 ...;
 ...D PARSE^BEXRUTL
 ...;
 ...D DETAIL
 ;
 I BEXEXIT=1 Q
 ;
 ;Write Totals
 ;
 I BEXTOT>0 D
 .W !
 .W "-------------------------------------------------------------------------------"
 .W !
 .W "TOTALS by Hour"
 .W !
 .W "-------------------------------------------------------------------------------"
 .W !
 ;
 S BEXHOR=""
 F  S BEXHOR=$O(BEXTOT(BEXHOR)) Q:'BEXHOR  D
 .I BEXHOR=1 W "MIDNIGHT TO  1:00 AM"
 .I BEXHOR=2 W " 1:00 AM TO  2:00 AM"
 .I BEXHOR=3 W " 2:00 AM TO  3:00 AM"
 .I BEXHOR=4 W " 3:00 AM TO  4:00 AM"
 .I BEXHOR=5 W " 4:00 AM TO  5:00 AM"
 .I BEXHOR=6 W " 5:00 AM TO  6:00 AM"
 .I BEXHOR=7 W " 6:00 AM TO  7:00 AM"
 .I BEXHOR=8 W " 7:00 AM TO  8:00 AM"
 .I BEXHOR=9 W " 8:00 AM TO  9:00 AM"
 .I BEXHOR=10 W " 9:00 AM TO 10:00 AM"
 .I BEXHOR=11 W "10:00 AM TO 11:00 AM"
 .I BEXHOR=12 W "11:00 AM TO     NOON"
 .I BEXHOR=13 W "NOON     TO  1:00 PM"
 .I BEXHOR=14 W " 1:00 PM TO  2:00 PM"
 .I BEXHOR=15 W " 2:00 PM TO  3:00 PM"
 .I BEXHOR=16 W " 3:00 PM TO  4:00 PM"
 .I BEXHOR=17 W " 4:00 PM TO  5:00 PM"
 .I BEXHOR=18 W " 5:00 PM TO  6:00 PM"
 .I BEXHOR=19 W " 6:00 PM TO  7:00 PM"
 .I BEXHOR=20 W " 7:00 PM TO  8:00 PM"
 .I BEXHOR=21 W " 8:00 PM TO  9:00 PM"
 .I BEXHOR=22 W " 9:00 PM TO 10:00 PM"
 .I BEXHOR=23 W "10:00 PM TO 11:00 PM"
 .I BEXHOR=24 W "11:00 PM TO MIDNIGHT"
 .W !
 .W ?6,"REFILL: "
 .W $J($P(BEXTOT(BEXHOR),U),5)
 .W ?21,"STATUS: "
 .W $J($P(BEXTOT(BEXHOR),U,2),5)
 .W ?36,"PHARM: "
 .W $J($P(BEXTOT(BEXHOR),U,3),5)
 .;Remove LIST since this type does not seem to be used
 .;W ?50,"INFO: "
 .;W $J($P(BEXTOT(BEXHOR),U,4),5)
 .W ?50,"TOTAL: "
 .W $J($P(BEXTOT(BEXHOR),U,5),6)
 .W !
 .;
 .I $Y>(IOSL-4) D
 ..I $E(IOST)="C" K DIR S DIR(0)="E" D ^DIR S:X="^" BEXEXIT=1 K DIR
 ..I BEXEXIT=1 Q
 ..D HEADER
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
 W !,"REPORT:      Transactions by Hour Report"
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
 Q
 ;
 ;
 ;-----------------------------------------------------------------
DETHEAD ;EP - Write Detail Header
 ;------------------------------------------------------------------
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
SUBHEAD ;EP - Write Subhead totals  
 ;-----------------------------------------------------------------
 ;
 W !
 W "-------------------------------------------------------------------------------"
 W !
 I BEXHOR=1 W "MIDNIGHT TO  1:00 AM"
 I BEXHOR=2 W " 1:00 AM TO  2:00 AM"
 I BEXHOR=3 W " 2:00 AM TO  3:00 AM"
 I BEXHOR=4 W " 3:00 AM TO  4:00 AM"
 I BEXHOR=5 W " 4:00 AM TO  5:00 AM"
 I BEXHOR=6 W " 5:00 AM TO  6:00 AM"
 I BEXHOR=7 W " 6:00 AM TO  7:00 AM"
 I BEXHOR=8 W " 7:00 AM TO  8:00 AM"
 I BEXHOR=9 W " 8:00 AM TO  9:00 AM"
 I BEXHOR=10 W " 9:00 AM TO 10:00 AM"
 I BEXHOR=11 W "10:00 AM TO 11:00 AM"
 I BEXHOR=12 W "11:00 AM TO     NOON"
 I BEXHOR=13 W "NOON     TO  1:00 PM"
 I BEXHOR=14 W " 1:00 PM TO  2:00 PM"
 I BEXHOR=15 W " 2:00 PM TO  3:00 PM"
 I BEXHOR=16 W " 3:00 PM TO  4:00 PM"
 I BEXHOR=17 W " 4:00 PM TO  5:00 PM"
 I BEXHOR=18 W " 5:00 PM TO  6:00 PM"
 I BEXHOR=19 W " 6:00 PM TO  7:00 PM"
 I BEXHOR=20 W " 7:00 PM TO  8:00 PM"
 I BEXHOR=21 W " 8:00 PM TO  9:00 PM"
 I BEXHOR=22 W " 9:00 PM TO 10:00 PM"
 I BEXHOR=23 W "10:00 PM TO 11:00 PM"
 I BEXHOR=24 W "11:00 PM TO MIDNIGHT"
 W !
 W ?6,"REFILL: "
 W $J($P(BEXTOT(BEXHOR),U),5)
 W ?21,"STATUS: "
 W $J($P(BEXTOT(BEXHOR),U,2),5)
 W ?36,"PHARM: "
 W $J($P(BEXTOT(BEXHOR),U,3),5)
 ;Remove INFO since this type does not seem to be used
 ;W ?50,"INFO: "
 ;W $J($P(BEXTOT(BEXHOR),U,4),5)
 W ?50,"TOTAL: "
 W $J($P(BEXTOT(BEXHOR),U,5),6)
 W !
 W "-------------------------------------------------------------------------------"
 W !
 Q
 ;
 ;
 ;----------------------------------------------------------------
TOTAL ;EP -  Calculate Totals and Suntotals
 ;------------------------------------------------------------------
 ;
 I BEXTIM="" Q
 S BEXHOR=BEXTIM
 ;
 S BEXTOT=BEXTOT+1
 ;
 ;Fix Midnight
 I BEXHOR="24" S BEXHOR="00"
 ;
 ;Fix 10:00
 I BEXHOR=1 S BEXHOR="10"
 ;Initialize Counters for this date
 D
 .I $E(BEXHOR,1,2)="00" S BEXHOR=1 Q
 .I $E(BEXHOR,1,2)="01" S BEXHOR=2 Q
 .I $E(BEXHOR,1,2)="02" S BEXHOR=3 Q
 .I $E(BEXHOR,1,2)="03" S BEXHOR=4 Q
 .I $E(BEXHOR,1,2)="04" S BEXHOR=5 Q
 .I $E(BEXHOR,1,2)="05" S BEXHOR=6 Q
 .I $E(BEXHOR,1,2)="06" S BEXHOR=7 Q
 .I $E(BEXHOR,1,2)="07" S BEXHOR=8 Q
 .I $E(BEXHOR,1,2)="08" S BEXHOR=9 Q
 .I $E(BEXHOR,1,2)="09" S BEXHOR=10 Q
 .I $E(BEXHOR,1,2)="10" S BEXHOR=11 Q
 .I $E(BEXHOR,1,2)="11" S BEXHOR=12 Q
 .I $E(BEXHOR,1,2)="12" S BEXHOR=13 Q
 .I $E(BEXHOR,1,2)="13" S BEXHOR=14 Q
 .I $E(BEXHOR,1,2)="14" S BEXHOR=15 Q
 .I $E(BEXHOR,1,2)="15" S BEXHOR=16 Q
 .I $E(BEXHOR,1,2)="16" S BEXHOR=17 Q
 .I $E(BEXHOR,1,2)="17" S BEXHOR=18 Q
 .I $E(BEXHOR,1,2)="18" S BEXHOR=19 Q
 .I $E(BEXHOR,1,2)="19" S BEXHOR=20 Q
 .I $E(BEXHOR,1,2)="20" S BEXHOR=21 Q
 .I $E(BEXHOR,1,2)="21" S BEXHOR=22 Q
 .I $E(BEXHOR,1,2)="22" S BEXHOR=23 Q
 .I $E(BEXHOR,1,2)="23" S BEXHOR=24 Q
 ;
 I BEXHOR>24 Q
 ;
 I '$D(BEXTOT(BEXHOR)) S BEXTOT(BEXHOR)="0^0^0^0^0"
 ;
 ;Refills
 I BEXTYPE="R" S $P(BEXTOT(BEXHOR),U)=$P(BEXTOT(BEXHOR),U)+1
 ;
 ;Status
 I BEXTYPE="S" S $P(BEXTOT(BEXHOR),U,2)=$P(BEXTOT(BEXHOR),U,2)+1
 ;
 ;Pharmacy
 I BEXTYPE="P" S $P(BEXTOT(BEXHOR),U,3)=$P(BEXTOT(BEXHOR),U,3)+1
 ;
 ;RX Info
 I BEXTYPE="I" S $P(BEXTOT(BEXHOR),U,4)=$P(BEXTOT(BEXHOR),U,4)+1
 ;
 ;Total (for this date)
 S $P(BEXTOT(BEXHOR),U,5)=$P(BEXTOT(BEXHOR),U,5)+1
 ;
 ;
 ;Set Sort Array
 S ^BEXTMP($J,"BEXRHOR",BEXHOR,BEXIEN)=""
 ;
 Q
 ;
 ;
 ;-----------------------------------------------------------------
DETAIL ;EP - Write out detail   
 ;-----------------------------------------------------------------
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
 I +BEXRXNUM W ?22,$J(+BEXRXNUM,8)
 S Y=$E(BEXRXNUM,$L(BEXRXNUM)) I Y?1A W Y
 ;
 ;Write Date Filled
 S Y=BEXRFDAT
 I Y]"" W ?33,$E(Y,4,5),"/",$E(Y,6,7),"/",$E(Y,2,3)
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
 .D DETHEAD
 ;
 Q
 ;
