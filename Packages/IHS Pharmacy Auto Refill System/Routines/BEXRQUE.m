BEXRQUE ;IHS/CMI/DAY - BEX - Refill Queue Report ; 12 Mar 2012  7:14 PM
 ;;1.0;BEX TELEPHONE REFILL SYSTEM;**4,5**;MAR 12, 2012;Build 1
 ;
 ;Prints the Refill Queue Report
 ;
 ;CMI/BJI/DAY - New routine released in Patch 5
 ;
 W #
 ;
 W !,"Refill Queue Report"
 W !
 W !,"This option prints a list of entries in the Refill Queue."
 W !
 ;
 ;If more than one Division, ask it
 I $P($G(^PS(59,0)),U,3)>1 K PSOPAR
 I '$D(PSOSITE) K PSOPAR
 I '$D(PSOPAR) D ^PSOLSET
 I '$D(PSOPAR) G EOJ
 ;
 ;Set DUZ(2) for correct HRNO's
 I +$G(PSOSITE) S DUZ(2)=+$P($G(^PS(59,PSOSITE,"INI")),U)
 ;
 W !
 W !,"Division: "
 I +$G(PSOSITE) W $P($G(^PS(59,+PSOSITE,0)),U)
 W !
 ;
 K BEXOPSIT
 S BEXOPSIT=0
 S BEXQUIT=0
 S BEXEXIT=0
 ;
 W !,"Press Enter to select ALL Outpatient Sites, or"
 F  D  Q:BEXQUIT=1
 .K DUOUT,DIC,DIR,DIE,DA,DR,DO,DD
 .S DIC(0)="AEQMZ"
 .S DIC("A")="Select a Outpatient Site: "
 .S DIC=59
 .D ^DIC
 .K DIC,DIR,DIE,DA,DD,DR,DO
 .I $G(DUOUT) K DUOUT S (BEXQUIT,BEXEXIT)=1 Q
 .I X="" S BEXQUIT=1 Q
 .I Y<0 Q
 .S BEXOPSIT=BEXOPSIT+1
 .I +Y S BEXOPSIT(+Y)=""
 ;
 I BEXEXIT=1 Q
 ;
 W !
 K DIR,DIRUT
 S DIR("A")="Choose Sorting Order"
 S DIR(0)="SO^A:Alphabetic within Window/Local/Mail;I:Internal Numbers - Similar to Refill Queue Order"
 S DIR("B")="A"
 D ^DIR
 K DIR
 I $D(DIRUT) K DIRUT G EOJ
 I Y="A" S BEXSAME=0
 I Y="I" S BEXSAME=1
 ;
 ;Only have Unprocessed entries
 S BEXRTYPE="UNPROC"
 ;
 W !
 K DIR,DIRUT
 S DIR(0)="S^A:All Entries;L:Local Mail Only;M:Mail Only (CMOP);W:Window Only"
 S DIR("A")="Process All, Local Mail, Mail, or Window"
 D ^DIR
 I $G(DIRUT) K DIR,DIRUT Q
 K DIR
 S BEXWIND=Y
 ;
 ;
 ;--------------------------------------------------------------------------
 ;
 W !
 S XBRP="LIST^BEXRQUE"
 S XBRX="EOJ^BEXRQUE"
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
 K ^BEXUTL($J)
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
 U IO
 W #
 D HEADER
 ;
 K ^BEXUTL($J)
 K BEXTOT
 S BEXTOT=0
 K BEXSUM
 S BEXSUM="0^0^0^0^0^0^0"
 ;
 S BEXQUIT=0
 S BEXEXIT=0
 ;
 ;VEXHRX is subscripted by the value in ^DD("SITE",1) for all Divs
 S BEXSITE=0
 F  S BEXSITE=$O(^VEXHRX(19080,BEXSITE)) Q:'BEXSITE  D  Q:BEXQUIT=1  Q:BEXEXIT=1
 .;
 .S BEXIEN=0
 .F  S BEXIEN=$O(^VEXHRX(19080,BEXSITE,BEXIEN)) Q:'BEXIEN  D  Q:BEXQUIT=1  Q:BEXEXIT=1
 ..;
 ..S BEXPTIEN=$P(BEXIEN,"-")
 ..S BEXRXIEN=$P(BEXIEN,"-",2)
 ..;
 ..;Screen by Division
 ..S BEXOPIEN=0
 ..I +BEXRXIEN S BEXOPIEN=$P($G(^PSRX(BEXRXIEN,2)),U,9)
 ..S BEXRFIEN=0
 ..I +BEXRXIEN S BEXRFIEN=$O(^PSRX(BEXRXIEN,1,99),-1)
 ..I +BEXRFIEN S BEXOPIEN=$P($G(^PSRX(BEXRXIEN,1,BEXRFIEN,0)),U,9)
 ..I +BEXOPSIT,+BEXOPIEN=0 Q
 ..I +BEXOPSIT,'$D(BEXOPSIT(BEXOPIEN)) Q
 ..;
 ..S BEXMAIL=$P(^VEXHRX(19080,BEXSITE,BEXIEN),U,4)
 ..I BEXMAIL="" S BEXMAIL="M"
 ..;
 ..;Did user want only Unprocessed entries
 ..S BEXFILL=$P($G(^PSRX(BEXRXIEN,3)),U)
 ..I BEXRTYPE="UNPROC",BEXFILL=DT Q
 ..I BEXRTYPE="UNPROC",BEXFILL>DT Q
 ..;
 ..;Did user want to restrict to certain values
 ..I BEXMAIL="W",BEXWIND="M" Q
 ..I BEXMAIL="W",BEXWIND="L" Q
 ..I BEXMAIL="L",BEXWIND="M" Q
 ..I BEXMAIL="L",BEXWIND="W" Q
 ..I BEXMAIL="M",BEXWIND="L" Q
 ..I BEXMAIL="M",BEXWIND="W" Q
 ..;
 ..;Want to sort by Window, Local, then Mail
 ..I BEXMAIL="W" S BEXSORT=1
 ..I BEXMAIL="L" S BEXSORT=2
 ..I BEXMAIL="M" S BEXSORT=3
 ..I $G(BEXSAME)=1 S BEXSORT=4
 ..;
 ..;Get Patient ID for Sort
 ..S BEXPAT=$$GET1^DIQ(2,BEXPTIEN,.01)
 ..I BEXPAT="" S BEXPAT="??"
 ..I $G(BEXSAME)=1 S BEXPAT=BEXPTIEN
 ..;
 ..S ^BEXUTL($J,BEXOPIEN,BEXSORT,BEXPAT,BEXRXIEN)=BEXPTIEN_U_BEXMAIL
 ;
 ;Loop BEXUTL to extract sorted data
 ;
 S BEXOPIEN=0
 F  S BEXOPIEN=$O(^BEXUTL($J,BEXOPIEN)) Q:'BEXOPIEN  D  Q:BEXEXIT=1
 .;
 .S BEXSORT=0
 .F  S BEXSORT=$O(^BEXUTL($J,BEXOPIEN,BEXSORT)) Q:'BEXSORT  D  Q:BEXEXIT=1
 ..;
 ..S BEXPAT=""
 ..F  S BEXPAT=$O(^BEXUTL($J,BEXOPIEN,BEXSORT,BEXPAT)) Q:BEXPAT=""  D  Q:BEXEXIT=1
 ...;
 ...S BEXRXIEN=0
 ...F  S BEXRXIEN=$O(^BEXUTL($J,BEXOPIEN,BEXSORT,BEXPAT,BEXRXIEN)) Q:'BEXRXIEN  D  Q:BEXEXIT=1
 ....;
 ....S BEXPTIEN=$P(^BEXUTL($J,BEXOPIEN,BEXSORT,BEXPAT,BEXRXIEN),U)
 ....S BEXMAIL=$P(^BEXUTL($J,BEXOPIEN,BEXSORT,BEXPAT,BEXRXIEN),U,2)
 ....;
 ....D DETAIL
 ;
 ;
 ;Write Totals
 ;
 I BEXEXIT=1 Q
 ;
 I $Y>(IOSL-5) D
 .I $E(IOST)="C" K DIR S DIR(0)="E" D ^DIR S:X="^" BEXEXIT=1 K DIR
 .I BEXEXIT=1 Q
 .D HEADER
 .W !
 ;
 I BEXEXIT=1 Q
 ;
 I BEXTOT>0 D
 .W !,"WINDOW",?14,$J(BEXTOT("W"),7)
 .W !,"LOCAL MAIL",?14,$J(BEXTOT("L"),7)
 .W !,"MAIL",?14,$J(BEXTOT("M"),7)
 .W !,"TOTAL",?14,$J(BEXTOT,7)
 ;
 Q
 ;
 ;
 ;--------------------------------------------------------------
