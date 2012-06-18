BDWAID ; IHS/CMI/LAB - UNIQUE REGISTRATION RECORD ID ;
 ;;1.0;IHS DATA WAREHOUSE;;JAN 23, 2006
 ;
UID(BDWA) ;PEP-Given DFN return unique patient record id.
 ; BDWA can be DFN, but is not required if DFN or DA exists.
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
 ; If BDWA is not specified, try DFN, then DA if DIC=AUPNPAT.
 I '$G(BDWA),$G(DFN) S BDWA=DFN
 I '$G(BDWA),$G(DA),$G(DIC)="^AUPNPAT(" S BDWA=DA
 ;
 I '$G(BDWA) Q "DFN undefined."
 I '$D(^AUPNPAT(BDWA)) Q "No entry in AUPNPAT(."
 ;
 Q $$GET1^DIQ(9999999.06,$P(^AUTTSITE(1,0),U),.32)_$E("0000000000",1,10-$L(BDWA))_BDWA
 ;
UIDV(VISIT) ;EP - generate unique ID for visit
 I '$G(VISIT) Q VISIT
 NEW X
 ;I '$P($G(^AUTTSITE(1,1)),"^",3) S $P(^AUTTSITE(1,1),"^",3)=$P(^AUTTLOC($P(^AUTTSITE(1,0),"^",1),0),"^",10)
 S X=$$GET1^DIQ(9999999.06,$P(^AUTTSITE(1,0),U),.32)
 Q X_$$LZERO(VISIT,10)
 ;
LZERO(V,L) ;EP - left zero fill
 NEW %,I
 S %=$L(V),Z=L-% F I=1:1:Z S V="0"_V
 Q V
