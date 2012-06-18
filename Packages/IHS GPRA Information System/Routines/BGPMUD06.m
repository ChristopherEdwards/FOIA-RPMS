BGPMUD06 ; IHS/MSC/SAT - MU measure NQF0018 ;16-JUN-2011 15:43;DU
 ;;11.1;IHS CLINICAL REPORTING SYSTEM;**1**;JUN 27, 2011;Build 106
 ;code to collect meaningful use report Control High Blood Pressure NQF 0018
ENTRY ;EP
 ; expects:
 ;  DFN      = patient code from VA PATIENT file
 ;  BGPBDATE = begin date of report
 ;  BGPEDATE = end date of report
 ;  BGPPROV   = provider code from NEW PERSON file
 ;  BGPMUTF  = timeframe variable - "C"=current year; "P"=previous year; "B"=baseline year
 ; Print Routine:     P18ENT^BGPMUDP3
 ; Delimited Routine: D18ENT^BGPMUDD3
 N BGP6,BGPAGEE,BGPBP,BGPBPDIA,BGPBPDT,BGPBPSYS,BGPDEN,BGPHYPDX,BGPNUM,BGPDT,BGPOP,BGPVIEN
 N BGPBPS,BGPESRD,BGPPREG
 N END,FIRST,IEN,START,VIEN
 S BGPDEN=0
 S BGPNUM=0
 S BGPNSTR=""
 S BGPDSTR=""
 S (BGPBP,BGPBPS,BGPBPDIA,BGPBPDT,BGPBPSYS,BGPESRD,BGPHYPDX,BGPOP,BGPPREG,BGPVIEN)=""
 ;patient needs to reach the an age between 18 and 85 by the end of the measurement period
 S BGPAGEE=$$AGE^AUPNPAT(DFN,BGPEDATE)
 Q:BGPAGEE<18
 Q:BGPAGEE>85
 ;getting here means the patient is in the initial population
 ;
 ;look for hypertension during the measurement period
 S BGPHYP=$$LASTDX^BGPMUUT2(DFN,BGPBDATE,BGPEDATE,"BGPMU CTRL HIGH BP HYP DX")
 S:'+BGPHYP BGPHYP=$$PLTAX^BGPMUUT1(DFN,"BGPMU CTRL HIGH BP HYP DX")
 Q:'BGPHYP
 S BGPICD="ICD"_" "_$$FMTE^XLFDT($P(BGPHYP,U,3),2)
 ;
 ;look for an outpatient encounter with the provider during the measurement period
 S START=9999999-BGPBDATE,END=9999999-BGPEDATE
 S FIRST=END-0.1 F  S FIRST=$O(^AUPNVSIT("AA",DFN,FIRST)) Q:FIRST=""!($P(FIRST,".",1)>START)  D  Q:BGPOP
 .S VIEN=0 F  S VIEN=$O(^AUPNVSIT("AA",DFN,FIRST,VIEN)) Q:'+VIEN  D  Q:BGPOP
 ..S BGPDT=$P($P($G(^AUPNVSIT(VIEN,0)),U,1),".",1)
 ..;Check provider
 ..I $$PRV^BGPMUUT1(VIEN,BGPPROV) D
 ...S X=$$VSTCPT^BGPMUUT1(DFN,VIEN,"BGPMU CTRL HIGH BP EM")  ;look for outpatient EM
 ...S:'+X X=$$VSTPOV^BGPMUUT3(DFN,VIEN,"BGPMU COLON ENC DX")
 ...S:+X BGPOP=VIEN_U_$G(BGPDT)
 Q:'BGPOP
 ;
 ;look for pregnancy
 S BGPPREG=$$LASTDX^BGPMUUT2(DFN,BGPBDATE,BGPEDATE,"BGPMU PREGNANCY ALL ICD")
 Q:BGPPREG
 ;look for procedures & diagnosis indicating ESRD
 S BGPESRD=$$LASTDX^BGPMUUT2(DFN,BGPBDATE,BGPEDATE,"BGPMU ESRD DX")
 Q:BGPESRD
 S BGPESRD=$$PLTAX^BGPMUUT1(DFN,"BGPMU ESRD DX","C")
 Q:BGPESRD
 S BGPESRD=$$CPT^BGPMUUT1(DFN,BGPBDATE,BGPEDATE,"BGPMU ESRD CPT")
 Q:BGPESRD
 S BGPESRD=$$CPT^BGPMUUT1(DFN,BGPBDATE,BGPEDATE,"BGPMU ESRD HCPCS")
 Q:BGPESRD
 S BGPESRD=$$LASTPRC^BGPMUUT2(DFN,BGPBDATE,BGPEDATE,"BGPMU ESRD PX")
 Q:BGPESRD
 ;getting here means the patient is in the denominator
 S BGPDEN=1
 ;
 ;check blood pressure reading of most recent outpatient encounter
 D BPC
 D TOTAL(DFN)
 ;
 ;there are no exclusions
 ;
 ;cleanup
 K BGP6,BGPAGEE,BGPBP,BGPBPDIA,BGPBPDT,BGPBPSYS,BGPDEN,BGPHYPDX,BGPNUM,BGPDT,BGPOP,BGPVIEN
 K END,FIRST,IEN,START,VIEN
 Q
 ;
