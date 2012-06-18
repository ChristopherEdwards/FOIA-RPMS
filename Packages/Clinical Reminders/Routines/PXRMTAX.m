PXRMTAX ; SLC/PKR - Handle taxonomy finding. ;06-May-2009 16:37;MGH
 ;;1.5;CLINICAL REMINDERS;**2,8,1004,1006**;Jun 19, 2000
 ;IHS/CIA/MGH Code added to find ICD0 codes in the V procedures file
 ;=======================================================================
EVALFI(DFN,FIEVAL) ;EP  Evaluate taxonomy findings.
 N FIND0,FIND3,FINDING,TAXIEN
 S TAXIEN=""
 F  S TAXIEN=$O(^PXD(811.9,PXRMITEM,20,"E","PXD(811.2,",TAXIEN)) Q:+TAXIEN=0  D
 . S FINDING=""
 . F  S FINDING=$O(^PXD(811.9,PXRMITEM,20,"E","PXD(811.2,",TAXIEN,FINDING)) Q:+FINDING=0  D
 .. S FIND0=^PXD(811.9,PXRMITEM,20,FINDING,0)
 .. S FIND3=$G(^PXD(811.9,PXRMITEM,20,FINDING,3))
 .. D FIEVAL(DFN,TAXIEN,FIND0,FIND3,"","",FINDING,.FIEVAL)
 Q
 ;
 ;=======================================================================
EVALTERM(DFN,FINDING,TERMIEN,TFIEVAL) ; EP Evaluate taxonomy findings in terms.
 N FIND0,FIND3,TAXIEN,TFIND0,TFIND3,TFINDING
 S FIND0=^PXD(811.9,PXRMITEM,20,FINDING,0)
 S FIND3=$G(^PXD(811.9,PXRMITEM,20,FINDING,3))
 S TAXIEN=""
 F  S TAXIEN=$O(^PXRMD(811.5,TERMIEN,20,"E","PXD(811.2,",TAXIEN)) Q:+TAXIEN=0  D
 . S TFINDING=""
 . F  S TFINDING=$O(^PXRMD(811.5,TERMIEN,20,"E","PXD(811.2,",TAXIEN,TFINDING)) Q:+TFINDING=0  D
 .. S TFIND0=^PXRMD(811.5,TERMIEN,20,TFINDING,0)
 .. S TFIND3=$G(^PXRMD(811.5,TERMIEN,20,TFINDING,3))
 .. D FIEVAL(DFN,TAXIEN,FIND0,FIND3,TFIND0,TFIND3,TFINDING,.TFIEVAL)
 Q
 ;
 ;=======================================================================
