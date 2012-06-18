BPXRMIM1 ; IHS/CIA/MGH - Handle computed findigs for immunizations. ;09-Apr-2009 12:53;MGH
 ;;1.5;CLINICAL REMINDERS;**1002,1003,1004,1005,1006**;Jun 19, 2000
 ;=================================================================
 ;This routine is designed to evaluate the immunication forcast
 ;data to determine if an immunization is due for a child requiring a
 ;seried of immunizations
 ;Patch 4 Added meningitis immunization
 ;=====================================================================
TD(DFN,TEST,DATE,VALUE,TEXT) ; EP
 ;This computed finding will check the imunization forecast file to find
 ;TD immunizations that are setup in the reminder term for TD
 N BPXNAME,BPXTRM,BPXIN,BPXCNT,BPXHI,BPXREM,BPXRTM,BPXTEST,EARLY,LATE,TARGET,LINE,TODAY,COUNT
 S BPXNAME="IHS-TD IMMUN 2008",LINE=1,TEST=0,DATE="",VALUE="",TEXT=""
 K ^TMP("PXRMCF",$J,DFN)
 S BPXREM="" S BPXREM=$O(^PXD(811.9,"B",BPXNAME,BPXREM))
 Q:BPXREM=""
 S BPXTRM="" S BPXTRM=$O(^PXRMD(811.5,"B","IHS-TD IMMUNIZATION",BPXTRM))
 I BPXTRM=""  S TEST=0,TEXT="Reminder term does not exist" Q
 D GETVAR^BPXRMIM2(BPXTRM)
 Q
TDPED(DFN,TEST,DATE,VALUE,TEXT) ;EP
 ;This computed finding will check the imunization forecast file to find
 ;DT-Ped immunizations that are setup in the reminder term for DT-Ped
 N BPXNAME,BPXTRM,BPXIN,BPXCNT,BPXHI,BPXREM,BPXRTM,BPXTEST,EARLY,LATE,TARGET,LINE,TODAY,COUNT
 S BPXNAME="IHS-PED DT IMMUN 2008",LINE=1,TEST=0,DATE="",VALUE="",TEXT=""
 K ^TMP("PXRMCF",$J,DFN)
 S BPXREM="" S BPXREM=$O(^PXD(811.9,"B",BPXNAME,BPXREM))
 Q:BPXREM=""
 S BPXTRM="" S BPXTRM=$O(^PXRMD(811.5,"B","IHS-PED TD IMMUNIZATION",BPXTRM))
 I BPXTRM=""  S TEST=0,TEXT="Reminder term does not exist" Q
 D GETVAR^BPXRMIM2(BPXTRM)
 Q
FLU(DFN,TEST,DATE,VALUE,TEXT) ;EP
 ;This computed finding will check the imunization forecast file to find
 ;Flu immunizations that are setup in the reminder term for Flu
 N BPXNAME,BPXTRM,BPXIN,BPXCNT,BPXHI,BPXREM,BPXRTM,BPXTEST,EARLY,LATE,TARGET,LINE,TODAY,COUNT
 S BPXNAME="IHS-INFLUENZA IMMUN 2008",LINE=1,TEST=0,DATE="",VALUE="",TEXT=""
 K ^TMP("PXRMCF",$J,DFN)
 S BPXREM="" S BPXREM=$O(^PXD(811.9,"B",BPXNAME,BPXREM))
 Q:BPXREM=""
 S BPXTRM="" S BPXTRM=$O(^PXRMD(811.5,"B","IHS-INFLUENZA 2007",BPXTRM))
 I BPXTRM=""  S TEST=0,TEXT="Reminder term does not exist" Q
 D GETVAR^BPXRMIM2(BPXTRM)
 Q
PNEUMO(DFN,TEST,DATE,VALUE,TEXT) ;EP
 ;This computed finding will check the imunization forecast file to find
 ;pneumo immunizations that are setup in the reminder term for Pneumo
 N BPXNAME,BPXTRM,BPXIN,BPXCNT,BPXHI,BPXREM,BPXRTM,BPXTEST,EARLY,LATE,TARGET,LINE,TODAY,COUNT
 S BPXNAME="IHS-PNEUMOVAX IMMUN 2008",LINE=1,TEST=0,DATE="",VALUE="",TEXT=""
 K ^TMP("PXRMCF",$J,DFN)
 S BPXREM="" S BPXREM=$O(^PXD(811.9,"B",BPXNAME,BPXREM))
 Q:BPXREM=""
 S BPXTRM="" S BPXTRM=$O(^PXRMD(811.5,"B","IHS-PNEUMOVAX IMMUNIZATION",BPXTRM))
 I BPXTRM=""  S TEST=0,TEXT="Reminder term does not exist" Q
 D GETVAR^BPXRMIM2(BPXTRM)
 Q
PNEUPED(DFN,TEST,DATE,VALUE,TEXT) ;EP
 ;This computed finding will check the imunization forecast file to find
 ;pneumo immunizations that are setup in the reminder term for Pneumo
 N BPXNAME,BPXTRM,BPXIN,BPXCNT,BPXHI,BPXREM,BPXRTM,BPXTEST,EARLY,LATE,TARGET,LINE,TODAY,COUNT
 S BPXNAME="IHS-PED PNEUMOCOCCAL IMMUN 2008",LINE=1,TEST=0,DATE="",VALUE="",TEXT=""
 K ^TMP("PXRMCF",$J,DFN)
 S BPXREM="" S BPXREM=$O(^PXD(811.9,"B",BPXNAME,BPXREM))
 Q:BPXREM=""
 S BPXTRM="" S BPXTRM=$O(^PXRMD(811.5,"B","IHS-PED PNEUMOVAX IMMUNIZATION",BPXTRM))
 I BPXTRM=""  S TEST=0,TEXT="Reminder term does not exist" Q
 D GETVAR^BPXRMIM2(BPXTRM)
 Q
