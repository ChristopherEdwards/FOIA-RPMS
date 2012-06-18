PXRMHF ; SLC/PKR - Handle Health Factor findings. ;23-Jan-2006 11:38;MGH
 ;;1.5;CLINICAL REMINDERS;**2,7,8,1004**;Jun 19, 2000
 ;
 ;=======================================================================
BLDPC(DFN) ;Build a list of Health Factors associated with this patient,
 ;keep only the most recent of each.
 N CAT,DATE,IEN,INVDATE,HFIND,NPATHF,TEMP,TYPE,VIEN
 I '$D(^XTMP(PXRMDFN,"HF","NPATHF")) D
 . K ^XTMP(PXRMDFN,"HF")
 . S NPATHF=0
 . S HFIND=""
 . F  S HFIND=$O(^AUPNVHF("AA",DFN,HFIND)) Q:HFIND=""  D
 .. S INVDATE=$O(^AUPNVHF("AA",DFN,HFIND,""))
 .. S IEN=$O(^AUPNVHF("AA",DFN,HFIND,INVDATE,""))
 .. S VIEN=$P(^AUPNVHF(IEN,0),U,3)
 .. S DATE=$$VDATE^PXRMDATE(VIEN)
 .. S TEMP=$G(^AUTTHF(HFIND,0))
 .. S TYPE=$P(TEMP,U,10)
 .. I TYPE="C" S CAT=HFIND
 .. E  S CAT=$P(^AUTTHF(HFIND,0),U,3)
 ..;If the category is null then send a warning.
 .. I CAT="" D WARN(TEMP)  Q
 .. S NPATHF=NPATHF+1
 ..;Store the heath factor, its category, the entry in AUPNVHF,
 ..;the visit, and the date.
 .. S ^XTMP(PXRMDFN,"HF",CAT,INVDATE,HFIND)=IEN_U_VIEN_U_DATE
 . S ^XTMP(PXRMDFN,"HF","NPATHF")=NPATHF
 E  S NPATHF=^XTMP(PXRMDFN,"HF","NPATHF")
 Q NPATHF
 ;
 ;=======================================================================
EVALFI(DFN,FIEVAL) ;Evaluate health factor findings.
 ;Setup an array of health factors for matching.
 N CAT,HFIEN,FIHF,FINDING,NPATHF,WCR
 ;
 S NPATHF=$$BLDPC(DFN)
 ;If the patient has no health factors set all health factor findings
 ;to false and quit.
 I NPATHF=0 D  Q
 . S HFIEN=""
 . F  S HFIEN=$O(^PXD(811.9,PXRMITEM,20,"E","AUTTHF(",HFIEN)) Q:+HFIEN=0  D
 .. S FINDING=""
 .. F  S FINDING=$O(^PXD(811.9,PXRMITEM,20,"E","AUTTHF(",HFIEN,FINDING)) Q:+FINDING=0  D
 ... S FIEVAL(FINDING)=0
 ;
 S HFIEN=""
 ;Build the list of health factor findings for this reminder.
 F  S HFIEN=$O(^PXD(811.9,PXRMITEM,20,"E","AUTTHF(",HFIEN)) Q:+HFIEN=0  D
 . S CAT=$P(^AUTTHF(HFIEN,0),U,3)
 .;If the category is null then send a warning.
 . I CAT="" D WARN(^AUTTHF(HFIEN,0))  Q
 . S FINDING=""
 . F  S FINDING=$O(^PXD(811.9,PXRMITEM,20,"E","AUTTHF(",HFIEN,FINDING)) Q:+FINDING=0  D
 .. S FIEVAL(FINDING)=0
 ..;Get the Within Category Rank
 .. S WCR=$P(^PXD(811.9,PXRMITEM,20,FINDING,0),U,10)
 .. I WCR="" S WCR=9999
 .. S FIHF(CAT,HFIEN,WCR)=FINDING
 ;
 D MPHF(DFN,.FIHF,.FIEVAL)
 Q
 ;
 ;=======================================================================
