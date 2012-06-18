APCM11E5 ;IHS/CMI/LAB - IHS MU;  ; 11 Feb 2011  11:13 PM
 ;;2.0;IHS PCC SUITE;**6**;MAY 14, 2009;Build 11
 ;;;;;;Build 3
PATEDUC ;EP - CALCULATE PAT ED
 ;for each provider or for the facility find out if this
 ;patient had a visit of A, O, R, S to this provider or facility
 ;if so, then check to see if they have PAT ED LITERATURE documented anytime before end of report period
 NEW APCMP
 S (APCMD1,APCMN1)=0
 I APCMRPTT=1 D  Q
 .S APCMP=0 F  S APCMP=$O(APCMPRV(APCMP)) Q:APCMP'=+APCMP  D
 ..Q:'$D(APCMHVTP(APCMP))  ;no visits to this provider for this patient so don't bother, the patient is not in the denominator
 ..D PATEDUC1
 ..Q
 I APCMRPTT=2 D
 .S APCMP=APCMFAC
 .Q:'$D(APCMHVTP(APCMP))
 .D PATEDUC1
 .Q
 Q
PATEDUC1 ;
 ;set denominator value into field
 S F=$P(^APCMMUM(APCMIC,0),U,8)  ;denom field for this measure
 D S^APCM11E1(APCMRPT,APCMIC,1,APCMP,APCMRPTT,APCMTIME,F)
 ;numerator?
 S APCMVALU="VISIT: "_$$DATE^APCM1UTL(APCMHVTP(APCMP)) S APCMEP=$$HASED(DFN,APCMBDAT,APCMEDAT)
 ;I APCMRPTT=2 S APCMEP=$$HASEDH(DFN,APCMBDAT,APCMEDAT,APCMFAC,.APCMVSTS)
 S APCMVALU=APCMVALU_"|||"_$P(APCMEP,U,2)_"|||"_$P(APCMEP,U,1)
 S F=$P(^APCMMUM(APCMIC,0),U,9)
 D S^APCM11E1(APCMRPT,APCMIC,$P(APCMEP,U,1),APCMP,APCMRPTT,APCMTIME,F)
 ;S APCMVALU=APCMVALU_"|||"_$P(APCMEP,U,2)_"|||"_$P(APCMEP,U,1)
 D SETLIST^APCM11E1
 Q
HASEDH(P,BD,ED,R,VSTS) ;does patient have a visit/patient ed
 ;
 NEW A,B,C,D,E,X,Y,V,PED,T,W,Z,Q,EDUC
 ;LOOP THROUGH ALL VISITS AND COUNT VISIT AND educ
 S PED=""
 S X=0 F  S X=$O(VSTS(X)) Q:X'=+X  D
 .S G=0
 .S V=$P(VSTS(X),U,5)
 .I '$D(^AUPNVSIT(V,0)) Q
 .I $P(^AUPNVSIT(V,0),U,11) Q
 .I '$$HOSER^APCM11E6(V,R) Q  ;not correct service category, clinic, facility
 .;was there a PAT ED -L between admission an discharge?
 .S Y="EDUC("
 .S Z=P_"^ALL EDUC;DURING "_$$FMTE^XLFDT($$VD^APCLV(V))_"-"_$$FMTE^XLFDT($$DSCHDATE^APCM11E6(V)) S E=$$START1^APCLDF(Z,Y)
 .I '$D(EDUC(1)) Q
 .S (Z,B,D)=0,%="",T="" F  S Z=$O(EDUC(Z)) Q:Z'=+Z!(B)  D
 ..S A=$P(^AUPNVPED(+$P(EDUC(Z),U,4),0),U)
 ..Q:'A
 ..Q:'$D(^AUTTEDT(A,0))
 ..S T=$P(^AUTTEDT(A,0),U,2)
 ..I $P(T,"-",2)'="L" Q
 ..S PED=1_U_"Visit/Adm: "_$$DATE^APCM1UTL($$VD^APCLV(V))_";"_T_" on "_$$DATE^APCM1UTL($P(EDUC(X),U)) Q
 Q PED
