BPXRMPC1 ; IHS/MSC/MGH - Computed Findings for PCC reminders. ;18-Apr-2014 15:31;DU
 ;;2.0;CLINICAL REMINDERS;**1001,1002**;Feb 04, 2005;Build 15
 ;=================================================================
 ;This routine is designed to use the standard PCC logic for reminders to
 ;evaluate if items are met or not met. Using the standard PCC calls ensures
 ;that all IHS items are using the same logic.
 ;=====================================================================
CHLAMYDI(DFN,TEST,DATE,VALUE,TEXT) ; EP
 ;This computed finding will check the PCC logic for chlamydia
 N BPXRESLT,TODAY,X,Y
 S TODAY=$$DT^XLFDT()
 S BPXRESLT=$$LASTCHLA^APCLAPI5(DFN,"","","A")
 I $P(BPXRESLT,U,1)>0 S TEST=1,VALUE=$P(BPXRESLT,U,3),TEXT=$P(BPXRESLT,U,2),DATE=$P(BPXRESLT,U,1)
 I $P(BPXRESLT,U,1)=0!(BPXRESLT="") S TEST=0,VALUE=TEST,DATE=TODAY
 Q
HIV(DFN,TEST,DATE,VALUE,TEXT) ;EP
 ;This computed finding will check the PCC logic for HIV testing
 N BPXRESLT,TODAY,X,Y
 S TODAY=$$DT^XLFDT()
 S BPXRESLT=$$LASTHIVS^APCLAPI5(DFN,"","","A")
 I $P(BPXRESLT,U,1)>0 S TEST=1,VALUE=$P(BPXRESLT,U,3),TEXT=$P(BPXRESLT,U,2),DATE=$P(BPXRESLT,U,1)
 I $P(BPXRESLT,U,1)=0!(BPXRESLT="") S TEST=0,VALUE=TEST,DATE=TODAY
 Q
NBHS(DFN,TEST,DATE,VALUE,TEXT) ;EP
 ;This computed finding will check the PCC logic for newborn hearing screening
 N BPXRESLT,TODAY,X,Y
 S TODAY=$$DT^XLFDT()
 S BPXRESLT=$$LASTNBHS^APCLAPI5(DFN,"","","A")
 I $P(BPXRESLT,U,1)>0 S TEST=1,VALUE=$P(BPXRESLT,U,3),TEXT=$P(BPXRESLT,U,2),DATE=$P(BPXRESLT,U,1)
 I $P(BPXRESLT,U,1)=0!(BPXRESLT="") S TEST=0,VALUE=TEST,DATE=TODAY
 Q
NUTR(DFN,TEST,DATE,VALUE,TEXT) ; EP
 ;This computed finding will check the PCC logic for nutritional screening
 N BPXRESLT,TODAY,X,Y
 S TODAY=$$DT^XLFDT()
 S BPXRESLT=$$LASTNUTR^APCLAPI5(DFN,"","","A")
 I $P(BPXRESLT,U,1)>0 S TEST=1,VALUE=$P(BPXRESLT,U,3),TEXT=$P(BPXRESLT,U,2),DATE=$P(BPXRESLT,U,1)
 I $P(BPXRESLT,U,1)=0!(BPXRESLT="") S TEST=0,VALUE=TEST,DATE=TODAY
 Q
RUB(DFN,TEST,DATE,VALUE,TEXT) ; EP
 ;This computed finding will check the PCC logic for Last Rubella
 N BPXRESLT,TODAY,X,Y
 S TODAY=$$DT^XLFDT()
 S BPXRESLT=$$LASTRUB^APCLAPI3(DFN,"","","A")
 I $P(BPXRESLT,U,1)>0 S TEST=1,VALUE=$P(BPXRESLT,U,2),TEXT=$P(BPXRESLT,U,2),DATE=$P(BPXRESLT,U,1)
 I $P(BPXRESLT,U,1)=0!(BPXRESLT="") S TEST=0,VALUE=TEST,DATE=TODAY
 Q
FALL(DFN,TEST,DATE,VALUE,TEXT) ;ep
 ;This computed finding will check the PCC logic for last fall risk
 N BPXRESLT,TODAY,X,Y
 S TODAY=$$DT^XLFDT()
 S BPXRESLT=$$LASTFRA^APCLAPI2(DFN,"","","A")
 I $P(BPXRESLT,U,1)>0 S TEST=1,VALUE=$P(BPXRESLT,U,2),TEXT=$P(BPXRESLT,U,2),DATE=$P(BPXRESLT,U,1)
 I $P(BPXRESLT,U,1)=0!(BPXRESLT="") S TEST=0,VALUE=TEST,DATE=TODAY
 Q
