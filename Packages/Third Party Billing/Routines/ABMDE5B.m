ABMDE5B ; IHS/ASDST/DMJ - PAGE 5B - PROCEDURE PART 2 ; 
 ;;2.6;IHS 3P BILLING SYSTEM;**10,14**;NOV 12, 2009;Build 238
 ;
 ;IHS/DSD/DMJ - 5/12/1999 - NOIS HQW-0599-100027 Patch 2
 ;    Changed mm/dd DOS display to full Charge Date
 ;
 ;IHS/SD/SDR - v2.6 CSV
 ;IHS/SD/SDR - 2.6*14 - ICD10 002H and SNOMED; Also added ICD Indicator options
 ;
 S ABMZ("PG")="5B"
 S ABMZ("TITL")="PROCEDURE VIEW OPTION" D SUM^ABMDE1
 S ABMA("C")=0,ABMA("D")="",$P(ABMA("D"),"-",80)=""
 W !?13,"***** PROCEDURE INFORMATION ENTERED THROUGH PCC *****"
 ;W !,"VISIT",?13,"ICD0"  ;abm*2.6*10 ICD10 002H
 W !,"VISIT",?15,"ICD"  ;abm*2.6*10 ICD10 002H
 ;W !,"DATE",?7,"PRI",?13,"CODE - PROCEDURE DESCRIPTION",?50,"PROVIDER'S NARRATIVE"  ;abm*2.6*10 ICD10 002H
 W !,"DATE",?7,"PRI",?11,"IND",?15,"CODE - PROCEDURE DESCRIPTION",?50,"PROVIDER'S NARRATIVE"  ;abm*2.6*10 ICD10 002H
 ;W !,"=====",?7,"===",?12,"===============================",?45,"=================================="  ;abm*2.6*10 ICD10 002H
 W !,"=====",?7,"===",?11,"===",?15,"===============================",?47,"================================="  ;abm*2.6*10 ICD10 002H
 S ABMA=0 F ABMA("I")=1:1 S ABMA=$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),11,ABMA)) Q:'ABMA  D V1
 I ABMA("I")=1 W *7,!," There are no PCC visits to view."
 I ABMA("C")=0 W *7,!," There are no Procedures Coded in PCC to view."
 D ^ABMDERR
 G XIT
V1 ; view
 S ABMA("V")="" F ABMA("J")=1:1 S ABMA("V")=$O(^AUPNVPRC("AD",ABMA,ABMA("V"))) Q:'ABMA("V")  D POV
 Q
 ;
POV I $D(^AUPNVPRC(ABMA("V"),0)) S ABMA(0)=^(0)
 E  Q
 S ABMA("C")=ABMA("C")+1
 W !,$$SDT^ABMDUTL(+^AUPNVSIT(ABMA,0))
 W !,?7,$S($P(ABMA(0),U,7)="Y":" P",1:" S")
 W ?12,$J($S($P($$ICDOP^ABMCVAPI($P(ABMA(0),U),ABMP("VDT")),U,15)=31:"10",1:"9"),"2R")  ;abm*2.6*14 ICD10 002H
 ;W ?12,$P($$ICDOP^ABMCVAPI($P(ABMA(0),U),""),U,2) S ABMU("TXT")=$P($$ICDOP^ABMCVAPI($P(ABMA(0),U),ABMP("VDT")),U,5),ABMU("LM")=19,ABMU("RM")=43,ABMU("TAB")=4  ;CSV-c  ;abm*2.6.*10 ICD10 002H
 ;W ?15,$P($$ICDOP^ABMCVAPI($P(ABMA(0),U),""),U,2) S ABMU("TXT")=$P($$ICDOP^ABMCVAPI($P(ABMA(0),U),ABMP("VDT")),U,5),ABMU("LM")=22,ABMU("RM")=45,ABMU("TAB")=4  ;CSV-c  ;abm*2.6.*10 ICD10 002H  ;abm*2.6*14 ICD10 002H
 W ?15,$P($$ICDOP^ABMCVAPI($P(ABMA(0),U),""),U,2) S ABMU("TXT")=$P($$ICDOP^ABMCVAPI($P(ABMA(0),U),ABMP("VDT")),U,5),ABMU("LM")=23,ABMU("RM")=45,ABMU("TAB")=6  ;CSV-c  ;abm*2.6.*10 ICD10 002H  ;abm*2.6*14 ICD10 002H
 ;I $P(ABMA(0),U,4)]"" S ABMU("2TXT")=$P(^AUTNPOV($P(ABMA(0),U,4),0),U),ABMU("2LM")=45,ABMU("2RM")=80,ABMU("2TAB")=-2  ;abm*2.6*10 ICD10 002H
 I $P(ABMA(0),U,4)]"" S ABMU("2TXT")=$P(^AUTNPOV($P(ABMA(0),U,4),0),U),ABMU("2LM")=47,ABMU("2RM")=80,ABMU("2TAB")=-2  ;abm*2.6*10 ICD10 002H
 D ^ABMDWRAP
 ;start new code abm*2.6*14 ICD10 SNOMED
 K ABMU
 I +$P($G(^AUPNVPRC(ABMA("V"),0)),U,22)'=0 D
 .W !?10,"Dual ICD-9 Code: ",$P($$ICDOP^ABMCVAPI(+$P($G(^AUPNVPRC(ABMA("V"),0)),U,22),ABMP("VDT")),U,2)
 I +$O(^AUPNVPRC(ABMA("V"),26,0))'=0 D
 .S ABMA("V1")=+$O(^AUPNVPRC(ABMA("V"),26,0))
 .Q:ABMA("V1")=0
 .S IENS=ABMA("V1")_","_ABMA("V")_","
 .W !?17,"SNOMED CT Preferred Term: "
 .S ABMU("TXT")=$$GET1^DIQ(9000010.0826,IENS,".019","E")
 .S ABMU("LM")=43
 .S ABMU("RM")=79
 .D ^ABMDWRAP
 .I +$O(^AUPNVPRC(ABMA("V"),26,ABMA("V1")))>1 W "*"
 ;end new ICD10 SNOMED
 Q
 ;
XIT K ABMA
 Q
