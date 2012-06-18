BARDRST ; IHS/SD/LSL - Statistical Report ; 07/31/2010
 ;;1.8;IHS ACCOUNTS RECEIVABLE;**19**;OCT 26, 2005
 ;
 ; IHS/SD/SDR - V1.6 Patch 1 - Original code by Shonda Render
 ;
 ; IHS/SD/LSL - 03/14/2002 - V1.6 Patch 2 - NOIS NDA-0302-180099
 ;     Resolve <UNDEF> DATA+34^BARDRST
 ;
 ; IHS/SD/LSL - 04/19/02 - V1.6 Patch 2
 ;     Modified to accomodate new "Location to sort report by" parameter
 ;
 ; IHS/SD/LSL - 12/06/02 - V1.7 - NHA-0601-180049
 ;      Look for 3P bill properly.
 ; 
 ; TMM 07/31/10 - V1.8 Patch 19
 ;                       Modify A/R Statistical report to print selected
 ;                       (Employer) Group Plans when BILLING ENTITY, 
 ;                       6) Selected A/R ACCOUNT is selected.  Modify
 ;                       report output to allow printing to a device
 ;                       or creating a delimited file for import to Excel
 ;                       file format
 ;
 ; *********************************************************************
 ; P-1=VISIT CNT, P-2=UNDUP CNT, P-3=$BILLED, P-4=$PAID
 ; P-5=$ADJUSTMENTS, P-6=$CURRENT BILLED
 ;
 K BAR,BARY
 S BARP("RTN")="BARDRST"
 S BAR("RTYP")=0,BAR("PAY")=""
 S BAR("LOC")=$$GET1^DIQ(90052.06,DUZ(2),16)   ; BILLING or VISIT
 I BAR("LOC")="" S BAR("LOC")="VISIT"
 D ^BARRSEL G XIT:$D(DTOUT)!$D(DUOUT)!$D(DIROUT)
 ;
 W !
 K DIR
 S DIR("A",1)="This report will only contain APPROVED bills."
 S DIR("A")="Do you wish to include CANCELLED bills"
 S DIR("B")="N"
 S DIR(0)="Y"
 D ^DIR
 K DIR
 S BAR("STATUS")=Y
 ;
 K DIR,DTOUT,DUOUT,DIROUT,DIRUT
 S DIR(0)="SA^P:PRINTED;D:DELIMITED"
 S DIR("A")="Should the output be in (P)rinter format or (D)elimited file format?  P/D  "
 K DA
 D ^DIR
 I $D(DIROUT)!$D(DTOUT)!$D(DUOUT) Q
 S BARPRTYP=Y                 ;selected print type
 S BARTEXT=0                  ;output = printer format
 I Y="D" S BARTEXT=1          ;output = delimited file format
 ;
 S BAR("HD",0)="A/R STATISTICAL REPORT"
 D ^BARRHD
 S BAR("TXT")="ALL"
 I $D(BARY("LOC")) S BAR("TXT")=$P(^DIC(4,BARY("LOC"),0),U)
 I BAR("LOC")="BILLING" D
 . S BAR("TXT")=BAR("TXT")_" Visit location(s) under "
 . S BAR("TXT")=BAR("TXT")_$P(^DIC(4,DUZ(2),0),U)
 . S BAR("TXT")=BAR("TXT")_" Billing Location"
 E  S BAR("TXT")=BAR("TXT")_" Visit location(s) regardless of Billing Location"              ;1.8*19 TMM 7/31/10
 S BAR("CONJ")="at "
 D CHK^BARRHD
 ;
 S BARQ("RC")="COMPUTE^BARDRST"
 S BARQ("RX")="POUT^BARRUTL"
 S BARQ("NS")="BAR"
 S BARQ("RP")="PRINT^BARDRST1"
 D ^BARDBQUE
 Q
 ; *********************************************************************
 ;
COMPUTE ;EP - Entry Point for Setting up Data
 K ^TMP($J,"BAR-ST")
 K ^TMP($J,"BAR-B")
 S BARP("RTN")="BARDRST"
 I BAR("LOC")="BILLING" D  Q
 . S (BAR("NLN"),BAR("NLC"),BAR("NLB"),BAR("NLP"),BAR("NLA"))=0
 . D LOOP^BARRUTL
 I BAR("LOC")'="BILLING" D  Q
 . S BARDUZ2=DUZ(2)
 .  S DUZ(2)=0
 . F  S DUZ(2)=$O(^BARBL(DUZ(2))) Q:'DUZ(2)  D
 .. S (BAR("NLN"),BAR("NLC"),BAR("NLB"),BAR("NLP"),BAR("NLA"))=0
 .. D LOOP^BARRUTL
 . S DUZ(2)=BARDUZ2
 Q
 ; *********************************************************************
 ;
