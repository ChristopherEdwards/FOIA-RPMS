ABMM2PVP ;IHS/SD/SDR - MU Patient Volume EP Report ;
 ;;2.6;IHS 3P BILLING SYSTEM;**11,12**;NOV 12, 2009;Build 187
 ;2.6*12-Updated FQHC/RHC/Tribal to include Urban
 ;2.6*12-Made changes for uncomp care; uncomp should be separate detail line
 ;  and should be included in pt vol total, not separate line.
 ;2.6*12-Added screen on options B,C dts so it won't cross yrs.
 ;
 I $P($G(^ABMMUPRM(1,0)),U,2)="" D  Q
 .W !!,"Setup has not been done.  Please do MUP option prior to running any reports",!
 .S DIR(0)="E",DIR("A")="Enter RETURN to Continue" D ^DIR K DIR
 ;
EN ;
 K ABMF,ABMPRVDR,ABMY,ABM,ABMEFLG
 D FAC Q:$D(DTOUT)!$D(DUOUT)!$D(DIROUT)!'$D(ABMF)
 W !!,"In order for an Eligible Professional (EP) to participate in the Medicaid EHR"
 W !,"Incentive program EPs have to meet a patient volume requirement of 30% or 20%"
 W !,"minimum for pediatricians. This can be accomplished as an individual or as a"
 W !,"group."
 W !!,"The SEL report is to be used to determine patient volume for an individual EP."
 W !,"The GRP report is to be used to determine patient volume for an entire group"
 W !,"practice. If GRP report is utilized all EPs within the facility will need to"
 W !,"utilize the GRP report."
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
 I $P(Y,U)="H" D  Q  ;HFS; prompt for path/filename
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
 .I +Y<0 Q  ;none selected
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
 .I $$GET1^DIQ(200,ABMPRV,53.5,"E")="PHYSICIAN ASSISTANT" D
 ..S ABMPAFLG=0
 ..S ABMFQ=0
 ..F  S ABMFQ=$O(ABMF(ABMFQ)) Q:'ABMFQ  D
 ...S ABMFQIEN=0
 ...S ABMFQIEN=+$O(^ABMMUPRM(1,1,"B",ABMFQ,0))
 ...Q:'ABMFQIEN
 ...I $P($G(^ABMMUPRM(1,1,ABMFQIEN,0)),U,2)=1 S ABMPAFLG=1
 ..Q:ABMPAFLG=1
 ..W !!,"Provider "_$$GET1^DIQ(200,ABMPRV,".01","E")_" ("_$$GET1^DIQ(200,ABMPRV,53.5,"E")_")"
 ..W !,"can't be included because the facility has to be led by a PA for a PA"
 ..W !,"to qualify"
 .Q:(+$G(ABMPAFLG)=1)
 .S ABMPRVDR(ABMPRV)=""
 M ABMP=ABMPRVDR
 Q
FAC ;
 D GETFACS^ABMM2MUP  ;get fac list
 W !!
 K ABMFANS,ABMF
 S ABMFQHC=0,ABMNFQHC=0
 F  D  Q:+$G(Y)<0!(Y=ABMTOT)!$D(DTOUT)!$D(DUOUT)!$D(DIRUT)!$D(DIROUT)  ;didn't answer or ALL selected
 .D ^XBFMK
 .D FACLST
 .S DIR(0)="SO^"_$G(ABMDIR)
 .S:'$D(ABMF) DIR(0)="S^"_$G(ABMDIR)
 .I ABMFQHC=1 D
 ..S DIR("A",1)="Note: A combination of FQHC/RHC/Tribal/Urban and non-FQHC/RHC/"
 ..S DIR("A",2)="      Tribal/Urban data may not be selected on this report"
 ..S DIR("A",3)=""
 .S DIR("A")="Select one or more facilities to use for calculating patient volume"
 .D ^DIR K DIR
 .Q:$D(DTOUT)!$D(DUOUT)!$D(DIRUT)!$D(DIROUT)
 .S ABMFANS=Y
 .I ABMFANS'=ABMTOT,$D(ABMF),($G(ABMFTYP)="T"),'$D(^ABMMUPRM(1,1,"B",ABMFLIST(ABMFANS)))  W !!,"only FQHC/RHC/Tribal/Urbans are allowed based on your first selection" H 1 Q
 .I ABMFANS'=ABMTOT,$D(ABMF),($G(ABMFTYP)="I"),$D(^ABMMUPRM(1,1,"B",ABMFLIST(ABMFANS)))  W !!,"only non-FQHC/RHC/Tribal/Urban clinics are allowed based on your first selection" H 1 Q
 .;
 .I ABMFANS'=ABMTOT,$D(^ABMMUPRM(1,1,"B",ABMFLIST(ABMFANS))) S ABMFQHC=2,ABMFTYP=$S($G(ABMFTYP)="":"T",1:$G(ABMFTYP))
 .I ABMFANS'=ABMTOT,'$D(^ABMMUPRM(1,1,"B",ABMFLIST(ABMFANS))),($G(ABMFTYP)="") S ABMFTYP="I"
 .I ABMFANS'=(ABMTOT) S ABMF($G(ABMFLIST(ABMFANS)))=""
 .I ABMFANS=(ABMTOT) D
 ..S ABMCNT=0
 ..F  S ABMCNT=$O(ABMFLIST(ABMCNT)) Q:'ABMCNT  S ABMF($G(ABMFLIST(ABMCNT)))=""
 ;Q:+$G(Y)<0!(Y=ABMTOT)!$D(DTOUT)!$D(DUOUT)!$D(DIRUT)!$D(DIROUT)
 S ABMFQHC=0
 I $D(^ABMMUPRM(1,1,"B",$O(ABMF(0)))) S ABMFQHC=1
 Q
FACLST ;
 S ABMCNT=0,ABMDIR=""  ;abm*2.6*12
 F  S ABMCNT=$O(ABMFLIST(ABMCNT)) Q:'ABMCNT  D
 .S:ABMDIR'="" ABMDIR=ABMDIR_";"_ABMCNT_":"_$$GET1^DIQ(9999999.06,$G(ABMFLIST(ABMCNT)),.01,"E")
 .S:ABMDIR="" ABMDIR=ABMCNT_":"_$$GET1^DIQ(9999999.06,$G(ABMFLIST(ABMCNT)),.01,"E")
 .S ABMDIR=ABMDIR_$S($D(^ABMMUPRM(1,1,"B",ABMFLIST(ABMCNT))):" (FQHC/RHC/Tribal/Urban)",1:"")
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
 D 90DAY^ABMM2PP1
 Q
RFORMAT ;
 D ^XBFMK
 S DIR(0)="S^S:Summary Report;P:Patient List"  ;abm*2.6*12
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
 ....;only ityp K,P and can't add an insurer that's already on list
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
 S ABMK=$O(ABMI(99),-1)
 F ABM=1:1:ABMK S ABMI("INS",$O(ABMI(ABM,0)))=""
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