EVALTERM(DFN,FINDING,TERMIEN,TERMEVAL) ;Evaluate health factor terms.
 N CAT,HFIEN,FIHF,NPATHF,TERMHF,TFINDING,WCR
 ;
 S NPATHF=$$BLDPC(DFN)
 ;If the patient has no health factors set all health factor
 ;findings to false and quit.
 I NPATHF=0 D  Q
 . S HFIEN=""
 . F  S HFIEN=$O(^PXRMD(811.5,TERMIEN,20,"E","AUTTHF(",HFIEN)) Q:+HFIEN=0  D
 .. S TFINDING=""
 .. F  S TFINDING=$O(^PXRMD(811.5,TERMIEN,20,"E","AUTTHF(",HFIEN,TFINDING)) Q:+TFINDING=0  D
 ... S TERMEVAL(TFINDING)=0
 ;
 S HFIEN=""
 ;Build the list of health factor findings for this term.
 F  S HFIEN=$O(^PXRMD(811.5,TERMIEN,20,"E","AUTTHF(",HFIEN)) Q:+HFIEN=0  D
 . S CAT=$P(^AUTTHF(HFIEN,0),U,3)
 . S TFINDING=""
 . F  S TFINDING=$O(^PXRMD(811.5,TERMIEN,20,"E","AUTTHF(",HFIEN,TFINDING)) Q:+TFINDING=0  D
 .. S TERMEVAL(TFINDING)=0
 ..;Get the Within Category Rank, look at the term finding level first.
 .. S WCR=$P(^PXRMD(811.5,TERMIEN,20,TFINDING,0),U,10)
 .. I WCR="" S WCR=$P(^PXD(811.9,PXRMITEM,20,FINDING,0),U,10)
 .. I WCR="" S WCR=9999
 .. S TERMHF(CAT,HFIEN,WCR)=FINDING_U_TERMIEN_U_TFINDING
 ;
 D MPHF(DFN,.TERMHF,.TERMEVAL)
 Q
 ;
 ;=======================================================================
MPHF(DFN,FIHF,FIEVAL) ;Find the matches.
 N CONVAL,CAT,DATE,DONE,F0,FIND0,FIND3,HFIEN,INVDATE,LEVEL,SORTLIST
 N TEMP,TF0,TFIND0,TFIND3,VALID,WCR
 S CAT=0
 F  S CAT=$O(^XTMP(PXRMDFN,"HF",CAT)) Q:+CAT=0  D
 . I '$D(FIHF(CAT)) Q
 .;Have a category get health factors.
 . S INVDATE=0
 . F  S INVDATE=$O(^XTMP(PXRMDFN,"HF",CAT,INVDATE)) Q:INVDATE=""  D
 .. S HFIEN=0
 .. F  S HFIEN=$O(^XTMP(PXRMDFN,"HF",CAT,INVDATE,HFIEN)) Q:HFIEN=""  D
 ... I '$D(FIHF(CAT,HFIEN)) Q
 ... S WCR=$O(FIHF(CAT,HFIEN,""))
 ... S SORTLIST(CAT,INVDATE,WCR,HFIEN)=""
 ;Process SORTLIST the first factor in the category will be true
 ;the others false unless WCR=0 in which case it is treated as an
 ;individual finding.
 S CAT=0
 F  S CAT=$O(SORTLIST(CAT)) Q:CAT=""  D
 . S DONE=0
 . S INVDATE=0
 . F  S INVDATE=$O(SORTLIST(CAT,INVDATE)) Q:(INVDATE="")!(DONE)  D
 .. S WCR=""
 .. F  S WCR=$O(SORTLIST(CAT,INVDATE,WCR)) Q:(WCR="")!(DONE)  D
 ... S HFIEN=""
 ... F  S HFIEN=$O(SORTLIST(CAT,INVDATE,WCR,HFIEN)) Q:(HFIEN="")!(DONE)  D
 ....;If this is a term finding it will be the third piece.
 .... S F0=$P(FIHF(CAT,HFIEN,WCR),U,1)
 .... S TF0=$P(FIHF(CAT,HFIEN,WCR),U,3)
 .... I TF0="" S FINDING=F0
 .... E  S FINDING=TF0
 .... S TEMP=^XTMP(PXRMDFN,"HF",CAT,INVDATE,HFIEN)
 .... S FIEVAL(FINDING)=1
 .... S (DATE,FIEVAL(FINDING,"DATE"))=$P(TEMP,U,3)
 .... S FIEVAL(FINDING,"FINDING")=HFIEN_";AUTTHF("
 .... S FIEVAL(FINDING,"SOURCE")=$P(TEMP,U,1)_";AUPNVHF("
 .... ;IHS/CIA/MGH Modified for missing health factor
 .... I '$D(^AUPNVHF($P(TEMP,U,1))) D  Q
 ..... S FIEVAL(FINDING)=0
 .... S FIEVAL(FINDING,"VIEN")=$P(TEMP,U,2)
 ....;The value is the level/severity.
 .... S LEVEL=$P(^AUPNVHF($P(TEMP,U,1),0),U,5)
 .... S FIEVAL(FINDING,"LEVEL")=LEVEL
 .... S FIEVAL(FINDING,"VALUE")=LEVEL
 ....;If this is being called as part of a term evaluation we are done.
 .... I TF0'="" Q
 ....;If there is an condition for this finding evaluate it.
 .... S FIND0=^PXD(811.9,PXRMITEM,20,F0,0)
 .... S FIND3=$G(^PXD(811.9,PXRMITEM,20,F0,3))
 .... S (TFIND0,TFIND3)=""
 ....;Determine if the finding has expired.
 .... S VALID=$$VALID^PXRMDATE(FIND0,TFIND0,DATE)
 .... I 'VALID D  Q
 ..... S FIEVAL(FINDING)=0
 ..... S FIEVAL(FINDING,"EXPIRED")=""
 .... S CONVAL=$$COND^PXRMUTIL(FIND3,TFIND3,LEVEL)
 .... I CONVAL'="" D
 ..... I CONVAL D
 ...... S FIEVAL(FINDING)=CONVAL
 ...... S FIEVAL(FINDING,"CONDITION")=CONVAL
 ..... E  D
 ...... K FIEVAL(FINDING)
 ...... S FIEVAL(FINDING)=0
 .... I WCR>0 S DONE=1
 Q
 ;
 ;=======================================================================
