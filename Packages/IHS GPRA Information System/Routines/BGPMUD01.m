BGPMUD01 ; IHS/MSC/SAT - MU measure NQF0028A ;11-Feb-2011 15:43;DU
 ;;11.1;IHS CLINICAL REPORTING SYSTEM;**1**;JUN 27, 2011;Build 106
 ;code to collect meaningful use report tobacco use assessment
ENTRY ;EP
 ; expects:
 ;  DFN      = patient code from VA PATIENT file
 ;  BGPBDATE = begin date of report
 ;  BGPEDATE = end date of report
 ;  BGPPROV   = provider code from NEW PERSON file
 ;  BGPMUTF  = timeframe variable - "C"=current year; "P"=previous year; "B"=baseline year
 N BGP1,BGP2,BGPDEN,BGPDSTR,BGPNUM,BGPNSTR,BGPDT,BGPAGEE,END,FIRST,IEN,START,VDATE,VIEN
 N BGPHFI
 ;K ^TMP("BGPMU0028A",$J)
 S BGPDEN=0
 S BGPNUM=0
 S BGPDSTR=""
 S BGPNSTR=""
 ;Pts must be 18 or older
 S BGPAGEE=$$AGE^AUPNPAT(DFN,BGPBDATE)
 ;No need to check further on children
 Q:BGPAGEE<18
 ;
 S START=9999999-BGPBDATE,END=9999999-BGPEDATE
 ;look for 2 visits with E&M codes
 ;    OR   1 visit with E&M codes
 S (BGP1,BGP2)=""
 S FIRST=END-0.1 F  S FIRST=$O(^AUPNVSIT("AA",DFN,FIRST)) Q:FIRST=""!($P(FIRST,".",1)>START)  D  Q:($L(BGP2,";")>1)!(BGP1'="")
 .S VIEN=0 F  S VIEN=$O(^AUPNVSIT("AA",DFN,FIRST,VIEN)) Q:'+VIEN  D  Q:($L(BGP2,";")>1)!(BGP1'="")
 ..S BGPDT=$P($P($G(^AUPNVSIT(VIEN,0)),U,1),".",1)
 ..;Check provider, determine if there are visits with E&M codes
 ..I $$PRV^BGPMUUT1(VIEN,BGPPROV) D
 ...D EM2(DFN,VIEN,.BGP2,BGPDT)  ;determine if there are visits that have at least one of the E&M codes where 2 are necessary
 ...D EM1(DFN,VIEN,.BGP1,BGPDT)  ;determine if there are visits that have at least one of the E&M codes where only 1 is necessary
 ;
 ;quit if visits with E&M code(s) not found for given DFN
 Q:(BGP1="")&(BGP2="")
 Q:(BGP1="")&($L(BGP2,";")'>1)
 ;getting here means this patient is in the denominator
 S BGPDEN=1
 ;combine BGP1 and BPG2 into one string
 S BGPDSTR=$S(BGP2'="":BGP2_$S(BGP1'="":";"_BGP1,1:""),1:BGP1)
 ;
 ;determine if this patient is in the numerator
 N BGPH,BGPHFF,BGPTOBN,BGPTOBU
 S BGPHFF=0  ;health factor found flag
 S BGPTOBU=1
 S BGPTOBN=1
 D HFA(.BGPTOBU,.BGPTOBN)
 S START=9999999-$$FMADD^XLFDT(BGPBDATE,-730)
 S FIRST=END-0.1 F  S FIRST=$O(^AUPNVSIT("AA",DFN,FIRST)) Q:FIRST=""!($P(FIRST,".",1)>START)  D  Q:BGPHFF
 .S VIEN=0 F  S VIEN=$O(^AUPNVSIT("AA",DFN,FIRST,VIEN)) Q:'+VIEN  D  Q:BGPHFF
 ..S BGPDT=$P($P($G(^AUPNVSIT(VIEN,0)),U,1),".",1)
 ..S BGPIEN="" F  S BGPIEN=$O(^AUPNVHF("AD",VIEN,BGPIEN)) Q:'+BGPIEN  D
 ...S BGPHFI=$P($G(^AUPNVHF(BGPIEN,0)),U,1)
 ...S BGPH="" F  S BGPH=$O(BGPTOBU(BGPH)) Q:BGPH=""  Q:BGPHFF  I BGPHFI=BGPH S BGPHFF=1 S BGPNSTR=BGPTOBU(BGPH)_";"_BGPDT
 ...I 'BGPHFF S BGPH="" F  S BGPH=$O(BGPTOBN(BGPH)) Q:BGPH=""  Q:BGPHFF  I BGPHFI=BGPH S BGPHFF=1 S BGPNSTR=BGPTOBN(BGPH)_";"_BGPDT
 I BGPHFF S BGPNUM=1  ;patient is in the numerator
 ; update TOTAL
 D TOTAL(DFN,BGPNUM,BGPMUTF,BGPDSTR,BGPNSTR)
 ;
 ; check these
 K BGPL,BGPLWTS,BGPLHTS,%,X,BGPLWTS1,BGPLHTS1,Y,TERMINAL,NORMAL,FOLLOW,EXCEPT
 Q
 ;
