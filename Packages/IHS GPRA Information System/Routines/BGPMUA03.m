BGPMUA03 ; IHS/MSC/MGH - MI measure NQF0031 ;29-Nov-2011 7:37;MMT
 ;;12.1;IHS CLINICAL REPORTING;;MAY 17, 2012;Build 66
 ;Code to collect meaningful use report for breast cancer screening
ENTRY ;EP
 ; expects:
 ;  DFN      = patient code from VA PATIENT file
 ;  BGPBDATE = begin date of report
 ;  BGPEDATE = end date of report
 ;  BGPPROV   = provider code from NEW PERSON file
 ;  BGPMUTF  = timeframe variable - "C"=current year; "P"=previous year; "B"=baseline year
 N START,END,BGPNUM,BGPDEN,BGPNUM,AENC,BENC,BGPX,MASTCNT
 N IEN,INV,VISIT,WTIEN,DATA,VDATE,VALUE,RESULT,FIRST,REF,VIEN,EXCEPT
 N BGPN1,BGPN3,RETVAL,BGPMUMAM,BGPMAS,AENC,BENC,BGPBIRTH,BGPMAM,BGPMAM2,BGPMAM3,BGPMAM4
 N BGPENC,BGPBICPT,BGPUICPT,BGPBIICD,BGPUIICD,STRING1,STRING2
 N BGPDT,BGPDSTR,BGPNSTR
 S (BGPDEN,BGPNUM,RESULT)=0
 S (BGPDSTR,BGPNSTR)=""
 S START=9999999-BGPBDATE,END=9999999-BGPEDATE,VALUE=0
 S START2Y=9999999-$$FMADD^XLFDT(BGPEDATE,-730)
 S RETVAL="",VIEN=""     ;Return value
 S BGPSEX=$$SEX^AUPNPAT(DFN)
 Q:BGPSEX="M"    ;Patients must be female
 ;Pts must be 41-69
 ;No need to check further if no age match
 Q:(BGPAGEE<41)!(BGPAGEE>68)
 ;find outpatient encounter with provider within 2 years of BGPEDATE
 S FIRST=END-0.1 F  S FIRST=$O(^AUPNVSIT("AA",DFN,FIRST)) Q:FIRST=""!($P(FIRST,".",1)>START2Y)!(+VIEN)  D
 .S IEN=0 F  S IEN=$O(^AUPNVSIT("AA",DFN,FIRST,IEN)) Q:'+IEN!(VIEN]"")  D
 ..;Check provider, Only visits for chosen provider
 ..Q:'$$PRV^BGPMUUT1(IEN,BGPPROV)
 ..;Check E&M
 ..S AENC=$$VSTCPT^BGPMUUT1(DFN,IEN,"BGPMU MAMMOGRAM ENC EM")
 ..S BENC=$$VSTPOV^BGPMUUT3(DFN,IEN,"BGPMU MAMMOGRAM ENC ICD")
 ..Q:(AENC=0)&(BENC=0)
 ..S DATA=$G(^AUPNVSIT(IEN,0))
 ..S VDATE=$P($G(^AUPNVSIT(IEN,0)),U,1),VIEN=IEN
 I +VIEN D
 .S (STRING1,STRING2)=""
 .K BGPX
 .S MASTCNT=0
 .;Set a new begin date of 2 years prior to the visit
 .N X1,X2,X S X1=VDATE,X2=-730 D C^%DTC S BGPENC=X
 .S BGPDT=$P($P($G(^AUPNVSIT(VIEN,0)),U,1),".",1)
 .I AENC S STRING1="ENCC:"_$P(AENC,U,2)
 .I BENC S STRING1="ENCC:"_$P(BENC,U,2)
 .S BGPBIRTH=$P(^DPT(DFN,0),U,3)
 .I BGPBIRTH="" S BGPBIRTH=BGPENC
 .;First, check for bilateral mastectomy
 .S BGPBICPT=$$CPT("B")
 .I +BGPBICPT S VALUE=BGPBICPT,RETVAL=1 Q
 .;Then check for 2 unilateral CPT codes
 .S BGPUICPT=$$CPT("U")
 .I +BGPUICPT S VALUE=BGPUICPT,RETVAL=1 Q
 .;Quit if patient has ICD0 code for bilateral mastectomy on record
 .S BGPBIICD=$$LASTPRC^BGPMUUT2(DFN,BGPBIRTH,BGPEDATE,"BGPMU BILAT MASTECTOMY ICD")
 .I +BGPBIICD S VALUE=BGPBIICD,RETVAL=1 Q
 .;Check for 2 unilateral ICD0 codes
 .S BGPUIICD=$$ICD0("U")
 .I +BGPUIICD S VALUE=BGPUIICD,RETVAL=1 Q
 .;getting here means the patient is in the denominator
 .S BGPDSTR=BGPDT
 .;Check for mammogram in the last 2 years
 .S BGPMAM=$$CPT^BGPMUUT1(DFN,BGPENC,BGPEDATE,"BGPMU MAMMOGRAM CPTS")
 .I +BGPMAM=1 S RESULT=BGPMAM
 .S BGPMAM2=$$LASTPRC^BGPMUUT2(DFN,BGPENC,BGPEDATE,"BGPMU MAMMOGRAM ICD")
 .I +BGPMAM2=1 S RESULT=BGPMAM2
 .S BGPMAM3=$$LASTDX^BGPMUUT2(DFN,BGPENC,BGPEDATE,"BGPMU MAMMOGRAM DX")
 .I +BGPMAM3=1 S RESULT=BGPMAM3
 .S BGPMAM4=$$RAD^BGPMUUT1(DFN,BGPENC,BGPEDATE,"BGPMU MAMMOGRAM CPTS",7)
 .I +BGPMAM4 S RESULT=1_U_BGPMAM4
 .I +BGPMAM S STRING2="MAMC:"_$P(BGPMAM,U,2),BGPNSTR=$P(BGPMAM,U,2)_";"_$P($P(BGPMAM,U,3),".",1)
 .I +BGPMAM2 D
 ..I STRING2="" S STRING2="MAMP:"+$P(BGPMAM2,U,2),BGPNSTR=$P(BGPMAM2,U,2)_";"_$P($P(BGPMAM2,U,3),".",1)
 ..I STRING2'="" S STRING2=STRING2_";MAMP:"+$P(BGPMAM2,U,2),BGPNSTR=$P(BGPMAM2,U,2)_";"_$P($P(BGPMAM2,U,3),".",1)
 .I +BGPMAM3 D
 ..I STRING2="" S STRING2="MAMD:"+$P(BGPMAM3,U,2),BGPNSTR=$P(BGPMAM3,U,2)_";"_$P($P(BGPMAM3,U,3),".",1)
 ..I STRING2'="" S STRING2=STRING2_";MAMD:"+$P(BGPMAM3,U,2),BGPNSTR=$P(BGPMAM3,U,2)_";"_$P($P(BGPMAM3,U,3),".",1)
 .I +BGPMAM4 D
 ..I STRING2="" S STRING2="MAMC:"+$P(BGPMAM4,U,2),BGPNSTR=$P(BGPMAM4,U,2)_";"_$P($P(BGPMAM4,U,1),".",1)
 ..I STRING2'="" S STRING2=STRING2_";MAMC:"+$P(BGPMAM4,U,2),BGPNSTR=$P(BGPMAM4,U,2)_";"_$P($P(BGPMAM4,U,1),".",1)
 .D TOTAL(DFN,VIEN,BGPDSTR,BGPNSTR)
 Q
