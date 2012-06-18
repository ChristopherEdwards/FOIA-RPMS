ABMDRSEL ; IHS/ASDST/DMJ - Selective Report Parameters ;
 ;;2.6;IHS 3P BILLING SYSTEM;**3,4**;NOV 12, 2009
 ;Original;TMD;07/14/95 12:23 PM
 ;
 ; IHS/SD/SDR - v2.5 p8 - Added code for cancelling official
 ; IHS/SD/SDR,TPB - v2.5 p8 - Added code for pending status (12)
 ; IHS/SD/SDR - v2.5 p10 - IM20566 - Fix for <UNDEF>PRINT+13^ABMDRST1
 ; IHS/SD/SDR - abm*2.6*4 - NO HEAT - Fixed closed/exported dates
 ;
 K DIC,DIR,ABMY
 S U="^"
 S ABMY("X")="W $$SDT^ABMDUTL(X)"
 I $D(ABM("APPR")) S ABMY("APPR")=ABM("APPR")
 I $D(ABM("CANC")) S ABMY("CANC")=ABM("CANC")
 I $D(ABM("CLOS")) S ABMY("CLOS")=ABM("CLOS")  ;Closed
 I $D(ABM("OVER-DUE")) D
 .S ABMY("DT")="X"
 .I ABM("OVER-DUE")=2 D  Q
 ..S ABMY("DT")=""  ;abm*2.6*3 NOHEAT
 ..S ABMY("DT",1)=$E(DT,1,5)_"01"
 ..S ABMY("DT",2)=DT
 .I ABM("OVER-DUE")=3 D  Q
 ..S ABMY("DT",1)=$S($E(DT,4,5)>10:$E(DT,1,3)_1001,1:($E(DT,1,3)-1)_1001)
 ..S ABMY("DT",2)=DT
 .S X1=DT
 .S X2=-30
 .D C^%DTC
 .S ABMY("DT",2)=X
 .S X1=DT
 .S X2=-330
 .D C^%DTC
 .S ABMY("DT",1)=X
 .Q
 ;
LOOP ;
 ; Display current exclusion parameters
 G XIT:$D(DUOUT)!$D(DTOUT)!$D(DIROUT)
 W !!?3,"EXCLUSION PARAMETERS Currently in Effect for RESTRICTING the EXPORT to:",!?3,"======================================================================="
 I $D(ABMY("LOC")) W !?3,"- Visit Location.....: ",$P(^DIC(4,ABMY("LOC"),0),U)
 I $D(ABMY("INS")) W !?3,"- Billing Entity.....: ",$P(^AUTNINS(ABMY("INS"),0),U)
 I $D(ABMY("PAT")) W !?3,"- Billing Entity.....: ",$P(^DPT(ABMY("PAT"),0),U)
 I $D(ABMY("TYP")) W !?3,"- Billing Entity.....: ",ABMY("TYP","NM")
 I $D(ABMY("DT")) D
 .;start old code abm*2.6*4 NOHEAT
 .;W !?3,"- ",$S(ABMY("DT")="A":"Approval Dates from: ",ABMY("DT")="V":"Visit Dates from...: ",ABMY("DT")="P":"Payment Dates from.: ",ABMY("DT")="C":"Cancellation Dates from:",ABMY("DT")="X":"Closed Dates from:",1:"Export Dates from..: ")
 .;end old code start new code NOHEAT
 .W !?3,"- ",$S(ABMY("DT")="A":"Approval Dates from: ",ABMY("DT")="V":"Visit Dates from...: ",ABMY("DT")="P":"Payment Dates from.: ",ABMY("DT")="C":"Cancellation Dates from:",ABMY("DT")="M":"Closed Dates from:",1:"Export Dates from..: ")
 .;end new code NOHEAT
 I  S X=ABMY("DT",1) X ABMY("X") W "  to: " S X=ABMY("DT",2) X ABMY("X")
 I $G(ABMY("STATUS UPDATER"))'="" W !?3,"- Status Updater.....: ",$P($G(^VA(200,$G(ABMY("STATUS UPDATER")),0)),U)
 I $D(ABMY("APPR")) W !?3,"- Approving Official.: ",$P(^VA(200,ABMY("APPR"),0),U)
 I $D(ABMY("CANC")) W !?3,"- Cancelling Official.: ",$P(^VA(200,ABMY("CANC"),0),U)
 I $D(ABMY("CLOS")) W !?3,"- Closing Official.: ",$P(^VA(200,ABMY("CLOS"),0),U)  ;Closing
 I $D(ABM("STA")) W !?3,"- Claim Status.......: ",ABM("STA","NM")
 I $D(ABMY("PRV")) W !?3,"- Provider...........: ",$P(^VA(200,ABMY("PRV"),0),U)
 I $G(ABMY("PTYP")) W !?3,"- Eligibility Status.: ",ABMY("PTYP","NM")
 I $D(ABMY("DX")) W !?3,"- Diagnosis Code from: ",ABMY("DX",1),"  to: ",ABMY("DX",2),"  (",$S($D(ABMY("DX","ALL")):"Check All Diagnosis",1:"Primary Diagnosis Only"),")"
 I $D(ABMY("PX")) W !?3,"- CPT Range from.....: ",ABMY("PX",1),"  to: ",ABMY("PX",2)
 I $G(ABM("RTYP")) W !?3,"- Report Type........: ",ABM("RTYP","NM")
 ;
