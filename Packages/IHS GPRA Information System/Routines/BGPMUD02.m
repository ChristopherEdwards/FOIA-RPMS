BGPMUD02 ; IHS/MSC/SAT - MU measure NQF0028B ;28-Dec-2010 16:14;DU
 ;;11.1;IHS CLINICAL REPORTING SYSTEM;**1**;JUN 27, 2011;Build 106
 ;code to collect meaningful use report tobacco use assessment
ENTRY ;EP
 ; expects:
 ;  DFN      = patient code from VA PATIENT file
 ;  BGPBDATE = begin date of report
 ;  BGPEDATE = end date of report
 ;  BGPPROV   = provider code from NEW PERSON file
 ;  BGPMUTF  = timeframe variable - "C"=current year; "P"=previous year; "B"=baseline year
 N BGPDIEN,BGPDIFN,BGP1,BGP2,BGP3,BGPDEN,BGPNUM,BGPDT,BGPAGEE,END,FIRST,IEN,START,VDATE,VIEN
 N BGPHFI
 S BGPDEN=0
 S BGPNUM=0
 S BGPNSTR=""   ; <NDC code> OR <CPT code> ; [date in FM format]
 S BGPDSTR=""
 ;Pts must be 18 and older
 S BGPAGEE=$$AGE^AUPNPAT(DFN,BGPBDATE)
 ;No need to check further on children
 Q:BGPAGEE<18
 ;
 S START=9999999-BGPBDATE,END=9999999-BGPEDATE
 ;look for 2 visits with E&M codes
 ;    OR   1 visit with E&M codes
 S BGP1=""
 S BGP2=""
 S FIRST=END-0.1 F  S FIRST=$O(^AUPNVSIT("AA",DFN,FIRST)) Q:FIRST=""!($P(FIRST,".",1)>START)  D  Q:($L(BGP2,";")>1)!(BGP1'="")
 .S VIEN=0 F  S VIEN=$O(^AUPNVSIT("AA",DFN,FIRST,VIEN)) Q:'+VIEN  D  Q:($L(BGP2,";")>1)!(BGP1'="")
 ..S BGPDT=$P($P($G(^AUPNVSIT(VIEN,0)),U,1),".",1)
 ..;Check provider, determine if there are visits with E&M codes
 ..I $$PRV^BGPMUUT1(VIEN,BGPPROV) D
 ...D EM2^BGPMUD01(DFN,VIEN,.BGP2,BGPDT)  ;determine if there are visits that have at least one of the E&M codes where 2 are necessary
 ...D EM1^BGPMUD01(DFN,VIEN,.BGP1,BGPDT)  ;determine if there are visits that have at least one of the E&M codes where only 1 is necessary
 ;TEST
 ;quit if visits with E&M code(s) not found for given DFN
 Q:(BGP1="")&(BGP2="")
 Q:(BGP1="")&($L(BGP2,";")'>1)
 ;getting here means this patient has been screened for Tobacco Use
 ;
 ;combine BGP1 and BPG2 into one string
 S BGPDSTR=$S(BGP2'="":BGP2_$S(BGP1'="":";"_BGP1,1:""),1:BGP1)
 ;
 ;determine if this patient is a Tobacco User
 N BGPH,BGPHF,BGPTOBN,BGPTOBU
 S BGPHF=0  ;health factor found flag
 S BGPTOBU=1
 D HFA^BGPMUD01(.BGPTOBU)
 S START=9999999-$$FMADD^XLFDT(BGPBDATE,-730)
 S FIRST=END-0.1 F  S FIRST=$O(^AUPNVSIT("AA",DFN,FIRST)) Q:FIRST=""!($P(FIRST,".",1)>START)  D  Q:BGPHF
 .S VIEN=0 F  S VIEN=$O(^AUPNVSIT("AA",DFN,FIRST,VIEN)) Q:'+VIEN  D  Q:BGPHF
 ..S BGPIEN="" F  S BGPIEN=$O(^AUPNVHF("AD",VIEN,BGPIEN)) Q:'+BGPIEN  D
 ...S BGPHNOD=$G(^AUPNVHF(BGPIEN,0))
 ...S BGPHFI=$P(BGPHNOD,U,1)
 ...S BGPH="" F  S BGPH=$O(BGPTOBU(BGPH)) Q:BGPH=""  Q:BGPHF  I BGPHFI=BGPH S BGPHF=1_";"_$P($P($G(^AUPNVHF(BGPIEN,12)),U,1),".",1)
 I BGPHF D
 .S BGPDEN=1  ;patient is in the denominator - patient has been screened for Tobacco Use AND is a Tobacco User
 .S BGPDSTR=BGPDSTR_":"_$P(BGPHF,";",2)
 Q:'BGPDEN
 ;
 ;determine if patient is participating in a smoking cessation program (numerator)
 ; BGP3 = [CPT code] ; date in FM format
 S BGP3=""
 S FIRST=END-0.1 F  S FIRST=$O(^AUPNVSIT("AA",DFN,FIRST)) Q:FIRST=""!($P(FIRST,".",1)>START)  D  Q:BGP3>0
 .S VIEN=0 F  S VIEN=$O(^AUPNVSIT("AA",DFN,FIRST,VIEN)) Q:'+VIEN  D  Q:BGP3>0
 ..;S BGPDT=9999999-FIRST  ;convert date to fileman format
 ..S BGPDT=$P($P($G(^AUPNVSIT(VIEN,0)),U,1),".",1)
 ..D EM3(DFN,BGPDT,.BGP3)  ;determine if there is a visit that has a CPT code for Tobacco Use Cessation Counseling
 ..I BGP3>0 S BGPNUM=1 S BGPNSTR=BGP3
 ;determine if patient has medications that are Smoking Cessation Agents
 I 'BGPNUM D
 .S BGP4=0
 .K ^TMP("PS",$J)
 .N BGPI,BGPIFN,BGPRX0
 .S BGP4=$$FIND^BGPMUUT8(DFN,"BGPMU SMOKING CESSATION AGENTS",9999999-START,"",BGPEDATE)
 .;S BGP4=$$FIND^BGPMUUT4(DFN,"BGPMU SMOKING CESSATION AGENTS",9999999-START,"OP",BGPEDATE)
 .S:BGP4>0 BGPNUM=1,BGPNSTR=$P(BGP4,U,2)
 ;D OCL^PSOORRL(DFN,9999999-START,BGPEDATE)  ;collect patient's meds in ^TMP
 ;.S BGPI="" F  S BGPI=$O(^TMP("PS",$J,BGPI)) Q:BGPI=""  D
 ;..S BGPDIFN=$P($G(^TMP("PS",$J,BGPI,0)),U,2)
 ;..S BGPDIEN=$O(^PSDRUG("B",BGPDIFN,""))    ;get pointer to DRUG file
 ;..D NDC(BGPDIEN,.BGP4)
 K ^TMP("PS",$J)
 ; update TOTAL
 D TOTAL(DFN,BGPNUM,BGPMUTF,BGPDSTR,BGPNSTR)
 ;
 ; check these
 K BGPL,BGPLWTS,BGPLHTS,%,X,BGPLWTS1,BGPLHTS1,Y,TERMINAL,NORMAL,FOLLOW,EXCEPT
 Q
 ;
