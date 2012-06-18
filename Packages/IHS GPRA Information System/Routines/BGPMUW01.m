BGPMUW01 ; IHS/MSC/AJF -Meaningful Use NQF Measure ID:0024 ;22-Mar-2011 10:08;DU
 ;;11.1;IHS CLINICAL REPORTING SYSTEM;**1**;JUN 27, 2011;Build 106
 ;;This program will collect information for Weight Assessment and Counseling
 ;; for Children and Adolescents
 ;;
ENTRY ;Get Measurement Summary for a patient given a date range and a Provider
 ;Input:
 ;BEGDT: Date to begin query for Outpatient Encounters
 ;ENDDT: Date to end query for Outpatient Encounters
 ;BGPMUTF:Time frame for this report("C"-current,"B"-baseline,"P"-previous)
 ;Output:Temp globaal of results
 ;
 N NOWDT,NOWYR,%
 D NOW^%DTC
 S NOWDT=$P(%,"."),NOWYR=$E(NOWDT,1,3),U="^"
 ;
 N VSTSDT,VSTEDT,FIRST,AGE,AGE2,AGE10,AGE16,VIEN,NOA,NOB,NOC,PCA,PCB,PCC,FINALD1,FINALD2,FINALD3,VNODE,PCPIEN,AUPNVIEN
 N DATA,VDATE,VIEN,IEN,RETVAL,CNT,PT1,PT2,AENC,BENC
 ;Counters for Numerators that DID NOT meet numerator criteria
 N NOTCA1,NOTCA2,NOTCA3,NOTCB1,NOTCB2,NOTCB3,NOTCC1,NOTCC2,NOTCC3
 N FINA,FINB,FINC,ENDDT,BEGDT
 S (NOTCA1,NOTCA2,NOTCA3,NOTCB1,NOTCB2,NOTCB3,NOTCC1,NOTCC2,NOTCC3)=0
 ;Counters for Denominators and Numerators that MEET criteria
 N POPCA,POPCB,POPCC,NUMCA1,NUMCA2,DEN,NUMCA3,NUMCB1,NUMCB2,NUMCB3,NUMCC1,NUMCC2,NUMCC3,DNOMA,DNOMB,DNOMC
 S (POPCA,POPCB,POPCC,NUMCA1,NUMCA2,NUMCA3,NUMCB1,NUMCB2,NUMCB3,NUMCC1,NUMCC2,NUMCC3,DNOMA,DNOMB,DNOMC)=0
 S AGE2=2,AGE10=10,AGE16=16,CNT=0
 S RETVAL="",VIEN=0
 S BEGDT=9999999-BGPBDATE,ENDDT=9999999-BGPEDATE
 ;
 Q:BGPAGEB<2!(BGPAGEB>16)
 S FIRST=ENDDT-0.1 F  S FIRST=$O(^AUPNVSIT("AA",DFN,FIRST)) Q:FIRST=""!($P(FIRST,".",1)>BEGDT)!(+VIEN)  D
 .S IEN=0 F  S IEN=$O(^AUPNVSIT("AA",DFN,FIRST,IEN)) Q:'+IEN!(+VIEN)  D
 ..;Check provider, Only visits for chosen provider
 ..Q:'$$PRV^BGPMUUT1(IEN,BGPPROV)
 ..;Quit if the patient has a pregnancy diagnosis
 ..I ($P(^DPT(DFN,0),U,2)="F")&($$LASTDX^BGPMUUT2(DFN,BGPBDATE,BGPEDATE,"BGPMU PREGNANCY ALL ICD")) Q
 ..I ($P(^DPT(DFN,0),U,2)="F")&($$LASTDX^BGPMUUT2(DFN,BGPBDATE,BGPEDATE,"BGPMU BMI PREG ENC DX")) Q
 ..;Quit if the visit does not have a valid E&M code
 ..S AENC=$$VSTCPT^BGPMUUT1(DFN,IEN,"BGPMU BMI ENC PEDS EM")
 ..S BENC=$$VSTPOV^BGPMUUT3(DFN,IEN,"BGPMU BMI ENC PEDS DX")
 ..Q:(AENC=0)&(BENC=0)
 ..S DATA=$G(^AUPNVSIT(IEN,0))
 ..S VSTSDT=$P($G(^AUPNVSIT(IEN,0)),U,1),VIEN=IEN
 ..S DEN="EN:"_$$DATE^BGPMUUTL(VSTSDT)
 I +VIEN D
 .;Counter for the Initial Population Criteria 1
 .S VSTSDT=$P(BGPBDATE,".",1),VSTEDT=BGPEDATE
 .S POPCA=POPCA+1
 .;
 .;Range A (Ages 2-16 inclusive)
 .D NUMATOR(DFN,"BGPMU 2-16",.NUMCA1,.NUMCA2,.NUMCA3,.DNOMA,.NOTCA1,VSTSDT,VSTEDT,DEN)
 .;Range B (Ages 2-10 inclusive)
 .I BGPAGEB<11 D NUMATOR(DFN,"BGPMU 2-10",.NUMCB1,.NUMCB2,.NUMCB3,.DNOMB,.NOTCB1,VSTSDT,VSTEDT,DEN)
 .;Range C (Ages 11-16 inclusive)
 .I BGPAGEB>10 D NUMATOR(DFN,"BGPMU 11-16",.NUMCC1,.NUMCC2,.NUMCC3,.DNOMC,.NOTCC1,VSTSDT,VSTEDT,DEN)
 .;
 .;Summary calculations
 .S FINA=$G(^TMP("BGPMU 2-16",$J,BGPMUTF,"POPULATION"))
 .S FINB=$G(^TMP("BGPMU 2-10",$J,BGPMUTF,"POPULATION"))
 .S FINC=$G(^TMP("BGPMU 11-16",$J,BGPMUTF,"POPULATION"))
 .;Final Denominator for all
 .S FINALD1=$P(FINA,U,4)
 .S $P(FINA,U,4)=$P(FINA,U,4)+DNOMA
 .S $P(FINA,U,1)=$P(FINA,U,1)+NUMCA1
 .S $P(FINA,U,2)=$P(FINA,U,2)+NUMCA2
 .S $P(FINA,U,3)=$P(FINA,U,3)+NUMCA3
 .S $P(FINA,U,5)=$P(FINA,U,5)+NOTCA1
 .S FINALD2=$P(FINB,U,4)
 .I BGPAGEE>1&(BGPAGEE<11) D
 ..S $P(FINB,U,4)=$P(FINB,U,4)+DNOMB
 ..S $P(FINB,U,1)=$P(FINB,U,1)+NUMCB1
 ..S $P(FINB,U,2)=$P(FINB,U,2)+NUMCB2
 ..S $P(FINB,U,3)=$P(FINB,U,3)+NUMCB3
 ..S $P(FINB,U,5)=$P(FINB,U,5)+NOTCB1
 .S FINALD3=$P(FINC,U,4)
 .I BGPAGEE>10&(BGPAGEE<17) D
 ..S $P(FINC,U,4)=$P(FINC,U,4)+DNOMC
 ..S $P(FINC,U,1)=$P(FINC,U,1)+NUMCC1
 ..S $P(FINC,U,2)=$P(FINC,U,2)+NUMCC2
 ..S $P(FINC,U,3)=$P(FINC,U,3)+NUMCC3
 ..S $P(FINC,U,5)=$P(FINC,U,5)+NOTCC1
 .;Store Final Date into work global for printing reports
 .S ^TMP("BGPMU 2-16",$J,BGPMUTF,"POPULATION")=FINA
 .S ^TMP("BGPMU 2-10",$J,BGPMUTF,"POPULATION")=FINB
 .S ^TMP("BGPMU 11-16",$J,BGPMUTF,"POPULATION")=FINC
 Q
 ;
