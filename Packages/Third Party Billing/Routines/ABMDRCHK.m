ABMDRCHK ; IHS/ASDST/DMJ - Report Utility to Check Parms ;  
 ;;2.6;IHS Third Party Billing;**1**;NOV 12, 2009
 ;Original;TMD;10/17/95 12:45 PM
 ;
 ; IHS/SD/SDR - v2.5 p8
 ;    Added code to check cancelled claim file
 ; IHS/SD/SDR,TPF - v2.5 p8 - added code for pending status (12)
 ; IHS/SD/SDR - v2.5 p9 - IM17380
 ;    Split out line and added $G
 ; IHS/SD/SDR - v2.5 p10 - IM21520
 ;   Fixed report so it would allow selection of one insurer
 ;
 ; IHS/SD/SDR - v2.6 CSV
 ; IHS/SD/SDR - abm*2.6*1 - HEAT7633 - didn't work when V-codes
 ;    were selected
 ;
BILL ;EP for checking Bill File data parameters
 Q:'$D(^ABMDBILL(DUZ(2),ABM,0))!('$D(^(1)))
 Q:$P(^ABMDBILL(DUZ(2),ABM,0),"^",4)="X"
 ;ABM("L") is piece 3 of bill file
 S ABM("V")=$P($G(^ABMDBILL(DUZ(2),ABM,0)),U,7)
 S ABM("L")=$P($G(^ABMDBILL(DUZ(2),ABM,0)),U,3)
 S ABM("I")=$P($G(^ABMDBILL(DUZ(2),ABM,0)),U,8)
 S ABM("P")=$P($G(^ABMDBILL(DUZ(2),ABM,0)),U,5)
 S ABM("D")=$P($G(^ABMDBILL(DUZ(2),ABM,7)),U)
 S ABM("A")=$P($G(^ABMDBILL(DUZ(2),ABM,1)),U,4)
 S ABM("C")=$P($G(^ABMDBILL(DUZ(2),ABM,0)),U,10)
 S ABM("AD")=$P($G(^ABMDBILL(DUZ(2),ABM,1)),U,5)
 S ABM("XD")=$P($G(^ABMDBILL(DUZ(2),ABM,1)),U,7)
 Q:ABM("L")=""!(ABM("I")="")!(ABM("P")="")!(ABM("D")="")
 Q:($D(ABMY("VYTP"))&(ABM("V")=""))
 Q:($D(ABMY("CLIN"))&(ABM("C")=""))
 Q:'$D(^AUTNINS(ABM("I"),0))
 I $D(ABMP("TYP")),ABMP("TYP")=0 Q:+$O(^ABMDBILL(DUZ(2),ABM,3,0))
 I $D(ABMP("TYP")),ABMP("TYP")=1,'+$O(^ABMDBILL(DUZ(2),ABM,3,0)) Q
 I $G(ABMP("COMPL")) Q:$P(^ABMDBILL(DUZ(2),ABM,0),U,4)="C"
 I $D(ABMY("LOC")),ABMY("LOC")'=ABM("L") Q
 I $D(ABMY("PAT")),ABMY("PAT")'=ABM("P") Q
 I $D(ABMP("FORM")),+ABMP("FORM")'=$P(^ABMDBILL(DUZ(2),ABM,0),U,6) Q
 I $D(ABMY("PRV")),'$D(^ABMDBILL(DUZ(2),ABM,41,"B",ABMY("PRV"))) Q
 I $D(ABMY("DX")) S ABM("DX","HIT")=0,ABM("DX")="BILL" D DX Q:'ABM("DX","HIT")
 I $D(ABMY("PX")) S ABM("PX","HIT")=0,ABM("PX")="BILL" D PX Q:'ABM("PX","HIT")
 I $D(ABMY("APPR")),ABMY("APPR")'=ABM("A") Q
 I $G(ABMY("PTYP"))=2,$P($G(^AUPNPAT(ABM("P"),11)),U,12)'="I" Q
 I $G(ABMY("PTYP"))=1,$P($G(^AUPNPAT(ABM("P"),11)),U,12)="I" Q
 I $D(ABMY("INS")),ABMY("INS")'=ABM("I") Q
 I $D(ABMY("TYP")) Q:ABMY("TYP")'[$P($G(^AUTNINS(ABM("I"),2)),U)
 I $D(ABMY("CLIN")),'$D(ABMY("CLIN",+$P(^ABMDBILL(DUZ(2),ABM,0),"^",10))) Q
 I $D(ABMY("VTYP")),'$D(ABMY("VTYP",+$P(^ABMDBILL(DUZ(2),ABM,0),"^",7))) Q
 K ABM("QUIT")
 I $G(ABMY("DT"))="V" D  Q:$G(ABM("QUIT"))
 .S:$P(ABM("D"),".")<ABMY("DT",1) ABM("QUIT")=1
 .S:$P(ABM("D"),".")>ABMY("DT",2) ABM("QUIT")=1
 I $G(ABMY("DT"))="A" D  Q:$G(ABM("QUIT"))
 .S:$P(ABM("AD"),".")<ABMY("DT",1) ABM("QUIT")=1
 .S:$P(ABM("AD"),".")>ABMY("DT",2) ABM("QUIT")=1
 S ABMP("HIT")=1
 Q
 ;
