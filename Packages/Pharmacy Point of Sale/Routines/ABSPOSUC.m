ABSPOSUC ; IHS/FCS/DRS - POS utilities ;     
 ;;1.0;PHARMACY POINT OF SALE;;JUN 21, 2001
 Q
 ; CATEG is used by ILC billing in ABSPOSB2
 ; Also called by several other routines
CATEG(N,WANTREV) ;EP - many
 ; given N, return category for the duplicate resolution process
 ; Can call with either N = integer IEN into 9002313.57
 ;   or N = decimal IEN into 9002313.59
 ; $G(WANTREV) = true if you care about reversals 
 ;         (that's the default if N is an IEN59)
 ; $G(WANTREV) = false if you want to ignore reversals 
 ;         (that's the default if IEN57)
 ; because billing is handled differently.
 ;
 ; Many routines rely on these exact return values; do not change them:
 ; Return values:  PAPER, E PAYABLE, E CAPTURED, E DUPLICATE,
 ;                 E REJECTED, E OTHER
 ;            and  CANCELLED (two L's) (only for 9002313.59)
 ;
 ;   E DUPLICATE - being phased out - 02/06/2001
 ;   remap to E PAYABLE or E CAPTURED, as appropriate
 ;
 ; and if you want to consider reversals, 
 ;     PAPER REVERSAL, E REVERSAL ACCEPTED, E REVERSAL REJECTED
 ;     or E REVERSAL OTHER
 ; (CORRUPT, E OTHER and E REVERSAL OTHER should never happen)
 ;
 ;
 I N<1 Q "" ; N=-1 can happen from print templates, e.g. MISSED PRESC
 N FILENUM S FILENUM=$S(N[".":9002313.59,1:9002313.57)
 I '$D(WANTREV) S WANTREV=$S(FILENUM=9002313.57:0,FILENUM=9002313.59:1)
 N RETVAL,CLAIM,RESP,REV,X,RESULT
 I '$$GET1^DIQ(FILENUM,N_",",.01) Q "CORRUPT"
 S CLAIM=$$GET1^DIQ(FILENUM,N_",",3,"I")
 S RESP=$$GET1^DIQ(FILENUM,N_",",4,"I")
 I 'CLAIM S RETVAL="PAPER" D  Q RETVAL
 . I 'WANTREV Q
 . I $$GET1^DIQ(FILENUM,N_",",403,"I") S RETVAL=RETVAL_" REVERSAL"
 ; otherwise, there is an electronic claim and you get an "E xxxxxx"
 ;S RESULT=$$GET1^DIQ(FILENUM,N_",",202)
 ;S RESULT=$G(^ABSPEC(FILENUM,N,2))
 I $$GET1^DIQ(FILENUM,N_",",302) Q "CANCELLED"
 I WANTREV S X=$$GET1^DIQ(FILENUM,N_",",401,"I") I X D  Q RETVAL
 . S RETVAL="E REVERSAL "
 . S RESP=$$GET1^DIQ(FILENUM,N_",",402,"I")
 . I 'RESP S RETVAL="E OTHER" Q
 . S X=$$RESP500^ABSPOSQ4(RESP,"I")
 . S RETVAL=RETVAL_$S(X="A":"ACCEPTED",X="R":"REJECTED",1:"OTHER")
 ; Electronic claim, don't want to consider reversal
 I 'RESP D  Q RETVAL
 . S RETVAL="E OTHER" ; electronic claim but no response?
 N RESP500 S RESP500=$$RESP500^ABSPOSQ4(RESP,"I")
 ; Give precedence to the particular response in 1000
 ;I X="R" Q "E REJECTED" ; 10/26/2000 ; Oklahoma Medicaid might give
 ; a rejected header as well as a rejected prescription therein
 ;I X'="A" Q "E OTHER" ; rejected header?  corrupt? rejected reversal?
 N POS S POS=$$GET1^DIQ(FILENUM,N_",",14)
 S X=$$RESP1000^ABSPOSQ4(RESP,POS,"I")
 I X="P"!(X="DP") Q "E PAYABLE"
 I X="D" Q "E DUPLICATE" ; SHOULD NEVER HAPPEN as of 02/06/2001
 I X="R" Q "E REJECTED"
 I X="C"!(X="DC") Q "E CAPTURED"
 ; 1000 indefinite, fall back to 500
 I RESP500="R" Q "E REJECTED"
 Q "E OTHER" ; corrupt?