HEPA(DFN,TEST,DATE,VALUE,TEXT) ;EP
 ;This computed finding will check the imunization forecast file to find
 ;HepA immunizations that are setup in the reminder term for HepA
 N BPXNAME,BPXTRM,BPXIN,BPXCNT,BPXHI,BPXREM,BPXRTM,BPXTEST,EARLY,LATE,TARGET,LINE,TODAY,COUNT
 S BPXNAME="IHS-PED HEPA IMMUN 2008",LINE=1,TEST=0,DATE="",VALUE="",TEXT=""
 K ^TMP("PXRMCF",$J,DFN)
 S BPXREM="" S BPXREM=$O(^PXD(811.9,"B",BPXNAME,BPXREM))
 Q:BPXREM=""
 S BPXTRM="" S BPXTRM=$O(^PXRMD(811.5,"B","IHS-HEPA IMMUNIZATION",BPXTRM))
 I BPXTRM=""  S TEST=0,TEXT="Reminder term does not exist" Q
 D GETVAR^BPXRMIM2(BPXTRM)
 Q
HEPADULT(DFN,TEST,DATE,VALUE,TEXT) ;EP
 ;This computed finding will check the imunization forecast file to find
 ;HepA ADULT immunizations that are setup in the reminder term for HepA
 N BPXNAME,BPXTRM,BPXIN,BPXCNT,BPXHI,BPXREM,BPXRTM,BPXTEST,EARLY,LATE,TARGET,LINE,TODAY,COUNT
 S BPXNAME="IHS-HEP A ADULT IMMUN 2008",LINE=1,TEST=0,DATE="",VALUE="",TEXT=""
 K ^TMP("PXRMCF",$J,DFN)
 S BPXREM="" S BPXREM=$O(^PXD(811.9,"B",BPXNAME,BPXREM))
 Q:BPXREM=""
 S BPXTRM="" S BPXTRM=$O(^PXRMD(811.5,"B","IHS-HEPADULT IMMUNIZATION",BPXTRM))
 I BPXTRM=""  S TEST=0,TEXT="Reminder term does not exist" Q
 D GETVAR^BPXRMIM2(BPXTRM)
 Q
HEBADULT(DFN,TEST,DATE,VALUE,TEXT) ;EP
 ;This computed finding will check the imunization forecast file to find
 ;Hepb Adult immunizations that are setup in the reminder term for HepA
 N BPXNAME,BPXTRM,BPXIN,BPXCNT,BPXHI,BPXREM,BPXRTM,BPXTEST,EARLY,LATE,TARGET,LINE,TODAY,COUNT
 S BPXNAME="IHS-HEP B ADULT IMMUN 2008",LINE=1,TEST=0,DATE="",VALUE="",TEXT=""
 K ^TMP("PXRMCF",$J,DFN)
 S BPXREM="" S BPXREM=$O(^PXD(811.9,"B",BPXNAME,BPXREM))
 Q:BPXREM=""
 S BPXTRM="" S BPXTRM=$O(^PXRMD(811.5,"B","IHS-HEBADULT IMMUNIZATION",BPXTRM))
 I BPXTRM=""  S TEST=0,TEXT="Reminder term does not exist" Q
 D GETVAR^BPXRMIM2(BPXTRM)
 Q
MENING(DFN,TEST,DATE,VALUE,TEXT) ;EP
 ;This computed finding will check the imunization forecast file to find
 ;Meningitis immunizations that are setup in the reminder term for HepA
 N BPXNAME,BPXTRM,BPXIN,BPXCNT,BPXHI,BPXREM,BPXRTM,BPXTEST,EARLY,LATE,TARGET,LINE,TODAY,COUNT
 S BPXNAME="IHS-MENINGITIS IMMUN 2008",LINE=1,TEST=0,DATE="",VALUE="",TEXT=""
 K ^TMP("PXRMCF",$J,DFN)
 S BPXREM="" S BPXREM=$O(^PXD(811.9,"B",BPXNAME,BPXREM))
 Q:BPXREM=""
 S BPXTRM="" S BPXTRM=$O(^PXRMD(811.5,"B","IHS-MENINGITIS IMMUNE",BPXTRM))
 I BPXTRM=""  S TEST=0,TEXT="Reminder term does not exist" Q
 D GETVAR^BPXRMIM2(BPXTRM)
 Q
TDAP(DFN,TEST,DATE,VALUE,TEXT) ;EP
 ;This computed finding will check the imunization forecast file to find
 ;tdap immunizations that are setup in the reminder term for tdap
 N BPXNAME,BPXTRM,BPXIN,BPXCNT,BPXHI,BPXREM,BPXRTM,BPXTEST,EARLY,LATE,TARGET,LINE,TODAY,COUNT
 S BPXNAME="IHS-TDAP IMMUN 2008",LINE=1,TEST=0,DATE="",VALUE="",TEXT=""
 K ^TMP("PXRMCF",$J,DFN)
 S BPXREM="" S BPXREM=$O(^PXD(811.9,"B",BPXNAME,BPXREM))
 Q:BPXREM=""
 S BPXTRM="" S BPXTRM=$O(^PXRMD(811.5,"B","IHS-TDAP IMMUNE",BPXTRM))
 I BPXTRM=""  S TEST=0,TEXT="Reminder term does not exist" Q
 D GETVAR^BPXRMIM2(BPXTRM)
 Q