TOTAL(DFN,BGPNUM,BGPMUTF,BGPDSTR,BGPNSTR) ;See where this patient ends up
 ;if we got here, this patient is in the denominator
 N PTCNT,DEN1CT,INCL1CT,NOT1CT,TOTALS,PT1
 S TOTALS=$G(^TMP("BGPMU0028B",$J,BGPMUTF,"TOT"))
 S INCL1CT=+$G(^TMP("BGPMU0028B",$J,BGPMUTF,"INCL",1))
 S NOT1CT=+$G(^TMP("BGPMU0028B",$J,BGPMUTF,"NOT",1))
 S DEN1CT=+$G(^TMP("BGPMU0028B",$J,BGPMUTF,"DEN",1))
 S PTCNT=$P(TOTALS,U,1),PT1=$P(TOTALS,U,2)
 S PTCNT=PTCNT+1
 S PT1=PT1+1
 I BGPDEN D
 .S DEN1CT=DEN1CT+1 S ^TMP("BGPMU0028B",$J,BGPMUTF,"DEN",1)=DEN1CT
 .S ^TMP("BGPMU0028B",$J,BGPMUTF,"DEN","PAT",1,PT1)=DFN_U_BGPDSTR_U_BGPNSTR
 .I BGPNUM D
 ..S INCL1CT=INCL1CT+1
 ..S ^TMP("BGPMU0028B",$J,BGPMUTF,"INCL",1)=INCL1CT
 ..S ^TMP("BGPMU0028B",$J,BGPMUTF,"INCL","PAT",1,PT1)=DFN_U_BGPDSTR_U_BGPNSTR
 .I 'BGPNUM D
 ..S NOT1CT=NOT1CT+1
 ..S ^TMP("BGPMU0028B",$J,BGPMUTF,"NOT",1)=NOT1CT
 ..S ^TMP("BGPMU0028B",$J,BGPMUTF,"NOT","PAT",1,PT1)=DFN_U_BGPDSTR
 S ^TMP("BGPMU0028B",$J,BGPMUTF,"TOT")=PTCNT_U_PT1
 Q
 ;
 ;look for NDC codes related to Tobacco use Cessation Agents
