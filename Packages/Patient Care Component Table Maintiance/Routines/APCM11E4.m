APCM11E4 ;IHS/CMI/LAB - IHS MU; 
 ;;1.0;IHS MU PERFORMANCE REPORTS;**1,2**;MAR 26, 2012;Build 11
 ;;;;;;Build 3
AL ;EP - CALCULATE ALLERY LIST
 ;for each provider or for the facility find out if this
 ;patient had a visit of A, O, R, S to this provider or facility
 ;if so, then check to see if they any ALLERGIES OR NAA documented in report period
 NEW APCMP
 S (APCMD1,APCMN1)=0
 I APCMRPTT=1 D  Q
 .S APCMP=0 F  S APCMP=$O(APCMPRV(APCMP)) Q:APCMP'=+APCMP  D
 ..Q:'$D(APCMHVTP(APCMP))  ;no visits to this provider for this patient so don't bother, the patient is not in the denominator
 ..D AL1
 ..Q
 I APCMRPTT=2 D
 .S APCMP=APCMFAC
 .Q:'$D(APCMHVTP(APCMP))
 .D AL1
 .Q
 Q
AL1 ;
 ;set denominator value into field
 S F=$P(^APCMMUM(APCMIC,0),U,8)  ;denom field for this measure
 D S^APCM11E1(APCMRPT,APCMIC,1,APCMP,APCMRPTT,APCMTIME,F)
 S APCMVALU="VISIT: "_$$DATE^APCM1UTL(APCMHVTP(APCMP))
 ;numerator?
 S APCMEP=$$HASAL(DFN,APCMBDAT,APCMEDAT)
 S APCMVALU=APCMVALU_"|||"_$P(APCMEP,U,2)_"|||"_$P(APCMEP,U,1)
 S F=$P(^APCMMUM(APCMIC,0),U,9)
 D S^APCM11E1(APCMRPT,APCMIC,$P(APCMEP,U,1),APCMP,APCMRPTT,APCMTIME,F)
 D SETLIST^APCM11E1
 Q
HASAL(P,BD,ED) ;does patient have an allergy entered before end of report period
 ;
 NEW A,B,C,D,E,X
 ;check in allergy tracking for a "drug" allergy ever
 S E=""
 S X=0 F  S X=$O(^GMR(120.8,"B",P,X)) Q:X'=+X!(E)  D
 .S A=$$VAL^XBDIQ1(120.8,X,3.1)
 .S D=$P($P(^GMR(120.8,X,0),U,4),".")
 .I D>ED Q  ;after report period
 .I A]"",A["DRUG" S E=1_U_"Allergy: "_$$VAL^XBDIQ1(120.8,X,.02)_" entered on "_$$DATE^APCM1UTL(D) Q
 I E]"" Q E
 ;now check for no known allergies
 I $D(^GMR(120.86,P,0)),$P(^GMR(120.86,P,0),U,2)=0 D
 .S D=$P($P(^GMR(120.86,P,0),U,4),".",1)
 .Q:D>ED  ;after ed
 .S E=1_U_"NKA noted on "_$$FMTE^XLFDT($P($P(^GMR(120.86,P,0),U,4),".",1))
 I E]"" Q E
 S D=$$LASTNAA^APCLAPI6(P,,ED,"D")
 I D]"" S E="1^No Active Allergies on "_$$DATE^APCM1UTL(D)
 Q E
