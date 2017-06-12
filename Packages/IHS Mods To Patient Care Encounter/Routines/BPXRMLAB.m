BPXRMLAB ; IHS/MSC/MGH - Use V Labs in reminder resolution. ;25-Nov-2013 14:52;DU
 ;;2.0;CLINICAL REMINDERS;**1001**;Feb 04, 2005;Build 21
 ;===================================================================
VLAB(DFN,TEST,DATE,VALUE,TEXT) ;EP
 N BPXTRM
 Q:TEST=""
 S BPXTRM="" S BPXTRM=$O(^PXRMD(811.5,"B",TEST,BPXTRM))
 I BPXTRM=""  S TEST=0,DATE=DT,TEXT="Reminder term does not exist" Q
 D GETVAR(BPXTRM)
 Q
GETVAR(BPXTRM) ;EP
 ;Get the needed data from the reminder term. This includes
 ;the test name(s) and the value to search for
 N X,Y,BPXFIND,BPXTYPE,BPXOFF,BPXFILE,BPXRESLT,BPXCNT,BPXTEST
 K ^TMP("PXRMLAB",$J)
 S BPXCNT=0,BPXRESLT=0
 S BPXFIND=0 F  S BPXFIND=$O(^PXRMD(811.5,BPXTRM,20,BPXFIND)) Q:BPXFIND=""!(BPXFIND?1A.A)!(BPXRESLT=1)  D
 .S BPXTYPE=$P($G(^PXRMD(811.5,BPXTRM,20,BPXFIND,0)),U,1)
 .S BPXTEST=$P(BPXTYPE,";",1),BPXFILE=$P(BPXTYPE,";",2)
 .;This needs to be a term of laboratory tests
 .Q:BPXFILE'="LAB(60,"
 .S BPXOFF=$P($G(^PXRMD(811.5,BPXTRM,20,BPXFIND,0)),U,8)
 .;Call next routine with patient,start and stop dates,test name
 .D RESULT(DFN,BPXTEST)
 ;Loop through results and return most recent
 S BPXRESLT="" S BPXRESLT=$O(^TMP("PXRMLAB",$J,BPXRESLT))
 I BPXRESLT="" S TEST=0,VALUE=TEST
 I +BPXRESLT D
 .S TEST=1,VALUE=$P($G(^TMP("PXRMLAB",$J,BPXRESLT)),U,6)
 .S DATE=$P($G(^TMP("PXRMLAB",$J,BPXRESLT)),U,5)
 .S TEXT=$P($G(^TMP("PXRMLAB",$J,BPXRESLT)),U,2)
 Q
RESULT(DFN,LABIEN) ;EP
 ;EP  Find a patients labs in the V LAB file
 ;Get up to ten results of the specified lab test
 ;If the result has an associated LR ACCESSION NUMBER quit
 ;If not, add it to the array to be used in the reminder
 ;===================================================================
 N VLIEN,INVDATE,TEMP,COUNT
 S INVDATE="",COUNT=0
 F  S INVDATE=$O(^AUPNVLAB("AA",DFN,LABIEN,INVDATE)) Q:INVDATE=""!(COUNT>10)  D
 .S VLIEN="" F  S VLIEN=$O(^AUPNVLAB("AA",DFN,LABIEN,INVDATE,VLIEN)) Q:VLIEN=""  D
 ..S TEMP=$G(^AUPNVLAB(VLIEN,0))
 ..I TEMP'="" D STORE
 Q
STORE ;Store the needed data into TMP for use in reminders
 N FLAG,UNITS,TEMP1,TEMP2,VAL,EVDT,VIEN
 S COUNT=COUNT+1
 S TEMP1=$G(^AUPNVLAB(VLIEN,11))
 S VAL=$P(TEMP,U,4) I VAL="" S VAL="pending"
 S FLAG=$P(TEMP,U,5)
 S UNITS=$P(TEMP1,U,1)
 S VIEN=$P(TEMP,U,3)
 S EVDT=$$GET1^DIQ(9000010.09,VLIEN,1201,"I")
 I EVDT="" S EVDT=$$GET1^DIQ(9000010,VIEN,.01,"I")
 S TEMP2=LABIEN_U_VAL_U_FLAG_U_UNITS_U_EVDT
 S $P(TEMP2,U,6)=$P($G(^LAB(60,LABIEN,.1)),"^")
 S ^TMP("PXRMLAB",$J,INVDATE)=TEMP2
 Q