HEADER ;EP - Write the Header
 ;---------------------------------------------------------------
 ;
 U IO
 W #
 W !,"REPORT:      Refill Queue Report"
 W " for "
 I BEXOPSIT=1 W $$GET1^DIQ(59,$O(BEXOPSIT(0)),.01)
 I BEXOPSIT=0 W "all Divisions"
 I BEXOPSIT>1 W "selected Divisions"
 W !,"DATE RUN:    " S Y=DT X ^DD("DD") W Y
 W !,"PARAMETERS:  "
 ;
 ;
 I BEXRTYPE="ALL" W "Both Processed and Unprocessed Entries"
 I BEXRTYPE="UNPROC" W "Unprocessed Entries"
 I BEXWIND="W" W ", Window Only"
 I BEXWIND="L" W ", Local Mail Only"
 I BEXWIND="M" W ", Mail (CMOP) Only"
 I BEXSAME=0 W ", Alpha within W/L/M"
 I BEXSAME=1 W ", Internal Sort"
 ;
 W !
 W "-------------------------------------------------------------------------------"
 W !
 W "Name"
 W ?21,"Chart"
 W ?30,"RX #"
 W ?37,"M/W"
 W ?42,"LFill"
 W ?49,"Drug"
 W ?74,"DEA"
 ;
 W !
 W "-------------------------------------------------------------------------------"
 W !
 ;
 Q
 ;
 ;
 ;-----------------------------------------------------------------
