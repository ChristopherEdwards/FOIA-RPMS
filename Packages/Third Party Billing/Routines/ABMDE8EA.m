ABMDE8EA ; IHS/ASDST/DMJ - PAGE 8E - LAB VIEW OPTION ;
 ;;2.6;IHS 3P BILLING SYSTEM;;NOV 12, 2009
 ;
 S ABMZ("PG")="8E"
 S ABMZ("TITL")="LABORATORY VIEW OPTION" D SUM^ABMDE1
 S ABMA("C")=0,ABMA("D")="",$P(ABMA("D"),"-",80)=""
 W !?13,"***** LABORATORY TEST INFORMATION ENTERED THROUGH PCC *****"
 W !,"VISIT"
 W !,"DATE",?7,"CPT",?13,"LAB DESCRIPTION(IEN)",?55,"Lab accession#",?73,"Results"
 W !,"=====",?7,"===== ========================================= ================= ======="
 S ABMA=0 F ABMA("I")=1:1 S ABMA=$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),11,ABMA)) Q:'ABMA  D V1
 I ABMA("I")=1 W *7,!," There are no PCC visits to view."
 I ABMA("C")=0 W *7,!," There are no Laboratory Procedures Coded in PCC to view."
 D ^ABMDERR
 G XIT
V1 ; view
 S ABMA("V")="" F ABMA("J")=1:1 S ABMA("V")=$O(^AUPNVLAB("AD",ABMA,ABMA("V"))) Q:'ABMA("V")  D POV
 Q
 ;
POV I $D(^AUPNVLAB(ABMA("V"),0)) S ABMA(0)=$G(^AUPNVLAB(ABMA("V"),0))
 E  Q
 S ABMA("C")=ABMA("C")+1
 W !,$E(^AUPNVSIT(ABMA,0),4,5),"/",$E(^AUPNVSIT(ABMA,0),6,7)  ;visit date (MM/DD)
 W ?7,$P($P($G(^AUPNVLAB(ABMA("V"),14)),U,2),"|")  ;CPT
 S ABMLABD=$P($G(^LAB(60,+ABMA(0),0)),U)
 I ($L(ABMLABD)+$L(+ABMA(0))+2)>40 D
 .S ABMIENL=$L(+ABMA(0))+2
 .S ABMLABD=$E(ABMLABD,1,$L(ABMLABD)-ABMIENL)
 W ?13,ABMLABD_"("_+ABMA(0)_")"  ;Laboratory Test file, NAME field
 W ?55,$P(ABMA(0),U,6)  ;Lab accession number (16 chars)
 W ?73,$P(ABMA(0),U,4)  ;Results
 Q
 ;
XIT K ABMA
 Q
