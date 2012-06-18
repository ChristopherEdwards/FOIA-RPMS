BPXRMIMM ; IHS/CIA/MGH - Computed Findings for Immunizations. ;08-Apr-2009 17:52;MGH
 ;;1.5;CLINICAL REMINDERS;**1002,1004,1005,1006**;Jun 19, 2000
 ;=================================================================
 ;This routine is designed to evaluate the immunication forcast
 ;data to determine if an immunization is due for a child requiring a
 ;seried of immunizations
 ;Added to patch 1004 to sites can install all reminders
 ;=====================================================================
POLIO(DFN,TEST,DATE,VALUE,TEXT) ; EP
 ;This computed finding will check the imunization forecast file to find
 ;IPV immunizations that are setup in the reminder term for polio
 N BPXNAME,BPXTRM,BPXIN,BPXCNT,BPXHI,BPXREM,BPXRTM,BPXTEST,EARLY,LATE,TARGET,LINE,TODAY,COUNT
 S BPXNAME="IHS-PED POLIO IMMUN 2008",LINE=1,TEST=0,DATE="",VALUE="",TEXT=""
 K ^TMP("PXRMCF",$J,DFN)
 S BPXREM="" S BPXREM=$O(^PXD(811.9,"B",BPXNAME,BPXREM))
 Q:BPXREM=""
 S BPXTRM="" S BPXTRM=$O(^PXRMD(811.5,"B","IHS-POLIO IMMUNIZATION",BPXTRM))
 I BPXTRM=""  S TEST=0,TEXT="Reminder term does not exist" Q
 D GETVAR^BPXRMIM2(BPXTRM)
 Q
DTP(DFN,TEST,DATE,VALUE,TEXT) ;EP
 ;This computed finding will check the imunization forecast file to find
 ;DPT immunizations that are setup in the reminder term for dpt
 N BPXNAME,BPXTRM,BPXIN,BPXCNT,BPXHI,BPXREM,BPXRTM,BPXTEST,EARLY,LATE,TARGET,LINE,TODAY,COUNT
 S BPXNAME="IHS-PED DTP IMMUN",LINE=1,TEST=0,DATE="",VALUE="",TEXT=""
 K ^TMP("PXRMCF",$J,DFN)
 S BPXREM="" S BPXREM=$O(^PXD(811.9,"B",BPXNAME,BPXREM))
 Q:BPXREM=""
 S BPXTRM="" S BPXTRM=$O(^PXRMD(811.5,"B","IHS-DTP IMMUNIZATION",BPXTRM))
 I BPXTRM=""  S TEST=0,TEXT="Reminder term does not exist" Q
 D GETVAR^BPXRMIM2(BPXTRM)
 Q
DTAP(DFN,TEST,DATE,VALUE,TEXT) ;EP
 ;This computed finding will check the imunization forecast file to find
 ;DTap immunizations that are setup in the reminder term for DTap
 N BPXNAME,BPXTRM,BPXIN,BPXCNT,BPXHI,BPXREM,BPXRTM,BPXTEST,EARLY,LATE,TARGET,LINE,TODAY,COUNT
 S BPXNAME="IHS-PED DTAP IMMUN 2008",LINE=1,TEST=0,DATE="",VALUE="",TEXT=""
 K ^TMP("PXRMCF",$J,DFN)
 S BPXREM="" S BPXREM=$O(^PXD(811.9,"B",BPXNAME,BPXREM))
 Q:BPXREM=""
 S BPXTRM="" S BPXTRM=$O(^PXRMD(811.5,"B","IHS-DTAP IMMUNIZATION",BPXTRM))
 I BPXTRM=""  S TEST=0,TEXT="Reminder term does not exist" Q
 D GETVAR^BPXRMIM2(BPXTRM)
 Q
MMR(DFN,TEST,DATE,VALUE,TEXT) ; EP
 ;This computed finding will check the imunization forecast file to find
 ;MMR immunizations that are setup in the reminder term for MMR
 N BPXNAME,BPXTRM,BPXIN,BPXCNT,BPXHI,BPXREM,BPXRTM,BPXTEST,EARLY,LATE,TARGET,LINE,TODAY,COUNT
 S BPXNAME="IHS-PED MMR IMMUN 2008",LINE=1,TEST=0,DATE="",VALUE="",TEXT=""
 K ^TMP("PXRMCF",$J,DFN)
 S BPXREM="" S BPXREM=$O(^PXD(811.9,"B",BPXNAME,BPXREM))
 Q:BPXREM=""
 S BPXTRM="" S BPXTRM=$O(^PXRMD(811.5,"B","IHS-MMR IMMUNIZATION",BPXTRM))
 I BPXTRM=""  S TEST=0,TEXT="Reminder term does not exist" Q
 D GETVAR^BPXRMIM2(BPXTRM)
 Q
