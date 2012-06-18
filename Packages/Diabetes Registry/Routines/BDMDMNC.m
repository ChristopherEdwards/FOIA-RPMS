BDMDMNC ; IHS/CMI/LAB - is this the first of this diabetes diagnosis? ;
 ;;2.0;DIABETES MANAGEMENT SYSTEM;**2**;JUN 14, 2007
 ;
 ;cmi/anch/maw 9/10/2007 code set versioning in DMCOMPL
 ;
DMNC ;EP -- called by taxonomy system
 K ATXSTOP
 Q:'ATXPOVDA
 Q:'$P(^AUPNVPOV(ATXPOVDA,0),U,2)
 ; -- is this the first of this diagnosis (ICD9) for this patient
 K BDM
 S BDMY="BDM("
 S BDMX=$P(^AUPNVPOV(ATXPOVDA,0),U,2)_"^FIRST DX [BDM DIABETES REG NEW CASE" S BDMER=$$START1^APCLDF(BDMX,BDMY)
 I BDMER S ATXSTOP=1 G X1
 S V=+$P($G(BDM(1)),U,4) I V=ATXPOVDA G X1
 S ATXSTOP=1
X1 K BDM,BDMER,BDMX,BDMY
 Q
DMCOMPL ;PEP -- called from taxonomy system
 ;-- if this patient is on IHS DIABETES register, and this is the first dx of this complication send bulletin (do not set atxstp)
 ;S DIC="^ACM(41.1,",DIC(0)="M",X="IHS DIABETES" D ^DIC I Y=-1 G X3
 ;S BDMDMRG=+Y
 K ATXSTOP
 Q:'ATXPOVDA
 Q:'$P(^AUPNVPOV(ATXPOVDA,0),U,2)
 S BDMDFN=$P(^AUPNVPOV(ATXPOVDA,0),U,2)
 ; -- PUT CODE HERE TO SEE IF PATIENT ON REGISTER
 ;I '$D(^ACM(41,"AC",BDMDFN,BDMDMRG)) G X3
 I '$$DMREG(BDMDFN) G X3  ;IHS/CMI/GRL
 K BDM
 S BDMY="BDM("
 ;S BDMX=BDMDFN_"^FIRST DX "_$P(^ICD9(ATXICD,0),U) S BDMER=$$START1^APCLDF(BDMX,BDMY)  ;cmi/anch/maw 9/10/2007 orig line
 S BDMX=BDMDFN_"^FIRST DX "_$P($$ICDDX^ICDCODE(ATXICD),U,2) S BDMER=$$START1^APCLDF(BDMX,BDMY)  ;cmi/anch/maw 9/10/2007 csv
 I BDMER G X2
 S V=+$P($G(BDM(1)),U,4) I V=ATXPOVDA G X2
X3 S ATXSTOP=1
X2 K BDM,BDMDFN,BDMER,BDMX,BDMY
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
