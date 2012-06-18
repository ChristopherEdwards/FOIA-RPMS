BARBLOS1 ; IHS/SD/LSL - List Outstanding Balances by Insurer- Jan 17,1997 ;08/20/2008
 ;;1.8;IHS ACCOUNTS RECEIVABLE;**7**;OCT 26, 2005
 ;
 ; IHS/ADC/KMR P*2 JAN 2,1997 - Routine created
 ; MODIFIED TO CHANGE XTMP($J,"BARBLOS" TMP TO MEET SAC REQUIREMENTS;MRS:BAR*1.8*7 IM29892
 ; *********************************************************************
 ;
PRINT ;EP
 ; roll through the ^XTMP("BARBLOS",$J) and report on these records
 S BARAPDT=$$SDT^BARDUTL(BARDATE)  ;Y2000
 S BARPG("HDR")="Outstanding Balances by Insurer for Bills approved by "_BARAPDT
 S BARHDRA="N"
 D BARHDR
 I '$D(^XTMP("BARBLOS",$J)) W !!?15,"NO RECORDS TO BE LISTED" Q
 S BARINSNO=""
 S BARDATE=BARDATE
 S (BARQUIT,BARTBILL,BARTCOLL,BARTGRP)=0
 F  S BARINSNO=$O(^XTMP("BARBLOS",$J,BARINSNO)) Q:BARINSNO=""  Q:BARQUIT  Q:BARINSNO="NO49REC"  D  Q:($G(DIROUT)!$G(DUOUT)!$G(DTOUT)!$G(DROUT))
 . S (BARACTBL,BARACTCL,BARGRPDL)=0
 . I BARINSNO'=0 D
 .. I '$D(^BARAC(DUZ(2),BARINSNO)) S BARACTNM="  UNKNOWN  "_BARINSNO Q
 .. S BARACTNM=$$GET1^DIQ(90050.02,BARINSNO,.01)
 . I BARINSNO=0 D
 .. S BARACTNM=" UNKNOWN  "
 . I $D(^XTMP("BARBLOS",$J,BARINSNO,"BILLED")) D
 .. S BARACTBL=^XTMP("BARBLOS",$J,BARINSNO,"BILLED")
 .. S BARTBILL=BARTBILL+^XTMP("BARBLOS",$J,BARINSNO,"BILLED")
 . I $D(^XTMP("BARBLOS",$J,BARINSNO,"COLLECTED")) D
 .. S BARACTCL=^XTMP("BARBLOS",$J,BARINSNO,"COLLECTED")
 .. S BARTCOLL=BARTCOLL+^XTMP("BARBLOS",$J,BARINSNO,"COLLECTED")
 . I $D(^XTMP("BARBLOS",$J,BARINSNO,"GROUPER")) D
 .. S BARGRPDL=^XTMP("BARBLOS",$J,BARINSNO,"GROUPER")
 .. S BARTGRP=BARTGRP+^XTMP("BARBLOS",$J,BARINSNO,"GROUPER")
 . S BARACTBA=BARACTBL-BARACTCL
 . D WRTRPT
 S BARTBA=BARTBILL-BARTCOLL
 S BARTBLF=$FN(BARTBILL,",",2)
 S BARTCLF=$FN(BARTCOLL,",",2)
 S BARTBAF=$FN(BARTBA,",",2)
 S BARTGRPF=$FN(BARTGRP,",",2)
 W !!,?5,"TOTALS:"
 W ?27,$J("",15-$L(BARTBLF))_BARTBLF
 W ?43,$J("",15-$L(BARTCLF))_BARTCLF
 W ?56,$J("",15-$L(BARTBAF))_BARTBAF
 I $E(IOST)="C",IOT["TRM" D EOP^BARUTL(0)
 D EBARPG
 Q
 ; *********************************************************************
 ;
WRTRPT ;
 ; Write out the reports
 S BARACTBF=$FN(BARACTBL,",",2)
 S BARACTCF=$FN(BARACTCL,",",2)
 S BARACTAF=$FN(BARACTBA,",",2)
 S BARGRPDF=$FN(BARGRPDL,",",2)
 W !!,$E(BARACTNM,1,25)
 W ?29,$J("",13-$L(BARACTBF))_BARACTBF
 W ?45,$J("",13-$L(BARACTCF))_BARACTCF
 W ?59,$J("",13-$L(BARACTAF))_BARACTAF
 D PG
 Q
 ; *********************************************************************
 ;
PG ;**page controller 
BARPG ;EP
 ; PAGE CONTROLLER   
 ; This utility uses variables BARPG("HDR"),BARPG("DT"),BARPG("LINE"),BARPG("PG")
 ; kill variables by D EBARPG
 ;
 Q:($Y<(IOSL-6))!($G(DOUT)!$G(DFOUT))
 S:'$D(BARPG("PG")) BARPG("PG")=0
 S BARPG("PG")=BARPG("PG")+1
 I $E(IOST)="C",IOT["TRM" D EOP^BARUTL(0) Q:($G(DIROUT)!$G(DUOUT)!$G(DTOUT)!$G(DROUT))
 ;
Q ;
 Q:($G(DIROUT)!$G(DUOUT)!$G(DTOUT)!$G(DROUT))
 ;
BARHDR ;
 ; Write the Report Header
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
 W !?(IOM-75),BARPG("DT"),?(IOM-15),"PAGE: ",BARPG("PG"),!,BARPG("LINE")
 ;
BARHD ;EP
 ; Write column header / message
 W !
 I BARPG("HDR")'["mmary" D
 . I BARHDRA="N" D
 .. W ?8,"Insurer",?31," Billed Amt ",?45,"Accounted For",?60," Outstanding"
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
