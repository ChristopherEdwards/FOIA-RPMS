DG53426U ;ALB/AEG - DG*5.3*426 POST-INSTALL UTILITIES ;2-13-02
 ;;5.3;Registration;**426**;2-13-02
 ;
 ; This routine contains a number of APIs/Utilities to be
 ; used in the post-installation cleanup of patch DG*5.3*426
 ;
MTDA(DFN) ;Set up a data array of each patient's primary means test
 ;        data.
 ;INPUT - DFN (REQUIRED)
 ;OUTPUT - NONE -- SET UP MEANS TEST DATA ON TMP GLOBAL
 ;                 ^TMP($J,"MTD",DFN)=DGMTI_"~~"_DGNODE
 N DGDT,DGIDT,DGMTI,DGMTST,DGNODE,DGCS,DGMTDT
 S (DGMTI,DGMTDT)=""
 F  S DGMTDT=$O(^DGMT(408.31,"AD",1,DFN,DGMTDT)) Q:'DGMTDT  D
 .F DGMTI=0:0 S DGMTI=$O(^DGMT(408.31,"AD",1,DFN,DGMTDT,DGMTI)) Q:'DGMTI  D
 ..S DGNODE=$G(^DGMT(408.31,DGMTI,0)),DGCS=$P($G(DGNODE),U,3)
 ..I $G(DGNODE),$G(^("PRIM")) D
 ...D:((DGCS=6)!(DGCS=2))
 ....; Only store the last test which meets the criteria for
 ....; this cleanup.
 ....S ^TMP($J,"MTD",DFN)=DGMTI_"~~"_DGNODE
 ....Q
 ...Q
 ..Q
 .Q
 Q
AGTP(DGMTI) ; This API will determine if the patient declined to provide 
 ;;        income info but agreed to pay the deductible for a given
 ;         test OR if the veteran provided income information and agreed
 ;         to pay the deductible.
 ;
 ; input - DGMTI - IEN of file 408.31 entry
 ; output - DGRETV -  1 = YES, Vet provided income info & Agreed to
 ;                        pay deductible.
 ;                    2 = NO, Vet did not provide income info & 
 ;                        Agreed to pay.
 ;                    3 = NO, Vet did not provide income info & did
 ;                        not agree to pay (Ineligible)
 ;                    4 = YES, Vet provided income info & did NOT
 ;                        Agree to pay.
 ;                    0 = Error condition indicated.
 N DGRETV
 S DGRETV=0
 I '$D(^DGMT(408.31,DGMTI,0)) Q DGRETV
 I $D(^DGMT(408.31,DGMTI,0)) D
 .; Did not decline to provide income info & Agreed to Pay.
 .I '+$P($G(^DGMT(408.31,DGMTI,0)),U,14)&+$P($G(^DGMT(408.31,DGMTI,0)),U,11) D
 ..; Determine age of test and assign to appropriate sub-category
 ..;         -  If test date is greater than 10/5/99 - subcategory "a"
 ..;         -  If test date is less than 10/6/99 - subcategory "b"
 ..I $P($G(^DGMT(408.31,DGMTI,0)),U)>2991005 S DGRETV="1a"
 ..I $P($G(^DGMT(408.31,DGMTI,0)),U)<2991006 S DGRETV="1b"
 .; Did NOT provide income info but Agreed to pay. NO date restrictions
 .; on these veterans.
 .I +$P($G(^DGMT(408.31,DGMTI,0)),U,14)&+$P($G(^DGMT(408.31,DGMTI,0)),U,11) S DGRETV=2
 .; Did NOT provide income info & did NOT Agree to pay. (Not eligible)
 .I +$P($G(^DGMT(408.31,DGMTI,0)),U,14)&'+$P($G(^DGMT(408.31,DGMTI,0)),U,11) S DGRETV=3
 .; Did provide income info but did NOT agree to pay deductible.
 .I '+$P($G(^DGMT(408.31,DGMTI,0)),U,14)&'+$P($G(^DGMT(408.31,DGMTI,0)),U,11) S DGRETV=4
 Q DGRETV
MM(XMZ) ; Write mail message to user screen and/or install file.
 D BMES^XPDUTL("Mail Message < #"_XMZ_" > sent.")
 Q
