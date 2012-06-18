ABSPOSPX ; IHS/FCS/DRS - automatic writeoffs - criteria on form ;   [ 09/12/2002  10:18 AM ]
 ;;1.0;PHARMACY POINT OF SALE;**3**;JUN 21, 2001
 Q
 ; Continuation of ABSPOSPW - invoked indirectly by ^DIP
 ;
INCLUDE()          ; should D0 be included?
 S NINCLUDE=NINCLUDE+1
 I NINCLUDE#100=0 W "." W:$X>70 !
 N PCNDFN S PCNDFN=D0
 N VSTDFN S VSTDFN=$P($G(^ABSBITMS(9002302,PCNDFN,1,1,0)),U,3)
 N WATCH
 I +$H=58211,PCNDFN=131154!(PCNDFN=130550) S WATCH=PCNDFN
 I $G(WATCH) W "Watching ",PCNDFN,": "
 I $G(WATCH) W 4," "
 I '$$INC4 Q 0 ; age of account
 I $G(WATCH) W 5," "
 I '$$INC5 Q 0 ; date of service
 I $G(WATCH) W 1," "
 I '$$INC1 Q 0 ; insurers 
 I $G(WATCH) W 2," "
 I '$$INC2 Q 0 ; A/R type
 I $G(WATCH) W 3," "
 I '$$INC3 Q 0 ; balance, balance % of original
 I $G(WATCH) W 6," "
 I '$$INC6 Q 0 ; clinic
 I $G(WATCH) W 7," "
 I '$$INC7 Q 0 ; primary diagnosis
 I $G(WATCH) W 10," "
 I '$$INC10 Q 0 ; any payments
 I $G(WATCH) W "PASSED!",!
 Q 1
INC1() ; insurer
 I $P(PARAMS,U)=1 Q 1 ; all insurers
 N X S X=$P(^ABSBITMS(9002302,PCNDFN,0),U,3) ; AUDIT INSURER
 N IEN S IEN=$$INSIEN
 N ONLIST I IEN S ONLIST=$D(PARAMS("INS","B",IEN))
 E  S ONLIST=0
 I $P(PARAMS,U)=2 Q ONLIST ; only those on the list
 I $P(PARAMS,U)=3 Q 'ONLIST ; except those on the list
 D IMPOSS^ABSPOSUE("DB,P","TI","Bad PARAMS="_PARAMS,"piece 1","INC1",$T(+0))
 Q
INSIEN() ; Insurer IEN
 N X
 I '$D(^ABSBITMS(9002302,PCNDFN,"INSCOV1")) G OLD7
 N Y S Y=$P(^ABSBITMS(9002302,PCNDFN,0),U,4) ; internal audit insurer
 I 'Y S Y=1 ; default to #1
 ; INSIEN for new-style INSCOV1
 ; But you can't always trust the internal audit insurer! - so $GET it
 S X=$P($G(^ABSBITMS(9002302,PCNDFN,"INSCOV1",Y,1)),U,2)
 I X Q X
 ; not there?  try ^AUTNINS name lookup
 S X=$P(^ABSBITMS(9002302,PCNDFN,0),U,3)
 I X="" Q X
 Q $O(^AUTNINS("B",X,0))
OLD7 ; INSIEN for old-style INSCOV
 N Z S Z=$O(^ABSBITMS(9002302,PCNDFN,"INSCOV",Y,""))
 I Z="" Q ""
 N Z0 S Z0=^ABSBITMS(9002302,PCNDFN,"INSCOV",Y,Z,0)
 I Z="PRVT"!(Z="CAID") S X=$P(Z0,U,5)
 E  I Z="CARE"!(Z="RR") S X=$P(Z0,U,4) ; not sure about the RR
 E  S X=""
 Q X
INC2() ; a/r type
 I $P(PARAMS,U,2)=1 Q 1 ; all a/r types
 N X S X=$P(^ABSBITMS(9002302,PCNDFN,9),U,2) ; PCN TYPE
 N IEN S IEN=$O(^ABSBTYP("B",X,0))
 I 'IEN D IMPOSS^ABSPOSUE("DB,P","Bad A/R TYPE "_X,,"INC2",$T(+0))
 N ONLIST S ONLIST=$D(PARAMS("ARTYP","B",IEN))
 I $P(PARAMS,U)=2 Q ONLIST ; only those on the list
 I $P(PARAMS,U)=3 Q 'ONLIST ; except those on the list
 D IMPOSS^ABSPOSUE("DB,P","TI","Bad PARAMS="_PARAMS,"piece 1","INC1",$T(+0))
 Q ""
