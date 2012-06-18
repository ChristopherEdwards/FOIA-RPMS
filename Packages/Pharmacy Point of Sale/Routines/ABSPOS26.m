ABSPOS26 ; IHS/FCS/DRS - put insurance in order ;   
 ;;1.0;PHARMACY POINT OF SALE;;JUN 21, 2001
 ; these are most of the rules implementations
 ; called from ABSPOS25
 Q
 ; 
 ;  SEARHC set up notes for their conversion:
 ;  * give BENEFICIARY MEDICAL PLAN a huge 
 ;       DELTA FROM BASE PRIORITY score in 9002313.4
 ;  * Mark MEDICARE as not billable
 ;  * Set up the rules in the table
 ;  * Testing
 ;
 ; Utilities - most deal with pointer into ARRAY(N)
INSIEN(N)          Q $P(ARRAY(N),U)
INSTYPE(N)         Q $P($P(ARRAY(N),U,2),",")
COMBREC(N)         Q ^ABSPCOMB(ABSBPATI,1,$P(ARRAY(N),U,3),0) ; copy of record
FINDTYPE(TYPE)      ;EP - from ABSPOS28
 I TYPE="SELF" S TYPE="SELF PAY"
 N I,RET,N S (I,RET)=0
 F I=1:1:ARRAY(0) D  Q:RET
 . I $$INSTYPE(I)=TYPE S RET=I
 Q RET
