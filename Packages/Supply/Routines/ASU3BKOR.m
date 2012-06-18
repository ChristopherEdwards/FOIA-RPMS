ASU3BKOR ; IHS/ITSC/LMH -RELEASE BACKORDER ;  
 ;;4.2T2;Supply Accounting Mgmt. System;;JUN 30, 2000
 ;;This routine provides logic for checking all back orders to see if
 ;;they may be released during the update which calls it.
 ;; Requires local arrays ASUC, ASUL, ASUM, ASUMB, ASUT, ASUV
EN(X) ;EP; CHECK FOR BACKORDER FOR INDEX X
 S ASUMB("E#","IDX")=X,ASUMB("E#","QTY")=""
 F  S ASUMB("E#","QTY")=$O(^ASUMB("AC",ASUMB("E#","IDX"),ASUMB("E#","QTY"))) Q:ASUMB("E#","QTY")=""  D
 .S ASUMB("E#","REQ")="" N Z
 .F  S ASUMB("E#","REQ")=$O(^ASUMB("AC",ASUMB("E#","IDX"),ASUMB("E#","QTY"),ASUMB("E#","REQ"))) Q:ASUMB("E#","REQ")=""  D
 ..I '$D(^ASUMB(ASUMB("E#","REQ"),1,ASUMB("E#","IDX"),0)) Q
 ..S ASUM("RMK-B/O")="",ASUT("TRCD")="31",ASUT("TYPE")=3
 ..;S ASUV("TR")=$G(ASUT("TRCD")),ASUV("TP")=$G(ASUT("TYPE")),ASUV("DA")=ASUHDA
 ..D ^ASUMBOIO ;Read Backorder Master
 ..S ASUC("TR")=$G(ASUC("TR"))+1
 ..S ASUT="BOR"
 ..D GENBOR ;Copy Backorder Master fields into Transaction array
 ..S Z="Releasing Backorder for this item. Requested by: "_ASUL(22,"PGM","NM")_" - "_ASUL(20,"REQ","NM")_". For a quantity of: "_ASUMB("QTYB/O") W *7 D MSG^ASUJHELP(Z) ;DFM P1 9/1/98
 ..S X=ASUT(ASUT,"QTY"),Y="" D SPQ^ASU3ISQA(.X,.Y) ;Adjust quantity to standard pack, if aplicable
 ..S ASUT(ASUT,"QTY","ISS")=Y ;use adjusted qty if set
 ..I ASUT(ASUT,"QTY")'=Y D  ;Quantity was adjusted
 ...S ASUT("RMK")="B/O-R ADJ"_ASUT(ASUT,"QTY")-ASUT(ASUT,"QTY","ISS")
 ..I ASUMS("QTY","O/H")<ASUT(ASUT,"QTY","ISS") D  ;Only release qty available (partial)
 ...S ASUT(ASUT,"FPN")="P"
 ...S ASUT(ASUT,"QTY","ISS")=ASUMS("QTY","O/H")
 ...S ASUMS("D/O","QTY")=ASUMS("D/O","QTY")-ASUT(ASUT,"QTY","ISS")
 ...S ASUT(ASUT,"QTY","B/O")=ASUT(ASUT,"QTY","REQ")-ASUT(ASUT,"QTY","ISS")
 ...S ASUT("RMK")="B/O-R PAR"
 ...S Z="Unable to release requested quantity of "_ASUMB("QTYB/O") ;DFM P1 9/1/98
 ...S Z=Z_". A partial release of "_ASUT(ASUT,"QTY","ISS")_" will be made." ;DFM P1 9/1/98
 ...S Z=Z_" A quantity of "_ASUT(ASUT,"QTY","B/O")_" will remain on backorder." ;DFM P1 9/1/98
 ...W *7 D MSG^ASUJHELP(Z) ;DFM P1 9/1/98
 ...D BORESET
 ...S DA(1)=ASUMB("E#","REQ"),DA=ASUMB("E#","IDX")
 ...D KFAC^ASUMBOIO,KAC^ASUMBOIO ;Kill Master cross references
 ...D WRITEBO^ASUMBOIO  ;Update Backorder Master from transaction array
 ...D SFAC^ASUMBOIO,SAC^ASUMBOIO ;Reset Master cross references
 ..E  D  ;Able to release full qty
 ...S Z="Full release of backorder for a quantity of "_ASUT(ASUT,"QTY","ISS")_" was posted." W *7 D MSG^ASUJHELP(Z) ;DFM P1 9/1/98
 ...S ASUT(ASUT,"FPN")="F" ;Update Master due out qty
 ...S ASUMS("D/O","QTY")=ASUMS("D/O","QTY")-ASUT(ASUT,"QTY","ISS")
 ...D BORESET
 ...S DA=ASUMB("E#","IDX"),DA(1)=ASUMB("E#","REQ"),DIK="^ASUMB("_DA(1)_",1," D ^DIK
 ...I $P(^ASUMB(DA(1),1,0),U,4)=0 D
 ....S DA=ASUMB("E#","REQ"),DIK="^ASUMB(" D ^DIK
 ..S X=ASUK("DT","FM")_"."_ASUK("TIME","F")_"."_DUZ,DIC(0)="L",DIC=9002036.3 D ^DIC
 ..S ASUV(ASUT,"E#")=+Y,ASUT(ASUT,"TRKY")=X
 ..S ASUM("TRTYP")="REGULAR"
 ..D ^ASUMKBPS,^ASUMYDPS
 ..D TR31(ASUV(ASUT,"E#")),UPDATE^ASU3IUPD
 ;K ASUT M ASUT=ASUTS S ASUT("TRCD")=ASUV("TR"),ASUT("TYPE")=ASUV("TP"),ASUHDA=ASUV("DA")
 Q
