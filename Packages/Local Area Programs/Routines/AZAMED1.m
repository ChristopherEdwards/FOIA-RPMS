AZAMED1 ; IHS/PHXAO/TMJ - MEDICAID TAPE TO ELIG FILE ; [ 06/12/03  2:38 PM ]
 ;
 N IFN,DFN,IEN,EED,EBD,CT,NUM,SEX,N,NAME S STOP=""
A ; -- loop medicaid tape data
 S IFN=0 F  S IFN=$O(^AZAGMED(IFN)) Q:'IFN  Q:STOP=10  D
 . S N=^AZAGMED(IFN),SSN=$E(N,27,35) Q:'SSN
 . S DFN=$O(^DPT("SSN",SSN,0)) Q:'DFN  
 . S NAME=$P(^DPT(DFN,0),U),SEX=$P(^(0),U,2)
 . S NUM=$E(N,18,26),EED=$$EED,EBD=$$EBD,CT=$E(N,91,92)
 . Q:EED<$$EHIS  
 . I '$O(^AUPNMCD("B",DFN,0)) W !,NAME S STOP=STOP+1
 Q
 ;
MED ; -- add eligiblity date(s)/data
 S IEN=$O(^AUPNMCD("B",DFN,0)) D:'IEN NEW Q:'IEN
 S:'$D(^AUPNMCD(IEN,11,0)) $P(^(0),U,2)="9000004.11D"
 Q:$D(^AUPNMCD(IEN,11,EBD))
 S DIE="^AUPNMCD("_IEN_",11,",DA(1)=IEN,DA=EBD
 S DR=".01////"_EBD_";.02////"_EED_";.03////"_CT D ^DIE K DIE,DR,DA
 Q
 ;
NEW ; -- create new entry in medicaid eligible
 N X,Y S X=DFN,DIC="^AUPNMCD(",DIC(0)="L"
 S DIC("DR")=".02////3;.03////"_NUM_";.04////2;.05////"_NAME
 S DIC("DR")=DIC("DR")_";.07////"_SEX
 D FILE^DICN S IEN=+Y K DIC
ENEW Q
 ;
EED() ; -- eligibility end date
 N X,Y S X=$E(N,412,419) D ^%DT Q Y
 ;
EBD() ; -- eligibility beg date
 N X,Y S X=$E(N,347,354) D ^%DT Q Y
 ;
EHIS() ; -- eligibility history flag
 N X1,X2,X S X1=DT,X2=-180 D C^%DTC Q X
