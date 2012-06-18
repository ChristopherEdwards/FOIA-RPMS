PXRMDGPT ; SLC/PKR - Code to handle DGPT (Patient Treatment File) data. ;10/03/2000
 ;;1.5;CLINICAL REMINDERS;**2**;Jun 19, 2000
 ;
 ;=======================================================================
ADDICD9(IEN,D070,DATE,INVDATE) ;Get ICD9 codes from D070=DGPT(D0,70).
 N DATA,ICD9P
 S DATA=IEN_U_U_DATE
 S ICD9P=$P(D070,U,10) I ICD9P'="" S ^TMP($J,"DGPTICD9",ICD9P,INVDATE)=DATA_U_ICD9P_U_"DXLS"
 S ICD9P=$P(D070,U,11) I ICD9P'="" S ^TMP($J,"DGPTICD9",ICD9P,INVDATE)=DATA_U_ICD9P_U_"P"
 S ICD9P=$P(D070,U,16) I ICD9P'="" S ^TMP($J,"DGPTICD9",ICD9P,INVDATE)=DATA_U_ICD9P
 S ICD9P=$P(D070,U,17) I ICD9P'="" S ^TMP($J,"DGPTICD9",ICD9P,INVDATE)=DATA_U_ICD9P
 S ICD9P=$P(D070,U,18) I ICD9P'="" S ^TMP($J,"DGPTICD9",ICD9P,INVDATE)=DATA_U_ICD9P
 S ICD9P=$P(D070,U,19) I ICD9P'="" S ^TMP($J,"DGPTICD9",ICD9P,INVDATE)=DATA_U_ICD9P
 S ICD9P=$P(D070,U,20) I ICD9P'="" S ^TMP($J,"DGPTICD9",ICD9P,INVDATE)=DATA_U_ICD9P
 S ICD9P=$P(D070,U,21) I ICD9P'="" S ^TMP($J,"DGPTICD9",ICD9P,INVDATE)=DATA_U_ICD9P
 S ICD9P=$P(D070,U,22) I ICD9P'="" S ^TMP($J,"DGPTICD9",ICD9P,INVDATE)=DATA_U_ICD9P
 S ICD9P=$P(D070,U,23) I ICD9P'="" S ^TMP($J,"DGPTICD9",ICD9P,INVDATE)=DATA_U_ICD9P
 S ICD9P=$P(D070,U,24) I ICD9P'="" S ^TMP($J,"DGPTICD9",ICD9P,INVDATE)=DATA_U_ICD9P
 Q
 ;
 ;=======================================================================
BLDPC0(DFN) ;Check and if necessary build the PTF ICD0 patient cache.
 N DATE,ICD0P,IEN,INVDATE,NPATIEN,PIEN,SIEN
 I '$D(^XTMP(PXRMDFN,"DGPTICD0","NPATIEN")) D
 . K ^TMP($J,"DGPTICD0"),^XTMP(PXRMDFN,"DGPTICD0")
 .;In DGPTICD0 we store the ICD0 ien in the first piece, the DGPT ien
 .;it came from in the second piece, and the date in the third piece.
 . S IEN=""
 . F  S IEN=$O(^DGPT("B",DFN,IEN)) Q:IEN=""  D
 .. S ICD0P=""
 .. F  S ICD0P=$O(^DGPT(IEN,"S","AO",ICD0P)) Q:ICD0P=""  D
 ... S SIEN=$O(^DGPT(IEN,"S","AO",ICD0P,""))
 ... S DATE=$P($G(^DGPT(IEN,"S",SIEN,0)),U,1)
 ... S INVDATE=$$INVFFMDL^PXRMDATE(DATE,1)
 ... S ^TMP($J,"DGPTICD0",ICD0P,INVDATE)=IEN_U_U_DATE_U_ICD0P
 ..;
 ..;This cross-ref gets the second set of ICD0 operation/procedure codes.
 .. S ICD0P=""
 .. F  S ICD0P=$O(^DGPT(IEN,"AP",ICD0P)) Q:ICD0P=""  D
 ... S DATE=$P(^DGPT(IEN,0),U,2)
 ... S INVDATE=$$INVFFMDL^PXRMDATE(DATE,1)
 ... S ^TMP($J,"DGPTICD0",ICD0P,INVDATE)=IEN_U_U_DATE_U_ICD0P
 ..;
 ..;This cross-ref gets the third set of ICD0 operation/procedure codes.
 .. S ICD0P=""
 .. F  S ICD0P=$O(^DGPT(IEN,"P","AP6",ICD0P)) Q:ICD0P=""  D
 ... S PIEN=$O(^DGPT(IEN,"P","AP6",ICD0P,""))
 ... S DATE=$P($G(^DGPT(IEN,"P",PIEN,0)),U,1)
 ... S INVDATE=$$INVFFMDL^PXRMDATE(DATE,1)
 ... S ^TMP($J,"DGPTICD0",ICD0P,INVDATE)=IEN_U_U_DATE_U_ICD0P
 .;
 .;Build the list of most recent entries.
 . S NPATIEN=0
 . S ICD0P=""
 . F  S ICD0P=$O(^TMP($J,"DGPTICD0",ICD0P)) Q:ICD0P=""  D
 .. S NPATIEN=NPATIEN+1
 .. S INVDATE=$O(^TMP($J,"DGPTICD0",ICD0P,""))
 .. S ^XTMP(PXRMDFN,"DGPTICD0",ICD0P,INVDATE)=^TMP($J,"DGPTICD0",ICD0P,INVDATE)
 . S ^XTMP(PXRMDFN,"DGPTICD0","NPATIEN")=NPATIEN
 . K ^TMP($J,"DGPTICD0")
 E  S NPATIEN=^XTMP(PXRMDFN,"DGPTICD0","NPATIEN")
 Q NPATIEN
 ;
 ;=======================================================================
