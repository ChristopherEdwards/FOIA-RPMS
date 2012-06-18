PXRMPROB ; SLC/PKR - Code to treat items from the Problem List. ;24-Sep-2009 16:14;MGH
 ;;1.5;CLINICAL REMINDERS;**2,1005,1006,1007**;Jun 19, 2000
 ;
 ;Patch 1005 fixed issue with empty conditions
 ;Patch 1006 fixed issue with empty date
 ;=======================================================================
BLDPC(DFN) ;Check and if necessary build the Problem List patient cache.
 N DATE,ICD9P,INVDATE,INVDT,NPATIEN,PROBIEN,TEMP
 N GMPLCOND,GMPLDLM,GMPLICD,GMPLLEX,GMPLODAT,GMPLPNAM,GMPLPRIO,GMPLPRV
 N GMPLSTAT,GMPLTXT,GMPLXDAT
 ;If the patient's problem list was modified since the cache was
 ;last built the cache will have been killed in PXRMPINF.
 I '$D(^XTMP(PXRMDFN,"PROB","NPATIEN")) D
 . K ^XTMP(PXRMDFN,"PROB")
 . S INVDT=$$INVFFMDL^PXRMDATE(DT,1)
 . S PROBIEN=""
 . F  S PROBIEN=$O(^AUPNPROB("AC",DFN,PROBIEN)) Q:PROBIEN=""  D
 .. D CALL2^GMPLUTL3(PROBIEN)
 .. ;IHS/MSC/MGH Line changed for IHS problems
 .. ;I (GMPLCOND="H")!(GMPLCOND="") Q
 .. I GMPLCOND="H" Q
 .. S INVDATE=$$INVFFMDL^PXRMDATE(GMPLDLM,1)
 .. ;IHS/MSC/MGH 1006 If no inverse date,quit
 .. I INVDATE="" Q
 ..;If the problem is chronic use today's date instead of the
 ..;date last modified.
 ..;IHS/MSC/MGH Patch 1007 Changed because IHS does not use chronic field
 ..;I GMPLPRIO="C" D
 ..S DATE=DT
 ..S INVDATE=INVDT
 .. ;E  S DATE=GMPLDLM
 .. S ^TMP($J,"PROB",GMPLICD,INVDATE)=PROBIEN_U_U_DATE_U_GMPLICD_U_GMPLSTAT_U_GMPLPRIO
 .;
 .;Build the list of most recent entries.
 . S NPATIEN=0
 . S ICD9P=""
 . F  S ICD9P=$O(^TMP($J,"PROB",ICD9P)) Q:ICD9P=""  D
 .. S INVDATE=$O(^TMP($J,"PROB",ICD9P,""))
 .. S NPATIEN=NPATIEN+1
 .. S TEMP=^TMP($J,"PROB",ICD9P,INVDATE)
 .. S ^XTMP(PXRMDFN,"PROB",ICD9P,INVDATE)=TEMP
 . S ^XTMP(PXRMDFN,"PROB","NPATIEN")=NPATIEN
 . K ^TMP($J,"PROB")
 E  S NPATIEN=^XTMP(PXRMDFN,"PROB","NPATIEN")
 Q NPATIEN
 ;
 ;=======================================================================
