ABMDESEL ; IHS/ASDST/DMJ - Selective Report Parameters ;
 ;;2.6;IHS 3P BILLING SYSTEM;;NOV 12, 2009
 ;
 ; IHS/SD/SDR - v2.5 p10 - IM13359
 ;   Ask for range of patients
 ;
 K ABMY,DIR,DIC
LOOP G XIT:$D(DUOUT)!$D(DTOUT)!$D(DIROUT)
 W !!?3,"EXCLUSION PARAMETERS Selected for RESTRICTING the CLAIM LOOPING to:"
 W !?3,"==================================================================="
 I $D(ABMY("LOC")) W !?3,"- Visit Location....: ",$P(^AUTTLOC(ABMY("LOC"),0),"^",2)
 I $D(ABMY("INS")) W !?3,"- Billing Entity....: ",$P(^AUTNINS(ABMY("INS"),0),U)
 I $D(ABMY("PAT")) W !?3,"- Billing Entity....: ",$P(^DPT(ABMY("PAT"),0),U)
 I $D(ABMY("TYP")) W !?3,"- Billing Entity....: ",ABMY("TYP","NM")
 I $D(ABMY("DT")) W !?3,"- Visit Dates from..: "
 I  W $$HDT^ABMDUTL(ABMY("DT",1)),"  to: ",$$HDT^ABMDUTL(ABMY("DT",2))
 I $D(ABMY("VTYP")) W !?3,"- Visit Type........: ",$P(^ABMDVTYP(ABMY("VTYP"),0),U)
 I $D(ABMY("CLN")) W !?3,"- Clinic............: ",$P(^DIC(40.7,ABMY("CLN"),0),U)
 I $D(ABMY("PRV")) W !?3,"- Provider...........: ",$P(^VA(200,ABMY("PRV"),0),U)
 I $G(ABMY("PTYP")) W !?3,"- Eligibility Status.: ",ABMY("PTYP","NM")
 I $D(ABMY("RNG")) W !?3,"- Range of Patients..: ",ABMY("RNG",1)," thru ",ABMY("RNG",2)
 ;
PARM ;
 K DIR
 S DIR(0)="SO^1:LOCATION;2:BILLING ENTITY;3:DATE RANGE;4:VISIT TYPE;5:CLINIC;6:PROVIDER;7:ELIGIBILITY STATUS"
 I $G(ABMY("PAT"))="" S DIR(0)=DIR(0)_";8:RANGE OF PATIENTS"
 S DIR("A")="Select ONE or MORE of the above EXCLUSION PARAMETERS"
 S DIR("?")="The report can be restricted to one or more of the listed parameters. A parameter can be removed by reselecting it and making a null entry."
 D ^DIR K DIR G XIT:$D(DIRUT)!$D(DIROUT)
 D @($S(Y=1:"LOC",Y=2:"TYP",Y=3:"DT",Y=4:"VTYP",Y=5:"CLN",Y=6:"PRV",Y=7:"ELIG",1:"RANGE")_"^ABMDESL1")
 G LOOP
 ;
INS W !!?5,"You can RESTRICT the REPORT to either a SPECIFIC INSURER or",!?5,"else a TYPE of INSURER (i.e. PRIVATE INSURANCE, MEDICAID...).",! S DIR(0)="Y",DIR("A")="Restrict Report to a SPECIFIC INSURER (Y/N)",DIR("B")="N" D ^DIR
 G XIT:$D(DIRUT)
 D @($S(Y=1:"INS",1:"TYP")_"^ABMDRSL1")
 I '$D(DTOUT)!'$D(DUOUT)!'$D(DIROUT) G LOOP
 ;
XIT G XIT2:'$D(ABM("RTYP"))!$D(DIROUT)!$D(DTOUT)!$D(DUOUT)
 W ! K DIR S DIR(0)="SA^C:CLINC;V:VISIT TYPE",DIR("A")="Sort Report by [V]isit Type or [C]linic: ",DIR("B")="V"
 S DIR("?")="Enter 'V' to sort the report by Visit Type (inpatient, outpatient, etc.) or a 'C' to sort it by the Clinic associated with each visit."
 D ^DIR I '$D(DIROUT)!'$D(DIRUT) S ABMY("SORT")=Y
XIT2 K ABMY("I"),ABMY("X"),DIR
 Q
