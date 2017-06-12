BPXRMRAD ; IHS/MSC/MGH - Use V RAD in reminder resolution. ;25-Nov-2013 14:52;DU
 ;;2.0;CLINICAL REMINDERS;**1001**;Feb 04, 2005;Build 21
 ;===================================================================
VRAD(DFN,TEST,DATE,VALUE,TEXT) ;EP
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
 K ^TMP("PXRMRAD",$J)
 S BPXCNT=0,BPXRESLT=0
 S BPXFIND=0 F  S BPXFIND=$O(^PXRMD(811.5,BPXTRM,20,BPXFIND)) Q:BPXFIND=""!(BPXFIND?1A.A)!(BPXRESLT=1)  D
 .S BPXTYPE=$P($G(^PXRMD(811.5,BPXTRM,20,BPXFIND,0)),U,1)
 .S BPXTEST=$P(BPXTYPE,";",1),BPXFILE=$P(BPXTYPE,";",2)
 .;This needs to be a term of laboratory tests
 .Q:BPXFILE'="RAMIS(71,"
 .S BPXOFF=$P($G(^PXRMD(811.5,BPXTRM,20,BPXFIND,0)),U,8)
 .;Call next routine with patient,start and stop dates,test name
 .D RESULT(DFN,BPXTEST)
 ;Loop through results and return most recent
 S BPXRESLT="" S BPXRESLT=$O(^TMP("PXRMRAD",$J,BPXRESLT))
 I BPXRESLT="" S TEST=0,VALUE=TEST
 I +BPXRESLT D
 .S TEST=1,VALUE=$P($G(^TMP("PXRMRAD",$J,BPXRESLT)),U,2)
 .S DATE=$P($G(^TMP("PXRMRAD",$J,BPXRESLT)),U,1)
 .S TEXT=$P($G(^TMP("PXRMRAD",$J,BPXRESLT)),U,3)
 Q
RESULT(DFN,RADIEN) ;EP
 ;EP  Find a patients labs in the V LAB file
 ;Get up to ten results of the specified lab test
 ;If the result has an associated LR ACCESSION NUMBER quit
 ;If not, add it to the array to be used in the reminder
 ;===================================================================
 N VRIEN,INVDATE,TEMP,RADPROC,COUNT
 S VRIEN="",COUNT=0
 Q:'$D(^AUPNVRAD("AC",DFN))
 F  S VRIEN=$O(^AUPNVRAD("AC",DFN,VRIEN)) Q:VRIEN=""!(COUNT>10)  D
 .S RADPROC=$P($G(^AUPNVRAD(VRIEN,0)),U,1)
 .I RADPROC=RADIEN D STORE
 Q
STORE ;Store the needed data into TMP for use in reminders
 N FLAG,UNITS,ORDER,TEMP,TEMP1,TEMP2,VIS,VDATE,Y,INVDATE,PROC,STATUS
 S COUNT=COUNT+1
 S TEMP=$G(^AUPNVRAD(VRIEN,0)),TEMP1=$G(^AUPNVRAD(VRIEN,11))
 S TEMP2=$G(^AUPNVRAD(VRIEN,12))
 I TEMP1'="" S ORDER="COMPLETE",STATUS="COMPLETE"
 I TEMP1="" S ORDER="IN PROGRESS",STATUS="IN PROGRESS"
 S PROC=$$GET1^DIQ(9000010.22,VRIEN,.01)
 I $P(TEMP2,U,1)="" D
 .S VIS=$P($G(^AUPNVRAD(VRIEN,0)),U,3)
 .Q:VIS=""
 .S VDATE=$P($G(^AUPNVSIT(VIS,0)),U,1)
 .S Y=VDATE
 E  S Y=$P(TEMP2,U,1)
 S INVDATE=9999999-Y
 S ^TMP("PXRMRAD",$J,INVDATE)=Y_U_PROC_U_STATUS
 Q
