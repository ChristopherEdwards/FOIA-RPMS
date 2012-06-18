ASURDRNG ; IHS/ITSC/LMH -RPT 10 -VOUCHER SUMMARY ; 
 ;;4.2T2;Supply Accounting Mgmt. System;;JUN 30, 2000
 ;This routine selects a range of dates for report data
 D:$G(ASUL(2,"STA","E#"))']"" STA^ASULARST($G(ASUL("ST#")))
 S (ASURR("RNG","BEG"),ASURR("RNG","END"))=ASUL(2,"STA","E#")
 S DIR(0)="Y",DIR("B")="YES",DIR("A")="Create report(s) for today's transactions" D ^DIR Q:$D(DIRUT)
 I Y D
 .S ASURR("RNG","BEG")=ASURR("RNG","BEG")_"-"_ASUK("DT","FM")_"-"_"0000000"
 .S ASURR("RNG","END")=ASURR("RNG","END")_"-"_ASUK("DT","FM")_"-"_"9999999"
 E  D
 .N DIR S DIR(0)="D",DIR("B")="T",DIR("A")="Enter beginning date" D ^DIR Q:$D(DIRUT)
 .S ASURR("RNG","BEG")=ASURR("RNG","BEG")_"-"_Y_"-0000000"
 .S DIR("A")="Enter ending date" D ^DIR Q:$D(DIRUT)
 .S ASURR("RNG","END")=ASURR("RNG","END")_"-"_Y_"-9999999"
 S ASURR("BEG")=$O(^ASUH("B",ASURR("RNG","BEG"))),ASURR("END")=$O(^ASUH("B",ASURR("RNG","END")),-1)
 Q:ASURR("BEG")=""  Q:ASURR("END")=""
 S ASURR("BEG")=$O(^ASUH("B",ASURR("BEG"),"")),ASURR("END")=$O(^ASUH("B",ASURR("END"),"")),ASUTDA=ASURR("BEG")-1
 Q