HEPB(DFN,TEST,DATE,VALUE,TEXT) ; EP
 ;This computed finding will check the imunization forecast file to find
 ;hepb pediatric immunizations that are setup in the reminder term for hep b
 N BPXNAME,BPXTRM,BPXIN,BPXCNT,BPXHI,BPXREM,BPXRTM,BPXTEST,EARLY,LATE,TARGET,LINE,TODAY,COUNT
 S BPXNAME="IHS-PED HEPB IMMUN 2008",LINE=1,TEST=0,DATE="",VALUE="",TEXT=""
 K ^TMP("PXRMCF",$J,DFN)
 S BPXREM="" S BPXREM=$O(^PXD(811.9,"B",BPXNAME,BPXREM))
 Q:BPXREM=""
 S BPXTRM="" S BPXTRM=$O(^PXRMD(811.5,"B","IHS-HEPB IMMUNIZATION",BPXTRM))
 I BPXTRM=""  S TEST=0,TEXT="Reminder term does not exist" Q
 D GETVAR^BPXRMIM2(BPXTRM)
 Q
HIB(DFN,TEST,DATE,VALUE,TEXT) ; EP
 ;This computed finding will check the imunization forecast file to find
 ;hibtiter immunizations that are setup in the reminder term for hibtiter
 N BPXNAME,BPXTRM,BPXIN,BPXCNT,BPXHI,BPXREM,BPXRTM,BPXTEST,EARLY,LATE,TARGET,LINE,TODAY,COUNT
 S BPXNAME="IHS-PED HIBTITER IMMUN 2008",LINE=1,TEST=0,DATE="",VALUE="",TEXT=""
 K ^TMP("PXRMCF",$J,DFN)
 S BPXREM="" S BPXREM=$O(^PXD(811.9,"B",BPXNAME,BPXREM))
 Q:BPXREM=""
 S BPXTRM="" S BPXTRM=$O(^PXRMD(811.5,"B","IHS-HIBTITER IMMUNIZATION",BPXTRM))
 I BPXTRM=""  S TEST=0,TEXT="Reminder term does not exist" Q
 D GETVAR^BPXRMIM2(BPXTRM)
 Q
PEDIARIX(DFN,TEST,DATE,VALUE,TEXT) ; EP
 ;This computed finding will check the imunization forecast file to find
 ;pediarix immunizations that are setup in the reminder term for pediarix
 N BPXNAME,BPXTRM,BPXIN,BPXCNT,BPXHI,BPXREM,BPXRTM,BPXTEST,EARLY,LATE,TARGET,LINE,TODAY,COUNT
 S BPXNAME="IHS-PED PEDIARIX IMMUN 2008",LINE=1,TEST=0,DATE="",VALUE="",TEXT=""
 K ^TMP("PXRMCF",$J,DFN)
 S BPXREM="" S BPXREM=$O(^PXD(811.9,"B",BPXNAME,BPXREM))
 Q:BPXREM=""
 S BPXTRM="" S BPXTRM=$O(^PXRMD(811.5,"B","IHS-PEDIARIX IMMUNIZATION",BPXTRM))
 I BPXTRM=""  S TEST=0,TEXT="Reminder term does not exist" Q
 D GETVAR^BPXRMIM2(BPXTRM)
 Q
PEDIAVAC(DFN,TEST,DATE,VALUE,TEXT) ; EP
 ;This computed finding will check the imunization forecast file to find
 ;vaxhib immunizations that are setup in the reminder term for vaxhib
 N BPXNAME,BPXTRM,BPXIN,BPXCNT,BPXHI,BPXREM,BPXRTM,BPXTEST,EARLY,LATE,TARGET,LINE,TODAY,COUNT
 S BPXNAME="IHS-PED PEDVAXHIB IMMUN 2008",LINE=1,TEST=0,DATE="",VALUE="",TEXT=""
 K ^TMP("PXRMCF",$J,DFN)
 S BPXREM="" S BPXREM=$O(^PXD(811.9,"B",BPXNAME,BPXREM))
 Q:BPXREM=""
 S BPXTRM="" S BPXTRM=$O(^PXRMD(811.5,"B","IHS-PEDVAXHIB IMMUNIZATION",BPXTRM))
 I BPXTRM=""  S TEST=0,TEXT="Reminder term does not exist" Q
 D GETVAR^BPXRMIM2(BPXTRM)
 Q
VARI(DFN,TEST,DATE,VALUE,TEXT) ; EP
 ;This computed finding will check the imunization forecast file to find
 ;varicella immunizations that are setup in the reminder term for varicella
 N BPXNAME,BPXTRM,BPXIN,BPXCNT,BPXHI,BPXREM,BPXRTM,BPXTEST,EARLY,LATE,TARGET,LINE,TODAY,COUNT
 S BPXNAME="IHS-PED VARICELLA IMMUN 2008",LINE=1,TEST=0,DATE="",VALUE="",TEXT=""
 K ^TMP("BPXRMCF",$J,DFN)
 S BPXREM="" S BPXREM=$O(^PXD(811.9,"B",BPXNAME,BPXREM))
 Q:BPXREM=""
 S BPXTRM="" S BPXTRM=$O(^PXRMD(811.5,"B","IHS-VARICELLA IMMUNIZATION",BPXTRM))
 I BPXTRM=""  S TEST=0,TEXT="Reminder term does not exist" Q
 D GETVAR^BPXRMIM2(BPXTRM)
 Q