BORESET ;EP; -RESETS TOTAL VALUE & TOTAL QUANTITY ON BACK ORDERS
 N X S X="" D MSUNCST^ASU6JUPD(.X) S ASUT(ASUT,"UCS")=X,ASUT(ASUT,"VAL")=X*ASUT(ASUT,"QTY","ISS")
 I ASUT(ASUT,"VAL")>ASUMS("VAL","O/H") S ASUT(ASUT,"VAL")=ASUMS("VAL","O/H")
 S ASUT(ASUT,"SIGN")=-1 D SETMOIS^ASU3IUPD
 I ASUT(ASUT,"VAL")>ASUMS("VAL","O/H")!(ASUMS("QTY","O/H")=ASUT(ASUT,"QTY","ISS")) S ASUT(ASUT,"VAL")=ASUMS("VAL","O/H")
 Q
GENBOR ;EP ;GENERATE BACKORDER RELEASE TRANSACTION (31)
 S ASUT("TRCD")=31,ASUT("TYPE")=3
 S ASUT(ASUT,"AR")=ASUL(1,"AR","AP")
 S ASUT(ASUT,"PT","AR")=ASUL(1,"AR","AP")
 S ASUT(ASUT,"PT","STA")=$G(ASUL(2,"STA","E#"))
 S ASUT(ASUT,"ACC")=ASUMB("ACC")
 S ASUT(ASUT,"PT","ACC")=ASUMB("ACC")
 S ASUT(ASUT,"IDX")=ASUMB("IDX")
 S ASUT(ASUT,"PT","IDX")=ASUL(1,"AR","AP")_ASUT(ASUT,"IDX")
 S ASUT(ASUT,"ENTR BY")=DUZ
 S ASUT(ASUT,"DTE")=ASUK("DT","FM")
 S ASUT(ASUT,"DTP")=ASUK("DT","FM")
 S ASUT(ASUT,"DTW")=""
 S ASUT(ASUT,"STATUS")="U"
 S ASUT(ASUT,"SSA")=ASUMB("SSA") D:ASUT(ASUT,"SSA")]"" SSA^ASULDIRR(ASUT(ASUT,"SSA"))
 S ASUT(ASUT,"PT","SSA")=$G(ASUL(17,"SSA","E#"))
 S ASUT(ASUT,"SST")=ASUMB("SST") D:ASUT(ASUT,"SST")]"" SST^ASULDIRR(ASUT(ASUT,"SST"))
 S:$L(ASUT(ASUT,"SST"))=5 ASUT(ASUT,"SST")=$E(ASUT(ASUT,"SST"),4,5)
 S ASUT(ASUT,"PT","SST")=$G(ASUL(18,"SST","E#"))
 S ASUT(ASUT,"USR")=ASUMB("USR") D:ASUT(ASUT,"USR")]"" USR^ASULDIRR(ASUT(ASUT,"USR"))
 S ASUT(ASUT,"PT","USR")=$G(ASUL(19,"USR","E#"))
 D:ASUT(ASUT,"PT","USR")]"" REQ^ASULDIRR(ASUT(ASUT,"PT","USR"))
 S ASUT(ASUT,"PT","REQ")=$G(ASUL(20,"REQ","E#"))
 S ASUT(ASUT,"REQ")=$G(ASUL(20,"REQ"))
 S ASUT(ASUT,"PT","EOQ TYP")=""
 S ASUT(ASUT,"CALCED")=1
 S ASUT(ASUT,"DTR")=ASUK("DT","FM")
 S ASUT(ASUT,"VOU")=ASUMB("VOU")
 S (ASUT(ASUT,"QTY","REQ"),ASUT(ASUT,"QTY"))=ASUMB("QTYB/O")
 S ASUT(ASUT,"VAL")=""
 S ASUT(ASUT,"CAN")=ASUMB("CAN")
 S ASUT(ASUT,"B/O")=ASUMB("B/O")
 S ASUT(ASUT,"QTY","ADJ")=ASUMB("QTYAJ")
 S ASUT(ASUT,"CTG")=ASUMB("CTG")
 S ASUT(ASUT,"SLC")=ASUMB("SLC"),ASUT(ASUT,"PT","SLC")=ASUMB("E#","SLC")
 S ASUT(ASUT,"RQN")=ASUMB("RQN")
 S ASUT(ASUT,"REQ TYP")=ASUMB("REQTYP")
 S ASUT(ASUT,"STA")=ASUMB("STA")
 S ASUT(ASUT,"FPN")=ASUMB("FPN")
 S ASUT(ASUT,"UCS")=ASUMB("UCS")
 S ASUT(ASUT,"ORD")=""
 S:'$D(ASUT(ASUT,"PON")) ASUT(ASUT,"PON")=""
 S ASUT(ASUT,"EOQ TYP")=""
 S ASUT(ASUT,"PST")=""
 S ASUT(ASUT,"ISSTY")=3
 S ASUT(ASUT,"SUI")=$G(ASUT(ASUT,"SUI"))
 S ASUT(ASUT,"SRC")=$G(ASUT(ASUT,"SRC"))
 Q
