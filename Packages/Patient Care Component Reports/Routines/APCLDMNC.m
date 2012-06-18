APCLDMNC ; IHS/CMI/LAB - is this the first of this diabetes diagnosis? ;
 ;;2.0;IHS PCC SUITE;;MAY 14, 2009
 ;
 ;cmi/anch/maw 9/10/2007 code set versioning in DMCOMPL
 ;
DMNC ;EP -- called by taxonomy system
 K ATXSTOP
 Q:'ATXPOVDA
 Q:'$P(^AUPNVPOV(ATXPOVDA,0),U,2)
 ; -- is this the first of this diagnosis (ICD9) for this patient
 K APCL
 S APCLY="APCL("
 S APCLX=$P(^AUPNVPOV(ATXPOVDA,0),U,2)_"^FIRST DX [APCL DIABETES REG NEW CASE" S APCLER=$$START1^APCLDF(APCLX,APCLY)
 I APCLER S ATXSTOP=1 G X1
 S V=+$P($G(APCL(1)),U,4) I V=ATXPOVDA G X1
 S ATXSTOP=1
X1 K APCL,APCLER,APCLX,APCLY
 Q
DMCOMPL ;PEP -- called from taxonomy system
 ;-- if this patient is on IHS DIABETES register, and this is the first dx of this complication send bulletin (do not set atxstp)
 ;S DIC="^ACM(41.1,",DIC(0)="M",X="IHS DIABETES" D ^DIC I Y=-1 G X3
 ;S APCLDMRG=+Y
 K ATXSTOP
 Q:'ATXPOVDA
 Q:'$P(^AUPNVPOV(ATXPOVDA,0),U,2)
 S APCLDFN=$P(^AUPNVPOV(ATXPOVDA,0),U,2)
 ; -- PUT CODE HERE TO SEE IF PATIENT ON REGISTER
 ;I '$D(^ACM(41,"AC",APCLDFN,APCLDMRG)) G X3
 I '$$DMREG(APCLDFN) G X3  ;IHS/CMI/GRL
 K APCL
 S APCLY="APCL("
 ;S APCLX=APCLDFN_"^FIRST DX "_$P(^ICD9(ATXICD,0),U) S APCLER=$$START1^APCLDF(APCLX,APCLY)  ;cmi/anch/maw 9/10/2007 orig line
 S APCLX=APCLDFN_"^FIRST DX "_$P($$ICDDX^ICDCODE(ATXICD),U,2) S APCLER=$$START1^APCLDF(APCLX,APCLY)  ;cmi/anch/maw 9/10/2007 csv
 I APCLER G X2
 S V=+$P($G(APCL(1)),U,4) I V=ATXPOVDA G X2
X3 S ATXSTOP=1
X2 K APCL,APCLDFN,APCLER,APCLX,APCLY
 Q
 ;
DMREG(P) ;is patient on any Diabetes register 1 if on reg, "" if not
 I $G(P)="" Q ""
 NEW X,Y
 S X=0,Y="" F  S X=$O(^ACM(41,"AC",P,X)) Q:X'=+X!(Y)  D
 .S N=$$UP^XLFSTR($P($G(^ACM(41.1,X,0)),U))
 .I N["DIABETES" S Y=1
 .I N["DIAB" S Y=1
 .I N["DM " S Y=1
 .I N[" DM" S Y=1
 .Q
 Q Y