CLM ;EP for checking Claim file data parameters
 Q:'$D(^ABMDCLM(DUZ(2),ABM,0))
 I ABM("STA")'="",$P(^ABMDCLM(DUZ(2),ABM,0),U,4)'=ABM("STA") Q
 S ABM("V")=$P(^ABMDCLM(DUZ(2),ABM,0),U,7)  ;visit type
 S ABM("L")=$P(^ABMDCLM(DUZ(2),ABM,0),U,3)  ;visit location
 S ABM("I")=$P(^ABMDCLM(DUZ(2),ABM,0),U,8)  ;active insurer
 S ABM("P")=$P(^ABMDCLM(DUZ(2),ABM,0),U)  ;patient
 S ABM("D")=$P(^ABMDCLM(DUZ(2),ABM,0),U,2)  ;encounter date
 S ABM("C")=$P(^ABMDCLM(DUZ(2),ABM,0),U,6)  ;clinic
 Q:ABM("L")=""!(ABM("I")="")!(ABM("P")="")!(ABM("D")="")!(ABM("V")="")!(ABM("C")="")
 Q:'$D(^AUTNINS(ABM("I"),0))
 I $D(ABMY("DX")) S ABM("DX","HIT")=0,ABM("DX")="CLM" D DX
 I $D(ABMY("PX")) S ABM("PX","HIT")=0,ABM("PX")="CLM" D PX
 I $D(ABMY("PRV")),'$D(^ABMDCLM(DUZ(2),ABM,41,"B",ABMY("PRV"))) Q
 I $D(ABMY("PAT")),ABMY("PAT")'=ABM("P") Q
 I $D(ABMY("LOC")),ABMY("LOC")'=ABM("L") Q
 I $D(ABMY("INS")),ABMY("INS")'=ABM("I") Q
 I $G(ABMY("PTYP"))=2,$P($G(^AUPNPAT(ABM("P"),11)),U,12)'="I" Q
 I $G(ABMY("PTYP"))=1,$P($G(^AUPNPAT(ABM("P"),11)),U,12)="I" Q
 I $D(ABMY("TYP")) Q:ABMY("TYP")'[$P($G(^AUTNINS(ABM("I"),2)),U)
 I $D(ABMY("DT")),$G(ABMY("DT"))'="X",ABM("D")<ABMY("DT",1)!(ABM("D")>ABMY("DT",2)) Q
 I $D(ABMY("CLIN")),'$D(ABMY("CLIN",+$P(^ABMDCLM(DUZ(2),ABM,0),"^",6))) Q
 I $D(ABMY("VTYP")),'$D(ABMY("VTYP",+$P(^ABMDCLM(DUZ(2),ABM,0),"^",7))) Q
 I ABM("STA")'="X" S ABMP("HIT")=1 Q  ;stop here if not closed claims
 S ABMXFLG=0,ABMDFLG=0
 I '$D(ABMY("CLOS")) S ABMXFLG=1
 I '$D(ABMY("DT")) S ABMDFLG=1
 S ABMY("CIEN")=99999
 F  S ABMY("CIEN")=$O(^ABMDCLM(DUZ(2),ABM,69,ABMY("CIEN")),-1) Q:+ABMY("CIEN")=0  D  Q:ABMXFLG=1
 .Q:$P($G(^ABMDCLM(DUZ(2),ABM,69,ABMY("CIEN"),0)),U,3)'="C"  ;closed only
 .S ABMY("CLOSER")=$P($G(^ABMDCLM(DUZ(2),ABM,69,ABMY("CIEN"),0)),U,2)
 .I $D(ABMY("CLOS")),ABMY("CLOSER")=ABMY("CLOS") S ABMXFLG=1
 .S ABM("REAS")=$P($G(^ABMDCLM(DUZ(2),ABM,69,ABMY("CIEN"),0)),U,4)
 .S ABMY("CLDT")=$P($P($G(^ABMDCLM(DUZ(2),ABM,69,ABMY("CIEN"),0)),U),".")
 .I $D(ABMY("DT")),($G(ABMY("DT"))="X") D
 ..Q:(ABMY("CLDT")<ABMY("DT",1)!(ABMY("CLDT")>ABMY("DT",2)))
 ..S ABMDFLG=1
 .;the below code counts how many times it has been closed, if we are looking for closed
 S ABMY("CIEN")=0
 F  S ABMY("CIEN")=$O(^ABMDCLM(DUZ(2),ABM,69,ABMY("CIEN"))) Q:+ABMY("CIEN")=0  D
 .Q:$P($G(^ABMDCLM(DUZ(2),ABM,69,ABMY("CIEN"),0)),U,3)'="C"  ;closed only
 .S ABMCLSCT=+$G(ABMCLSCT)+1
 Q:ABMXFLG=0
 Q:ABMDFLG=0
 S ABMP("HIT")=1  ;we want this one!
 Q
 ;