PARM ;
 ; Choose additional exclusion parameters
 K DIR
 S DIR(0)="SO^1:LOCATION;2:BILLING ENTITY;3:DATE RANGE;4:"
 S DIR(0)=DIR(0)_$S($D(ABM("CANC")):"CANCELLING OFFICIAL",$D(ABM("CLOS")):"CLOSING OFFICIAL",($G(ABM("STA"))'="")&($G(ABM("STA"))'="P"):"CLAIM STATUS",$G(ABM("STA"))="P":"STATUS UPDATER",1:"APPROVING OFFICIAL")
 S DIR(0)=DIR(0)_";5:PROVIDER;6:ELIGIBILITY STATUS"
 I '$D(ABM("NODX")) S DIR(0)=DIR(0)_";7:DIAGNOSIS RANGE;8:CPT RANGE"
 I $G(ABM("RTYP")) S DIR(0)=DIR(0)_";"_$S($D(ABM("NODX")):7,1:9)_":REPORT TYPE"
 S DIR("A")="Select ONE or MORE of the above EXCLUSION PARAMETERS"
 S DIR("?")="The report can be restricted to one or more of the listed parameters. A parameter can be removed by reselecting it and making a null entry."
 D ^DIR
 K DIR
 G XIT:$D(DIRUT)!$D(DIROUT)
 I Y<6 D @($S(Y=1:"LOC",Y=2:"TYP",Y=3:"DT",$G(ABM("STA"))="P"&(Y=4):"INC",Y=5:"PRV",$D(ABM("CANC")):"CANC",$D(ABM("CLOS")):"CLOS",$D(ABM("STA")):"STATUS",1:"APPR")_"^ABMDRSL1") G LOOP  ;Closed
 I Y=6 D PTYP^ABMDRSL2 G LOOP
 I '$D(ABM("NODX")) D @($S(Y=7:"DX",Y=8:"PX",1:"RTYP")_"^ABMDRSL2") G LOOP
 D RTYP^ABMDRSL2 G LOOP
 ;
INS ;
 W !!?5,"You can RESTRICT the REPORT to either a SPECIFIC INSURER or",!?5,"else a TYPE of INSURER (i.e. PRIVATE INSURANCE, MEDICAID...).",!
 S DIR(0)="Y"
 S DIR("A")="Restrict Report to a SPECIFIC INSURER (Y/N)"
 S DIR("B")="N"
 D ^DIR
 G XIT:$D(DIRUT)
 D @($S(Y=1:"INS",1:"TYP")_"^ABMDRSL1")
 I '$D(DTOUT)!'$D(DUOUT)!'$D(DIROUT) G LOOP
 ;
XIT ;
 G XIT2:'$D(ABM("RTYP"))!$D(DIROUT)!$D(DTOUT)!$D(DUOUT)
 W !
 K DIR
 S DIR(0)="SA^C:CLINIC;V:VISIT TYPE"
 S DIR("A")="Sort Report by [V]isit Type or [C]linic: "
 S DIR("B")="V"
 S DIR("?")="Enter 'V' to sort the report by Visit Type (inpatient, outpatient, etc.) or a 'C' to sort it by the Clinic associated with each visit."
 D ^DIR
 I '$D(DIROUT)&('$D(DIRUT)) D
 .S ABMY("SORT")=Y
 .I ABMY("SORT")="C" D CLIN,REASON:$D(ABM("REASON")) Q
 .D VTYP,REASON:$D(ABM("REASON"))&($D(ABMY("VTYP")))
 .Q
 ;
XIT2 ;
 K ABMY("I"),ABMY("X"),DIR
 Q
 ;
CLIN ;SELECT CLINICS
 K ABMY("CLIN")
 S DIC="^DIC(40.7,"
 S DIC(0)="AEMQ"
 S DIC("A")="Select Clinic: ALL// "
 F  D  Q:+Y<0
 .I $D(ABMY("CLIN")) S DIC("A")="Select Another Clinic: "
 .D ^DIC
 .Q:+Y<0
 .S ABMY("CLIN",+Y)=""
 I '$D(ABMY("CLIN")) D
 .I $D(DUOUT) K ABMY("SORT") Q
 .W "ALL"
 K DIC
 Q
 ;
VTYP ;SELECT VISIT TYPES
 K ABMY("VTYP")
 S DIC="^ABMDVTYP("
 S DIC(0)="AEMQ"
 S DIC("A")="Select Visit Type: ALL// "
 F  D  Q:+Y<0
 .I $D(ABMY("VTYP")) S DIC("A")="Select Another Visit Type: "
 .D ^DIC
 .Q:+Y<0
 .S ABMY("VTYP",+Y)=""
 I '$D(ABMY("VTYP")) D
 .I $D(DUOUT) K ABMY("SORT") Q
 .W "ALL"
 K DIC
 Q
REASON ; select reasons (for cancelled and pending claim reports)
 K ABMY("REASON")
 S DIC=$S($G(ABM("REASON"))="PEND":"^ABMPSTAT(",1:"^ABMCCLMR(")
 S DIC(0)="AEMQ"
 S DIC("A")="Select Reason: ALL// "
 F  D  Q:+Y<0
 .I $D(ABMY("REASON")) S DIC("A")="Select Another Reason: "
 .D ^DIC
 .Q:+Y<0
 .S ABMY("REASON",+Y)=""
 I '$D(ABMY("REASON")) D
 .I $D(DUOUT) K ABMY("SORT") Q
 .W "ALL"
 K DIC
 Q
