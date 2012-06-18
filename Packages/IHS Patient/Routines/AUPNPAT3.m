AUPNPAT3 ; IHS/CMI/LAB - PATIENT RELATED FUNCTIONS ; [ 05/09/2003  8:02 AM ]
 ;;99.1;IHS DICTIONARIES (PATIENT);**2,8,9,10,18**;JUN 13, 2003
 ;
 ;IHS/CMI/LAB - patch 2 Y2K
 ;IHS/CMI/LAB - patch 8 DOD check in AGE subroutine
 Q
 ;
AGE(DFN,D,F) ;EP - Given DFN, return Age.
 I '$G(DFN) Q -1
 I '$D(^DPT(DFN,0)) Q -1
 I $$DOB^AUPNPAT(DFN,"")<0 Q -1
 ;S:$G(D)="" D=DT ;IHS/CMI/LAB - added DOD check patch 8
 S:$G(D)="" D=$S(+$$DOD^AUPNPAT3(DFN):$$DOD^AUPNPAT3(DFN),1:DT)
 S:$G(F)="" F="Y"
 NEW %
 S %=$$FMDIFF^XLFDT(D,$$DOB^AUPNPAT(DFN,""))
 S %1=%\365.25
 I F="Y" Q %1
 Q $S(%1>2:%1_" YRS",%<31:%_" DYS",1:%\30_" MOS")
 ;
BEN(DFN,F) ;EP - returns classification/beneficiary in F format
 ;F="E":name of beneficiary type, F="I":ien of beneficiary type, F="C":code of beneficiary type
 I '$G(DFN) Q -1
 I '$D(^AUPNPAT(DFN,11)) Q -1
 I $P(^AUPNPAT(DFN,11),"^",11)="" Q ""
 I '$D(^AUTTBEN($P(^AUPNPAT(DFN,11),"^",11))) Q -1
 S F=$G(F)
 Q $S(F="I":$P(^AUPNPAT(DFN,11),"^",11),F="E":$P(^AUTTBEN($P(^AUPNPAT(DFN,11),"^",11),0),"^"),1:$P(^AUTTBEN($P(^AUPNPAT(DFN,11),"^",11),0),"^",2))
 ;
CDEATH(DFN,F) ;EP - returns Cause of Death in F format
 ;F="E":ICD narrative, F="I":ien of icd code, F="C":icd code
 I '$G(DFN) Q ""
 I '$D(^AUPNPAT(DFN)) Q ""
 I '$P($G(^AUPNPAT(DFN,11)),"^",14) Q ""
 I '$D(^ICD9($P(^AUPNPAT(DFN,11),"^",14))) Q ""
 S F=$G(F)
 I F="I" Q $P(^AUPNPAT(DFN,11),"^",14)
 I F="E" Q $P($$ICDDX^ICDCODE($P(^AUPNPAT(DFN,11),"^",14),$S($P($G(^DPT(DFN,.35)),U,1)]"":$P(^DPT(DFN,.35),U,1),1:DT)),"^",2) ;CSV
 Q $P($$ICDDX^ICDCODE($P(^AUPNPAT(DFN,11),"^",14)),"^",2)
 ;
COMMRES(DFN,F) ;EP - Given DFN, return comm of res in F format
 ;F="E":community name, F="I":community ien, F="C":community STCTYCOM code
 I '$G(DFN) Q -1
 I '$D(^AUPNPAT(DFN,11)) Q -1
 I $P(^AUPNPAT(DFN,11),"^",17)="" Q ""
 I '$D(^AUTTCOM($P(^AUPNPAT(DFN,11),"^",17))) Q -1
 S F=$G(F)
 Q $S(F="I":$P(^AUPNPAT(DFN,11),"^",17),F="E":$P(^AUTTCOM($P(^AUPNPAT(DFN,11),"^",17),0),"^"),1:$P(^AUTTCOM($P(^AUPNPAT(DFN,11),"^",17),0),"^",8))
 ;
