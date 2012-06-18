BGP7DCHW ; IHS/CMI/LAB - calc measures 29 Apr 2007 7:38 PM ;
 ;;7.0;IHS CLINICAL REPORTING;;JAN 24, 2007
 ;
GEN ;EP
 Q:'BGPACTCL
 I '$D(^AUPNVSIT("AC",DFN)) Q ""
 K ^TMP($J,"A")
 S A="^TMP($J,""A"",",B=DFN_"^ALL VISITS;DURING "_$$FMTE^XLFDT(BGPBBD)_"-"_$$FMTE^XLFDT(BGPED),E=$$START1^APCLDF(B,A)
 I '$D(^TMP($J,"A",1)) Q ""
 S (X,G)=0 F  S X=$O(^TMP($J,"A",X)) Q:X'=+X  S V=$P(^TMP($J,"A",X),U,5) D
 .Q:'$D(^AUPNVSIT(V,0))
 .Q:'$P(^AUPNVSIT(V,0),U,9)
 .Q:$P(^AUPNVSIT(V,0),U,11)
 .Q:'$D(^AUPNVMSR("AD",V))
 .S M=0,W="",H="" F  S M=$O(^AUPNVMSR("AD",V,M)) Q:M'=+M  D
 ..S T=$P($G(^AUPNVMSR(M,0)),U)
 ..Q:T=""
 ..S T=$P($G(^AUTTMSR(T,0)),U)
 ..I T="WT" S W=$P(^AUPNVMSR(M,0),U,4)
 ..I T="HT" S H=$P(^AUPNVMSR(M,0),U,4)
 .I W="",H="" Q  ;no ht or wt so skip visit
 .I $$AGE^AUPNPAT(DFN,BGPED)<19,(H=""!(W="")) Q  ;under 19 and not both
 .D SET
 Q
 ;
SET ;
 S BGPCHWC=BGPCHWC+1
 S BGPHTV=H,BGPWTV=W
 S R=""
 S $P(R,U)=$$VAL^XBDIQ1(9999999.06,DUZ(2),.05)
 S $P(R,U,2)=$P(^AUTTLOC(DUZ(2),0),U,10)
 S $P(R,U,3)=$P($G(^AUTTLOC($P(^AUTTSITE(1,0),U),1)),U,3)
 S $P(R,U,4)=$$DATE(DT)
 S $P(R,U,5)=$$DATE(BGPBBD)
 S $P(R,U,6)=$$DATE(BGPED)
 S $P(R,U,7)=$$UID(DFN)
 S $P(R,U,8)=$$DATE($P(^DPT(DFN,0),U,3))
 S $P(R,U,9)=$$TRIBE^AUPNPAT(DFN,"C")
 S $P(R,U,10)=$P(^DPT(DFN,0),U,2)
 S $P(R,U,11)=$$STATE(DFN)
 S $P(R,U,12)=$$UIDV(V)
 S $P(R,U,13)=$$DATE($P($P(^AUPNVSIT(V,0),U),"."))
 S $P(R,U,14)=$$RZERO($P($P(^AUPNVSIT(V,0),U),".",2),4)
 S I=BGPHTV*2.54,I=$J(I,6,2),I=$$STRIP^XLFSTR(I," ")
 S $P(R,U,15)=$S(BGPHTV]"":I,1:"")
 S I=BGPWTV*.45359,I=$J(I,6,2),I=$$STRIP^XLFSTR(I," ")
 S $P(R,U,16)=$S(BGPWTV]"":I,1:"")
 S ^BGPGPDCA(BGPRPT,88888,BGPCHWC,0)=R
 Q
UID(BGPA) ;PEP-Given DFN return unique patient record id.
 ; BGPA can be DFN, but is not required if DFN or DA exists.
 ;
 ; pt record id = 6DIGIT_PADDFN
 ;     where 6DIGIT is the ASUFAC at the time of implementation of
 ;     this functionality.  I.e., the existing ASUFAC was frozen and
 ;     stuffed into the .25 field of the RPMS SITE file.
 ; PADDFN = DFN right justified in a field of 10.
 ;
 ; If not there, stuff the ASUFAC into RPMS SITE for durability.
 ;I '$P($G(^AUTTSITE(1,1)),U,3) S $P(^AUTTSITE(1,1),U,3)=$P(^AUTTLOC($P(^AUTTSITE(1,0),U,1),0),U,10)
 ;
 ;
 Q $$GET1^DIQ(9999999.06,$P(^AUTTSITE(1,0),U),.32)_$E("0000000000",1,10-$L(BGPA))_BGPA
 ;
DATE(D) ;EP
 I $G(D)="" Q ""
 Q $E(D,4,5)_"/"_$E(D,6,7)_"/"_(1700+($E(D,1,3)))
 ;
UIDV(VISIT) ;EP - generate unique ID for visit
 I '$G(VISIT) Q VISIT
 NEW X
 S X=$$GET1^DIQ(9999999.06,$P(^AUTTSITE(1,0),U),.32)
 Q X_$$LZERO(VISIT,10)
 ;
LZERO(V,L) ;EP - left zero fill
 NEW %,I
 S %=$L(V),Z=L-% F I=1:1:Z S V="0"_V
 Q V
RZERO(V,L) ;ep right zero fill 
 NEW %,I
 S %=$L(V),Z=L-% F I=1:1:Z S V=V_"0"
 Q V
STATE(P) ;EP
 S C=$$COMMRES^AUPNPAT(P,"C")
 I C="" Q ""
 S S=$E(C,1,2)
 S S=$O(^DIC(5,"C",S,0))
 I S="" Q S
 Q $P($G(^DIC(5,S,0)),U,2)
 ;
