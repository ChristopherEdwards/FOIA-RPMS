BPXRMPRC ; SLC/PKR - Code to handle VPRC ;07-May-2009 12:43;MGH
 ;;1.5;CLINICAL REMINDERS;**1004,1006**;Jun 19, 2000
 ;IHS/CIA/MGH Routine to search the V procedure file for ICD0 entries
 ;======================================================================
BLDPC(DFN) ;Check and if necessary build the V POV patient cache.
 N ICD0P,IEN,INVDATE,NPATIEN,PS,TEMP,VIEN,VDATE,VPRCIEN
 I '$D(^XTMP(PXRMDFN,"VPRC","NPATIEN")) D
 . K ^TMP($J,"VPRC"),^XTMP(PXRMDFN,"VPRC")
 . S INVDATE=""
 . F  S INVDATE=$O(^AUPNVPRC("AA",DFN,INVDATE)) Q:INVDATE=""  D
 .. S VPRCIEN=""
 .. F  S VPRCIEN=$O(^AUPNVPRC("AA",DFN,INVDATE,VPRCIEN)) Q:VPRCIEN=""  D
 ... S TEMP=$G(^AUPNVPRC(VPRCIEN,0))
 ... S ICD0P=$P(TEMP,U,1)
 ... S VIEN=$P(TEMP,U,3)
 ... S PS=$P(TEMP,U,12)
 ... S VDATE=$$VDATE^PXRMDATE(VIEN)
 ... S ^TMP($J,"VPRC",ICD0P,INVDATE)=VPRCIEN_U_VIEN_U_VDATE_U_ICD0P_U_PS
 .;Build the list of most recent entries.
 . S NPATIEN=0
 . S ICD0P=""
 . F  S ICD0P=$O(^TMP($J,"VPRC",ICD0P)) Q:ICD0P=""  D
 .. S NPATIEN=NPATIEN+1
 .. S INVDATE=$O(^TMP($J,"VPRC",ICD0P,""))
 .. S ^XTMP(PXRMDFN,"VPRC",ICD0P,INVDATE)=^TMP($J,"VPRC",ICD0P,INVDATE)
 . S ^XTMP(PXRMDFN,"VPRC","NPATIEN")=NPATIEN
 . K ^TMP($J,"VPRC")
 E  S NPATIEN=^XTMP(PXRMDFN,"VPRC","NPATIEN")
 Q NPATIEN
 ;
 ;======================================================================
EVAL(DFN,TAXIEN,FLIST) ; EP Evaluate V POV entries.
 N FIRST,ICD0P,INVDATE,LAST,NPATIEN,PDS,TEMP,TLIST
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
 S FIRST=$O(^XTMP(PXRMDFN,"VPRC",""))
 S LAST=$O(^XTMP(PXRMDFN,"VPRC","NPATIEN"),-1)
 S ICD0P=FIRST-1
 F  S ICD0P=$O(^PXD(811.3,TAXIEN,80.1,"ICD0P",ICD0P)) Q:(ICD0P>LAST)!(ICD0P="")  D
 . S INVDATE=+$O(^XTMP(PXRMDFN,"VPRC",ICD0P,""))
 . I INVDATE>0 D
 .. S TEMP=^XTMP(PXRMDFN,"VPRC",ICD0P,INVDATE)
 .. I (PDS="")!(PDS=$P(TEMP,U,5)) S TLIST(INVDATE)=TEMP
 D ULOCKXTL^PXRMBXTL(TAXIEN)
 ;Return the most recent entry only.
 S INVDATE=$O(TLIST(""))
 ;If there are no entries we are done.
 I INVDATE="" Q
 S FLIST(INVDATE,"AUPNVPRC")=TLIST(INVDATE)
 Q
 ;
 ;======================================================================
OUTPUT(NLINES,TEXT,FINDING,FIEVAL) ;Produce the clinical
 ;maintenance output. The VPRC information is:  DATE, ICD0 IEN,
 ;ICD0 CODE, MODIFIER, PROVIDER NARRATIVE.
 N CODE,D0,DIAG,FIEN,ICD0P,ICD0ZN,PN,TEMP,VDATE
 S FIEN=$P(FIEVAL(FINDING,"SOURCE"),";",1)
 S VDATE=FIEVAL(FINDING,"DATE")
 S TEMP=$$EDATE^PXRMDATE(VDATE)
 S TEMP=TEMP_" Encounter Procedure: "
 S ICD0P=FIEVAL(FINDING,"CODEP")
 S D0=$G(^AUPNVPRC(FIEN,0))
 S ICD0ZN=$$GET0^BPXRMIC0(ICD0P)
 S CODE=$P(ICD0ZN,U,1)
 S DIAG=$P(ICD0ZN,U,3)
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
 . S UID="ICD0VPRC "_CODE
 . S ^TMP(PXRMPID,$J,PXRMITEM,UID,"CODE")=CODE
 . S ^TMP(PXRMPID,$J,PXRMITEM,UID,"DATE")=VDATE
 . S ^TMP(PXRMPID,$J,PXRMITEM,UID,"DIAG")=DIAG
 . S ^TMP(PXRMPID,$J,PXRMITEM,UID,"PN")=PN
 ;
 ;For historical encounters display the location and comments.
 I VDATE["E" D
 . N INDEX,VIEN
 . S INDEX="ICD0VPRC-"_DIAG
 . S VIEN=FIEVAL(FINDING,"VIEN")
 . D HLCV^PXRMVSIT(.NLINES,.TEXT,VIEN,INDEX)
 Q
 ;
