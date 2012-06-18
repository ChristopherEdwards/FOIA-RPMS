AGTXID ;IHS/ASDS/EFG - UNIQUE REGISTRATION RECORD ID ;  
 ;;7.1;PATIENT REGISTRATION;;AUG 25,2005
 ;
UID(AG) ;PEP - Given DFN return unique patient record id.
 ;AG can be DFN, but is not required if DFN or DA exists.
 ;
 ;pt record id = 6DIGIT_PADDFN
 ;     where 6DIGIT is the ASUFAC at the time of implementation of
 ;     this functionality.  I.e., the existing ASUFAC was frozen and
 ;     stuffed into the .25 field of the RPMS SITE file.
 ;PADDFN = DFN right justified in a field of 10.
 ;
 ;If not there, stuff the ASUFAC into RPMS SITE for durability.
 I '$P($G(^AUTTSITE(1,1)),U,3) S $P(^AUTTSITE(1,1),U,3)=$P(^AUTTLOC($P(^AUTTSITE(1,0),U,1),0),U,10)
 ;If AG is not specified, try DFN, then DA if DIC=AUPNPAT.
 I '$G(AG),$G(DFN) S AG=DFN
 I '$G(AG),$G(DA),$G(DIC)="^AUPNPAT(" S AG=DA
 I '$G(AG) Q "DFN undefined."
 I '$D(^AUPNPAT(AG)) Q "No entry in AUPNPAT(."
 Q $P(^AUTTSITE(1,1),U,3)_$E("0000000000",1,10-$L(AG))_AG
