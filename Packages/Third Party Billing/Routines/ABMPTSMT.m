ABMPTSMT ; IHS/SD/SDR - Non-ben patient statement ;   
 ;;2.6;IHS 3P BILLING SYSTEM;**3**;NOV 12, 2009
 ;
 ; IHS/SD/SDR - v2.6 CSV
 ;
MARG ;Set left and top margins
 S (ABM("LM"),ABM("TM"),ABM("LN"))=0
 W $$EN^ABMVDF("IOF")
 I +ABM("TM") F ABM("I")=1:1:ABM("TM") W !
 S ABMP("PDFN")=$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),0)),U,5)
 S ABMP("LDFN")=$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),0)),U,3)
 S ABMP("VTYP")=$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),0)),U,7)
 S ABMP("BTYP")=$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),0)),U,2)
 S ABMP("INS")=$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),0)),U,8)
 S ABMP("CLIN")=$P($G(^DIC(40.7,$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),0)),U,10),0)),U,2)
 S ABMP("VDT")=$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),7)),U)
 S ABMPAGE=1
 S ABMTCHRG=0
 D HDR
 D SLINES
 D XIT
 Q
 ;
HDR ;
 ;main header
 W !!
 S ABMADIEN=$O(^AUTTLOC(DUZ(2),11,9999999),-1)
 I $P($G(^AUTTLOC(DUZ(2),11,ABMADIEN,0)),U,3)=1 D CENTER("DEPARTMENT OF HEALTH & HUMAN SERVICES")
 W !
 I $P($G(^ABMDPARM(DUZ(2),1,2)),U,11)'="" D CENTER($P($G(^ABMDPARM(DUZ(2),1,2)),U,11))
 E  D CENTER("INDIAN HEALTH SERVICE")
 W !!
 ;visit location
 D CENTER($P($G(^AUTTLOC(ABMP("LDFN"),0)),U,2))
 W !!!
 D CENTER("STATEMENT OF SERVICES")
 W !!!!
 ;claim data header
 ;
 D GUARCHK  ;check if guarantor; default to patient if none for DOS
 W ?5,"DATE   : ",$$SDT^ABMDUTL(DT)
 W ?45,ABMGNAME
 W !
 W ?5,"CHART #: "
 W $S($P($G(^AUPNPAT(ABMP("PDFN"),41,ABMP("LDFN"),0)),U,2)'="":$P(^AUPNPAT(ABMP("PDFN"),41,ABMP("LDFN"),0),U,2),1:$P($G(^AUPNPAT(ABMP("PDFN"),41,DUZ(2),0)),U,2))
 W ?45,ABMGSTR
 W !
 W ?5,"REF #  : ",$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),0)),U)
 W ?45,ABMGCITY_", "_ABMGST_"  "_ABMGZIP
 W !!!,?1
 F ABMI=1:1:78 W "-"
 W !,?1
 F ABMI=1:1:78 W "="
 W !
 ; statement header
 W ?1,"|PATIENT NAME: ",$E($P($G(^DPT($P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),0)),U,5),0)),U),1,38)
 W ?40,"|SERVICE DATE: ",$$SDT^ABMDUTL($P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),7)),U))
 W ?68,"|PAGE: ",$$FMT^ABMERUTL(ABMPAGE,"3NR")_"|"
 W !,?1
 F ABMI=1:1:78 W "-"
 W !
 W ?1,"|VISIT TYPE: ",$P($G(^ABMDVTYP(ABMP("VTYP"),0)),U)
 S ABMAPRV=$O(^ABMDBILL(DUZ(2),ABMP("BDFN"),41,"C","A",0))
 I ABMAPRV="" S ABMAPRV=$O(^ABMDBILL(DUZ(2),ABMP("BDFN"),41,"C","R",0))
 I ABMAPRV'="" S ABMAPRV=$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),41,ABMAPRV,0)),U)
 W ?39,"|ATTENDING PHYSICIAN: ",$S(ABMAPRV'="":$E($P($G(^VA(200,ABMAPRV,0)),U),1,17),1:"(NO ATTENDING)")_"|"
 W !,?1
 F ABMI=1:1:78 W "="
 W !
 W ?1,"|SERVICE |SERVICE  |",?63,"|",?67,"|",?78,"|"
 W !
 W ?1,"|DATE",?10,"|CODE     |DESCRIPTION"
 W ?63,"|QTY|AMOUNT    |"
 W !
 W ?1,"|--------|---------|------------------------------------------"
 W "|---|----------|"
 W !
 Q
SLINES ;service lines
 D ^ABMEHGRV
 I $G(ABMP("FLAT"))'="" D  Q
 .S ABMSDT=$$SDTO^ABMDUTL($P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),7)),U))
 .S ABMSCD=$P(ABMP("FLAT"),U,2)
 .S ABMDESC=$S($P($G(^ABMNINS(DUZ(2),ABMP("INS"),1,ABMP("VTYP"),0)),U,9)'="":$P(^ABMNINS(DUZ(2),ABMP("INS"),1,ABMP("VTYP"),0),U,9),1:$P($G(^AUTTREVN($P(ABMP("FLAT"),U,2),0)),U,2))
 .S ABMUNIT=$P(ABMP("FLAT"),U,3)
 .S ABMCHRG=$P(ABMP("FLAT"),U)*ABMUNIT
 .S ABMTCHRG=$G(ABMTCHRG)+ABMCHRG
 .S ABMCHRG=$FN($J(ABMCHRG,".",2),",",2)
 .D WLINE
 .D TOTAL
 ;
 S ABMLNCNT=0
 S (ABMI,ABMJ,ABMK)=0
 F  S ABMI=$O(ABMRV(ABMI)) Q:+ABMI=0  D
 .S ABMJ=0
 .F  S ABMJ=$O(ABMRV(ABMI,ABMJ)) Q:+ABMJ=0  D
 ..S ABMK=0
 ..F  S ABMK=$O(ABMRV(ABMI,ABMJ,ABMK)) Q:+ABMK=0  D
 ...S ABMSDT=$$SDTO^ABMDUTL($S($P(ABMRV(ABMI,ABMJ,ABMK),U,27)'="":+$P(ABMRV(ABMI,ABMJ,ABMK),U,27),1:$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),7)),U)))
 ...S ABMSCD=$P($G(ABMRV(ABMI,ABMJ,ABMK)),U,2)
 ...I ABMI=23 D
 ....S ABMSCD=$P($G(ABMRV(ABMI,ABMJ,ABMK)),U,13)  ;pharmacy RX
 ....S ABMSDT=$$SDTO^ABMDUTL($S($P(ABMRV(ABMI,ABMJ,ABMK),U,10)'="":+$P(ABMRV(ABMI,ABMJ,ABMK),U,10),1:$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),7)),U)))
 ...I ABMI=25 S ABMSCD=$P($G(ABMRV(ABMI,ABMJ,ABMK)),U)  ;Rev code
 ...S ABMDESC=$P($G(ABMRV(ABMI,ABMJ,ABMK)),U,9)
 ...I ABMI'=23&(ABMI'=33)&(ABMI'=25),($P(ABMRV(ABMI,ABMJ,ABMK),U,2)'="") S ABMDESC=$P($$CPT^ABMCVAPI(+$P(ABMRV(ABMI,ABMJ,ABMK),U,2),ABMP("VDT")),U,3)  ;CSV-c
 ...I ABMI'=33&($A($E($P(ABMRV(ABMI,ABMJ,ABMK),U,2)))>64) S ABMDESC=$P($$CPT^ABMCVAPI($O(^ICPT("B",$P(ABMRV(ABMI,ABMJ,ABMK),U,2),0)),ABMP("VDT")),U,3)  ;CSV-c
 ...I ABMI=33&($A($E($P(ABMRV(ABMI,ABMJ,ABMK),U,2)))>64) S ABMDESC=$P($G(^AUTTADA($O(^AUTTADA("B",$E($P(ABMRV(ABMI,ABMJ,ABMK),U,2),2,5),0)),0)),U,2)
 ...I ABMI=25 S ABMDESC=$P($G(^AUTTREVN($P(ABMRV(ABMI,ABMJ,ABMK),U),0)),U,2)  ;rev code desc
 ...S ABMUNIT=$P($G(ABMRV(ABMI,ABMJ,ABMK)),U,5)  ;units--ok for all
 ...S ABMCHRG=$P($G(ABMRV(ABMI,ABMJ,ABMK)),U,6)  ;charges--ok for all
 ...S ABMTCHRG=$G(ABMTCHRG)+ABMCHRG
 ...S ABMCHRG=$FN($J(ABMCHRG,".",2),",",2)
 ...D WLINE
 D TOTAL
 Q
 ;
WLINE ;write service line
 W ?1,"|",ABMSDT,"|"
 W $$FMT^ABMERUTL(ABMSCD,"9R"),"|"
 W $$FMT^ABMERUTL(ABMDESC,"42L"),"|"
 W $$FMT^ABMERUTL(ABMUNIT,"3R"),"|"
 W $$FMT^ABMERUTL(ABMCHRG,"10R"),"|"
 W !
 S ABMLNCNT=+$G(ABMLNCNT)+1
 I ABMLNCNT>17 D  ;start new page
 .W ?1,"|"
 .W ?10,"|"
 .W ?20,"|"
 .W ?50,"CONTINUED==>"
 .W ?63,"|"
 .W ?67,"|          |"
 .W !
 .D WCOVRG
 .S ABMPAGE=ABMPAGE+1
 .D HDR
 .S ABMLNCNT=1
 Q
 ;
TOTAL ;total
 W ?1,"|"
 W ?10,"|"
 W ?20,"|"
 W ?63,"|"
 W ?67,"|==========|"
 W !
 W ?1,"|"
 W ?10,"|"
 W ?20,"|"
 W ?50,"TOTAL CHARGES|"
 W ?67,"|",$J($FN(ABMTCHRG,",",2),10),"|",!
 I ABMLNCNT<20 D
 .S ABMLN=" |        |         |                                          |   |          |"
 .F ABMLNCNT=ABMLNCNT:1:20 W ABMLN,!
 ;
WCOVRG ; coverage info from bill
 D COVRG
 W ?1
 F ABMI=1:1:78 W "-"
 W !?1,"Your coverage on file is:"
 S (ABMPRI,ABMPRIS,ABMINS)=0
 F  S ABMPRI=$O(ABML(ABMPRI)) Q:+ABMPRI=0!(ABMPRI>3)  D
 .S ABMPRIS=ABMPRI
 .S ABMINS=0
 .F  S ABMINS=$O(ABML(ABMPRI,ABMINS)) Q:+ABMINS=0  D
 ..Q:$P($G(^AUTNINS(ABMINS,0)),U)["NON-BEN"  ;don't print non-ben insurer
 ..W !?1,ABMPRI_". ",?3,$E($P($G(^AUTNINS(ABMINS,0)),U),1,35)
 ..I $P($G(ABML(ABMPRI,ABMINS)),U)'="" W ?40,$E($P($G(^AUTTPIC($P($G(ABML(ABMPRI,ABMINS)),U),0)),U),1,23)
 ..I $P($G(ABML(ABMPRI,ABMINS)),U,2) W ?65,"Eff: "_$$SDT^ABMDUTL($P($G(ABML(ABMPRI,ABMINS)),U,2))
 I +$O(ABML(0))=0 W ?10,"NO COVERAGE FOUND"
 I ABMPRIS<3 D
 .F ABMPRIS=ABMPRIS:1:3 W !
 ;
 W !!?1
 F ABMI=1:1:78 W "-"
 W !?1,"|"
 ;W $G(ABMY(ABMP("BDFN")))_$S($P(^ABMDBILL(DUZ(2),ABMP("BDFN"),1),U,7)'="":" ("_$$SDT^ABMDUTL($P($G(^ABMDTXST(DUZ(2),$P(^ABMDBILL(DUZ(2),ABMP("BDFN"),1),U,7),0)),U))_")",1:"")  ;abm*2.6*3
 W $G(ABMY(ABMP("BDFN")))_$S($P(^ABMDBILL(DUZ(2),ABMP("BDFN"),1),U,7)'=""&($P($G(^ABMDPARM(DUZ(2),1,2)),U,14)="Y"):" ("_$$SDT^ABMDUTL($P($G(^ABMDTXST(DUZ(2),$P(^ABMDBILL(DUZ(2),ABMP("BDFN"),1),U,7),0)),U))_")",1:"")  ;abm*2.6*3
 W ?78,"|"
 W !?1
 F ABMI=1:1:78 W "-"
 ;
 D LOC^ABMDE1X1
 W !,?1
 W "Payments or inquiries may be sent to: "
 W ?50,$P($P($G(ABMV("X1")),U),";",2)
 W !?50,$P($G(ABMV("X1")),U,3)
 W !?50,$P($G(ABMV("X1")),U,4)
 W !!?50,$P($G(ABMV("X1")),U,5)
 W !
 D PRTFILE  ;files message and who printed
 Q
PRTFILE ; EP - save message, date, and who printed statement
 K X,Y,DIC,DIE,DA
 S DA(1)=ABMP("BDFN")
 S DIC="^ABMDBILL(DUZ(2),"_DA(1)_",67,"
 S DIC(0)="LM"
 S DIC("P")=$P(^DD(9002274.4,67,0),U,2)
 D NOW^%DTC
 S X=%
 S DIC("DR")=".02////"_DUZ_";.03////"_$G(ABMY(ABMP("BDFN")))
 D ^DIC
 Q
XIT ;
 K ABMV
 K ABMGNAME,ABMGSTR,ABMGCITY,ABMGST,ABMGZIP
 K ABMI,ABMJ,ABMK,ABMPRI,ABMINS,ABMRV,ABML
 K ABMSDT,ABMSCD,ABMDESC,ABMUNIT,ABMCHRG,ABMTCHRG
 K ABMLNCNT,ABMNOG,ABMPAGE,ABMMSG
 Q
 ;
GUARCHK ; set vars for header
 ;guarantor if there is one
 ;default to patient
 S ABMNOG=0  ;stays 0 if no guarantor entry found for DOS
 I +$O(^AUPNGUAR(ABMP("PDFN"),1,0))'=0 D
 .S ABMSDTTO=$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),7)),U)
 .S ABMSDTFR=$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),7)),U,2)
 .S ABMGIEN=0
 .F  S ABMGIEN=$O(^AUPNGUAR(ABMP("PDFN"),1,ABMGIEN)) Q:+ABMGIEN=0  D
 ..S ABMGEFDA=0
 ..F  S ABMGEFDA=$O(^AUPNGUAR(ABMP("PDFN"),1,ABMGIEN,11,ABMGEFDA)) Q:+ABMGEFDA=0  D
 ...S ABMGEFDT=$P($G(^AUPNGUAR(ABMP("PDFN"),1,ABMGIEN,11,ABMGEFDA,0)),U)
 ...S ABMGENDT=$P($G(^AUPNGUAR(ABMP("PDFN"),1,ABMGIEN,11,ABMGEFDA,0)),U,2)
 ...I ABMGEFDT>ABMSDTTO!(ABMGENDT>ABMSDTFR) Q
 ...S ABMNOG=1
 ...S ABMG=$P($G(^AUPNGUAR(ABMP("PDFN"),1,ABMGIEN,0)),U)
 ...S ABMGDA=$P(ABMG,";"),ABMGFILE=$P(ABMG,";",2)
 ...I ABMGFILE["AUPNPAT" D
 ....S ABMGNAME=$E($P($G(^DPT(ABMGDA,0)),U),1,50)
 ....S ABMGSTR=$P($G(^DPT(ABMGDA,.11)),U)
 ....S ABMGCITY=$P($G(^DPT(ABMGDA,.11)),U,4)
 ....S ABMGST=$S($P($G(^DPT(ABMGDA,.11)),U,5)'="":$P($G(^DIC(5,$P($G(^DPT(ABMGDA,.11)),U,5),0)),U,2),1:"")
 ....S ABMGZIP=$P($G(^DPT(ABMGDA,.11)),U,6)
 ...I ABMGFILE["AUTNINS" D
 ....S ABMGNAME=$P($G(^AUTNINS(ABMGDA,0)),U)
 ....S ABMGSTR=$P($G(^AUTNINS(ABMGDA,0)),U,2)
 ....S ABMGCITY=$P($G(^AUTNINS(ABMGDA,0)),U,3)
 ....S ABMGST=$S($P($G(^AUTNINS(ABMGDA,0)),U,4)'="":$P($G(^DIC(5,$P($G(^AUTNINS(ABMGDA,0)),U,4),0)),U,2),1:"")
 ....S ABMGZIP=$P($G(^AUTNINS(ABMGDA,0)),U,5)
 ...I ABMGFILE["AUTNEMPL" D
 ....S ABMGNAME=$E($P($G(^AUTNEMPL(ABMGDA,0)),U),1,50)
 ....S ABMGSTR=$P($G(^AUTNEMPL(ABMGDA,0)),U,2)
 ....S ABMGCITY=$P($G(^AUTNEMPL(ABMGDA,0)),U,3)
 ....S ABMGST=$S($P($G(^AUTNEMPL(ABMGDA,0)),U,4)'="":$P($G(^DIC(5,$P($G(^AUTNEMPL(ABMGDA,0)),U,4),0)),U,2),1:"")
 ....S ABMGZIP=$P($G(^AUTNEMPL(ABMGDA,0)),U,5)
 ;default to patient
 I +$O(^AUPNGUAR(ABMP("PDFN"),1,0))=0!(ABMNOG=0) D
 .S ABMGNAME=$E($P($G(^DPT(ABMP("PDFN"),0)),U),1,50)
 .S ABMGSTR=$P($G(^DPT(ABMP("PDFN"),.11)),U)
 .S ABMGCITY=$P($G(^DPT(ABMP("PDFN"),.11)),U,4)
 .S ABMGST=$S($P($G(^DPT(ABMP("PDFN"),.11)),U,5)'="":$P($G(^DIC(5,$P($G(^DPT(ABMP("PDFN"),.11)),U,5),0)),U,2),1:"")
 .S ABMGZIP=$P($G(^DPT(ABMP("PDFN"),.11)),U,6)
 Q
COVRG ;EP
 K ABML
 K ABMBEN
 S ABMIEN=0,ABMISNB=0,ABMBILLD=0
 F  S ABMIEN=$O(^ABMDBILL(DUZ(2),ABMP("BDFN"),13,ABMIEN)) Q:+ABMIEN=0  D
 .S (ABMINTRY,ABMCOV,ABMEFDT)=""
 .S ABMX=$G(^ABMDBILL(DUZ(2),ABMP("BDFN"),13,ABMIEN,0))
 .I $P(ABMX,U,3)="C" S ABMBILLD=1  ;completed; don't print if doing batch
 .S ABMINS=$P(ABMX,U)
 .I $P($G(^AUTNINS(ABMINS,2)),U)="N"!($P($G(^AUTNINS(ABMINS,0)),U)["NON-BEN") S ABMISNB=1
 .S ABMPRI=$P(ABMX,U,2)
 .I ($P($G(^AUTNINS(ABMINS,0)),U)="BENEFICIARY PATIENT"),($P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),0)),U,8)=ABMINS) S ABMABEN=1
 .I ($P($G(^AUTNINS(ABMINS,0)),U)="BENEFICIARY PATIENT") S ABMBEN=1 Q
 .I $P($G(^AUPNPAT(ABMP("PDFN"),11)),U,12)'="I" S ABMBEN=1
 .I $P(ABMX,U,4)'="" D  ;Medicare
 ..S ABMINTRY=$G(^AUPNMCR(ABMP("PDFN"),11,$P(ABMX,U,4),0))
 ..S ABMEFDT=$P(ABMINTRY,U)
 ..S ABMCOV=$P(ABMINTRY,U,3)
 .I $P(ABMX,U,5)'="" D  ;Railroad
 ..S ABMINTRY=$G(^AUPNRRE(ABMP("PDFN"),11,$P(ABMX,U,5),0))
 ..S ABMEFDT=$P(ABMINTRY,U)
 ..S ABMCOV=$P(ABMINTRY,U,3)
 .I $P(ABMX,U,6)'="" D  ;Medicaid
 ..S ABMMULT=$P(ABMX,U,7)
 ..Q:ABMMULT=""
 ..S ABMINTRY=$G(^AUPNMCD($P(ABMX,U,6),11,ABMMULT,0))
 ..S ABMEFDT=$P(ABMINTRY,U)
 ..S ABMCOV=$P(ABMINTRY,U,3)
 .I $P(ABMX,U,8)'="" D  ;PI
 ..S ABMINTRY=$G(^AUPNPRVT(ABMP("PDFN"),11,$P(ABMX,U,8),0))
 ..S ABMEFDT=$P(ABMINTRY,U,6)
 ..S ABMPH=$P(ABMINTRY,U,8)
 ..S:+ABMPH ABMCOV=$P($G(^AUPN3PPH(ABMPH,0)),U,5)
 .S ABML(ABMPRI,ABMINS)=$G(ABMCOV)_"^"_ABMEFDT
 Q
CENTER(X) ;EP
 S CENTER=IOM/2
 W ?CENTER-($L(X)/2),X
 Q