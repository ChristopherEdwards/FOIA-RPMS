PXRMRAD ; SLC/PKR - Handle radiology findings. ;24-Mar-2006 12:17;MGH
 ;;1.5;CLINICAL REMINDERS;**2,8,11,1003,1004**;Jun 19, 2000
 ;IHS/CIA/MGH
 ;PATCH 1004 included for backward compatibility
 ;=====================================================================
 ;Edited to allow entries in the V RAD file satisfy reminders
 ;=======================================================================
EVALFI(DFN,FIEVAL) ;Evaluate radiology findings.
 N FIND0,FIND3,FINDING,RADPROC
 ;Build a list of radiology procedures.
 S RADPROC=""
 F  S RADPROC=$O(^PXD(811.9,PXRMITEM,20,"E","RAMIS(71,",RADPROC)) Q:+RADPROC=0  D
 . S FINDING=""
 . F  S FINDING=$O(^PXD(811.9,PXRMITEM,20,"E","RAMIS(71,",RADPROC,FINDING)) Q:+FINDING=0  D
 .. S FIND0=^PXD(811.9,PXRMITEM,20,FINDING,0)
 .. S FIND3=$G(^PXD(811.9,PXRMITEM,20,FINDING,3))
 .. D FIEVAL(DFN,RADPROC,FIND0,FIND3,"","",FINDING,.FIEVAL)
 Q
 ;
 ;=======================================================================
EVALTERM(DFN,FINDING,TERMIEN,TFIEVAL) ;Evaluate radiology terms.
 N FIND0,FIND3,RADPROC,TFIND0,TFIND3,TFINDING
 S FIND0=^PXD(811.9,PXRMITEM,20,FINDING,0)
 S FIND3=$G(^PXD(811.9,PXRMITEM,20,FINDING,3))
 ;Build a list of radiology procedures.
 S RADPROC=""
 F  S RADPROC=$O(^PXRMD(811.5,TERMIEN,20,"E","RAMIS(71,",RADPROC)) Q:+RADPROC=0  D
 . S TFINDING=""
 . F  S TFINDING=$O(^PXRMD(811.5,TERMIEN,20,"E","RAMIS(71,",RADPROC,TFINDING)) Q:+TFINDING=0  D
 .. S TFIND0=^PXRMD(811.5,TERMIEN,20,TFINDING,0)
 .. S TFIND3=$G(^PXRMD(811.5,TERMIEN,20,TFINDING,3))
 .. D FIEVAL(DFN,RADPROC,FIND0,FIND3,TFIND0,TFIND3,TFINDING,.TFIEVAL)
 Q
 ;
 ;=======================================================================
