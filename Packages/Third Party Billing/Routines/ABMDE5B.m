ABMDE5B ; IHS/ASDST/DMJ - PAGE 5B - PROCEDURE PART 2 ; 
 ;;2.6;IHS 3P BILLING SYSTEM;;NOV 12, 2009
 ;
 ;IHS/DSD/DMJ - 5/12/1999 - NOIS HQW-0599-100027 Patch 2
 ;    Changed mm/dd DOS display to full Charge Date
 ;
 ; IHS/SD/SDR - v2.6 CSV
 ;
 S ABMZ("PG")="5B"
 S ABMZ("TITL")="PROCEDURE VIEW OPTION" D SUM^ABMDE1
 S ABMA("C")=0,ABMA("D")="",$P(ABMA("D"),"-",80)=""
 W !?13,"***** PROCEDURE INFORMATION ENTERED THROUGH PCC *****"
 W !,"VISIT",?13,"ICD0"
 W !,"DATE",?7,"PRI",?13,"CODE - PROCEDURE DESCRIPTION",?50,"PROVIDER'S NARRATIVE"
 W !,"=====",?7,"===",?12,"===============================",?45,"=================================="
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
 W ?12,$P($$ICDOP^ABMCVAPI($P(ABMA(0),U),""),U,2) S ABMU("TXT")=$P($$ICDOP^ABMCVAPI($P(ABMA(0),U),ABMP("VDT")),U,5),ABMU("LM")=19,ABMU("RM")=43,ABMU("TAB")=4  ;CSV-c
 I $P(ABMA(0),U,4)]"" S ABMU("2TXT")=$P(^AUTNPOV($P(ABMA(0),U,4),0),U),ABMU("2LM")=45,ABMU("2RM")=80,ABMU("2TAB")=-2
 D ^ABMDWRAP
 Q
 ;
XIT K ABMA
 Q