EPRES ;EP - CALCULATE EPRESCRIBING
 ;for each provider or for the facility count all prescriptions that meet criteria and if it is not written it meets numerator
 K ^TMP($J,"PATSRX")
 K APCMRXS
 D TOTRX
 NEW APCMP,N,F
 S (APCMD1,APCMN1)=0
 I APCMRPTT=1 S APCMP=0 F  S APCMP=$O(APCMPRV(APCMP)) Q:APCMP'=+APCMP  D
 .I $D(APCM100R(APCMP,APCMTIME)) S F=$P(^APCMMUM(APCMIC,0),U,11) D S^APCM11E1(APCMRPT,APCMIC,"Provider is excluded from this measure as he/she had < 100 prescriptions issued during the EHR reporting period.",APCMP,APCMRPTT,APCMTIME,F,1) Q
 .;set denominator value into field
 .S F=$P(^APCMMUM(APCMIC,0),U,8)  ;denom field for this measure
 .S N=$P($G(APCMRXS(APCMP)),U,1)  ;returns # of prescriptions^# not written by nature of order
 .D S^APCM11E1(APCMRPT,APCMIC,N,APCMP,APCMRPTT,APCMTIME,F)
 .;now set patient list for this provider
 .S P=0 F  S P=$O(^TMP($J,"PATSRX",APCMP,P)) Q:P'=+P  D
 ..;Q:'$P(^TMP($J,"PATSRX",APCMP,P),U,1)
 ..I $P(^TMP($J,"PATSRX",APCMP,P),U,1)=$P(^TMP($J,"PATSRX",APCMP,P),U,2) S APCMVALU="# Prescriptions: "_$P(^TMP($J,"PATSRX",APCMP,P),U,1)_"|||"_" # transmitted electronically: "_+$P(^TMP($J,"PATSRX",APCMP,P),U,2)_"|||1" D  Q
 ...S DFN=P D SETLIST^APCM11E1 Q
 ..S S="",APCMVALU="Not transmitted electronically: "
 ..F  S S=$O(^TMP($J,"PATSRX",APCMP,P,"SCRIPTS",S)) Q:S=""  D
 ...I '$D(^TMP($J,"PATSRX",APCMP,P,"ELEC",S)) D
 ....S APCMVALU=APCMVALU_S_";"
 ..S DFN=P,APCMVALU="# of Prescriptions: "_$P(^TMP($J,"PATSRX",APCMP,P),U,1)_" # transmitted electronically: "_+$P(^TMP($J,"PATSRX",APCMP,P),U,2)_"|||"_APCMVALU,$P(APCMVALU,"|||",3)=0 D SETLIST^APCM11E1
 .;numerator?
 .S F=$P(^APCMMUM(APCMIC,0),U,9)
 .S N=$P($G(APCMRXS(APCMP)),U,2)
 .D S^APCM11E1(APCMRPT,APCMIC,N,APCMP,APCMRPTT,APCMTIME,F)
 K ^TMP($J,"PATSRX")
 Q