NUMATOR(DFN,PATPOP,NUM1,NUM2,NUM3,DENOM,NONUM,VSTSDT,VSTEDT,DEN) ;Calculate Numerators
 ;Input:
 ;  DFN   : Patient Internal Entry Number
 ;  PATPOP : Patient Population Group ("BGPMU 2-16" or "BGPMU 2-10" or "BGPMU 11-16")
 ;  NUM1   : Numerator Counter - (Add 1 if patient is 2-16 and had BMI)
 ;  NUM2   : Numerator Counter - (Add 1 if patient is 2-10 and had Counseling on Nutrition)
 ;  NUM3   : Numerator Counter - (Add 1 if patient is 11-16 and had Counseling on Physical Activity)
 ;  DENOM  : Denominator Counter - Total Patients between 2-17
 ;  NONUM  : Numerator Counter - (Total number of patients that did not receive (NUM1 or NUM2 or NUM3 above)
 ;  VSDSDT : Visit Start Date
 ;  VSTEDT : Visit End Date
 ;Output
 ;  Temporary work global to contain calculations:  ^TMP($J,PATPOP,BGPMUTF)=NUM1_U_NUM2_U_NUM3_U_DENOM_U_NONUM
 ;
 N I,J,K,L,M,STR1,STR2,STR3,NUM
 ;
 S DENOM=1 ;Denominator for Population Criteria
 S I=$$LASTDX^BGPMUUT2(DFN,VSTSDT,VSTEDT,"BGPMU BMI PERCENTILE ICD")
 S J=$$LASTDX^BGPMUUT2(DFN,VSTSDT,VSTEDT,"BGPMU COUNSELING NUTRITION ICD")
 S K=$$LASTDX^BGPMUUT2(DFN,VSTSDT,VSTEDT,"BGPMU COUNSELING PHYSICAL ACT")
 S L=$$VSTCPT^BGPMUUT1(DFN,VIEN,"BGPMU COUNSELING NUTRITION CPT")
 S M=$$VSTCPT^BGPMUUT1(DFN,VIEN,"BGPMU COUNSELING PHYS ACT CPT")
 I +I S NUM1=1 ;BMI PERCENTILE COUNTER
 I +J!(+L) S NUM2=1 ;COUNSELING ON NUTRITION COUNTER
 I +K!(+M) S NUM3=1 ;COUNSELING ON PHYSICAL ACTIVITY COUNTER
 ;Set counter if patient DID NOT receive one of the criteria above
 I 'I&('J)&('K) S NONUM=1
 ;Set up work global to store data for final calculations
 S ^TMP(PATPOP,$J,BGPMUTF)=NUM1_U_NUM2_U_NUM3_U_DENOM_U_NONUM
 ;Set up temp globals for patient lists (per numerator)
 I PATPOP="BGPMU 2-16"&(BGPMUTF="C") D
 .S (STR1,STR2,STR3)="",NUM=""
 .I +I S STR1=$P(I,U,2)_" "_$$DATE^BGPMUUTL($P(I,U,3))
 .I +J D
 ..I STR2'="" S STR2=STR2_";"_$P(J,U,2)_" "_$$DATE^BGPMUUTL($P(J,U,3))
 ..I STR2="" S STR2=$P(J,U,2)_" "_$$DATE^BGPMUUTL($P(J,U,3))
 .I +K D
 ..I STR3'="" S STR3=STR3_";"_$P(K,U,2)_" "_$$DATE^BGPMUUTL($P(K,U,3))
 ..I STR3="" S STR3=$P(K,U,2)_" "_$$DATE^BGPMUUTL($P(K,U,3))
 .I (+NUM1) D
 ..S PT2=$G(^TMP("BGPMU0024",$J,"PAT",BGPMUTF,"NUM",1))
 ..S PT2=PT2+1
 ..S NUM="M:"_STR1
 ..S ^TMP("BGPMU0024",$J,"PAT",BGPMUTF,"NUM",1,PT2)=DFN_U_DEN_U_NUM
 ..S ^TMP("BGPMU0024",$J,"PAT",BGPMUTF,"NUM",1)=PT2
 ..;Setup iCare array for patient
 ..S BGPICARE("MU.EP.0024.1",BGPMUTF)=1_U_+NUM1_U_""_U_DEN_";"_NUM
 .E  D
 ..S PT1=$G(^TMP("BGPMU0024",$J,"PAT",BGPMUTF,"NOT",1))
 ..S PT1=PT1+1
 ..S NUM="NM:"_STR1
 ..S ^TMP("BGPMU0024",$J,"PAT",BGPMUTF,"NOT",1,PT1)=DFN_U_DEN_U_NUM
 ..S ^TMP("BGPMU0024",$J,"PAT",BGPMUTF,"NOT",1)=PT1
 ..;Setup iCare array for patient
 ..S BGPICARE("MU.EP.0024.1",BGPMUTF)=1_U_0_U_""_U_DEN_";"_NUM
 .I (+NUM2) D
 ..S PT2=$G(^TMP("BGPMU0024",$J,"PAT",BGPMUTF,"NUM",2))
 ..S PT2=PT2+1
 ..S NUM="M:"_STR2
 ..S ^TMP("BGPMU0024",$J,"PAT",BGPMUTF,"NUM",2,PT2)=DFN_U_DEN_U_NUM
 ..S ^TMP("BGPMU0024",$J,"PAT",BGPMUTF,"NUM",2)=PT2
 ..;Setup iCare array for patient
 ..S BGPICARE("MU.EP.0024.3",BGPMUTF)=1_U_+NUM2_U_""_U_DEN_";"_NUM
 .E  D
 ..S PT1=$G(^TMP("BGPMU0024",$J,"PAT",BGPMUTF,"NOT",2))
 ..S PT1=PT1+1
 ..S NUM="NM:"_STR2
 ..S ^TMP("BGPMU0024",$J,"PAT",BGPMUTF,"NOT",2,PT1)=DFN_U_DEN_U_NUM
 ..S ^TMP("BGPMU0024",$J,"PAT",BGPMUTF,"NOT",2)=PT1
 ..;Setup iCare array for patient
 ..S BGPICARE("MU.EP.0024.3",BGPMUTF)=1_U_0_U_""_U_DEN_";"_NUM
 .I (+NUM3) D
 ..S PT2=$G(^TMP("BGPMU0024",$J,"PAT",BGPMUTF,"NUM",3))
 ..S PT2=PT2+1
 ..S NUM="M:"_STR3
 ..S ^TMP("BGPMU0024",$J,"PAT",BGPMUTF,"NUM",3,PT2)=DFN_U_DEN_U_NUM
 ..S ^TMP("BGPMU0024",$J,"PAT",BGPMUTF,"NUM",3)=PT2
 ..;Setup iCare array for patient
 ..S BGPICARE("MU.EP.0024.5",BGPMUTF)=1_U_+NUM3_U_""_U_DEN_";"_NUM
 .E  D
 ..S PT1=$G(^TMP("BGPMU0024",$J,"PAT",BGPMUTF,"NOT",3))
 ..S PT1=PT1+1
 ..S NUM="NM:"_STR3
 ..S ^TMP("BGPMU0024",$J,"PAT",BGPMUTF,"NOT",3,PT1)=DFN_U_DEN_U_NUM
 ..S ^TMP("BGPMU0024",$J,"PAT",BGPMUTF,"NOT",3)=PT1
 ..;Setup iCare array for patient
 ..S BGPICARE("MU.EP.0024.5",BGPMUTF)=1_U_+NUM3_U_""_U_DEN_";"_NUM
 Q