BKORDCAN ;EP;
 ;This routine provides for posting a Cancel Pending Backorder
 ;transaction to the Backorder file.
 S DIC(0)="MXZ",DIC=9002035,X=ASUT(ASUT,"PT","REQ") D ^DIC
 I Y<0 S ASUM("RMK")="B/O NOT MATCH" N Z S Z="Unable to cancel Back Order - no match" W *7 D MSG^ASUJHELP(.Z) S DDSERROR=1 Q  ;DFM P1 9/1/98
 I Y>0 S ASUMB("E#","REQ")=+Y D
 .S ASUMB("E#","IDX")=ASUMX("E#","IDX")
 .S ASUMB("QTYB/O")=$P(^ASUMB(ASUMB("E#","REQ"),1,ASUMB("E#","IDX"),0),U,4)
 .S ASUMS("D/O","QTY")=ASUMS("D/O","QTY")-ASUMB("QTYB/O")
 .S:ASUMS("D/O","QTY")'>0 ASUMS("D/O","QTY")=""
 .S $P(^ASUMS(ASUMS("E#","STA"),1,ASUMS("E#","IDX"),2),U,2)=ASUMS("D/O","QTY")
 .S DIE="^ASUMB(ASUMB(""E#"",""REQ""),1,"
 .S DR=".01///@"
 .S DA(1)=ASUMB("E#","REQ")
 .S DA=ASUMB("E#","IDX"),ASUMB(0)=^ASUMB(DA(1),1,DA,0),ASUMB(1)=$G(^ASUMB(DA(1),1,DA,1))
 .K Y D ^DIE
 .I $D(Y) S ASUM("RMK")="B/O NOT CANCELLED" N Z S Z="Unable to cancel Back Order" W *7 D MSG^ASUJHELP(.Z) S DDSERROR=2 ;DFM P1 9/1/98
 .E  S ASUM("RMK")="B/O CANCELLED"
 Q:$G(DDSERROR)>0
 D ^ASUJHIST ;Move transaction to History file
 Q
TR31(X) ;EP ;ADD NEW BACKORDER RELEASE TRANSACTION
 S ASUHDA=X
 S ASUT(ASUT,"STATUS")="U"
 S ASUT(ASUT,"DTW")=""
 S ASUT(ASUT,"DTE")=""
 S ASUT(ASUT,"DTP")=ASUK("DT","FM")
 S ASUT(ASUT,"ISSTY")=3
 S ASUT(ASUT,"PST")=""
 S ASUT(ASUT,"PT","SSA")=$G(ASUL(17,"SSA","E#"))
 S ASUT(ASUT,"PT","SST")=$G(ASUL(18,"SST","E#"))
 S ASUT(ASUT,"PT","USR")=$G(ASUL(19,"USR","E#"))
 S ASUT(ASUT,"PT","REQ")=$G(ASUL(20,"REQ","E#"))
 S ASUT(ASUT,"PT","EOQ TYP")=$G(ASUL(6,"EOQTP","E#"))
 S ASUT(ASUT,"PT","AR")=ASUT(ASUT,"AR")
 S ASUT(ASUT,"PT","STA")=$G(ASUL(2,"STA","E#"))
 S ASUT(ASUT,"PT","ACC")=ASUT(ASUT,"ACC")
 S ASUT(ASUT,"PT","IDX")=ASUT(ASUT,"AR")_ASUT(ASUT,"IDX")
 S ASUT(ASUT,"ENTR BY")=DUZ
 S ASUT(ASUT,"CALCED")=""
 S ASUF("SV")=2
 Q
REINDX ;
 F X=0:0 S X=$O(^ASUMB(X)) Q:X']""  D
 .I X?1A.A K ^ASUMB(X) Q
 .F Y=0:0 S Y=$O(^ASUMB(X,1,Y)) Q:Y']""  D
 ..I Y?1A.A K ^ASUMB(X,1,Y) Q
 ..S Z="AAA" F  S Z=$O(^ASUMB(X,1,Y,1,Z)) Q:Z']""  K ^ASUMB(X,1,Y,1,Z)
 S DIK="^ASUMB(" D IXALL^DIK
 Q