TOTRX ;EP - did patient have a RX in file 52 with an issue date
 ;between BD and ED
 ;SET ARRAY APCMRXS to APCMRXS(prov ien)=denom^numer
 NEW ID,C,Y,X,D,S,N,A,B,R,PAT,G
 S C=0,N=0
 S ID=$$FMADD^XLFDT(APCMBDAT,-1)
 F  S ID=$O(^PSRX("AC",ID)) Q:ID'=+ID!(ID>APCMEDAT)  D
 .S X=0 F  S X=$O(^PSRX("AC",ID,X)) Q:X'=+X  D
 ..S R=$P($G(^PSRX(X,0)),U,4)
 ..Q:'R
 ..;I '$D(APCMPRV(R)) Q  ;not a provider of interest
 ..I '$D(APCMRXS(R)) S APCMRXS(R)=""
 ..Q:$P($G(^PSRX(X,"STA")),"^")=13
 ..S D=$P(^PSRX(X,0),U,6)
 ..S S=$P($G(^PSDRUG(D,0)),U,3)
 ..Q:S[5
 ..Q:S[4
 ..Q:S[3
 ..Q:S[2
 ..Q:S[1
 ..S S=$P($G(^PSRX(X,3)),U,7)
 ..Q:$$UP^XLFSTR(S)["ADMINISTERED IN CLINIC"
 ..S PAT=$P(^PSRX(X,0),U,2)
 ..;quit if demo patient
 ..Q:$$DEMO^APCLUTL(PAT,$G(APCMDEMO))
 ..S $P(APCMRXS(R),U,1)=$P(APCMRXS(R),U,1)+1,$P(^TMP($J,"PATSRX",R,PAT),U,1)=$P($G(^TMP($J,"PATSRX",R,PAT)),U,1)+1,^TMP($J,"PATSRX",R,PAT,"SCRIPTS",$P(^PSRX(X,0),U,1))=""
 ..;
 ..;now check to see if it has a nature of order not equal to 1-written
 ..S G=0
 ..I $E($P(^PSRX(X,0),U,1))?1N D
 ...S O=$P($G(^PSRX(X,"OR1")),U,2)  ;order number
 ...Q:O=""
 ...S B=$P($G(^OR(100,O,0)),U,6)
 ...Q:B=""
 ...S A=0,G=0 F  S A=$O(^OR(100,O,8,A)) Q:A'=+A!(G)  D
 ....S B=$P($G(^OR(100,O,8,A,0)),U,12)
 ....Q:B=1
 ....Q:B=""
 ....S G=1
 ...S $P(APCMRXS(R),U,2)=$P(APCMRXS(R),U,2)+G,$P(^TMP($J,"PATSRX",R,PAT),U,2)=$P($G(^TMP($J,"PATSRX",R,PAT)),U,2)+G I G S ^TMP($J,"PATSRX",R,PAT,"ELEC",$P(^PSRX(X,0),U,1))=""  ;S N=N+G
 ..S B=0 I $E($P(^PSRX(X,0),U,1))="X" D
 ...S A=0 F  S A=$O(^PSRX(X,"A",A)) Q:A'=+A!(B)  D
 ....I $P(^PSRX(X,"A",A,0),U,5)["E-Prescribe" S B=1
 ...S $P(APCMRXS(R),U,2)=$P(APCMRXS(R),U,2)+B,$P(^TMP($J,"PATSRX",R,PAT),U,2)=$P($G(^TMP($J,"PATSRX",R,PAT)),U,2)+B I B S ^TMP($J,"PATSRX",R,PAT,"ELEC",$P(^PSRX(X,0),U,1))=""
 Q
VS ;EP - CALCULATE VITAL SIGNS
 ;for each provider or for the facility find out if this
 ;patient had a visit of A, O, R, S to this provider or facility
 ;if so, then check to see if they have vital signs documented anytime before end of report period
 Q:$$AGE^AUPNPAT(DFN,APCMBDAT)<2
 NEW APCMP
 S (APCMD1,APCMN1)=0
 I APCMRPTT=1 D  Q
 .S APCMP=0 F  S APCMP=$O(APCMPRV(APCMP)) Q:APCMP'=+APCMP  D
 ..I $D(APCM2ON(APCMP,APCMTIME)) S F=$P(^APCMMUM(APCMIC,0),U,11) D S^APCM11E1(APCMRPT,APCMIC,"Provider is excluded from this measure as he/she did not see anyone over 2 during the EHR reporting period.",APCMP,APCMRPTT,APCMTIME,F,1) Q
 ..Q:'$D(APCMHVTP(APCMP))  ;no visits to this provider for this patient so don't bother, the patient is not in the denominator
 ..D VS1
 .Q
 I APCMRPTT=2 D
 .S APCMP=APCMFAC
 .Q:'$D(APCMHVTP(APCMP))
 .D VS1
 .Q
 Q
VS1 ;set denominator value into field
 S F=$P(^APCMMUM(APCMIC,0),U,8)  ;denom field for this measure
 D S^APCM11E1(APCMRPT,APCMIC,1,APCMP,APCMRPTT,APCMTIME,F)
 S APCMVALU="VISIT: "_$$DATE^APCM1UTL(APCMHVTP(APCMP))
 ;numerator?
 S APCMEP=$$HASVS(DFN,$$DOB^AUPNPAT(DFN),APCMEDAT)
 S APCMVALU=APCMVALU_"|||"_$P(APCMEP,U,2)_"|||"_$P(APCMEP,U,1)
 S F=$P(^APCMMUM(APCMIC,0),U,9)
 D S^APCM11E1(APCMRPT,APCMIC,$P(APCMEP,U,1),APCMP,APCMRPTT,APCMTIME,F)
 D SETLIST^APCM11E1
 Q
HASVS(P,BD,ED) ;does patient have a problem entered before end of report period
 ;
 NEW A,B,C,D,E,HT,WT,BP
 S C=0
 S (HT,WT,BP)=""
 S HT=$$LASTITEM^APCLAPIU(P,"HT","MEASUREMENT",BD,ED)
 S WT=$$LASTITEM^APCLAPIU(P,"WT","MEASUREMENT",BD,ED)
 S BP=$$LASTITEM^APCLAPIU(P,"BP","MEASUREMENT",BD,ED)
 I HT]"",WT]"",BP]"" Q 1_U_"Has: HT, WT, BP"
 Q 0_U_"Has: "_$S(HT]"":"HT ",1:"")_$S(WT]"":"WT ",1:"")_$S(BP]"":"BP ",1:"")
 ;
ST ;EP - CALCULATE SMOKING STATUS
 ;for each provider or for the facility find out if this
 ;patient had a visit of A, O, R, S to this provider or facility
 ;if so, then check to see if they have SMOKING STATUS documented anytime before end of report period
 Q:$$AGE^AUPNPAT(DFN,APCMBDAT)<13
 NEW APCMP
 S (APCMD1,APCMN1)=0
 I APCMRPTT=1 D  Q
 .S APCMP=0 F  S APCMP=$O(APCMPRV(APCMP)) Q:APCMP'=+APCMP  D
 ..I $D(APCM13ON(APCMP,APCMTIME)) S F=$P(^APCMMUM(APCMIC,0),U,11) D S^APCM11E1(APCMRPT,APCMIC,"Provider is excluded from this measure as he/she did not see anyone over 13 during the EHR reporting period.",APCMP,APCMRPTT,APCMTIME,F,1) Q
 ..Q:'$D(APCMHVTP(APCMP))  ;no visits to this provider for this patient so don't bother, the patient is not in the denominator
 ..D ST1
 I APCMRPTT=2 D
 .S APCMP=APCMFAC
 .I $D(APCM13ON(APCMP,APCMTIME)) S F=$P(^APCMMUM(APCMIC,0),U,11) D S^APCM11E1(APCMRPT,APCMIC,"Hospital is excluded from this measure as did not admit anyone over 13 during the EHR reporting period.",APCMP,APCMRPTT,APCMTIME,F,1) Q
 .Q:'$D(APCMHVTP(APCMP))
 .D ST1
 .Q
 Q
ST1 ;set denominator value into field
 S F=$P(^APCMMUM(APCMIC,0),U,8)  ;denom field for this measure
 D S^APCM11E1(APCMRPT,APCMIC,1,APCMP,APCMRPTT,APCMTIME,F)
 S APCMVALU="VISIT: "_$$DATE^APCM1UTL(APCMHVTP(APCMP))
 ;numerator?
 S APCMEP=$$HASST(DFN,$$DOB^AUPNPAT(DFN),APCMEDAT)
 S APCMVALU=APCMVALU_"|||"_$P(APCMEP,U,2)_"|||"_$P(APCMEP,U,1)
 S F=$P(^APCMMUM(APCMIC,0),U,9)
 D S^APCM11E1(APCMRPT,APCMIC,$P(APCMEP,U,1),APCMP,APCMRPTT,APCMTIME,F)
 D SETLIST^APCM11E1
 Q
HASST(P,BD,ED) ;does patient have a SMOKING STATUS
 ;
 NEW A,B,C,D,E,HF
 S C=0
 S HF=""
 S HF=$$LASTHF^APCLAPIU(P,"TOBACCO (SMOKING)",,ED,"A")
 I HF]"" Q 1_U_$$DATE^APCM1UTL($P(HF,U))_" "_$P(HF,U,2)
 Q 0
