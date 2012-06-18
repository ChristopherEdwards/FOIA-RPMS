BEXRDOW ;CMI/BJI/DAY - BEX - Transactions by Day of Week Report ; 21 Nov 2009  7:43 PM [ 03/02/2010  11:12 AM ]
 ;;1.0;BEX TELEPHONE REFILL SYSTEM;**4**;DEC 01, 2009
 ;
 ;Prints the Transactions by Day of Week Report
 ;
 D ^XBCLS
 ;
 W !,"Transactions by Day of Week"
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
 .K DIC,DIE,DIR,DA,DD,DO,DR
 .I X="" S BEXQUIT=1 Q
 .I Y<0 S BEXQUIT=1 Q
 .S BEXSITE=+Y
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
 S XBRP="LIST^BEXRDOW"
 S XBRX="EOJ^BEXRDOW"
 S XBNS="BEX"
 D ^XBDBQUE
 Q
 ;
 ;
 ;---------------------------------------------------------------
EOJ ;EP -  End of Job Processing
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
 K BEXSUM
 S BEXSUM="0^0^0^0^0"
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
 ..;Screen by division
 ..I +BEXDIV,BEXDVIEN="" Q
 ..I +BEXDIV,'$D(BEXDIV(BEXDVIEN)) Q
 ..;
 ..D TOTAL
 ;
 ;Write Totals
 ;
 W !
 W "------------------------------------------------------------------------------"
 W !
 W "TOTALS by Day of Week"
 W !
 W "------------------------------------------------------------------------------"
 W !
 ;
 S BEXDOW=0
 F  S BEXDOW=$O(BEXTOT(BEXDOW)) Q:'BEXDOW  D
 .I BEXDOW=1 W "SUN"
 .I BEXDOW=2 W "MON"
 .I BEXDOW=3 W "TUE"
 .I BEXDOW=4 W "WED"
 .I BEXDOW=5 W "THU"
 .I BEXDOW=6 W "FRI"
 .I BEXDOW=7 W "SAT"
 .W ?8,"REFILL: "
 .W $J($P(BEXTOT(BEXDOW),U),5)
 .W ?23,"STATUS: "
 .W $J($P(BEXTOT(BEXDOW),U,2),5)
 .W ?38,"PHARM: "
 .W $J($P(BEXTOT(BEXDOW),U,3),5)
 .;Remove LIST since this type does not seem to be used
 .;W ?52,"INFO: "
 .;W $J($P(BEXTOT(BEXDOW),U,4),5)
 .W ?52,"TOTAL: "
 .W $J($P(BEXTOT(BEXDOW),U,5),6)
 .W !
 ;
 W "TOTAL"
 W ?14,$J($P(BEXSUM,U),7)
 W ?29,$J($P(BEXSUM,U,2),7)
 W ?43,$J($P(BEXSUM,U,3),7)
 ;W ?56,$J($P(BEXSUM,U,4),7)
 W ?58,$J($P(BEXSUM,U,5),7)
 W !
 ;
 W !,"TOTAL Transactions:",?25,$J(BEXTOT,8)
 W !
 ;
 Q
 ;
 ;
 ;---------------------------------------------------------------
HEADER ;EP -  Write the Header
 ;---------------------------------------------------------------
 ;
 D ^XBCLS
 W !,"REPORT:      Transactions by Day of Week Report"
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
 W "------------------------------------------------------------------------------"
 W !
 Q
 ;
 ;
 ;-----------------------------------------------------------------
TOTAL ;EP -  Add up totals
 ;-----------------------------------------------------------------
 ;
 S BEXTOT=BEXTOT+1
 ;
 ;Initialize Counters for this date
 S X=BEXDAT
 D DOW^%DTC
 I Y=-1 Q
 ;Add 1 to DOW because Sunday is zero
 S BEXDOW=Y+1
 I '$D(BEXTOT(BEXDOW)) S BEXTOT(BEXDOW)="0^0^0^0^0"
 ;
 ;Refills
 I BEXTYPE="R" S $P(BEXTOT(BEXDOW),U)=$P(BEXTOT(BEXDOW),U)+1
 I BEXTYPE="R" S $P(BEXSUM,U)=$P(BEXSUM,U)+1
 ;
 ;Status
 I BEXTYPE="S" S $P(BEXTOT(BEXDOW),U,2)=$P(BEXTOT(BEXDOW),U,2)+1
 I BEXTYPE="S" S $P(BEXSUM,U,2)=$P(BEXSUM,U,2)+1
 ;
 ;Pharmacy
 I BEXTYPE="P" S $P(BEXTOT(BEXDOW),U,3)=$P(BEXTOT(BEXDOW),U,3)+1
 I BEXTYPE="P" S $P(BEXSUM,U,3)=$P(BEXSUM,U,3)+1
 ;
 ;RX Info
 I BEXTYPE="I" S $P(BEXTOT(BEXDOW),U,4)=$P(BEXTOT(BEXDOW),U,4)+1
 I BEXTYPE="I" S $P(BEXSUM,U,4)=$P(BEXSUM,U,4)+1
 ;
 ;Total (for this date)
 S $P(BEXTOT(BEXDOW),U,5)=$P(BEXTOT(BEXDOW),U,5)+1
 S $P(BEXSUM,U,5)=$P(BEXSUM,U,5)+1
 ;
 Q
 ;