NDC(BGPDIEN,BGP4) ;
 N BGPI,BGPNDC,BGPTMP
 F BGPI=1:1 Q:BGP4>0  S BGPTMP=$P($T(NDCT+BGPI),";;",2) Q:BGPTMP=""  S BGPNDC=$$NDC^BGPMUUT4(BGPDIEN,BGPTMP) I BGPNDC S BGP4=U_$P(BGPNDC,U,2)_U_$P($P(BGPNDC,U,3),".",1)
 Q
 ;
 ;look for CPT codes related to Tobacco use Cessation Counseling
EM3(DFN,BGPDT,BGP3) ;
 N BGPCPT,BGPI,BGPTMP1
 S BGPTMP1=""
 F BGPI=1:1 Q:BGP3>0  S BGPTMP1=$P($T(CPT3+BGPI),";;",2) Q:BGPTMP1=""  S BGPCPT=$$VSTCPT^BGPMUUT1(DFN,VIEN,BGPTMP1) I BGPCPT S BGP3=$P(BGPCPT,U,2)_";"_$P($P(BGPCPT,U,3),".",1)
 Q
 ;
CPT3 ;;
 ;;BGPMU TOBACCO USE CESS COUNSEL
 ;
NDCT ;;
 ;;BGPMU SMOKING CESSATION AGENTS
 ;
TESTC ;capture input data
 ; call with D:$G(^TMP("BGPMU0028B","TEST")=1 TESTC
 ;  DFN      = patient code from VA PATIENT file
 ;  BGPBDATE = begin date of report
 ;  BGPEDATE = end date of report
 ;  BGPPROV   = provider code from NEW PERSON file
 ;  BGPMUTF  = timeframe variable - "C"=current year; "P"=previous year; "B"=baseline year
 S ^TMP("BGPMU0028B",$J,"J")=$J
 S ^TMP("BGPMU0028B",$J,"DFN")=DFN
 S ^TMP("BGPMU0028B",$J,"BGPBDATE")=BGPBDATE
 S ^TMP("BGPMU0028B",$J,"BGPEDATE")=BGPEDATE
 S ^TMP("BGPMU0028B",$J,"BGPPROV")=BGPPROV
 S ^TMP("BGPMU0028B",$J,"BGPMUTF")=BGPMUTF
 Q
 ;
TESTH ;debug
 ;S U="^"
 ;S DUZ=1
 ;S DT=3110217
 ;S DFN=184
 ;S DFN=158
 ;S BGPBDATE=3100101
 ;S BGPEDATE=3110401
 ;S BGPPROV=2
 ;S BGPMUTF="C"
 ;D ENTRY
 Q
