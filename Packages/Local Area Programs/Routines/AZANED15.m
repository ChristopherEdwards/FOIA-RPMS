BMENED15 ; IHS/PHXAO/TMJ - -- Billing ; [ 06/11/03  3:35 PM ]
 ;Revised version of AZAMED12.  Daily rate increased from $233.00 to
 ; $241.00 beginning Jan 1,1997
 ;
A ; -- driver
 ;G ^AZAMEDNO  ;IHS/ANMC/FBD-6/17/97-ADDED LINE
 D BD I BD<1 D Q Q
 D ED I ED<1 D Q Q
 D TN I $D(DIRUT) D Q Q
 D LV Q
 ;
BD ; -- beginning date
 S %DT="AEQ",%DT("A")="Select beg date: ",X="" D ^%DT S BD=Y-.0001 Q
 ;
ED ; -- end date
 S %DT="AEQ",%DT("A")="Select end date: ",X="" D ^%DT S ED=Y+.9999 Q
 ;
TN ; -- transmittal number
 N DIR,X,Y S DIR(0)="F^5:10",DIR("A")="Enter Transmittal Number"
 D ^DIR S T=Y Q
 ;
LV ; -- loop visits
 S VDT=BD F  S VDT=$O(^AUPNVSIT("B",VDT)) Q:'VDT  Q:VDT>ED  D
 . S IEN=0 F  S IEN=$O(^AUPNVSIT("B",VDT,IEN)) Q:'IEN  D
 .. S N=$G(^AUPNVSIT(IEN,0)) Q:'N  Q:$P(N,U,11)  Q:$P(N,U,6)'=DUZ(2)
 .. S DFN=$P(N,U,5) Q:'DFN
 .. Q:$P(N,U,8)=36  ;dental
 .. ;Q:$$CB'=1       ;non indian beneficiary
 .. I $$MCD,'$$PRV,'$$DS,'$$URC,'$$AV,'$$MCR,'$$INP,$$ICD'="" D 1
 Q
 ;
1 ; -- create entry       
 N DIC,DINUM,X,DR,DIE,DA,ICD K DD,DO
 S DIC="^DIZ(1115238,",DIC(0)="L",(DINUM,X)=IEN
 S DIC("DR")=".02////3;.03////^S X=DFN" D FILE^DICN
 ; -- stuff additional fields
 S DIE=DIC,DA=IEN
 S DR=".04///^S X=$$ICD^AZAMED8;.05////^S X=$P(N,U,8)"
 S DR=DR_";.06////^S X=$$ES^AZAMED8;.07////^S X=$$CB^AZAMED8"
 ;S DR=DR_";.08////^S X=$P(N,U,7);.09///^S X=""147.00"""
 ;S DR=DR_";.08////^S X=$P(N,U,7);.09///^S X=""159.00""" ;SFB 2/1/95
 S DR=DR_";.08////^S X=$P(N,U,7);.09///^S X=""241.00""" ;IHS/ANMC/FBD-2/13/97
 S DR=DR_";.11////^S X=$$MCDC^AZAMED8;.12////^S X=$$MCDN^AZAMED8"
 ;S DR=DR_";.13////^S X=T;.14////^S X=DT;.15///^S X=$$HRCN^ADGF"  ;IHS/ANMC/FBD-6/24/96-CHANGED ^DGZF RTN REF TO ^ADGF
 S DR=DR_";.13////^S X=T;.14////^S X=DT;.15///^S X=$$HRCN^AZAMED"  ;IHS/ANMC/LJF 1/21/99 keep calls within namespace
 ;S DR=DR_";.18////^S X=$$P"  ;IHS/ANMC/CLS 10/12/95
 D ^DIE Q
 ;
MCDC() ; -- medicaid eligibility code
 Q $P($G(^AUPNMCD(+$$MCDI,11,+$$MCDM,0)),U,3)
 ;
