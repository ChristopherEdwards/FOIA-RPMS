BPXRMIM3 ; IHS/MSC/MGH - Handle computed findings for immunizations. ;04-Mar-2015 12:36;du
 ;;2.0;CLINICAL REMINDERS;**1001,1002,1003**;Feb 04, 2005;Build 21
 ;=================================================================
 ;This routine is designed to evaluate the immunication forcast
 ;data to determine if an immunization is due for a child requiring a
 ;seried of immunizations
 ;=====================================================================
ROTA(DFN,TEST,DATE,VALUE,TEXT) ; EP
 ;This computed finding will check the imunization forecast file to find
 ;Rotavirus immunizations that are setup in the reminder term for ROTAVIRUS
 N BPXNAME,BPXTRM,BPXIN,BPXCNT,BPXHI,BPXREM,BPXRTM,BPXTEST,EARLY,LATE,TARGET,LINE,TODAY,COUNT
 K ^TMP("BPXRMCF",$J,DFN)
 S BPXNAME="IHS-PED ROTAVIRUS IMMUN 2013",LINE=1,TEST=0,DATE="",VALUE="",TEXT=""
 S BPXREM="" S BPXREM=$O(^PXD(811.9,"B",BPXNAME,BPXREM))
 I BPXREM="" D
 . S BPXNAME="IHS-PED ROTAVIRUS IMMUN 2012",LINE=1,TEST=0,DATE="",VALUE="",TEXT=""
 . S BPXREM="" S BPXREM=$O(^PXD(811.9,"B",BPXNAME,BPXREM))
 Q:BPXREM=""
 S BPXTRM="" S BPXTRM=$O(^PXRMD(811.5,"B","IHS-ROTAVIRUS IMMUNIZATION",BPXTRM))
 I BPXTRM=""  S TEST=0,TEXT="Reminder term does not exist" Q
 D GETVAR^BPXRMIM2(BPXTRM)
 Q
HPV(DFN,TEST,DATE,VALUE,TEXT) ;EP
 ;This computed finding will check the imunization forecast file to find
 ;HPV immunizations that are setup in the reminder term for HPV
 N BPXNAME,BPXTRM,BPXIN,BPXCNT,BPXHI,BPXREM,BPXRTM,BPXTEST,EARLY,LATE,TARGET,LINE,TODAY,COUNT
 K ^TMP("BPXRMCF",$J,DFN)
 S BPXNAME="IHS-HPV IMMUN 2014",LINE=1,TEST=0,DATE="",VALUE="",TEXT=""
 S BPXREM="" S BPXREM=$O(^PXD(811.9,"B",BPXNAME,BPXREM))
 I BPXREM="" D
 . S BPXNAME="IHS-HPV IMMUN 2013",LINE=1,TEST=0,DATE="",VALUE="",TEXT=""
 . S BPXREM="" S BPXREM=$O(^PXD(811.9,"B",BPXNAME,BPXREM))
 Q:BPXREM=""
 S BPXTRM="" S BPXTRM=$O(^PXRMD(811.5,"B","IHS-HPV IMMUNIZATION",BPXTRM))
 I BPXTRM=""  S TEST=0,TEXT="Reminder term does not exist" Q
 D GETVAR^BPXRMIM2(BPXTRM)
 Q
H1N1(DFN,TEST,DATE,VALUE,TEXT) ;EP
 ;This computed finding will check the imunization forecast file to find
 ;HPV immunizations that are setup in the reminder term for HPV
 N BPXNAME,BPXTRM,BPXIN,BPXCNT,BPXHI,BPXREM,BPXRTM,BPXTEST,EARLY,LATE,TARGET,LINE,TODAY,COUNT
 S BPXNAME="IHS-H1N1 IMMUN 2009",LINE=1,TEST=0,DATE="",VALUE="",TEXT=""
 K ^TMP("PXRMCF",$J,DFN)
 S BPXREM="" S BPXREM=$O(^PXD(811.9,"B",BPXNAME,BPXREM))
 Q:BPXREM=""
 S BPXTRM="" S BPXTRM=$O(^PXRMD(811.5,"B","IHS-H1N1 IMMUNIZATION",BPXTRM))
 I BPXTRM=""  S TEST=0,TEXT="Reminder term does not exist" Q
 D GETVAR^BPXRMIM2(BPXTRM)
 Q
ZOSTER(DFN,TEST,DATE,VALUE,TEXT) ;EP
 ;This computed finding will check the imunization forecast file to find
 ;ZOSTER immunizations that are setup in the reminder term for HPV
 N BPXNAME,BPXTRM,BPXIN,BPXCNT,BPXHI,BPXREM,BPXRTM,BPXTEST,EARLY,LATE,TARGET,LINE,TODAY,COUNT
 K ^TMP("BPXRMCF",$J,DFN)
 S BPXNAME="IHS-ZOSTER IMMUN 2013",LINE=1,TEST=0,DATE="",VALUE="",TEXT=""
 S BPXREM="" S BPXREM=$O(^PXD(811.9,"B",BPXNAME,BPXREM))
 I BPXREM="" D
 . S BPXNAME="IHS-ZOSTER IMMUN 2012",LINE=1,TEST=0,DATE="",VALUE="",TEXT=""
 . S BPXREM="" S BPXREM=$O(^PXD(811.9,"B",BPXNAME,BPXREM))
 Q:BPXREM=""
 S BPXTRM="" S BPXTRM=$O(^PXRMD(811.5,"B","IHS-ZOSTER IMMUNIZATION",BPXTRM))
 I BPXTRM=""  S TEST=0,TEXT="Reminder term does not exist" Q
 D GETVAR^BPXRMIM2(BPXTRM)
 Q