FIEVAL(DFN,RADPROC,FIND0,FIND3,TFIND0,TFIND3,FINDING,FIEVAL) ;
 N CONVAL,DATE,RADPTIEN,STATUS,TEMP,VALID
 S FIEVAL(FINDING)=0
 ;Get the matches
 D CLIN^RAO7PC2(DFN,RADPROC)
 ;======================================================================
 ;IHS/CIA/MGH Make a call to V Radiology to see if the procedure is there
 D VRAD^BPXRMRAD(DFN,RADPROC)
 ;======================================================================
 ;If this is an unknown radiology patient we are done.
 I $G(^TMP($J,"RADPROC"))["Invalid" G DONE
 ;
 S RADPTIEN=$O(^TMP($J,"RADPROC",""))
 ;STATUS can be "CANCELLED", "COMPLETE", "IN PROGRESS", or "NONE".
 ;Ignore any that are cancelled.
 S STATUS=""
 F  S STATUS=$O(^TMP($J,"RADPROC",RADPTIEN,RADPROC,STATUS)) Q:STATUS=""  D
 . I (STATUS="NONE") Q
 .;If there is a "COMPLETE" status make sure we save it only.
 . I 'FIEVAL(FINDING) S FIEVAL(FINDING,"STATUS")=STATUS
 . I (STATUS="CANCELLED") D
 .. S FIEVAL(FINDING,"DATA")=^TMP($J,"RADPROC",RADPTIEN,RADPROC,STATUS)
 .. S FIEVAL(FINDING,"DATE")=$P(FIEVAL(FINDING,"DATA"),U,1)
 . I STATUS="COMPLETE" D
 .. S FIEVAL(FINDING)=1
 .. S FIEVAL(FINDING,"DATA")=^TMP($J,"RADPROC",RADPTIEN,RADPROC,STATUS)
 .. S (FIEVAL(FINDING,"DATE"),DATE)=$P(FIEVAL(FINDING,"DATA"),U,1)
 .;Save information about an "IN PROGRESS" procedure if it is more
 .;recent than the completed one or there is not a completed one.
 . I STATUS="IN PROGRESS" D
 .. S TEMP=^TMP($J,"RADPROC",RADPTIEN,RADPROC,STATUS)
 .. S DATE=$P(TEMP,U,1)
 .. I DATE>+$G(FIEVAL(FINDING,"DATE")) D
 ... I 'FIEVAL(FINDING) S FIEVAL(FINDING,"DATE")=DATE
 ... S FIEVAL(FINDING,"IN PROGRESS")=TEMP
 . S FIEVAL(FINDING,"FINDING")=RADPROC_";RAMIS(71,"
 ;If this is being called as part of a term evaluation we are done.
 I TFIND0'="" Q
 ;Determine if the finding has expired.
 I FIEVAL(FINDING) D
 . S VALID=$$VALID^PXRMDATE(FIND0,TFIND0,FIEVAL(FINDING,"DATE"))
 . I 'VALID D
 .. S FIEVAL(FINDING)=0
 .. S FIEVAL(FINDING,"EXPIRED")=""
 ;If there is a condition for this finding evaluate it.
 S CONVAL=$$COND^PXRMUTIL(FIND3,TFIND3,"")
 I CONVAL'="" D
 . I CONVAL D
 .. S FIEVAL(FINDING)=CONVAL
 .. S FIEVAL(FINDING,"CONDITION")=CONVAL
 . E  D
 .. K FIEVAL(FINDING)
 .. S FIEVAL(FINDING)=0
DONE K ^TMP($J,"RADPROC")
 Q
 ;
 ;=======================================================================
OUTPUT(NLINES,TEXT,FINDING,FIEVAL) ;Produce the clinical
 ;maintenance output.
 N CPT,CPTDATA,CODE,D0,DATE,NAME,RADPROC,SNAME,TEMP
 S RADPROC=$P(FIEVAL(FINDING,"FINDING"),";",1)
 S DATE=FIEVAL(FINDING,"DATE")
 S TEMP=$$EDATE^PXRMDATE(DATE)
 S TEMP=TEMP_" Radiology Procedure: "
 S D0=^RAMIS(71,RADPROC,0)
 S NAME=$P(D0,U,1)
 S CPT=$P(D0,U,9)
 S CPTDATA=$$CPT^ICPTCOD(CPT)
 S CODE=$P(CPTDATA,U,2)
 S SNAME=$P(CPTDATA,U,3)
 S TEMP=TEMP_CODE_" ("_NAME_")"
 S TEMP=TEMP_" - "_SNAME
 S TEMP=TEMP_"; status:  "_FIEVAL(FINDING,"STATUS")
 ;If the finding has expired add "EXPIRED"
 I $D(FIEVAL(FINDING,"EXPIRED")) S TEMP=TEMP_" - EXPIRED"
 S NLINES=NLINES+1
 S TEXT(NLINES)=TEMP
 I $D(PXRMDEV) D
 . N UID
 . S UID="RAD "_NAME
 . S ^TMP(PXRMPID,$J,PXRMITEM,UID)=TEMP
 ;
 ;If there is an "IN PROGRESS" as well as complete procedure and
 ;the "IN PROGRESS" is newer than the complete show some information
 ;on it.
 I (FIEVAL(FINDING))&($D(FIEVAL(FINDING,"IN PROGRESS"))) D
 . N IPDATE,STATUS
 . S IPDATE=$P(FIEVAL(FINDING,"IN PROGRESS"),U,1)
 . I IPDATE>DATE D
 .. S STATUS=$P(FIEVAL(FINDING,"IN PROGRESS"),U,2)
 .. S TEMP="This procedure is also in progress."
 .. S TEMP=TEMP_" "_$$EDATE^PXRMDATE(IPDATE)
 .. S TEMP=TEMP_" status:  "_STATUS
 .. S NLINES=NLINES+1
 .. S TEXT(NLINES)=TEMP
 Q
 ;