BLDPC9(DFN) ;Check and if necessary build the PTF ICD9 patient cache.
 N D070,DATE,ICD9P,IEN,INVDATE,NPATIEN
 I '$D(^XTMP(PXRMDFN,"DGPTICD9","NPATIEN")) D
 . K ^TMP($J,"DGPTICD9"),^XTMP(PXRMDFN,"DGPTICD9")
 . S IEN=""
 . F  S IEN=$O(^DGPT("B",DFN,IEN)) Q:IEN=""  D
 .. S D070=$G(^DGPT(IEN,70))
 .. S DATE=$P($G(^DGPT(IEN,70)),U,1)
 ..;If there is no discharge date then use the admission date.
 .. I $L(DATE)=0 S DATE=$P($G(^DGPT(IEN,0)),U,2)
 .. S INVDATE=$$INVFFMDL^PXRMDATE(DATE,1)
 .. D ADDICD9(IEN,D070,DATE,INVDATE)
 .;
 .;Build the list of most recent entries.
 . S NPATIEN=0
 . S ICD9P=""
 . F  S ICD9P=$O(^TMP($J,"DGPTICD9",ICD9P)) Q:ICD9P=""  D
 .. S NPATIEN=NPATIEN+1
 .. S INVDATE=$O(^TMP($J,"DGPTICD9",ICD9P,""))
 .. S ^XTMP(PXRMDFN,"DGPTICD9",ICD9P,INVDATE)=^TMP($J,"DGPTICD9",ICD9P,INVDATE)
 . S ^XTMP(PXRMDFN,"DGPTICD9","NPATIEN")=NPATIEN
 . K ^TMP($J,"DGPTICD9")
 E  S NPATIEN=^XTMP(PXRMDFN,"DGPTICD9","NPATIEN")
 Q NPATIEN
 ;
 ;=======================================================================
EVALICD0(DFN,TAXIEN,FLIST) ;Match patient PTF ICD0 entries.
 N FIRST,ICD0P,INVDATE,LAST,NPATIEN,TLIST
 ;
 S NPATIEN=$$BLDPC0(DFN)
 I NPATIEN=0 Q
 ;Lock the expanded taxonomy cache.
 I '$$LOCKXTL^PXRMBXTL(TAXIEN) Q
 ;Get the first and last entry in the patient cache, use this for the
 ;match limits.
 S FIRST=$O(^XTMP(PXRMDFN,"DGPTICD0",""))
 S LAST=$O(^XTMP(PXRMDFN,"DGPTICD0","NPATIEN"),-1)
 S ICD0P=FIRST-1
 F  S ICD0P=$O(^PXD(811.3,TAXIEN,80.1,"ICD0P",ICD0P)) Q:(ICD0P>LAST)!(ICD0P="")  D
 . S INVDATE=+$O(^XTMP(PXRMDFN,"DGPTICD0",ICD0P,""))
 . I INVDATE>0 D
 .. S TLIST(INVDATE)=$G(^XTMP(PXRMDFN,"DGPTICD0",ICD0P,INVDATE))
 D ULOCKXTL^PXRMBXTL(TAXIEN)
 ;Return the most recent entry only.
 S INVDATE=$O(TLIST(""))
 ;If there are no entries we are done.
 I INVDATE="" Q
 S FLIST(INVDATE,"DGPTICD0")=TLIST(INVDATE)
 Q
 ;
 ;=======================================================================
