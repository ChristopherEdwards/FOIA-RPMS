ABMDE5A ; IHS/ASDST/DMJ - PAGE 5A - DIAGNOSIS PART 2 ;
 ;;2.6;IHS 3P BILLING SYSTEM;**10,14,16**;NOV 12, 2009;Build 268
 ;
 ; IHS/SD/SDR - v2.5 p13 - POA changes
 ;   Added POA to display
 ;
 ; IHS/SD/SDR - v2.6 CSV
 ;IHS/SD/SDR 2.6*14 - 002F - Added code to display ICD10 code and indicator
 ;IHS/SD/SDR 2.6*14 - Added SNOMED and dual coding field to View option; also added options to refresh (RBCL) the diagnoses and ICD Indicator to
 ;  override if the claim should be ICD9 or ICD10
 ;IHS/SD/SDR - 2.6*14 - HEAT161263 - Changed reference to AUTNPOV to use $$GET1^DIQ so output transform would execute for SNOMED references
 ;IHS/SD/SDR - 2.6*16 - HEAT217211 - Updated to include PLACE OF OCCURRENCE; fixed alignment of CAUSE OF INJURY (was wrapping)
 ;
 S ABMZ("TITL")="DIAGNOSIS VIEW OPTION" D SUM^ABMDE1
 S ABMA("C")=0,ABMA("D")="",$P(ABMA("D"),"-",80)=""
 W !?13,"***** DIAGNOSIS INFORMATION ENTERED THROUGH PCC *****"
 ;W !,"PRI",?4,"ICD CD"  ;abm*2.6*10 ICD10 002G
 W !,"PRI",?4,"ICD CD",?12,"IND"  ;abm*2.6*10 ICD10 002G
 I $P($G(^ABMDPARM(ABMP("LDFN"),1,2)),U,13)="Y"&(($E(ABMP("BTYP"),1,2)=11)!($E(ABMP("BTYP"),1,2)="12")) D
 .;W ?11,"POA",?22,"PROVIDER'S NARRATIVE",?58,"CAUSE OF INJURY"  ;abm*2.6*10 ICD10 002G
 .W ?16,"POA",?22,"PROVIDER'S NARRATIVE",?58,"CAUSE OF INJURY"  ;abm*2.6*10 ICD10 002G
 ;E  W ?18,"PROVIDER'S NARRATIVE",?57,"CAUSE OF INJURY"  ;abm*2.6*10 ICD10 002G
 E  W ?19,"PROVIDER'S NARRATIVE",?57,"CAUSE OF INJURY"  ;abm*2.6*10 ICD10 002G
 ;W !,"===",?4,"======"  ;abm*2.6*10 ICD10 002G
 W !,"===",?4,"=======",?12,"==="  ;abm*2.6*10 ICD10 002G
 I $P($G(^ABMDPARM(ABMP("LDFN"),1,2)),U,13)="Y"&(($E(ABMP("BTYP"),1,2)=11)!($E(ABMP("BTYP"),1,2)="12")) D
 .;W ?11,"===",?15,"==================================",?50,"=============================="  ;abm*2.6*10 ICD10 002G
 .W ?16,"===",?20,"=============================",?50,"=============================="  ;abm*2.6*10 ICD10 002G
 ;E  W ?11,"==================================",?49,"=============================="  ;abm*2.6*10 ICD10 002G
 E  W ?16,"================================",?49,"=============================="  ;abm*2.6*10 ICD10 002G
 S ABMA=0 F ABMA("I")=1:1 S ABMA=$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),11,ABMA)) Q:'ABMA  D V1
 I ABMA("I")=1 W *7,!," There are no PCC visits to view."
 D ^ABMDERR
 G XIT
V1 ; view
 S ABMA("V")="" F ABMA("J")=1:1 S ABMA("V")=$O(^AUPNVPOV("AD",ABMA,ABMA("V"))) Q:'ABMA("V")  D POV
 I ABMA("C")=0 W *7,!," There are no PCC Purpose of Visits to view."
 Q
 ;
