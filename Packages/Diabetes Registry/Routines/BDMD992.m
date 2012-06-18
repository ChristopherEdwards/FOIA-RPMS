BDMD992 ; IHS/CMI/LAB - 1999 DIABETES AUDIT ;
 ;;2.0;DIABETES MANAGEMENT SYSTEM;**2**;JUN 14, 2007
MAMMOG(P,BDATE,EDATE) ;  EP
 I $$SEX^AUPNPAT(P)'="F" Q "N/A"
 I '$G(P) Q ""
 NEW LMAM S LMAM=""
 I $G(^AUTTSITE(1,0)),$P(^AUTTLOC($P(^AUTTSITE(1,0),U),0),U,10)="353101" S LMAM=$$MAMMOG1(P,BDATE,EDATE)
 NEW BDM S %=P_"^LAST RAD MAMMOGRAM BILAT;DURING "_BDATE_"-"_EDATE,E=$$START1^APCLDF(%,"BDM(")
 I $D(BDM(1)) D
 .Q:LMAM>$P(BDM(1),U)
 .S LMAM=$P(BDM(1),U)
 K BDM S %=P_"^LAST RAD SCREENING MAMMOGRAM;DURING "_BDATE_"-"_EDATE,E=$$START1^APCLDF(%,"BDM(")
 I $D(BDM(1)) D
 .Q:LMAM>$P(BDM(1),U)
 .S LMAM=$P(BDM(1),U)
 K BDM S %=P_"^LAST DX V76.11;DURING "_BDATE_"-"_EDATE,E=$$START1^APCLDF(%,"BDM(")
 I $D(BDM(1)) D
 .Q:LMAM>$P(BDM(1),U)
 .S LMAM=$P(BDM(1),U)
 K BDM S %=P_"^LAST DX V76.12;DURING "_BDATE_"-"_EDATE,E=$$START1^APCLDF(%,"BDM(")
 I $D(BDM(1)) D
 .Q:LMAM>$P(BDM(1),U)
 .S LMAM=$P(BDM(1),U)
 K BDM S %=P_"^LAST PROCEDURE 87.37;DURING "_BDATE_"-"_EDATE,E=$$START1^APCLDF(%,"BDM(")
 I $D(BDM(1)) D
 .Q:LMAM>$P(BDM(1),U)
 .S LMAM=$P(BDM(1),U)
 Q $S(LMAM]"":"Yes  "_$$FMTE^XLFDT(LMAM),1:"No")
 ;
MAMMOG1(P,BDATE,EDATE) ;for radiology 4.5+ or until qman can handle taxonomies for radiology procedures
 ;
 ;IHS/ANMC/LJF 8/26/99 new code to look for all mammograms no matter
 ;    how they are spelled in file 71 - for Rad version 4.5+
 NEW BDMMAM,CODE,COUNT,IEN,X
 S CODE=$O(^DIC(40.7,"C",72,0)) I 'CODE Q "No    <never recorded>"
 S IEN=0 F  S IEN=$O(^RAMIS(71,IEN)) Q:'IEN  D
 . Q:$G(^RAMIS(71,IEN,"I"))  ;inactive
 . Q:'$D(^RAMIS(71,IEN,"STOP","B",CODE))  ;no mamm stop code
 . S COUNT=$G(COUNT)+1,BDMMAM(COUNT)=$P(^RAMIS(71,IEN,0),U)
 ;
 ; -- use data fetcher to find mammogram dates
 NEW BDMY,BDMSAV,BDMX,BDMNAM
 S (BDMSAV,BDMX)=0 F  S BDMX=$O(BDMMAM(BDMX)) Q:'BDMX  D
 . S %=P_"^LAST RAD "_BDMMAM(BDMX)_";DURING "_BDATE_"-"_EDATE,E=$$START1^APCLDF(%,"BDMY(")
 . ; save latest date and procedure name
 . I $G(BDMY(1)),$P(BDMY(1),U)>BDMSAV S BDMSAV=$P(BDMY(1),U),BDMNAM=BDMMAM(BDMX)
 ;
 ; -- return results
 I BDMSAV'=0 Q BDMSAV
 ;IHS/ANMC/LJF 8/26/99 end of new code
 ;
 Q ""
 ;
