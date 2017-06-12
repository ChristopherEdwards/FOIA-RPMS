BPXRMDRG ; IHS/MSC/MGH - Use V Meds in reminder resolution. ;25-Nov-2013 14:57;DU
 ;;2.0;CLINICAL REMINDERS;**1001**;Feb 04, 2005;Build 21
 ;===================================================================
VMED(DFN,TEST,DATE,VALUE,TEXT) ;EP
 N BPXTRM
 Q:TEST=""
 S BPXTRM="" S BPXTRM=$O(^PXRMD(811.5,"B",TEST,BPXTRM))
 I BPXTRM=""  S TEST=0,DATE=DT,TEXT="Reminder term does not exist" Q
 D GETVAR(BPXTRM)
 Q
GETVAR(BPXTRM) ;EP
 ;Get the needed data from the reminder term. This includes
 ;the test name(s) and the value to search for
 N X,Y,BPXFIND,BPXTYPE,BPXOFF,BPXFILE,BPXRESLT,BPXCNT,BPXTEST,ARRAY
 K ^TMP("PXRMMED",$J)
 D GETMEDS(DFN)
 S BPXCNT=0,BPXRESLT=0
 S BPXFIND=0 F  S BPXFIND=$O(^PXRMD(811.5,BPXTRM,20,BPXFIND)) Q:BPXFIND=""!(BPXFIND?1A.A)!(BPXRESLT=1)  D
 .S BPXTYPE=$P($G(^PXRMD(811.5,BPXTRM,20,BPXFIND,0)),U,1)
 .S BPXTEST=$P(BPXTYPE,";",1),BPXFILE=$P(BPXTYPE,";",2)
 .;This needs to be a term of medications
 .Q:(BPXFILE'="PSNDF(50.6,")&(BPXFILE'="PSDRUG(,")
 .S BPXOFF=$P($G(^PXRMD(811.5,BPXTRM,20,BPXFIND,0)),U,8)
 .;Call next routine with patient,start and stop dates,test name
 .D RESULT(DFN,BPXTEST,BPXFILE)
 ;Loop through results and return most recent
 S BPXRESLT="" S BPXRESLT=$O(ARRAY(BPXRESLT))
 I BPXRESLT="" S TEST=0,VALUE=TEST
 I +BPXRESLT D
 .S TEST=1,VALUE=$P(ARRAY(BPXRESLT),U,1)
 .S VALUE=$$GET1^DIQ(50,VALUE,.01)
 .S DATE=$P(ARRAY(BPXRESLT),U,2)
 Q
GETMEDS(DFN) ;EP
 ;EP  Find a patients labs in the V MED file
 ;Get up to the last 3 years.
 ;If not, add it to the array to be used in the reminder
 ;===================================================================
 N ORDER,DRUG,SDATE,INVDATE,VMIEN,MED,TEMP,EVDT,DATE,STARTDT,X1,X2
 N DISC,DSUP,INVDTE
 K ^TMP("PXRMMED",$J)
 S X1=DT,X2=-1095 D C^%DTC S STARTDT=X
 S STARTDT=9999999-STARTDT
 Q:'$D(^AUPNVMED("AA",DFN))
 S (VMIEN,INVDATE)=0
 F  S INVDATE=$O(^AUPNVMED("AA",DFN,INVDATE)) Q:INVDATE=""!(INVDATE>STARTDT)  D
 .S VMIEN="" F  S VMIEN=$O(^AUPNVMED("AA",DFN,INVDATE,VMIEN)) Q:VMIEN=""  D
 ..S EVDT=$P($G(^AUPNVMED(VMIEN,12)),U,1)
 ..I $P($G(^AUPNVMED(VMIEN,11)),U,8)'="" S EVDT=DT
 ..S TEMP=$G(^AUPNVMED(VMIEN,0))
 .S MED=$P(TEMP,U,1)
 .S DSUP=$P(TEMP,U,7)
 .S DISC=$P(TEMP,U,8)
 .Q:DISC'=""
 .S INVDTE=9999999-EVDT
 .S ^TMP("PXRMMED",$J,INVDTE,MED)=EVDT
 Q
RESULT(DFN,BPXTEST,BPXFILE) ;FIND MATCHES
 ;Loop through med list looking for matches
 N DTE,MED,POI
 S DTE="" F  S DTE=$O(^TMP("PXRMMED",$J,DTE)) Q:DTE=""  D
 .S MED="" F  S MED=$O(^TMP("PXRMMED",$J,DTE,MED)) Q:MED=""  D
 ..I BPXFILE="PSDRUG(," D
 ...I BPXTEST=MED S ARRAY(DTE)=MED
 ..I BPXFILE="PSNDF(50.6," D
 ...I $D(^PSDRUG("AND",BPXTEST,MED))>0 S ARRAY(DTE)=MED_U_$G(^TMP("PXRMMED",$J,DTE,MED))
 Q
