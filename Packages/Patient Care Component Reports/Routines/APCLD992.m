APCLD992 ; IHS/CMI/LAB - 1999 DIABETES AUDIT ;
 ;;2.0;IHS PCC SUITE;;MAY 14, 2009
MAMMOG(P,BDATE,EDATE) ;  EP
 I $$SEX^AUPNPAT(P)'="F" Q "N/A"
 I '$G(P) Q ""
 NEW LMAM S LMAM=""
 I $G(^AUTTSITE(1,0)),$P(^AUTTLOC($P(^AUTTSITE(1,0),U),0),U,10)="353101" S LMAM=$$MAMMOG1(P,BDATE,EDATE)
 NEW APCL S %=P_"^LAST RAD MAMMOGRAM BILAT;DURING "_BDATE_"-"_EDATE,E=$$START1^APCLDF(%,"APCL(")
 I $D(APCL(1)) D
 .Q:LMAM>$P(APCL(1),U)
 .S LMAM=$P(APCL(1),U)
 K APCL S %=P_"^LAST RAD SCREENING MAMMOGRAM;DURING "_BDATE_"-"_EDATE,E=$$START1^APCLDF(%,"APCL(")
 I $D(APCL(1)) D
 .Q:LMAM>$P(APCL(1),U)
 .S LMAM=$P(APCL(1),U)
 K APCL S %=P_"^LAST DX V76.11;DURING "_BDATE_"-"_EDATE,E=$$START1^APCLDF(%,"APCL(")
 I $D(APCL(1)) D
 .Q:LMAM>$P(APCL(1),U)
 .S LMAM=$P(APCL(1),U)
 K APCL S %=P_"^LAST DX V76.12;DURING "_BDATE_"-"_EDATE,E=$$START1^APCLDF(%,"APCL(")
 I $D(APCL(1)) D
 .Q:LMAM>$P(APCL(1),U)
 .S LMAM=$P(APCL(1),U)
 K APCL S %=P_"^LAST PROCEDURE 87.37;DURING "_BDATE_"-"_EDATE,E=$$START1^APCLDF(%,"APCL(")
 I $D(APCL(1)) D
 .Q:LMAM>$P(APCL(1),U)
 .S LMAM=$P(APCL(1),U)
 Q $S(LMAM]"":"Yes  "_$$FMTE^XLFDT(LMAM),1:"No")
 ;
MAMMOG1(P,BDATE,EDATE) ;for radiology 4.5+ or until qman can handle taxonomies for radiology procedures
 ;
 ;IHS/ANMC/LJF 8/26/99 new code to look for all mammograms no matter
 ;    how they are spelled in file 71 - for Rad version 4.5+
 NEW APCLMAM,CODE,COUNT,IEN,X
 S CODE=$O(^DIC(40.7,"C",72,0)) I 'CODE Q "No    <never recorded>"
 S IEN=0 F  S IEN=$O(^RAMIS(71,IEN)) Q:'IEN  D
 . Q:$G(^RAMIS(71,IEN,"I"))  ;inactive
 . Q:'$D(^RAMIS(71,IEN,"STOP","B",CODE))  ;no mamm stop code
 . S COUNT=$G(COUNT)+1,APCLMAM(COUNT)=$P(^RAMIS(71,IEN,0),U)
 ;
 ; -- use data fetcher to find mammogram dates
 NEW APCLY,APCLSAV,APCLX,APCLNAM
 S (APCLSAV,APCLX)=0 F  S APCLX=$O(APCLMAM(APCLX)) Q:'APCLX  D
 . S %=P_"^LAST RAD "_APCLMAM(APCLX)_";DURING "_BDATE_"-"_EDATE,E=$$START1^APCLDF(%,"APCLY(")
 . ; save latest date and procedure name
 . I $G(APCLY(1)),$P(APCLY(1),U)>APCLSAV S APCLSAV=$P(APCLY(1),U),APCLNAM=APCLMAM(APCLX)
 ;
 ; -- return results
 I APCLSAV'=0 Q APCLSAV
 ;IHS/ANMC/LJF 8/26/99 end of new code
 ;
 Q ""
 ;
