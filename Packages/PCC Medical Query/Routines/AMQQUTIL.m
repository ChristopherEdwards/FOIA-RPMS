AMQQUTIL ;IHS/CMI/THL - RETURNS IF USER HOLDER OF PARTICULAR SECURITY KEY ;
 ;;2.0;IHS PCC SUITE;**6,7**;MAY 14, 2009
 ;-----
KEYCHECK(AMQQKEY)  ; - EP - CHECK FOR KEY HOLDING
 Q $S(('$D(DUZ)#2):0,1:$D(^XUSEC(AMQQKEY,DUZ)))
 ;
DFNINC    ; - EP - Gets the next valid DFN when random sampling
 Q:$D(^DPT(AMQP(0)))
 F  S AMQP(0)=AMQP(0)+$R(AMQP("$R")) Q:$D(^DPT(AMQP(0)))  S:'$O(^DPT(AMQP(0))) AMQP(0)=0 Q:'AMQP(0)
 Q
VFC(V) ;EP
 S V=$G(V)
 I V=0 Q "Unknown"
 I V=1 Q "Not Eligible"
 I V=2 Q "Medicaid"
 I V=3 Q "Uninsured"
 I V=4 Q "Am Indian/AK Native"
 I V=5 Q "Federally Qualified"
 I V=6 Q "State-specific Elig"
 I V=7 Q "Local-specific Elig"
 Q ""
ACTIMM(V) ;EP
 S V=+V
 I '$D(^BIP(V,0)) Q 0
 I $P(^BIP(V,0),U,8) Q 0
 Q 1