DOB(DFN,F) ;EP - Given DFN, return Date of Birth according to F.
 ; If F="E" produce the External form, else FM format.
 I '$G(DFN) Q -1
 I '$D(^DPT(DFN,0)) Q -1
 S F=$G(F)
 ;beginning Y2K mods - change 2 parameter is FMTE call to 5
 ;Q $S(F="E":$$FMTE^XLFDT($P(^DPT(DFN,0),"^",3)),F="S":$$FMTE^XLFDT($P(^DPT(DFN,0),"^",3),2),1:$P(^DPT(DFN,0),"^",3)) ;Y2000 IHS/CMI/LAB - commented out
 Q $S(F="E":$$FMTE^XLFDT($P(^DPT(DFN,0),"^",3)),F="S":$$FMTE^XLFDT($P(^DPT(DFN,0),"^",3),5),1:$P(^DPT(DFN,0),"^",3))  ;Y2000 IHS/CMI/LAB
 ;end Y2K mods
 ;
DOD(DFN,F) ;EP - Given DFN, return Date of Death according to F.
 ; If F="E" produce the External form, else FM format.
 I '$G(DFN) Q -1
 I '$D(^DPT(DFN,0)) Q -1
 S F=$G(F)
 Q $S(F="E":$$FMTE^XLFDT($P($G(^DPT(DFN,.35)),"^")),1:$P($G(^DPT(DFN,.35)),"^"))
 ;
ELIGSTAT(DFN,F) ;EP - returns eligibility status in F format
 ;F="E":eligibility type (name), F="I":internal set of codes
 I '$G(DFN) Q -1
 I '$D(^AUPNPAT(DFN,11)) Q -1
 S F=$G(F)
 Q $S(F="E":$$EXTSET^XBFUNC(9000001,1112,$P(^AUPNPAT(DFN,11),"^",12)),1:$P(^AUPNPAT(DFN,11),"^",12))
 ;
HRN(DFN,L,F) ;EP - return HRN at L location
 ;L must be ien of location of encounter
 ;F is optional.  If F=2 hrn will be prefixed with site abbreviation
 I '$G(DFN) Q -1
 I '$D(^AUPNPAT(DFN)) Q -1
 I '$G(L) Q -1
 I $G(F)=2,'$D(^AUTTLOC(L,0)) Q -1
 Q $S($D(^AUPNPAT(DFN,41,L,0)):$S($G(F)=2:$P(^AUTTLOC(L,0),"^",7)_" ",1:"")_$P(^AUPNPAT(DFN,41,L,0),"^",2),1:"")
 Q $P($G(^AUPNPAT(DFN,41,L,0)),"^",2)
 ;
SEX(DFN) ;EP - Given DFN, return Sex.
 I '$G(DFN) Q -1
 I '$D(^DPT(DFN,0)) Q -1
 Q $P(^DPT(DFN,0),"^",2)
 ;
SSN(DFN) ;EP - Given DFN, return SSN.
 I '$G(DFN) Q -1
 I '$D(^DPT(DFN,0)) Q -1
 Q $P(^DPT(DFN,0),"^",9)
 ;
TRIBE(DFN,F) ;EP - Given DFN, return Tribe in F format
 ;If F="E", name of tribe returned, if F="I", internal ien of tribe
 ;returned, if F="C", tribe code returned
 I '$G(DFN) Q -1
 I '$D(^AUPNPAT(DFN,11)) Q -1
 I $P(^AUPNPAT(DFN,11),"^",8)="" Q ""
 I '$D(^AUTTTRI($P(^AUPNPAT(DFN,11),"^",8))) Q -1
 S F=$G(F)
 Q $S(F="I":$P(^AUPNPAT(DFN,11),"^",8),F="E":$P(^AUTTTRI($P(^AUPNPAT(DFN,11),"^",8),0),"^"),1:$P(^AUTTTRI($P(^AUPNPAT(DFN,11),"^",8),0),"^",2))
 ;