TOTAL(DFN,BGPNUM,BGPMUTF,BGPDSTR,BGPNSTR) ;See where this patient ends up
 ;  BGPDSTR = Denominator string: encounter dates in FM format pieced by ";"
 ;  BGPNSTR = Numerator string: <health factor text> ";" <health factor edit date in FM format>
 ;if we got here, this patient is in the denominator
 N BGPDT,PTCNT,DEN1CT,INCL1CT,NOT1CT,TOTALS,PT1
 S TOTALS=$G(^TMP("BGPMU0028A",$J,BGPMUTF,"TOT"))
 S INCL1CT=+$G(^TMP("BGPMU0028A",$J,BGPMUTF,"INCL",1))
 S NOT1CT=+$G(^TMP("BGPMU0028A",$J,BGPMUTF,"NOT",1))
 S DEN1CT=+$G(^TMP("BGPMU0028A",$J,BGPMUTF,"DEN",1))
 S PTCNT=$P(TOTALS,U,1),PT1=$P(TOTALS,U,2)
 S PTCNT=PTCNT+1
 S PT1=PT1+1
 I BGPDEN D
 .S DEN1CT=DEN1CT+1 S ^TMP("BGPMU0028A",$J,BGPMUTF,"DEN",1)=DEN1CT
 .S ^TMP("BGPMU0028A",$J,BGPMUTF,"DEN","PAT",1,DEN1CT)=DFN_U_BGPDSTR
 .I BGPNUM D
 ..S INCL1CT=INCL1CT+1
 ..S ^TMP("BGPMU0028A",$J,BGPMUTF,"INCL",1)=INCL1CT
 ..S ^TMP("BGPMU0028A",$J,BGPMUTF,"INCL","PAT",1,PT1)=DFN_U_BGPDSTR_U_BGPNSTR
 .I 'BGPNUM D
 ..S NOT1CT=NOT1CT+1
 ..S ^TMP("BGPMU0028A",$J,BGPMUTF,"NOT",1)=NOT1CT
 ..S ^TMP("BGPMU0028A",$J,BGPMUTF,"NOT","PAT",1,PT1)=DFN_U_BGPDSTR
 S ^TMP("BGPMU0028A",$J,BGPMUTF,"TOT")=PTCNT_U_PT1
 ;Setup iCare array for patient
 S BGPICARE("MU.EP.0028a.1",BGPMUTF)=BGPDEN_U_BGPNUM_U_""_U_$G(BGPDSTR)_";"_$G(BGPNSTR)
 Q
 ;
 ;look for E&M codes related to "office visit", "health and behavior assessment", "occupational therapy", "phychiatric & psychologic"
