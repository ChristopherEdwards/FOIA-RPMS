ABMMUPVP ;IHS/SD/SDR - MU Patient Volume EP Report ;
 ;;2.6;IHS 3P BILLING SYSTEM;**7,8**;NOV 12, 2009
 ;
 I $P($G(^ABMMUPRM(1,0)),U,2)="" D  Q
 .W !!,"Setup has not been done.  Please do MUP option prior to running any reports",!
 .S DIR(0)="E",DIR("A")="Enter RETURN to Continue" D ^DIR K DIR
 ;
 ;
EN ;
 K ABMF,ABMPRVDR,ABMY,ABM
 D FAC Q:$D(DTOUT)!$D(DUOUT)!$D(DIROUT)!'$D(ABMF)
 ;
 W !!,"The SEL report determines if INDIVIDUAL Eligible Professionals have met the"
 W !,"minimum patient volume requirements on their own patient encounters during a"
 W !,"continuous 90-day period in order to be eligible for the Medicaid EHR Incentive"
 W !,"Program (Meaningful Use EHR Incentive Program)."
 ;
 W !!,"The GRP report may be used for EPs who wish to use encounters of all providers"
 W !,"at a facility to meet the minimum patient volume requirements during a"
 W !,"continuous 90-day period in order to be eligible for the Medicaid EHR Incentive"
 W !,"Program (Meaningful Use EHR Incentive Program).  When used, all EPs at the"
 W !,"facility must use the Group Method.  All provider encounters for the entire"
 W !,"facility are included in the calculation."
 W !!
 D RTYPE
 ;I ABMY("RTYP")="GRP" W !!,"GRP not available at this time...defaulting to SEL" S ABMY("RTYP")="SEL"  ;abm*2.6*8
 Q:$D(DTOUT)!$D(DUOUT)!$D(DIROUT)  ;abm*2.6*8
 I ABMY("RTYP")="SEL" D  Q:$D(DTOUT)!$D(DUOUT)!$D(DIROUT)!'$D(ABMPRVDR)
 .D PRVDR Q:$D(DTOUT)!$D(DUOUT)!$D(DIROUT)!'$D(ABMPRVDR)
 D PARTYR Q:$D(DTOUT)!$D(DUOUT)!$D(DIRUT)!$D(DIROUT)
 D 90DAY Q:$D(DTOUT)!$D(DUOUT)!$D(DIRUT)!$D(DIROUT)
 D RFORMAT Q:$D(DTOUT)!$D(DUOUT)!$D(DIRUT)!$D(DIROUT)
 D SUMMARY
 D ^XBFMK
 S DIR(0)="S^P:Print Report;R:Return to Selection Criteria -Erases ALL previous selections"
 S DIR("A")="<P> to Print or <R> to Reselect"
 D ^DIR K DIR Q:$D(DTOUT)!$D(DUOUT)!$D(DIRUT)!$D(DIROUT)
 ;I $P(Y,U)="R" K ABMY,ABMPRVDR,ABMF G EN  ;abm*2.6*8
 I $P(Y,U)="R" K ABMY,ABMPRVDR,ABMF,ABMP,ABMPRV G EN  ;abm*2.6*8
 W !!,"Note: This report will take a while to run based on the amount of data you have"
 S ABMQ("RX")="POUT^ABMDRUTL"
 S ABMQ("NS")="ABM"
 S ABMQ("RP")="COMPUTE^ABMMUPV1"
 D ^ABMDRDBQ
 Q
 ;
