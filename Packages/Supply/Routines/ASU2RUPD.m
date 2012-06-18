ASU2RUPD ; IHS/ITSC/LMH -POST RECEIPTS ;  
 ;;4.2T2;Supply Accounting Mgmt. System;;JUN 30, 2000
 ;;This routine posts Receipt transaction data to SAMS masters.
 ;;It is invoked after the transaction is saved in Screenman.
 ;; Requires local arrays ASUT, ASUS and ASUM
 S:$G(DDSREFT)']"" DDSREFT=$G(ASUV("DDSREFT"))
 I $G(ASUS("PO#"))']"" N Z S Z=$G(ASUT(ASUT,"PON")) D POCK(.Z) Q:$G(DDSERROR)
 ;I ASUT(ASUT,"FPN")="P"!(ASUT("TRCD")="26") D:$G(ASUS("QVP"))="" POM I $G(DDSERROR) D QTY^ASUJCLER Q
 S ASUS("PO#")=$G(ASUS("PO#")),ASUS("PO#")=+ASUS("PO#")
 I ASUS("PO#")>0 D
 .I ASUS("PO#")=2 D
 ..S ASUMS("D/I","QTY",ASUV("PO#"))=""
 ..S ASUMS("D/I","VAL",ASUV("PO#"))=""
 ..S ASUMS("D/I","PO#",ASUV("PO#"))=""
 ..S ASUMS("D/I","DT",ASUV("PO#"))=""
 ..S ASUMS("D/I","SSA",ASUV("PO#"))=""
 ..S ASUMS("D/I","DTR72",ASUV("PO#"))=""
 .E  D
 ..S ASUMS("D/I","QTY",ASUV("PO#"))=ASUMS("D/I","QTY",ASUV("PO#"))-ASUT(ASUT,"QTY")
 ..S ASUMS("D/I","VAL",ASUV("PO#"))=ASUMS("D/I","VAL",ASUV("PO#"))-ASUT(ASUT,"VAL")
 I $E(ASUT("TRCD"),2)?1A D  Q:$G(ASUF("ERR"))>0
 .I ASUMS("QTY","O/H")<ASUT(ASUT,"QTY") D  Q
 ..S ASUF("ERR")=1,DDSERROR=1,Z="Not enough Quantity On Hand - Receipt reversal of  "_ASUT(ASUT,"QTY")_" would cause credit balance"
 ..S ASUT(ASUT,"QTY")=0 S:$G(DIE)']"" DIE=$G(ASUJ("GLOB"))
 ..D MSG^ASUJHELP(Z),QTY^ASUJSAVE(ASUT(ASUT,"QTY"))
 .I ASUMS("VAL","O/H")<ASUT(ASUT,"VAL") D  Q
 ..S ASUF("ERR")=1,DDSERROR=1,Z="Not enough Value On Hand - Receipt reversal of  "_ASUT(ASUT,"VAL")_" would cause credit balance"
 ..S ASUT(ASUT,"VAL")=0 S:$G(DIE)']"" DIE=$G(ASUJ("GLOB"))
 ..D MSG^ASUJHELP(Z),VAL^ASUJSAVE(ASUT(ASUT,"VAL"))
 S ASUMS("VAL","O/H")=ASUMS("VAL","O/H")+(ASUT(ASUT,"VAL")*ASUT(ASUT,"SIGN"))
 S ASUMS("QTY","O/H")=ASUMS("QTY","O/H")+(ASUT(ASUT,"QTY")*ASUT(ASUT,"SIGN"))
 I ASUT("TRCD")=22,ASUT(ASUT,"SRC")=ASUMS("SRC") D
 .I +ASUT(ASUT,"QTY")>0,+ASUT(ASUT,"VAL")>0 D
 ..S ASUMS("LPP")=$FN((ASUT(ASUT,"VAL")/ASUT(ASUT,"QTY")),"-",2)
 S ASUF("SV")=2 D ^ASUJHIST ;Move transaction to History file
 I ASUMS("QTY","O/H")>0,ASUMS("D/O","QTY")>0 D
 .D EN^ASU3BKOR(ASUMS("E#","IDX"))
 S ASUS("ADD")=0 D ^ASUMSTWR
 K ASUV("PO#"),ASUS("PO#")
 Q
POCK(X) ;EP; PO# Check
 Q:ASUT(ASUT,"FPN")']""  Q:X']""
 S:'$L($G(ASUS("PO#"))) ASUS("PO#")=0
 Q:X=$G(ASUV("PON"))  S ASUV("PON")=X
 D POCK^ASUJHELP
 I ASUT(ASUT,"FPN")="F" D
 .F ASUV("PO#")=1:1:3 D
 ..I ASUMS("D/I","PO#",ASUV("PO#"))=X D
 ...D POMATCH^ASUJHELP
 ...S ASUS("PO#")=2
 ...S ASUT(ASUT,"D/IF")=ASUMS("D/I","QTY",ASUV("PO#"))*-1
 ...I ASUT("TRCD")'=26 D POM
 E  D
 .F ASUV("PO#")=1:1:3 D
 ..I ASUMS("D/I","PO#",ASUV("PO#"))=X D
 ...D POMATCH^ASUJHELP
 ...S ASUT(ASUT,"D/IF")=0
 ...I ASUT("TRCD")'=26 D POM
 D PLSCONT^ASUJHELP
 Q
POM ;Purchase order match
 I (ASUT(ASUT,"QTY")'="")&(ASUT(ASUT,"VAL")'="") D  ;any valu & any valu
 .S ASUS("QVP")=1
 .I ASUMS("D/I","QTY",ASUV("PO#"))-ASUT(ASUT,"QTY")>0&((ASUMS("D/I","VAL",ASUV("PO#"))-ASUT(ASUT,"VAL"))>0) D  ;Value
 ..S ASUT(ASUT,"D/IF")=0
 ..I ASUMS("D/I","QTY",ASUV("PO#"))-ASUT(ASUT,"QTY")=0 D  ;Qty
 ...S ASUS("PO#")=2
 ..E  D
 ...S ASUS("PO#")=1
 .E  D
 ..D RECQTY^ASUJHELP,QTY^ASUJCLER,VAL^ASUJCLER
 Q
