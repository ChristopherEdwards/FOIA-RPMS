ABMDEI ; IHS/ASDST/DMJ - Special Identifier for DIC Lookup ;
 ;;2.6;IHS 3P BILLING SYSTEM;;NOV 12, 2009
 ;
 Q
 I $D(DZ),$E(DZ)'="?" W !,X
 W " -"
 ;start CSV
 S ABMU("TXT")=""
 D IHSCPTD^ABMCVAPI($P(ABM("X0"),U),ABMZCPTD,"","")
 S ABMU("CP")=0
 F  S ABMU("CP")=$O(ABMZCPTD(ABMU("CP"))) Q:'$D(ABMZCPTD(ABMU("CP")))  D
 .S ABMU("TXT")=ABMU("TXT")_ABMZCPTD(ABMU("CP"))_" "
 ;end CSV
 S ABMU("RM")=79,ABMU("LM")=11,ABMU("TAB")=-3
 D ^ABMDWRAP
 ;
XIT K ABMU
 Q
 ;
EXT ;PEP - External Entry Point for displaying CPT codes
 ;start CSV
 S ABMU("TXT")=""
 D IHSCPTD^ABMCVAPI($P(ABM("X0"),U),ABMZCPTD,"","")
 S ABMU("CP")=0
 F  S ABMU("CP")=$O(ABMZCPTD(ABMU("CP"))) Q:'$D(ABMZCPTD(ABMU("CP")))  D
 .S ABMU("TXT")=ABMU("TXT")_ABMZCPTD(ABMU("CP"))_" "
 ;end CSV
 S ABMU("RM")=67,ABMU("LM")=11,ABMU("TAB")=-13
 D ^ABMDWRAP
 G XIT
 ;
ADA W " - ",$P(^AUTTADA(+Y,0),U,2)
 G XIT
 ;
REVN W " - ",$P(^AUTTREVN(+Y,0),U,2)
 G XIT