POV ;
 I $D(^AUPNVPOV(ABMA("V"),0)) S ABMA(0)=^(0) Q:'$P(ABMA(0),U,4)
 E  Q
 S ABMA(11)=$G(^AUPNVPOV(ABMA("V"),11))
 S ABMA("C")=ABMA("C")+1
 W !,$S($P(ABMA(0),U,12)="P":" P",1:" S")
 W ?4,$P($$DX^ABMCVAPI($P(ABMA(0),U),ABMP("VDT")),U,2)  ;CSV-c
 W ?13,$J($S($P($$DX^ABMCVAPI($P(ABMA(0),U),ABMP("VDT")),U,20)=30:"10",1:"9"),"2R")  ;abm*2.6*14 ICD10 002F
 ;W:$P($G(^ABMDPARM(ABMP("LDFN"),1,2)),U,13)="Y"&(($E(ABMP("BTYP"),1,2)=11)!($E(ABMP("BTYP"),1,2)="12")) ?12,$P(ABMA(0),U,22)  ;abm*2.6*10 ICD10 002G
 W:$P($G(^ABMDPARM(ABMP("LDFN"),1,2)),U,13)="Y"&(($E(ABMP("BTYP"),1,2)=11)!($E(ABMP("BTYP"),1,2)="12")) ?16,$P(ABMA(0),U,22)  ;abm*2.6*10 ICD10 002G
 K ABMU
 I $P($G(^ABMDPARM(ABMP("LDFN"),1,2)),U,13)="Y"&(($E(ABMP("BTYP"),1,2)=11)!($E(ABMP("BTYP"),1,2)="12")) D
 .;S ABMU("TXT")=$P(^AUTNPOV($P(ABMA(0),U,4),0),U),ABMU("LM")=15,ABMU("RM")=48  ;abm*2.6*10 ICD10 002G
 .;S ABMU("TXT")=$P(^AUTNPOV($P(ABMA(0),U,4),0),U),ABMU("LM")=20,ABMU("RM")=48  ;abm*2.6*10 ICD10 002G  ;abm*2.6*14 HEAT161263
 .S ABMU("TXT")=$$GET1^DIQ(9000010.07,ABMA("V"),".04","E"),ABMU("LM")=20,ABMU("RM")=48  ;abm*2.6*10 ICD10 002G  ;abm*2.6*14 HEAT161263
 ;E  S ABMU("TXT")=$P(^AUTNPOV($P(ABMA(0),U,4),0),U),ABMU("LM")=11,ABMU("RM")=48  ;abm*2.6*10 ICD10 002G
 ;E  S ABMU("TXT")=$P(^AUTNPOV($P(ABMA(0),U,4),0),U),ABMU("LM")=16,ABMU("RM")=48  ;abm*2.6*10 ICD10 002G  ;abm*2.6*14 HEAT161263
 E  S ABMU("TXT")=$$GET1^DIQ(9000010.07,ABMA("V"),".04","E"),ABMU("LM")=16,ABMU("RM")=48  ;abm*2.6*10 ICD10 002G  ;abm*2.6*14 HEAT161263
 ;I $P(ABMA(0),U,9)]"",$D(^ICD9($P(ABMA(0),U,9),0)) S ABMU(1)="?49^"_$P($$DX^ABMCVAPI($P(ABMA(0),U,9),ABMP("VDT")),U,4)  ;CSV-c  ;abm*2.6*10 ICD10 002G
 ;I $P(ABMA(0),U,9)]"",$D(^ICD9($P(ABMA(0),U,9),0)) S ABMU(1)="?50^"_$P($$DX^ABMCVAPI($P(ABMA(0),U,9),ABMP("VDT")),U,4)  ;CSV-c  ;abm*2.6*10 ICD10 002G  ;abm*2.6*16 IHS/SD/SDR HEAT217211
 I $P(ABMA(0),U,9)]"",$D(^ICD9($P(ABMA(0),U,9),0)) S ABMU(1)="?49^"_$E($P($$DX^ABMCVAPI($P(ABMA(0),U,9),ABMP("VDT")),U,4),1,30)  ;CSV-c  ;abm*2.6*10 ICD10 002G  ;abm*2.6*16 IHS/SD/SDR HEAT217211
 D ^ABMDWRAP
 ;start new abm*2.6*14 ICD10 dual coding
 K ABMU
 I +$P(ABMA(0),U,24)'=0 D
 .W !?10,"Dual ICD-9 Code: ",$P($$DX^ABMCVAPI(+$P(ABMA(0),U,24),ABMP("VDT")),U,2)
 I $$GET1^DIQ(9000010.07,ABMA("V"),"1101.019","E")'="" D
 .W !?10,"SNOMED Preferred Term: "
 .S ABMU("TXT")=$$GET1^DIQ(9000010.07,ABMA("V"),"1101.019","E")
 .S ABMU("LM")=33
 .S ABMU("RM")=68
 .D ^ABMDWRAP
 I $$GET1^DIQ(9000010.07,ABMA("V"),"1102.019","E")'="" D
 .W !?10,"SNOMED Desc ID Preferred Term: "
 .S ABMU("TXT")=$$GET1^DIQ(9000010.07,ABMA("V"),"1102.019","E")
 .S ABMU("LM")=41
 .S ABMU("RM")=68
 .D ^ABMDWRAP
 I $$GET1^DIQ(9000010.07,ABMA("V"),"1103.019","E")'="" D
 .W !?10,"Primary SNOMED Preferred Term: "
 .S ABMU("TXT")=$$GET1^DIQ(9000010.07,ABMA("V"),"1103.019","E")
 .S ABMU("LM")=41
 .S ABMU("RM")=68
 .D ^ABMDWRAP
 ;end new dual coding
 ;start new abm*2.6*16 IHS/SD/SDR HEAT217211
 I +$P(ABMA(0),U,28)'=0 D
 .W !?10,"Place of Occurrence (E849): ",$P($$DX^ABMCVAPI(+$P(ABMA(0),U,28),ABMP("VDT")),U,2)
 ;end new abm*2.6*16 IHS/SD/SDR HEAT217211
