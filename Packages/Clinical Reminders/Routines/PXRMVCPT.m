PXRMVCPT ; SLC/PKR - Code to handle VCPT data. ;26-Sep-2006 13:44;MGH
 ;;1.5;CLINICAL REMINDERS;**2,1001,1004**;Jun 19, 2000
 ;IHS/CIA/MGH - 8/12/04 PATCH 1001
 ;1004 added for backward compatibility
 ;=======================================================================
 ;Modified by CIA Informatics to handle CPT cases without a provider
 ;narrative
 ;======================================================================
EVAL(DFN,TAXIEN,FLIST) ;Evaluate V CPT entries.
 N FIRST,ICPTP,INVDATE,LAST,TLIST,VCPTIEN,VDATE,VIEN
 I '$D(^AUPNVCPT("AA",DFN)) Q
 ;Lock the expanded taxonomy cache.
 I '$$LOCKXTL^PXRMBXTL(TAXIEN) Q
 ;Get the first and last entry in the patient cache, use this for the
 ;match limits.
 S FIRST=$O(^AUPNVCPT("AA",DFN,""))
 S LAST=$O(^AUPNVCPT("AA",DFN,""),-1)
 S ICPTP=FIRST-1
 F  S ICPTP=$O(^PXD(811.3,TAXIEN,81,"ICPTP",ICPTP)) Q:(ICPTP>LAST)!(ICPTP="")  D
 . S INVDATE=+$O(^AUPNVCPT("AA",DFN,ICPTP,""))
 . I INVDATE>0 D
 .. S VCPTIEN=$O(^AUPNVCPT("AA",DFN,ICPTP,INVDATE,""))
 .. S VIEN=$P(^AUPNVCPT(VCPTIEN,0),U,3)
 .. S VDATE=$$VDATE^PXRMDATE(VIEN)
 .. S TLIST(INVDATE)=VCPTIEN_U_VIEN_U_VDATE_U_ICPTP
 D ULOCKXTL^PXRMBXTL(TAXIEN)
 ;Return the most recent entry only.
 S INVDATE=$O(TLIST(""))
 ;If there are no entries we are done.
 I INVDATE="" Q
 S FLIST(INVDATE,"AUPNVCPT")=TLIST(INVDATE)
 Q
 ;
 ;======================================================================
OUTPUT(NLINES,TEXT,FINDING,FIEVAL) ;Produce the clinical
 ;maintenance output. The VCPT information is:  DATE, ICPT CODE,
 ;SHORT NAME, PROVIDER NARRATIVE.
 N CODE,CPT,CPTDATA,D0,ICPTP,FIEN,PN,SNAME,TEMP,VDATE
 S FIEN=$P(FIEVAL(FINDING,"SOURCE"),";",1)
 S VDATE=FIEVAL(FINDING,"DATE")
 S TEMP=$$EDATE^PXRMDATE(VDATE)
 S TEMP=TEMP_" Encounter Procedure: "
 S D0=$G(^AUPNVCPT(FIEN,0))
 S ICPTP=FIEVAL(FINDING,"CODEP")
 S CPTDATA=$$CPT^ICPTCOD(ICPTP)
 S CODE=$P(CPTDATA,U,2)
 S SNAME=$P(CPTDATA,U,3)
 S TEMP=TEMP_CODE
 S TEMP=TEMP_"-"_SNAME
 ;If the finding has expired add "EXPIRED"
 I $D(FIEVAL(FINDING,"EXPIRED")) S TEMP=TEMP_" - EXPIRED"
 S NLINES=NLINES+1
 S TEXT(NLINES)=TEMP
 S PN=$P(D0,U,4)
 ;
 ;IHS/CIA/MGH - 8/12/04 PATCH 1001
 ;Edited by CIA Informatics, for cases that do not have a provider narrative
 ;S PN=$P(^AUTNPOV(PN,0),U,1)
 ;I ($L(PN)>0)&(PN'=SNAME) D
 ;. S NLINES=NLINES+1
 ;. S TEXT(NLINES)="  Prov. Narr. - "_PN	
 I PN'="" D
 .S PN=$P(^AUTNPOV(PN,0),U,1)
 .I ($L(PN)>0)&(PN'=SNAME) D
 .. S NLINES=NLINES+1
 .. S TEXT(NLINES)="  Prov. Narr. - "_PN
 ;End of PATCH 1001 changes
 ;
 I $D(PXRMDEV) D
 . N UID
 . S UID="CPTVCPT "_ICPTP
 . S ^TMP(PXRMPID,$J,PXRMITEM,UID,"DATE")=VDATE
 . S ^TMP(PXRMPID,$J,PXRMITEM,UID,"CODE")=CODE
 . S ^TMP(PXRMPID,$J,PXRMITEM,UID,"PN")=PN
 . S ^TMP(PXRMPID,$J,PXRMITEM,UID,"SNAME")=SNAME
 ;
 ;For historical encounters display the location and comments.
 I VDATE["E" D
 . N INDEX,VIEN
 . S INDEX="CPTVCPT-"_CODE
 . S VIEN=FIEVAL(FINDING,"VIEN")
 . D HLCV^PXRMVSIT(.NLINES,.TEXT,VIEN,INDEX)
 Q
 ;