DX ;I 'ABMY("DX",1)!'ABMY("DX",2) G DX2  ;abm*2.6*1 HEAT7633
 I $G(ABMY("DX",1))=""!($G(ABMY("DX",2))="") G DX2  ;abm*2.6*1 HEAT7633
 S ABM("DX")=0,ABM("DX","HIT")=0,ABM("LP")=$S($D(ABMY("DX","ALL")):10,1:1)
 F ABM("II")=1:1:ABM("LP") S ABM("DX")=$O(^ABMDBILL(DUZ(2),ABM,17,"C",ABM("DX"))) Q:'ABM("DX")  D  Q:ABM("DX","HIT")
 .S ABM("DX")=$O(^ABMDBILL(DUZ(2),ABM,17,"C",ABM("DX"),""))
 .Q:'$D(^ABMDBILL(DUZ(2),ABM,17,ABM("DX"),0))  S ABM("DX",0)=$P(^(0),U)
 .S ABM("DX",0)=$P($$DX^ABMCVAPI(ABM("DX"),ABM("D")),U,2)  ;CSV-c
 .I ABM("DX",0)'>ABMY("DX",2),ABM("DX",0)'<ABMY("DX",1) S ABM("DX","HIT")=1
 Q
 ;
DX2 Q
 ;
PX I '+ABMY("PX",1)!'+ABMY("PX",2) Q
 I ABM("PX")="BILL" S ABM("PX","HIT")=0 N I F I=21,27,35,37,39 D  Q:ABM("PX","HIT")
 .N J S J=0 F  S J=$O(^ABMDBILL(DUZ(2),ABM,I,J)) Q:'J  D
 ..S ABM("CPT")=$P(^ABMDBILL(DUZ(2),ABM,I,J,0),U)
 ..Q:ABM("CPT")>+ABMY("PX",2)
 ..Q:ABM("CPT")<+ABMY("PX",1)
 ..S ABM("PX","HIT")=1
 I ABM("PX")="CLM" S ABM("PX")=0,ABM("PX","HIT")=0 S ABM("PX")=$O(^ABMDCLM(DUZ(2),ABM,21,"C",ABM("PX"))) Q:'ABM("PX")  D  Q:ABM("PX","HIT")
 .S ABM("PX")=$O(^ABMDCLM(DUZ(2),ABM,21,"C",ABM("PX"),""))
 .Q:'$D(^ABMDCLM(DUZ(2),ABM,21,ABM("PX"),0))  S ABM("PX",0)=$P(^(0),U)
 .Q:+ABM("PX",0)>ABMY("PX",2)
 .Q:+ABM("PX",0)<ABMY("PX",1)
 .S ABM("PX","HIT")=1
 Q