TOTAL(DFN,VIEN,BGPDSTR,BGPNSTR) ;See where this patient ends up
 N PTCNT,EXCCT,DENCT,NUMCT,TOTALS
 S TOTALS=$G(^TMP("BGPMU0031",$J,BGPMUTF,"TOT"))
 S DENCT=+$G(^TMP("BGPMU0031",$J,BGPMUTF,"DEN"))
 S NUMCT=+$G(^TMP("BGPMU0031",$J,BGPMUTF,"NUM"))
 S NOTCT=+$G(^TMP("BGPMU0031",$J,BGPMUTF,"NOT"))
 S PTCNT=TOTALS
 S PTCNT=PTCNT+1
 ;Do not include those with 2 mastectomies in the denominator
 Q:+VALUE
 S DENCT=DENCT+1 S ^TMP("BGPMU0031",$J,BGPMUTF,"DEN")=DENCT
 I +RESULT D
 .S NUMCT=NUMCT+1 S ^TMP("BGPMU0031",$J,BGPMUTF,"NUM")=NUMCT
 .I BGPMUTF="C" S ^TMP("BGPMU0031",$J,"PAT",BGPMUTF,"NUM",PTCNT)=DFN_U_STRING1_U_STRING2_U_$G(BGPDSTR)_U_$G(BGPNSTR)
 E  S ^TMP("BGPMU0031",$J,"PAT",BGPMUTF,"NOT",PTCNT)=DFN_U_STRING1_U_$G(STRING2)_U_$G(BGPDSTR)_U_$G(BGPNSTR) I BGPMUTF="C" S ^TMP("BGPMU0031",$J,"PAT",BGPMUTF,"DEN",PTCNT)=DFN_U_STRING1_U_U_$G(BGPDSTR)_U_$G(BGPNSTR)
 S ^TMP("BGPMU0031",$J,BGPMUTF,"TOT")=PTCNT
 ;Setup iCare array for patient
 S BGPICARE("MU.EP.0031.1",BGPMUTF)=1_U_+RESULT_U_""_U_$G(BGPDSTR)_";"_$G(BGPNSTR)
 Q
