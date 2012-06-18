BGPMUD05 ; IHS/MSC/SAT - MU measure NQF0014 ;14-JUN-2011 15:43;DU
 ;;11.1;IHS CLINICAL REPORTING SYSTEM;**1**;JUN 27, 2011;Build 106
 ;code to collect meaningful use report Prenatal Anti-D Immune Globulin
ENTRY ;EP
 ; expects:
 ;  DFN      = patient code from VA PATIENT file
 ;  BGPBDATE = begin date of report
 ;  BGPEDATE = end date of report
 ;  BGPPROV   = provider code from NEW PERSON file
 ;  BGPMUTF  = timeframe variable - "C"=current year; "P"=previous year; "B"=baseline year
 ; Print Routine:     P14ENT^BGPMUDP3
 ; Delimited Routine: D14ENT^BGPMUDD3
 N BGP3,BGPDEN,BGPDSTR,BGPDT,BGPEXC,BGPNSTR,BGPNUM,BGPP,BGPRHO,BGPSEX,BGPUNSEN
 N END,EXC,FIRST,IEN,START,VIEN,ESTDOC
 S (BGPDEN,BGPEXC,BGPNUM)=0
 S (BGPNSTR,BGPDSTR,BGP3)=""
 ;only check female
 S BGPSEX=$$SEX^AUPNPAT(DFN)
 Q:BGPSEX'="F"
 ;
 ;look for a delivery live birth procedure during the reporting period
 S BGPP=$$DLBCPT^BGPMUD04(DFN,BGPBDATE,BGPEDATE,"BGPMU DELIVERY LIVE BIRTH CPT")
 Q:'BGPP
 S ESTDOC=$$FMADD^XLFDT($P(BGPP,U,3),-300)
 ;
 ;look for prenatal visit with EP within 300 days of birth
 S START=9999999-ESTDOC,END=9999999-$P(BGPP,U,3)
 S FIRST=END-0.1 F  S FIRST=$O(^AUPNVSIT("AA",DFN,FIRST)) Q:FIRST=""!($P(FIRST,".",1)>START)  D
 .S VIEN=0 F  S VIEN=$O(^AUPNVSIT("AA",DFN,FIRST,VIEN)) Q:'+VIEN  D
 ..S BGPDT=$P($P($G(^AUPNVSIT(VIEN,0)),U,1),".",1)
 ..;Check provider, determine if there are visits with ICD codes for prenatal visit
 ..I $$PRV^BGPMUUT1(VIEN,BGPPROV) D
 ...S X=$$VSTPOV^BGPMUUT3(DFN,VIEN,"BGPMU PRENATAL VISIT DX")
 ...I +X S BGP3=BGP3_$S(BGP3'="":";",1:"")_$G(BGPDT)
 ;quit if no diagnosis for prenatal visit
 Q:BGP3=""
 ;
 S BGPUNSEN=$$UNSEN(DFN)
 Q:'BGPUNSEN
 ;getting here means patient is in the denominator
 S BGPDEN=1
 S BGPDSTR="DEL:"_$$DATE^BGPMUUTL($P(BGPP,U,3))_";EN:"_$$DATE^BGPMUUTL($P(BGP3,";"))
 ;
 ;determine if patient was given anti-d immune globulin between 118-90 days before the delivery date
 S BGPNUM=$$FIND^BGPMUUT8(DFN,"BGPMU ANTI-D IMMUNE GLOBUL NDC",$$FMADD^XLFDT($P(BGPP,U,3),-118),"",$$FMADD^XLFDT($P(BGPP,U,3),-90))
 ;
 ;check for exclusions
 I +BGPNUM D
 .S BGPNSTR="M:MED "_$$DATE^BGPMUUTL($P(BGPNUM,U,3))
 E  D
 .S EXC=$$MEDREF^BGPMUUT2(DFN,ESTDOC,$P(BGPP,U,3),"BGPMU ANTI-D IMMUNE GLOBUL NDC")
 .S:EXC BGPEXC=1,BGPNSTR="Excluded" ;patient is excluded
 .S:'EXC BGPNSTR="NM:"
 ;
 D TOTAL(DFN)
 ;
 K BGP3,BGPDEN,BGPDSTR,BGPDT,BGPEXC,BGPNSTR,BGPNUM,BGPP,BGPRHO,BGPSEX,BGPUNSEN
 K END,EXC,FIRST,IEN,START,VIEN,ESTDOC
 Q
UNSEN(DFN) ;Determine if patient is Rh negative and unsensitized
 N BGPRHT,RHTVAL,BGPABO,ABOVAL,BGPABO1,LIEN,VAL,DATA
 S (RHTVAL,ABOVAL)=""
 ;check for Rh type in blood bank
 S BGPRHT=$$RHTYPE^BGPMUUT5(DFN)
 S:+BGPRHT RHTVAL=$P(BGPRHT,U,2)
 ;check for Rh type in V LAB
 I '+BGPRHT D
 .S BGPRHT=$$LOINC^BGPMUUT2(DFN,"",$P(BGPP,U,3),"BGPMU RH TYPE LOINC")
 .I +BGPRHT D
 ..S LIEN=$P(BGPRHT,U,2)
 ..S RHTVAL=$P($G(^AUPNVLAB(LIEN,0)),U,4)
 Q:('BGPRHT)!((RHTVAL'="N")&(RHTVAL'="NEG")&(RHTVAL'="NEGATIVE")) 0
  ;check for result of antibody screen (indirect COOMBS)
 S BGPABO=$$ANTI^BGPMUUT5(DFN)
 S:+BGPABO ABOVAL=$P(BGPABO,U,2)
 I '+BGPABO D
 .S BGPABO=$$LOINC^BGPMUUT2(DFN,ESTDOC,$P(BGPP,U,3),"BGPMU INDIRECT COOMBS LOINC")
 .I +BGPABO D
 ..S ABOVAL=$P($G(^AUPNVLAB($P(BGPABO,U,2),0)),U,4)
 .E  D
 ..;check for HDL via CPT codes in LAB
 ..D LABCPT^BGPMUUT5(.DATA,DFN,"BGPMU INDIRECT COOMBS CPT",ESTDOC,$P(BGPP,U,3))
 ..S VAL="" S VAL=$O(DATA(VAL))
 ..I +VAL D
 ...S ABOVAL=$G(DATA(VAL))
 ...S BGPABO=1_(9999999-VAL)
 Q:('BGPABO)!((ABOVAL'="N")&(ABOVAL'="NEG")&(ABOVAL'="NEGATIVE")) 0
 Q 1
 ;
 ;
 ;CODE BELOW IS NO LONGER USED - NO MENTION OF RHOGAM OR ICD'S IN THE DENOMINATOR CRITERIA
 ;FROM Dr. Advani: Per Terry's recommendation earlier, we do not include system reasons until we implement full hl7 3.0 RIM codes for this.
 ;if no anti-body screening, look for ICD on problem list
 S BGPRHO=0
 I $P(BGPABO,U,2)=0 D
 .S BGPABO1=$$LASTDX^BGPMUUT2(DFN,BGPBDATE,BGPEDATE,"BGPMU CTRL HIGH BP HYP DX")
 .S:BGPABO1="" BGPABO1=$$PLTAX^BGPMUUT1(DFN,"BGPMU CTRL HIGH BP HYP DX")
 Q:'BGPABO1 0
 ;if unsensitized
 S:$P(BGPABO,U,2)="N" BGPRHO=$$FIND^BGPMUUT7(DFN,"BGPMU PRENATAL RHOGAM CPT",BGPBDATE,BGPEDATE)
 Q:'BGPRHO 0
 ;if sensitized check for sensitization ICD codes in problems list
 S:$P(BGPABO,U,2)="P" BGPRHO=$$PLTAX^BGPMUUT1(DFN,"BGPMU PRENATAL SENSITIZED ICD")
 Q:'BGPRHO 0
 Q 1
 ;
