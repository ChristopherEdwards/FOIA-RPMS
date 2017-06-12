ABMM2PV5 ;IHS/SD/SDR - MU Patient Volume EP Report ;
 ;;2.6;IHS 3P BILLING SYSTEM;**11,12,15**;NOV 12, 2009;Build 251
 ;IHS/SD/SDR - 2.6*12 - Updated FQHC/RHC/Tribal to include Urban
 ;IHS/SD/SDR - 2.6*12 - Made changes for uncompensated care; uncompensated should be a separate detail line
 ;  and should be included in the patient volume total, not as a separate line.  Also initialized ABMFQHC variable.
 ;IHS/SD/SDR - 2.6*15 - HEAT183289 - Tribal self-insured added to not-met report
 ;
NOTMET ;EP
 S ABMCNT=0
 K ABMLN
 S ABMSDT=$P($G(^XTMP("ABM-PVP2",$J,"PRV TOP",ABMPRV)),U,2)
 ;
 I +$G(ABMY("TVDTS"))'=0 D
 .S ABMCNT=0
 .S ABMDT=0
 .F  S ABMDT=$O(^XTMP("ABM-PVP2",$J,"PRV PERCENT",ABMDT)) Q:'ABMDT  D
 ..S ABMP("PRV")=0
 ..F  S ABMP("PRV")=$O(^XTMP("ABM-PVP2",$J,"PRV PERCENT",ABMDT,ABMP("PRV"))) Q:'ABMP("PRV")  D
 ...I ABMP("PRV")'=ABMPRV Q
 ...S ABMCNT=ABMCNT+1
 ...;S ABMPRC($G(^XTMP("ABM-PVP2",$J,"PRV PERCENT",ABMDT,ABMPRV)),ABMCNT)=ABMDT  ;abm*2.6*12 HEAT136326
 ...S ABMPRC(+$G(^XTMP("ABM-PVP2",$J,"PRV PERCENT",ABMDT,ABMPRV)),ABMCNT)=ABMDT  ;abm*2.6*12 HEAT136326
 .S ABMP=""
 .S ABMSAV=ABMCNT-ABMY("TVDTS")
 .F  S ABMP=$O(ABMPRC(ABMP)) Q:ABMP=""  D
 ..S ABMCNT=0,ABMC=0
 ..F  S ABMCNT=$O(ABMPRC(ABMP,ABMCNT)) Q:'ABMCNT  D  Q:(ABMC=ABMSAV)
 ...K ^XTMP("ABM-PVP2",$J,"PRV PERCENT",$G(ABMPRC(ABMP,ABMCNT))),ABMP("PRV")
 ...S ABMC=ABMC+1
 ;
 S ABM("PG")=1
 S ABMSDT=$P($G(^XTMP("ABM-PVP2",$J,"PRV TOP",ABMPRV)),U,2)
 I +ABMSDT=0 S ABMSDT=ABMY("SDT")
 D HDR
 W !,"The Patient Volume Threshold (30% for EPs, or 20% for Pediatricians) was not"
 W !,"met for the "_$S(("^A^B^C^"[("^"_ABMY("90")_"^")):"timeframe entered",1:"MU Qualification year")_"."
 W !,"Details for the volumes that were achieved are provided for your information.",!
 W !,"Highest Patient Volume Met: ",+$P($G(^XTMP("ABM-PVP2",$J,"PRV TOP",ABMPRV)),U)_"%"
 W !,"First Day Highest Patient Volume Achieved: ",$$SDT^ABMDUTL(ABMSDT)
 ;
 I $Y+5>IOSL D HD^ABMM2PV3 Q:(IOST["C")&((+$G(Y)=0)!($D(DIRUT)!$D(DIROUT)!$D(DTOUT)!$D(DUOUT)))
 S ABMTHPV=0
 S:ABMSDT ABMTHPV=+$G(^XTMP("ABM-PVP2",$J,"PRV-DENOM",ABMSDT,ABMPRV))
 S ABMMHPV=0
 S:ABMSDT ABMMHPV=+$G(^XTMP("ABM-PVP2",$J,"PRV-NUM",ABMSDT,ABMPRV))
 W !!,"Total Patient Encounters of First Highest Patient Volume Period: ",ABMTHPV,!
 S ABMU("TXT")="Total Medicaid"_$S(+$G(ABMFQHC)=1:"/Needy Individual",1:"")
 S ABMU("TXT")=ABMU("TXT")_" Encounters of First Highest Patient Volume Period: "_ABMMHPV
 S ABMU("LM")=0,ABMU("RM")=80,ABMU("LNG")=80
 D ^ABMDWRAP
 D NMHDR
 ;
 S ABMSDT=0,ABMCNT=0
 S ABMDTCNT=0
 F  S ABMSDT=$O(^XTMP("ABM-PVP2",$J,"PRV-DENOM",ABMSDT)) Q:'ABMSDT  D
 .;I ABMY("90")'="A"&(ABMY("SDT")'=ABMSDT) Q  ;only calculate whole year for automated  ;abm*2.6*12 uncomp care
 .I "^A^D^"'[("^"_ABMY("90")_"^")&(ABMY("SDT")'=ABMSDT) Q  ;only whole year for automated ;abm*2.6*12 uncomp care
 .;start new code abm*2.6*12 HEAT134048
 .S X1=ABMY("SDT")
 .S X2=275
 .D C^%DTC
 .I "^A^D^"[("^"_ABMY("90")_"^")&(ABMSDT>X) Q  ;275 days after start won't contain 90 days anymore
 .;end new code HEAT134048
 .S ABMDTCNT=+$G(ABMDTCNT)+1
 .;
 .I $Y+5>IOSL D HD^ABMM2PV3,NMHDR Q:(IOST["C")&((+$G(Y)=0)!($D(DIRUT)!$D(DIROUT)!$D(DTOUT)!$D(DUOUT)))
 .S ABMP("PRV")=0
 .F  S ABMP("PRV")=$O(^XTMP("ABM-PVP2",$J,"PRV-DENOM",ABMSDT,ABMP("PRV"))) Q:'ABMP("PRV")  D
 ..I $Y+5>IOSL D HD^ABMM2PV3,NMHDR Q:(IOST["C")&((+$G(Y)=0)!($D(DIRUT)!$D(DIROUT)!$D(DTOUT)!$D(DUOUT)))
 ..I ABMP("PRV")'=ABMPRV Q
 ..;I +$G(ABMY("EDT"))=0 D
 ..;.S X1=ABMSDT
 ..;.S X2=89
 ..;.D C^%DTC
 ..;.S ABMEDT=X
 ..;I +$G(ABMY("EDT"))'=0 S ABMEDT=ABMY("EDT")
 ..S X1=ABMSDT
 ..S X2=89
 ..D C^%DTC
 ..S ABMEDT=X
 ..S ABMPD=$TR($P($$MDT^ABMDUTL(ABMSDT),"-",1,2),"-"," ")_"-"_$TR($P($$MDT^ABMDUTL(ABMEDT),"-",1,2),"-"," ")  ;report period
 ..S ABMRT=$J($G(^XTMP("ABM-PVP2",$J,"PRV PERCENT",ABMSDT,ABMPRV)),5)_"%"  ;rate
 ..S ABMDEN=$J(+$G(^XTMP("ABM-PVP2",$J,"PRV-DENOM",ABMSDT,ABMPRV)),6)  ;denominator
 ..S ABMNUM=$J(+$G(^XTMP("ABM-PVP2",$J,"PRV-NUM",ABMSDT,ABMPRV)),6)  ;numerator
 ..S ABMMCDPD=$J(+$G(^XTMP("ABM-PVP2",$J,"PRV-NUM PD",ABMSDT,ABMPRV,"MCD")),6)
 ..S ABMSCHPD=$J(+$G(^XTMP("ABM-PVP2",$J,"PRV-NUM PD",ABMSDT,ABMPRV,"CHIP")),5)
 ..S ABMMCDZP=$J(+$G(^XTMP("ABM-PVP2",$J,"PRV-NUM ZEROPD",ABMSDT,ABMPRV,"MCD")),6)
 ..S ABMMCDEN=$J(+$G(^XTMP("ABM-PVP2",$J,"PRV-NUM ENR",ABMSDT,ABMPRV,"MCD")),6)
 ..S ABMSCHZP=$J(+$G(^XTMP("ABM-PVP2",$J,"PRV-NUM ZEROPD",ABMSDT,ABMPRV,"CHIP")),5)
 ..S ABMSCHEN=$J(+$G(^XTMP("ABM-PVP2",$J,"PRV-NUM ENR",ABMSDT,ABMPRV,"CHIP")),5)
 ..;S ABMUNCOM=$J(+$G(^XTMP("ABM-PVP2",$J,"PRV-NUM UNCOMP",ABMSDT,ABMPRV,"UNCOMP")),6)  ;abm*2.6*12  ;abm*2.6*15 HEAT183289
 ..S ABMUNCOM=$J(+$G(^XTMP("ABM-PVP2",$J,"PRV-NUM UNCOMP",ABMSDT,ABMPRV,"UNCOMP")),4)  ;abm*2.6*15 HEAT183289 shortened to make room for tribal self-insured
 ..S ABMTSI=$J(+$G(^XTMP("ABM-PVP2",$J,"PRV-NUM TRIBSI",ABMSDT,ABMPRV,"TRIBSI")),2)  ;abm*2.6*15 HEAT183289 tribal self-insured not met
 ..;W !,ABMPD,?15,ABMRT,?20,ABMDEN,?28,ABMNUM,?35,ABMMCDPD,?41,ABMMCDZP,?50,ABMMCDEN,?57,ABMSCHPD,?63,ABMSCHZP,?73,ABMSCHEN  ;abm*2.6*12
 ..W !,ABMPD,?13,ABMRT,?20,ABMDEN,?27,ABMNUM,?34,ABMMCDPD,?41,ABMMCDZP,?48,ABMMCDEN,?55,ABMSCHPD,?62,ABMSCHZP,?67,ABMSCHEN  ;abm*2.6*12
 ..;I ABMFQHC=1 W ?74,ABMUNCOM  ;abm*2.6*12  ;abm*2.6*15 HEAT183289
 ..I ABMFQHC=1 W ?74,ABMUNCOM,?78,ABMTSI  ;abm*2.6*15 HEAT183289
 I ABMDTCNT=0 D
 .W !!, "<< NO DATA FOUND FOR SELECTION >>"
 Q
NMHDR ;EP
 W !
 F ABM=1:1:80 W "="
 W !,"MEDICAID"_$S($G(ABMFQHC)=1:"/NEEDY INDIVIDUAL",1:"")_" PATIENT VOLUME"_$S($G(ABMY("ADT"))="":" - QUALIFICATION YEAR "_ABMY("QYR"),1:"")
 ;start old code abm*2.6*12 uncomp care
 ;W !,"Report Period",?15,"Rate",?21,"Denom-",?30,"Numer-",?38,"Mcd",?44,"Mcd",?52,"Mcd",?58,"Schip",?64,"Schip",?73,"Schip"
 ;W !?21,"inator",?30,"ator",?37,"Paid",?42,"ZeroPd",?49,"Enrolled",?59,"Paid",?64,"ZeroPd",?71,"Enrolled"
 ;end old start new uncomp care
 W !?20,"Denom-",?28,"Numer-",?34,"|    --Medicaid--    | --- Schip --- |"
 ;I ABMFQHC=1 W ?73,"Uncomp-"  ;abm*2.6*15 HEAT183289 tribal self-insured
 I ABMFQHC=1 W ?73,"Un- |T"  ;abm*2.6*15 HEAT183289 tribal self-insured
 W !,"Report Period",?15,"Rate",?20,"inator",?28,"ator",?34,"|",?38,"Pd",?44,"ZP",?51,"En",?55,"|",?57,"Pd",?63,"ZP",?69,"En|"
 ;I ABMFQHC=1 W ?73,"ensated"  ;abm*2.6*15 HEAT183289 tribal self-insured
 I ABMFQHC=1 W ?73,"Comp|SI"  ;abm*2.6*15 HEAT183289 tribal self-insured
 ;end new uncomp care
 W !
 F ABM=1:1:80 W "="
 Q
HDR      ;EP
 S:ABMSDT="" ABMSDT=ABMY("SDT")
 I ABMY(90)="A"!(ABMY(90)="B") D
 .S X1=ABMSDT
 .S X2=89
 .D C^%DTC
 .S ABMEDT=X
 I ABMY(90)="C" S ABMEDT=ABMY("EDT")
 D EN^ABMVDF("IOF")
 W !
 I ABMY("RFMT")="P" D CENTER^ABMUCUTL("CONFIDENTIAL PATIENT INFORMATIONCOVERED BY THE PRIVACY ACT") W !
 I ABMY("RTYP")="SEL" D CENTER^ABMUCUTL("IHS Meaningful Use Patient Volume Report - Eligible Professional    Page "_ABM("PG"))
 I ABMY("RTYP")="GRP" D CENTER^ABMUCUTL("IHS Meaningful Use Patient Volume Report - Group Practice       Page "_ABM("PG"))
 I ABMY("RTYP")="HOS" D CENTER^ABMUCUTL("       IHS Meaningful Use Patient Volume Report - Hospital          Page "_ABM("PG"))
 I ABMY("RFMT")'="P",+$G(ABMPMET)=0 W ! D CENTER^ABMUCUTL("Minimum Patient Volume NOT Achieved")
 I ABMY("RFMT")="P" W ! D CENTER^ABMUCUTL("PATIENT LIST")
 W !
 D NOW^%DTC
 D CENTER^ABMUCUTL("Report Run Date:  "_$$CDT^ABMDUTL(%))
 W !
 D CENTER^ABMUCUTL("Report Generated by: "_$$GET1^DIQ(200,DUZ,.01,"E"))
 I ABM("PG")=1 D
 .S ABMFQHC=0  ;abm*2.6*12
 .I ABMY("RTYP")'="HOS" D
 ..W !!,"Participation Year: ",ABMY("PYR")
 ..W:("^A^B^C^"[("^"_ABMY("90")_"^")) !,"Qualification Year: ",ABMY("QYR")
 ..W:$G(ABMY("ADT")) !,"Attestation Date: ",$$SDT^ABMDUTL(ABMY("ADT"))
 .I ABMY("RTYP")="HOS" D
 ..W !!,"Participation Federal fiscal year: ",ABMY("PYR")
 ..W:("^A^B^C^"[("^"_ABMY("90")_"^")) !,"Qualification Year: ",ABMY("QYR")
 ..W:$G(ABMY("AYR")) !,"Attestation Federal fiscal year: ",ABMY("AYR")
 .I ("^F^H^"[("^"_$G(ABMY("A90"))_"^")) D
 ..W !,$S($G(ABMY("A90"))="F":"First",1:"Highest")_" Reporting Period Identified: "
 ..W $S(ABMSDT:$$SDT^ABMDUTL(ABMSDT),1:"")
 ..;start new abm*2.6*12
 ..S X1=$P(ABMSDT,".")
 ..S X2=+89
 ..D C^%DTC
 ..W " thru "_$$SDT^ABMDUTL(X)
 ..;end new abm*2.6*12
 .I ("^D^E^"[("^"_ABMY("90")_"^")) W !,$S($G(ABMY("90"))="D":"Automated",1:"Specified")_" 90-Day Period in last 12 months "
 .;I ("^A^D^E^"'[("^"_ABMY("90")_"^")) W !,"Reporting Period Identified: ",$S(ABMSDT:$$SDT^ABMDUTL(ABMSDT)_" thru "_$$SDT^ABMDUTL(ABMEDT),ABMY("SDT"):$$SDT^ABMDUTL(ABMY("SDT"))_" thru "_$$SDT^ABMDUTL(ABMEDT),1:"NONE FOUND")  ;abm*2.6*12 HEAT134048
 .;below line new abm*2.6*12 HEAT134048
 .I ("^F^H^"'[("^"_$G(ABMY("A90"))_"^")) W !,"Reporting Period Identified: ",$S(ABMSDT:$$SDT^ABMDUTL(ABMSDT)_" thru "_$$SDT^ABMDUTL(ABMEDT),ABMY("SDT"):$$SDT^ABMDUTL(ABMY("SDT"))_" thru "_$$SDT^ABMDUTL(ABMEDT),1:"NONE FOUND")
 .I ABMY("RTYP")'="HOS" D
 ..W !,"Facility(s): ",!
 ..S ABML=0
 ..;F  S ABML=$O(ABMF(ABML)) Q:'ABML  W ?10,$$GET1^DIQ(9999999.06,ABML,.01,"E"),$S($D(^ABMMUPRM(1,1,"B",ABML)):" (FQHC/RHC/Tribal)",1:""),! I $D(^ABMMUPRM(1,1,"B",ABML)) S ABMFQHC=1  ;abm*2.6*12 include Urban
 ..F  S ABML=$O(ABMF(ABML)) Q:'ABML  W ?10,$$GET1^DIQ(9999999.06,ABML,.01,"E"),$S($D(^ABMMUPRM(1,1,"B",ABML)):" (FQHC/RHC/Tribal/Urban)",1:""),! I $D(^ABMMUPRM(1,1,"B",ABML)) S ABMFQHC=1  ;abm*2.6*12 include Urban
 .;
 .;start old code abm*2.6*12 uncomp care
 .;I $G(ABMFQHC)=1 D
 .;.S ABMMPD=+$G(^XTMP("ABM-PVP2",$J,"PRV-NUM PD",ABMSDT,ABMPRV,"MCD"))
 .;.S ABMMZPD=+$G(^XTMP("ABM-PVP2",$J,"PRV-NUM ZEROPD",ABMSDT,ABMPRV,"MCD"))
 .;.S ABMMENR=+$G(^XTMP("ABM-PVP2",$J,"PRV-NUM ENR",ABMSDT,ABMPRV,"MCD"))
 .;.S ABMCPD=+$G(^XTMP("ABM-PVP2",$J,"PRV-NUM PD",ABMSDT,ABMPRV,"CHIP"))
 .;.S ABMCZPD=+$G(^XTMP("ABM-PVP2",$J,"PRV-NUM ZEROPD",ABMSDT,ABMPRV,"CHIP"))
 .;.S ABMCENR=+$G(^XTMP("ABM-PVP2",$J,"PRV-NUM ENR",ABMSDT,ABMPRV,"CHIP"))
 .;.S ABMOTHPD=+$G(^XTMP("ABM-PVP2",$J,"PRV ENC CNT",ABMSDT,ABMPRV,"OTHR"))
 .;.S (ABMTENC,ABMDENOM)=+$G(^XTMP("ABM-PVP2",$J,"PRV-DENOM",ABMSDT,ABMPRV))
 .;.I ABMY("RTYP")="GRP" D
 .;..S ABMMPD=+$G(^XTMP("ABM-PVP2",$J,"PRV-NUM PD",ABMSDT,"MCD"))
 .;..S ABMMZPD=+$G(^XTMP("ABM-PVP2",$J,"PRV-NUM ZEROPD",ABMSDT,"MCD"))
 .;..S ABMMENR=+$G(^XTMP("ABM-PVP2",$J,"PRV-NUM ENR",ABMSDT,"MCD"))
 .;..S ABMCPD=+$G(^XTMP("ABM-PVP2",$J,"PRV-NUM PD",ABMSDT,"CHIP"))
 .;..S ABMCZPD=+$G(^XTMP("ABM-PVP2",$J,"PRV-NUM ZEROPD",ABMSDT,"CHIP"))
 .;..S ABMCENR=+$G(^XTMP("ABM-PVP2",$J,"PRV-NUM ENR",ABMSDT,"CHIP"))
 .;..S ABMOTHPD=+$G(^XTMP("ABM-PVP2",$J,"PRV ENC CNT",ABMSDT,"OTHR"))
 .;..S (ABMTENC,ABMDENOM)=+$G(^XTMP("ABM-PVP2",$J,"PRV-DENOM",ABMSDT))
 .;.S ABMUNCOM=ABMTENC-ABMMPD-ABMMZPD-ABMMENR-ABMCPD-ABMCZPD-ABMCENR-ABMOTHPD
 .;.S ABMNUMER=ABMMPD+ABMMZPD+ABMMENR+ABMCPD+ABMCZPD+ABMCENR+ABMUNCOM
 .;.S ABMTUNCR=$S(+$G(ABMDENOM)>0:(ABMNUMER/ABMDENOM),1:0)
 .;.W !,"Uncompensated Care: ",$J(ABMTUNCR*100,0,1)_"%"
 .;end old code uncomp care
 .;
 .W !!,"SCHIP insurers included:"
 .I '$D(ABMI) W !?3,"<NONE>"
 .S ABMINS=0
 .F  S ABMINS=$O(ABMI("INS",ABMINS)) Q:'ABMINS  D
 ..W !?5,$$GET1^DIQ(9999999.18,ABMINS,".01","E")
 ;
 I +$G(ABMY("TVDTS"))'=0 W !!,"Number of top volume dates to display if minimum thresholds are not met: ",$J(ABMY("TVDTS"),3),!
 I ABMY("RFMT")="P",ABM("PG")'=1 W !
 I ABMY("RTYP")="SEL" W !,"Eligible Professional: ",$$GET1^DIQ(200,ABMPRV,".01")_" ("_$$GET1^DIQ(7,$$DOCLASS^ABMDVST2(ABMPRV),.01,"E")_")"
 I ABMY("RTYP")="GRP" D
 .Q:ABM("PG")'=1  ;only print on first page
 .W !!,"Eligible Professionals: "
 .I '$D(ABMPRV("E")) W !?3,"<NONE>"
 .S ABMPRV=0
 .F  S ABMPRV=$O(ABMPRV("E",ABMPRV)) Q:'ABMPRV  D
 ..I $Y+5>IOSL,IOST["C" D HD^ABMM2PV3 Q:(IOST["C")&((+$G(Y)=0)!($D(DIRUT)!$D(DIROUT)!$D(DTOUT)!$D(DUOUT)))
 ..W !?3,$$GET1^DIQ(200,ABMPRV,".01")_" ("_$$GET1^DIQ(7,$$DOCLASS^ABMDVST2(ABMPRV),.01,"E")_")"
 .W !!,"Other Professionals: "
 .I '$D(ABMPRV("O")) W !?3,"<NONE>"
 .S ABMPRV=0
 .F  S ABMPRV=$O(ABMPRV("O",ABMPRV)) Q:'ABMPRV  D
 ..I $Y+5>IOSL,IOST["C" D HD^ABMM2PV3 Q:(IOST["C")&((+$G(Y)=0)!($D(DIRUT)!$D(DIROUT)!$D(DTOUT)!$D(DUOUT)))
 ..W !?3,$$GET1^DIQ(200,ABMPRV,".01")_" ("_$$GET1^DIQ(7,$$DOCLASS^ABMDVST2(ABMPRV),.01,"E")_")"
 .I IOST["C" D HD^ABMM2PV3 Q:(IOST["C")&((+$G(Y)=0)!($D(DIRUT)!$D(DIROUT)!$D(DTOUT)!$D(DUOUT)))
 ;
 W !
 I ABMY("RFMT")="P" D
 .W !
 .Q:ABM("PG")'=1
 .S ABMU("TXT")="This Patient List is provided for Eligible "_$S(ABMY("RTYP")="HOS":"Hospitals",1:"Professionals")_" to evaluate their "
 .S ABMU("TXT")=ABMU("TXT")_"Medicaid"_$S($G(ABMFQHC)=1:"/Needy Individual",1:"")_" Patient Volume Encounters during the Report Period"
 .S ABMU("TXT")=ABMU("TXT")_" for participation in the Medicaid EHR Incentive program."
 .S ABMU("LM")=0,ABMU("RM")=80,ABMU("LNG")=80
 .D ^ABMDWRAP
 .W !
 I $Y+5>IOSL,IOST["C" D HD^ABMM2PV3 Q:(IOST["C")&((+$G(Y)=0)!($D(DIRUT)!$D(DIROUT)!$D(DTOUT)!$D(DUOUT)))
 ;
 Q
