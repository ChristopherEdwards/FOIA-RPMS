BPXRMASM ; IHS/CIA/MGH - Asthma reminders. ;24-Sep-2009 16:17;MGH
 ;;1.5;CLINICAL REMINDERS;**1003,1004,1005,1007**;Jun 19, 2000
 ;=================================================================
 ;This routine is designed to evaluate the asthma registry information
 ;to create the reminders for asthma patients that match the
 ;health summary maintenance reminders for asthma patients
 ;1004 MODIFIED TO MAKE MORE UNIFORM DATE RETURN FOR ASTHAM PLAN
 ;1007 Updated to match the treatment prompts logic
 ;=====================================================================
STEROID(DFN,TEST,DATE,VALUE,TEXT) ; EP
 ;This computed finding will check to see if steroids should be increased
 I '$$HMR1ST^APCHSMAS(DFN) S TEST=1,DATE=DT,TEXT="Not a candidate for this reminder" Q
 E  S TEST=0,DATE=DT,TEXT="If this patient has asthma, consider adding or increasing this patient's inhaled corticsteroids."
 Q
PRIMARY(DFN,TEST,DATE,VALUE,TEXT) ; EP
 ;This computed finding will check to see if this asthma patient has a primary provider
 N CIADOB,CIASEX,X1,X2,CIAAGE
 S TEST=0,DATE="",TEXT="",VALUE=""
 I $P(^AUPNPAT(DFN,0),U,14)]"" S TEST=1,DATE=DT,TEXT="PROVIDER FOUND" Q
 NEW APCHPRV
 D WHPCP^BDPAPI(DFN,.APCHPRV)
 I $G(APCHPRV("DESIGNATED PRIMARY PROVIDER"))]"" S TEST=1,DATE=DT,TEXT="PROVIDER FOUND" Q
 I '$$HMR5ST^APCHSMAS(DFN) S TEST=1,DATE=DT,TEXT="Does not meet criteria for reminder" Q
 E  S TEST=0,DATE=DT,TEXT="No primary provider found"
 Q
SEVERITY(DFN,TEST,DATE,VALUE,TEXT) ; EP
 ;This computed finding will check to see if the asthma patient has
 ;had a severity indicated
 N CIASTAT,X
 I $$LASTASCL^APCHSMAS(DFN,1)]"" S TEST=1,DATE=DT,TEXT="ASTHMA SEVERITY DOCUMENTED" Q     ;asthma severity documented
 I '$$HMR4ST^APCHSMAS(DFN) S TEST=1,DATE=DT,TEXT="NOT A CANDIDATE FOR ASTHMA SEVERITY"  ;not a candidate so reminder is resolved
 E  S TEST=0,DATE=DT,TEXT="ASTHMA SEVERITY NOT DOCUMENTED"  ; severity is NOT documented
 Q
PLAN(DFN,TEST,DATE,VALUE,TEXT) ; EP
 ;This computed finding will check to see if the patient has an asthma plan
 ;in place
 ;IHS/MSC/MGH Changed to match treatment plan logic
 N APCHICAR,Y
 S APCHICAR=$$LASTITEM^APCLAPIU(DFN,"ASM-SMP","EDUCATION",,,"A")
 I APCHICAR="" S APCHICAR=$$LASTAM^APCHSAST(DFN,3)
 S (APCHLAST,Y)=$P(APCHICAR,U,1)
 I Y>$$FMADD^XLFDT(DT,-365) S TEST=1,DATE=APCHLAST,VALUE=APCHLAST,TEXT="Asthma plan found in the last year" Q
 I '$$HMR2ST^APCHSMAS(DFN) S TEST=1,DATE=DT,TEXT="Not a candidate for asthma plan"
 E  D
 .S TEST=0,DATE=DT,TEXT="No asthma management plan found"
 Q
CONTROL(DFN,TEST,DATE,VALUE,TEXT) ;EP
 N APCHLAST
 I '$$HMR6ST^APCHSMAS(DFN) S TEST=1,DATE=DT,TEXT="Not a candidate for this reminder" Q
 S APCHLAST=$$LASTACON^APCHSMAS(DFN,2)
 I $$FMDIFF^XLFDT(DT,APCHLAST)<365 S TEST=1,DATE=APCHLAST,VALUE=APCHLAST,TEXT="Asthma control documented"
 E  S TEST=0,DATE=DT,TEXT="No asthma control documented"
 Q
RISK(DFN,TEST,DATE,VALUE,TEXT) ;EP
 N APCHSEV
 S APCHSEV=$$HMR7ST^APCHSMAS(DFN)  ;not a candidate
 I 'APCHSEV S TEST=1,DATE=DT,TEXT="Not a candidate for this reminder"
 E  S TEST=0,DATE=DT,TEXT="Pt at risk for exacerbation"
 Q
