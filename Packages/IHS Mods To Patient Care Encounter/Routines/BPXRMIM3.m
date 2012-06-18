BPXRMIM3 ; IHS/CIA/MGH - Handle computed findigs for immunizations. ;24-Sep-2009 16:19;MGH
 ;;1.5;CLINICAL REMINDERS;**1005,1006,1007**;Jun 19, 2000
 ;=================================================================
 ;This routine is designed to evaluate the immunication forcast
 ;data to determine if an immunization is due for a child requiring a
 ;seried of immunizations
 ;Patch 5 added rotavirus and HPV immunizations
 ;Patch 7 added H1N1
 ;=====================================================================
ROTA(DFN,TEST,DATE,VALUE,TEXT) ; EP
 ;This computed finding will check the imunization forecast file to find
 ;Rotavirus immunizations that are setup in the reminder term for ROTAVIRUS
 N BPXNAME,BPXTRM,BPXIN,BPXCNT,BPXHI,BPXREM,BPXRTM,BPXTEST,EARLY,LATE,TARGET,LINE,TODAY,COUNT
 S BPXNAME="IHS-PED ROTAVIRUS IMMUN 2008",LINE=1,TEST=0,DATE="",VALUE="",TEXT=""
 K ^TMP("PXRMCF",$J,DFN)
 S BPXREM="" S BPXREM=$O(^PXD(811.9,"B",BPXNAME,BPXREM))
 Q:BPXREM=""
 S BPXTRM="" S BPXTRM=$O(^PXRMD(811.5,"B","IHS-ROTAVIRUS IMMUNIZATION",BPXTRM))
 I BPXTRM=""  S TEST=0,TEXT="Reminder term does not exist" Q
 D GETVAR^BPXRMIM2(BPXTRM)
 Q
HPV(DFN,TEST,DATE,VALUE,TEXT) ;EP
 ;This computed finding will check the imunization forecast file to find
 ;HPV immunizations that are setup in the reminder term for HPV
 N BPXNAME,BPXTRM,BPXIN,BPXCNT,BPXHI,BPXREM,BPXRTM,BPXTEST,EARLY,LATE,TARGET,LINE,TODAY,COUNT
 S BPXNAME="IHS-HPV IMMUN 2008",LINE=1,TEST=0,DATE="",VALUE="",TEXT=""
 K ^TMP("PXRMCF",$J,DFN)
 S BPXREM="" S BPXREM=$O(^PXD(811.9,"B",BPXNAME,BPXREM))
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
