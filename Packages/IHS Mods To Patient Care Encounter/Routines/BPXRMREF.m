BPXRMREF ; SLC/PKR - Handle Refusal findings. ;07-May-2009 12:46;MGH
 ;;1.5;CLINICAL REMINDERS;**1004,1006**;Jun 19, 2000
 ;
 ;IHS/CIA/MGH Routine to evaluate refusals for findings.  Entries in the refuals file can
 ;be used in findings for the EHR remnder terms
 ;=======================================================================
EVALFI(DFN,FIEVAL) ;Evaluate refusal findings.
 N REFIEN,INVDATE,REFTYP,FIND0,FIND3,FINDING
 S REFIEN=""
 F  S REFIEN=$O(^PXD(811.9,PXRMITEM,20,"E","AUTTREFT(",REFIEN)) Q:+REFIEN=0  D
 .S REFTYP=$P($G(^AUTTREFT(REFIEN,0)),U,2)
 .S FINDING=""
 .F  S FINDING=$O(^PXD(811.9,PXRMITEM,20,"E","AUTTREFT(",REFIEN,FINDING)) Q:+FINDING=0  D
 ..S FIND0=^PXD(811.9,PXRMITEM,20,FINDING,0)
 ..S FIND3=$G(^PXD(811.9,PXRMITEM,20,FINDING,3))
 ..D FIEVAL(DFN,REFIEN,FIND0,FIND3,"","",FINDING,.FIEVAL)
 Q
 ;
 ;=======================================================================
EVALTERM(DFN,FINDING,TERMIEN,TFIEVAL) ;Evaluate refusal terms.
 N REFIEN,FIND0,FIND3,INVDATE,LFIEVAL,TFIND0,TFIND3,TFINDING
 S FIND0=^PXD(811.9,PXRMITEM,20,FINDING,0)
 S FIND3=$G(^PXD(811.9,PXRMITEM,20,FINDING,3))
 S REFIEN=""
 F  S REFIEN=$O(^PXRMD(811.5,TERMIEN,20,"E","AUTTREFT(",REFIEN)) Q:+REFIEN=0  D
 . S REFTYP=$P($G(^AUTTREFT(REFIEN,0)),U,2)
 . S TFINDING=""
 . F  S TFINDING=$O(^PXRMD(811.5,TERMIEN,20,"E","AUTTREFT(",REFIEN,TFINDING)) Q:+TFINDING=0  D
 .. S TFIND0=^PXRMD(811.5,TERMIEN,20,TFINDING,0)
 .. S TFIND3=$G(^PXRMD(811.5,TERMIEN,20,TFINDING,3))
 .. D FIEVAL(DFN,REFIEN,FIND0,FIND3,TFIND0,TFIND3,TFINDING,.TFIEVAL)
 Q
 ;
 ;=======================================================================
FIEVAL(DFN,REFIEN,FIND0,FIND3,TFIND0,TFIND3,FINDING,FIEVAL) ;
 N CONVAL,DATE,IEN,IND,RSLT,TEMP,VALID,VIEN,FIEN,FINISHED,INVDATE
 ;Set finding to zero to start
 S FIEVAL(FINDING)=0,FINISHED=0
 S FIEN="" S FIEN=$O(^AUPNPREF("AA",DFN,REFTYP,FIEN)) Q:FIEN=""!(FINISHED=1)  D
 . S INVDATE="" S INVDATE=$O(^AUPNPREF("AA",DFN,REFTYP,FIEN,INVDATE)) Q:INVDATE=""!(FINISHED=1)  D
 ..S IEN=""  S IEN=$O(^AUPNPREF("AA",DFN,REFTYP,FIEN,INVDATE,IEN))
 ..S TEMP=$G(^AUPNPREF(IEN,0))
 ..S RSLT=$P(TEMP,U,4)
 ..S DATE=$P(TEMP,U,3)
 ..;S DATE=$$VDATE^PXRMDATE(DATE)
 ..;If there is a type of refusal to be examined (and there should be),evaluate it
 ..;If there is no condition, then the first finging of this type is sufficient
 ..;If there is a condition for this finding evaluate it.
 ..S CONVAL=$$COND^PXRMUTIL(FIND3,TFIND3,RSLT)
 ..I CONVAL>0 D
 ...I CONVAL D
 ....S FIEVAL(FINDING)=CONVAL
 ....S FIEVAL(FINDING,"CONDITION")=CONVAL
 ....S FINISHED=1
 ....;Save the rest of the finding information.
 ....S FIEVAL(FINDING)=1
 ....S FIEVAL(FINDING,"DATE")=DATE
 ....S FIEVAL(FINDING,"FINDING")=REFIEN_";AUTTREFT("
 ....S FIEVAL(FINDING,"SOURCE")=IEN_";AUPNPREF("
 ....S FIEVAL(FINDING,"RESULT")=RSLT
 ....S FIEVAL(FINDING,"VALUE")=RSLT
 ;If this is being called as part of a term evaluation we are done.
 I TFIND0'="" Q
 ;Determine if the finding has expired.
 I FIEVAL(FINDING)=1 D
 .S VALID=$$VALID^PXRMDATE(FIND0,TFIND0,DATE)
 .I 'VALID D  Q
 ..S FIEVAL(FINDING)=0
 ..S FIEVAL(FINDING,"EXPIRED")=""
 Q
 ;
 ;=======================================================================
