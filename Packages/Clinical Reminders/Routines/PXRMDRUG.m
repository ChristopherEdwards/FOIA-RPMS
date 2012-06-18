PXRMDRUG ; SLC/PKR - Handle drug findings. ;19-Oct-2009 17:55;MGH
 ;;1.5;CLINICAL REMINDERS;**2,5,8,11,1003,1004,1007**;Jun 19, 2000
 ;IHS/CIA/MGH
 ;Patch 1007 changes made for eprescribing
 ;=====================================================================
 ;Edited to allow V MED entries to be used in reminder resolution
 ;=======================================================================
BLDCACHE(DFN) ;Build the patient drug cache.
 N PXRMDFN S PXRMDFN="PXRMDFN"_DFN
 K ^TMP("PS",$J),^XTMP(PXRMDFN,"PSDRUG")
 N DRUG,DRUGIEN,DSUP,IND,OITEM,ORDER,POI,RDATE,SDATE,STATUS,TEMP
 ;Start the search for drugs on the patient's date of birth
 ;to make sure we get all of them.
 D OCL^PSOORRL(DFN,PXRMDOB,"")
 S IND=0
 F  S IND=$O(^TMP("PS",$J,IND)) Q:+IND=0  D
 . S TEMP=^TMP("PS",$J,IND,0)
 . S ORDER=$P(TEMP,U,1)
 . I $L(ORDER)=0 Q
 . S DRUG=$P(TEMP,U,2)
 . S STATUS=$P(TEMP,U,9)
 .;Look for DRUG file entries, if not there then probably pharmacy
 .;orderable item.
 . I $L(DRUG)=0 S DRUGIEN=0
 . E  S DRUGIEN=+$O(^PSDRUG("B",DRUG,""))
 . I DRUGIEN>0 D
 .. I ORDER["O" D
 ... S RDATE=+$P(TEMP,U,16)
 ... S DSUP=+$P(TEMP,U,17)
 ... S DATE=+$$FMADD^XLFDT(RDATE,DSUP)
 ... S ^XTMP(PXRMDFN,"PSDRUG",DRUG,DATE)=ORDER_U_STATUS_U_RDATE_U_DSUP
 .. I ORDER["I" D
 ... S SDATE=+$P(TEMP,U,4)
 ... I SDATE=0 D SDERR(ORDER)  Q
 ... S ^XTMP(PXRMDFN,"PSDRUG",DRUG,SDATE)=ORDER_U_STATUS_SDATE
 . E  S POI(ORDER)=""
 K ^TMP("PS",$J)
 ;Process the pharmacy orderable item list.
 S ORDER=""
 F  S ORDER=$O(POI(ORDER)) Q:ORDER=""  D
 . D OEL^PSOORRL(DFN,ORDER)
 . I '$D(^TMP("PS",$J,"DD")) K ^TMP("PS",$J) Q
 . S TEMP=^TMP("PS",$J,0)
 . S SDATE=+$P(TEMP,U,3)
 . I SDATE=0 D SDERR(ORDER)  Q
 . S STATUS=$P(TEMP,U,6)
 . F IND=+$G(^TMP("PS",$J,"DD",0)) Q:+IND=0  D
 ..;Get the dispense drug.
 .. S DRUGIEN=+$P(^TMP("PS",$J,"DD",IND,0),U,1)
 .. ;I (DRUGIEN=0) D  Q
 .. I (DRUGIEN=0)!('$D(^PSDRUG(DRUGIEN))#10) D  Q  ;IHS/OKCAO/POC
 ... I ($P(ORDER,";",1)'["P")!($P(ORDER,";",2)'="I") D
 .... N XMSUB
 .... K ^TMP("PXRMXMZ",$J)
 .... S XMSUB="CLINICAL REMINDER DATA PROBLEM, INPATIENT MEDICATION"
 .... S ^TMP("PXRMXMZ",$J,1,0)="Warning - Pharmacy order "_ORDER_", for patient DFN= "_DFN_","
 .... S ^TMP("PXRMXMZ",$J,2,0)="is missing the dispense drug."
 .... S OITEM=+$P(^TMP("PS",$J,"DD",IND,0),U,4)
 .... I OITEM>0 S OITEM=$P(^ORD(101.43,OITEM,0),U,1)
 .... E  S OITEM="Missing"
 .... S ^TMP("PXRMXMZ",$J,3,0)="Orderable item: "_OITEM
 .... S ^TMP("PXRMXMZ",$J,4,0)="This indicates a possible data problem."
 .... D SEND^PXRMMSG(XMSUB)
 .. S DRUG=$P(^PSDRUG(DRUGIEN,0),U,1)
 .. S ^XTMP(PXRMDFN,"PSDRUG",DRUG,SDATE)=ORDER_U_STATUS_U_SDATE
 . K ^TMP("PS",$J)
 ;===============================================================
 ;IHS/CIA/MGH Check orders against the list in the V Med File to capture
 ;any meds stored there but not in pharmacy files
 D VMEDS^BPXRMDRG(DFN)
 ;===============================================================
 K ^TMP("PS",$J)
 Q
 ;
 ;=======================================================================
EVALFI(DFN,FIEVAL) ;Evaluate drug (file #50) findings.
 N DRUGIEN,FIND0,FIND3,FINDING
 S DRUGIEN=""
 F  S DRUGIEN=$O(^PXD(811.9,PXRMITEM,20,"E","PSDRUG(",DRUGIEN)) Q:+DRUGIEN=0  D
 . S FINDING=""
 . F  S FINDING=$O(^PXD(811.9,PXRMITEM,20,"E","PSDRUG(",DRUGIEN,FINDING)) Q:+FINDING=0  D
 .. S FIND0=^PXD(811.9,PXRMITEM,20,FINDING,0)
 .. S FIND3=$G(^PXD(811.9,PXRMITEM,20,FINDING,3))
 .. D FIEVAL(DFN,DRUGIEN,FIND0,FIND3,"","",FINDING,.FIEVAL)
 Q
 ;
 ;=======================================================================
EVALTERM(DFN,FINDING,TERMIEN,TFIEVAL) ;Evaluate drug (file #50) terms.
 N DRUGIEN,FIND0,FIND3,TFIND0,TFIND3,TFINDING
 S FIND0=^PXD(811.9,PXRMITEM,20,FINDING,0)
 S FIND3=$G(^PXD(811.9,PXRMITEM,20,FINDING,3))
 S DRUGIEN=""
 F  S DRUGIEN=$O(^PXRMD(811.5,TERMIEN,20,"E","PSDRUG(",DRUGIEN)) Q:+DRUGIEN=0  D
 . S TFINDING=""
 . F  S TFINDING=$O(^PXRMD(811.5,TERMIEN,20,"E","PSDRUG(",DRUGIEN,TFINDING)) Q:+TFINDING=0  D
 .. S TFIND0=^PXRMD(811.5,TERMIEN,20,TFINDING,0)
 .. S TFIND3=$G(^PXRMD(811.5,TERMIEN,20,TFINDING,3))
 .. D FIEVAL(DFN,DRUGIEN,FIND0,FIND3,TFIND0,TFIND3,TFINDING,.TFIEVAL)
 Q
 ;
 ;=======================================================================
FIEVAL(DFN,DRUGIEN,FIND0,FIND3,TFIND0,TFIND3,FINDING,FIEVAL) ;
 N CONVAL,DRUG,DSUP,LDATE,RDATE,RXTYPE,SDATE,STATUS,VALID
 S RXTYPE=$P(TFIND0,U,13)
 I RXTYPE="" S RXTYPE=$P(FIND0,U,13)
 I RXTYPE="B" S RXTYPE=""
 S DRUG=$P(^PSDRUG(DRUGIEN,0),U,1)
 D LDATE(DFN,DRUG,RXTYPE,.DSUP,.LDATE,.RDATE,.SDATE,.STATUS)
 ;If the last date is 0 then there is no release or stop date and the
 ;finding is false.
 I +LDATE=0 S FIEVAL(FINDING)=0 Q
 ;Save the rest of the finding information.
 S FIEVAL(FINDING)=1
 S FIEVAL(FINDING,"DATE")=LDATE
 S FIEVAL(FINDING,"DRUG")=DRUG
 I DSUP>0 S FIEVAL(FINDING,"DSUP")=DSUP
 I RDATE>0 S FIEVAL(FINDING,"RDATE")=RDATE
 I SDATE>0 S FIEVAL(FINDING,"SDATE")=SDATE
 S FIEVAL(FINDING,"STATUS")=STATUS
 S FIEVAL(FINDING,"FINDING")=DRUGIEN_";PSDRUG("
 ;If this is being called as part of a term evaluation we are done.
 I TFIND0'="" Q
 ;Determine if the finding has expired.
 S VALID=$$VALID^PXRMDATE(FIND0,TFIND0,LDATE)
 I 'VALID D
 . S FIEVAL(FINDING)=0
 . S FIEVAL(FINDING,"EXPIRED")=""
 ;If there is a condition for this finding evaluate it.
 S CONVAL=$$COND^PXRMUTIL(FIND3,TFIND3,"")
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
LDATE(DFN,DRUG,RXTYPE,DSUP,LDATE,RDATE,SDATE,STATUS) ;Return last date
 ;patient is on drug, refill date, days supply, or stop date, and status.
 N DATE,ORDER,TEMP,AUTO,ARX,AREF,ADSP
 I '$D(^XTMP(PXRMDFN,"PSDRUG")) D BLDCACHE(DFN)
 I '$D(^XTMP(PXRMDFN,"PSDRUG",DRUG))="" S FIEVAL(FINDING)=0 Q 0
 S (DSUP,RDATE,SDATE)=0
 S LDATE=+$O(^XTMP(PXRMDFN,"PSDRUG",DRUG,""),-1)
 I LDATE=0 Q
 S TEMP=^XTMP(PXRMDFN,"PSDRUG",DRUG,LDATE)
 S ORDER=$P(TEMP,U,1)
 ;Make sure the Rx Type is in the order. Null RXTYPE is contained in
 ;both I and O orders.
 ;IHS/MSC/MGH changes made for eprescribing
 I ORDER[RXTYPE S STATUS=$P(TEMP,U,2)
 E  S LDATE=0  Q
 S DATE=$P(TEMP,U,3)
 I ORDER["O" D
 . S RDATE=DATE
 . S DSUP=$P(TEMP,U,4)
 . I DATE=0 D
 ..S ARX=+$P(TEMP,U,1)
 ..S AUTO=$P($G(^PSRX(ARX,999999921)),U,3)
 ..I AUTO=1 S (RDATE,LDATE)=$P($G(^PSRX(ARX,2)),U,2)
 ..S AREF=$P($G(^PSRX(ARX,0)),U,9),ADSP=$P($G(^PSRX(ARX,0)),U,8)
 ..S DSUP=ADSP+(ADSP*AREF)
 E  S SDATE=DATE
 Q
 ;
 ;=======================================================================
OUTPUT(NLINES,TEXT,FINDING,FIEVAL) ;Produce the clinical
 ;maintenance output.
 N DATE,DRUG,TEMP
 S DATE=FIEVAL(FINDING,"DATE")
 S TEMP=$$EDATE^PXRMDATE(DATE)
 S TEMP=TEMP_" Drug: "
 S DRUG=FIEVAL(FINDING,"DRUG")
 S TEMP=TEMP_DRUG
 ;If the finding has expired add "EXPIRED"
 I $D(FIEVAL(FINDING,"EXPIRED")) S TEMP=TEMP_" - EXPIRED"
 S NLINES=NLINES+1
 S TEXT(NLINES)=TEMP
 S TEMP="Status: "_FIEVAL(FINDING,"STATUS")
 I $D(FIEVAL(FINDING,"RDATE")) S TEMP=TEMP_" Last release date: "_$$EDATE^PXRMDATE(FIEVAL(FINDING,"RDATE"))
 I $D(FIEVAL(FINDING,"DSUP")) S TEMP=TEMP_" Days supply: "_FIEVAL(FINDING,"DSUP")
 I $D(FIEVAL(FINDING,"SDATE")) S TEMP=TEMP_" Stop date: "_$$EDATE^PXRMDATE(FIEVAL(FINDING,"SDATE"))
 S NLINES=NLINES+1
 S TEXT(NLINES)=TEMP
 I $D(PXRMDEV) D
 . N UID
 . S UID="DRUG "_DRUG
 . S ^TMP(PXRMPID,$J,PXRMITEM,UID)=TEMP
 Q
 ;
 ;=======================================================================
SDERR(ORDER) ;If the Stop Date is missing and the order is not pending
 ;send an error message.
 I ($P(ORDER,";",1)["P") Q
 N XMSUB
 K ^TMP("PXRMXMZ",$J)
 S XMSUB="CLINICAL REMINDER DATA PROBLEM, INPATIENT MEDICATION"
 S ^TMP("PXRMXMZ",$J,1,0)="Warning - Pharmacy order "_ORDER_", for patient DFN= "_DFN_","
 S ^TMP("PXRMXMZ",$J,2,0)="is missing the stop date."
 S ^TMP("PXRMXMZ",$J,3,0)="This indicates a possible data problem."
 D SEND^PXRMMSG(XMSUB)
 Q
 ;
