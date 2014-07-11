ABMM2PVP ;IHS/SD/SDR - MU Patient Volume EP Report ;
 ;;2.6;IHS 3P BILLING SYSTEM;**11**;NOV 12, 2009;Build 133
 ;
 I $P($G(^ABMMUPRM(1,0)),U,2)="" D  Q
 .W !!,"Setup has not been done.  Please do MUP option prior to running any reports",!
 .S DIR(0)="E",DIR("A")="Enter RETURN to Continue" D ^DIR K DIR
 ;
EN ;
 K ABMF,ABMPRVDR,ABMY,ABM,ABMEFLG
 D FAC Q:$D(DTOUT)!$D(DUOUT)!$D(DIROUT)!'$D(ABMF)
 ;
 W !!,"In order for an Eligible Professional (EP) to participate in the Medicaid EHR"
 W !,"Incentive program EPs have to meet a patient volume requirement of 30% or 20%"
 W !,"minimum for pediatricians. This can be accomplished as an individual or as a"
 W !,"group."
 ;
 W !!,"The SEL report is to be used to determine patient volume for an individual EP."
 W !,"The GRP report is to be used to determine patient volume for an entire group"
 W !,"practice. If GRP report is utilized all EPs within the facility will need to"
 W !,"utilize the GRP report."
 ;
 W !!
 D RTYPE
 Q:$D(DTOUT)!$D(DUOUT)!$D(DIROUT)!$D(DIRUT)
 I ABMY("RTYP")="SEL" D  Q:$D(DTOUT)!$D(DUOUT)!$D(DIROUT)!'$D(ABMPRVDR)
 .D PRVDR Q:$D(DTOUT)!$D(DUOUT)!$D(DIROUT)!'$D(ABMPRVDR)
 D PARTYR Q:$D(DTOUT)!$D(DUOUT)!$D(DIRUT)!$D(DIROUT)
 D SELINS
 D 90DAY Q:$D(DTOUT)!$D(DUOUT)!$D(DIRUT)!$D(DIROUT)
 I $G(ABMY("90"))=""!($G(ABMY("90"))'="A"&(+$G(ABMY("SDT"))=0)) K ABMY,ABMPRVDR,ABMF,ABMP,ABMPRV G EN
 D RFORMAT Q:$D(DTOUT)!$D(DUOUT)!$D(DIRUT)!$D(DIROUT)
 D SUMMARY
 D ^XBFMK
 S DIR(0)="S^P:Print Report;R:Return to Selection Criteria -Erases ALL previous selections"
 S DIR("A")="<P> to Print or <R> to Reselect"
 I ABMY("RFMT")="P" D
 .S DIR(0)="S^P:Print Report;H:Print Delimited Report to the HOST FILE;R:Return to Selection Criteria -Erases ALL previous selections"
 .S DIR("A")="<P> to Print, <H> to Host File, or <R> to Reselect"
 D ^DIR K DIR Q:$D(DTOUT)!$D(DUOUT)!$D(DIRUT)!$D(DIROUT)
 I $P(Y,U)="R" K ABMY,ABMPRVDR,ABMF,ABMP,ABMPRV G EN
 I $P(Y,U)="H" D  Q  ;host file selected; prompt for path/filename
 .D ^XBFMK
 .S DIR(0)="F"
 .S DIR("A")="Enter Path"
 .S DIR("B")=$P($G(^ABMDPARM(DUZ(2),1,4)),"^",7)
 .D ^DIR K DIR
 .I $G(Y)["^" S POP=1 Q
 .S ABMPATH=$S($G(Y)="":ABMPATH,1:Y)
 .D ^XBFMK
 .S DIR(0)="F"
 .S DIR("A")="Enter filename"
 .D ^DIR K DIR
 .I $G(Y)["^" S POP=1 Q
 .S ABMFN=Y
 .D COMPUTE^ABMM2PV1
 W !!,"Note: This report will take a while to run based on the amount of data you have"
 S ABMQ("RX")="POUT^ABMDRUTL"
 S ABMQ("NS")="ABM"
 S ABMQ("RP")="COMPUTE^ABMM2PV1"
 D ^ABMDRDBQ
 Q
 ;
RTYPE ;
 K ^XTMP("ABM-PVP2",$J)
 D ^XBFMK
 S DIR(0)="SO^SEL:Encounter method for each EP;GRP:Group method for facilities"
 S DIR("A")="Select report type"
 D ^DIR K DIR
 Q:$D(DTOUT)!$D(DUOUT)!$D(DIRUT)!$D(DIROUT)
 S ABMY("RTYP")=Y
 Q
PRVDR ;EP
 W !
 F  D  Q:(+Y<0)
 .D ^XBFMK
 .S DIC="^VA(200,"
 .S DIC(0)="AEMQ"
 .D ^DIC
 .S ABMPRV=+Y
 .I +Y<0 Q  ;nothing selected
 .I +$$GET1^DIQ(200,ABMPRV,53.5,"I")=0 D  Q
 ..W !!,"Provider "_$$GET1^DIQ(200,ABMPRV,".01","E")_" does not have a Provider Class so they can't be"
 ..W !,"considered for this report"
 ..W !,"Please enter a different Eligible Professional's name.",!!
 .;
 .I '$D(^ABMMUPRM(1,2,"B",$$GET1^DIQ(200,ABMPRV,53.5,"I"))) D  Q
 ..W !!,"Provider "_$$GET1^DIQ(200,ABMPRV,".01","E")_" ("_$$GET1^DIQ(200,ABMPRV,53.5,"E")_")"
 ..W !,"is not an Eligible Professional for the Medicaid MU EHR Program"
 ..W !,"Please enter a different Eligible Professional's name.",!!
 .;
 .I $$GET1^DIQ(200,ABMPRV,53.5,"E")="PHYSICIAN ASSISTANT" D  Q:ABMPAFLG=0
 ..S ABMPAFLG=0
 ..I $D(^ABMMUPRM(1,1,"B")) D
 ...S ABMFQ=0
 ...F  S ABMFQ=$O(^ABMMUPRM(1,1,ABMFQ)) Q:'ABMFQ  D
 ....I $P($G(^ABMMUPRM(1,1,ABMFQ,0)),U,2)=1 S ABMPAFLG=1
 ..Q:ABMPAFLG=1
 ..W !!,"Provider "_$$GET1^DIQ(200,ABMPRV,".01","E")_" ("_$$GET1^DIQ(200,ABMPRV,53.5,"E")_")"
 ..W !,"can't be included because the facility has to be led by a PA for a PA"
 ..W !,"to qualify"
 .S ABMPRVDR(ABMPRV)=""
 M ABMP=ABMPRVDR
 Q
FAC ;
 D GETFACS^ABMM2MUP  ;get list of facilities
 W !!
 K ABMFANS,ABMF
 F  D  Q:+$G(Y)<0!(Y=ABMTOT)!$D(DTOUT)!$D(DUOUT)!$D(DIRUT)!$D(DIROUT)  ;they didn't answer or ALL was selected
 .D ^XBFMK
 .D FACLST
 .S DIR(0)="SO^"_$G(ABMDIR)
 .S:'$D(ABMF) DIR(0)="S^"_$G(ABMDIR)
 .I ABMFQHC=1 D
 ..S DIR("A",1)="Note: you cannot select a combination of FQHC/RHC/Tribal and non-FQHC/RHC/Tribal"
 ..S DIR("A",2)="data on this report"
 ..S DIR("A",3)=""
 .S DIR("A")="Select one or more facilities to use for calculating patient volume"
 .D ^DIR K DIR
 .Q:$D(DTOUT)!$D(DUOUT)!$D(DIRUT)!$D(DIROUT)
 .S ABMFANS=Y
 .I ABMFANS'=ABMTOT,$D(ABMF),(ABMFQHC>1),'$D(^ABMMUPRM(1,1,"B",ABMFLIST(ABMFANS)))  W !!,"only FQHC/RHC/Tribals are allowed based on your first selection" H 1 Q
 .I ABMFANS'=ABMTOT,$D(ABMF),(ABMFQHC=0),$D(^ABMMUPRM(1,1,"B",ABMFLIST(ABMFANS)))  W !!,"only non-FQHC/RHC/Tribal clinics are allowed based on your first selection" H 1 Q
 .I ABMFANS'=ABMTOT,$D(^ABMMUPRM(1,1,"B",ABMFLIST(ABMFANS))) S ABMFQHC=2
 .I ABMFANS'=(ABMTOT) S ABMF($G(ABMFLIST(ABMFANS)))=""
 .I ABMFANS=(ABMTOT) D
 ..S ABMCNT=0
 ..F  S ABMCNT=$O(ABMFLIST(ABMCNT)) Q:'ABMCNT  S ABMF($G(ABMFLIST(ABMCNT)))=""
 K ABMFQHC
 Q
FACLST ;
 S ABMCNT=0,ABMDIR="",ABMFQHC=0,ABMNFQHC=0
 F  S ABMCNT=$O(ABMFLIST(ABMCNT)) Q:'ABMCNT  D
 .S:ABMDIR'="" ABMDIR=ABMDIR_";"_ABMCNT_":"_$$GET1^DIQ(9999999.06,$G(ABMFLIST(ABMCNT)),.01,"E")
 .S:ABMDIR="" ABMDIR=ABMCNT_":"_$$GET1^DIQ(9999999.06,$G(ABMFLIST(ABMCNT)),.01,"E")
 .S ABMDIR=ABMDIR_$S($D(^ABMMUPRM(1,1,"B",ABMFLIST(ABMCNT))):" (FQHC/RHC/Tribal)",1:"")
 .S ABMDIR=ABMDIR_$S($D(ABMF($G(ABMFLIST(ABMCNT)))):" *",1:"")
 .I $D(^ABMMUPRM(1,1,"B",ABMFLIST(ABMCNT))) S ABMFQHC=1
 .I '$D(^ABMMUPRM(1,1,"B",ABMFLIST(ABMCNT))) S ABMNFQHC=1
 S ABMCNT=$O(ABMFLIST(99999),-1)  ;get last entry#
 S (ABMCNT,ABMTOT)=ABMCNT+1
 I ((ABMFQHC=0&(ABMNFQHC=1))!((ABMFQHC=1)&(ABMNFQHC=0)))!(ABMCNT<2) S ABMDIR=ABMDIR_";"_ABMCNT_":All facilities"
 Q
PARTYR ;
 I ABMY("RTYP")="SEL"!(ABMY("RTYP")="GRP") D
 .W !!!,"For EPs, the Participation year is based on a calendar year;"
 .W !,"this is the same year that the EP would be demonstrating Meaningful"
 .W !,"Use. (Calendar year is January 1- December 31)"
 D ^XBFMK
 S DIR(0)="NA^1960:2030"
 S DIR("A")="Enter the Participation year for this report: "
 I ABMY("RTYP")="HOS" S DIR("A")="Enter the Participation Fiscal year for this report: "
 D ^DIR K DIR
 Q:$D(DTOUT)!$D(DUOUT)!$D(DIRUT)!$D(DIROUT)
 S ABMY("PYR")=+Y
 S ABMY("QYR")=ABMY("PYR")-1
 Q
90DAY ;
 W !!,"Patient Volume is calculated based on a 90-day period. There are two different"
 W !,"time frame options that can be utilized to determine patient volume."
 W !!?3,"1. Qualification year - This is the year prior to the participation year."
 W !?6,"Any 90-day period can be selected within the qualification year to"
 W !?6,"determine patient volume."
 W !?3,"2. Look-back period - This can be a 90-day period in the previous 12 months"
 W !?6,"from attestation."
 W !!,"Select option A, B, or C to utilize the Qualification year time frame"
 W !,"Select option D or E to utilize the look-back time frame"
 W !!,"Note: All reports will be run for a 90-day reporting period. The 90-day"
 W !,"period may be automatically calculated or user may select a specific start date."
 W !,"The automated calculation will return the first 90-day period in which required"
 W !,"patient volumes are met or the 90-day period with the highest volume percentage"
 W !,"(first occurrence in the year)."
 ;
 D ^XBFMK
 S DIR(0)="S^A:Automated 90-Day Report;B:Specific 90-Day Report Period;C:User specified Report Period"
 S DIR(0)=DIR(0)_";D:Automated 90-Day Period within the last 12 months;E:Specific 90-Day Period within the last 12 months"
 S DIR("A",1)=""
 S DIR("A")="Enter selection"
 D ^DIR K DIR
 Q:$D(DTOUT)!$D(DUOUT)!$D(DIRUT)!$D(DIROUT)
 S ABMY("90")=$P(Y,U)
 I ABMY("90")="D" D  Q:+$G(ABMY("SDT"))=0
 .D ^XBFMK
 .S DIR(0)="D^::EX"
 .S DIR("A")="Enter Attestation Date"
 .D ^DIR K DIR
 .Q:$D(DTOUT)!$D(DUOUT)!$D(DIRUT)!$D(DIROUT)
 .S (ABMY("QYR"),ABMY("AYR"))=$E($$SDT^ABMDUTL(+Y),7,10)
 .S ABMY("ADT")=+Y
 .S (ABMY("EDT"),ABMEDT)=Y
 .S X1=$P(ABMEDT,".")
 .S X2=-365
 .D C^%DTC
 .S (ABMY("SDT"),ABMP("SDT"))=X
 I ABMY("90")="A"!(ABMY("90")="D") D
 .D ^XBFMK
 .S DIR(0)="S^F:First 90-day period found;H:Highest 90-day period found"
 .S DIR("A",1)=""
 .S DIR("A")="Enter selection"
 .S DIR("B")="F"
 .D ^DIR K DIR
 .Q:$D(DTOUT)!$D(DUOUT)!$D(DIRUT)!$D(DIROUT)
 .S ABMY("A90")=$P(Y,U)
 I ABMY("90")="B"!(ABMY("90")="C") D
 .D ^XBFMK
 .S DIR(0)="D^"_(ABMY("QYR")-1700)_"0101:"_(ABMY("QYR")-1700)_"1231:%DT"
 .I ABMY("RTYP")="HOS" S DIR(0)="D^"_(ABMY("QYR")-1701)_"1001:"_(ABMY("QYR")-1700)_"0930:%DT"
 .S DIR("A",1)=""
 .S DIR("A",2)="Select a specific start date in the calendar year"
 .I ABMY("90")="B" S DIR("A",2)=DIR("A",2)_" for the 90-Day Report Period."
 .I ABMY("RTYP")="HOS" S DIR("A",2)="Select a specific start date in the fiscal year for the 90-Day Report Period."
 .S DIR("A",3)="Note:  End Date must not be after December 31."
 .I ABMY("RTYP")="HOS" S DIR("A",3)="Note:  End Date must not be after September 30."
 .S DIR("A",4)=""
 .S DIR("A")="Enter first day of reporting period for "_ABMY("QYR")
 .D ^DIR K DIR
 .S (ABMY("SDT"),ABMP("SDT"))=Y
 .I ABMY("90")="C" D
 ..D ^XBFMK
 ..S DIR(0)="D^"_(ABMY("QYR")-1700)_"0101:"_(ABMY("QYR")-1700)_"1231:%DT"
 ..I ABMY("RTYP")="HOS" S DIR(0)="D^"_(ABMY("QYR")-1701)_"1001:"_(ABMY("QYR")-1700)_"0930:%DT"
 ..S DIR("A",1)=""
 ..S DIR("A",2)="Select a specific end date in the calendar year"
 ..I ABMY("90")="B" S DIR("A",2)=DIR("A",2)_" for the 90-Day Report Period."
 ..I ABMY("RTYP")="HOS" S DIR("A",2)="Select a specific start date in the fiscal year for the 90-Day Report Period."
 ..S DIR("A",3)="Note:  End Date must not be after December 31."
 ..S DIR("A",4)=""
 ..S DIR("A")="Enter last day of reporting period for "_ABMY("QYR")
 ..D ^DIR K DIR
 ..S (ABMY("EDT"),ABMP("EDT"))=Y
 I ABMY("90")="E" D
 .D ^XBFMK
 .S DIR(0)="D^"
 .S DIR("A",1)=""
 .S DIR("A",2)="Select a specific END date"
 .S DIR("A",4)=""
 .S DIR("A")="Enter last day of 90-day period"
 .D ^DIR K DIR
 .S (ABMY("EDT"),ABMEDT)=Y
 .S X1=$P(ABMEDT,".")
 .S X2=-89
 .D C^%DTC
 .S (ABMY("SDT"),ABMP("SDT"))=X
 Q
RFORMAT ;
 D ^XBFMK
 S DIR(0)="S^S:Summary Report;A:Abbreviated Summary Report;P:Patient List"
 S DIR("A",1)=""
 S DIR("A")="Enter Report Format Choice"
 D ^DIR K DIR
 Q:$D(DTOUT)!$D(DUOUT)!$D(DIRUT)!$D(DIROUT)
 S ABMY("RFMT")=$P(Y,U)
 I ABMY("RFMT")="A" D
 . D ^XBFMK
 .S DIR(0)="N"
 .S DIR("A",1)=""
 .S DIR("A",2)="Specify the number of top volume dates to display if minimum thresholds are not met"
 .S DIR("A")="Enter Number (1-275)"
 .D ^DIR K DIR
 .Q:$D(DTOUT)!$D(DUOUT)!$D(DIRUT)!$D(DIROUT)
 .S ABMY("TVDTS")=+Y
 Q
SELINS ;EP
 W !!!
 I ABMY("RTYP")="HOS" W "EH"
 I ABMY("RTYP")'="HOS" W "EP"
 W " calculations can include any SCHIP visits that are part of a Medicaid"
 W !,"expansion program.  Visits for stand-alone SCHIP programs cannot be included"
 W !,"in the calculation.  The following list of insurers will be included unless"
 W !,"otherwise specified."
 W !,"A breakdown of categories will be provided."
 D FINDINS
 I '$D(ABMI) W !!,"No SCHIP insurers found" Q
 D WRTINS
 S ABMFLG=0
 F  D  Q:ABMFLG=1
 .S ABMEDIT=""
 .S DIR(0)="SO^A:Add Additional SCHIP Payers;R:Remove SCHIP Payers from List;N:Do NOT count any SCHIP entries in the report"
 .S DIR("A")="Would you like to Add or Remove (A/R/N)"
 .D ^DIR K DIR
 .S ABMEDIT=Y
 .I ABMEDIT="" S ABMFLG=1 Q
 .Q:$D(DTOUT)!$D(DUOUT)!$D(DIRUT)!$D(DIROUT)
 .I ABMEDIT="N" K ABMI S ABMFLG=1 Q
 .I ABMEDIT="A"!(ABMEDIT="R") D
 ..I ABMEDIT="A" D
 ...S ABMAFLG=0
 ...F  D  Q:ABMAFLG=1
 ....D ^XBFMK
 ....S DIC="^AUTNINS("
 ....S DIC(0)="QEAM"
 ....S DIC("A")="Select Insurer: "
 ....;only insurer type K and P and can't add an insurer that's already on list
 ....S DIC("S")="I (($$GET1^DIQ(9999999.181,$$GET1^DIQ(9999999.18,Y,"".211"",""I""),1,""I"")=""K"")!($$GET1^DIQ(9999999.181,$$GET1^DIQ(9999999.18,Y,"".211"",""I""),1,""I"")=""P""))&('$D(ABML(X)))"
 ....D ^DIC
 ....S ABMINS=+Y
 ....I $D(DTOUT)!$D(DUOUT)!$D(DIRUT)!$D(DIROUT)!(Y<0) S ABMAFLG=1 W:'$D(DIRUT) !,"<NO ENTRY ADDED>" Q
 ....S ABMI("INS",ABMINS)=""
 ....S ABMI(ABMCNT,ABMINS)=""
 ....S ABMCNT=+$G(ABMCNT)+1
 ....W "  <ADDED>"
 ..I ABMEDIT="R" D
 ...S ABMRFLG=0
 ...F  D  Q:ABMRFLG=1
 ....D WRTINS
 ....D ^XBFMK
 ....S DIR(0)="NO^1:"_(ABMCNT-1)
 ....S DIR("A")="Remove which entry"
 ....D ^DIR K DIR
 ....I $D(DTOUT)!$D(DUOUT)!$D(DIRUT)!$D(DIROUT) S ABMRFLG=1 W:'$D(DIRUT) !,"<NO ENTRY REMOVED>" Q
 ....S ABMA=$O(ABMI(X,0))
 ....K ABMI(X,ABMA)
 ....K ABML(ABMA)
 ....W "  <REMOVED>"
 ....D RBINSLST
 I $D(ABMI) D WRTINS
 I '$D(ABMI) W !!,"Insurers with SCHIP insurer type will not be included on this report"
 Q
RBINSLST ;EP
 S ABMCNT1=0,ABMCNT2=1
 F  S ABMCNT1=$O(ABMI(ABMCNT1)) Q:'ABMCNT1  D
 .S ABMX=0
 .F  S ABMX=$O(ABMI(ABMCNT1,ABMX)) Q:'ABMX  D
 ..S ABMK(ABMCNT2,ABMX)=""
 ..S ABMCNT2=ABMCNT2+1
 S ABMCNT=ABMCNT2
 K ABMI
 M ABMI=ABMK
 K ABMK
 Q
FINDINS ;EP
 S ABMINS=0
 S ABMCNT=1
 F  S ABMINS=$O(^AUTNINS(ABMINS)) Q:'ABMINS  D
 .I $$GET1^DIQ(9999999.181,$$GET1^DIQ(9999999.18,+ABMINS,".211","I"),1,"I")'="K" Q
 .S ABMI(ABMCNT,ABMINS)=""
 .S ABMI("INS",ABMINS)=""
 .S ABMCNT=+$G(ABMCNT)+1
 Q
WRTINS ;EP
 W !!,"Report will include the following insurers that hold the SCHIP Insurer Type:"
 S ABMC=0
 F  S ABMC=$O(ABMI(ABMC)) Q:'ABMC  D
 .S ABMINS=$O(ABMI(ABMC,0))
 .W !?5,ABMC_". "_$$GET1^DIQ(9999999.18,ABMINS,".01","E")
 Q
SUMMARY ;
 D SUMMARY^ABMM2PV6
 Q