MOD I $P(ABMA(0),U,6)="" G CAUSE
 S ABMA("Y")=$P(ABMA(0),U,6)
DD ;
 ;S ABMA("Y0")=$P(^DD(9000010.07,.06,0),U,3),ABMA("Y0")=$P($P(ABMA("Y0"),ABMA("Y")_":",2),";",1) W !?11,"(Modifier: ",ABMA("Y0"),")"  ;abm*2.6*10 ICD10 002G
 S ABMA("Y0")=$P(^DD(9000010.07,.06,0),U,3),ABMA("Y0")=$P($P(ABMA("Y0"),ABMA("Y")_":",2),";",1) W !?20,"(Modifier: ",ABMA("Y0"),")"  ;abm*2.6*10 ICD10 002G
CAUSE ;
 ;I $P(ABMA(0),U,7)="" G CONT  ;abm*2.6*16 IHS/SD/SDR HEAT217211
 I $P(ABMA(0),U,7)="" G POC  ;abm*2.6*16 IHS/SD/SDR HEAT217211
 S ABMA("Y")=$P(ABMA(0),U,7)
 ;S ABMA("Y0")=$P(^DD(9000010.07,.07,0),U,3),ABMA("Y0")=$P($P(ABMA("Y0"),ABMA("Y")_":",2),";",1) W !?11,"(Cause of Dx: ",ABMA("Y0"),")"  ;abm*2.6*10 ICD10 002G
 S ABMA("Y0")=$P(^DD(9000010.07,.07,0),U,3),ABMA("Y0")=$P($P(ABMA("Y0"),ABMA("Y")_":",2),";",1) W !?20,"(Cause of Dx: ",ABMA("Y0"),")"  ;abm*2.6*10 ICD10 002G
 ;start new abm*2.6*16 IHS/SD/SDR HEAT217211
POC ;
 I $P(ABMA(0),U,21)="" G CONT
 S ABMA("Y0")=$P($$DX^ABMCVAPI(+$P(ABMA(0),U,21),ABMP("VDT")),U,2) W !?20,"(Place of Occurrence: ",ABMA("Y0"),")"
 ;end new abm*2.6*16 IHS/SD/SDR HEAT217211
CONT Q
 ;start new code abm*2.6*14 ICD10 Refresh page 5A and ICD Indicator
REFRESH ;EP
 ;remove entries
 I '$D(^ABMDCLM(DUZ(2),ABMP("CDFN"),11,0)) W !!,"There aren't any visits associated with this claim to refresh from" H 1 Q  ;only do if there is visit entries
 W !!
 K DIR,DIE,DIC,DA,X,Y
 S DIR(0)="Y"
 S DIR("A",1)="Note:  All manually entered codes will be deleted if you continue and you may"
 S DIR("A",2)="need to relink Diagnosis codes to charges"
 S DIR("A",3)=""
 S DIR("A")="Do you wish to continue with refresh?"
 S DIR("B")="Y"
 D ^DIR
 K DIR
 Q:Y<1
 K ^ABMDCLM(DUZ(2),ABMP("CDFN"),17)
 K ^ABMDCLM(DUZ(2),ABMP("CDFN"),19)
 S ^ABMDCLM(DUZ(2),ABMP("CDFN"),17,0)="^9002274.3017P^^"
 S ^ABMDCLM(DUZ(2),ABMP("CDFN"),19,0)="^9002274.3019P^^"
 ;reload DXs from V POV
 S ABMIDONE=0
 S ABMSVDFN=ABMVDFN
 S ABMVDFN=0
 F  S ABMVDFN=$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),11,ABMVDFN)) Q:'ABMVDFN  D
 .S (ABMP("V0"),ABMCHV0)=^AUPNVSIT(ABMVDFN,0)
 .S ABMCHVDT=$P(ABMCHV0,U)\1
 .D ^ABMDVST1
 .D ^ABMDVST3
 S ABMVDFN=ABMSVDFN
 Q
IND ;EP
 ;sets indicator for ICD9/ICD10 on this one claim, like an override
 K DIR,DIE,DIC,DA,X,Y
 W !!
 S DIE="^ABMDCLM(DUZ(2),"
 S DR=".021What ICD code set should be used?//"
 S DA=ABMP("CDFN")
 D ^DIE
 K ABMP("ICD10")
 I +$P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),0)),U,21)=9 S ABMP("ICD10")=(ABMP("VDT")+1)
 I +$P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),0)),U,21)=10 S ABMP("ICD10")=(ABMP("VDT")-1)
 I (+$G(ABMP("INS"))'=0)&(+$G(ABMP("ICD10"))=0) S ABMP("ICD10")=$P($G(^ABMNINS(ABMP("LDFN"),ABMP("INS"),0)),U,12)
 Q
 ;end new code ICD10 Refresh page 5A and ICD Indicator
 ;
XIT K ABMA
 Q
