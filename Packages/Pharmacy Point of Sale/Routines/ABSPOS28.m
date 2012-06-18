ABSPOS28 ; IHS/FCS/DRS - test of insurance selection ; 
 ;;1.0;PHARMACY POINT OF SALE;**10**;JUN 21, 2001
 ;------------------------------------------------
 ;IHS/SD/lwj 03/10/04 patch 10
 ; Routine adjusted to call ABSPFUNC to retrieve
 ; the Prescription Refill NDC value.  At some
 ; point the call needs to be modified to call APSPFUNC.
 ; See ABSPFUNC for details on why call was done.
 ;------------------------------------------------
 Q
 ; development utility
TEST1(N,M,DEBUG) ; look through some prescriptions and see what you get   
 ; Stores copies of ARRAY(*) in ^TMP($J,
 ; See FIND* utilities below for help in searching ^TMP($J,
 ;    for instances of interesting things.
 ; look at N prescrips ; optionally start M from end
 ; S DEBUG=1
 N ABSBRXI,ABSBRXR,ABSBVISI,ABSBPATI,ABSBNDC,ABSBVMED
 K ^TMP($J)
 S ABSBRXI="A"
 I $G(M) F IJK=1:1:M S ABSBRXI=$O(^PSRX(ABSBRXI),-1) ; skip a bit
 N IJK F IJK=1:1:N D
 . I IJK#100=0,'$G(DEBUG) W IJK," " W:$X>70 !
 . S ABSBRXI=$O(^PSRX(ABSBRXI),-1) Q:'ABSBRXI
 . S ABSBRXR=$O(^PSRX(ABSBRXI,1,"A"),-1) S:ABSBRXR="" ABSBRXR=0
 . ;IHS/SD/lwj 03/10/04 patch 10, nxt line rmkd out, new line added
 . ;I ABSBRXR S ABSBNDC=$P(^PSRX(ABSBRXI,1,ABSBRXR,0),"^",13)
 . I ABSBRXR S ABSBNDC=$$NDCVAL^ABSPFUNC(ABSBRXI,ABSBRXR)  ;patch 10
 . E  S ABSBNDC=$P(^PSRX(ABSBRXI,2),"^",7)
 . ;IHS/SD/lwj 03/10/04 patch 10 end change
 . I $G(DEBUG) D
 . . W "- - -  for RXI=",ABSBRXI,",RXR=",ABSBRXR
 . . W ", NDC=",ABSBNDC
 . . W " - - -",!
 . D TEST2
 Q
TEST2 D  ; not an entry point
 . I ABSBRXR S ABSBVMED=$P($G(^PSRX(ABSBRXI,1,ABSBRXR,999999911)),U)
 . E  S ABSBVMED=$P($G(^PSRX(ABSBRXI,999999911)),U)
 . I 'ABSBVMED W "No PCC link for ",ABSBRXI,",",ABSBRXR,! Q
 . I '$D(^AUPNVMED(ABSBVMED,0)) D  Q
 . . W "PCC link but '$D() on "
 . . D ZWRITE^ABSPOS("ABSBVMED") W !
 . S ABSBVISI=$P(^AUPNVMED(ABSBVMED,0),U,3)
 . S ABSBPATI=$P(^PSRX(ABSBRXI,0),U,2)
 . N ARRAY D INSURER^ABSPOS25(.ARRAY)
 . ; today, we're looking for cases with more than 1 private insurance
 . M ^TMP($J,ABSBPATI,ABSBRXI,ABSBRXR)=ARRAY
 . I $G(DEBUG) D ZWRITE^ABSPOS("ARRAY")
 Q
TEST3 ; Look through 9002313.59 entries
 S ABSBRXI="A"
 F  S ABSBRXI=$O(^ABSPT(ABSBRXI),-1) Q:'ABSBRXI  D
 . S ABSBRXR=$P(^ABSPT(ABSBRXI,1),U)
 . D TEST2
 Q
TEST4(PCNDFN)      ;
 I PCNDFN?1N.N1"."1N.N1A D  Q  ; well, okay, we'll do a VCN too
 . N VCN,X S VCN=PCNDFN,X=""
 . F  S X=$O(^ABSBITMS(9002302,"V",VCN,PCNDFN)) Q:'PCNDFN  D
 . . W "VCN ",VCN,", PCNDFN ",PCNDFN,!
 . . D TEST4(PCNDFN)
 I $L(PCNDFN,"-")=3 D  Q
 . N PCN,X S PCN=PCNDFN,PCNDFN=$O(^ABSBITMS(9002302,"B",PCNDFN,0))
 . W "PCN ",PCN,", PCNDFN ",PCNDFN,!
 . D TEST4(PCNDFN)
 N ABSBVISI S ABSBVISI=$P(^ABSBITMS(9002302,PCNDFN,1,1,0),U,3)
 W "Visit date: ",$P(^AUPNVSIT(ABSBVISI,0),U),!
 N ABSBPATI S ABSBPATI=$P(^ABSBITMS(9002302,PCNDFN,0),U,2)
 W "Last registration update: ",$P(^AUPNPAT(ABSBPATI,0),U,3),!
 N ABSBRXI,ABSBRXR S (ABSBRXI,ABSBRXR)=0
 N ARRAY D INSURER^ABSPOS25(.ARRAY,1,99)
 ;ZW ARRAY
 N COMB M COMB=^ABSPCOMB(ABSBPATI,1) D ZWRITE^ABSPOS("COMB")
 N INSCOV1 M INSCOV1=^ABSBITMS(9002302,PCNDFN,"INSCOV1")
 D ZWRITE^ABSPOS("INSCOV1")
 D ZWRITE^ABSPOS("ARRAY(0)")
 W $P(^DPT(ABSBPATI,0),U),!
 N A S A=0 F  S A=$O(ARRAY(A)) Q:'A  D
 . N X S X=$P(ARRAY(A),U)
 . W ARRAY(A),"     ",$P(^AUTNINS(X,0),U),!
 Q
SRH1 ; search for:  self pay ahead of others (the rule happened)
 N INSSELF,INSCAID,INSCARE D TYPES
 N A S A=0
 W "Hits: "
 F  S A=$O(^TMP($J,A)) Q:'A  D
 . I $P(^TMP($J,A,1),U)=INSSELF,$D(^TMP($J,A,2)) D
 . . ; hit!
 . . W:$X>70 !?10 W A," "
 W !
 Q
SRH2 ; search for: prvt & care & caid & ben (rule should not happen)
 N INSSELF,INSCAID,INSCARE D TYPES
 W "SRH2 misses: "
 S A=0 F  S A=$O(^TMP($J,A)) Q:'A  D
 . N X S X=$P(^TMP($J,A,1),U)
 . I X'=INSSELF,X'=INSCAID,X'=INSCARE,^TMP($J,A,"BEN"),^TMP($J,A,"CARE"),^TMP($J,A,"CAID") D
 . . ; hit!
 . . W:$X>70 !?10 W A," "
 W !
 Q
TYPES ;
 S INSSELF=$O(^AUTNINS("B","SELF PAY",""))
 S INSCAID=$O(^AUTNINS("B","MEDICAID",""))
 S INSCARE=$O(^AUTNINS("B","MEDICARE",""))
 Q
 ; FINDxxxx in ^TMP($J,pat,rxi,rxr,n)=ARRAY(n)
FINDINIT S (ABSBPATI,ABSBRXI,ABSBRXR)="" D FINDN2
 I ABSBPATI="" W "There are no records",!
 Q
FINDNEXT S ABSBRXR=$O(^TMP($J,ABSBPATI,ABSBRXI,ABSBRXR)) Q:ABSBRXR]""
FINDN1 S ABSBRXI=$O(^TMP($J,ABSBPATI,ABSBRXI)) I ABSBRXI G FINDNEXT
FINDN2 S ABSBPATI=$O(^TMP($J,ABSBPATI)) I ABSBPATI G FINDN1
 Q  ; ABSBPATI="" means FINDNEXT has reached the end
FIND1 ; find records that have two BIRTHDAY rules
 S TYPE=",1," G FINDLOOP
FIND2 ; find records that have the EMPLOY2 rule
 S TYPE=",2," G FINDLOOP
FIND3 S TYPE=",3," G FINDLOOP ; SEARHC0 rule
FIND(TYPE)         G FINDLOOP ; with TYPE set  e.g.  ,2,3,
FINDLOOP D FINDINIT Q:ABSBPATI=""
 W "Searching, with TYPE=",TYPE,!
 F  D  D FINDNEXT Q:ABSBPATI=""
 . K ARRAY M ARRAY=^TMP($J,ABSBPATI,ABSBRXI,ABSBRXR)
 . K RULECT ; RULECT(rule)=count of how many times used
 . N I F I=1:1:ARRAY(0) D
 . . N %,X S X=ARRAY(I)
 . . S %=$P(ARRAY(I),U) ; point to ^AUTNINS(%
 . . S %=$P(ARRAY(I),U,2) ; PINS node
 . . S %=$P(ARRAY(I),U,3) ; point into ^AUPNPRVT multiple
 . . S %=$P(ARRAY(I),U,4) ; score
 . . S %=$P(ARRAY(I),U,5) ; rules
 . . I %]"" N J F J=1:1:$L(%,";") D
 . . . N X S X=$P(%,";",J),RULECT(X)=$G(RULECT(X))+1
 . I TYPE[",1,",$G(RULECT("BIRTHDAY"))>1 D FOUND(1)
 . I TYPE[",2,",$G(RULECT("EMPLOY2"))>0 D FOUND(2)
 . I TYPE[",3,",$G(RULECT("SEARHC0"))>0 D FOUND(3)
 W "Search done",!
 Q
FINDTYPE(TYPE)     Q $$FINDTYPE^ABSPOS26(TYPE) ; e.g. find first PRVT, 0 if none
FOUND(WHICH)       ;
 W "Found case ",WHICH,!
 D ZWRITE^ABSPOS("ABSBPATI","ABSBRXI","ABSBRXR","ARRAY")
 Q
