ABMDE5A ; IHS/ASDST/DMJ - PAGE 5A - DIAGNOSIS PART 2 ;
 ;;2.6;IHS 3P BILLING SYSTEM;;NOV 12, 2009
 ;
 ; IHS/SD/SDR - v2.5 p13 - POA changes
 ;   Added POA to display
 ;
 ; IHS/SD/SDR - v2.6 CSV
 ;
 S ABMZ("TITL")="DIAGNOSIS VIEW OPTION" D SUM^ABMDE1
 S ABMA("C")=0,ABMA("D")="",$P(ABMA("D"),"-",80)=""
 W !?13,"***** DIAGNOSIS INFORMATION ENTERED THROUGH PCC *****"
 W !,"PRI",?4,"ICD CD"
 I $P($G(^ABMDPARM(ABMP("LDFN"),1,2)),U,13)="Y"&(($E(ABMP("BTYP"),1,2)=11)!($E(ABMP("BTYP"),1,2)="12")) D
 .W ?11,"POA",?22,"PROVIDER'S NARRATIVE",?58,"CAUSE OF INJURY"
 E  W ?18,"PROVIDER'S NARRATIVE",?57,"CAUSE OF INJURY"
 W !,"===",?4,"======"
 I $P($G(^ABMDPARM(ABMP("LDFN"),1,2)),U,13)="Y"&(($E(ABMP("BTYP"),1,2)=11)!($E(ABMP("BTYP"),1,2)="12")) D
 .W ?11,"===",?15,"==================================",?50,"=============================="
 E  W ?11,"==================================",?49,"=============================="
 S ABMA=0 F ABMA("I")=1:1 S ABMA=$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),11,ABMA)) Q:'ABMA  D V1
 I ABMA("I")=1 W *7,!," There are no PCC visits to view."
 D ^ABMDERR
 G XIT
V1 ; view
 S ABMA("V")="" F ABMA("J")=1:1 S ABMA("V")=$O(^AUPNVPOV("AD",ABMA,ABMA("V"))) Q:'ABMA("V")  D POV
 I ABMA("C")=0 W *7,!," There are no PCC Purpose of Visits to view."
 Q
 ;
POV I $D(^AUPNVPOV(ABMA("V"),0)) S ABMA(0)=^(0) Q:'$P(ABMA(0),U,4)
 E  Q
 S ABMA("C")=ABMA("C")+1
 W !,$S($P(ABMA(0),U,12)="P":" P",1:" S")
 W ?4,$P($$DX^ABMCVAPI($P(ABMA(0),U),ABMP("VDT")),U,2)  ;CSV-c
 W:$P($G(^ABMDPARM(ABMP("LDFN"),1,2)),U,13)="Y"&(($E(ABMP("BTYP"),1,2)=11)!($E(ABMP("BTYP"),1,2)="12")) ?12,$P(ABMA(0),U,22)
 K ABMU
 I $P($G(^ABMDPARM(ABMP("LDFN"),1,2)),U,13)="Y"&(($E(ABMP("BTYP"),1,2)=11)!($E(ABMP("BTYP"),1,2)="12")) D
 .S ABMU("TXT")=$P(^AUTNPOV($P(ABMA(0),U,4),0),U),ABMU("LM")=15,ABMU("RM")=48
 E  S ABMU("TXT")=$P(^AUTNPOV($P(ABMA(0),U,4),0),U),ABMU("LM")=11,ABMU("RM")=48
 I $P(ABMA(0),U,9)]"",$D(^ICD9($P(ABMA(0),U,9),0)) S ABMU(1)="?49^"_$P($$DX^ABMCVAPI($P(ABMA(0),U,9),ABMP("VDT")),U,4)  ;CSV-c
 D ^ABMDWRAP
MOD I $P(ABMA(0),U,6)="" G CAUSE
 S ABMA("Y")=$P(ABMA(0),U,6)
DD S ABMA("Y0")=$P(^DD(9000010.07,.06,0),U,3),ABMA("Y0")=$P($P(ABMA("Y0"),ABMA("Y")_":",2),";",1) W !?11,"(Modifier: ",ABMA("Y0"),")"
CAUSE I $P(ABMA(0),U,7)="" G CONT
 S ABMA("Y")=$P(ABMA(0),U,7)
 S ABMA("Y0")=$P(^DD(9000010.07,.07,0),U,3),ABMA("Y0")=$P($P(ABMA("Y0"),ABMA("Y")_":",2),";",1) W !?11,"(Cause of Dx: ",ABMA("Y0"),")"
CONT Q
 ;
XIT K ABMA
 Q
