BIUTL9 ;IHS/CMI/MWR - UTIL: OVERFLOW CODE FROM OTHER BIUTL RTNS; MAY 10, 2010
 ;;8.5;IMMUNIZATION;**12**;MAY 01,2016
 ;;* MICHAEL REMILLARD, DDS * CIMARRON MEDICAL INFORMATICS, FOR IHS *
 ;;  OVERFLOW CODE FROM OTHER BIUTL RTNS.
 ;;  PATCH 9: All EP's below are moved from BIUTL7 for space (<15000k).  REASCHK+0
 ;;  PATCH 12: Same as above. LOTDAT+0, HISTORY+0
 ;
 ;
 ;********** PATCH 9, v8.5, OCT 01,2014, IHS/CMI/MWR
 ;---> All EP's below are moved from BIUTL7 for space (<15000k).
 ;
 ;----------
REASCHK ;EP
 ;---> Called by Post Action field of Field 5 on BI FORM-CASE DATA EDIT.
 ;---> If Date Inactive in Field 4, then a Reason is req'd in Field 5.
 ;
 I (BI("E")]"")&(BI("F")="") D
 .D HLP^DDSUTL("*** NOTE! An Inactive Date REQUIRES an Inactive Reason! ***")
 .S DDSBR=4
 Q
 ;
 ;
 ;----------
READCHK ;EP
 ;---> Called by Post Action field of Field 4 on BI FORM-SKIN VISIT ADD/EDIT.
 ;---> If user entered a Result in Field 3, then a Reading is req'd in Field 4.
 I $G(BI("L"))]"",$G(BI("M"))="",$G(BI("I"))'="E" D
 .;
 .D HLP^DDSUTL("*** NOTE! If you enter a Result you MUST enter a Reading! ***")
 .S DDSBR=3
 Q
 ;
 ;
 ;----------
READCH6 ;EP
 ;---> Called by Post Action field of Field 4 on BI FORM-SKIN VISIT ADD/EDIT.
 ;
 D READCHK
 I $G(DDSBR)=3 D  Q
 .S X=$G(DDSOLD) D PUT^DDSVALF(6,,,X)
 D LOCBR^BIUTL4
 Q
 ;
 ;
 ;----------
CREASCHK ;EP
 ;---> Called by Post Action of Field 4 on BI FORM-CONTRAIND ADD/EDIT.
 ;---> If user entered a Contra in Field 1, then a Reason is req'd in Field 4.
 ;
 I (BI("B")]"")&(BI("C")="") D
 .D HLP^DDSUTL("*** NOTE! A Reason for the contraindication is required! ***")
 .S DDSBR=1
 Q
 ;**********
 ;
 ;********** PATCH 12, v8.5, MAY 01,2016, IHS/CMI/MWR
 ;---> LOTDAT and VSHORT below are moved from BIUTL7 for space (<15000k).
 ;
 ;----------
LOTDAT(X) ;EP
 ;---> Called by Post Action field of Field 3 on BI FORM-IMM VISIT ADD/EDIT.
 ;---> Display Lot Exp Date and Remaining Balance (if tracked).
 ;---> Parameters:
 ;     1 - X (req) IEN of Lot Number in ^AUTTIML.
 ;
 Q:'$G(X)
 D PUT^DDSVALF(3.4,,," Exp Date: "_$$LOTEXP^BIRPC3(X,1))
 D PUT^DDSVALF(3.5,,,"Remaining: "_$$LOTRBAL^BIRPC3(X))
 Q
 ;
 ;
 ;----------
VSHORT(X) ;EP
 ;---> Called by LOADVIS above and by Post Action field of Field 2
 ;---> on BI FORM-IMM VISIT ADD/EDIT.
 ;---> Display Short Name below Vaccine Name if different.
 ;---> Parameters:
 ;     1 - X (req) IEN of Vaccine in ^AUTTIMM.
 ;
 Q:'$G(X)  Q:($$VNAME^BIUTL2(X)=$$VNAME^BIUTL2(X,1))
 D PUT^DDSVALF(2.5,,,"("_$$VNAME^BIUTL2(X)_")")
 Q
 ;**********
 ;
 ;
 ;********** PATCH 12, v8.5, MAY 01,2016, IHS/CMI/MWR
 ;---> HISTORY below are moved from BIUTL4 for space (<15000k).
 ;
 ;----------
HISTORY(X) ;EP
 ;---> Add/Edit Screenman actions to take ON POST-CHANGE of Category Field.
 ;---> Parameters:
 ;     1 - X (opt) X=Internal Value of Category Field ("E"=Historical Event).
 ;
 ;---> If this is an Historical Event, then set Lot#="" and not required.
 I X="E" D
 .S BI("D")=""
 .D PUT^DDSVALF(3,"","",""),REQ^DDSUTL(3,"","",0)
 .;---> Remove (default) provider.
 .D PUT^DDSVALF(9,,,) S BI("R")=""
 .;
 .;********** PATCH 12, v8.5, MAY 01,2016, IHS/CMI/MWR
 .;---> Set Injection Site AND Volume fields not required.
 .D REQ^DDSUTL(4,"","",0),REQ^DDSUTL(5,"","",0)
 ;
 ;---> If Category is Ambulatory or Inpatient, then set Inj Site to required.
 I (X="A")!(X="I") D REQ^DDSUTL(4,"","",1),REQ^DDSUTL(5,"","",1)
 Q
 ;**********