OUTPUT(NLINES,TEXT,FINDING,FIEVAL) ;Produce the clinical
 ;maintenance output.
 N REFIEN,EM,FIEN,IND,PNAME,RSLT,TEMP,VDATE
 S REFIEN=$P(FIEVAL(FINDING,"SOURCE"),";",1)
 S FIEN=$P(FIEVAL(FINDING,"FINDING"),";",1)
 S VDATE=FIEVAL(FINDING,"DATE")
 S RSLT=$G(FIEVAL(FINDING,"VALUE"))
 S TEMP=$$EDATE^PXRMDATE(VDATE)
 S TEMP=TEMP_" Refusal: "
 S IND=$P(^AUPNPREF(REFIEN,0),U,1)
 S PNAME=$P(^AUTTREFT(FIEN,0),U,1)
 S TEMP=TEMP_PNAME
 I $L(RSLT)>0 D
 . S TEMP=TEMP_"; result - "
 . S TEMP=TEMP_$$EXTERNAL^DILFD(9000022,.04,"",RSLT,.EM)
 ;If the finding has expired add "EXPIRED"
 I $D(FIEVAL(FINDING,"EXPIRED")) S TEMP=TEMP_" - EXPIRED"
 ;If the finding is false because of the value add the reason.
 I $G(FIEVAL(FINDING,"CONDITION"))=0 S TEMP=TEMP_$$ACTFT^PXRMOPT
 S NLINES=NLINES+1
 S TEXT(NLINES)=TEMP
 I $D(PXRMDEV) D
 . N UID
 . S UID="REFUSAL "_PNAME
 . S ^TMP(PXRMPID,$J,PXRMITEM,UID)=TEMP
 ;
 ;For historical encounters display the location and comments.
 I VDATE["E" D
 . N INDEX,VIEN
 . S INDEX="REFUSAL-"_PNAME
 . S VIEN=FIEVAL(FINDING,"VIEN")
 . D HLCV^PXRMVSIT(.NLINES,.TEXT,VIEN,INDEX)
 Q
 ;
 ;=======================================================================
PATLIST(INDEX,EXAMIEN,FINDING,FIND0,FIND3,TFIND0,TFIND3,FIEVAL) ;Build a
 ;list of patients with a particular exam.
 K ^TMP(INDEX,$J,FINDING)
 K ^TMP("PXRMEXLIST",$J)
 N CONVAL,DATE,DFN,IND,TEMP,VALID,VALUE,VISIT
 S IND=0
 F  S IND=+$O(^AUPNVXAM("B",EXAMIEN,IND)) Q:IND=0  D
 . S TEMP=$G(^AUPNVXAM(IND,0))
 . S DFN=$P(TEMP,U,2)
 . S VISIT=$P(TEMP,U,3)
 . S DATE=$P(^AUPNVSIT(VISIT,0),U,1)
 . S VALID=$$VALID^PXRMDATE(FIND0,TFIND0,DATE)
 . I 'VALID Q
 .;Save the result.
 . S VALUE=$P(TEMP,U,4)
 . S CONVAL=$$COND^PXRMUTIL(FIND3,TFIND3,VALUE)
 . I (CONVAL="")!(CONVAL) D
 .. S TEMP="RESULT~"_VALUE_U_"SOURCE~"_IND_";AUPNVXAM("_U_"VISIT~"_VISIT
 .. S ^TMP("PXRMEXLIST",$J,DFN,DATE)=TEMP
 ;Only valid entries are on the list, save the most recent.
 S DFN=0
 F  S DFN=+$O(^TMP("PXRMEXLIST",$J,DFN)) Q:DFN=0  D
 . S DATE=$O(^TMP("PXRMEXLIST",$J,DFN,""),-1)
 . S ^TMP(INDEX,$J,DFN,DATE,FINDING)="FINDING~"_FIEVAL(FINDING,"FINDING")_U_^TMP("PXRMEXLIST",$J,DFN,DATE)
 K ^TMP("PXRMEXLIST",$J)
 Q
 ;
