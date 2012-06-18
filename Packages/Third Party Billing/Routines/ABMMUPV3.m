ABMMUPV3 ;IHS/SD/SDR - MU Patient Volume EP Report ;
 ;;2.6;IHS 3P BILLING SYSTEM;**7,8**;NOV 12, 2009
 ;
PRINT ;EP
 I ABMY("RTYP")="GRP" D GRPPRT^ABMMUPV4 Q  ;abm*2.6*8
 S ABMPRV=0
 F  S ABMPRV=$O(ABMP(ABMPRV)) Q:'ABMPRV  D  D PAZ^ABMDRUTL Q:$D(DTOUT)!$D(DUOUT)!$D(DIROUT)
 .S ABMPMET=0
 .I ABMY("RFMT")="P" D PATIENT Q
 .I +$G(^XTMP("ABM-PVP",$J,"PRV TOP",ABMPRV))>29.99 S ABMPMET=1 D MET Q
 .I +$G(^XTMP("ABM-PVP",$J,"PRV TOP",ABMPRV))>19.99&($$DOCLASS^ABMDVST2(ABMPRV)["PEDIAT") S ABMPMET=1 D MET Q
 .D NOTMET
 K ^XTMP("ABM-PVP",$J)
 Q
MET ;
 S ABM("PG")=1
 S ABMSDT=$P($G(^XTMP("ABM-PVP",$J,"PRV TOP",ABMPRV)),U,2)
 D HDR
 D MHDR
 I $Y+5>IOSL D HD Q:(IOST["C")&((+$G(Y)=0)!($D(DIRUT)!$D(DIROUT)!$D(DTOUT)!$D(DUOUT)))
 S ABMP("PRV")=0
 F  S ABMP("PRV")=$O(^XTMP("ABM-PVP",$J,"PRV-DENOM",ABMSDT,ABMP("PRV"))) Q:'ABMP("PRV")  D  Q:(IOST["C")&((+$G(Y)=0)!($D(DIRUT)!$D(DIROUT)!$D(DTOUT)!$D(DUOUT)))
 .I $Y+5>IOSL D HD Q:(IOST["C")&((+$G(Y)=0)!($D(DIRUT)!$D(DIROUT)!$D(DTOUT)!$D(DUOUT)))
 .I ABMP("PRV")'=ABMPRV Q
 .S ABMVLOC=0
 .F  S ABMVLOC=$O(^XTMP("ABM-PVP",$J,"PRV-DENOM",ABMSDT,ABMP("PRV"),ABMVLOC)) Q:'ABMVLOC  D
 ..I $Y+5>IOSL D HD Q:(IOST["C")&((+$G(Y)=0)!($D(DIRUT)!$D(DIROUT)!$D(DTOUT)!$D(DUOUT)))
 ..F ABM=1:1:80 W "-"
 ..S ABMLOC=$$GET1^DIQ(9999999.06,ABMVLOC,.02,"E")
 ..W !,"Patient Volume "_ABMLOC_": "_+$P($G(^XTMP("ABM-PVP",$J,"PRV PERCENT",ABMSDT,ABMPRV,ABMVLOC)),U)_"%"
 ..W !!,"Total Patient Encounters "_ABMLOC_": ",?54,$J(+$G(^XTMP("ABM-PVP",$J,"PRV-DENOM",ABMSDT,ABMPRV,ABMVLOC)),8)
 ..W !,"Total Paid Medicaid Encounters "_ABMLOC_": ",?54,$J(+$G(^XTMP("ABM-PVP",$J,"PRV ENC CNT",ABMSDT,ABMPRV,ABMVLOC,"MCD")),8)
 ..W !,"Total Paid Kidscare/Chip Encounters "_ABMLOC_": ",?54,$J(+$G(^XTMP("ABM-PVP",$J,"PRV ENC CNT",ABMSDT,ABMPRV,ABMVLOC,"CHIP")),8)
 ..W !,"Total Paid Other Encounters "_ABMLOC_": ",?54,$J(+$G(^XTMP("ABM-PVP",$J,"PRV ENC CNT",ABMSDT,ABMPRV,ABMVLOC,"OTHR")),8)
 ;
 W !
 F ABM=1:1:80 W "-"
 W !,"Patient Volume all calculated Facilities:  ",+$P($G(^XTMP("ABM-PVP",$J,"PRV TOP",ABMPRV)),U)_"%"
 W !!,"Total Patient Encounters All Facilities Total: ",?54,$J(+$G(^XTMP("ABM-PVP",$J,"PRV-DENOM",ABMSDT,ABMPRV)),8)
 W !,"Total Paid Medicaid Encounters All Facilities Total: ",?54,$J(+$G(^XTMP("ABM-PVP",$J,"PRV ENC CNT",ABMSDT,ABMPRV,"MCD")),8)
 W !,"Total Paid Kidscare/Chip Encounters All Facilities Total: ",?54,$J(+$G(^XTMP("ABM-PVP",$J,"PRV ENC CNT",ABMSDT,ABMPRV,"CHIP")),8)
 W !,"Total Paid Other Encounters All Facilities Total: ",?54,$J(+$G(^XTMP("ABM-PVP",$J,"PRV ENC CNT",ABMSDT,ABMPRV,"OTHR")),8)
 W !
 Q
MHDR ;
 W !
 S ABMU("TXT")="Patient Volume for the Qualification Year was calculated using the Medicaid"_$S(+$G(ABMFQHC)=1:"/Needy Individual",1:"")
 S ABMU("TXT")=ABMU("TXT")_" calculation method."
 S ABMU("LM")=0,ABMU("RM")=80,ABMU("LNG")=80
 D ^ABMDWRAP
 W !
 Q
NOTMET ;EP
 S ABMCNT=0
 K ABMLN
 S ABMSDT=$P($G(^XTMP("ABM-PVP",$J,"PRV TOP",ABMPRV)),U,2)
 ;
 I +$G(ABMY("TVDTS"))'=0 D
 .S ABMCNT=0
 .S ABMDT=0
 .F  S ABMDT=$O(^XTMP("ABM-PVP",$J,"PRV PERCENT",ABMDT)) Q:'ABMDT  D
 ..I $Y+5>IOSL D HD Q:(IOST["C")&((+$G(Y)=0)!($D(DIRUT)!$D(DIROUT)!$D(DTOUT)!$D(DUOUT)))  ;abm*2.6*8
 ..S ABMP("PRV")=0
 ..F  S ABMP("PRV")=$O(^XTMP("ABM-PVP",$J,"PRV PERCENT",ABMDT,ABMP("PRV"))) Q:'ABMP("PRV")  D
 ...I ABMP("PRV")'=ABMPRV Q
 ...S ABMCNT=ABMCNT+1
 ...S ABMPRC($G(^XTMP("ABM-PVP",$J,"PRV PERCENT",ABMDT,ABMPRV)),ABMCNT)=ABMDT
 .S ABMP=""
 .S ABMSAV=ABMCNT-ABMY("TVDTS")
 .F  S ABMP=$O(ABMPRC(ABMP)) Q:ABMP=""  D
 ..S ABMCNT=0,ABMC=0
 ..F  S ABMCNT=$O(ABMPRC(ABMP,ABMCNT)) Q:'ABMCNT  D  Q:(ABMC=ABMSAV)
 ...K ^XTMP("ABM-PVP",$J,"PRV PERCENT",$G(ABMPRC(ABMP,ABMCNT))),ABMP("PRV")
 ...S ABMC=ABMC+1
 ;
 S ABM("PG")=1
 S ABMSDT=$P($G(^XTMP("ABM-PVP",$J,"PRV TOP",ABMPRV)),U,2)
 I +ABMSDT=0 S ABMSDT=ABMY("SDT")
 D HDR
 W !,"The Patient Volume Threshold (30% for EPs, or 20% for Pediatricians) was not"
 W !,"met for the MU Qualification year."
 W !,"Details for the volumes that were achieved are provided for your information.",!
 W !,"Highest Patient Volume Met: ",+$P($G(^XTMP("ABM-PVP",$J,"PRV TOP",ABMPRV)),U)_"%"
 W !,"First Day Highest Patient Volume Achieved: ",$$SDT^ABMDUTL(ABMSDT)
 W !!,"Patient Volume for the Qualification Year was calculated using the Medicaid"
 W !,$S(+$G(ABMFQHC)=1:"/Needy Individual",1:"")_" calculation method."
 ;
 I $Y+5>IOSL D HD Q:(IOST["C")&((+$G(Y)=0)!($D(DIRUT)!$D(DIROUT)!$D(DTOUT)!$D(DUOUT)))  ;abm*2.6*8
 S ABMTHPV=0
 S:ABMSDT ABMTHPV=+$G(^XTMP("ABM-PVP",$J,"PRV-DENOM",ABMSDT,ABMPRV))
 S ABMMHPV=0
 S:ABMSDT ABMMHPV=+$G(^XTMP("ABM-PVP",$J,"PRV-NUM",ABMSDT,ABMPRV))
 W !!,"Total Patient Encounters of First Highest Patient Volume Period:",ABMTHPV,!
 S ABMU("TXT")="Total Medicaid"_$S(+$G(ABMFQHC)=1:"/Needy Individual",1:"")
 S ABMU("TXT")=ABMU("TXT")_" Encounters of First Highest Patient VolumePeriod: "_ABMMHPV
 S ABMU("LM")=0,ABMU("RM")=80,ABMU("LNG")=80
 D ^ABMDWRAP
 D NMHDR
 ;
 S ABMSDT=0,ABMCNT=0
 F  S ABMSDT=$O(^XTMP("ABM-PVP",$J,"PRV-DENOM",ABMSDT)) Q:'ABMSDT  D
 .;
 .S ABMP("PRV")=0
 .F  S ABMP("PRV")=$O(^XTMP("ABM-PVP",$J,"PRV-DENOM",ABMSDT,ABMP("PRV"))) Q:'ABMP("PRV")  D
 ..I ABMP("PRV")'=ABMPRV Q
 ..;start old code abm*2.6*8 NOHEAT
 ..;S X1=ABMSDT
 ..;S X2=89
 ..;D C^%DTC
 ..;S ABMEDT=X
 ..;end old code start new code
 ..I +$G(ABMY("EDT"))=0 D
 ...S X1=ABMSDT
 ...S X2=89
 ...D C^%DTC
 ...S ABMEDT=X
 ..I +$G(ABMY("EDT"))'=0 S ABMEDT=ABMY("EDT")
 ..;end new code
 ..S ABMCNT=ABMCNT+1
 ..S ABMLN(ABMCNT)=$TR($P($$MDT^ABMDUTL(ABMSDT),"-",1,2),"-"," ")_" - "_$TR($P($$MDT^ABMDUTL(ABMEDT),"-",1,2),"-"," ")  ;report period
 ..S $P(ABMLN(ABMCNT),U,2)=$J($G(^XTMP("ABM-PVP",$J,"PRV PERCENT",ABMSDT,ABMPRV)),3)_"%"  ;rate
 ..S $P(ABMLN(ABMCNT),U,3)=$J(+$G(^XTMP("ABM-PVP",$J,"PRV-DENOM",ABMSDT,ABMPRV)),6)  ;denominator
 ..S $P(ABMLN(ABMCNT),U,4)=$J(+$G(^XTMP("ABM-PVP",$J,"PRV-NUM",ABMSDT,ABMPRV)),6)  ;numerator
 S ABMCUTOF=$S(ABMCNT#2=1:(ABMCNT+1)\2,1:ABMCNT\2)
 S ABMMCNT=1
 F ABMCUTOF=(ABMCUTOF+1):1:ABMCNT D
 .S ABMLN(ABMMCNT)=ABMLN(ABMMCNT)_U_ABMLN(ABMCUTOF)
 .K ABMLN(ABMCUTOF)
 .S ABMMCNT=+$G(ABMMCNT)+1
 S ABMCNT=0
 F  S ABMCNT=$O(ABMLN(ABMCNT)) Q:'ABMCNT  D  Q:(IOST["C")&((+$G(Y)=0)!($D(DIRUT)!$D(DIROUT)!$D(DTOUT)!$D(DUOUT)))
 .I $Y+5>IOSL D HD,NMHDR Q:(IOST["C")&((+$G(Y)=0)!($D(DIRUT)!$D(DIROUT)!$D(DTOUT)!$D(DUOUT)))
 .S ABMPD=$P(ABMLN(ABMCNT),U)
 .S ABMRT=$P(ABMLN(ABMCNT),U,2)
 .S ABMDEN=$P(ABMLN(ABMCNT),U,3)
 .S ABMNUM=$P(ABMLN(ABMCNT),U,4)
 .S ABMPD2=$P(ABMLN(ABMCNT),U,5)
 .S ABMRT2=$P(ABMLN(ABMCNT),U,6)
 .S ABMDEN2=$P(ABMLN(ABMCNT),U,7)
 .S ABMNUM2=$P(ABMLN(ABMCNT),U,8)
 .W !,ABMPD,?16,ABMRT,?21,ABMDEN,?29,ABMNUM,?40,ABMPD2,?56,ABMRT2,?63,ABMDEN2,?71,ABMNUM2
 Q
NMHDR ;EP
 W !
 F ABM=1:1:80 W "="
 W !,"MEDICAID"_$S($G(ABMFQHC)=1:"/NEEDY INDIVIDUAL",1:"")_" PATIENT VOLUME - QUALIFICATION YEAR ",ABMY("QYR")
 W !,"Report Period",?16,"Rate",?22,"Denom-",?31,"Numer-",?40,"Report Period",?56,"Rate",?63,"Denom-",?71,"Numer-"
 W !?22,"inator",?31,"ator",?63,"inator",?71,"ator"
 W !
 F ABM=1:1:80 W "="
 Q
PATIENT  ;EP
 S ABM("PG")=1
 S ABMSDT=$P($G(^XTMP("ABM-PVP",$J,"PRV TOP",ABMPRV)),U,2)
 D HDR
 Q:ABMSDT=""
 S ABMVLOC=0
 F  S ABMVLOC=$O(^XTMP("ABM-PVP",$J,"PT LST",ABMSDT,ABMPRV,ABMVLOC)) Q:'ABMVLOC  D  Q:(IOST["C")&((+$G(Y)=0)!($D(DIRUT)!$D(DIROUT)!$D(DTOUT)!$D(DUOUT)))
 .D PTHDR
 .S ABMITYP=""
 .F  S ABMITYP=$O(^XTMP("ABM-PVP",$J,"PT LST",ABMSDT,ABMPRV,ABMVLOC,ABMITYP)) Q:ABMITYP=""  D  Q:(IOST["C")&((+$G(Y)=0)!($D(DIRUT)!$D(DIROUT)!$D(DTOUT)!$D(DUOUT)))
 ..S ABMINS=""
 ..F  S ABMINS=$O(^XTMP("ABM-PVP",$J,"PT LST",ABMSDT,ABMPRV,ABMVLOC,ABMITYP,ABMINS)) Q:ABMINS=""  D  Q:(IOST["C")&((+$G(Y)=0)!($D(DIRUT)!$D(DIROUT)!$D(DTOUT)!$D(DUOUT)))
 ...S ABMPTL=""
 ...F  S ABMPTL=$O(^XTMP("ABM-PVP",$J,"PT LST",ABMSDT,ABMPRV,ABMVLOC,ABMITYP,ABMINS,ABMPTL)) Q:ABMPTL=""  D  Q:(IOST["C")&((+$G(Y)=0)!($D(DIRUT)!$D(DIROUT)!$D(DTOUT)!$D(DUOUT)))
 ....S ABMPTF=""
 ....F  S ABMPTF=$O(^XTMP("ABM-PVP",$J,"PT LST",ABMSDT,ABMPRV,ABMVLOC,ABMITYP,ABMINS,ABMPTL,ABMPTF)) Q:ABMPTF=""  D  Q:(IOST["C")&((+$G(Y)=0)!($D(DIRUT)!$D(DIROUT)!$D(DTOUT)!$D(DUOUT)))
 .....S ABMVDT=0
 .....F  S ABMVDT=$O(^XTMP("ABM-PVP",$J,"PT LST",ABMSDT,ABMPRV,ABMVLOC,ABMITYP,ABMINS,ABMPTL,ABMPTF,ABMVDT)) Q:'ABMVDT  D  Q:(IOST["C")&((+$G(Y)=0)!($D(DIRUT)!$D(DIROUT)!$D(DTOUT)!$D(DUOUT)))
 ......S ABMVDFN=$P($G(^XTMP("ABM-PVP",$J,"PT LST",ABMSDT,ABMPRV,ABMVLOC,ABMITYP,ABMINS,ABMPTL,ABMPTF,ABMVDT)),U)
 ......S ABMPT=$P($G(^XTMP("ABM-PVP",$J,"PT LST",ABMSDT,ABMPRV,ABMVLOC,ABMITYP,ABMINS,ABMPTL,ABMPTF,ABMVDT)),U,2)
 ......S ABMTRIEN=$P($G(^XTMP("ABM-PVP",$J,"PT LST",ABMSDT,ABMPRV,ABMVLOC,ABMITYP,ABMINS,ABMPTL,ABMPTF,ABMVDT)),U,3)
 ......S IENS=ABMVLOC_","_ABMPT_","
 ......S ABMHRN=$$GET1^DIQ(9000001.41,IENS,.02)
 ......W !,$E(ABMPTL_", "_ABMPTF,1,16)  ;pt name
 ......W ?18,ABMHRN  ;HRN
 ......W ?25,$E($$GET1^DIQ(9000010,ABMVDFN,.07,"E"),1,3)  ;Category
 ......W ?29,$E($$GET1^DIQ(9000010,ABMVDFN,.08,"E"),1,8)  ;clinic
 ......W ?39,$S(ABMITYP="X":"",1:ABMITYP)  ;insurer type
 ......W ?42,$S(ABMINS="NO BILL":"NOT BILLED",1:$E(ABMINS,1,10))  ;insurer
 ......W ?53,$$CDT^ABMDUTL(ABMVDT)  ;visit date
 ......W ?70,$S(+ABMTRIEN:$$SDTO^ABMDUTL(ABMTRIEN),1:"") ;dt paid
 ......I $P($G(^XTMP("ABM-PVP",$J,"PT LST",ABMSDT,ABMPRV,ABMVLOC,ABMITYP,ABMINS,ABMPTL,ABMPTF,ABMVDT)),U,4)'="" W ?79,$P(^(ABMVDT),U,4)
 ......I $Y+5>IOSL D HD,PTHDR Q:(IOST["C")&((+$G(Y)=0)!($D(DIRUT)!$D(DIROUT)!$D(DTOUT)!$D(DUOUT)))
 Q
PTHDR    ;
 I IOST["C",(ABM("PG")=1) D HD  ;start data on 2nd page of report
 W !,"VISIT LOCATION: ",$$GET1^DIQ(9999999.06,ABMVLOC,.02,"E"),!
 F ABM=1:1:80 W "="
 W !,?25,"Ser",?39,"I.",?42,"Billed",?53,"Date of",?70,"Date"
 W !,"PATIENT NAME",?18,"CHART#",?25,"Cat",?29,"Clinic",?39,"T.",?42,"To",?53,"Service",?70,"Paid",!
 F ABM=1:1:80 W "="
 Q
HD D PAZ^ABMDRUTL Q:$D(DTOUT)!$D(DUOUT)!$D(DIROUT)
 S ABM("PG")=+$G(ABM("PG"))+1
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
 ;I ABMY("RTYP")'="HOS" D CENTER^ABMUCUTL("IHS Meaningful Use Patient Volume Report - Eligible Professional    Page "_ABM("PG"))  ;abm*2.6*8
 I ABMY("RTYP")="SEL" D CENTER^ABMUCUTL("IHS Meaningful Use Patient Volume Report - Eligible Professional    Page "_ABM("PG"))  ;abm*2.6*8
 I ABMY("RTYP")="GRP" D CENTER^ABMUCUTL("IHS Meaningful Use Patient Volume Report - Group Practice       Page "_ABM("PG"))  ;abm*2.6*8
 I ABMY("RTYP")="HOS" D CENTER^ABMUCUTL("       IHS Meaningful Use Patient Volume Report - Hospital          Page "_ABM("PG"))
 I ABMY("RFMT")'="P",+$G(ABMPMET)=0 W ! D CENTER^ABMUCUTL("Minimum Patient Volume NOT Achieved")
 I ABMY("RFMT")="P" W ! D CENTER^ABMUCUTL("PATIENT LIST BY PROVIDER")
 W !
 D NOW^%DTC
 D CENTER^ABMUCUTL("Report Run Date:  "_$$CDT^ABMDUTL(%))
 W !
 D CENTER^ABMUCUTL("Report Generated by: "_$$GET1^DIQ(200,DUZ,.01,"E"))
 I ABM("PG")=1 D
 .I ABMY("RTYP")'="HOS" D
 ..W !!,"Participation Year: ",ABMY("PYR")
 ..W !,"Qualification Year: ",ABMY("QYR")
 .I ABMY("RTYP")="HOS" D
 ..W !!,"Participation Federal fiscal year: ",ABMY("PYR")
 ..W !,"Qualification Federal fiscal year: ",ABMY("QYR")
 .W !,"Reporting Period Identified: ",$S(ABMSDT:$$SDT^ABMDUTL(ABMSDT)_"thru "_$$SDT^ABMDUTL(ABMEDT),ABMY("SDT"):$$SDT^ABMDUTL(ABMY("SDT"))_" thru "_$$SDT^ABMDUTL(ABMEDT),1:"NONE FOUND")
 .I ABMY("RTYP")'="HOS" D
 ..W !,"Facility(s): ",!
 ..S ABML=0
 ..F  S ABML=$O(ABMF(ABML)) Q:'ABML  W ?10,$$GET1^DIQ(9999999.06,ABML,.01,"E"),$S($D(^ABMMUPRM(1,1,"B",ABML)):" (FQHC/RHC)",1:""),! I $D(^ABMMUPRM(1,1,"B",ABML)) S ABMFQHC=1
 I +$G(ABMY("TVDTS"))'=0 W !!,"Number of top volume dates to display ifminimum thresholds are not met: ",$J(ABMY("TVDTS"),3),!
 I ABMY("RFMT")="P",ABM("PG")'=1 W !
 ;I ABMY("RTYP")'="HOS" W !,"Eligible Professional: ",$$GET1^DIQ(200,ABMPRV,".01")_" ("_$$GET1^DIQ(7,$$DOCLASS^ABMDVST2(ABMPRV),.01,"E")_")"  ;abm*2.6*8
 I ABMY("RTYP")="SEL" W !,"Eligible Professional: ",$$GET1^DIQ(200,ABMPRV,".01")_" ("_$$GET1^DIQ(7,$$DOCLASS^ABMDVST2(ABMPRV),.01,"E")_")"  ;abm*2.6*8
 ;start new code abm*2.6*8
 I ABMY("RTYP")="GRP" D
 .Q:ABM("PG")'=1  ;only print on first page
 .W !,"Eligible Professionals: "
 .I '$D(ABMPRV("E")) W !?3,"<NONE>"
 .S ABMPRV=0
 .F  S ABMPRV=$O(ABMPRV("E",ABMPRV)) Q:'ABMPRV  D
 ..I $Y+5>IOSL D HD Q:(IOST["C")&((+$G(Y)=0)!($D(DIRUT)!$D(DIROUT)!$D(DTOUT)!$D(DUOUT)))
 ..W !?3,$$GET1^DIQ(200,ABMPRV,".01")_" ("_$$GET1^DIQ(7,$$DOCLASS^ABMDVST2(ABMPRV),.01,"E")_")"
 .W !!,"Other Professionals: "
 .I '$D(ABMPRV("O")) W !?3,"<NONE>"
 .S ABMPRV=0
 .F  S ABMPRV=$O(ABMPRV("O",ABMPRV)) Q:'ABMPRV  D
 ..I $Y+5>IOSL D HD Q:(IOST["C")&((+$G(Y)=0)!($D(DIRUT)!$D(DIROUT)!$D(DTOUT)!$D(DUOUT)))
 ..W !?3,$$GET1^DIQ(200,ABMPRV,".01")_" ("_$$GET1^DIQ(7,$$DOCLASS^ABMDVST2(ABMPRV),.01,"E")_")"
 .D HD Q:(IOST["C")&((+$G(Y)=0)!($D(DIRUT)!$D(DIROUT)!$D(DTOUT)!$D(DUOUT)))
 ;end new code abm*2.6*8
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
 I $Y+5>IOSL D HD Q:(IOST["C")&((+$G(Y)=0)!($D(DIRUT)!$D(DIROUT)!$D(DTOUT)!$D(DUOUT)))  ;abm*2.6*8
 ;
 Q
