ABMDEADD ; IHS/ASDST/DMJ - Add New Claim - Non PCC Option ;  
 ;;2.6;IHS 3P BILLING SYSTEM;;NOV 12, 2009
 ;
 ; IHS/SD/SDR - v2.5 p3 - 2/28/03 - QEA-0702-130030
 ;     Added code for manually entered insurer check
 ; IHS/SD/SDR - v2.5 p9 - IM15913
 ;    Add check for admit/encounter date to be >DOB
 ; IHS/SD/SDR - v2.5 p12 - UFMS
 ;   If user isn't logged into cashiering session they can't do
 ;   this option
 ;
 S U="^" W !
PAT K ABMP,ABM
 I $P($G(^ABMDPARM(DUZ(2),1,4)),U,15)=1 D  Q:+$G(ABMUOPNS)=0
 .S ABMUOPNS=$$FINDOPEN^ABMUCUTL(DUZ)
 .I +$G(ABMUOPNS)=0 D  Q
 ..W !!,"* * YOU MUST SIGN IN TO BE ABLE TO PERFORM BILLING FUNCTIONS! * *",!
 ..S DIR(0)="E",DIR("A")="Enter RETURN to Continue" D ^DIR K DIR
 K DIC S DIC="^AUPNPAT(",DIC(0)="QZEAM"
 S DIC("A")="Select PATIENT NAME....: "
 D ^DIC
 I $G(X)=""!$D(DUOUT)!$D(DTOUT) G XIT
 I +Y<1 W *7 G XIT
 S ABMP("PDFN")=+Y
 ;
LOC S ABMP("LDFN")=DUZ(2)
 ;
CLN K DIC S DIC(0)="QEAM",DIC="^DIC(40.7,"
 S DIC("A")="Select CLINIC..........: ",DIC("B")="GENERAL"
 D ^DIC
 I $D(DUOUT)!$D(DTOUT)!$D(DIROUT) G XIT
 I X="" W *7 G CLN
 S ABMP("CLN")=+Y
 ;
VTYP K DIC S DIC(0)="QEAM",DIC="^ABMDVTYP(",DIC("B")="OUTPATIENT"
 S DIC("A")="Select VISIT TYPE......: "
 S DIC("S")="I Y'=121"
 D ^DIC K DIC
 I X="" W *7 G VTYP
 G XIT:$D(DTOUT)!$D(DIROUT)!$D(DUOUT)
 S ABMP("VTYP")=+Y
 ;
EDT ;
 K DIR S DIR(0)="D^"_$P($G(^DPT(ABMP("PDFN"),0)),U,3)_":DT:EX"
 S DIR("A")=$S(ABMP("VTYP")=111!($G(ABMP("BTYP"))=111):"Enter ADMISSION DATE...:",1:"Enter ENCOUNTER DATE...:")
 D ^DIR
 G XIT:$D(DTOUT)!$D(DIROUT)!$D(DUOUT)
 S ABMP("VDT")=+Y
 S:ABMP("VTYP")'=111 ABMP("DDT")=+Y
 ;
CHK ;
 S ABM="" F  S ABM=$O(^ABMDCLM(DUZ(2),"B",ABMP("PDFN"),ABM)) Q:'ABM  D
 .Q:$P($G(^ABMDCLM(DUZ(2),ABM,0)),U,2)'=ABMP("VDT")
 .S ABM(ABM)=""
 .Q:$P(^ABMDCLM(DUZ(2),ABM,0),U,7)'=ABMP("VTYP")
 .I ABMP("VTYP")=111 S ABMDUP=1 Q
 .Q:$P(^ABMDCLM(DUZ(2),ABM,0),U,3)'=ABMP("LDFN")
 .Q:$P(^ABMDCLM(DUZ(2),ABM,0),U,6)'=ABMP("CLN")
 .S ABMDUP=1
 I $G(ABMDUP) G DUP
 I '+$O(ABM(0)) G DDT
 W !!,"The following Claims already exist for this Patient on this date:"
 W !!,"Claim",?8,"Location",?40,"Clinic",?62,"Visit Type",!,"-------------------------------------------------------------------------------"
 S ABM=0 F  S ABM=$O(ABM(ABM)) Q:'ABM  D
 .Q:'$D(^ABMDCLM(DUZ(2),ABM,0))
 .W !,ABM,?8,$E($P(^DIC(4,$P(^ABMDCLM(DUZ(2),ABM,0),U,3),0),U),1,30)
 .W ?40,$E($P(^DIC(40.7,$P(^ABMDCLM(DUZ(2),ABM,0),U,6),0),U),1,20)
 .W ?62,$E($P(^ABMDVTYP($P(^ABMDCLM(DUZ(2),ABM,0),U,7),0),U),1,17)
 W ! K DIR S DIR(0)="Y",DIR("A")="Do you wish to CONTINUE to ADD this Claim" D ^DIR K DIR G XIT:'Y
 ;
DDT I ABMP("VTYP")=111 D  G XIT:$D(DTOUT)!$D(DIROUT)!$D(DUOUT)
 .K DIR S DIR(0)="DA^"_ABMP("VDT")_":DT:EX"
 .S DIR("A")="Enter DISCHARGE DATE...: "
 .D ^DIR
 .S ABMP("DDT")=+Y
 ;
LCHK ;CHECK ELIGIBILITY
 W !!,"Checking eligibility..."
 S ABMVDFN=$G(ABMP("VDFN")),ABMPDFN=ABMP("PDFN"),ABMVDT=ABMP("VDT")
 D ELG^ABMDLCK(ABMVDFN,.ABML,ABMPDFN,ABMVDT)
TST ;
 I '$D(ABML)!($O(ABML(""))>96) D
 .W !!,*7,$$EN^ABMVDF("RVN"),"NOTE:",$$EN^ABMVDF("RVF")
 .W " Patient either has no 3rd Party Resources for the date of the visit or the",!,"location/clinic is not billable for the insuring source.",!
 .K DIR S DIR(0)="Y",DIR("A")="Continue",DIR("B")="NO" D ^DIR K DIR I Y'=1 S ABM("F1")=1 Q
 .S DIC="^AUTNINS(",DIC(0)="AEMQ",DIC("S")="I $P($G(^(1)),""^"",7)=1",DIC("A")="Select INSURER to Bill // " D ^DIC K DIC I Y<0 S ABM("F1")=1 Q
 .S ABM("TYP")=$P($G(^AUTNINS(+Y,2)),U) I ABM("TYP")="" S ABM("F1")=1 W !!,"Insurance type undefined for this insurer.",! Q
 .S ABML(1,+Y)="^^"_ABM("TYP")_"^^^^M"
 .S ABM("F1")=0
 G:'$G(ABM("F1")) ^ABMDEAD2
 ;
 W !!,*7,"Claim ",$$EN^ABMVDF("RVN"),"NOT",$$EN^ABMVDF("RVF")," created.",! H 3
XIT K DIC,ABM,ABMP,ABMX,ABMV,ABME,ABML,AUPNLK("ALL"),ABMDUP
 Q
 ;
DUP W *7,!!,"Claim Number: ",ABM," already exists with the Identifiers entered above!",!?5,"(NOTE: Use the EDIT CLAIM Option to Access Existing Claims)"
 K DIR S DIR(0)="E" D ^DIR K DIR
 G XIT