DETAIL ;EP -  Write Detail for each Record and Add up totals
 ;-----------------------------------------------------------------
 ;
 U IO
 S BEXTOT=BEXTOT+1
 ;
 ;Initialize Counters for each type
 I '$D(BEXTOT("M")) S BEXTOT("M")=0
 I '$D(BEXTOT("L")) S BEXTOT("L")=0
 I '$D(BEXTOT("W")) S BEXTOT("W")=0
 ;
 ;
 ;Add to Counters by Type
 I BEXMAIL="W" S BEXTOT("W")=BEXTOT("W")+1
 I BEXMAIL="L" S BEXTOT("L")=BEXTOT("L")+1
 I BEXMAIL="M" S BEXTOT("M")=BEXTOT("M")+1
 ;
 ;-->  Let's write out the record detail
 ;
 ;Patient Name
 S Y=$$GET1^DIQ(2,BEXPTIEN,.01)
 S Y=$E(Y,1,17)
 I Y]"" W Y
 ;
 ;Write Patient HRNO
 S Y=""
 I +$G(BEXOPIEN) D
 .S BEXINST=$P($G(^PS(59,BEXOPIEN,"INI")),U)
 .I +BEXINST S Y=$$HRN^AUPNPAT(BEXPTIEN,BEXINST)
 I Y="" S Y=$$HRN^AUPNPAT(BEXPTIEN,DUZ(2))
 I Y>0 W ?20,$J(Y,6)
 ;
 ;Write RX Number
 S BEXRXNUM=$$GET1^DIQ(52,BEXRXIEN,.01)
 ;Align numbers, then add any alpha to the end
 I BEXRXNUM W ?28,$J(+BEXRXNUM,8)
 S Y=$E(BEXRXNUM,$L(BEXRXNUM)) I Y?1A W Y
 ;
 ;Mail/Window Code
 I BEXMAIL="W" W ?39,"W"
 I BEXMAIL="L" W ?39,"L"
 I BEXMAIL="M" W ?39,"M"
 ;
 ;
 ;Write Last Fill Date
 S Y=$P($G(^PSRX(BEXRXIEN,3)),U)
 I Y S Y=$E(Y,4,5)_"/"_$E(Y,6,7)
 W ?42,Y
 ;
 ;Write Drug Name
 S Y=$$GET1^DIQ(52,BEXRXIEN,6)
 S Y=$E(Y,1,22)
 W ?49,Y
 ;
 ;DEA, Special Handling
 S BEXDRIEN=$$GET1^DIQ(52,BEXRXIEN,6,"I")
 S Y=""
 I BEXDRIEN D
 .S X=$$GET1^DIQ(50,BEXDRIEN,3)
 .I X[3 S Y=X
 .I X[4 S Y=X
 .I X[5 S Y=X
 W ?74,Y
 ;
 W !
 ;
 I $Y>(IOSL-5) D
 .I $E(IOST)="C" K DIR S DIR(0)="E" D ^DIR K DIR
 .I X="^" S BEXEXIT=1 Q
 .D HEADER
 ;
 Q
 ;