DATA ;
 N BARREC,BARSTAT,BARTYP
 S BARREC=^BARBL(DUZ(2),BAR,0)                 ;MOVE BILL FILE TO BARREC
 ;SET VISIT TYPE FROM BILL FILE TO BARTYP
 S BARTYP=$P($G(^BARBL(DUZ(2),BAR,1)),U,14)
 S BARP("HIT")=0
 D BILL^BARRCHK Q:'BARP("HIT")                 ;checks parameters
 ;
 S BAR3P("LOC")=$$FIND3PB^BARUTL(DUZ(2),BAR)   ;returns "" or 3PDUZ2^3PBIEN
 Q:BAR3P("LOC")=""
 S BAR3PDUZ=$P(BAR3P("LOC"),",")
 S BAR3PDA=$P(BAR3P("LOC"),",",2)
 ;
 S BARSTAT=$P($G(^ABMDBILL(BAR3PDUZ,BAR3PDA,0)),U,4) ;3PB status
 I BAR("STATUS")'=1,(BARSTAT="X") Q             ;Quit if cancelled bills not included
 ;
 I BARY("SORT")="C" S BAR("V")=BAR("C")              ;C=Clinic V=Visit
 S BAR("PT")=$P(^BARBL(DUZ(2),BAR,1),U)              ;Patient IEN
 S:'$D(BAR("LC",BAR("L"))) BAR("LC",BAR("L"))=0
 I '$D(BAR(BAR("L"),BAR("V"))) D
 .S BAR(BAR("L"),BAR("V"))="0^0^0^0^0^0"
 ;
 ;Next line counts # undup pats
 I '$D(^TMP($J,"BAR-ST",BAR("L"),BAR("V"),BAR("PT"))) D
 .S ^TMP($J,"BAR-ST",BAR("L"),BAR("V"),BAR("PT"))=""
 .S $P(BAR(BAR("L"),BAR("V")),U,2)=$P(BAR(BAR("L"),BAR("V")),U,2)+1
 ;
 ;
 ; NEXT 5 LINES ADDING PAID AMOUNTS
 S BARTRAN=0
 F  S BARTRAN=$O(^BARTR(DUZ(2),"AC",BAR,BARTRAN)) Q:'BARTRAN  D
 .Q:'$D(^BARTR(DUZ(2),BARTRAN,0))    ; Q if no transaction
 .S BAR("PDD")=+^BARTR(DUZ(2),BARTRAN,0)
 .I $G(BARY("DT"))="P",BAR("PDD")<BARY("DT",1)!(BAR("PDD")>BARY("DT",2)) Q
 .S BARCDT=$P($G(^BARTR(DUZ(2),BARTRAN,0)),U,2)
 .S BARDBT=$P($G(^BARTR(DUZ(2),BARTRAN,0)),U,3)
 .S BARTTYP=$P($G(^BARTR(DUZ(2),BARTRAN,1)),U)
 .Q:BARTTYP=""
 .S BARTTYP=$P($G(^BARTBL(BARTTYP,0)),U)
 .; only want payment, not payment monthly
 .I BARTTYP["PAYMENT",BARTTYP'["MONTHLY" D
 ..S $P(BAR(BAR("L"),BAR("V")),U,4)=$P(BAR(BAR("L"),BAR("V")),U,4)+BARCDT-BARDBT
 .I BARTTYP["ADJUST" D
 ..S $P(BAR(BAR("L"),BAR("V")),U,5)=$P(BAR(BAR("L"),BAR("V")),U,5)+BARCDT-BARDBT
 ;
 ;
 ; NEXT 3 LINES COUNT TOTAL NUMBER OF UNDUP PATIENTS
 I '$D(^TMP($J,"BAR-ST",BAR("L"),BAR("PT"))) D
 .S ^TMP($J,"BAR-ST",BAR("L"),BAR("PT"))=""
 .S BAR("LC",BAR("L"))=BAR("LC",BAR("L"))+1
 ;
 I '$D(^TMP($J,"BAR-ST",BAR("PT"))) D
 .S ^TMP($J,"BAR-ST",BAR("PT"))=""
 .S BAR("NLC")=BAR("NLC")+1
 ;
 ; NEXT 3 LINES CHECKS FOR FIRST VALID BILL 
 S BARBILL=BARREC
 Q:$D(^TMP($J,"BAR-B",BARBILL))                          ;CK IF IS FOUND
 S ^TMP($J,"BAR-B",BARBILL)=""          ;CK IF TMP IS UNIQUE USING BAR-B
 ;
 ; NEXT LINE COUNTS # OF VISITS
 S $P(BAR(BAR("L"),BAR("V")),U)=$P(BAR(BAR("L"),BAR("V")),U)+1
 ;
 ;Next line is adding billed amount
 S $P(BAR(BAR("L"),BAR("V")),U,3)=$P(BAR(BAR("L"),BAR("V")),U,3)+$P(^BARBL(DUZ(2),BAR,0),U,13)
 I BARTYP=111 D     ;CK IF NOT EQUAL TO OUTPATIENT-NEED ONLY INPATIENTS
 .S BAR(BAR("L"),"COVD")=$G(BAR(BAR("L"),"COVD"))+$P($G(^ABMDBILL(BAR3PDUZ,BAR3PDA,7)),U,3)
 S $P(BAR(BAR("L"),BAR("V")),U,6)=$P(BAR(BAR("L"),BAR("V")),U,6)+$P($G(^BARBL(DUZ(2),BAR,0)),U,15)
 ;
 Q
 ; *********************************************************************
 ;
XIT K BAR,BARY,BARP
 Q
 ;
TEXTCK() ;   Text delimited file  <--NEW TAG(TEXTCK) ;1.8*19 TMM 7/31/10
 N BARTXT
 S BARTXT=""
 I $G(BARTEXT)=1 S BARTXT="^"
 Q BARTXT
