ASUCOHKP ; IHS/ITSC/LMH -UPDATE HOUSEKEEPING ; 
 ;;4.2T2;Supply Accounting Mgmt. System;;JUN 30, 2000
 ;This routine initializes necessary files/variables before any update
 ;run. (Housekeeping)
 S ASUP("CKT")=+$G(ASUP("CKT"))
 ;WAR 6/25/99 REM'D NEXT LINE & ADDED NEXT LINES
 ;S ASUP("CKT")=1 D SETST^ASUCOSTS
 S ASUP("CKT")=1
 I $G(ASUK("HDG","MENU"))["DAILY" S ASUP("CKT")=""
 D SETST^ASUCOSTS
 D DATE^ASUUDATE,TIME^ASUUDATE
 S ASURX="W !,""S.A.M.S. Closeout Housekeeping Procedure Begun "_ASUK("DT","TIME")_"""" D ^ASUUPLOG
 D:$G(ASUN("TYP"))']"" ^ASUURANG
 S:+($G(ASUP("CKP")))=0 ASUP("CKP")=1
 I ASUP("CKP")=1 D  ;Clear deleted masters
 .D IBMCLR Q:$G(ASUP("HLT"))>0  S ASUP("CKP")=2 D SETSP^ASUCOSTS
 I ASUP("CKP")=2 D  ;Clear report files
 .D RPTCLR Q:$G(ASUP("HLT"))>0  S ASUP("CKP")=3 D SETSP^ASUCOSTS
 I ASUP("CKP")=3 D  ;Get beginning balances
 .D BALANCE Q:$G(ASUP("HLT"))>0  S ASUP("CKP")=0 D SETSP^ASUCOSTS
 D DATE^ASUUDATE,TIME^ASUUDATE
 S ASURX="W !,""S.A.M.S. Closeout Housekeeping Procedure Ended "_ASUK("DT","TIME")_"""" D ^ASUUPLOG
 Q
IBMCLR ;CLEAR ISSUE BOOK MASTERS FOR PREVIOUSLY DELETED RECORDS
 D:'$D(U) ^XBKVAR
 S ASURX="W !?3,""Removing Deleted Indexes from Issue Book Masters File""" D ^ASUUPLOG
 K ASUMX S ASUMX("IDX")=""
 F  S ASUMX("IDX")=$O(^ASUMX("B",999999,ASUMX("IDX"))) Q:ASUMX("IDX")']""  Q:ASUMX("IDX")["999999"  D  ;Look at all deleted index masters
 .S ASUMK("SST")=$O(^ASUMK("C",ASUMX("IDX"),"")) ;Find first Sub Station using deleted index
 .Q:ASUMK("SST")']""  ;No Substations using this index
 .S ASUMK("SST")=ASUMK("SST")-1 ;Begin with first substation
 .F  S ASUMK("SST")=$O(^ASUMK("C",ASUMX("IDX"),ASUMK("SST"))) Q:ASUMK("SST")']""  D
 ..S ASUMK("REQ")="" S ASUMK("REQ")=$O(^ASUMK("C",ASUMX("IDX"),ASUMK("SST"),ASUMK("REQ"))) Q:ASUMK("SST")']""  D  ;Find all requsitioners
 ...S ASUC("CLRX")=$G(ASUC("CLRX"))+1
 ...F X=0,1,2 K ^ASUMK(ASUMK("SST"),1,ASUMK("REQ"),1,ASUMX("IDX"),X)
 ...K ^ASUMK(ASUMK("SST"),1,ASUMK("REQ"),1,"B",ASUMX("IDX"),ASUMX("IDX"))
 ...K ^ASUMK("C",ASUMX("IDX"),ASUMK("SST"),ASUMK("REQ"),ASUMX("IDX"))
 ...S ASUC("IDX")=$P(^ASUMK(ASUMK("SST"),1,ASUMK("REQ"),1,0),U,4)
 ...S ASUC("IDX")=ASUC("IDX")-1
 ...S $P(^ASUMK(ASUMK("SST"),1,ASUMK("REQ"),1,0),U,4)=ASUC("IDX")
 ...I ASUC("IDX")=0 D
 ....S X=$O(^ASUMK(ASUMK("SST"),1,ASUMK("REQ"),1,0))
 ....Q:X]""
 ....S ASUC("CLRU")=$G(ASUC("CLRU"))+1
 ....K ^ASUMK(ASUMK("SST"),1,ASUMK("REQ"))
 ....K ^ASUMK(ASUMK("SST"),1,"B",ASUMK("REQ"),ASUMK("REQ"))
 ....S ASUC("REQ")=$P(^ASUMK(ASUMK("SST"),1,0),U,4)
 ....S ASUC("REQ")=ASUC("REQ")-1
 ....S $P(^ASUMK(ASUMK("SST"),1,0),U,4)=ASUC("REQ")
 ....I ASUC("REQ")=0 D
 .....I X']"" S ASURX="W !,""Sub Station "_ASUMK("SST")_" may be deleted""" D ^ASUUPLOG
 S ASURX="W !?10,"_+($G(ASUC("CLRX")))_","" Issue Book Index Master Records Cleared""" D ^ASUUPLOG
 S ASURX="W !?10,"_+($G(ASUC("CLRU")))_","" Issue Book User Master Records Cleared""" D ^ASUUPLOG
 K ASUC("CLRX"),ASUC("IDX"),ASUMK,ASURX
 Q
 S ASUV("IDX")="" ;K ^ASUD("DIX")
 F  S ASUV("IDX")=$O(^ASUMX("D",ASUV("IDX"))) Q:ASUV("IDX")']""  D
 .S ASUMX("E#","IDX")=$O(^ASUMX("D",ASUV("IDX"),""))
 .Q:$P(^ASUMX(ASUMX("E#","IDX"),2),U,3)]""
 .D READ^ASUMXDIO S ASUMX("DELDT")=ASUK("DT","FM") D WRITE^ASUMXDIO
 .;S ^ASUD("DIX",ASUMX("E#","IDX"))=""