ECHI ;EP - electronic copy of HI
 NEW APCMP,APCMECV
 K APCMECV
 S (APCMD1,APCMN1)=0
 I APCMRPTT=1 S APCMP=0 F  S APCMP=$O(APCMPRV(APCMP)) Q:APCMP'=+APCMP  D
 .I $D(APCMECHI(APCMP,APCMTIME)) S F=$P(^APCMMUM(APCMIC,0),U,11) D  Q
 ..D S^APCM11E1(APCMRPT,APCMIC,"Provider is excluded from this measure as he/she did not see anyone who requested a copy of their health information during the EHR reporting period.",APCMP,APCMRPTT,APCMTIME,F,1) Q
 .D ALLV^APCLAPIU(DFN,$$FMADD^XLFDT(APCMEDAT,-365),APCMEDAT,"APCMECV")
 .S APCMHV=$$HADV^APCM11CI(DFN,APCMP,$$FMADD^XLFDT(APCMEDAT,-365),APCMEDAT,.APCMECV)
 .I 'APCMHV Q  ;no visits to this provider for this patient so don't bother, the patient is not in the denominator
 .;set denominator value into field
 .S APCMEP=$$HASECHI(DFN,APCMBDAT,$$BDB(APCMEDAT,-4))  ;"" if no requests so not in denom
 .Q:APCMEP=""
 .S F=$P(^APCMMUM(APCMIC,0),U,8)  ;denom field for this measure
 .D S^APCM11E1(APCMRPT,APCMIC,$P(APCMEP,U),APCMP,APCMRPTT,APCMTIME,F)
 .;S APCMVALU="VISIT: "_$$DATE^APCM1UTL(APCMHVTP(APCMP))  ;IHS/CMI/LAB - PATCH 7 FIX
 .S APCMVALU=$$DATE^APCM1UTL(APCMHV)
 .S APCMVALU=APCMVALU_"|||"_$S($P(APCMEP,U,2):"MET: ",1:"NOT MET: ")_$P(APCMEP,U,3)_"|||"_$P(APCMEP,U,2)
 .;numerator?
 .S F=$P(^APCMMUM(APCMIC,0),U,9)
 .D S^APCM11E1(APCMRPT,APCMIC,$P(APCMEP,U,2),APCMP,APCMRPTT,APCMTIME,F)
 .D SETLIST^APCM11E1
 K APCMECV
 Q
