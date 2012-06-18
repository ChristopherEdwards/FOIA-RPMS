BLRALFN1 ;DAOU/ALA-Lab ES Functions [ 11/18/2002  1:36 PM ]
 ;;5.2;LR;**1013,1015**;NOV 18, 2002
 ;
 ;**Program Description**
 ;  This program contains three functions for the Lab
 ;  Electronic Signature modification; SIGN, REVIEW, and
 ;  UNSIGN.
 ;
SIGN ;  Physician is signing
 ;I VALMLST<VALMCNT S VALMSG="YOU MUST SIGN ON THE LAST PAGE" D RE^VALM4 Q  ; FIX #46
 I VALMLST<VALMCNT D
 . W !!,"**WARNING! You must sign on the last page.**"
 . N DIR,X,Y
 . S DIR(0)="E",DIR("T")=10,DIR("A")="Press return to continue " D ^DIR
 . I Y>0 S BLRASFL=1 D RE^VALM4 Q
 ;
 ;  Set the date/time signed to the current date/time
 S BLRASDTM=$$NOW^XLFDT()
 S BLRADATA=$G(^LR(LRDFN,LRSS,LRIDT,9009027))
 ;
 ;  Kill off the old cross-reference and set new one
 S BLRARPHY=$P(BLRADATA,U,2),BLRARFL=$P(BLRADATA,U,1)
 ;
 ; Check for pending results flag
 S BLRAPND=+$P(BLRADATA,U,7)
 I BLRAPND D EN^DDIOL("You cannot sign for a result with pending results","","!!") Q
 ;
 D KX^BLRALUT1
 ;
 ;  Set result flag to 'Reviewed, signed'
 S BLRARFL=$S($G(BLRASFL)'="":BLRASFL,1:2)
 D SX^BLRALUT1
 ;
 S $P(BLRADATA,U,1)=BLRARFL,$P(BLRADATA,U,3)=DUZ,$P(BLRADATA,U,5)=BLRASDTM
 ;
 S ^LR(LRDFN,LRSS,LRIDT,9009027)=BLRADATA
 ;
 K BLRADATA,BLRARPHY,BLRARFL,BLRASDTM,BLRAPND,BLRASFL
 ;
 Q
 ;
REVW ;EP
 ;  Physician is reviewing only
 ;  Set audit for review
 I $G(DFN)="" S DFN=$P($G(^LR(LRDFN,0)),U,3)
 S BLRAACN=$P($G(^LR(LRDFN,LRSS,LRIDT,0)),U,6)
 D ^BLRALAU
 ;
 ; Set the date/time reviewed to the current date/time
 S BLRARDTM=$$NOW^XLFDT()
 S BLRADATA=$G(^LR(LRDFN,LRSS,LRIDT,9009027))
 ;
 ;  Kill off the old cross-reference and set new one
 S BLRARPHY=$P(BLRADATA,U,2),BLRARFL=$P(BLRADATA,U,1)
 ;
 ;  If already signed, quit
 I BLRARFL=2 K BLRARDTM,BLRADATA,BLRARPHY,BLRARFL Q
 D KX^BLRALUT1
 ;
 ;  Set result flag to 'Reviewed, not signed'
 S BLRARFL=1
 D SX^BLRALUT1
 ;
 ;  Set the date/time reviewed
 S $P(BLRADATA,U,1)=BLRARFL,$P(BLRADATA,U,4)=BLRARDTM
 S ^LR(LRDFN,LRSS,LRIDT,9009027)=BLRADATA
 ;
 K BLRADATA,BLRARPHY,BLRARFL,BLRARDTM,BLRAACN
 Q
 ;
UNSIG ;  Unsign a lab result
 I VALMLST<VALMCNT Q
 ;  Ask if need to unsign result
 S DIR("A")="DO YOU NEED TO UNSIGN THIS RESULT",DIR(0)="Y",DIR("B")="NO"
 D ^DIR
 K DIR
 I $G(Y)'=1 Q
 I $G(DIRUT)=1 K DIRUT Q
 ;
 S BLRADATA=$G(^LR(LRDFN,LRSS,LRIDT,9009027))
 ;
 ;  Kill off the old cross-reference and set new one
 S BLRARPHY=$P(BLRADATA,U,2),BLRARFL=$P(BLRADATA,U,1)
 D KX^BLRALUT1
 ;
 ;  Set result flag from 'Reviewed, signed' to 'Reviewed, not signed'
 I BLRARFL=2 S BLRARFL=1
 D SX^BLRALUT1
 ;
 ;  Clear out the date/time signed and signing physician
 S $P(BLRADATA,U,1)=BLRARFL,$P(BLRADATA,U,3)="",$P(BLRADATA,U,5)=""
 S ^LR(LRDFN,LRSS,LRIDT,9009027)=BLRADATA
 ;
 K BLRADATA,BLRARPHY,BLRARFL
 ;
 Q
