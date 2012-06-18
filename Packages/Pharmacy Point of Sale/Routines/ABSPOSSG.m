ABSPOSSG ; IHS/SD/lwj - Special gets for formats ;      [ 12/23/2002  8:10 AM ]
 ;;1.0;PHARMACY POINT OF SALE;**1,2,3,4,5,42**;JUN 21, 2001
 ;----------------------------------------------------------------------
 ; IHS/SD/lwj 07/31/02
 ; If version 3.2 there were several fields that were defined - when
 ; 5.1 came along, the fields had to be duplicated because of repeating
 ; values - as such, new logic was added into this program to 
 ; set the fields ^ABSPC entry based on the claim version used.
 ;
 ; FMT416 is now obsolete - remove with next patch or release
 ;----------------------------------------------------------------------
 ;IHS/SD/lwj 10/28/02 - added code for Idaho medicaid state license #
 ;
 ;IHS/SD/lwj 11/29/02 - fixed made to the STATE subroutine to referenece
 ; ABSP(9002313.0201 instead of typo ABSP(9002313.02
 ; (error reported by Tawaoc and Ignacio)
 ;
 ;IHS/SD/lwj 12/12/02 - fix made for loading of duel fields (i.e. fields
 ; stored in the 3.2 header and 5.1 detail)  
 ; 
 Q
 ;*******************************************************************
 ;  IHS/SD/lwj  10/28/02
 ;  The COLSTATE routine is now OBSOLETE - it can be removed in
 ;  any patch following Patch 3 of V1.0 of POS
COLSTATE()          ;EP  entry point frm clm frmt for Colorado State Lic
 ; This entry point is only called from within a claim format
 ; that requires the retrieval of the Colorado State License
 ; number.
 ;
 N ABSPST,ABSPFND,ABSPLIC,ABSPPRO  ;state IEN, fnd ind, state lic 
 S (ABSPST,ABSPFND,ABSPLIC,ABSPPRO)=""
 ;
 ; Retrieve the IEN for file 200 
 ; Retrieve provider IEN into file 16 from 200
 ; Loop through file 16 State licenses until we locate a Colorado
 ; state license.
 ; If Colorado state license not found - return the default Medicaid
 ; number - this will fail the claim, but alert them to a missing
 ; state license number.
 ;
 S ABSPPRO=$G(ABSP("RX",ABSP(9002313.0201),"Prescriber IEN")) ;for 200
 I ABSPPRO S ABSPPRO=$P($G(^VA(200,ABSPPRO,0)),U,16)  ;get prov
 ;
 I ABSPPRO'="" D
 . F  S ABSPST=$O(^DIC(6,ABSPPRO,999999921,ABSPST)) Q:ABSPST=""  D
 .. I $P($G(^DIC(5,ABSPST,0)),U)["COLORADO" D
 ... S ABSPLIC=$P($G(^DIC(6,ABSPPRO,999999921,ABSPST,0)),U,2)
 ... S ABSPFND=1
 ... S ABSPST=99999999
 ;
 I 'ABSPFND S ABSPLIC=ABSP("Site","Default CAID #")
 ;
 Q ABSPLIC
 ;
 ;*******************************************************************
STATE(STATE) ;EP IHS/SD/lwj 10/28/02 retrieve the state license number
 ; This code will replace the COLSTATE code.
 ; Incoming - the two character state abbreviation for the state
 ;            license we need
 ; Outgoing - the licence number if found, or the default Medicaid #
 ;
 N STPOINT,DRPOINT,LIPOINT,LICENSE
 S (STPOINT,DRPOINT,LIPOINT,LICENSE)=""
 S STPOINT=$O(^DIC(5,"C",STATE,0))   ;state pointer
 ;
 ;IHS/SD/lwj 11/29/02 next line remarked out, following line added
 ;S DRPOINT=$G(ABSP("RX",ABSP(9002313.02),"Prescriber IEN")) ;prsc pntr
 S DRPOINT=$G(ABSP("RX",ABSP(9002313.0201),"Prescriber IEN")) ;prsc pntr
 ;
 ; get the license pointer
 S:STPOINT&DRPOINT LIPOINT=$O(^VA(200,DRPOINT,"PS1","B",STPOINT,0))
 S:LIPOINT LICENSE=$P($G(^VA(200,DRPOINT,"PS1",LIPOINT,0)),U,2)
 ;
 S:LICENSE="" LICENSE=$G(ABSP("Site","Default CAID #"))
 ;
 Q LICENSE
 ;
NEW416() ; IHS/SD/lwj 8/30/02   NCPDP 5.1
 ; Field 416 is obsolete in version 5.1 - BUT - the logic that
 ; is used in 5.1 is similiar for populating 3.2 claims that
 ; use field 416.  So - we will use this routine only until
 ; 3.2 is obsolete.
 ;
 N PATYPE,PANUM,PA
 ;
 S PATYPE=$E($G(ABSP("X")),1,1)
 S PANUM=$E($G(ABSP("X")),2,12)
 S PA="DG"_$G(PATYPE)_$$NFF^ABSPECFM($G(PANUM),11)
 ;
 Q PA
FMT416() ;----------------------------------------------------------------
 ;| *** OBSOLETE  ***  OBSOLETE  ***  OBSOLETE ***  OBSOLETE     |
 ;|  With the addition of the 5.1 fields, this routine is no     |
 ;|  longer needed or used.  We will keep in around only until   |
 ;|  the next full release of Pharmacy Point of Sale             |
 ;----------------------------------------------------------------
 ;
 N ABSPPA,ABSPCD,ABSPPC
 ;
 ; IHS/SD/lwj 6/19/02 chged to add 4 exemption from copay
 ;  S ABSPCD=$S(ABSP("X")=5:5,1:$S(ABSP("X"):"1",1:"0"))
 ;  S ABSPCD=$S(ABSP("X")=2:2,ABSP("X")=5:5,1:$S(ABSP("X"):"1",1:"0"))
 S ABSPCD=$S(ABSP("X")=2:2,ABSP("X")=4:4,ABSP("X")=5:5,1:$S(ABSP("X"):"1",1:"0"))
 ;
 ; IHS/SD/lwj 6/19/02 chged to add 4 exemption from copay
 ;  I ABSP("X")=5 D      ;exemptions from prescription limits
 ;  I (ABSP("X")=5)!(ABSP("X")=2) D   ;exempt frm pres lmts/med cert
 I (ABSP("X")=5)!(ABSP("X")=2)!(ABSP("X")=4) D   ;prs lmt/med cert/cpy
 . S ABSPPA=$$NFF^ABSPECFM("",11)
 ;
 ; IHS/SD/lwj 6/19/02 chged to add 4 exemption from copay
 ;I ABSP("X")'=5 D     ;prior authorization
 ;I (ABSP("X")'=5)&(ABSP("X")'=2) D     ;prior authorization
 I (ABSP("X")'=5)&(ABSP("X")'=2)&(ABSP("X")'=4) D  ;prior authorization
 . S ABSPPA=$$NFF^ABSPECFM($G(ABSP("X")),11)
 ;
 S ABSPPC="DG"_ABSPCD_ABSPPA
 ;
 Q ABSPPC
 ;
 ;-------------------------------------------------------------------
 ; All of the following fields were placed in here as part of the 
 ; restructuring involved in NCPDP 5.1.
 ; For fields 308, 315, 316, 317, 318, 319, 320, and 327 the set
 ; code for 3.2 will remain exactly as it was - for 5.1 we will
 ; update the "newer" location for those fields as well.
 ;-------------------------------------------------------------------
FLD308 ;Other Coverage Code 
 ; 3.2/5.1 Set code - called by set command in ABSP NCPDP Field Defs
 ;
 ; 3.2 SET
 S $P(^ABSPC(ABSP(9002313.02),300),U,8)=ABSP("X")
 ;
 ; 5.1 Set
 ;IHS/SD/lwj 12/20/02  nxt line remarked out, following line added
 ;I $D(ABSP(9002313.0201)) D
 I $G(ABSP(9002313.0201))'="" D
 . S $P(^ABSPC(ABSP(9002313.02),400,ABSP(9002313.0201),300),U,8)=ABSP("X")
 ;
 Q
 ;
FLD315 ;Employer Name  
 ; 3.2/5.1 Set Code - called by set command in ABSP NCPDP Field Defs
 ;
 ; 3.2 Set
 S $P(^ABSPC(ABSP(9002313.02),300),U,15)=ABSP("X")
 ;
 ;5.1 Set
 ;IHS/SD/lwj 12/20/02  nxt line remarked out, following line added
 ;I $D(ABSP(9002313.0201)) D
 I $G(ABSP(9002313.0201))'="" D
 . S $P(^ABSPC(ABSP(9002313.02),400,ABSP(9002313.0201),310),U,5)=ABSP("X")
 ;
 Q
 ;
FLD316 ;Employer Street Address
 ; 3.2/5.1 Set Code - called by set command in ABSP NCPDP Field DEfs
 ;
 ;3.2 Set
 S $P(^ABSPC(ABSP(9002313.02),300),U,16)=ABSP("X")
 ;
 ;5.1 Set
 ;IHS/SD/lwj 12/20/02  nxt line remarked out, following line added
 ;I $D(ABSP(9002313.0201)) D
 I $G(ABSP(9002313.0201))'="" D
 . S $P(^ABSPC(ABSP(9002313.02),400,ABSP(9002313.0201),310),U,6)=ABSP("X")
 ;
 Q
 ;
FLD317 ;Employer City Address  
 ;3.2/5.1 Set Code - called by set command in ABSP NCPDP Field Defs
 ;
 ;3.2 Set
 S $P(^ABSPC(ABSP(9002313.02),300),U,17)=ABSP("X")
 ;
 ;5.1 Set
 ;IHS/SD/lwj 12/20/02  nxt line remarked out, following line added
 ;I $D(ABSP(9002313.0201)) D
 I $G(ABSP(9002313.0201))'="" D
 . S $P(^ABSPC(ABSP(9002313.02),400,ABSP(9002313.0201),310),U,7)=ABSP("X")
 ;
 Q
 ;
FLD318 ;Employer State/Prov Address
 ;3.2/5.1 Set Code - called by set command in ABSP NCPDP Field Defs
 ;
 ;3.2 Set
 S $P(^ABSPC(ABSP(9002313.02),300),U,18)=ABSP("X")
 ;
 ;5.1 Set
 ;IHS/SD/lwj 12/20/02  nxt line remarked out, following line added
 ;I $D(ABSP(9002313.0201)) D
 I $G(ABSP(9002313.0201))'="" D
 . S $P(^ABSPC(ABSP(9002313.02),400,ABSP(9002313.0201),310),U,8)=ABSP("X")
 ;
 Q
 ;
FLD319 ;Employer Zip/Postal Zip
 ;3.2/5.1 Set Code - called by set command in ABSP NCPDP Field Defs
 ;
 ;3.2 Set
 S $P(^ABSPC(ABSP(9002313.02),300),U,19)=ABSP("X")
 ;
 ;5.1 Set
 ;IHS/SD/lwj 12/20/02  nxt line remarked out, following line added
 ;I $D(ABSP(9002313.0201)) D
 I $G(ABSP(9002313.0201))'="" D
 . S $P(^ABSPC(ABSP(9002313.02),400,ABSP(9002313.0201),310),U,9)=ABSP("X")
 ;
 Q
 ;
FLD320 ;Employer Phone Number
 ;3.2/5.1 Set Code - called by set command in ABSP NCPDP Field Defs
 ;
 ;3.2 Set
 S $P(^ABSPC(ABSP(9002313.02),320),U,20)=ABSP("X")
 ;
 ;5.1 Set
 ;IHS/SD/lwj 12/20/02  nxt line remarked out, following line added
 ;I $D(ABSP(9002313.0201)) D
 I $G(ABSP(9002313.0201))'="" D
 . S $P(^ABSPC(ABSP(9002313.02),400,ABSP(9002313.0201),310),U,10)=ABSP("X")
 ;
 Q
 ;
FLD327 ;Carrier ID
 ;3.2/5.1 Set Code - called by set command in ABSP NCPDP Field Defs
 ;
 ;3.2 Set
 S $P(^ABSPC(ABSP(9002313.02),320),U,27)=ABSP("X")
 ;
 ;5.1 Set
 ;IHS/SD/lwj 12/20/02  nxt line remarked out, following line added
 ;I $D(ABSP(9002313.0201)) D
 I $G(ABSP(9002313.0201))'="" D
 . S $P(^ABSPC(ABSP(9002313.02),400,ABSP(9002313.0201),320),U,7)=ABSP("X")
 ;
 Q
 ;
 ;----------------------------------------------------------------
 ;For subroutines FLD439, FLD440, FLD441:
 ; These field were single entry fields in 3.2, but are now
 ; a part of the NCPDP 5.1 DUR/PPS repeating segment.  The
 ; calls to these subroutines are initiated by their respective
 ; fields in the set logic of the ABSP NCPDP Field Def entry.
 ; ABSP51 and DUR will be set in ABSPOSHF subroutine DURPPS
 ;----------------------------------------------------------------
FLD439 ;Reason for service code
 ;IHS/OIT/CASSEVERN/PIERAN/RAN 4/22/2011 patch 42 3.2 NO LONGER USED ABSP51 flag not needed.
 ;3.2 Set
 ;I '$G(ABSP51) S $P(^ABSPC(ABSP(9002313.02),400,ABSP(9002313.0201),430),U,9)=ABSP("X")
 ;
 ;5.1 Set
 S $P(^ABSPC(ABSP(9002313.02),400,ABSP(9002313.0201),473.01,DUR,0),U,2)=ABSP("X")
 ;
 Q
 ;
FLD440 ;Professional Service Code
 ;IHS/OIT/CASSEVERN/PIERAN/RAN 4/22/2011 patch 42 3.2 NO LONGER USED ABSP51 flag not needed.
 ;3.2 Set
 ;I '$G(ABSP51) S $P(^ABSPC(ABSP(9002313.02),400,ABSP(9002313.0201),430),U,10)=ABSP("X")
 ;
 ;5.1 Set
 S $P(^ABSPC(ABSP(9002313.02),400,ABSP(9002313.0201),473.01,DUR,0),U,3)=ABSP("X")
 ;
 Q
 ;
FLD441 ;Result of Service Code
 ;IHS/OIT/CASSEVERN/PIERAN/RAN 4/22/2011 patch 42 3.2 NO LONGER USED ABSP51 flag not needed.
 ;3.2 Set
 ;I '$G(ABSP51) S $P(^ABSPC(ABSP(9002313.02),400,ABSP(9002313.0201),440),U,1)=ABSP("X")
 ;
 ;5.1 Set
 S $P(^ABSPC(ABSP(9002313.02),400,ABSP(9002313.0201),473.01,DUR,0),U,4)=ABSP("X")
 ;
 Q
 ;
FLD473 ;DUR/PPS code counter - called from set logic in ABSP NCPDP Field Defs
 ; repeating field on the DUR/PPS 5.1 segment - 
 ; Since this is the .01 field - we also need to set the cross ref
 ; here as well 
 ;
 S $P(^ABSPC(ABSP(9002313.02),400,ABSP(9002313.0201),473.01,DUR,0),U,1)=ABSP("X")
 S ^ABSPC(ABSP(9002313.02),400,ABSP(9002313.0201),473.01,"B",ABSP("X"),DUR)=""
 ;
 Q
 ;
 ;------------------------------------------------------------------
 ; Set logic for flds 474, 475 and 476 move to this routine to 
 ; avoid the wrapping within the global which has been known to 
 ; split when installed on certain systems.
 ;------------------------------------------------------------------
FLD474 ;DUR/PPS level of effort - called from set logic in ABSP NCPDP Field
 ; Defs repeating field on the DUR/PPS 5.1 segment
 ;
 S $P(^ABSPC(ABSP(9002313.02),400,ABSP(9002313.0201),473.01,DUR,0),U,5)=ABSP("X")
 ;
 Q
 ;
FLD475 ;DUR Co-agent ID Qualifier - called from set logic in ABSP NCPDP Field
 ; Defs repeating field on the DUR/PPS 5.1 segment
 ;
 S $P(^ABSPC(ABSP(9002313.02),400,ABSP(9002313.0201),473.01,DUR,0),U,6)=ABSP("X")
 ;
 Q
 ;
FLD476 ;DUR Co-agent ID - called from set logic in ABSP NCPDP Field
 ; Defs repeating field on the DUR/PPS 5.1 segment
 ;
 S $P(^ABSPC(ABSP(9002313.02),400,ABSP(9002313.0201),473.01,DUR,0),U,7)=ABSP("X")
 ;
 Q