HASED(P,BD,ED) ;does patient have Patient Ed -L
 ;
 NEW A,B,C,D,E,PED,Y,EDUC,X,T
 S C=0
 S PED=""
 S Y="EDUC("
 S X=P_"^ALL EDUC;DURING "_$$FMTE^XLFDT(BD)_"-"_$$FMTE^XLFDT(ED) S E=$$START1^APCLDF(X,Y)
 I '$D(EDUC(1)) Q ""
 S (X,D)=0,%="",T="" F  S X=$O(EDUC(X)) Q:X'=+X!(PED]"")  D
 .S T=$P(^AUPNVPED(+$P(EDUC(X),U,4),0),U)
 .Q:'T
 .Q:'$D(^AUTTEDT(T,0))
 .S T=$P(^AUTTEDT(T,0),U,2)
 .I $P(T,"-",2)="L" S PED=1_U_T_" on "_$$DATE^APCM1UTL($P(EDUC(X),U)) Q
 Q PED
TIMELY ;EP - TIMELY - THIS IS THE PHR MEASURE
 NEW APCMP
 S (APCMD1,APCMN1)=0
 I APCMRPTT=1 S APCMP=0 F  S APCMP=$O(APCMPRV(APCMP)) Q:APCMP'=+APCMP  D
 .Q:'$D(APCMHVTP(APCMP))  ;no visits to this provider for this patient so don't bother, the patient is not in the denominator
 .;set denominator value into field
 .S F=$P(^APCMMUM(APCMIC,0),U,8)  ;denom field for this measure
 .D S^APCM11E1(APCMRPT,APCMIC,1,APCMP,APCMRPTT,APCMTIME,F)
 .S APCMVALU="VISIT: "_$$DATE^APCM1UTL(APCMHVTP(APCMP))
 .;numerator?
 .S APCMEP=$S(APCMATTE("S1.020.EP",APCMP)="Yes":1,1:0)
 .S F=$P(^APCMMUM(APCMIC,0),U,9)
 .D S^APCM11E1(APCMRPT,APCMIC,$P(APCMEP,U,1),APCMP,APCMRPTT,APCMTIME,F)
 .S APCMVALU=APCMVALU_"|||"_APCMATTE("S1.020.EP",APCMP)
 .D SETLIST^APCM11E1
 Q
 ;
MR ;EP - med reconciliation
 ;;then check to see if they have m-mr on the day of the visit
 NEW APCMP
 S (APCMD1,APCMN1)=0
 I APCMRPTT=1 S APCMP=0 F  S APCMP=$O(APCMPRV(APCMP)) Q:APCMP'=+APCMP  D
 .I $D(APCMTRAE(APCMP,APCMTIME)) S F=$P(^APCMMUM(APCMIC,0),U,11) D  Q
 ..D S^APCM11E1(APCMRPT,APCMIC,"Provider is excluded from this measure as he/she did not have any transitions of care clinic visits.",APCMP,APCMRPTT,APCMTIME,F,1) Q
 .Q:'$D(APCMHVTP(APCMP))  ;no visits to this provider for this patient so don't bother, the patient is not in the denominator
 .;numerator?
 .S APCMEP=$$HASMMR(DFN,APCMBDAT,APCMEDAT,APCMP,.APCMVSTS)  ;return # of visits^# w/M-MR
 .;set denominator value into field
 .S F=$P(^APCMMUM(APCMIC,0),U,8)  ;denom field for this measure
 .D S^APCM11E1(APCMRPT,APCMIC,$P(APCMEP,U,1),APCMP,APCMRPTT,APCMTIME,F)
 .;numerator?
 .S APCMVALU="# of visits: "_$P(APCMEP,U,1)_" - # w/ M-MR: "_+$P(APCMEP,U,2)_"|||"_$P(APCMEP,U,3)_"|||"_$S($P(APCMEP,U,1)=$P(APCMEP,U,2):1,1:0)
 .S F=$P(^APCMMUM(APCMIC,0),U,9)
 .D S^APCM11E1(APCMRPT,APCMIC,$P(APCMEP,U,2),APCMP,APCMRPTT,APCMTIME,F)
 .Q:$P(APCMEP,U,1)=0
 .D SETLIST^APCM11E1
 Q
