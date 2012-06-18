ASURO3UT ; IHS/ITSC/LMH -FILEMAN UTILITY REPORTS 3* ; 
 ;;4.2T2;Supply Accounting Mgmt. System;;JUN 30, 2000
 ;This routine is a utility used by FileMan templates which create
 ;the 30's series report.  It provides entry points for Printing Totals
 ;and Printing Index Description fields
 Q:'$D(D0)  Q:'$D(D1)
 Q:D0'?1N.N  Q:D1'?1N.N
 S ASUC("MSTRS")=$G(ASUC("MSTRS"))+1 ;COUNT TIMES ENTERED
 I $P(^ASUMS(D0,1,D1,0),U,3)?13N.AN S ASUC("NSN")=$G(ASUC("NSN"))+1
 Q
PRINT ;EP;PRINT TOTALS
 I $D(IOF) W @IOF
 W "REPORT #",$E($P(XQY0,U,2),2,$L($P(XQY0,U,2)))
 W ?80,"DATE ",ASUK("DT")
 W !,"AREA",?9,ASUL(1,"AR","NM"),!!
 F ASUC=1:1:132 W "_"
 W !!?50,"REPORT TOTAL STATISTICS",!!
 W !!?25,"NUMBER OF AREA/STATION MASTERS PROCESSED      : ",$J($FN($S($G(ASUC("MSTRS"))="":0,1:ASUC("MSTRS")),","),9)
 W !!?25,"NUMBER OF MASTERS WITH NATIONAL STOCK NUMBERS : ",$J($FN($S($G(ASUC("NSN"))="":0,1:ASUC("NSN")),","),9)
 K ASUC("MSTRS"),ASUC("NSN")
 Q
DESC ;EP;SET UP DESCRIPTION
 I $D(^ASUMX(D1,1,0)) D
 .K ^UTILITY($J,"W")
 .S DIWL=1,DIWR=20,DIWF="C30"
 .S ASUC("D1")=$P(^ASUMX(D1,1,0),U,3)
 .F ASUC("D2")=1:1:ASUC("D1") S X=^ASUMX(D1,1,ASUC("D2"),0) D
 ..D ^DIWP
 .F ASUC("D3")=0:0 S ASUC("D3")=$O(^UTILITY($J,"W",DIWL,ASUC("D3"))) Q:ASUC("D3")']""  D
 ..S ASU1(ASUC("D3"))=^UTILITY($J,"W",DIWL,ASUC("D3"),0)
 .S ASUC("D")=$G(ASUC("D"))+ASUC("D3")
 E  D
 .S ASU1(1)=$P(^ASUMX(D1,0),U,2)
 .S ASU1(2)=$P(^ASUMX(D1,0),U,3)
 .S ASUC("D")=2
 K ASUC("D2")
 W ?10,ASU1(1)
 K ASUC("D1"),ASUC("D2"),ASUC("D3"),DIWL,DIWR
 Q
WDESC ;EP;WRITE WORD PROCESSING DESCRIPTION
 Q:ASUC("D")<3
 F ASUC("D2")=3:1:ASUC("D") W !?10,ASU1(ASUC("D2"))
 K ASUC("D"),ASUC("D2"),ASU1
 Q
