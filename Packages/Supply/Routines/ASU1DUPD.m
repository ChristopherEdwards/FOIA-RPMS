ASU1DUPD ; IHS/ITSC/LMH -POST DUE IN ;  
 ;;4.2T2;Supply Accounting Mgmt. System;;JUN 30, 2000
 ;;This routine posts Due In transaction data to SAMS masters.
 ;;It is involked after a valid due in is entered.
 ;; - Requires local arrays ASUT AND ASUV
 S:$G(DDSREFT)']"" DDSREFT=$G(ASUV("DDSREFT"))
 I $E(ASUT("TRCD"),2)?1N D
 .S ASUV("PO#")=0 D
 ..I ASUMS("D/I","PO#",1)']"" S ASUV("PO#")=1 Q
 ..I ASUMS("D/I","PO#",2)']"" S ASUV("PO#")=2 Q
 ..I ASUMS("D/I","PO#",3)']"" S ASUV("PO#")=3 Q
 .;I 'ASUV("PO#")&($G(ASUT(ASUT,"PON"))'="") S ASUV("PO#")=1  ;WAR 7/28/99
 .Q:ASUV("PO#")=0
 .S ASUMS("D/I","QTY",ASUV("PO#"))=ASUT(ASUT,"QTY")
 .S ASUMS("D/I","VAL",ASUV("PO#"))=ASUT(ASUT,"VAL")
 .S ASUMS("D/I","PO#",ASUV("PO#"))=ASUT(ASUT,"PON")
 .S ASUMS("D/I","DT",ASUV("PO#"))=ASUT(ASUT,"DTD")
 .S ASUMS("D/I","SSA",ASUV("PO#"))=ASUT(ASUT,"SSA")
 E  D
 .S ASUV("PO#")=0 D
 ..I ASUT(ASUT,"PON")=ASUMS("D/I","PO#",1) S ASUV("PO#")=1 Q
 ..I ASUT(ASUT,"PON")=ASUMS("D/I","PO#",2) S ASUV("PO#")=2 Q
 ..I ASUT(ASUT,"PON")=ASUMS("D/I","PO#",3) S ASUV("PO#")=3 Q
 .;I 'ASUV("PO#")&($G(ASUT(ASUT,"PON"))'="") S ASUV("PO#")=1  ;WAR 7/28/99
 .Q:ASUV("PO#")=0
 .;Purchase order found - set transaction fields to match master then clear the master due in entry out
 .S ASUT(ASUT,"QTY")=ASUMS("D/I","QTY",ASUV("PO#"))
 .S ASUT(ASUT,"D/IF")=ASUMS("D/I","QTY",ASUV("PO#"))*-1
 .S ASUT(ASUT,"VAL")=ASUMS("D/I","VAL",ASUV("PO#"))
 .S ASUT(ASUT,"SSA")=ASUMS("D/I","SSA",ASUV("PO#"))
 .S (ASUMS("D/I","QTY",ASUV("PO#")),ASUMS("D/I","VAL",ASUV("PO#")))=""
 .S ASUMS("D/I","PO#",ASUV("PO#"))=""
 .S ASUMS("D/I","DT",ASUV("PO#"))=""
 .S ASUMS("D/I","SSA",ASUV("PO#"))=""
 Q:ASUV("PO#")=0
 K ASUV("PO#")
 S ASUT(ASUT,"D/IF")=0
 D MIX^ASUMSTWR ;Update Station Master
 D ^ASUJHIST ;Move transaction to History file
 Q
