PXRMORDR ; SLC/PKR - Handle order findings. ;01/22/2002
 ;;1.5;CLINICAL REMINDERS;**2,8**;Jun 19, 2000
 ;
 ;=======================================================================
EVALFI(DFN,FIEVAL) ;Evaluate radiology findings.
 N FIND0,FIND3,FINDING,ORDER
 ;Go through the orderable items.
 S ORDER=""
 F  S ORDER=$O(^PXD(811.9,PXRMITEM,20,"E","ORD(101.43,",ORDER)) Q:+ORDER=0  D
 . S FINDING=""
 . F  S FINDING=$O(^PXD(811.9,PXRMITEM,20,"E","ORD(101.43,",ORDER,FINDING)) Q:+FINDING=0  D
 .. S FIND0=^PXD(811.9,PXRMITEM,20,FINDING,0)
 .. S FIND3=$G(^PXD(811.9,PXRMITEM,20,FINDING,3))
 .. D FIEVAL(DFN,FIND0,FIND3,"","",FINDING,.FIEVAL,ORDER)
 Q
 ;
 ;=======================================================================
EVALTERM(DFN,FINDING,TERMIEN,TFIEVAL) ;Evaluate orderable item terms.
 N FIND0,FIND3,ORDER,TFIND0,TFIND3,TFINDING
 S FIND0=^PXD(811.9,PXRMITEM,20,FINDING,0)
 S FIND3=$G(^PXD(811.9,PXRMITEM,20,FINDING,3))
 ;Go through the orderable items.
 S ORDER=""
 F  S ORDER=$O(^PXRMD(811.5,TERMIEN,20,"E","ORD(101.43,",ORDER)) Q:+ORDER=0  D
 . S TFINDING=""
 . F  S TFINDING=$O(^PXRMD(811.5,TERMIEN,20,"E","ORD(101.43,",ORDER,TFINDING)) Q:+TFINDING=0  D
 .. S TFIND0=^PXRMD(811.5,TERMIEN,20,TFINDING,0)
 .. S TFIND3=$G(^PXRMD(811.5,TERMIEN,20,TFINDING,3))
 .. D FIEVAL(DFN,FIND0,FIND3,TFIND0,TFIND3,TFINDING,.TFIEVAL,ORDER)
 Q
 ;
 ;=======================================================================
FIEVAL(DFN,FIND0,FIND3,TFIND0,TFIND3,FINDING,FIEVAL,ORDER) ;
 N ADATE,CONVAL,DATE,IND,ORINFO,PDATE
 N SIND,STATUS,TEMP,VALID
 ;
 S FIEVAL(FINDING)=0
 ;Get the matches
 K ORINFO
 D LATEST^ORX8(DFN,ORDER,.ORINFO)
 ;If ORINFO=0 the patient has never had this order.
 I ORINFO=0 Q
 S STATUS=""
 ;First look for orders with a status of pending or active. By
 ;default these will make the finding true. Get the start date.
 S PDATE=+$P($G(ORINFO(5)),U,4)
 S ADATE=+$P($G(ORINFO(6)),U,4)
 I (PDATE>0)&(PDATE>ADATE) D
 . S FIEVAL(FINDING)=1
 . S FIEVAL(FINDING,"FINDING")=ORDER_";ORD(101.43,"
 . S FIEVAL(FINDING,"DATE")=PDATE
 . S STATUS=$P(ORINFO(5),U,7)
 . S SIND=5
 I (ADATE>0)&(ADATE'<PDATE) D
 . S FIEVAL(FINDING)=1
 . S FIEVAL(FINDING,"FINDING")=ORDER_";ORD(101.43,"
 . S FIEVAL(FINDING,"DATE")=ADATE
 . S STATUS=$P(ORINFO(6),U,7)
 . S SIND=6
 ;If no pending or active status were found use the one with the
 ;most recent date.
 I 'FIEVAL(FINDING) D
 . S (DATE,IND)=0
 . F  S IND=$O(ORINFO(IND)) Q:+IND=0  D
 .. S TEMP=+$P(ORINFO(IND),U,4)
 .. I TEMP>DATE D
 ... S DATE=TEMP
 ... S STATUS=$P(ORINFO(IND),U,7)
 ... S SIND=IND
 . S FIEVAL(FINDING,"DATE")=DATE
 . S FIEVAL(FINDING,"FINDING")=ORDER_";ORD(101.43,"
 ;Save the rest of the finding information.
 I STATUS'="" D
 . S FIEVAL(FINDING,"STATUS")=STATUS
 . S FIEVAL(FINDING,"VALUE")=STATUS
 S TEMP=ORINFO(SIND)
 S FIEVAL(FINDING,"ORIEN")=$P(TEMP,U,1)
 S FIEVAL(FINDING,"ORDERED BY")=$P(TEMP,U,2)
 S FIEVAL(FINDING,"LOCATION")=$P(TEMP,U,6)
 ;If this is being called as part of a term evaluation we are done.
 I TFIND0'="" Q
 ;Determine if the finding has expired.
 S VALID=$$VALID^PXRMDATE(FIND0,TFIND0,FIEVAL(FINDING,"DATE"))
 I 'VALID D
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
 N D0,DATE,NAME,OI,TEMP
 S OI=$P(FIEVAL(FINDING,"FINDING"),";",1)
 S DATE=FIEVAL(FINDING,"DATE")
 S TEMP=$$EDATE^PXRMDATE(DATE)
 S TEMP=TEMP_" Orderable Item: "
 S D0=^ORD(101.43,OI,0)
 S NAME=$P(D0,U,1)
 S TEMP=TEMP_NAME
 S TEMP=TEMP_"; status:  "_FIEVAL(FINDING,"STATUS")
 ;If the finding has expired add "EXPIRED"
 I $D(FIEVAL(FINDING,"EXPIRED")) S TEMP=TEMP_" - EXPIRED"
 ;If the finding is false because of the value add the reason.
 I $G(FIEVAL(FINDING,"CONDITION"))=0 S TEMP=TEMP_$$ACTFT^PXRMOPT
 S NLINES=NLINES+1
 S TEXT(NLINES)=TEMP
 I $D(PXRMDEV) D
 . N UID
 . S UID="ORDER "_NAME
 . S ^TMP(PXRMPID,$J,PXRMITEM,UID)=TEMP
 Q
 ;
