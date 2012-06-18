BARCHKLU ; IHS/SD/LSL - Look up Collection Information for Insurance Company by Check Number ;
 ;;1.8;IHS ACCOUNTS RECEIVABLE;;OCT 26, 2005
 ;
 ; IHS/SD/LSL - 11/14/02 - V1.7 - NOIS XCA-0802-200093
 ;      Modify code that $O thru the "D" x-ref to check for checks
 ;      in all upper case if check entered in lower case and lower case
 ;      check fails.
 ;
 ; ********************************************************************
 ;
 ;** Collection Batch information by check number
 ;** option Check Posting Summary (CPS)**
 ;
ONE ;EP
 N DIC,BARCHKNO,BARCBDA,BARITMNO
 ;
 ; -------------------------------
ASK W !!
 S DIC=$$DIC^XBDIQ1(90051.01)
 S DIC(0)="AEQZ"
 S D="D"
 S DIC("A")="Select Check Number: "
 D IX^DIC
 I X=" " W !,"  Must enter a Check Number " G ASK
 Q:+Y<0
 S BARCHKNO=X
 S BARCBDA=+Y
 S BARITMNO=0
 S BARCBNM=$P(Y,U,2)
 S BARITMNO=$O(^BARCOL(DUZ(2),"D",BARCHKNO,BARCBDA,BARITMNO))
 I BARITMNO="" D  I BARITMNO="" K BARCBDA,BARITMNO,BARCHKNO G ASK
 . S BARCHKNO=$$UPC^BARUTL(X)
 . S BARCBDA=+Y
 . S BARITMNO=0
 . S BARITMNO=$O(^BARCOL(DUZ(2),"D",BARCHKNO,BARCBDA,BARITMNO))
 . I BARITMNO="" W !,"Couldn't find ITEM for this CHECK NUMBER.  Please select again."
 I '$D(^BARCOL(DUZ(2),BARCBDA,1,BARITMNO,0)) D  G ASK
 . W !,"PROBLEM WITH THIS ITEM SET UP CONTACT YOUR SUPPORT PERSONNEL"
 . K BARCBDA,BARITMNO,BARCHKNO
 I '$D(^BARCOL(DUZ(2),BARCBDA,1,BARITMNO,1)) D  G ASK
 . W !,"PROBLEM WITH THIS ITEM SET UP CONTACT YOUR SUPPORT PERSONNEL"
 . K BARCBDA,BARITMNO,BARCHKNO
 I '$D(^BARCOL(DUZ(2),BARCBDA,1,BARITMNO,2)) D  G ASK
 . W !,"PROBLEM WITH THIS ITEM SET UP CONTACT YOUR SUPPORT PERSONNEL"
 . K BARCBDA,BARITMNO,BARCHKNO
 S (BARCKAMT,BARINSNM,BARITMPD,BARITMBL,BARITMUD,BARITMUA,BARITMRF)=0
 S BARCKAMT=$P(^BARCOL(DUZ(2),BARCBDA,1,BARITMNO,1),"^")
 S BARINSNM=$P(^BARCOL(DUZ(2),BARCBDA,1,BARITMNO,2),"^")
 S BARITMPD=$$VAL^XBDIQ1(90051.1101,"BARCBDA,BARITMNO",18)
 S BARITMBL=$$VAL^XBDIQ1(90051.1101,"BARCBDA,BARITMNO",19)
 S BARITMUD=$P(^BARCOL(DUZ(2),BARCBDA,1,BARITMNO,1),"^",3)
 S BAR23=1
 S BARITMUA=$$ITT^BARCBC(BARCBDA,BARITMNO,"UN-ALLOCATED")
 K BAR23
 S BARITMRF=$$ITT^BARCBC(BARCBDA,BARITMNO,"REFUND")*-1
 W !,"Check No: ",BARCHKNO,?25,"From: ",$E(BARINSNM,1,30),?65,"For: ",$J(BARCKAMT,10,2),!
 K DIR
 S DIR(0)="Y"
 S DIR("A")="  CORRECT "
 S DIR("B")="YES"
 D ^DIR
 K DIR
 I Y'=1 G ASK
 D PRINT
 Q
 ; *********************************************************************
 ;