HASMMR(P,BD,ED,R,VSTS) ;does patient have a m-mr on visits
 ;
 NEW A,B,C,D,E,X,Y,V,PWH,T,W,Z,Q,PED,EDUC
 S T=$O(^APCMMUCN("B","INTERIM STAGE 1 2011",0))
 ;LOOP THROUGH ALL VISITS AND COUNT VISIT AND PWH'S
 S PWH="0^0"
 S X=0 F  S X=$O(VSTS(X)) Q:X'=+X  D
 .S G=0
 .S V=$P(VSTS(X),U,5)
 .I '$D(^AUPNVSIT(V,0)) Q
 .I $P(^AUPNVSIT(V,0),U,11) Q  ;deleted
 .I "AOSM"'[$P(^AUPNVSIT(V,0),U,7) Q  ;not correct service category/OFFICE VISIT
 .S Y=0 F  S Y=$O(^AUPNVPRV("AD",V,Y)) Q:Y'=+Y!(G)  D
 ..I $P($G(^AUPNVPRV(Y,0)),U)'=R Q
 ..S G=1
 .Q:'G  ;not a visit to this provider
 .S C=$$CLINIC^APCLV(V,"C")
 .I C]"",T,$D(^APCMMUCN(T,14,"B",C)) Q  ;don't count these clinics
 .S $P(PWH,U,1)=$P(PWH,U,1)+1
 .;was there a PAT ED M-MR on the date of the visit
 .S B=""
 .K EDUC
 .S Y="EDUC("
 .S Z=P_"^ALL EDUC;DURING "_$$FMTE^XLFDT($$VD^APCLV(V))_"-"_$$FMTE^XLFDT($$VD^APCLV(V)) S E=$$START1^APCLDF(Z,Y)
 .;I '$D(EDUC(1)) Q
 .S (Z,D)=0,%="",T="" F  S Z=$O(EDUC(Z)) Q:Z'=+Z!(B)  D
 ..S T=$P(^AUPNVPED(+$P(EDUC(Z),U,4),0),U)
 ..Q:'T
 ..Q:'$D(^AUTTEDT(T,0))
 ..S Y=$P(^AUTTEDT(T,0),U,2)
 ..Q:Y'="M-MR"
 ..S B=1 S $P(PWH,U,2)=$P(PWH,U,2)+1
 .S $P(PWH,U,3)=$P(PWH,U,3)_$$DATE^APCM1UTL($$VD^APCLV(V))_":"_$S(B:"M-MR",1:"NO M-MR")_";"
 .Q
 Q PWH
