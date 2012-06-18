BHLOBX3M ;cmi/sitka/maw - BHL 3M OBX Supplement  
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;
 ;
 ;this routine will supplement the 3M OBX Segment
 ;
 S INA("OBID")=CS_CS_CS_"WT"_CS_"WEIGHT"_CS_BHL("IHST")
 I $$FMDIFF^XLFDT($P(BHL("VDTM"),"."),$P(^DPT(BHL("PAT"),0),"^",3))<30,$$BWT(BHL("PAT")) D
 . S INA("WGT")=$$BWT(BHL("PAT"))
 . S BHLOBX3M=1
 Q
 ;
BWT(P) ;get weight on date of birth
 I '$G(P) Q ""
 NEW M S M=$O(^AUTTMSR("C","02","")) I 'M Q ""
 NEW R,V,D S R=0,(D,V)="" F  S D=$O(^AUPNVMSR("AA",P,M,D)) Q:D'=+D!(V]"")  I D=9999999-$P(^DPT(P,0),"^",3) S R=$O(^AUPNVMSR("AA",P,M,D,0)),V=$P(^AUPNVMSR(R,0),"^",4)
 Q V
 ;