HASECHI(P,BD,ED) ;EP - does patient have a ROI
 ;
 NEW A,B,C,D,E,ROI,X,ROII
 S ROI=""  ;set to 1 if had a good request
 S ROII="" ;set to date of reques
 S D=$$FMADD^XLFDT(BD,-1)
 F  S D=$O(^BRNREC("AA",P,D)) Q:D'=+D!(D>ED)  D
 .S X=0 F  S X=$O(^BRNREC("AA",P,D,X)) Q:X'=+X  D
 ..Q:$P($G(^BRNREC(X,11)),U,1)'="E"  ;check to see if the request was electronic
 ..S (A,B)=0 F  S A=$O(^BRNREC(X,23,A)) Q:A'=+A  D
 ...I $P($G(^BRNREC(X,23,A,0)),U,3)='"E" Q  ;electronic request
 ...;had a request and it was disseminated electronically
 ...;was it disseminated within 3 business days?
 ...S B=$P(^BRNREC(X,23,A,0),U,2)
 ...I B="" S ROII=ROII_"Request date: "_$$DATE^APCM1UTL(D)_"disseminated: "_$$DATE^APCM1UTL(B)_";" Q
 ...I B>$$BD(D,3) S ROII=ROII_"Request date: "_$$DATE^APCM1UTL(D)_" disseminated: "_$$DATE^APCM1UTL(B)_";" Q
 ...S ROI=1_U_1_U_"Request Date: "_$$DATE^APCM1UTL(D)_" disseminated: "_$$DATE^APCM1UTL(B)
 I $P(ROI,U,1) Q ROI
 I ROII="" Q ""
 Q 1_U_0_U_ROII
CS ;EP - CLINICAL SUMMARIES ON EACH VISIT
 NEW APCMP
 S (APCMD1,APCMN1)=0
 I APCMRPTT=1 S APCMP=0 F  S APCMP=$O(APCMPRV(APCMP)) Q:APCMP'=+APCMP  D
 .I $D(APCMOFFV(APCMP,APCMTIME)) S F=$P(^APCMMUM(APCMIC,0),U,11) D  Q
 ..D S^APCM11E1(APCMRPT,APCMIC,"Provider is excluded from this measure as he/she did not have any office visits during the EHR Reporting Period.",APCMP,APCMRPTT,APCMTIME,F,1) Q
 .Q:'$D(APCMHVTP(APCMP))  ;no visits to this provider for this patient so don't bother, the patient is not in the denominator
 .;set denominator value into field
 .S APCMEP=$$HASCS(DFN,APCMP,APCMBDAT,$$BDB(APCMEDAT,-4),.APCMVSTS)  ;RETURNS # OF VISIT^# THAT HAD PWH GIVEN W/IN 3 BUS DAYS
 .S F=$P(^APCMMUM(APCMIC,0),U,8)  ;denom field for this measure
 .D S^APCM11E1(APCMRPT,APCMIC,$P(APCMEP,U),APCMP,APCMRPTT,APCMTIME,F)
 .;S APCMVALU="VISIT: "_$$DATE^APCM1UTL(APCMHVTP(APCMP))
 .I $P(APCMEP,U,1) S APCMVALU="# visits: "_$P(APCMEP,U,1)_" - # w/PWH: "_$P(APCMEP,U,2)_"|||"_$P(APCMEP,U,3)_"|||"_$S('(+$P(APCMEP,U,1)):0,$P(APCMEP,U,1)=$P(APCMEP,U,2):1,1:0)
 .;numerator?
 .S F=$P(^APCMMUM(APCMIC,0),U,9)
 .D S^APCM11E1(APCMRPT,APCMIC,$P(APCMEP,U,2),APCMP,APCMRPTT,APCMTIME,F)
 .I APCMVALU]"" D SETLIST^APCM11E1
 Q
