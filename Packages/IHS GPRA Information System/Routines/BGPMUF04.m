BGPMUF04 ; IHS/MSC/MMT - MU measure NQF0043 ;15-Jul-2011 11:44;MMT
 ;;11.1;IHS CLINICAL REPORTING SYSTEM;**1**;JUN 27, 2011;Build 106
 ;
ENTRY ;EP
 ; expects:
 ;  DFN      = patient code from VA PATIENT file
 ;  BGPBDATE = begin date of report
 ;  BGPEDATE = end date of report
 ;  BGPPROV  = provider code from NEW PERSON file
 ;  BGPMUTF  = timeframe variable - "C"=current year; "P"=previous year; "B"=baseline year
 N BGP1,BGP2,BGPDEN,BGPNUM,BGPDT,END,FIRST,IEN,START,VDATE,VIEN,BGPZ,BGPX
 N AENC,BENC,BGPDSTR,BGPNSTR,IMMC
 S (BGPDEN,BGPNUM)=0
 ;Pts must be 65 years and older
 Q:BGPAGEE<65
 S START=9999999-BGPBDATE,END=9999999-BGPEDATE
 ;look for 2 visits with E&M codes (outpatient encounters)
 ;    OR   1 visit with E&M codes  (preventive medicine encounter)
 S (BGP1,BGP2)=0
 S (BGPDSTR,BGPNSTR)=""
 S FIRST=END-0.1 F  S FIRST=$O(^AUPNVSIT("AA",DFN,FIRST)) Q:FIRST=""!($P(FIRST,".",1)>START)  D
 .S IEN=0 F  S IEN=$O(^AUPNVSIT("AA",DFN,FIRST,IEN)) Q:'+IEN  D
 ..;Check provider, determine if there are visits with E&M codes
 ..Q:'$$PRV^BGPMUUT1(IEN,BGPPROV)
 ..;Check E&M
 ..S AENC=$$VSTCPT^BGPMUUT1(DFN,IEN,"BGPMU PNEUMO ENC EM")
 ..S BENC=$$VSTPOV^BGPMUUT3(DFN,IEN,"BGPMU PNEUMO ENC ICD")
 ..Q:(AENC=0)&(BENC=0)
 ..S DATA=$G(^AUPNVSIT(IEN,0))
 ..S VDATE=$P($G(^AUPNVSIT(IEN,0)),U,1),VIEN=IEN
 I +$G(VIEN) D
 .S BGPDEN=1
 .S BGPDSTR="EN "_$$DATE^BGPMUUTL($G(VDATE))
 .;Setup numerator
 .;get all immunizations
 .S C="33^100^133"
 .S CPTS="90669^90670^90732"
 .K BGPX D GETIMMS^BGPMUUT2(DFN,BGPEDATE,C,.BGPX,CPTS)
 .I $D(BGPX) D
 ..S IMMC=""
 ..F  S IMMC=$O(BGPX(IMMC)) Q:IMMC=""  D
 ...S IMMD=BGPX(IMMC)
 ...S IMMV=$P(IMMD,U,2)
 ...S IMMDATE=$P($G(^AUPNVSIT(IMMV,0)),U,1)
 ...S BGPNUM=1
 ...S BGPNSTR=$S($P(IMMD,U,3):$P(IMMD,U,1),1:$P($G(^AUTTIMM($P(IMMD,U,1),0)),U,3))_" "_$$DATE^BGPMUUTL($P(IMMDATE,".",1))
 ...Q
 .D TOTAL(DFN)
 K BGP1,BGP2,BGPDEN,BGPNUM,BGPDT,END,FIRST,IEN,START,VDATE,VIEN,BGPZ,BGPX
 K AENC,BENC
 Q
 ;
TOTAL(DFN) ;See where this patient ends up
 N PTCNT,EXCCT,DENCT,NUMCT,TOTALS
 S TOTALS=+$G(^TMP("BGPMU0043",$J,BGPMUTF,"TOT"))
 S DENCT=+$G(^TMP("BGPMU0043",$J,BGPMUTF,"DEN"))
 S NUMCT=+$G(^TMP("BGPMU0043",$J,BGPMUTF,"NUM"))
 S PTCNT=TOTALS
 S PTCNT=PTCNT+1
 Q:'BGPDEN
 S DENCT=DENCT+1 S ^TMP("BGPMU0043",$J,BGPMUTF,"DEN")=DENCT
 I +BGPNUM D
 .S NUMCT=NUMCT+1 S ^TMP("BGPMU0043",$J,BGPMUTF,"NUM")=NUMCT
 .I BGPMUTF="C" S ^TMP("BGPMU0043",$J,"PAT",BGPMUTF,"NUM",PTCNT)=DFN_U_BGPDSTR_U_BGPNSTR
 I 'BGPNUM&(BGPMUTF="C") S ^TMP("BGPMU0043",$J,"PAT",BGPMUTF,"NOT",PTCNT)=DFN_U_BGPDSTR_U_BGPNSTR
 S ^TMP("BGPMU0043",$J,BGPMUTF,"TOT")=PTCNT
 ;Setup iCare array for patient
 S BGPICARE("MU.EP.0043.1",BGPMUTF)=+BGPDEN_U_+BGPNUM_U_""_U_BGPDSTR_";"_BGPNSTR
 K PTCNT,EXCCT,DENCT,NUMCT,TOTALS
 Q
 ;
TEST ; debug target
 ;S U="^"
 ;S DT=$$DT^XLFDT()
 ;S DFN=184            ;  DFN      = patient code from VA PATIENT file
 ;S BGPBDATE=3110101   ;  BGPBDATE = begin date of report
 ;S BGPEDATE=3110301   ;  BGPEDATE = end date of report
 ;S BGPPROV=2          ;  BGPPROV   = provider code from NEW PERSON file
 ;S BGPMUTF="C"        ;  BGPMUTF  = timeframe variable - "C"=current year; "P"=previous year; "B"=baseline year
 ;D ENTRY
 Q
