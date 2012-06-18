BPXRMDM ; IHS/CIA/MGH - Dental Exam reminders. ;15-Apr-2008 14:20;MGH
 ;;1.5;CLINICAL REMINDERS;**1003,1004,1005**;Jun 19, 2000
 ;===================================================================
 ;This routine will be used as a computed finding for the ADA codes
 ;for a dental exam
 ;1004 Included for backward compatibility
 ;=====================================================================
DENTAL(DFN,TEST,DATE,VALUE,TEXT) ;EP
 K BPXRMDEN
 N BPXRMERR
 S BPXRMERR=$$START1^APCLDF(DFN_"^LAST ADA [APCH DM ADA EXAMS;","BPXRMDEN(")
 I BPXRMERR D
 .  S TEST=0
 .  S:BPXRMERR=7 TEXT="DM AUDIT DENTAL EXAM TAXONOMY does not exist!"
 .  S:BPXRMERR'=7 TEXT="Unable to determine Dental Exam status for this patient.  Notify Site Manager."
 .  Q
 I $D(BPXRMDEN)<1 S TEST=0
 E  D
 .S TEST=1,DATE=$P(BPXRMDEN(1),U,1),VALUE=$P(BPXRMDEN(1),U,2)
 K BPXRMERR
 Q
