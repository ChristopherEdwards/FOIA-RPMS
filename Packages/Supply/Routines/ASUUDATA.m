ASUUDATA ; IHS/ITSC/LMH -NO DATA FOR RPT ; 
 ;;4.2T2;Supply Accounting Mgmt. System;;JUN 30, 2000
 ;This routine is a utility which may be called by certain print
 ;templates to check and see if data exists for the sort parameters
 ;supplied for the report.  It not, a 'No data for Report' message is
 ;written.
 N X,X1,Y
 S Y=$G(^XTMP("ASUR",ASUV("RPT"),0)) S Y=$P(Y,U,2) S:Y']"" Y=$G(DT) X ^DD("DD")
 S ASUX("DT")=Y S:ASUX("DT")']"" ASUX("DT")=$G(ASUK("DT"))
 S (ASUC("PG"),ASUX("NDTA"))=0,ASUX("AS")=$O(^XTMP("ASUR",ASUV("RPT"),0))
 I ASUV("RPT")="R08"!(ASUV("RPT")="R06")!(ASUV("RPT")="R83")!(ASUV("RPT")="R23") D  Q
 .I ASUX("AS")']"" D NODATA Q
 .S ASUV("AR")=$E(ASUX("AS"),1,2) D @ASUQ("HDR")
 I $L(ASUX("AS"))=4 S ASUX("AS")=$E(ASUX("AS"),1,2)_0_$E(ASUX("AS"),3,4)
 I ASUX("AS")]"",$L(ASUX("AS"))=5 D
 .K ASUL(2,"STA","CD")
 .S X=$E(ASUX("AS"),1,2),X1=$E(ASUX("AS"),4,5) D STAT^ASULARST
 .I ASUV("RPT")="R11" D
 ..D DIS^ASUMDIRM($E(ASUX("AS"),3,$L(ASUX("AS"))))
 ..S ASUX("AG")=$O(^XTMP("ASUR",ASUV("RPT"),ASUX("AS"),""))
 .D @ASUQ("HDR")
 .S ASUV("ARST")=ASUX("AS"),ASUX("AS")=0
 E  D
 .S X=ASUL(1,"AR","AP")
 .I $D(ASUL(1,"AR","STA1")) D
 ..S X1=ASUL(1,"AR","STA1")
 .E  D
 ..S Y=$O(^ASUMS(0))
 ..I Y']"" D
 ...S ASUL(2,"STA","CD")="UK"
 ...S ASUL(2,"STA","NM")="UNKNOWN"
 ..E  D
 ...S X1=$P($G(^ASUMS(X,0)),U)
 .I $D(X1) D STAT^ASULARST
 .S:ASUV("RPT")="R11" ASUX("AG")="N/A"
 .D NODATA
 Q
NODATA ;
 N X
 D @ASUQ("HDR")
 S X=$P(ASUV("RPT"),"R",2) S:$E(X)=0 X=$E(X,2,$L(X))
 W !!,"NO DATA FOR REPORT ",X
 S ASUX("NDTA")=1
 Q