EM2(DFN,VIEN,BGP2,BGPDT) ;
 N BGPI,BGPTMP
 F BGPI=1:1 Q:$L(BGP2,";")>1  S BGPTMP=$P($T(CPT2+BGPI),";;",2) Q:BGPTMP=""  D
 .S X=+$$VSTCPT^BGPMUUT1(DFN,VIEN,BGPTMP)
 .I +X S BGP2=BGP2_$S(BGP2'="":";",1:"")_$G(BGPDT)
 Q
 ;
 ;look for E&M codes related to "preventive medicine service 18 and older"
 ;                              "prev - individual counseling"
 ;                              "prev med group counseling"
 ;                              "prev med other services"
EM1(DFN,VIEN,BGP1,BGPDT) ;
 N BGPI,BGPTMP
 F BGPI=1:1 Q:BGP1>0  S BGPTMP=$P($T(CPT1+BGPI),";;",2) Q:BGPTMP=""  D
 .S X=+$$VSTCPT^BGPMUUT1(DFN,VIEN,BGPTMP)
 .I +X S BGP1=BGP1_$S(BGP1'="":";",1:"")_$G(BGPDT)
 Q
 ;
TOBU ;;
 ;;CURRENT SMOKER, EVERY DAY
 ;;CURRENT SMOKER, SOME DAY
 ;;CURRENT SMOKER
 ;;CURRENT SMOKELESS
 ;;CESSATION-SMOKER
 ;;CESSATION-SMOKELESS
 ;;PREVIOUS (FORMER) SMOKELESS
 ;;PREVIOUS (FORMER) SMOKER
 ;;EXPOSURE TO ENVIRONMENTAL TOBACCO SMOKE
 ;;SMOKER IN HOME
 ;;CURRENT SMOKER & SMOKELESS
 ;;ASTHMA TRIGGERS
 ;;TOBACCO
 ;
TOBN ;;
 ;;NEVER USED TOBACCO
 ;;NEVER USED SMOKELESS TOBACCO
 ;;NEVER SMOKED
 ;;SMOKING STATUS UNKNOWN
 ;;SMOKELESS TOBACCO, STATUS UNKNOWN
 ;;NON-TOBACCO USER
 ;;CEREMONIAL USE ONLY
 ;;SMOKE FREE HOME
 ;
 ;
CPT1 ;;
 ;;BGPMU ENC PREV MED SVC 18 UP
 ;;BGPMU ENC PREV MED IND COUNSEL
 ;;BGPMU ENC PREV MED GRP COUNSEL
 ;;BGPMU ENC PREV MED OTHER SVC
 ;
CPT2 ;;
 ;;BGPMU ENC OFFICE VISIT
 ;;BGPMU ENC HEALTH AND BEHAVIOR
 ;;BGPMU ENC OCCUPATIONAL THERAPY
 ;;BGPMU ENC PSYCH AND PSYCH
 ;
HFA(BGPTOBU,BGPTOBN) ;build arrays of health factor pointers
 ; BGPTOBU(<health factor pointer>) array of health factors indicating tobacco user
 ; BGPTOBN(<health factor pointer>) array of health factors indicating non-tobacco user
 N BGPI,BGPIND,BGPTMP
 I $G(BGPTOBU)=1 D
 .S BGPTMP=0
 .F BGPI=1:1 D  Q:BGPTMP=""
 ..S BGPTMP=$P($T(TOBU+BGPI),";;",2)
 ..Q:BGPTMP=""
 ..S BGPIND=$O(^AUTTHF("B",BGPTMP,""))
 ..S:BGPIND'="" BGPTOBU(BGPIND)=BGPTMP
 ;
 I $G(BGPTOBN)=1 D
 .S BGPTMP=0
 .F BGPI=1:1 D  Q:BGPTMP=""
 ..S BGPTMP=$P($T(TOBN+BGPI),";;",2)
 ..Q:BGPTMP=""
 ..S BGPIND=$O(^AUTTHF("B",BGPTMP,""))
 ..S:BGPIND'="" BGPTOBN(BGPIND)=BGPTMP
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