CANCEL ;EP for checking Claim file data parameters
 Q:'$D(^ABMCCLMS(DUZ(2),ABM,0))
 S ABMCREC=$G(^ABMCCLMS(DUZ(2),ABM,0))
 S ABM("VT")=$P(ABMCREC,U,7)
 S ABM("VLOC")=$P(ABMCREC,U,3)
 S ABM("AINS")=$P(ABMCREC,U,8)
 S ABM("PDFN")=$P(ABMCREC,U)
 S ABM("CL")=$P(ABMCREC,U,6)
 S ABM("CANC")=$P($G(^ABMCCLMS(DUZ(2),ABM,1)),U,4)
 S ABM("CDT")=$P($P($G(^ABMCCLMS(DUZ(2),ABM,1)),U,5),".")
 S ABM("CR")=$P($G(^ABMCCLMS(DUZ(2),ABM,1)),U,8)
 I $D(ABMY("REASON")) Q:'$D(ABMY("REASON",ABM("CR")))
 Q:ABM("VLOC")=""!(ABM("AINS")="")!(ABM("PDFN")="")!(ABM("CDT")="")!(ABM("VT")="")!(ABM("CL")="")
 Q:'$D(^AUTNINS(ABM("AINS"),0))
 I $D(ABMY("DX")) S ABM("DX","HIT")=0,ABM("DX")="CLM" D DX
 I $D(ABMY("PX")) S ABM("PX","HIT")=0,ABM("PX")="CLM" D PX
 I $D(ABMY("PRV")),'$D(^ABMCCLMS(DUZ(2),ABM,41,"B",ABMY("PRV"))) Q
 I $D(ABMY("PAT")),ABMY("PAT")'=ABM("PDFN") Q
 I $D(ABMY("LOC")),ABMY("LOC")'=ABM("VLOC") Q
 I $D(ABMY("INS")),ABMY("INS")'=ABM("AINS") Q
 I $G(ABMY("PTYP"))=2,$P($G(^AUPNPAT(ABM("PDFN"),11)),U,12)'="I" Q
 I $G(ABMY("PTYP"))=1,$P($G(^AUPNPAT(ABM("PDFN"),11)),U,12)="I" Q
 I $D(ABMY("TYP")) Q:ABMY("TYP")'[$P($G(^AUTNINS(ABM("AINS"),2)),U)
 I $D(ABMY("DT")),ABM("CDT")<ABMY("DT",1)!(ABM("CDT")>ABMY("DT",2)) Q
 I $D(ABMY("CLIN")),'$D(ABMY("CLIN",+$P(^ABMCCLMS(DUZ(2),ABM,0),"^",6))) Q
 I $D(ABMY("VTYP")),'$D(ABMY("VTYP",+$P(^ABMCCLMS(DUZ(2),ABM,0),"^",7))) Q
 I $D(ABMY("CANC")),(ABM("CANC")'=ABMY("CANC")) Q
 S ABMP("HIT")=1
 Q
INCOM(ABM,ABMTEMP,ABMYTEMP) ;EP - determine parameters for claims with pending status
 Q:$P($G(^ABMDCLM(DUZ(2),ABM,0)),U,4)'="P"
 ;is the provider involved with this claim?
 I $D(ABMY("PRV")),'$D(^ABMDCLM(DUZ(2),ABM,41,"B",ABMY("PRV"))) Q
 S ABMREC0=$G(^ABMDCLM(DUZ(2),ABM,0))
 S ABMREC7=$G(^ABMDCLM(DUZ(2),ABM,7))
 S ABMTEMP("PATIENT")=$P(ABMREC0,U) Q:ABMTEMP("PATIENT")=""
 I $G(ABMY("PAT"))'="" Q:ABMY("PAT")'=ABMTEMP("PATIENT")
 S ABMTEMP("ELIGIBILITY STATUS")=$P($G(^AUPNPAT(ABMTEMP("PATIENT"),11)),U,11)
 I $G(ABMY("PTYP"))'="" Q:ABMTEMP("ELIGIBILITY STATUS")'=ABMY("PTYP")
 S ABMTEMP("ENCOUNTER DATE")=$P(ABMREC0,U,2)
 S ABMTEMP("LOCATION")=$P(ABMREC0,U,3)
 I $G(ABMY("LOC"))'="" Q:ABMTEMP("LOCATION")'=ABMY("LOC")
 S ABMTEMP("CLINIC")=$P(ABMREC0,U,6)
 I ABMTEMP("CLINIC")'="",$D(ABMY("CLIN")) Q:'$D(ABMY("CLIN",ABMTEMP("CLINIC")))
 S ABMTEMP("VISIT TYPE")=$P(ABMREC0,U,7)
 I ABMTEMP("VISIT TYPE"),$D(ABMY("VTYP")) Q:'$D(ABMY("CLIN",ABMTEMP("VISIT TYPE")))
 S ABMTEMP("ACTIVE INSURER")=$P(ABMREC0,U,8)
 I $G(ABMY("INS"))'="" Q:ABMY("INS")'=ABMTEMP("ACTIVE INSURER")
 I ABMTEMP("ACTIVE INSURER")'="" S ABMTEMP("BILLING ENTITY")=$P($G(^AUTNINS(ABMTEMP("ACTIVE INSURER"),2)),U)
 S:ABMTEMP("ACTIVE INSURER")="" ABMTEMP("ACTIVE INSURER")="NO COVERAGE FOUND"
 I $G(ABMYTEMP("TYP"))'="" Q:ABMYTEMP("TYP")'[(ABMTEMP("BILLING ENTITY"))
 S ABMTEMP("PS")=$P(ABMREC0,U,18)
 I $D(ABMY("REASON")) Q:'$D(ABMY("REASON",ABMTEMP("PS")))
 S ABMTEMP("PS UPDATER")=$P(ABMREC0,U,19)
 I $G(ABMY("STATUS UPDATER"))'="" Q:ABMTEMP("PS UPDATER")'=$G(ABMY("STATUS UPDATER"))
 S ABMTEMP("VISIT DATE")=$P(ABMREC7,U)
 S ABMTEMP("PS REASON")=$S(ABMTEMP("PS")'="":$P($G(^ABMPSTAT(ABMTEMP("PS"),0)),U),1:"UNDEFINED")
 S ABMP("HIT")=1
 Q