RPTCLR ;UPDATE CLEAR REPORT GLOBALS
 ;This sub-routine clears the XTMP globals which contain pointers to
 ;data to be placed on the reports to be created for this closeout.
 S ASURX="W !?3,""Clearing Report and Beginning Balance Files""" D ^ASUUPLOG
 K ^XTMP("ASUMA")
 S ASUV("RDT")=$E(ASUK("DT","FM"),1,5)+100_"01"_U_ASUK("DT","FM") S ^XTMP("ASUMA",0)=ASUV("RDT")
 N X F X="70","7I","71","72","73","01","07","08","09","10A","10","11","13" D
 .S X="R"_X K ^XTMP("ASUR",X) S ^XTMP("ASUR",X,0)=ASUV("RDT")
 I $G(ASUP("TYP"))=1,$G(ASUP("OLIB"))]"" D VOUCHER
 Q
VOUCHER ;RESET VOUCHER NUMBER
 S $P(^ASUSITE(1,1),U,8)=$P(^ASUSITE(1,3),U,8)
 Q
BALANCE ;UPDATE ACTIVE/INACTIVE OPENING BALANCE FILE AND REPORT 1 BALANCES
 D SELSTA,LOADDAY
 D ^ASUMCUPD
 Q
SELSTA ;
 S (ASUC("STA"),ASUC("ACT"))=0
 S (ASUMX("E#","IDX"),ASUMS("E#","STA"))=0
 S ASURX="W !?3,""Getting Beginning Balances (R11) and Counts (R1)""" D ^ASUUPLOG
 I $G(ASUL(2,"STA","E#"))]"" S ASUMS("E#","STA")=ASUL(2,"STA","E#") D MSTLOOP Q
 F  S ASUMS("E#","STA")=$O(^ASUMS(ASUMS("E#","STA"))) Q:ASUMS("E#","STA")'?5N  D MSTLOOP
 Q