OUTPUT(NLINES,TEXT,FINDING,FIEVAL) ;Produce the clinical
 ;maintenance output.
 N EM,FIEN,PNAME,LEVEL,TEMP,VDATE
 S FIEN=$P(FIEVAL(FINDING,"FINDING"),";",1)
 S VDATE=FIEVAL(FINDING,"DATE")
 S LEVEL=$G(FIEVAL(FINDING,"VALUE"))
 S TEMP=$$EDATE^PXRMDATE(VDATE)
 S TEMP=TEMP_" Health Factor: "
 S PNAME=$P(^AUTTHF(FIEN,0),U,1)
 S TEMP=TEMP_PNAME
 I $L(LEVEL)>0 D
 . S TEMP=TEMP_"; level/severity - "
 . S TEMP=TEMP_$$EXTERNAL^DILFD(9000010.23,.04,"",LEVEL,.EM)
 ;If the health factor has expired add "EXPIRED"
 I $D(FIEVAL(FINDING,"EXPIRED")) S TEMP=TEMP_" - EXPIRED"
 ;If the finding is false because of the value add the reason.
 I $G(FIEVAL(FINDING,"CONDITION"))=0 S TEMP=TEMP_$$ACTFT^PXRMOPT
 S NLINES=NLINES+1
 S TEXT(NLINES)=TEMP
 I $D(PXRMDEV) D
 . N UID
 . S UID="HEALTH FACTOR "_PNAME
 . S ^TMP(PXRMPID,$J,PXRMITEM,UID)=TEMP
 ;
 ;For historical encounters display the location and comments.
 I VDATE["E" D
 . N INDEX,VIEN
 . S INDEX="HF-"_PNAME
 . S VIEN=FIEVAL(FINDING,"VIEN")
 . D HLCV^PXRMVSIT(.NLINES,.TEXT,VIEN,INDEX)
 Q
 ;
 ;=======================================================================
PATLIST(INDEX,HFIEN,FINDING,FIND0,FIND3,TFIND0,TFIND3,FIEVAL) ;Build a
 ;list of patients with a particular health factor.
 K ^TMP(INDEX,$J,FINDING)
 K ^TMP("PXRMHFLIST",$J)
 N CONVAL,DATE,DFN,HFLIST,IND,TEMP,VALID,VALUE
 S IND=0
 F  S IND=+$O(^AUPNVHF("B",HFIEN,IND)) Q:IND=0  D
 . S TEMP=$G(^AUPNVHF(IND,0))
 . S DFN=$P(TEMP,U,2)
 . S VISIT=$P(TEMP,U,3)
 . S DATE=$P(^AUPNVSIT(VISIT,0),U,1)
 . S VALID=$$VALID^PXRMDATE(FIND0,TFIND0,DATE)
 . I 'VALID Q
 .;Save the level/severity.
 . S VALUE=$P(TEMP,U,4)
 . S CONVAL=$$COND^PXRMUTIL(FIND3,TFIND3,VALUE)
 . I (CONVAL="")!(CONVAL) D
 .. S TEMP="RESULT~"_VALUE_U_"SOURCE~"_IND_";AUPNVHF("_U_"VISIT~"_VISIT
 .. S ^TMP("PXRMHFLIST",$J,DFN,DATE)=TEMP
 ;Only valid entries are on the list, save the most recent.
 S DFN=0
 F  S DFN=+$O(^TMP("PXRMHFLIST",$J,DFN)) Q:DFN=0  D
 . S DATE=$O(^TMP("PXRMHFLIST",$J,DFN,""),-1)
 . S ^TMP(INDEX,$J,DFN,DATE,FINDING)="FINDING~"_FIEVAL(FINDING,"FINDING")_U_^TMP("PXRMHFLIST",$J,DFN,DATE)
 K ^TMP("PXRMHFLIST",$J)
 Q
 ;
 ;=======================================================================
WARN(HF0) ;Issue a warning if a health factor is missing its category.
 N XMSUB
 K ^TMP("PXRMXMZ",$J)
 S XMSUB="CLINICAL REMINDER DATA PROBLEM, HEALTH FACTOR"
 S ^TMP("PXRMXMZ",$J,1,0)="Health Factor "_$P(HF0,U,1)
 S ^TMP("PXRMXMZ",$J,2,0)="does not have a category, this is a required field."
 S ^TMP("PXRMXMZ",$J,3,0)="This health factor will be ignored for all patients until the problem is fixed."
 D SEND^PXRMMSG(XMSUB)
 Q
 ;
