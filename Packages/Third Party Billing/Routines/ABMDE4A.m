ABMDE4A ; IHS/ASDST/DMJ - PAGE 4 - PROVIDERS VIEW ; 
 ;;2.6;IHS 3P BILLING SYSTEM;;NOV 12, 2009
 ;
 ;IHS/DSD/DMJ - 5/5/1999 - NOIS PEB-0599-90005 Patch 1
 ;            Modified for incorrect provider information (looking at
 ;            wrong file) new code at line PCCPRV+5
 ;
 ; IHS/SD/SDR - v2.5 p10 - IM20776
 ;   Display provider taxonomy code on view
 ;
 ; IHS/SD/SDR v2.5 p11 - NPI
 ;
 S ABMA("D")="",$P(ABMA("D"),"-",80)=""
 S ABMZ("TITL")="PROVIDER VIEW OPTION"
 D SUM^ABMDE1
 D PRV,PCC,^ABMDERR
 G XIT
 ;
PRV ;
ATTN I '$D(ABM("A")) G OPER
 W !,"Attn Prov..: ",$P(ABM("A"),U)
 W ?50,"Phone #....: " I $D(^VA(200,$P(ABM("A"),U,2),.13)) W $P(^(.13),U)
 W !,"Discipline.: "
 W $P($G(^DIC(7,+$P($G(^VA(200,$P(ABM("A"),U,2),"PS")),U,5),0)),U)
 I "RD"[$P($G(^AUTNINS(ABMP("INS"),2)),U),$P(^(2),U)]"" W ?50,"MCR/MCD #..: "
 E  W ?50,"Licensure #: "
 S ABMA("ST")=$P(^AUTTLOC(ABMP("LDFN"),0),U,23)
 S:ABMA("ST")="" ABMA("ST")=$P(^AUTTLOC(ABMP("LDFN"),0),U,14)
 I ABMA("ST")="" S ABME(120)=ABMP("LDFN")
PNUM W $$SLN^ABMERUTL($P(ABM("A"),"^",2),ABMA("ST"))
 W !,"Affilliation: "
DD I $D(^VA(200,$P(ABM("A"),U,2),9999999)),$P(^(9999999),U)]"" S ABMA("Y")=$P(^(9999999),U)
 I  S ABMA("Y0")=$P(^DD(200,9999999.01,0),U,3),ABMA("Y0")=$P($P(ABMA("Y0"),ABMA("Y")_":",2),";",1) W ABMA("Y0")
 W ?50,"DEA #......: ",$P($G(^VA(200,$P(ABM("A"),U,2),"PS")),U,2)
 S ABMNPI=$P($$NPI^XUSNPI("Individual_ID",$P(ABM("A"),U,2)),U)
 W !,"NPI.........: ",$S(+ABMNPI>0:ABMNPI,1:"")
 W ?50,"Provider Taxonomy:",$$PTAX^ABMEEPRV($P(ABM("A"),U,2))
 W !
OPER I '$D(ABM("O")) Q
 W !,"Oper Prov..: ",$P(ABM("O"),U)
 W ?50,"Phone #....: " I $D(^VA(200,$P(ABM("O"),U,2),.13)) W $P(^(.13),U)
 W !,"Discipline.: "
 W $P($G(^DIC(7,+$P($G(^VA(200,$P(ABM("O"),U,2),"PS")),U,5),0)),U)
 I "RD"[$P($G(^AUTNINS(ABMP("INS"),2)),U),$P(^(2),U)]"" W ?50,"MCR/MCD #..: "
 E  W ?50,"Licensure #: "
 S ABMA("ST")=$P(^AUTTLOC(ABMP("LDFN"),0),U,23) S:ABMA("ST")="" ABMA("ST")=$P(^(0),U,14)
 I ABMA("ST")="" S ABME(120)=ABMP("LDFN")
OPNUM W $$SLN^ABMERUTL($P(ABM("O"),"^",2),ABMA("ST"))
 W !,"Afilliation: "
 I $D(^VA(200,$P(ABM("O"),U,2),9999999)),$P(^(9999999),U)]"" S ABMA("Y")=$P(^(9999999),U)
 I  S ABMA("Y0")=$P(^DD(200,9999999.01,0),U,3),ABMA("Y0")=$P($P(ABMA("Y0"),ABMA("Y")_":",2),";",1) W ABMA("Y0")
 W ?50,"DEA #......: ",$P($G(^VA(200,$P(ABM("O"),U,2),"PS")),U,2)
 S ABMNPI=$P($$NPI^XUSNPI("Individual_ID",$P(ABM("O"),U,2)),U)
 W !,"NPI.........: ",$S(+ABMNPI>0:ABMNPI,1:"")
 W ?50,"Provider Taxonomy:",$$PTAX^ABMEEPRV($P(ABM("O"),U,2))
 Q
 ;
PCC W !,ABMA("D")
 S ABMA("C")=0
 W !?13,"***** Provider Information Entered Through PCC *****"
 W !,"PRI",?11,"PROVIDER",?50,"DISCIPLINE"
 W !,"===",?4,"====================================",?43,"=============================="
 S ABMA=0 F ABMA("I")=1:1 S ABMA=$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),11,ABMA)) Q:'ABMA  D V1
 I ABMA("I")=1 W *7,!," There are no PCC visits to view."
 Q
V1 ; view
 S ABMA("V")="" F ABMA("J")=1:1 S ABMA("V")=$O(^AUPNVPRV("AD",ABMA,ABMA("V"))) Q:'ABMA("V")  D PCCPRV
 Q
 ;
PCCPRV I $D(^AUPNVPRV(ABMA("V"),0)) S ABMA(0)=^(0)
 E  Q
 I ^DD(9000010.06,.01,0)["VA(200" D
 .S ABMA("PRV")=$P($G(^VA(200,+ABMA(0),0)),U)
 .S ABMA("DISC")=$P($G(^VA(200,+ABMA(0),"PS")),U,5)
 I ^DD(9000010.06,.01,0)["DIC(6" D
 .S ABMA("PRV")=$P($G(^DIC(16,+ABMA(0),0)),U)
 .S ABMA("DISC")=$P($G(^DIC(6,+ABMA(0),0)),U,4)
 I ABMA("DISC")]"",$D(^DIC(7,ABMA("DISC"),0)) S ABMA("DISC")=$E($P(^(0),U),1,30)
 S ABMA("C")=ABMA("C")+1
 W !,$S($P(ABMA(0),U,4)="P":" P",1:" S")
 W ?4,ABMA("PRV"),?43,ABMA("DISC")
 Q
 ;
XIT K ABMA
 Q