TOTAL(DFN) ;See where this patient ends up
 ;  BGPDSTR = Denominator string: encounter dates in FM format pieced by ";"
 ;  BGPNSTR = Numerator string: <health factor text> ";" <health factor edit date in FM format>
 ;if we got here, this patient is in the denominator
 N BGPDT,PTCNT,DENCT,NUMCT,NOTCT,TOTALS,PT1
 S TOTALS=$G(^TMP("BGPMU0014",$J,BGPMUTF,"TOT"))
 S NUMCT=+$G(^TMP("BGPMU0014",$J,BGPMUTF,"NUM"))
 S NOTCT=+$G(^TMP("BGPMU0014",$J,BGPMUTF,"NOT"))
 S DENCT=+$G(^TMP("BGPMU0014",$J,BGPMUTF,"DEN"))
 S EXCCT=+$G(^TMP("BGPMU0014",$J,BGPMUTF,"EXC"))
 S PTCNT=$P(TOTALS,U,1),PT1=$P(TOTALS,U,2)
 S PTCNT=PTCNT+1
 S PT1=PT1+1
 I BGPDEN D
 .S DENCT=DENCT+1 S ^TMP("BGPMU0014",$J,BGPMUTF,"DEN")=DENCT
 .S ^TMP("BGPMU0014",$J,BGPMUTF,"DEN","PAT",DENCT)=DFN
 .I BGPEXC D
 ..S EXCCT=EXCCT+1
 ..S ^TMP("BGPMU0014",$J,BGPMUTF,"EXC")=EXCCT
 ..S ^TMP("BGPMU0014",$J,"PAT",BGPMUTF,"EXC",PT1)=DFN_U_BGPDSTR_U_"Excluded"
 .I 'BGPEXC D
 ..I BGPNUM D
 ...S NUMCT=NUMCT+1
 ...S ^TMP("BGPMU0014",$J,BGPMUTF,"NUM")=NUMCT
 ...S ^TMP("BGPMU0014",$J,"PAT",BGPMUTF,"NUM",PT1)=DFN_U_BGPDSTR_U_BGPNSTR
 ..I 'BGPNUM D
 ...S NOTCT=NOTCT+1
 ...S ^TMP("BGPMU0014",$J,BGPMUTF,"NOT")=NOTCT
 ...S ^TMP("BGPMU0014",$J,"PAT",BGPMUTF,"NOT",PT1)=DFN_U_BGPDSTR_U_BGPNSTR
 S ^TMP("BGPMU0014",$J,BGPMUTF,"TOT")=PTCNT_U_PT1
 ;Setup iCare array for patient
 S BGPICARE("MU.EP.0014.1",BGPMUTF)=+BGPDEN_U_+BGPNUM_U_+BGPEXC_U_$G(BGPDSTR)_";"_$G(BGPNSTR)
 Q
 ;
TEST ; debug target
 ;S U="^"
 ;S DT=$$DT^XLFDT()
 ;S DFN=184            ;  DFN      = patient code from VA PATIENT file
 ;S BGPBDATE=3100401   ;  BGPBDATE = begin date of report
 ;S BGPEDATE=3110401   ;  BGPEDATE = end date of report
 ;S BGPPROV=2          ;  BGPPROV   = provider code from NEW PERSON file
 ;S BGPMUTF="C"        ;  BGPMUTF  = timeframe variable - "C"=current year; "P"=previous year; "B"=baseline year
 ;D ENTRY
 Q
