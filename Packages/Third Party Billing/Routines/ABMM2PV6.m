ABMM2PV6 ;IHS/SD/SDR - MU Patient Volume EP Report ;
 ;;2.6;IHS 3P BILLING SYSTEM;**11**;NOV 12, 2009;Build 133
 ;
SUMMARY ;
 D EN^ABMVDF("IOF")
 W !
 D CENTER^ABMUCUTL("SUMMARY OF PATIENT VOLUME REPORT TO BE GENERATED")
 W !!!,"Report Name: "
 I ABMY("RTYP")="SEL" W "Patient Volume Report for Eligible Professionals"
 I ABMY("RTYP")="GRP" W "Patient Volume Report for Group Practice"
 I ABMY("RTYP")="HOS" W "Patient Volume Report for Eligible Hospitals"
 W !,"The date ranges for this report are:"
 W !?3,"Participation Year: ",ABMY("PYR")
 I "^A^B^C^"[("^"_ABMY("90")_"^") W !?3,"Qualification Year: ",ABMY("QYR")
 W !,"Reporting Period: "
 I ABMY("90")="A"!(ABMY("90")="D") W "Automated ",$S(ABMY("A90")="F":"First",1:"Highest")," 90-day"
 I ABMY("90")="B"!(ABMY("90")="E") W "90-day beginning ",$$SDT^ABMDUTL(ABMY("SDT"))
 I ABMY("90")="C" W $$SDT^ABMDUTL(ABMY("SDT"))_" thru "_$$SDT^ABMDUTL(ABMY("EDT"))
 I ABMY("90")="D"!(ABMY("90")="E") W !,"Attestation Date: "
 W:(ABMY("90")="D") $$SDT^ABMDUTL(ABMY("ADT"))
 W:(ABMY("90")="E") $$SDT^ABMDUTL(ABMY("SDT"))
 W:$G(ABMY("TVDTS")) !!,"Number of top volume dates to display if minimum thresholds are not met: ",ABMY("TVDTS")
 W !!,"Report Method Type: "
 W:ABMY("RTYP")="SEL" "Individual"
 W:ABMY("RTYP")="GRP" "Group"
 W:ABMY("RTYP")="HOS" "Hospital/ER"
 ;
 W !!,"SCHIP insurers included:"
 I '$D(ABML) W !?3,"<NONE>"
 S ABMINS=0
 F  S ABMINS=$O(ABMI("INS",ABMINS)) Q:'ABMINS  D
 .W !?5,$$GET1^DIQ(9999999.18,ABMINS,".01","E")
 I ABMY("RTYP")="SEL" D
 .W !!,"Eligible Professional(s):"
 .S ABMPRV=0
 .F  S ABMPRV=$O(ABMPRVDR(ABMPRV)) Q:'ABMPRV  D
 ..W !?3,$$GET1^DIQ(200,ABMPRV,".01")_" ("_$$GET1^DIQ(7,$$GET1^DIQ(200,ABMPRV,53.5,"I"),.01,"E")_")"
 W !
 W !,"Facility(s):"
 S ABMFC=0
 F  S ABMFC=$O(ABMF(ABMFC)) Q:'ABMFC  D
 .W !?3,$$GET1^DIQ(9999999.06,ABMFC,".01","E")
 .I $D(^ABMMUPRM(1,1,"B",ABMFC)) W " (FQHC/RHC/Tribal)"
 Q
