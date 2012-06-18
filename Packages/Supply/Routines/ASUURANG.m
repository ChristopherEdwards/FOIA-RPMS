ASUURANG ; IHS/ITSC/LMH -RPT 10 -VOUCHER SUMMARY ; 
 ;;4.2T2;Supply Accounting Mgmt. System;;JUN 30, 2000
 ;This routine selects a range of dates for report data
 S DIR(0)="Y",DIR("B")="YES",DIR("A")="Date range for report(s) to be  today's transactions only" D ^DIR Q:$D(DIRUT)
 S X=Y
 D RANGE(X)
 Q
RANGE(X) ;EP ;Set report date range
 S ASUN("TYP")=X
 D:$G(ASUL(2,"STA","E#"))']"" STA^ASULARST($G(ASUL("ST#")))
 S (ASUN("BKY"),ASUN("EKY"))=ASUL(2,"STA","E#")
 I X D
 .S (Y,ASUN("BDT"),ASUN("EDT"))=ASUK("DT","FM")
 .S (ASUN("KEY"),ASUN("BKY"))=ASUN("BKY")_"-"_Y_"-"_"0000000"
 .S ASUN("EKY")=ASUN("EKY")_"-"_$S(X=1:Y,1:$E(Y,1,5)_"32")_"-"_"9999999"
 E  D
 .W !,"Enter report date range"
 .N DIR S DIR(0)="D",DIR("B")="T",DIR("A")="Enter beginning date" D ^DIR Q:$D(DIRUT)
 .Q:Y<0
 .S ASUN("BDT")=Y
 .S (ASUN("KEY"),ASUN("BKY"))=ASUN("BKY")_"-"_Y_"-0000000"
 .S DIR("A")="Enter ending date" D ^DIR Q:$D(DIRUT)
 .Q:Y<0
 .S ASUN("EDT")=Y
 .S ASUN("EKY")=ASUN("EKY")_"-"_Y_"-9999999"
 Q:Y<0
 S ASUN("B#")=$O(^ASUH("B",ASUN("BKY"))),ASUN("E#")=$O(^ASUH("B",ASUN("EKY")),-1)
 Q:ASUN("B#")=""  Q:ASUN("E#")=""
 S ASUN("B#")=$O(^ASUH("B",ASUN("B#"),"")),ASUN("E#")=$O(^ASUH("B",ASUN("E#"),"")),ASUHDA=ASUN("B#")-1
 Q