CPT(CODE) ;See if the patient has the CPT codes for mastectomy
 N VAL,TAX,FOUND,VISIT,CPT,MDATE,CPTCODE,MOD1,MOD2
 S VAL=0
 ;loop through all cpt codes up to Edate and if any match quit
 S TAX=$O(^ATXAX("B","BGPMU MASTECTOMY CPT",0))
 I TAX S FOUND="" D
 .S CPT=0 F  S CPT=$O(^AUPNVCPT("AC",DFN,CPT)) Q:CPT'=+CPT!(FOUND]"")  D
 ..S VISIT=$P($G(^AUPNVCPT(CPT,0)),U,3)
 ..Q:VISIT=""
 ..S MDATE=$P($P($G(^AUPNVSIT(VISIT,0)),U),".") ;date done
 ..Q:MDATE=""
 ..I MDATE>BGPEDATE Q
 ..S CPTCODE=$P(^AUPNVCPT(CPT,0),U)
 ..Q:'$$ICD^ATXCHK(CPTCODE,TAX,1)
 ..S:CODE="U" MASTCNT=MASTCNT+1
 ..S MOD1=$P(^AUPNVCPT(CPT,0),U,8)
 ..S MOD2=$P(^AUPNVCPT(CPT,0),U,9)
 ..D MODIFY(MOD1,MOD2)
 I 'FOUND S FOUND=0
 Q FOUND
ICD0(CODE) ;See if the patient has the CPT codes for mastectomy
 N VAL,TAX,FOUND,VISIT,ICD0,MDATE,ICDCODE,MOD1,MOD2,DATA
 S VAL=0,DATA=0
 ;loop through all ICD0 codes up to Edate and if any match quit
 S TAX=$O(^ATXAX("B","BGPMU UNI MASTECTOMY ICDS",0))
 I TAX S FOUND="" D
 .S ICD0=0 F  S ICD0=$O(^AUPNVPRC("AC",DFN,ICD0)) Q:ICD0'=+ICD0!(FOUND]"")  D
 ..S VISIT=$P($G(^AUPNVPRC(ICD0,0)),U,3)
 ..Q:VISIT=""
 ..S MDATE=$P($P($G(^AUPNVPRC(ICD0,0)),U,6),".")
 ..I MDATE="" S MDATE=$P($P($G(^AUPNVSIT(VISIT,0)),U),".") ;date done
 ..Q:MDATE=""
 ..I MDATE>BGPEDATE Q
 ..S ICDCODE=$P(^AUPNVPRC(ICD0,0),U)
 ..Q:'$$ICD^ATXCHK(ICDCODE,TAX,0)
 ..S:CODE="U" MASTCNT=MASTCNT+1
 ..S MOD1=$P(^AUPNVPRC(ICD0,0),U,17)
 ..S MOD2=$P(^AUPNVPRC(ICD0,0),U,18)
 ..D MODIFY(MOD1,MOD2)
 I 'FOUND S FOUND=0
 Q FOUND
MODIFY(MOD1,MOD2) ;Check for modifiers
 N MOD,DATE2
 S MOD=""
 S:MOD1 MOD=$P($G(@$$MODGBL@(MOD1,0)),U,1)
 S:MOD2 MOD=$P($G(@$$MODGBL@(MOD2,0)),U,1)
 I (MOD1=50)!(MOD2=50) S FOUND=1
 I CODE="U"&(MASTCNT=1) D
 .S BGPX(MASTCNT)=MDATE_U_MOD
 I CODE="U"&(MASTCNT>1) D
 .I MDATE'=$P(BGPX(1),U,1) S FOUND=1
 Q
MODGBL() Q $S($$CSVACT():"^DIC(81.3)",$G(DUZ("AG"))="I":"^AUTTCMOD",1:"^DIC(81.3)")
CSVACT(RTN) ;EP
 Q $S(DUZ("AG")'="I":1,$$VERSION^XPDUTL("BCSV")="":0,'$L($G(RTN)):1,1:$T(+0^@RTN)'="")
