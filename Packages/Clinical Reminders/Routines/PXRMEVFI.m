PXRMEVFI ; SLC/PKR - Driver for findings evaluation. ;24-Mar-2006 13:24;MGH
 ;;1.5;CLINICAL REMINDERS;**1001,1004**;Jun 19, 2000
 ; Modified IHS/CIA/MGH - 5/10/2004 - Added lines to call routines for reminder findings in IHS
 ; PATCH 1004 added call for refusals
 ;=======================================================================
EVAL(DFN,FIEVAL) ;Evaluate the findings by group using the "E"
 ;cross-reference.
 N FTYPE
 S FTYPE=""
 F  S FTYPE=$O(^PXD(811.9,PXRMITEM,20,"E",FTYPE)) Q:FTYPE=""  D
 . I FTYPE="AUTTEDT(" D EVALFI^PXRMEDU(DFN,.FIEVAL) Q
 . I FTYPE="AUTTEXAM(" D EVALFI^PXRMEXAM(DFN,.FIEVAL) Q
 . I FTYPE="AUTTHF(" D EVALFI^PXRMHF(DFN,.FIEVAL) Q
 . I FTYPE="AUTTIMM(" D EVALFI^PXRMIMM(DFN,.FIEVAL) Q
 . I FTYPE="AUTTSK(" D EVALFI^PXRMSKIN(DFN,.FIEVAL) Q
 . I FTYPE="GMRD(120.51," D EVALFI^PXRMMEAS(DFN,.FIEVAL) Q
 . I FTYPE="LAB(60," D EVALFI^PXRMLAB(DFN,.FIEVAL) Q
 . I FTYPE="ORD(101.43," D EVALFI^PXRMORDR(DFN,.FIEVAL) Q
 . I FTYPE="PXD(811.2," D EVALFI^PXRMTAX(DFN,.FIEVAL) Q
 . I FTYPE="PXRMD(811.4," D EVALFI^PXRMCF(DFN,.FIEVAL) Q
 . I FTYPE="PXRMD(811.5," D EVALFI^PXRMTERM(DFN,.FIEVAL) Q
 . I FTYPE="PS(50.605," D EVALFI^PXRMDRCL(DFN,.FIEVAL) Q
 . I FTYPE="PSDRUG(" D EVALFI^PXRMDRUG(DFN,.FIEVAL) Q
 . I FTYPE="PSNDF(50.6," D EVALFI^PXRMDGEN(DFN,.FIEVAL) Q
 . I FTYPE="RAMIS(71," D EVALFI^PXRMRAD(DFN,.FIEVAL) Q
 . ;I FTYPE="YTT(601," D EVALFI^PXRMMH(DFN,.FIEVAL) Q
 . ;-----------------------------------------------------------------
 . ; IHS/CIA/MGH - 5/10/2004 PATCH 1001 Calls below are to resolve findings using
 . ; files from IHS that are not used by VA.  They are Patient refusals
 . ; V-measurement files, family history and personal history
 . I FTYPE="AUTTREFT(" D EVALFI^BPXRMREF(DFN,.FIEVAL) Q
 . I FTYPE="AUTTMSR(" D EVALFI^BPXRMEA(DFN,.FIEVAL) Q   ;V Measurement file PATCH 1001
 Q
 ;