TOTAL(DFN) ;See where this patient ends up
 ;  BGPDSTR = ???
 ;  BGPNSTR = ???
 N BGPDT,PTCNT,DENCT,NUMCT,NOTCT,TOTALS,PT1
 S TOTALS=$G(^TMP("BGPMU0018",$J,BGPMUTF,"TOT"))
 S NUMCT=+$G(^TMP("BGPMU0018",$J,BGPMUTF,"NUM",1))
 S NOTCT=+$G(^TMP("BGPMU0018",$J,BGPMUTF,"NOT",1))
 S DENCT=+$G(^TMP("BGPMU0018",$J,BGPMUTF,"DEN",1))
 S PTCNT=$P(TOTALS,U,1),PT1=$P(TOTALS,U,2)
 S PTCNT=PTCNT+1
 S PT1=PT1+1
 I BGPDEN D
 .S DENCT=DENCT+1 S ^TMP("BGPMU0018",$J,BGPMUTF,"DEN",1)=DENCT
 .S ^TMP("BGPMU0018",$J,"PAT",BGPMUTF,"DEN",1,DENCT)=DFN
 .I BGPNUM D
 ..S NUMCT=NUMCT+1
 ..S ^TMP("BGPMU0018",$J,BGPMUTF,"NUM",1)=NUMCT
 ..S ^TMP("BGPMU0018",$J,"PAT",BGPMUTF,"NUM",1,PT1)=DFN_U_BGPICD_";"_"EN "_$$FMTE^XLFDT($P(BGPOP,U,2),2)_";"_BGPBPS
 .I 'BGPNUM D
 ..S NOTCT=NOTCT+1
 ..S ^TMP("BGPMU0018",$J,BGPMUTF,"NOT",1)=NOTCT
 ..S ^TMP("BGPMU0018",$J,"PAT",BGPMUTF,"NOT",1,PT1)=DFN_U_BGPICD_";"_"EN "_$$FMTE^XLFDT($P(BGPOP,U,2),2)_";"_BGPBPS
 S ^TMP("BGPMU0018",$J,BGPMUTF,"TOT")=PTCNT_U_PT1
 ;Setup iCare array for patient
 S BGPICARE("MU.EP.0018.1",BGPMUTF)=BGPDEN_U_BGPNUM_U_""_U_BGPICD_";"_BGPBPS
 Q
 ;