EVALICD9(DFN,TAXIEN,FLIST) ;Match patient PTF ICD9 entries.
 N ANY,DXLS,FIRST,ICD9P,INVDATE,LAST,NPATIEN,PDS,PDST,PRIN,TEMP,TLIST
 ;
 S NPATIEN=$$BLDPC9(DFN)
 I NPATIEN=0 Q
 ;Lock the expanded taxonomy cache.
 I '$$LOCKXTL^PXRMBXTL(TAXIEN) Q
 ;See if we are looking for DXLS or principal only.
 S PDS=$P(^PXD(811.2,TAXIEN,0),U,4)
 I PDS["DXLS" S DXLS=1
 E  S DXLS=0
 I PDS["PR" S PRIN=1
 E  S PRIN=0
 I ('DXLS)&('PRIN) S ANY=1
 E  S ANY=0
 ;Get the first and last entry in the patient cache, use this for the
 ;match limits.
 S FIRST=$O(^XTMP(PXRMDFN,"DGPTICD9",""))
 S LAST=$O(^XTMP(PXRMDFN,"DGPTICD9","NPATIEN"),-1)
 S ICD9P=FIRST-1
 F  S ICD9P=$O(^PXD(811.3,TAXIEN,80,"ICD9P",ICD9P)) Q:(ICD9P>LAST)!(ICD9P="")  D
 . S INVDATE=+$O(^XTMP(PXRMDFN,"DGPTICD9",ICD9P,""))
 . I INVDATE>0 D
 .. S TEMP=^XTMP(PXRMDFN,"DGPTICD9",ICD9P,INVDATE)
 .. I ANY S TLIST(INVDATE)=TEMP
 .. E  D
 ... S PDST=$P(TEMP,U,5)
 ... I (DXLS),(PDST="DXLS") S TLIST(INVDATE)=TEMP
 ... I (PRIN),(PDST="P") S TLIST(INVDATE)=TEMP
 D ULOCKXTL^PXRMBXTL(TAXIEN)
 ;Return the most recent entry only.
 S INVDATE=$O(TLIST(""))
 ;If there are no entries we are done.
 I INVDATE="" Q
 S FLIST(INVDATE,"DGPTICD9")=TLIST(INVDATE)
 Q
 ;
 ;======================================================================
OUTICD0(NLINES,TEXT,FINDING,FIEVAL) ;Produce the clinical
 ;maintenance output.
 N D0,FIEN,ICD0ZN,PROC,TEMP,VDATE
 S FIEN=$P(FIEVAL(FINDING,"SOURCE"),";",1)
 S VDATE=FIEVAL(FINDING,"DATE")
 S TEMP=$$EDATE^PXRMDATE(VDATE)
 S TEMP=TEMP_" Hospitalization Procedure: "
 S D0=$P(FIEVAL(FINDING,"CODEP"),";",1)
 S ICD0ZN=$G(^ICD0(D0,0))
 S CODE=$P(ICD0ZN,U,1)
 S PROC=$P(ICD0ZN,U,4)
 S TEMP=TEMP_CODE_" "_PROC
 ;If the finding has expired add "EXPIRED"
 I $D(FIEVAL(FINDING,"EXPIRED")) S TEMP=TEMP_" - EXPIRED"
 S NLINES=NLINES+1
 S TEXT(NLINES)=TEMP
 I $D(PXRMDEV) D
 . N UID
 . S UID="ICD0DGPT "_CODE
 . S ^TMP(PXRMPID,$J,PXRMITEM,UID,"CODE")=CODE
 . S ^TMP(PXRMPID,$J,PXRMITEM,UID,"DATE")=VDATE
 . S ^TMP(PXRMPID,$J,PXRMITEM,UID,"PROC")=PROC
 Q
 ;
 ;======================================================================
OUTICD9(NLINES,TEXT,FINDING,FIEVAL) ;Produce the clinical
 ;maintenance output.
 N DIAG,FIEN,ICD9P,ICD9ZN,TEMP,VDATE
 S FIEN=$P(FIEVAL(FINDING,"SOURCE"),";",1)
 S VDATE=FIEVAL(FINDING,"DATE")
 S TEMP=$$EDATE^PXRMDATE(VDATE)
 S TEMP=TEMP_" Hospitalization Diagnosis: "
 S ICD9P=FIEVAL(FINDING,"CODEP")
 S ICD9ZN=$$GET0^PXRMICD9(ICD9P)
 S CODE=$P(ICD9ZN,U,1)
 S DIAG=$P(ICD9ZN,U,3)
 S TEMP=TEMP_CODE_" "_DIAG
 ;If the finding has expired add "EXPIRED"
 I $D(FIEVAL(FINDING,"EXPIRED")) S TEMP=TEMP_" - EXPIRED"
 S NLINES=NLINES+1
 S TEXT(NLINES)=TEMP
 I $D(PXRMDEV) D
 . N UID
 . S UID="ICD9DGPT "_CODE
 . S ^TMP(PXRMPID,$J,PXRMITEM,UID,"CODE")=CODE
 . S ^TMP(PXRMPID,$J,PXRMITEM,UID,"DATE")=VDATE
 . S ^TMP(PXRMPID,$J,PXRMITEM,UID,"DIAG")=DIAG
 Q
 ;