HASCS(P,R,BD,ED,VSTS) ;does patient have a SMOKING STATUS
 ;
 NEW A,B,C,D,E,X,Y,V,PWH,J
 ;LOOP THROUGH ALL VISITS AND COUNT VISIT AND PWH'S
 S PWH="0^0"
 ;RETURN 3RD PIECE AS LIST OF VISITS WITH A "PWH" or "No PWH"
 S X=0 F  S X=$O(VSTS(X)) Q:X'=+X  D
 .S G=0
 .S V=$P(VSTS(X),U,5)
 .I '$D(^AUPNVSIT(V,0)) Q
 .I $P(^AUPNVSIT(V,0),U,11) Q  ;deleted
 .I "AOSM"'[$P(^AUPNVSIT(V,0),U,7) Q  ;not correct service category/OFFICE VISIT
 .S C=$$CLINIC^APCLV(V,"C")
 .Q:C=30
 .Q:C=77
 .I C=76 Q  ;no lab
 .I C=63 Q  ;no radiology
 .I C=39 Q  ;no pharmacy
 .S Y=0 F  S Y=$O(^AUPNVPRV("AD",V,Y)) Q:Y'=+Y!(G)  D
 ..I $P($G(^AUPNVPRV(Y,0)),U)'=R Q
 ..I $P($G(^AUPNVPRV(Y,0)),U,4)'="P" Q
 ..S G=1
 .Q:'G  ;not a visit to this provider
 .Q:$$VD^APCLV(V)>ED
 .S $P(PWH,U,1)=$P(PWH,U,1)+1
 .;was there a pwh after the date of the visit up to 3 days after day of visit
 .;S D=$P(^AUPNVSIT(V,0),U),D=D-.000001  ;date of visit
 .S E=$$BD($$VD^APCLV(V),3)
 .S A=$$FMADD^XLFDT($$VD^APCLV(V),-1),B=0
 .F  S A=$O(^APCHPWHL("AA",P,A)) Q:A'=+A!($P(A,".")>E)!(B)  D
 ..S J=0 F  S J=$O(^APCHPWHL("AA",P,A,J)) Q:J'=+J!(B)  D
 ...Q:$P(^APCHPWHL(J,0),U,5)<$P(^AUPNVSIT(V,0),U,1)
 ...Q:$P($P(^APCHPWHL(J,0),U,5),".")>E
 ...S B=1
 .I B S $P(PWH,U,2)=$P(PWH,U,2)+1
 .S $P(PWH,U,3)=$P(PWH,U,3)_$$DATE^APCM1UTL($$VD^APCLV(V))_":"_$S(B:"PWH",1:"No PWH")_";"
 Q PWH
BD(D,N) ;3 business days from this date
 NEW O,C,Q,R,T
 S C=0,T=""
 S O=D F  S O=$$FMADD^XLFDT(O,1) Q:C=N  D
 .S Q=$$DOW^XLFDT(O,1)
 .I Q=0 Q
 .I Q=6 Q
 .Q:$D(^HOLIDAY(O))
 .S C=C+1,T=O
 Q T
BDB(D,N) ;EP - 3 business days from this date
 NEW O,C,Q,R,T
 S C=0,T=""
 S O=D F  S O=$$FMADD^XLFDT(O,-1) Q:C=$P(N,"-",2)  D
 .S Q=$$DOW^XLFDT(O,1)
 .I Q=0 Q
 .I Q=6 Q
 .Q:$D(^HOLIDAY(O))
 .S C=C+1,T=O
 Q T
