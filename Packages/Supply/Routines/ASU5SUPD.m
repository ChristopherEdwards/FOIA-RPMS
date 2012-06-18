ASU5SUPD ; IHS/ITSC/LMH -POST STATION MASTER CHANGE ; 
 ;;4.2T2;Supply Accounting Mgmt. System;;JUN 30, 2000
 ;;This routine provides logic to post STATION MASTER records to
 ;;the database
 S:$G(DDSREFT)']"" DDSREFT=$G(ASUV("DDSREFT"))
 I $E(ASUT,3)="A" D ADD
 I $E(ASUT,3)="B" D USERLEVL
 I $E(ASUT,3)="C" D CHANGE
 I $E(ASUT,3)="D" D DELETE
 Q:$D(DDSERROR)
 D ^ASUJHIST
 K ASUS("ADD")
 Q
ADD ;Add station master record
 N X
 S ASUMS("E#","STA")=ASUT(ASUT,"PT","STA")
 D S^ASUMSTRD ;Read Station portion of Station master into variables
 I $G(Y)<0 D
 .S X=ASUT(ASUT,"PT","STA")
 .D DIS^ASUMDIRA(.X) ;Add new Station if not on file
 S (X,ASUMS("E#","IDX"))=ASUT(ASUT,"PT","IDX")
 D DISX^ASUMDIRA(.X) ;Add new Index to station
 ;Read Index portion of Station master - new record (null variables)
 D ^ASUMSTRD
 ;Set Station index record fields from transaction
 S ASUMS("ESTB")=ASUT(ASUT,"DTS")
 S ASUMS("ORD#")=ASUT(ASUT,"ORD#")
 S ASUMS("SRC")=ASUT(ASUT,"SRC")
 S ASUMS("LTM")=ASUT(ASUT,"LTM")
 S ASUMS("RPQ-O")=ASUT(ASUT,"RPQ")
 S ASUV("RPQ")=ASUMS("LTM")+1
 S ASUMS("PMIQ")=ASUMS("RPQ-O")/ASUV("RPQ")
 S ASUMS("PMIQ")=$J(ASUMS("PMIQ"),0,0)
 S ASUMS("RPQ")=ASUT(ASUT,"RPQ")
 S ASUMS("EOQ","TB")=$S($G(ASUL(2,"STA","EOQTBL")):ASUL(2,"STA","EOQTBL"),1:50)
 S ASUMS("EOQ","MM")=ASUT(ASUT,"EOQ MM")
 S ASUMS("EOQ","QM")=ASUT(ASUT,"EOQ QM")
 S ASUMS("EOQ","AM")=ASUT(ASUT,"EOQ AM")
 S ASUMS("LSTISS")=""
 S ASUMS("VENAM")=ASUT(ASUT,"VEN NM")
 S ASUMS("LPP")=ASUT(ASUT,"UCS")
 S ASUMS("SLC")=ASUT(ASUT,"SLC")
 S ASUMS("VENUI")=ASUT(ASUT,"SUI")
 S ASUMS("SFSKM")="1.0"
 S ASUMS("EOQ","TP")=ASUT(ASUT,"EOQ TYP")
 S ASUMS("SPQ")=ASUT(ASUT,"SPQ")
 ;Initialize Usage statistic counters (12 months)
 F ASUU(11)=1:1:12 D
 .S (ASUMS("DMD","CALL",ASUU(11)),ASUMS("DMD","QTY",ASUU(11)))=0
 K ASUU(11)
 S ASUS("ADD")=1
 ;Write new Station Index record
 D ^ASUMSTWR
 Q
 ;Set Beginning Balance statistics for Station Index
USERLEVL ;User Level change transaction
 I $E(ASUT,3)="B" D
 .I ASUT(ASUT,"ULVQTY")]"" D ^ASUMKBPS
 Q
CHANGE ;Change station master transaction
 S ASUSV("FL#")="9002036.5"
 ;Update Station Index master fields from Transaction
 I ASUT(ASUT,"EOQ TYP")]"" D
 .S ASUMS("EOQ","TP")=ASUT(ASUT,"EOQ TYP")
 .S (ASUMS("EOQ","MM"),ASUMS("EOQ","QM"),ASUMS("EOQ","AM"))=""
 S:ASUT(ASUT,"SLC")]"" ASUMS("SLC")=ASUT(ASUT,"SLC")
 S ASUMS("ESTB")=ASUT(ASUT,"DTS")
 S:ASUT(ASUT,"EOQ MM")]"" ASUMS("EOQ","MM")=ASUT(ASUT,"EOQ MM")
 S:ASUT(ASUT,"ORD#")]"" ASUMS("ORD#")=ASUT(ASUT,"ORD#")
 S:ASUT(ASUT,"SRC")]"" ASUMS("SRC")=ASUT(ASUT,"SRC")
 S:ASUT(ASUT,"UCS")>0 ASUMS("LPP")=ASUT(ASUT,"UCS")
 S:ASUT(ASUT,"LTM")]"" ASUMS("LTM")=ASUT(ASUT,"LTM")
 S:ASUT(ASUT,"SUI")]"" ASUMS("VENUI")=ASUT(ASUT,"SUI")
 S:ASUT(ASUT,"SPQ")]"" ASUMS("SPQ")=ASUT(ASUT,"SPQ")
 I ASUT(ASUT,"RPQ")]"" D
 .S ASUMS("RPQ")=ASUT(ASUT,"RPQ")
 .S ASUV("RPM")=ASUMS("LTM")+ASUMS("SFSKM")
 .S ASUMS("PMIQ")=ASUT(ASUT,"RPQ")/ASUV("RPM")
 .S ASUMS("PMIQ")=$J(ASUMS("PMIQ"),0,0)
 S:ASUT(ASUT,"VEN NM")]"" ASUMS("VENAM")=ASUT(ASUT,"VEN NM")
 S:ASUT(ASUT,"EOQ QM")]"" ASUMS("EOQ","QM")=ASUT(ASUT,"EOQ QM")
 S:ASUT(ASUT,"EOQ AM")]"" ASUMS("EOQ","AM")=ASUT(ASUT,"EOQ AM")
 D MIX^ASUMSTWR ;Write updated Station Index master record
 Q
DELETE ;Delete station master trans
 ;S ASUMS("E#","STA")=$O(^ASUMS("C",ASUMS("E#","IDX"),""))  ;CSC 1-14-99
 S ASUSV("FL#")="9002036.5"
 ;S ASUMS(0)=^ASUMS(ASUMS("E#","STA"),1,ASUMS("E#","IDX"),0)
 ;S ASUMS(2)=^ASUMS(ASUMS("E#","STA"),1,ASUMS("E#","IDX"),2)
 ;I $P(ASUMS(0),U,16)!($P(ASUMS(0),U,17))!($P(ASUMS(0),U,18))!($P(ASUMS(0),U,28)) D  Q  ;Balance was on hand -Reject Transaction
 ;.W *7 D MSG^ASUJHELP("Delete Unsucessful - BAL O/H") S DDSERROR=2 ;DFM P1 9/1/98
 ;I $P(ASUMS(2),U,2)>0 D  Q  ;Backorder was on file -Reject Transaction
 ;.W *7 D MSG^ASUJHELP("Delete Unsucessful -Back/Order O/H") S DDSERROR=1 ;DFM P1 9/1/98
 ;Q:$D(DDSERROR)
 D D^ASUMSTWR ;Station Index record may be cleared of information
 Q
 ;
 Q:$D(DDSERROR)
 D ^ASUJHIST ;Move transaction to History file
 K ASUS("ADD")
 Q