HASPWH(P,BD,ED,R,VSTS) ;
 ;
 NEW A,B,C,D,E,X,Y,V,PWH,T,W,Z,Q
 S T=$O(^APCMMUCN("B","INTERIM STAGE 1 2011",0))
 ;LOOP THROUGH ALL VISITS AND COUNT VISIT AND PWH'S
 S PWH="0^0"
 S X=0 F  S X=$O(VSTS(X)) Q:X'=+X  D
 .S G=0
 .S V=$P(VSTS(X),U,5)
 .I '$D(^AUPNVSIT(V,0)) Q
 .I $P(^AUPNVSIT(V,0),U,11) Q
 .I "AOSM"'[$P(^AUPNVSIT(V,0),U,7) Q  ;not correct service category/OFFICE VISIT
 .S Y=0 F  S Y=$O(^AUPNVPRV("AD",V,Y)) Q:Y'=+Y!(G)  D
 ..I $P($G(^AUPNVPRV(Y,0)),U)'=R Q
 ..S G=1
 .Q:'G  ;not a visit to this provider
 .S C=$$CLINIC^APCLV(V,"C")
 .I C]"",T,$D(^APCMMUCN(T,14,"B",C)) Q  ;don't count these clinics
 .S $P(PWH,U,1)=$P(PWH,U,1)+1
 .;was there a pwh on the date of the visit
 .S D=$P(^AUPNVSIT(V,0),U),D=D-.000001  ;date of visit
 .S E=$P(D,".")
 .S A=D,B=0 F  S A=$O(^APCHPWHL("AA",P,A)) Q:A'=+A!($P(A,".")>E)  D
 ..;MUST HAVE MEDICATONS AS A COMPONENT
 ..S Z=0 F  S Z=$O(^APCHPWHL("AA",P,A,Z)) Q:Z'=+Z  D
 ...S W=$P(^APCHPWHL(Z,0),U,2)
 ...Q:'W
 ...S Q=0 F  S Q=$O(^APCHPWHT(Z,1,Q)) Q:Q'=+Q!(B)  D
 ....S R=$P($G(^APCHPWHT(Z,1,Q,0)),U,2)
 ....Q:'R
 ....S R=$P($G(^APCHPWHC(R,0)),U,1)
 ....Q:R'["MEDICATIONS"
 ....S B=1
 .I B S $P(PWH,U,2)=$P(PWH,U,2)+1
 .Q
 Q PWH
PR ;EP - patient reminders
 ;for each provider or for the facility find out if this
 ;if patient is <=5 or >=65 count them
 ;exclude deceased, and inactive charts
 ;if so, then check to see if they have PWH WITH 4 COMPONENTs documented any time before end of report period
 NEW APCMP
 S (APCMD1,APCMN1)=0
 I APCMRPTT=1 S APCMP=0 F  S APCMP=$O(APCMPRV(APCMP)) Q:APCMP'=+APCMP  D
 .I APCMN565(APCMTIME) S F=$P(^APCMMUM(APCMIC,0),U,11) D  Q
 ..D S^APCM11E1(APCMRPT,APCMIC,"Facility is excluded from this measure as they did not see any patients <=5 or >=65 years old.",APCMP,APCMRPTT,APCMTIME,F,1) Q
 .;set denominator value into field
 .S G=0
 .Q:$$DOB^AUPNPAT(DFN)>APCMBDAT  ;born after time period begin date
 .I APCMAGEB<5 G PR1
 .I APCMAGEB<65 Q
PR1 .;IS CHART ACTIVE OR DECEASED
 .S X=$$DOD^AUPNPAT(DFN)
 .I X,X'>APCMEDAT Q
 .S X=$P($G(^AUPNPAT(DFN,41,DUZ(2),0)),U,3)
 .I X,X'>APCMEDAT Q
 .S F=$P(^APCMMUM(APCMIC,0),U,8)  ;denom field for this measure
 .D S^APCM11E1(APCMRPT,APCMIC,1,APCMP,APCMRPTT,APCMTIME,F)
 .S APCMVALU=""
 .;numerator?
 .S APCMEP=$$HASPWHR(DFN,APCMBDAT,APCMEDAT,APCMP,.APCMVSTS)  ;return # of visits^# w/pwh
 .S APCMVALU="Patient age: "_$$AGE^AUPNPAT(DFN,APCMBDAT)_"|||"_"PWH: "_$P(APCMEP,U,2)_"|||"_$P(APCMEP,U,1)
 .S F=$P(^APCMMUM(APCMIC,0),U,9)
 .D S^APCM11E1(APCMRPT,APCMIC,$P(APCMEP,U,1),APCMP,APCMRPTT,APCMTIME,F)
 .D SETLIST^APCM11E1
 Q