INC6() ; clinic
 I $P(PARAMS,U,6)=1 Q 1 ; all clinics
 I VSTDFN="" Q 1 ; should never happen
 N X S X=$P(^AUPNVSIT(VSTDFN,0),U,8)
 S ONLIST=$D(PARAMS("CLINIC","B",X))
 I $P(PARAMS,U,6)=2 Q ONLIST
 I $P(PARAMS,U,6)=3 Q 'ONLIST
 D IMPOSS^ABSPOSUE("DB,P","TI","Bad PARAMS="_PARAMS,"piece 6","INC6",$T(+0))
 Q ""
INC7() ; primary diagnosis
 I $P(PARAMS,U,7)=1 Q 1 ; any diagnosis
 N X S X=$$DIAG
 I 'X S ONLIST=0
 E  S ONLIST=$D(PARAMS("DIAG","B",X))
 I $P(PARAMS,U,7)=2 Q ONLIST
 I $P(PARAMS,U,7)=3 Q 'ONLIST
 D IMPOSS^ABSPOSUE("DB,P","TI","Bad PARAMS="_PARAMS,"pieces 7","INC7",$T(+0))
 Q ""
DIAG() ; find primary diagnosis for VSTDFN
 I VSTDFN="" Q 1 ; should never happen
 N X S X=$O(^ABSBV(VSTDFN,"FSICD9",0)) ; in V VISIT file?
 I X Q $P(^ABSBV(VSTDFN,"FSICD9",X,0),U)
 ; else look in V POV file for first one marked primary
 N IEN S IEN=0
 F  S IEN=$O(^AUPNVPOV("AD",VSTDFN,IEN)) Q:'IEN  D  Q:X
 . I $P(^AUPNVPOV(IEN,0),U,12)="P" S X=$P(^(0),U)
 Q X
INC10() ; include only if there's been a payment by current insurer
 ; useful, for example, if you want to write off Medicaid RX
 ; after getting whatever Medicaid paid
 N TYPE S TYPE=$P(PARAMS,U,11)
 I $G(WATCH) D ZWRITE^ABSPOS("TYPE")
 I 'TYPE Q 1 ; don't consider payments record
 I TYPE=1 N INSIEN S INSIEN=$$INSIEN ; insist on payment from this ins
 I $G(WATCH) D ZWRITE^ABSPOS("INSIEN")
 N RET S RET=0
 N X S X=0
 F  S X=$O(^ABSBITMS(9002302,PCNDFN,7,X)) Q:'X  D  Q:RET
 . I $G(WATCH) W "Examining payment node #",X,!
 . I TYPE=2 S RET=1 Q  ; yes, a payment, and we don't care who paid
 . I $P(^ABSBITMS(9002302,PCNDFN,7,X,0),U,3)=INSIEN S RET=1
 I $G(WATCH) D ZWRITE^ABSPOS("RET")
 Q RET
INC3() ; balance
 N MIN,MAX,PCT
 S MIN=$P(PARAMS,U,3),MAX=$P(PARAMS,U,4),PCT=$P(PARAMS,U,9)/100
 I MIN="",MAX="",PCT="" Q 1
 N BAL S BAL=$P(^ABSBITMS(9002302,PCNDFN,3),U)
 N ORIG S ORIG=$P(^ABSBITMS(9002302,PCNDFN,1,1,0),U,4)
 I $G(WATCH) D
 . D ZWRITE^ABSPOS("MIN","MAX","PCT","BAL")
 . I ORIG W "BAL/ORIG=",BAL/ORIG,!
 I 'BAL Q 0  ; shouldn't happen; zero balance account s/b inactive
 I MIN]"",BAL<MIN Q 0
 I MAX]"",BAL>MAX Q 0
 I 'PCT Q 0
 I 'ORIG Q 1 ; impossible?
 N X S X=BAL/ORIG S:X<0 X=-X S:X>1 X=1
 Q X'>PCT
INC4() ; aging date
 N X S X=$G(PARAMS("AGING DATE < THIS")) Q:'X 1
 N Y S Y=$P($G(^ABSBITMS(9002302,PCNDFN,"AGE")),U) Q:'Y 1
 Q Y<X ; true if account's aging date < specified date
INC5() ; date of service
 N X S X=$P(PARAMS,U,8) Q:'X 1 ; dates of service prior to this
 I VSTDFN="" Q 1 ; should never happen
 N Y S Y=$P($G(^AUPNVSIT(VSTDFN,0)),U) Q:'Y 1
 Q Y<X ; true if date of service < specified date
ACTIVBAT() ;EP - returns true if there's an active batch outstanding
 ; from this program's operation
 N X S X=$P($G(^ABSP(9002313.99,1,"WRITEOFF-SCREEN BATCH")),U)
 I X="" Q "" ; no batch in progress (first time program has been run)
 I '$D(^ABSBPMNT(X)) Q "" ; batch is undefined?!
 N Y S Y=$P(^ABSBPMNT(X,0),U,5) ; batch status
 I Y="R"!(Y="C") Q "" ; released or canceled, okay
 Q X ; return batch number
