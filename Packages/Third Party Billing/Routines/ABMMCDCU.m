ABMMCDCU ; IHS/SD/SDR - Medicaid Eligible file cleanup for TPB ; 02/19/2015
 ;;99.1;IHS DICTIONARIES (PATIENT);**24**;MAR 9, 1999;Build 1
 ;
 ;For CR4215 - This routine is called by AUPNMCDF to clean up TPB claims and bills based
 ;  on Medicaid Eligible records that are cleaned up in the AUPNMCDF routine.  It will
 ;  use one patient/Medicaid DFN and look for all claims associated with that entry, changing
 ;  .07 MEDICAID MULTIPLE in the Insurer multiple.
 ;
 ;
 Q
 ; *********************************************************************
EN(A,B,C,D) ;
 ;  ABM("PDFN")=PATIENT
 ;  ABM("MDFN")=Medicaid Eligible IEN
 ;  ABMOLD - original value; what we are looking for
 ;  ABMNEW - new value; what we are replacing old value with
 ;
 S ABM("PDFN")=A
 S ABM("MDFN")=B
 S ABMOLD=C
 S ABMNEW=D
 ;
 S ABMHOLD=DUZ(2)
 S DUZ(2)=0
 ;
 F  S DUZ(2)=$O(^ABMDCLM(DUZ(2))) Q:'DUZ(2)  D
 .S ABM("CDFN")=0
 .F  S ABM("CDFN")=$O(^ABMDCLM(DUZ(2),"B",ABM("PDFN"),ABM("CDFN"))) Q:'ABM("CDFN")  D
 ..S ABM("MIEN")=0
 ..F  S ABM("MIEN")=$O(^ABMDCLM(DUZ(2),ABM("CDFN"),13,ABM("MIEN"))) Q:'ABM("MIEN")  D
 ...I $P($G(^ABMDCLM(DUZ(2),ABM("CDFN"),13,ABM("MIEN"),0)),U,6)'=ABM("MDFN") Q  ;not the Medicaid entry we are looking for
 ...S ABM("OLD")=$P($G(^ABMDCLM(DUZ(2),ABM("CDFN"),13,ABM("MIEN"),0)),U,7)
 ...I ABM("OLD")'=ABMOLD Q  ;not the Medicaid eligibility entry we are looking for
 ...S DA(1)=ABM("CDFN")
 ...S DA=ABM("MIEN")
 ...S DIE="^ABMDCLM(DUZ(2),"_DA(1)_",13,"
 ...S DR=".07////"_ABMNEW
 ...D ^DIE
 ...D LOG^AUPNMCDF(9002274.3,ABM("MIEN")_",13,"_ABM("CDFN")_","_DUZ(2),"9002274.3013"_","_".07",ABM("OLD"))
 ...D BILLS
 S DUZ(2)=ABMHOLD
 Q
BILLS   ;EP
 S ABM("BILL")=ABM("CDFN")_" "  ;the space makes it act like a string
 F  S ABM("BILL")=$O(^ABMDBILL(DUZ(2),"B",ABM("BILL"))) Q:(ABM("BILL")'[ABM("CDFN"))  D
 .S ABM("BDFN")=0
 .F  S ABM("BDFN")=$O(^ABMDBILL(DUZ(2),"B",ABM("BILL"),ABM("BDFN"))) Q:'ABM("BDFN")  D
 ..S ABM("BMIEN")=0
 ..F  S ABM("BMIEN")=$O(^ABMDBILL(DUZ(2),ABM("BDFN"),13,ABM("BMIEN"))) Q:'ABM("BMIEN")  D
 ...I $P($G(^ABMDBILL(DUZ(2),ABM("BDFN"),13,ABM("BMIEN"),0)),U,6)'=ABM("MDFN") Q  ;not the Medicaid entry we are looking for
 ...S ABM("OLD")=$P($G(^ABMDBILL(DUZ(2),ABM("BDFN"),13,ABM("BMIEN"),0)),U,7)
 ...I ABM("OLD")'=ABMOLD Q  ;not the Medicaid eligibility entry we are looking for
 ...S DA(1)=ABM("BDFN")
 ...S DA=ABM("BMIEN")
 ...S DIE="^ABMDBILL(DUZ(2),"_DA(1)_",13,"
 ...S DR=".07////"_ABMNEW
 ...D ^DIE
 ...D LOG^AUPNMCDF(9002274.4,ABM("MIEN")_",13,"_ABM("BDFN")_","_DUZ(2),"9002274.4013"_","_".07",ABM("OLD"))
 Q
