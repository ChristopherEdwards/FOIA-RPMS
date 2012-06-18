AGGWVAL1 ;VNGT/HS/ALA-Validation continued ; 05 Nov 2010  10:41 AM
 ;;1.0;PATIENT REGISTRATION GUI;;Nov 15, 2010
 ;
 ;
TBQ(X,DFN,IBQ,AGGPTCLB) ;EP - Tribal Blood Quantum
 N RTN,CLBEN
 ;
 ;Skip check if classification/beneficiary is not Indian/Alaskan Native
 S CLBEN=$O(^AUTTBEN("B","INDIAN/ALASKA NATIVE",""))  ;Get Classification IEN
 I AGGPTCLB]"",AGGPTCLB'=CLBEN S RESULT=1,MSG="" Q
 ;
 D
 . I $L(IBQ)>11!($L(IBQ)<1) K IBQ Q
 . I "NF"[$E(IBQ) S IBQ=$S($E(IBQ)="F":"FULL",1:"NONE") Q
 . I $E(IBQ)'?1N&(($E(IBQ,1,3)'="UNK")&($E(IBQ,1,3)'="UNS")) K IBQ Q
 . I $E(IBQ)="U" S IBQ=$S($E(IBQ,3)="K":"UNKNOWN",1:"UNSPECIFIED") Q
 . I IBQ'?1.4N1"/"1.5N K IBQ Q
 . I $P(IBQ,"/",1)>$P(IBQ,"/",2)!(+$P(IBQ,"/",2)=0) K IBQ Q
 . S:$P(IBQ,"/",1)=$P(IBQ,"/",2) IBQ="FULL" Q
 D
 . I $L(X)>11!($L(X)<1) K X Q
 . I "NF"[$E(X) S X=$S($E(X)="F":"FULL",1:"NONE") Q
 . I $E(X)'?1N&(($E(X,1,3)'="UNK")&($E(X,1,3)'="UNS")) K X Q
 . I $E(X)="U" S X=$S($E(X,3)="K":"UNKNOWN",1:"UNSPECIFIED") Q
 . I X'?1.4N1"/"1.5N K X Q
 . I $P(X,"/",1)>$P(X,"/",2)!(+$P(X,"/",2)=0) K X Q
 . S:$P(X,"/",1)=$P(X,"/",2) X="FULL" Q
 ;
 S RESULT=1
 ;
 I $G(X)="" S RESULT=-1,MSG="Entry not valid"
 I $G(IBQ)="" S RESULT=-1,MSG="Quantums are Inconsistent"
 ;
 ;Basic Quantum checks
 I RESULT=1,"UNKNOWN,NONE,UNSPECIFIED"[IBQ,"UNKOWN,NONE,UNSPECIFIED"'[X D
 . S MSG="Quantums are Inconsistent",RESULT=-1,CODE="AGGPTTRQ"
 ;
 I RESULT=1,X="FULL",IBQ'="FULL" D
 . S MSG="Quantums are Inconsistent",RESULT=-1,CODE="AGGPTTRQ"
 ;
 ;Check to see if main tribal quantum is greater than blood quantum
 I RESULT=1,$P($G(^AGFAC(DUZ(2),0)),U,2)="Y" S RTN=$$QUANT^AGGUL2(IBQ,X,0) I $P(RTN,U)=-1 S MSG="The Tribal Quantum cannot be greater than the Indian Blood Quantum",RESULT=-1
 ;
 ;Set up fields to revalidate
 S REVAL="AGGPTELG;AGGPTCLB;AGGPTTRI;AGGPTBLQ"
 Q
 ;
FEMP(AGGFTEMN,AGGFTNME,AGGMTEMN,AGGMTNME,DFN) ; EP = Father's Employer check
 S RESULT=1
 NEW AGE
 S AGE=$$AGE^AGGAGE(DFN)
 I AGE'<18 Q
 I $G(AGGMTNME)="",$G(AGGFTNME)="" Q
 ; If father's name exists and father's employer exists, okay
 I $$FTH(AGGFTNME,AGGFTEMN) Q
 ; if mother's name exists and mother's employer exists, okay
 I $$MTH(AGGMTNME,AGGMTEMN) Q
 ; if father's name exists
 S REVAL="AGGFTEMN;AGGFTNME;AGGMTEMN;AGGMTNME"
 I $G(AGGFTNME)'="" D  Q
 . ; If mother's name does not exist and father's employer does not exist
 . I '$$MTH(AGGMTNME,AGGMTEMN),$G(AGGFTEMN)="" S RESULT=-1,MSG="Father's Employer must be entered." Q
 ; If neither is true, error
 I '$$MTH(AGGMTNME,AGGMTEMN),'$$FTH(AGGFTNME,AGGFTEMN) D
 . I $G(AGGFTNME)="",$G(AGGMTNME)'="" Q
 . S RESULT=-1,MSG="Mother or Father's Employer must be entered." Q
 Q
 ;
MEMP(AGGMTEMN,AGGMTNME,AGGFTNME,AGGFTEMN,DFN) ; EP = Mother's Employer check
 S RESULT=1
 NEW AGE
 S AGE=$$AGE^AGGAGE(DFN)
 I AGE'<18 Q
 I $G(AGGMTNME)="",$G(AGGFTNME)="" Q
 ; if mother's name exists and mother's employer exists, okay
 I $$MTH(AGGMTNME,AGGMTEMN) Q
 ; If father's name exists and father's employer exists, okay
 I $$FTH(AGGFTNME,AGGFTEMN) Q
 ; if mother's name exists
 S REVAL="AGGMTEMN;AGGMTNME;AGGFTNME;AGGFTEMN"
 I $G(AGGMTNME)'="" D  Q
 . I '$$FTH(AGGFTNME,AGGFTEMN),$G(AGGMTEMN)="" S RESULT=-1,MSG="Mother's Employer must be entered." Q
 ; If neither is true, error
 I '$$MTH(AGGMTNME,AGGMTEMN),'$$FTH(AGGFTNME,AGGFTEMN) D
 . I $G(AGGMTNME)="",$G(AGGFTNME)'="" Q
 . S RESULT=-1,MSG="Mother or Father's Employer must be entered." Q
 Q
 ;
FTH(AGGFTNME,AGGFTEMN) ; EP
 I $G(AGGFTNME)="",$G(AGGFTEMN)="" Q 0
 I $G(AGGFTNME)'="",$G(AGGFTEMN)'="" Q 1
 Q 0
 ;
MTH(AGGMTNME,AGGMTEMN) ; EP
 I $G(AGGMTNME)="",$G(AGGMTEMN)="" Q 0
 I $G(AGGMTNME)'="",$G(AGGMTEMN)'="" Q 1
 Q 0