WCINS(N)        ; what kind of workers comp is this one?
 ; returns ONLY (wc only), BOTH (doesn't matter), NEVER (no wc claims)
 N X S X=$P($G(^ABSPEI($$INSIEN(N),107)),U)
 I X="",$P($G(^AUTNINS($$INSIEN(N),2)),U)="W" S X="ONLY"
 I X="" S X="BOTH"
 Q X
PHOLDER(N)         Q $P($$COMBREC(N),U,7) ; returns pointer to ^AUPN3PPH
THRUEMPL(N)        N X S X=$$PHOLDER(N) I 'X Q 0
 Q $P($G(^AUPN3PPH(X,0)),U,16) ; pointer to employer (as truth value)
PHOLDDOB(N)         N X S X=$$PHOLDER(N) I 'X Q 0
 Q $P($G(^AUPN3PPH(X,0)),U,19) ; policy holder's date of birth
RELATION(N)        ; return relationship (text)
 N X S X=$P($$COMBREC(N),U,11) I X="" Q "SELF"
 S X=$P($G(^AUTTRLSH(X,0)),U) I X="" Q "SELF"
 Q X
ISSPOUSE(N)        N X S X=$$RELATION(N)
 Q X["SPOUSE"!(X="HUSBAND")!(X="WIFE")
ISCHILD(N)         N X S X=$$RELATION(N)
 I X="SON"!(X="DAUGHTER")!(X="CHILD") Q 1
 I X="STEP CHILD"!(X="NATURAL CHILD") Q 1
 Q 0
ISSELF(N)          Q $$RELATION(N)="SELF"
ISBEN() ; Is ABSBPATI a "Beneficiary" according to local definition?
 Q $D(^ABSP(9002313.99,1,"WRITE OFF SELF PAY","B",$$AUTTBEN(ABSBPATI)))
PTS(N) Q $P(ARRAY(N),U,4)
PTSSET(N,POINTS)   S $P(ARRAY(N),U,4)=POINTS Q
PTSADD(N,DELTA)    D PTSSET(N,$$PTS(N)+DELTA) Q
PTSSUB(N,DELTA)    D PTSADD(N,-DELTA) Q
RULESET(N,RULE)         N X S X=$P(ARRAY(N),U,5) S:X]"" X=X_";"
 S X=X_RULE,$P(ARRAY(N),U,5)=X Q
 ;
 ; Other utilities
AUTTBEN(PATDFN) ;EP - return beneficiary code, from ^AUPNPAT
 N AUPNPAT S AUPNPAT=$O(^AUPNPAT("B",PATDFN,0)) I 'AUPNPAT Q 0 ; imposs?
 N X S X=$P($G(^AUPNPAT(AUPNPAT,11)),U,11) ; pointer to ^AUTTBEN
 Q X
WORKREL()          ; is ABSBVISI a worker's comp visit?
 ; If so, return value is true = pointer to ^AUPNVPOV which has
 ;  the CAUSE OF DX listed as EMPLOYMENT RELATED
 N A,RET S (A,RET)=0
 F  S A=$O(^AUPNVPOV("AD",ABSBVISI,A)) Q:'A  D  Q:RET
 . I $P($G(^AUPNVPOV(A,0)),U,7)=4 S RET=A
 Q RET
 ;
 ; SEARHC0 rule, named SEARHC SPECIAL RULE 0
 ; If Medicare + Commercial Ins. + Native Ben,
 ; then it's a write-off; it shouldn't be billed to the commercial ins.
 ; Make this happen by putting SELF PAY at the front of the line -
 ; then ABSBMAKE->ABSBPB->ABSBPBRX will see SELF PAY + Native Ben
 ; and the account will go to the POS Automatic Writeoff List
 ; (Handle this as one of the RULES.)
SEARHC0(ARRAY,ABSBPATI,ABSBVISI,PTSPLUS,PTSMINUS)         ;
 Q:'$$FINDTYPE("CARE")  ; no Medicare; it doesn't apply
 Q:'$$FINDTYPE("PRVT")  ; no private coverage; rule doesn't apply
 Q:$$FINDTYPE("CAID")  ; has Medicaid; rule doesn't apply
 Q:'$$ISBEN  ; not Native Beneficiary; rule doesn't apply
 N X S X=$$FINDTYPE("SELF") I 'X D  Q  ; find the Self Pay
 . D IMPOSS^ABSPOSUE("DB","TI","Missing SELF PAY in INSURER file",,"SEARHC0",$T(+0))
 D PTSSET(X,9999),RULESET(X,"SEARHC0")
 Q
 ;
 ; WORKCOMP rule, named WORKERS COMP RULE
 ;   If this is a worker's comp visit,
 ;   we might eliminate some insurances.
WORKCOMP(ARRAY,ABSBPATI,ABSBVISI,PTSPLUS,PTSMINUS)        ;
 N WCVISIT S WCVISIT=$$WORKREL ; is ABSBVISI a work-related visit?
 N WCINS
 N I F I=1:1:ARRAY(0) D
 . S WCINS=$$WCINS(I) ; what kind of worker's comp coverage here?
 . I WCINS="ONLY" D  ; insurance is ONLY for worker's comp use
 . . ; so if it's not a wcomp visit, don't pick this insurance
 . . I 'WCVISIT D PTSSET(I,-1000),RULESET(I,"WORKCOMP")
 . E  I WCINS="BOTH" D  ; do nothing, insurance doesn't care
 . E  I WCINS="NEVER" D  ; insurance will not cover worker's comp
 . . ; but it is a wcomp visit, so don't pick this insurance
 . . I WCVISIT D PTSSET(I,-1000),RULESET(I,"WORKCOMP")
 . E  D  ; should never happen
 . . D IMPOSS^ABSPOSUE("DB","TI","bad wcomp setting for insurer",WCINS,"WORKCOMP",$T(+0))
 Q
 ;
 ; NULL rule.                                ABSP*1.0T7*10 ; DRS
 ;  EMPLOYMENT BEFORE PRIVATE INS and EMPLOYMENT BEFORE SPOUSE INS
 ;  rules have been temporarily redirected here because of the 
 ;  problem with the EMPLOYER field in the POLICY HOLDER file
 ;
NULL(A,B,C,D,E) ; ABSP*1.0T7*10
 ; This rule does nothing.
 Q
 ; EMPLOY1 rule, named EMPLOYMENT OVER PRIVATE
 ;    Insurance through employment takes precedence over
 ;    insurance through private purchase.
 ;    We distinguish using the ^AUPN3PPH employer.
EMPLOY1(ARRAY,ABSBPATI,ABSBVISI,PTSPLUS,PTSMINUS) ;
 ; Insurance through employment takes precedence over
 ; insurance through private purchase
 ; Give it a plus, in the neighborhood of 10 points
 N I F I=1:1:ARRAY(0) D
 . I $$INSTYPE(I)'="PRVT" Q
 . I $$THRUEMPL(I) D
 . . Q:'PTSPLUS  D RULESET(I,"EMPLOY1"),PTSADD(I,PTSPLUS)
 . E  D
 . . Q:'PTSMINUS  D RULESET(I,"EMPLOY1"),PTSSUB(I,PTSMINUS)
 Q
 ;
 ; EMPLOY2 rule, named EMPLOYMENT BEFORE SPOUSE
 ;   If you are covered through your employment,
 ;   and also by a policy held by your spouse,
 ;   then the employment-based policy takes precedence.
 ;  Note that the employment-based policy probably already
 ;    has received a bonus, but it will get another bonus
 ;    if RELATIONSHIP TO INSURED is SELF
EMPLOY2(ARRAY,ABSBPATI,ABSBVISI,PTSPLUS,PTSMINUS)          ;
 N I F I=1:1:ARRAY(0) D
 . I $$INSTYPE(I)'="PRVT" Q
 . I $$RELATION(I)="SELF",$$THRUEMPL(I) D
 . . D PTSADD(I,PTSPLUS),RULESET(I,"EMPLOY2")
 Q
 ; SELFRULE, code for POLICY HOLDER IS SELF rule ; ABSP*1.0T7*9
SELFRULE(ARRAY,%1,%2,%3,%4) ; new with ABSP*1.0T7*9
 N I F I=1:1:ARRAY(0) D
 . I $$INSTYPE(I)'="PRVT" Q  ; ABSP*1.0T7*10
 . I $$RELATION(I)="SELF" D PTSADD(I,PTSPLUS),RULESET(I,"SELFRULE")
 Q
 ;
 ; BIRTHDAY rule, named BIRTHDAY RULE
BIRTHDAY(ARRAY,ABSBPATI,ABSBVISI,PTSPLUS,PTSMINUS)         ;
 ;  If the patient is a child and both parents cover the
 ;   child through their work, the parent whose birthday falls 
 ;   first within the calendar year's insurance is primary and
 ;   the other parent's insurance is secondary.  "The birthday rule".
 ;   [law]
 ; Problem:  we have no idea when the parents' birthdays are.
 ; There's no guarantee that they are in our patient file.
 N I F I=1:1:ARRAY(0) D
 . Q:$$INSTYPE(I)'="PRVT"  ; private insurance 
 . Q:'$$THRUEMPL(I)  ; insured through employer's policy
 . Q:'$$ISCHILD(I)  ; child of the policy holder
 . ; Slick trick:  we award PTSPLUS scaled according to when the
 . ; birthday occurs.  If birthday is not on file, default to midyear
 . ; Jan 1 gets entire PTSPLUS amount, Dec 31 gets about 8.2% of it
 . N X S X=$$PHOLDDOB(I),X=$E(X,4,7) S:X="" X="0631" ; no June 31st
 . D PTSADD(I,1-(X-0101/1231)*PTSPLUS*1000\1/1000)
 . D RULESET(I,"BIRTHDAY")
 Q