MSTLOOP ;
 K ^XTMP("ASUMA")
 S ASURX="W !?3,""Cataloging All Masters""" D ^ASUUPLOG
 S ASUMS("E#","IDX")=0
 F  S ASUMS("E#","IDX")=$O(^ASUMS(ASUMS("E#","STA"),1,ASUMS("E#","IDX"))) Q:ASUMS("E#","IDX")'?8N  D
 .I $P(^ASUMS(ASUMS("E#","STA"),1,ASUMS("E#","IDX"),0),U)[999999 Q  ;Deleted master
 .S ASUMX("E#","IDX")=ASUMS("E#","IDX")
 .D ^ASUMXDIO,^ASUMSTRD ;Read Index and Station masters
 .S ^XTMP("ASUMA",ASUMS("E#","STA"),ASUL(9,"ACG"),ASUMS("E#","IDX"))=""
 .S ^TMP("ASUMC",$J,ASUL(9,"ACC"),ASUMS("E#","IDX"))=""
 Q
LOADDAY ;
 S ASURX="W !?3,""Getting Today's Master Beginning Balances""" D ^ASUUPLOG
 S ASUMS("E#","STA")=ASUL(2,"STA","E#")
 D:$G(ASUN("TYP"))']"" RANGE^ASUURANG(1)
 D LOAD(.ASUN)
 Q
LOAD(Y) ;EP; LOAD BEGINNING BALANCES
 S Y("ACC")=0
 F  S Y("ACC")=$O(^XTMP("ASUMA",ASUMS("E#","STA"),Y("ACC"))) Q:Y("ACC")']""  D
 .S Y("IDX")=0
 .F  S Y("IDX")=$O(^XTMP("ASUMA",ASUMS("E#","STA"),Y("ACC"),Y("IDX"))) Q:Y("IDX")']""  D
 ..N X S X=^XTMP("ASUMA",ASUMS("E#","STA"),Y("ACC"),Y("IDX"))
 ..I Y("B#")]"" D
 ...I $D(^ASUH("I",Y("IDX"),Y("B#"))) S Y=Y("B#")
 ...E  S Y=$O(^ASUH("I",Y("IDX"),Y("B#"))) ;First tran today
 ..E  S Y=""
 ..I Y]"",Y'>Y("E#") S X="A",X("DA")=Y
 ..E  S X="I"
 ..I Y("B#")]"" D
 ...S Y=$O(^ASUH("I",Y("IDX"),Y("B#")),-1) ;Most recent tran
 ..E  S Y=""
 ..I Y]"" S ASUFB=1
 ..E  S ASUFB=0 S:X="A" Y=$G(X("DA"))
 ..I Y?1N.N D
 ...Q:$P(^ASUH(Y,0),U,3)'=ASUL(2,"STA","E#")
 ...D READ^ASU0TRRD(.Y,"H")
 ...Q:ASUT("TYPE")=7  ;Direct issue - not masters
 ...S X("VAL")=(+ASUT(ASUT,"MST","VAL"))
 ...S X("QTY")=(+ASUT(ASUT,"MST","QTY"))
 ...S X("D/I")=(+ASUT(ASUT,"MST","D/I"))
 ...S X("ACC")=ASUT(ASUT,"ACC")
 ...I ASUFB=0 D  ;First of current day's transaction being used
 ....Q:ASUT("TYPE")=4  Q:ASUT("TYPE")=5  ;Index and Station masters - no effect on balance
 ....I ASUT("TYPE")=1 S X("D/I")=X("D/I")-(ASUT(ASUT,"QTY")*ASUT(ASUT,"SIGN")) Q  ;Due in - due in quantity effected
 ....I ASUT("TYPE")=3 S X("QTY")=X("QTY")-(ASUT(ASUT,"QTY","ISS")*ASUT(ASUT,"SIGN")),X("VAL")=X("VAL")-(ASUT(ASUT,"VAL")*ASUT(ASUT,"SIGN")) Q  ;Issue - Quantity and Value effected
 ....S X("QTY")=X("QTY")-(ASUT(ASUT,"QTY")*ASUT(ASUT,"SIGN")),X("VAL")=X("VAL")-(ASUT(ASUT,"VAL")*ASUT(ASUT,"SIGN")) ;Receipt,Adjustments and Transfers - Quantity and Value effected
 ..E  D
 ...K ASUMS,ASUMX D IDX^ASUMXDIO(Y("IDX")),READ^ASUMSTRD(Y("IDX"))
 ...S X("VAL")=+ASUMS("VAL","O/H"),X("QTY")=+ASUMS("QTY","O/H"),X("D/I")=+ASUMS("D/I","QTY-TOT"),X("ACC")=$G(ASUMX("ACC")) ;Save balances from Station master
 ..I Y("TYP")="1" D
 ...S X=X_U_$G(X("VAL"))_U_$G(X("QTY"))_U_$G(X("D/I"))_U_$S($G(X("ACC"))]"":X("ACC"),1:Y("ACC"))_U_$G(X("DA"))_U_$G(ASUFB)
 ...S ^XTMP("ASUMA",ASUMS("E#","STA"),ASUL(9,"ACG"),Y("IDX"))=X
 ..E  D
 ...S ^TMP("ASUMC",$J,ASUL(9,"ACC"),Y("IDX"))=$G(X("VAL"))
 Q
