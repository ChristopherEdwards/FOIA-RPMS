APCD3MG ; IHS/CMI/LAB - install and generate HL7 messages to 3M ;
 ;;2.0;IHS PCC SUITE;;MAY 14, 2009
 ;
 ;
OK3M(V) ;EP - check visit for 3M
 I '$G(V) Q "1^No visit ien passed"
 I '$D(^AUPNVSIT(V,0)) Q "2^Invalid Visit passed"
 I $P(^AUPNVSIT(V,0),"^",11) Q "3^Deleted visit passed"
 I '$P(^AUPNVSIT(V,0),"^",9) Q "4^Visit has no dependent entries"
 ;I '$D(^AUPNVPOV("AD",V)) Q "5^No POV for this visit"
 ;check all POVs for provider narrative
 ;NEW X,% S (X,%)=0 F  S X=$O(^AUPNVPOV("AD",V,X)) Q:X'=+X  I $P(^AUPNVPOV(X,0),"^",4)="" S %="6^No Provider Narrative on POV "_X
 S U="^"
 ;I % Q %
 ;NEW F S (F,X,%)=0 F  S X=$O(^AUPNVPOV("AD",V,X)) Q:X'=+X!(F)  I $$VAL^XBDIQ1(9000010.07,X,.01)=".9999",$P(^AUPNVPOV(X,0),"^",18)="" S F=1
 ;I 'F Q "13^No VPOV's with a .9999 diagnosis."
 NEW P S P=$P(^AUPNVSIT(V,0),"^",5)
 I 'P Q "7^No patient entered"
 I '$D(^DPT(P)) Q "8^Invalid DPT entry"
 I $P(^DPT(P,0),"^",2)="" Q "9^Sex of patient missing"
 I $P(^DPT(P,0),"^",3)="" Q "10^DOB of patient missing"
 NEW % S %="" D HOSPCHK I % Q %
 Q 0
HOSPCHK ;
 Q:$P(^AUPNVSIT(V,0),"^",7)'="H"
 I '$D(^AUPNVINP("AD",V)) S %="11^No V HOSPITALIZATION Entry" Q
 NEW H S H=$O(^AUPNVINP("AD",V,""))
 I $P(^AUPNVINP(H,0),"^",6)="" S %="12^No discharge type entered on Hospitalization" Q
 Q
 ;
GEN(APCDV) ;EP - generate HL7 message outbound to 3M
 K APCDHL7M
 S %=$$OK3M(APCDV) I $P(%,"^") S APCD3MER=% Q
 NEW % S %=$$OK3M(APCDV) I $P(%,"^") S APCD3MER=% Q
 Q
 ;