BPC  ;check blood pressure reading of most recent outpatient encounter
 N LDIA,LSYS
 S (LDIA,LSYS)=""
 D BP(DFN,$P(BGPOP,U,1),.BGPBP)
 S BGPCNT=0
 I BGPBP="" S BGPBPS="NM:" Q
 ;loop to find lowest BP readings
 F BGPI=1:1:$L(BGPBP,";") D
 .S X=$P($P(BGPBP,";",BGPI),":",2) S %DT="T" D ^%DT S BGPBPDT=Y
 .S BGPBPSYS=$P($P($P(BGPBP,";",BGPI),":",1),"/",1)
 .S BGPBPDIA=$P($P($P(BGPBP,";",BGPI),":",1),"/",2)
 .S:(LSYS="")!($P(LSYS,U,2)>BGPBPSYS) LSYS=BGPI_U_BGPBPSYS_U_BGPBPDIA
 .S:(LDIA="")!($P(LDIA,U,3)>BGPBPDIA) LDIA=BGPI_U_BGPBPSYS_U_BGPBPDIA
 Q:(LSYS="")&(LDIA="")  ;shouldn't happen, but just in case
 I (LSYS=LDIA) D  ;if lowest BP's are in the same reading create only one MET row
 .I ($P(LSYS,U,2)<140)&($P(LDIA,U,3)<90) D
 ..S BGPNUM=1
 ..S BGPCNT=BGPCNT+1
 ..S BGPBPS="M:"_$P(LSYS,U,2)_"/"_$P(LSYS,U,3)_" "_$$FMTE^XLFDT($P(BGPOP,U,2),2)
 .I '(($P(LSYS,U,2)<140)&($P(LDIA,U,3)<90)) D
 ..;one BP, but NOT MET
 ..S BGPBPS="NM:"_$P(LSYS,U,2)_"/"_$P(LSYS,U,3)_" "_$$FMTE^XLFDT($P(BGPOP,U,2),2)
 Q:BGPBPS'=""
 ;if we get here, pt has lowest BP readings on two different measurements
 I ($P(LSYS,U,2)<140)&($P(LDIA,U,3)<90) D
 .;create two MET
 .S BGPNUM=1
 .S BGPCNT=BGPCNT+1
 .S BGPBPS="M:"_$P(LSYS,U,2)_"/"_$P(LSYS,U,3)_" "_$$FMTE^XLFDT($P(BGPOP,U,2),2)
 .S BGPBPS=BGPBPS_"*"_"  "_$P(LDIA,U,2)_"/"_$P(LDIA,U,3)_" "_$$FMTE^XLFDT($P(BGPOP,U,2),2)
 Q:BGPBPS'=""
 ;if we get here pt has high BP
 ;create two NOT MET rows
 S BGPBPS="NM:"_$P(LSYS,U,2)_"/"_$P(LSYS,U,3)_" "_$$FMTE^XLFDT($P(BGPOP,U,2),2)
 S BGPBPS=BGPBPS_"*"_"   "_$P(LDIA,U,2)_"/"_$P(LDIA,U,3)_" "_$$FMTE^XLFDT($P(BGPOP,U,2),2)
 Q
 ;
BP(DFN,VIEN,NUM) ;Find is pt has a BP on the chosen visits
 N IEN,MSR,MTYP,BP,BPCNT,SAVE,ARRAY,VST,VCNT
 S BP="",BPCNT=0,VCNT=0
 S MTYP="" S MTYP=$O(^AUTTMSR("B","BP",MTYP))
 Q:MTYP="" 0
 S IEN=VIEN,SAVE=0
 S MSR="" F  S MSR=$O(^AUPNVMSR("AD",VIEN,MSR)) Q:MSR=""  D
 .I $P($G(^AUPNVMSR(MSR,0)),U,1)=MTYP D
 ..S BPCNT=BPCNT+1
 ..S ARRAY(IEN)=""
 ..I BPCNT=1 S BP=$P($G(^AUPNVMSR(MSR,0)),U,4)_":"_$$DATE^BGPMUUTL($P($G(^AUPNVMSR(MSR,12)),U,1))
 ..I BPCNT>1 S BP=BP_";"_$P($G(^AUPNVMSR(MSR,0)),U,4)_":"_$$DATE^BGPMUUTL($P($G(^AUPNVMSR(MSR,12)),U,1))
 ;
 I BPCNT>0 S NUM=BP
 Q
 ;
TEST ; debug target
 S U="^"
 S DT=$$DT^XLFDT()
 S DFN=184            ;  DFN      = patient code from VA PATIENT file
 S BGPBDATE=3110401   ;  BGPBDATE = begin date of report
 S BGPEDATE=3110701   ;  BGPEDATE = end date of report
 S BGPPROV=2          ;  BGPPROV   = provider code from NEW PERSON file
 S BGPMUTF="C"        ;  BGPMUTF  = timeframe variable - "C"=current year; "P"=previous year; "B"=baseline year
 D ENTRY
 Q
