BIUTL9 ;IHS/CMI/MWR - UTIL: OVERFLOW CODE FROM OTHER BIUTL RTNS; MAY 10, 2010
 ;;8.5;IMMUNIZATION;**9**;OCT 01,2014
 ;;* MICHAEL REMILLARD, DDS * CIMARRON MEDICAL INFORMATICS, FOR IHS *
 ;;  OVERFLOW CODE FROM OTHER BIUTL RTNS.
 ;;  PATCH 9: All EP's below are moved from BIUTL7 for space (<15000k).  REASCHK+0
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