HEADER ;
 I IOSL=6000 D
 .W $$EN^BARVDF("IOF")
 .W !?5,"Collection Batch: ",BARCBNM
 .W ?50,"Item Number: ",BARITMNO
 .W !,"Check Number: ",BARCHKNO
 .W ?32,"Issued By: ",BARINSNM
 .W !,"Check Amount: ",$J(BARCKAMT,10,2)
 .W ?27,"Amount Posted : ",$J(BARITMPD,10,2)
 .W ?55,"Balance : ",$J(BARITMBL,10,2)
 .W !,"Un-Allocated: ",$J(BARITMUA,10,2)
 .W ?55,"Refunded: ",$J(BARITMRF,10,2),!
 .W !,"Patient Name",?19,"3P Bill DT",?30,"Bill Name",?48,"DOS",?70,"Paid Amt.",!
 .D EBARPG
 I IOSL<6000 D BARHDR
 ;
 ; -------------------------------
DETAILS ;
 ; Collect information on what bills this check applied to
 S BARBCNT=0
 S (BARDTTM,BARCHKPD)=0
 F  S BARDTTM=$O(^BARTR(DUZ(2),"AD",BARCBDA,BARDTTM)) Q:BARDTTM'>0  D  Q:($G(DIROUT)!$G(DUOUT)!$G(DTOUT)!$G(DROUT))
 .I $P(^BARTR(DUZ(2),BARDTTM,0),"^",15)'=BARITMNO Q
 .I '$D(^BARTR(DUZ(2),BARDTTM,1)) Q
 .I $P(^BARTR(DUZ(2),BARDTTM,1),"^")'=40 Q
 .S (BARBLDA,BARBLPT,BARPDAMT)=0
 .S (BARBLNM,BARBLPTN)=""
 .S BARPDAMT=$P(^BARTR(DUZ(2),BARDTTM,0),U,2)
 .S BARBLDA=$P(^BARTR(DUZ(2),BARDTTM,0),U,4)
 .S BARBLPT=$P(^BARTR(DUZ(2),BARDTTM,0),U,5)
 .S BARBLPTN=$E($$VAL^XBDIQ1(90050.01,BARBLDA,101),1,25)
 .S BARDOSB=$$VALI^XBDIQ1(90050.01,BARBLDA,102)
 .S BARDOSE=$$VALI^XBDIQ1(90050.01,BARBLDA,103)
 .S BARDOSEF=$$SDT^BARDUTL(BARDOSE)
 .S BARDOSBF=$$SDT^BARDUTL(BARDOSB)  ;Y2000
 .S BARBLNM=$E($$VAL^XBDIQ1(90050.01,BARBLDA,.01),1,15)
 .S BAR3PAP=$$SDT^BARDUTL($P($G(^BARBL(DUZ(2),BARBLDA,0)),U,18))
 .W !,$E(BARBLPTN,1,18)
 .W ?19,BAR3PAP
 .W ?30,$E(BARBLNM,1,17)
 .W ?48,BARDOSBF_"-"_BARDOSEF
 .W ?70,$J(BARPDAMT,10,2)
 .S BARBCNT=BARBCNT+1
 .S BARCHKPD=BARCHKPD+BARPDAMT
 .D PG
 .Q
 W !!?40,"Bill Count: ",BARBCNT,?60,"TOTALS:",?68,$J(BARCHKPD,12,2),!
 D EBARPG
 I $E(IOST)="C",IOT["TRM" D EOP^BARUTL(0)
 Q
 ; *********************************************************************
 ;
PRINT ;**Print   
 ;
 ; GET DEVICE (QUEUEING ALLOWED)
 S Y=$$DIR^XBDIR("S^P:PRINT Output;B:BROWSE Output on Screen","Do you wish to ","P","","","",1)
 K DA
 Q:$D(DIRUT)
 I Y="B" D  Q
 . S XBFLD("BROWSE")=1
 . S BARIOSL=IOSL
 . S IOSL=600
 . D VIEWR^XBLM("HEADER^BARCHKLU")
 . D FULL^VALM1
 . W $$EN^BARVDF("IOF")
 .D CLEAR^VALM1  ;clears out all list man stuff
 .K XQORNEST,VALMKEY,VALM,VALMAR,VALMBCK,VALMBG,VALMCAP,VALMCNT,VALMOFF
 .K VALMCON,VALMDN,VALMEVL,VALMIOXY,VALMLFT,VALMLST,VALMMENU,VALMSGR
 .K VALMUP,VALMWD,VALMY,XQORS,XQORSPEW,VALMCOFF
 .;
 .; ------------------------------
DEVE .;
 .S IOSL=BARIOSL
 .K BARIOSL
 .Q
 S XBRP="HEADER^BARCHKLU"
 S XBNS="BAR"
 S XBRX="EXIT^BARCHKLU"
 D ^XBDBQUE
ENDJOB Q
 ; *********************************************************************
PG ;**page controller      
BARPG ;EP PAGE CONTROLLER   
 ; This utility uses variables BARPG("HDR"),BARPG("DT"),BARPG("LINE"),BARPG("PG")
 ; kill variables by D EBARPG
 ;
 Q:($Y<(IOSL-6))!($G(DOUT)!$G(DFOUT))
 S:'$D(BARPG("PG")) BARPG("PG")=0
 S BARPG("PG")=BARPG("PG")+1
 I $E(IOST)="C",IOT["TRM" D EOP^BARUTL(0)  Q:($G(DIROUT)!$G(DUOUT)!$G(DTOUT)!$G(DROUT))
 ;
 ; -------------------------------
Q ;
 Q:($G(DIROUT)!$G(DUOUT)!$G(DTOUT)!$G(DROUT))
 ;
 ; -------------------------------
BARHDR ; Write the Report Header
 S BARPG("HDR")="Check Posting Summary"
 W:$Y @IOF
 W !
 Q:'$D(BARPG("HDR"))
 S:'$D(BARPG("LINE")) $P(BARPG("LINE"),"-",IOM-2)=""
 S:'$D(BARPG("PG")) BARPG("PG")=1
 I '$D(BARPG("DT")) D
 . S %H=$H
 . D YX^%DTC
 . S BARPG("DT")=Y
 U IO
 W ?(IOM-$L(BARPG("HDR"))/2),BARPG("HDR")
 W !?(IOM-75),BARPG("DT"),?(IOM-15),"PAGE: ",BARPG("PG")
 W !,BARPG("LINE")
 ;
 ; -------------------------------
BARHD ;EP
 ; Write column header / message
 W !?5,"Collection Batch: ",BARCBNM
 W ?50,"Item Number: ",BARITMNO
 W !,"Check Number: ",BARCHKNO
 W ?32,"Issued By: ",BARINSNM
 W !,"Check Amount: ",$J(BARCKAMT,10,2)
 W ?27,"Amount Posted : ",$J(BARITMPD,10,2)
 W ?55,"Balance : ",$J(BARITMBL,10,2),!
 W "Un-Allocated: ",$J(BARITMUA,10,2)
 W ?55,"Refunded: ",$J(BARITMRF,10,2),!
 W !,"Patient Name"
 W ?19,"3P Bill DT"
 W ?30,"Bill Name"
 W ?48,"DOS"
 W ?70,"Paid Amt.",!
 I ($G(DIROUT)!$G(DUOUT)!$G(DTOUT)!$G(DROUT)) S BARQUIT=1
 Q
 ; *********************************************************************
 ;
EBARPG ;
 K BARPG("LINE"),BARPG("PG"),BARPG("HDR"),BARPG("DT")
 Q
 ; *********************************************************************
 ;
EXIT ; Exit routine
 Q
