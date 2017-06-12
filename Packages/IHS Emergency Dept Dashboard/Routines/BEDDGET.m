BEDDGET ;GDIT/HS/BEE-BEDD Utility Routine ; 08 Nov 2011  12:00 PM
 ;;2.0;BEDD DASHBOARD;**1**;Jun 04, 2014;Build 22
 ;
 Q
 ;
GETCHIEF(BEDDIEN,BEDDCOMP,TYPE,CCLIST,LATEST) ;EP - Get V NARRATIVE TEXT
 ;
 ; Input:
 ; BEDDIEN - V NARRATIVE TEXT Entry IEN
 ; BEDDCOMP - BEDD.EDVISIT - Complaint field value
 ;     TYPE - Return type - P - Presenting, C - Chief, Null - All
 ;
 ; Output:
 ; V NARRATIVE TEXT (1st) or Complaint value (2nd)
 ; CCLIST - Array of chief complaint entries
 ;
 ;Error Trap
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BEDDGET D UNWIND^%ZTER" ; SAC 2006 2.2.3.3.2
 ;
 S TYPE=$G(TYPE)
 S BEDDCOMP=$G(BEDDCOMP)
 S BEDDIEN=$G(BEDDIEN)
 S LATEST=$G(LATEST)
 ;
 ;Return only presenting complaint
 I BEDDCOMP="" D
 . NEW DFN
 . S DFN=$$GET1^DIQ(9000010,BEDDIEN_",",.05,"I") Q:DFN=""
 . S BEDDCOMP=$$GET1^DIQ(9009081,DFN_",",23,"E")
 I TYPE="P" Q BEDDCOMP
 ;
 ;Retrieve V NARRATIVE TEXT entries
 NEW BEDDCTXT
 S BEDDCTXT=""
 ;
 I $G(BEDDIEN)]"",$D(^AUPNVNT("AD",BEDDIEN)) D
 . NEW BEDDCC
 . S BEDDCC="" F  S BEDDCC=$O(^AUPNVNT("AD",BEDDIEN,BEDDCC),-1) Q:'BEDDCC  D  I $G(BEDDCTXT)]"",LATEST Q
 .. ;
 .. ;Pull the entry
 .. I $D(^AUPNVNT(BEDDCC,11,0)) D
 ... N LN
 ... S CCLIST=$G(CCLIST)+1
 ... S LN=0 F  S LN=$O(^AUPNVNT(BEDDCC,11,LN)) Q:'LN  D
 .... S BEDDCTXT=$G(BEDDCTXT)_$S(BEDDCTXT="":"",1:" ")_$G(^AUPNVNT(BEDDCC,11,LN,0))
 .... S CCLIST(CCLIST)=$G(CCLIST(CCLIST))_$S($G(CCLIST(CCLIST))="":"",1:"; ")_$G(^AUPNVNT(BEDDCC,11,LN,0))
 ;
 ;If request for all, add the presenting complaint
 I TYPE="" D
 . I LATEST,BEDDCTXT]"" Q
 . S BEDDCTXT=BEDDCTXT_$S(BEDDCTXT="":"",1:"; ")_BEDDCOMP
 . S CCLIST=$G(CCLIST)+1
 . S CCLIST(CCLIST)=BEDDCOMP
 ;
 Q BEDDCTXT
 ;
 ;
ERR ;
 D ^%ZTER
 Q