RTYPE ;
 K ^XTMP("ABM-PVP",$J)
 D ^XBFMK
 ;S DIR(0)="S^SEL:Encounter method for each EP;GRP:Group method for facilities (not available at this time)"  ;abm*2.6*8
 S DIR(0)="S^SEL:Encounter method for each EP;GRP:Group method for facilities"  ;abm*2.6*8
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
 D GETFACS^ABMMUMUP  ;get list of facilities
 W !!
 K ABMFANS,ABMF
 F  D  Q:+$G(Y)<0!(Y=ABMTOT)!$D(DTOUT)!$D(DUOUT)!$D(DIRUT)!$D(DIROUT)  ;they didn't answer or ALL was selected
 .D ^XBFMK
 .D FACLST
 .S DIR(0)="SO^"_$G(ABMDIR)
 .S:'$D(ABMF) DIR(0)="S^"_$G(ABMDIR)
 .I ABMFQHC=1 D
 ..S DIR("A",1)="Note: you cannot select a combination of FQHC/RHC and non-FQHC/RHC data on"
 ..S DIR("A",2)="this report"
 ..S DIR("A",3)=""
 .S DIR("A")="Select one or more facilities to use for calculating patient volume"
 .D ^DIR K DIR
 .Q:$D(DTOUT)!$D(DUOUT)!$D(DIRUT)!$D(DIROUT)
 .S ABMFANS=Y
 .I ABMFANS'=ABMTOT,$D(ABMF),(ABMFQHC>1),'$D(^ABMMUPRM(1,1,"B",ABMFLIST(ABMFANS)))  W !!,"only FQHCs are allowed based on your first selection" H 1 Q
 .I ABMFANS'=ABMTOT,$D(ABMF),(ABMFQHC=1),$D(^ABMMUPRM(1,1,"B",ABMFLIST(ABMFANS)))  W !!,"only non-FQHCs are allowed based on your first selection" H 1 Q
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
 .S ABMDIR=ABMDIR_$S($D(^ABMMUPRM(1,1,"B",ABMFLIST(ABMCNT))):" (FQHC/RHC)",1:"")
 .S ABMDIR=ABMDIR_$S($D(ABMF($G(ABMFLIST(ABMCNT)))):" *",1:"")
 .I $D(^ABMMUPRM(1,1,"B",ABMFLIST(ABMCNT))) S ABMFQHC=1
 .I '$D(^ABMMUPRM(1,1,"B",ABMFLIST(ABMCNT))) S ABMNFQHC=1
 S ABMCNT=$O(ABMFLIST(99999),-1)  ;get last entry#
 S (ABMCNT,ABMTOT)=ABMCNT+1
 ;I ABMFQHC=0!(ABMCNT<2) S ABMDIR=ABMDIR_";"_ABMCNT_":All facilities"
 I ((ABMFQHC=0&(ABMNFQHC=1))!((ABMFQHC=1)&(ABMNFQHC=0)))!(ABMCNT<2) S ABMDIR=ABMDIR_";"_ABMCNT_":All facilities"
  Q
PARTYR ;
 I ABMY("RTYP")="SEL"!(ABMY("RTYP")="GRP") D
 .W !!!,"For EPs, the Participation year is a calendar year."
 .W !!,"Note:  The qualification year is the year prior to the participation year."
 .W !,"Patient Volume is calculated on encounters that occurred in the qualification"
 .W !,"year, which is the year prior to the participation year.  To view volume for"
 .W !,"the current year, select next year as the participation year.",!
 D ^XBFMK
 S DIR(0)="NA^1960:2030"
 S DIR("A")="Enter the Participation year for this report: "
 I ABMY("RTYP")="HOS" S DIR("A")="Enter the Participation Fiscal year for this report: "  ;abm*2.6*8
 D ^DIR K DIR
 Q:$D(DTOUT)!$D(DUOUT)!$D(DIRUT)!$D(DIROUT)
 S ABMY("PYR")=+Y
 S ABMY("QYR")=ABMY("PYR")-1
 Q
90DAY ;
 W !!,"Report will be run for a 90-day reporting period. The 90-day period may be "
 W !,"automatically calculated or user may select a specific start date.",!
 W !,"The automated calculation will return the first 90-day period in the "
 W ABMY("PYR")_" year"
 W !,"in which required patient volumes are met or the 90-day period with the"
 W !,"highest volume percentage (first occurrence in the year)."
 D ^XBFMK
 S DIR(0)="S^A:Automated 90-Day Report;B:Specific 90-Day Report Period;C:User specified Report Period"
 S DIR("A",1)=""
 S DIR("A")="Enter selection"
 D ^DIR K DIR
 Q:$D(DTOUT)!$D(DUOUT)!$D(DIRUT)!$D(DIROUT)
 S ABMY("90")=$P(Y,U)
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
SUMMARY ;
 D EN^ABMVDF("IOF")
 W !
 D CENTER^ABMUCUTL("SUMMARY OF PATIENT VOLUME REPORT TO BE GENERATED")
 W !!!,"Report Name: "
 I ABMY("RTYP")="SEL" W "Patient Volume Report for Eligible Professionals"
 I ABMY("RTYP")="GRP" W "Patient Volume Report for Group Practice"  ;abm*2.6*8
 I ABMY("RTYP")="HOS" W "Patient Volume Report for Eligible Hospitals"
 W !,"The date ranges for this report are:"
 W !?3,"Participation Year: ",ABMY("PYR")
 W !?3,"Qualification Year: ",ABMY("QYR")
 W !,"Reporting Period: "
 I ABMY("90")="A" W "Automated 90-day"
 I ABMY("90")="B" W "90-day beginning ",$$SDT^ABMDUTL(ABMY("SDT"))
 I ABMY("90")="C" W $$SDT^ABMDUTL(ABMY("SDT"))_" thru "_$$SDT^ABMDUTL(ABMY("EDT"))
 W:$G(ABMY("TVDTS")) !!,"Number of top volume dates to display if minimum thresholds are not met: ",ABMY("TVDTS")
 W !!,"Report Method Type: "
 W:ABMY("RTYP")="SEL" "Individual"
 W:ABMY("RTYP")="GRP" "Group"  ;abm*2.6*8
 W:ABMY("RTYP")="HOS" "Hospital/ER"
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
 .I $D(^ABMMUPRM(1,1,"B",ABMFC)) W " (FQHC/RHC)"
 Q
