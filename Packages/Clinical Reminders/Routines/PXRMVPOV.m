PXRMVPOV ; SLC/PKR - Code to handle VPOV ;07-Nov-2005 10:09;MGH
 ;;1.5;CLINICAL REMINDERS;**2,1004**;Jun 19, 2000
 ;IHS/CIA/MGH Modified to include codes without provider narratives
 ;======================================================================
BLDPC(DFN) ;Check and if necessary build the V POV patient cache.
 N ICD9P,IEN,INVDATE,NPATIEN,PS,TEMP,VIEN,VDATE,VPOVIEN
 I '$D(^XTMP(PXRMDFN,"VPOV","NPATIEN")) D
 . K ^TMP($J,"VPOV"),^XTMP(PXRMDFN,"VPOV")
 . S INVDATE=""
 . F  S INVDATE=$O(^AUPNVPOV("AA",DFN,INVDATE)) Q:INVDATE=""  D
 .. S VPOVIEN=""
 .. F  S VPOVIEN=$O(^AUPNVPOV("AA",DFN,INVDATE,VPOVIEN)) Q:VPOVIEN=""  D
 ... S TEMP=$G(^AUPNVPOV(VPOVIEN,0))
 ... S ICD9P=$P(TEMP,U,1)
 ... S VIEN=$P(TEMP,U,3)
 ... S PS=$P(TEMP,U,12)
 ... S VDATE=$$VDATE^PXRMDATE(VIEN)
 ... S ^TMP($J,"VPOV",ICD9P,INVDATE)=VPOVIEN_U_VIEN_U_VDATE_U_ICD9P_U_PS
 .;Build the list of most recent entries.
 . S NPATIEN=0
 . S ICD9P=""
 . F  S ICD9P=$O(^TMP($J,"VPOV",ICD9P)) Q:ICD9P=""  D
 .. S NPATIEN=NPATIEN+1
 .. S INVDATE=$O(^TMP($J,"VPOV",ICD9P,""))
 .. S ^XTMP(PXRMDFN,"VPOV",ICD9P,INVDATE)=^TMP($J,"VPOV",ICD9P,INVDATE)
 . S ^XTMP(PXRMDFN,"VPOV","NPATIEN")=NPATIEN
 . K ^TMP($J,"VPOV")
 E  S NPATIEN=^XTMP(PXRMDFN,"VPOV","NPATIEN")
 Q NPATIEN
 ;
 ;======================================================================
EVAL(DFN,TAXIEN,FLIST) ;Evaluate V POV entries.
 N FIRST,ICD9P,INVDATE,LAST,NPATIEN,PDS,TEMP,TLIST
 ;
 S NPATIEN=$$BLDPC(DFN)
 I NPATIEN=0 Q
 ;Lock the expanded taxonomy cache.
 I '$$LOCKXTL^PXRMBXTL(TAXIEN) Q
 ;See if we are looking for primary only. The code is "P" for primary.
 I $P(^PXD(811.2,TAXIEN,0),U,4)["ENPR" S PDS="P"
 E  S PDS=""
 ;Get the first and last entry in the patient cache, use this for the
 ;match limits.
 S FIRST=$O(^XTMP(PXRMDFN,"VPOV",""))
 S LAST=$O(^XTMP(PXRMDFN,"VPOV","NPATIEN"),-1)
 S ICD9P=FIRST-1
 F  S ICD9P=$O(^PXD(811.3,TAXIEN,80,"ICD9P",ICD9P)) Q:(ICD9P>LAST)!(ICD9P="")  D
 . S INVDATE=+$O(^XTMP(PXRMDFN,"VPOV",ICD9P,""))
 . I INVDATE>0 D
 .. S TEMP=^XTMP(PXRMDFN,"VPOV",ICD9P,INVDATE)
 .. I (PDS="")!(PDS=$P(TEMP,U,5)) S TLIST(INVDATE)=TEMP
 D ULOCKXTL^PXRMBXTL(TAXIEN)
 ;Return the most recent entry only.
 S INVDATE=$O(TLIST(""))
 ;If there are no entries we are done.
 I INVDATE="" Q
 S FLIST(INVDATE,"AUPNVPOV")=TLIST(INVDATE)
 Q
 ;
 ;======================================================================
OUTPUT(NLINES,TEXT,FINDING,FIEVAL) ;Produce the clinical
 ;maintenance output. The VPOV information is:  DATE, ICD9 IEN,
 ;ICD9 CODE, MODIFIER, PROVIDER NARRATIVE.
 N CODE,D0,DIAG,FIEN,ICD9P,ICD9ZN,PN,TEMP,VDATE
 S FIEN=$P(FIEVAL(FINDING,"SOURCE"),";",1)
 S VDATE=FIEVAL(FINDING,"DATE")
 S TEMP=$$EDATE^PXRMDATE(VDATE)
 S TEMP=TEMP_" Encounter Diagnosis: "
 S ICD9P=FIEVAL(FINDING,"CODEP")
 S D0=$G(^AUPNVPOV(FIEN,0))
 S ICD9ZN=$$GET0^PXRMICD9(ICD9P)
 S CODE=$P(ICD9ZN,U,1)
 S DIAG=$P(ICD9ZN,U,3)
 S TEMP=TEMP_CODE_" "_DIAG
 ;If the finding has expired add "EXPIRED"
 I $D(FIEVAL(FINDING,"EXPIRED")) S TEMP=TEMP_" - EXPIRED"
 S NLINES=NLINES+1
 S TEXT(NLINES)=TEMP
 S PN=$P(D0,U,4)
 ;IHS/CIA/MGH -11/8/05 PATCH 1004
 ;Edited to allow for cases that do NOT have a provider narrative
 I PN'="" D
 .S PN=$P(^AUTNPOV(PN,0),U,1)
 .I ($L(PN)>0)&(PN'=DIAG) D
 .. S NLINES=NLINES+1
 .. S TEXT(NLINES)="  Prov. Narr. - "_PN
 I $D(PXRMDEV) D
 . N UID
 . S UID="ICD9VPOV "_CODE
 . S ^TMP(PXRMPID,$J,PXRMITEM,UID,"CODE")=CODE
 . S ^TMP(PXRMPID,$J,PXRMITEM,UID,"DATE")=VDATE
 . S ^TMP(PXRMPID,$J,PXRMITEM,UID,"DIAG")=DIAG
 . S ^TMP(PXRMPID,$J,PXRMITEM,UID,"PN")=PN
 ;
 ;For historical encounters display the location and comments.
 I VDATE["E" D
 . N INDEX,VIEN
 . S INDEX="ICD9VPOV-"_DIAG
 . S VIEN=FIEVAL(FINDING,"VIEN")
 . D HLCV^PXRMVSIT(.NLINES,.TEXT,VIEN,INDEX)
 Q
 ;