EVAL(DFN,FIND0,TFIND0,TAXIEN,FLIST) ;Evaluate Problem List entries.
 N FIRST,ICD9P,INVDATE,LAST,NPATIEN,TAX0,TLIST,USEINP
 S NPATIEN=$$BLDPC(DFN)
 I NPATIEN=0 Q
 ;Lock the expanded taxonomy cache.
 I '$$LOCKXTL^PXRMBXTL(TAXIEN) Q
 ;Get the first and last entry in the patient cache, use this for the
 ;match limits.
 S FIRST=$O(^XTMP(PXRMDFN,"PROB",""))
 S LAST=$O(^XTMP(PXRMDFN,"PROB","NPATIEN"),-1)
 S ICD9P=FIRST-1
 F  S ICD9P=$O(^PXD(811.3,TAXIEN,80,"ICD9P",ICD9P)) Q:(ICD9P>LAST)!(ICD9P="")  D
 . S INVDATE=+$O(^XTMP(PXRMDFN,"PROB",ICD9P,""))
 . I INVDATE>0 D
 .. S TLIST(INVDATE)=$G(^XTMP(PXRMDFN,"PROB",ICD9P,INVDATE))
 D ULOCKXTL^PXRMBXTL(TAXIEN)
 S INVDATE=$O(TLIST(""))
 ;If there are no entries we are done.
 I INVDATE="" Q
 S TAX0=^PXD(811.2,TAXIEN,0)
 S USEINP=$P(TAX0,U,9)
 I USEINP="" S USEINP=$P(TFIND0,U,9)
 I USEINP="" S USEINP=$P(FIND0,U,9)
 ;If Use Inactive Problems is true return the most recent entry no
 ;matter what the status. If it is false return the most recent
 ;active entry.
 I 'USEINP D
 . N DONE,STATUS
 . S DONE=0
 . S INVDATE=""
 . F  S INVDATE=$O(TLIST(INVDATE)) Q:(DONE)!(INVDATE="")  D
 .. S STATUS=$P(TLIST(INVDATE),U,5)
 .. I STATUS="A" D
 ... S FLIST(INVDATE,"AUPNPROB")=TLIST(INVDATE)
 ... S DONE=1
 E  S FLIST(INVDATE,"AUPNPROB")=TLIST(INVDATE)
 Q
 ;
 ;======================================================================
OUTPUT(NLINES,TEXT,FINDING,FIEVAL) ;Produce the clinical
 ;maintenance output. The Problem List information is:  DATE, ICD9 IEN,
 ;ICD9 CODE, PROVIDER NARRATIVE.
 N EM,D0,DIAG,FIEN,ICD9P,ICD9ZN,PN,PRIORITY,TEMP,VDATE,CODE
 S FIEN=$P(FIEVAL(FINDING,"SOURCE"),";",1)
 S VDATE=FIEVAL(FINDING,"DATE")
 S TEMP=$$EDATE^PXRMDATE(VDATE)
 S TEMP=TEMP_" Problem Diagnosis: "
 S D0=$G(^AUPNPROB(FIEN,0))
 S ICD9P=FIEVAL(FINDING,"CODEP")
 S ICD9ZN=$$GET0^PXRMICD9(ICD9P)
 S CODE=$P(ICD9ZN,U,1)
 S DIAG=$P(ICD9ZN,U,3)
 S TEMP=TEMP_CODE_" "_DIAG
 S PRIORITY=$G(FIEVAL(FINDING,"PRIORITY"))
 I $L(PRIORITY)>0 D
 . S TEMP=TEMP_" Priority-"_$$EXTERNAL^DILFD(9000011,1.14,"",PRIORITY,.EM)
 ;If the finding has expired add "EXPIRED"
 I $D(FIEVAL(FINDING,"EXPIRED")) S TEMP=TEMP_" - EXPIRED"
 ;If the Problem is inactive add "INACTIVE PROBLEM"
 I $D(FIEVAL(FINDING,"INACTIVE")) S TEMP=TEMP_" - INACTIVE PROBLEM"
 S NLINES=NLINES+1
 S TEXT(NLINES)=TEMP
 S PN=$P(D0,U,5)
 S PN=$P(^AUTNPOV(PN,0),U,1)
 I ($L(PN)>0)&(PN'=DIAG) D
 . S NLINES=NLINES+1
 . S TEXT(NLINES)="Prov. Narr. - "_PN
 I $D(PXRMDEV) D
 . N UID
 . S UID="ICD9PROB "_CODE
 . S ^TMP(PXRMPID,$J,PXRMITEM,UID,"CODE")=CODE
 . S ^TMP(PXRMPID,$J,PXRMITEM,UID,"DATE")=VDATE
 . S ^TMP(PXRMPID,$J,PXRMITEM,UID,"DIAG")=DIAG
 . S ^TMP(PXRMPID,$J,PXRMITEM,UID,"PN")=PN
 Q
 ;
