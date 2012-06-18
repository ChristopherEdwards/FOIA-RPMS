ABMDEAD3 ; IHS/ASDST/DMJ - Manually Add Claim - Rx Data ;
 ;;2.6;IHS 3P BILLING SYSTEM;;NOV 12, 2009
 ;
 S ABMA("OUT")=0,ABMA=ABMP("VDT")-1 F  S ABMA=$O(^PSRX("AD",ABMA)) Q:'ABMA  D  Q:ABMA("OUT")
 .Q:ABMA<ABMP("VDT")
 .I $D(ABMP("DDT")),ABMA>ABMP("DDT") S ABMA("OUT")=1 Q
 .I '$D(ABMP("DDT")),ABMA>ABMP("VDT") S ABMA("OUT")=1 Q
 .S ABMA("R")=0 F  S ABMA("R")=$O(^PSRX("AD",ABMA,ABMA("R"))) Q:'ABMA("R")  Q:'$D(^PSRX(ABMA("R"),0))  I $P(^(0),U,2)=ABMP("PDFN") S ABMA(0)=^(0),ABMA(2)=^(2) D V1
 G XIT
 ;
V1 S (DINUM,X)=$P(ABMA(0),U,6)
 S DIC("DR")=".02////"_250_";.03////"_$P(ABMA(0),U,7)_";.06////"_$P(ABMA(0),U)
 Q
 ;
XIT K ABMA
 Q
