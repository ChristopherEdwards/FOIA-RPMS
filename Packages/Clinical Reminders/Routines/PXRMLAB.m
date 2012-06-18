PXRMLAB ; SLC/PKR - Handle laboratory test findings. ;24-Mar-2006 13:14;MGH
 ;;1.5;CLINICAL REMINDERS;**2,5,8,1003,1004**;Jun 19, 2000
 ;IHS/CIA/MGH  1004 for backward compatibility
 ;=====================================================================
 ;Edited to allow V LAB entries to satisfy the reminder
 ;=======================================================================
EVALFI(DFN,FIEVAL) ;Evaluate laboratory test findings.
 N FIND0,FIND3,FINDING,LABIEN
 S LABIEN=""
 F  S LABIEN=$O(^PXD(811.9,PXRMITEM,20,"E","LAB(60,",LABIEN)) Q:+LABIEN=0  D
 . S FINDING=""
 . F  S FINDING=$O(^PXD(811.9,PXRMITEM,20,"E","LAB(60,",LABIEN,FINDING)) Q:+FINDING=0  D
 .. S FIND0=^PXD(811.9,PXRMITEM,20,FINDING,0)
 .. S FIND3=$G(^PXD(811.9,PXRMITEM,20,FINDING,3))
 .. D FIEVAL(DFN,LABIEN,FIND0,FIND3,"","",FINDING,.FIEVAL)
 Q
 ;
 ;=======================================================================
EVALTERM(DFN,FINDING,TERMIEN,TFIEVAL) ;Evaluate laboratory test terms.
 N FIND0,FIND3,LABIEN,LFIEVAL,TFIND0,TFIND3,TFINDING
 S FIND0=^PXD(811.9,PXRMITEM,20,FINDING,0)
 S FIND3=$G(^PXD(811.9,PXRMITEM,20,FINDING,3))
 S LABIEN=""
 F  S LABIEN=$O(^PXRMD(811.5,TERMIEN,20,"E","LAB(60,",LABIEN)) Q:+LABIEN=0  D
 . S TFINDING=""
 . F  S TFINDING=$O(^PXRMD(811.5,TERMIEN,20,"E","LAB(60,",LABIEN,TFINDING)) Q:+TFINDING=0  D
 .. S TFIND0=^PXRMD(811.5,TERMIEN,20,TFINDING,0)
 .. S TFIND3=$G(^PXRMD(811.5,TERMIEN,20,TFINDING,3))
 .. D FIEVAL(DFN,LABIEN,FIND0,FIND3,TFIND0,TFIND3,TFINDING,.TFIEVAL)
 Q
 ;
 ;=======================================================================
FIEVAL(DFN,LABIEN,FIND0,FIND3,TFIND0,TFIND3,FINDING,FIEVAL) ;
 N CONVAL,DATA,DATE,IEN,IND,INVDATE,LRT
 N SEQ,RESULT,STATUS,VALID,VALUE
 K ^TMP("LRRR",$J)
 D RR^LR7OR1(DFN,"","","","CH",LABIEN,"",10)
 ;=======================================================================
 ;IHS/CIA/MGH -Edited to add in entries in the VLAB file that are not in the regular
 ;lab file
 D VLAB^BPXRMLAB(DFN,LABIEN,10)
 ;======================================================================
 S INVDATE=$O(^TMP("LRRR",$J,DFN,"CH",""))
 I INVDATE="" S FIEVAL(FINDING)=0 K ^TMP("LRRR",$J) Q
 ;Order the results putting cancelled or pending last.
 S INVDATE=""
 F  S INVDATE=$O(^TMP("LRRR",$J,DFN,"CH",INVDATE)) Q:+INVDATE=0  D
 . S SEQ=""
 . F  S SEQ=$O(^TMP("LRRR",$J,DFN,"CH",INVDATE,SEQ)) Q:+SEQ=0  D
 .. S DATA=^TMP("LRRR",$J,DFN,"CH",INVDATE,SEQ)
 .. S RESULT=$P(DATA,U,2)
 .. I (RESULT="canc")!(RESULT="pending") S STATUS=1
 .. E  S STATUS=0
 .. S LRT(STATUS,INVDATE)=DATA
 K ^TMP("LRRR",$J)
 ;Process the list.
 S STATUS=""
 S STATUS=$O(LRT(STATUS))
 I STATUS'=0 S FIEVAL(FINDING)=0 Q
 S INVDATE=$O(LRT(STATUS,INVDATE))
 S DATE=$$FMDFINVL^PXRMDATE(INVDATE,0)
 ;Save the rest of the finding information.
 S FIEVAL(FINDING)=1
 S FIEVAL(FINDING,"DATE")=DATE
 S FIEVAL(FINDING,"FINDING")=LABIEN_";LAB(60,"
 S DATA=LRT(STATUS,INVDATE)
 S FIEVAL(FINDING,"DATA")=DATA
 S VALUE=$P(DATA,U,2)
 S FIEVAL(FINDING,"RESULT")=$P(DATA,U,2)
 S FIEVAL(FINDING,"VALUE")=FIEVAL(FINDING,"RESULT")
 ;If this is being called as part of a term evaluation we are done.
 I TFIND0'="" Q
 ;Determine if the finding has expired.
 S VALID=$$VALID^PXRMDATE(FIND0,TFIND0,DATE)
 I 'VALID D  Q
 . S FIEVAL(FINDING)=0
 . S FIEVAL(FINDING,"EXPIRED")=""
 ;If there is a condition for this finding evaluate it.
 S CONVAL=$$COND^PXRMUTIL(FIND3,TFIND3,FIEVAL(FINDING,"VALUE"))
 I CONVAL'="" D
 . I CONVAL D
 .. S FIEVAL(FINDING)=CONVAL
 .. S FIEVAL(FINDING,"CONDITION")=CONVAL
 . E  D
 .. K FIEVAL(FINDING)
 .. S FIEVAL(FINDING)=0
 Q
 ;
 ;=======================================================================
OUTPUT(NLINES,TEXT,FINDING,FIEVAL) ;Produce the clinical
 ;maintenance output.
 N DATA,DATE,LABIEN,PNAME,TEMP,VALUE
 S DATA=FIEVAL(FINDING,"DATA")
 S DATE=FIEVAL(FINDING,"DATE")
 S VALUE=$G(FIEVAL(FINDING,"VALUE"))
 S TEMP=$$EDATE^PXRMDATE(DATE)
 S TEMP=TEMP_" Laboratory test: "
 S PNAME=$P(DATA,U,10)
 I $L(PNAME)=0 S PNAME=$P(DATA,U,15)
 S TEMP=TEMP_PNAME
 I $L(VALUE)>0 D
 . S TEMP=TEMP_"; value - "
 . S TEMP=TEMP_VALUE
 ;If the finding has expired add "EXPIRED"
 I $D(FIEVAL(FINDING,"EXPIRED")) S TEMP=TEMP_" - EXPIRED"
 ;If the finding is false because of the value add the reason.
 I $G(FIEVAL(FINDING,"CONDITION"))=0 S TEMP=TEMP_$$ACTFT^PXRMOPT
 S NLINES=NLINES+1
 S TEXT(NLINES)=TEMP
 I $D(PXRMDEV) D
 . N UID
 . S UID="LAB "_PNAME
 . S ^TMP(PXRMPID,$J,PXRMITEM,UID)=TEMP
 Q
 ;