FIEVAL(DFN,TAXIEN,FIND0,FIND3,TFIND0,TFIND3,FINDING,FIEVAL) ;
 ;Make sure the taxonomy has been expanded and the expansion is current.
 D CHECK^PXRMBXTL(TAXIEN,"")
 N CONVAL,DATE,ENS,FLIST,INS,INVDATE,NICD0,NICD9,NICPT,NRCPT,PDS,PLS
 N RAS,SOURCE,STATUS,TEMP,TSORT,VALID,VIEN
 ;Setup the Patient Data Source control variables.
 S PDS=$P(^PXD(811.2,TAXIEN,0),U,4)
 I PDS["EN" S ENS=1
 E  S ENS=0
 I PDS["IN" S INS=1
 E  S INS=0
 I PDS["PL" S PLS=1
 E  S PLS=0
 I PDS["RA" S RAS=1
 E  S RAS=0
 ;The default is to search all locations.
 I PDS="" S (ENS,INS,PLS,RAS)=1
 S TEMP=$G(^PXD(811.3,TAXIEN,0))
 S NICD0=+$P(TEMP,U,3)
 I (NICD0>0)&(INS) D
 . D EVALICD0^PXRMDGPT(DFN,TAXIEN,.FLIST)
 . ;IHS/CIA/MGH line added to call routine for ICD0 codes
 . D EVAL^BPXRMPRC(DFN,TAXIEN,.FLIST)  ;POC
 S NICD9=+$P(TEMP,U,5)
 I NICD9>0 D
 . I INS D EVALICD9^PXRMDGPT(DFN,TAXIEN,.FLIST)
 . I PLS D EVAL^PXRMPROB(DFN,FIND0,TFIND0,TAXIEN,.FLIST)
 . I ENS D EVAL^PXRMVPOV(DFN,TAXIEN,.FLIST)
 S NICPT=+$P(TEMP,U,7)
 I (NICPT>0)&(ENS) D
 . D EVAL^PXRMVCPT(DFN,TAXIEN,.FLIST)
 S NRCPT=+$P(TEMP,U,9)
 I (NRCPT>0)&(RAS) D
 . D EVAL^PXRMRCPT(DFN,TAXIEN,.FLIST)
 ;Process the found list. Return the most recent non expired result.
 ;If there are no non-expired results return the most recent expired.
 ;The found list data is
 ;FLIST(INVDATE,SOURCE)=SOURCE IEN_U_VISIT IEN_U_DATE_U_CODE PTR_U_
 ;whatever is unique for this finding type.
 ;If the finding is not related to a visit then visit ien will be null.
 S INVDATE=""
 F  S INVDATE=$O(FLIST(INVDATE)) Q:+INVDATE=0  D
 . S SOURCE=""
 . F  S SOURCE=$O(FLIST(INVDATE,SOURCE)) Q:SOURCE=""  D
 .. S DATE=$P(FLIST(INVDATE,SOURCE),U,3)
 ..;If this is being called as part of a term evaluation we are done
 ..;do not check for expiration or the condition.
 ..;Determine if the finding has expired.
 .. I TFIND0'="" S VALID=1
 .. E  S VALID=$$VALID^PXRMDATE(FIND0,TFIND0,DATE)
 ..;Set status=0 for a true finding for sorting.
 .. I VALID S STATUS=0
 .. E  S STATUS=1
 .. S TSORT(STATUS,INVDATE,SOURCE)=""
 ;Look for the most recent true finding.
 S STATUS=0
 S INVDATE=+$O(TSORT(STATUS,""))
 I INVDATE=0 D
 . S STATUS=1
 . S INVDATE=+$O(TSORT(STATUS,""))
 I INVDATE>0 D
 . I STATUS=1 D
 .. S FIEVAL(FINDING)=0
 .. S FIEVAL(FINDING,"EXPIRED")=""
 . E  S FIEVAL(FINDING)=1
 . S SOURCE=$O(TSORT(STATUS,INVDATE,""))
 . S TEMP=FLIST(INVDATE,SOURCE)
 . S FIEVAL(FINDING,"DATE")=$P(TEMP,U,3)
 . S FIEVAL(FINDING,"CODEP")=$P(TEMP,U,4)
 . S FIEVAL(FINDING,"FINDING")=TAXIEN_";PXD(811.2,"
 . S FIEVAL(FINDING,"SOURCE")=$P(TEMP,U,1)_";"_SOURCE
 . I SOURCE="AUPNPROB" S FIEVAL(FINDING,"PRIORITY")=$P(TEMP,U,6)
 . S VIEN=$P(TEMP,U,2)
 . I VIEN'="" S FIEVAL(FINDING,"VIEN")=VIEN
 .;If the finding is true evaluate the condition.
 . I TFIND0'="" Q
 . I FIEVAL(FINDING) D
 .. S CONVAL=$$COND^PXRMUTIL(FIND3,TFIND3,"")
 .. I CONVAL'="" D
 ... I CONVAL D
 .... S FIEVAL(FINDING)=CONVAL
 .... S FIEVAL(FINDING,"CONDITION")=CONVAL
 ... E  D
 .... K FIEVAL(FINDING)
 .... S FIEVAL(FINDING)=0
 E  S FIEVAL(FINDING)=0
 Q
 ;
 ;=======================================================================
OUTPUT(NLINES,TEXT,FINDING,FIEVAL) ;Produce the clinical
 ;maintenance output.
 N SROOT
 S SROOT=$P(FIEVAL(FINDING,"SOURCE"),";",2)
 I SROOT["AUPNVCPT" D OUTPUT^PXRMVCPT(.NLINES,.TEXT,FINDING,.FIEVAL) Q
 I SROOT["AUPNPROB" D OUTPUT^PXRMPROB(.NLINES,.TEXT,FINDING,.FIEVAL) Q
 I SROOT["AUPNVPOV" D OUTPUT^PXRMVPOV(.NLINES,.TEXT,FINDING,.FIEVAL) Q
 I SROOT["DGPTICD0" D OUTICD0^PXRMDGPT(.NLINES,.TEXT,FINDING,.FIEVAL) Q
 I SROOT["DGPTICD9" D OUTICD9^PXRMDGPT(.NLINES,.TEXT,FINDING,.FIEVAL) Q
 I SROOT["AUPNVPRC" D OUTPUT^BPXRMPRC(.NLINES,.TEXT,FINDING,.FIEVAL) Q
 I SROOT["RADPT" D OUTPUT^PXRMRCPT(.NLINES,.TEXT,FINDING,.FIEVAL) Q
 Q
 ;
 ;=======================================================================
PDSXHELP ;Taxonomy field Patient Data Source executable help.
 N TEXT
 S TEXT(1)="This is a list of comma separated patient data sources."
 S TEXT(2)="You may use any combination of valid entries."
 S TEXT(3)="Valid entries are:"
 S TEXT(4)="  IN - inpatient from PTF"
 S TEXT(5)="  INDXLS - inpatient DXLS diagnosis only"
 S TEXT(6)="  INPR - inpatient primary diagnosis  only"
 S TEXT(7)="  EN - encounter PCE data"
 S TEXT(8)="  ENPR - encounter PCE data primary diagnosis only"
 S TEXT(9)="  PL - Problem List"
 S TEXT(10)="  RA - radiology CPT only"
 S TEXT(11)="  "
 D EN^DDIOL(.TEXT)
 Q
 ;
 ;=======================================================================
TAXEDIT(TAXIEN,KI) ;Whenever a taxonony item is edited rebuild the expanded
 ;taxonomy
 D DELEXTL^PXRMBXTL(TAXIEN)
 D CHECK^PXRMBXTL(TAXIEN,KI)
 Q
 ;
 ;=======================================================================
TAXKILL(TAXIEN) ;Called whenever a taxonony item is killed.
 D DELEXTL^PXRMBXTL(TAXIEN)
 Q
 ;
 ;=======================================================================
VPDS ;Taxonomy field Patient Data Source input transform. Check for valid
 ;patient data sources.
 N IND,NSOURCE,PDS,TEXT,VALID
 S VALID=1
 S X=$$UP^XLFSTR(X)
 S NSOURCE=$L(X,",")
 F IND=1:1:NSOURCE D
 . S PDS=$P(X,",",IND)
 .;Check for valid source abbreviations.
 . I PDS="IN" Q
 . I PDS="INDXLS" Q
 . I PDS="INPR" Q
 . I PDS="EN" Q
 . I PDS="ENPR" Q
 . I PDS="PL" Q
 . I PDS="RA" Q
 . S VALID=0
 . S TEXT=PDS_" is not a valid Patient Data Source"
 . D EN^DDIOL(TEXT)
 I 'VALID K X
 Q
 ;
