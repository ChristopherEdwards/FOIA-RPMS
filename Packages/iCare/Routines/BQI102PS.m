BQI102PS ;PRXM/HC/ALA-Version 1.0 Patch 2 Post-Install ; 18 Oct 2007  5:08 PM
 ;;1.0;ICARE MANAGEMENT SYSTEM;**2**;May 21, 2007
 ;
EN ; Fix missing zero nodes in BQIPAT caused by NPT^BQITASK error
 ;   fixed in patch 1
 NEW BQIDFN
 S BQIDFN=0
 F  S BQIDFN=$O(^BQIPAT(BQIDFN)) Q:'BQIDFN  D
 . I $G(^BQIPAT(BQIDFN,0))="" D
 .. S ^BQIPAT(BQIDFN,0)=BQIDFN,^BQIPAT("B",BQIDFN,BQIDFN)=""
 Q