MCDN() ; -- medicaid eligibility number
 Q $P($G(^AUPNMCD(+$$MCDI,0)),U,3)
 ;
MCDI() ; -- medicaid eligible ien
 Q $O(^AUPNMCD("B",DFN,0))
 ;
MCDM(X,Y) ; -- medicaid eligible multiple ien
 S (Y,X)=0 F  S X=$O(^AUPNMCD(+$$MCDI,11,X)) Q:'X  D  Q:Y
 . S Y=$G(^AUPNMCD(+$$MCDI,11,+X,0))
 . S:Y Y=$S($P(Y,U,2)>VDT:1,'$P(Y,U,2):1,1:0)
 Q X
 ;
 ;Q $O(^AUPNMCD(+$$MCDI,11,VDT),-1)
 ;
MCDE() ; -- medicaid eligible end date
 Q $P($G(^AUPNMCD(+$$MCDI,11,+$$MCDM,0)),U,2)
 ;
MCD(X,Y) ; -- medicaid eligible
 S (Y,X)=0 F  S X=$O(^AUPNMCD(+$$MCDI,11,X)) Q:Y  Q:'X  D
 . S Y=$G(^AUPNMCD(+$$MCDI,11,+X,0))
 . S:Y Y=$S($P(Y,U,2)>VDT:1,'$P(Y,U,2):1,1:0)
 Q Y
 ;
 ;Q $S($$MCDE>VDT:1,1:0)
 ;
URC() ; -- urc billing file
 Q $O(^DIZ(1115238,"B",IEN,0))
 ;
MCRI() ; -- medicare eligible ien
 Q $O(^AUPNMCR("B",DFN,0))
 ;
MCRM() ; -- medicare eligible multiple ien
 Q $O(^AUPNMCR(+$$MCRI,11,VDT),-1)
 ;
MCRE() ; -- medicare eligible end date
 Q $P($G(^AUPNMCR(+$$MCRI,11,+$$MCRM,0)),U,2)
 ;
MCRB() ; -- medicare eligible eligibility
 Q $P($G(^AUPNMCR(+$$MCRI,11,+$$MCRM,0)),U,3)
 ;
MCR() ; -- medicare eligible
 Q $S($$MCRE>VDT:1,$$MCRB="B":1,($$MCRM&'$$MCRE):1,1:0)
 ;
INP() ; -- inpatient
 Q $S('$$INPI:0,$P(VDT,".")<$P($$INPV,"."):0,$P(VDT,".")>$P($$INPD,"."):0,1:1)
 ;
INPD() ; -- inpatient discharge date
 Q +$G(^AUPNVINP(+$$INPI,0))
 ;
INPV() ; -- inpatient visit date
 Q +$G(^AUPNVSIT(+$P($G(^AUPNVINP(+$$INPI,0)),U,3),0))
 ;
INPI() ; -- inpatient ien
 Q $O(^AUPNVINP("AA",+DFN,+$O(^AUPNVINP("AA",+DFN,$$ID($P(VDT,"."))),-1),0))
 ;
ID(X) ; -- inverse date
 Q 9999999-X
 ;
ICD() ;
 N ICD,FLG,IFN S (ICD,FLG,IFN)=""
 F  S IFN=$O(^AUPNVPOV("AD",IEN,IFN)) Q:'IFN  Q:FLG  D
 . S ICD=$P($G(^ICD9(+$G(^AUPNVPOV(+IFN,0)),0)),U)
 . I ICD=".0860" S ICD="" Q
 . I ICD=799.90 S ICD="" Q
 . I ICD D  S FLG=+ICD Q:FLG
 .. I ICD>302.99,ICD<303.90 S ICD="" Q
 .. I ICD>303.90,ICD<303.94 S ICD="" Q
 .. I ICD>303.99,ICD<305.04 S ICD="" Q
 .. I ICD>305.29,ICD<305.54 S ICD="" Q
 .. I ICD>305.69,ICD<305.94 S ICD="" Q
 .. I '$$U21,ICD>369.99,ICD<390.00 S ICD="" Q  ;effective 9/1/94
 . Q:'$P(ICD,"V",2)
 . I $O(^DIZ(1115233,"B",$P(ICD,"V",2),0)) S FLG=1 Q
 . I $P(ICD,"V",2)>01.00,$P(ICD,"V",2)<20.00 S FLG=1 Q
 . I $P(ICD,"V",2)>21.99,$P(ICD,"V",2)<38.00 S FLG=1 Q
 . I $P(ICD,"V",2)>72.19,$P(ICD,"V",2)<77.80 S FLG=1 Q  ;changed 9/1/94
 . I $P(ICD,"V",2)>78.99,$P(ICD,"V",2)<83.00 S FLG=1 Q
 . I $$U21,$P(ICD,"V",2)>20.00,$P(ICD,"V",2)<22.00 S FLG=1 Q
 . I $$U21,$P(ICD,"V",2)>70.00,$P(ICD,"V",2)<71.00 S FLG=1 Q
 . I $$U21,$P(ICD,"V",2)>71.99,$P(ICD,"V",2)<72.01 S FLG=1 Q  ;eff 9/1
 . I $$U21,$P(ICD,"V",2)>77.99,$P(ICD,"V",2)<78.99 S FLG=1 Q
 . S ICD=""
 Q ICD
 ;
DT(Y) ;
 X ^DD("DD") Q Y
 ;
U21() ; -- under 21 years of age
 N X,X1,X2 S X1=DT,X2=$P(^DPT(DFN,0),U,3) D ^%DTC 
 Q $S((X\365.25)<21:1,1:0)
 ;
DS() ; -- day surgery
 Q $S($P($G(^AUPNVSIT(IEN,0)),U,7)="S":1,1:0)  ;IHS/ANMC/LJF 1/21/99
 ;Q $O(^ADGDS("AD",DFN,$P(VDT,"."),0))  we don't use ^ADGDS anymore
 ;Q $S($P(N,U,8)'=65:0,$O(^AUPNVPRC("AD",IEN,0)):1,1:0)
 ;
ES() ; -- eligibility status
 Q $P($G(^AUPNPAT(+DFN,11)),U,12)
 ;
CB() ; -- classification/beneficiary
 Q $P($G(^AUPNPAT(+DFN,11)),U,11)
 ;
P() ; -- provider
 Q +$G(^AUPNVPRV(+$O(^AUPNVPRV("AD",+N,0)),0))
 ;
PRVI() ; -- private insurance
 Q $O(^AUPNPRVT("B",DFN,0))
 ;
PRVM() ; -- private insurance eligible multiple ien
 Q $O(^AUPNPRVT(+$$PRVI,11,VDT),-1)
 ;
PRVE() ; -- private insurance eligible end date
 Q $P($G(^AUPNPRVT(+$$PRVI,11,+$$PRVM,0)),U,2)
 ;
PRVX() ; -- private insurance eligible
 Q $S($$PRVE>VDT:1,($$PRVM&'$$PRVE):1,1:0)
 ;
AV(X,Y) ; -- visit same day
 S (Y,X)=0 F  S X=$O(^DIZ(1115238,"AV",DFN,$P(VDT,"."),X)) Q:Y  Q:'X  D
 . S Y=$G(^DIZ(1115238,X,0)) S:Y Y=$S($P(Y,U,21):0,1:1)
 Q Y
 ;
Q ; -- cleanup
 K BD,ED,T,DFN,VDT,DIRUT,N,IEN Q
 ;
PRV() ;
 N N,X,Y S (X,Y)=0 F  S X=$O(^AUPNPRVT(DFN,11,X)) Q:'X  D
 . S N=^AUPNPRVT(DFN,11,X,0) Q:$P(N,U,6)>VDT
 . I $P(N,U,7),$P(N,U,7)<VDT Q
 . S Y=1
 Q Y