HASPWHR(P,BD,ED,R,VSTS) ;
 ;
 NEW A,B,C,D,E,X,Y,V,PWH,T,W,Z,Q
 S PWH=""
 S D=$$FMADD^XLFDT(BD,-1)
 S A=D,B=0 F  S A=$O(^APCHPWHL("AA",P,A)) Q:A'=+A!($P(A,".")>ED)!(PWH)  D
 .;MUST HAVE PL, MEDS, ALLERGIES AND LABS AS A COMPONENT
 .S Z=0,C=0 F  S Z=$O(^APCHPWHL("AA",P,A,Z)) Q:Z'=+Z!(PWH)  D
 ..S W=$P(^APCHPWHL(Z,0),U,2)
 ..Q:'W
 ..S Q=0 F  S Q=$O(^APCHPWHT(W,1,Q)) Q:Q'=+Q  D
 ...S R=$P($G(^APCHPWHT(W,1,Q,0)),U,2)
 ...Q:'R
 ...S R=$P($G(^APCHPWHC(R,0)),U,1)
 ...I R["MEDICATIONS" S C=C+1
 ...I R["PROBLEM LIST" S C=C+1
 ...I R["RECENT LAB" S C=C+1
 ...I R["ALLERGIES" S C=C+1
 ...Q:C'=4
 ...S PWH=1_U_$$DATE^APCM1UTL(A)_" "_$P(^APCHPWHT(W,0),U)
 Q PWH
SC ;EP - REFERRAL, SUMMARY OF CARE
 NEW APCMP
 S (APCMD1,APCMN1)=0
 I APCMRPTT=1 S APCMP=0 F  S APCMP=$O(APCMPRV(APCMP)) Q:APCMP'=+APCMP  D
 .I $D(APCMRCIS(APCMP,APCMTIME)) S F=$P(^APCMMUM(APCMIC,0),U,11) D  Q
 ..D S^APCM11E1(APCMRPT,APCMIC,"Provider is excluded from this measure as he/she did not make any referrals for patients they saw during the report period.",APCMP,APCMRPTT,APCMTIME,F,1) Q
 .;Q:'$D(APCMHVTP(APCMP))  ;no visits to this provider for this patient so don't bother, the patient is not in the denominator
 .;set denominator value into field
 .S APCMEP=$$HASC32(DFN,APCMBDAT,$$FMADD^XLFDT(APCMEDAT,-14),APCMP)  ;# referrals^# w/c32 documentation
 .Q:$P(APCMEP,U,1)=""
 .S F=$P(^APCMMUM(APCMIC,0),U,8)  ;denom field for this measure
 .D S^APCM11E1(APCMRPT,APCMIC,$P(APCMEP,U,1),APCMP,APCMRPTT,APCMTIME,F)
 .;S APCMVALU="VISIT: "_$$DATE^APCM1UTL(APCMHVTP(APCMP))
 .;numerator?
 .S APCMVALU="# of referrals: "_$P(APCMEP,U,1)_" # w/C32 w/in 14 days: "_+$P(APCMEP,U,2)_"|||"_$P(APCMEP,U,3)_"|||"_$S('+$P(APCMEP,U,1):0,+$P(APCMEP,U,1)=+$P(APCMEP,U,2):1,1:0)
 .S F=$P(^APCMMUM(APCMIC,0),U,9)
 .D S^APCM11E1(APCMRPT,APCMIC,$P(APCMEP,U,2),APCMP,APCMRPTT,APCMTIME,F)
 .D SETLIST^APCM11E1
 Q
HASC32(P,BD,ED,R) ;does patient have a referral with c32
 ;
 NEW A,B,C,D,E,ROI,X,ROII,S
 S ROI=""  ;set to 1 if had a good request
 S ROII="" ;set to date of reques
 S D=$$FMADD^XLFDT(BD,-1)
 F  S D=$O(^BMCREF("AA",P,D)) Q:D'=+D!(D>ED)  D
 .S X=0 F  S X=$O(^BMCREF("AA",P,D,X)) Q:X'=+X  D
 ..;check to see if it is for this provider, is an A or CL and is not an in-house
 ..S S=$P(^BMCREF(X,0),U,6)
 ..Q:S'=R  ;not the requesting provider we want
 ..S S=$P(^BMCREF(X,0),U,15)
 ..I S'="A",S'="C1" Q  ;not a A or C1
 ..Q:$P(^BMCREF(X,0),U,4)="N"
 ..;was it 1 day before through 1 day after discharge
 ..;OR was it on the date of an 30/80 visit or the day after
 ..S $P(ROI,U,1)=$P(ROI,U,1)+1
 ..;now check to see if a c32 was printed
 ..S Y=0 F  S Y=$O(^BMCREF(X,6,"B",Y)) Q:Y'=+Y  D
 ...I $P(Y,".")'<D,$P(Y,".")'>$$FMADD^XLFDT(D,14) S $P(ROI,U,2)=$P(ROI,U,2)+1,ROII=ROII_$$DATE^APCM1UTL(D)_"/"_$$DATE^APCM1UTL(Y)_";" Q
 ...S ROII=ROII_$$DATE^APCM1UTL(D)_"/None;"
 Q ROI_U_ROII
 ;
LAB ;EP - CALCULATE LAB
 ;for each provider or for the facility count all prescriptions that meet criteria and if it is not written it meets numerator
 K ^TMP($J,"PATSRX")
 K APCMLABS
 D TOTLAB
 NEW APCMP,N,F
 S (APCMD1,APCMN1)=0
 I APCMRPTT=1 S APCMP=0 F  S APCMP=$O(APCMPRV(APCMP)) Q:APCMP'=+APCMP  D
 .I '$P($G(APCMLABS(APCMP)),U,1) S F=$P(^APCMMUM(APCMIC,0),U,11) D S^APCM11E1(APCMRPT,APCMIC,"Provider is excluded from this measure as he/she did not order any lab tests with results during the time period.",APCMP,APCMRPTT,APCMTIME,F,1) Q
 .;set denominator value into field
 .S F=$P(^APCMMUM(APCMIC,0),U,8)  ;denom field for this measure
 .S N=$P($G(APCMLABS(APCMP)),U,1)  ;returns # of LABS^# not Structured data
 .D S^APCM11E1(APCMRPT,APCMIC,N,APCMP,APCMRPTT,APCMTIME,F)
 .;now set patient list for this provider
 .S P=0 F  S P=$O(^TMP($J,"PATSRX",APCMP,P)) Q:P'=+P  D
 ..;Q:'$P(^TMP($J,"PATSRX",APCMP,P),U,1)
 ..I $P(^TMP($J,"PATSRX",APCMP,P),U,1)=$P(^TMP($J,"PATSRX",APCMP,P),U,2) S APCMVALU="# Labs: "_$P(^TMP($J,"PATSRX",APCMP,P),U,1)_"|||"_" # w/structured result: "_+$P(^TMP($J,"PATSRX",APCMP,P),U,2)_"|||1" D  Q
 ...S DFN=P D SETLIST^APCM11E1 Q
 ..S S="",APCMVALU="No Structured Result: "
 ..F  S S=$O(^TMP($J,"PATSRX",APCMP,P,"SCRIPTS",S)) Q:S=""  D
 ...I '$D(^TMP($J,"PATSRX",APCMP,P,"ELEC",S)) D
 ....S APCMVALU=APCMVALU_S_";"
 ..S DFN=P,APCMVALU="# of Labs: "_$P(^TMP($J,"PATSRX",APCMP,P),U,1)_" # w/structured results: "_+$P(^TMP($J,"PATSRX",APCMP,P),U,2)_"|||"_APCMVALU,$P(APCMVALU,"|||",3)=0 D SETLIST^APCM11E1
 .;numerator?
 .S F=$P(^APCMMUM(APCMIC,0),U,9)
 .S N=$P($G(APCMLABS(APCMP)),U,2)
 .D S^APCM11E1(APCMRPT,APCMIC,N,APCMP,APCMRPTT,APCMTIME,F)
 K ^TMP($J,"PATSRX")
 Q
TOTLAB ;EP - 
 ;SET ARRAY APCMLABS to APCMLABS(prov ien)=denom^numer
 ;IF DENOM =0 THEN PROVIDER EXCLUSION
 NEW ID,C,Y,X,D,S,N,A,B,R,PAT
 S C=0,N=0
 S LABSNO=""
 S T=$O(^ATXLAB("B","BGP PAP SMEAR TAX",0))
 S (ID,SD)=$$FMADD^XLFDT(APCMBDAT,-365),ID=ID_".99999"
 F  S ID=$O(^AUPNVSIT("B",ID)) Q:ID'=+ID  D
 .S X=0 F  S X=$O(^AUPNVSIT("B",ID,X)) Q:X'=+X  D
 ..Q:'$D(^AUPNVLAB("AD",X))  ;no labs
 ..S Y=0 F  S Y=$O(^AUPNVLAB("AD",X,Y)) Q:Y'=+Y  D
 ...S R=$P($G(^AUPNVLAB(Y,12)),U,2)
 ...Q:'R  ;no ordering provider
 ...I '$D(APCMPRV(R)) Q  ;not a provider of interest
 ...Q:$P($P($G(^AUPNVLAB(Y,12)),U,1),".")>APCMEDAT
 ...Q:$P($P($G(^AUPNVLAB(Y,12)),U,1),".")<APCMBDAT
 ...S A=$P(^AUPNVLAB(Y,0),U,1)
 ...I T,$D(^ATXLAB(T,21,"B",A)) Q   ;it's a pap smear
 ...I $P(^AUPNVLAB(Y,0),U,4)="canc" Q
 ...S PAT=$P(^AUPNVLAB(Y,0),U,2)
 ...I '$D(APCMLABS(R)) S APCMLABS(R)=""
 ...S $P(APCMLABS(R),U,1)=$P(APCMLABS(R),U,1)+1,$P(^TMP($J,"PATSRX",R,PAT),U,1)=$P($G(^TMP($J,"PATSRX",R,PAT)),U,1)+1,^TMP($J,"PATSRX",R,PAT,"SCRIPTS",$$VAL^XBDIQ1(9000010.09,Y,1201)_" "_$$VAL^XBDIQ1(9000010.09,Y,.01))=""
 ...;now check numerator
 ...Q:$P($G(^AUPNVLAB(Y,11)),U,9)'="R"  ;if status not resulted it doesn't make the numerator
 ...I $$UP^XLFSTR($P(^AUPNVLAB(Y,0),U,4))="COMMENT",'$$HASCOM(Y) Q
 ...S $P(APCMLABS(R),U,2)=$P(APCMLABS(R),U,2)+1,$P(^TMP($J,"PATSRX",R,PAT),U,2)=$P($G(^TMP($J,"PATSRX",R,PAT)),U,2)+1 S ^TMP($J,"PATSRX",R,PAT,"ELEC",$$VAL^XBDIQ1(9000010.09,Y,1201)_" "_$$VAL^XBDIQ1(9000010.09,Y,.01))=""  ;S N=N+G Q  ;S N=N+G
 ...;S $P(APCMLABS(R),U,3)=$P(APCMLABS(R),U,3)_$$VAL^XBDIQ1(9000010.09,Y,.01)_":"_$$VAL^XBDIQ1(9000010.09,Y,.04)_";"
 Q
 ;
HASCOM(L) ;ARE THERE ANY COMMENTS
 I '$D(^AUPNVLAB(L,21)) Q 0
 NEW B,G
 S G=0
 S B=0 F  S B=$O(^AUPNVLAB(L,21,B)) Q:B'=+B  I ^AUPNVLAB(L,21,B,0)]"" S G=1  ;has comment
 Q G
