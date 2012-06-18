ORWD2 ; SLC/KCM/REV - GUI Prints; 28-JAN-1999 12:51
 ;;3.0;ORDER ENTRY/RESULTS REPORTING;**10**;Dec 17, 1997
 ;
 ; PUBLIC CALLS
 ;
DEVINFO(LST,LOC,NATR,ORDERS)       ; Return device info when signing/releasing orders
 ; Y(0)=Prompt Chart ^ Prompt Label ^ Prompt Requisition ^ Prompt Work
 ;      ^ Chart Device ^ Label Device ^ Requisition Device ^ Work Device
 ; for Prompt X: *=no print, 0=autoprint, 1=prompt&dev 2=prompt only 
 ; Y(n)=ORIFN;ACT ^ Chart ^ Label ^ Requisition ^ Service ^ Work
 ; LOC=location (ptr 44), NATR=nature of order (ptr 100.02)
 ; ORDERS=ORIFN;ACT ^ R | S | E (released, signed, error)
 N NATCHT,NATWRK,WHENCHT,PRMTCHT,PRMTLBL,PRMTREQ,PRMTWRK
 N DOCHT,DOLBL,DOREQ,DOWRK,RELEASE,ORDERID,I,J,X
 S (DOCHT,DOLBL,DOREQ,DOWRK,I,J)=0,LOC=+LOC_";SC("
 S NATR=$O(^ORD(100.02,"C",NATR,0))
 S NATCHT=+$P($G(^ORD(100.02,NATR,1)),U,2),NATWRK=+$P($G(^(1)),U,5)
 S WHENCHT=$$GET^XPAR("ALL^"_LOC,"ORPF PRINT CHART COPY WHEN",1,"I")
 I '$L(WHENCHT) S WHENCHT="R"
 S PRMTCHT=$$GET^XPAR("ALL^"_LOC,"ORPF PROMPT FOR CHART COPY",1,"I")
 S PRMTLBL=$$GET^XPAR("ALL^"_LOC,"ORPF PROMPT FOR LABELS",1,"I")
 S PRMTREQ=$$GET^XPAR("ALL^"_LOC,"ORPF PROMPT FOR REQUISITIONS",1,"I")
 S PRMTWRK=$$GET^XPAR("ALL^"_LOC,"ORPF PROMPT FOR WORK COPY",1,"I")
 F  S I=$O(ORDERS(I)) Q:'I  I $P(ORDERS(I),U,2)'["E" D
 . S ORDERID=$P(ORDERS(I),U),RELEASE=($P(ORDERS(I),U,2)["R")
 . S J=J+1,LST(J)=ORDERID_"^^^^"
 . ; skip chart copy if nature doesn't print, no match to 'print when',
 . ; or prompt parameter says don't print 
 . I NATCHT,($P(ORDERS(I),U,2)[WHENCHT),(PRMTCHT'="*") S $P(LST(J),U,2)=1,DOCHT=1
 . ; skip label if not released, no label format, or prompt parameter
 . ; says don't print
 . I RELEASE,(PRMTLBL'="*"),$$HASFMTL S $P(LST(J),U,3)=1,DOLBL=1
 . ; skip requisition if not released, no requistion format, or the
 . ; prompt parameter says don't print
 . I RELEASE,(PRMTREQ'="*"),$$HASFMTR S $P(LST(J),U,4)=1,DOREQ=1
 . ; skip service copy if not releasing
 . I RELEASE S $P(LST(J),U,5)=1
 . ; skip work copy if nature doesn't print, not released, no work
 . ; copy format, or prompt parameter says don't print
 . I NATWRK,RELEASE,(PRMTWRK'="*"),$$HASFMTW S $P(LST(J),U,6)=1,DOWRK=1
 S LST(0)=$$DEFDEV
 Q
MANUAL(REC,LOC,ORDERS)   ; return device info for manual prints
 N DOCHT,DOLBL,DOREQ,DOWRK,ORDERID,I
 N PRMTCHT,PRMTLBL,PRMTREQ,PRMTWRK  ; (so undefined for DEFDEV call)
 S (DOLBL,DOREQ,DOWRK,I,J)=0,DOCHT=1,LOC=+LOC_";SC("
 F  S I=$O(ORDERS(I)) Q:'I  D  Q:DOCHT&DOLBL&DOREQ&DOWRK
 . S ORDERID=$P(ORDERS(I),U)
 . I $$HASFMTL S DOLBL=1
 . I $$HASFMTR S DOREQ=1
 . I $$HASFMTW S DOWRK=1
 S REC=$$DEFDEV
 Q
 ;
 ; PRIVATE CALLS
 ;
DEFDEV()        ; returns string of prompt flags & default devices
 ; called from DEVINFO & MANUAL
 ; expects LOC,DOCHT,DOLBL,DOREQ,DOWRK to be defined
 ; optionally expects PRMTCHT, PRMTLBL, PRMTREQ, PRMTWRK
 N X
 I DOCHT D
 . S $P(X,U,1)=$G(PRMTCHT,1)
 . S $P(X,U,5)=$TR($$GET^XPAR("ALL^"_LOC,"ORPF CHART COPY PRINT DEVICE",1,"B"),U,";")
 E  S $P(X,U,1)="*"
 I DOLBL D
 . S $P(X,U,2)=$G(PRMTLBL,1)
 . S $P(X,U,6)=$TR($$GET^XPAR("ALL^"_LOC,"ORPF LABEL PRINT DEVICE",1,"B"),U,";")
 E  S $P(X,U,2)="*"
 I DOREQ D
 . S $P(X,U,3)=$G(PRMTREQ,1)
 . S $P(X,U,7)=$TR($$GET^XPAR("ALL^"_LOC,"ORPF REQUISITION PRINT DEVICE",1,"B"),U,";")
 E  S $P(X,U,3)="*"
 I DOWRK D
 . S $P(X,U,4)=$G(PRMTWRK,1)
 . S $P(X,U,8)=$TR($$GET^XPAR("ALL^"_LOC,"ORPF WORK COPY PRINT DEVICE",1,"B"),U,";")
 E  S $P(X,U,4)="*"
 Q X
HASFMTL()       ; returns 1 if a label format is available
 ; called from DEVINFO & MANUAL, expects ORDERID & DOLBL to be defined
 I DOLBL=1 Q 1  ; already know we're doing at least 1 label
 N PKG S PKG=+$P($G(^OR(100,+ORDERID,0)),U,14)
 Q ''$$GET^XPAR("SYS","ORPF WARD LABEL FORMAT",PKG,"I")
 ;
HASFMTR()       ; returns 1 if a requisition format is available
 ; called from DEVINFO & MANUAL, expects ORDERID & DOREQ to be defined
 I DOREQ=1 Q 1  ; already know we're doing at least 1 requisition
 N PKG S PKG=+$P($G(^OR(100,+ORDERID,0)),U,14)
 Q ''$$GET^XPAR("SYS","ORPF WARD REQUISITION FORMAT",PKG,"I")
 ;
HASFMTW()       ; returns 1 if a work copy format is available
 ; called from DEVINFO & MANUAL, expects ORDERID & DOWRK to be defined
 I DOWRK=1 Q 1  ; already know we're doing at least 1 work copy
 Q ''$$GET^XPAR("SYS","ORPF WORK COPY FORMAT",1,"I") ; not at pkg level
  
