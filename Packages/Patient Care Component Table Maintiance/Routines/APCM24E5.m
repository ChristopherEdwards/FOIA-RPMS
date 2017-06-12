APCM24E5 ;IHS/CMI/LAB - IHS MU; 
 ;;1.0;IHS MU PERFORMANCE REPORTS;**5,6**;MAR 26, 2012;Build 65
 ;;;;;;Build 3
PATEDUC ;EP - CALCULATE PAT ED
 ;for each provider or for the facility find out if this
 ;patient had a visit of A, O, R, S to this provider or facility
 ;if so, then check to see if they have PAT ED LITERATURE documented anytime before end of report period
 NEW APCMP
 S (APCMD1,APCMN1)=0
 I APCMRPTT=1 D  Q
 .S APCMP=0 F  S APCMP=$O(APCMPRV(APCMP)) Q:APCMP'=+APCMP  D
 ..I $D(APCMOFFV(APCMP,APCMTIME)) S F=$P(^APCM24OB(APCMIC,0),U,11) D  Q
 ...D S^APCM24E1(APCMRPT,APCMIC,"Provider is excluded from this measure as he/she did not have any office visits during the EHR Reporting Period.",APCMP,APCMRPTT,APCMTIME,F,1) Q
 ..Q:'$D(APCMPEVT(APCMP))  ;no visits to this provider for this patient so don't bother, the patient is not in the denominator
 ..;Q:'$D(APCMHVTP(APCMP))
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
 S F=$P(^APCM24OB(APCMIC,0),U,8)  ;denom field for this measure
 D S^APCM24E1(APCMRPT,APCMIC,1,APCMP,APCMRPTT,APCMTIME,F)
 ;numerator?
 S APCMVALU="VISIT: "_$$DATE^APCM1UTL(APCMHVTP(APCMP))
 ;S APCMEP=$$HASED(DFN,APCMBDAT,DT)
 ;S APCMEP=$$HASED(DFN,$$FMADD^XLFDT(APCMBDAT,-365),DT)
 ;I APCMRPTT=2 S APCMEP=$$HASEDH(DFN,APCMBDAT,APCMEDAT,APCMFAC,.APCMVSTS)
 NEW B
 I APCMRPTT=1 S B=$E(APCMBDAT,1,3)_"0101"
 I APCMRPTT=2 S B=$S(+$E(APCMBDAT,4,5)>9:$E(APCMBDAT,1,3)_"1001",1:$E(APCMBDAT,1,3)-1_"1001")
 S APCMEP=$$HASED(DFN,B,APCMEDAT)
 S APCMVALU=APCMVALU_"|||"_$P(APCMEP,U,2)_"|||"_$P(APCMEP,U,1)
 S F=$P(^APCM24OB(APCMIC,0),U,9)
 D S^APCM24E1(APCMRPT,APCMIC,$P(APCMEP,U,1),APCMP,APCMRPTT,APCMTIME,F)
 ;S APCMVALU=APCMVALU_"|||"_$P(APCMEP,U,2)_"|||"_$P(APCMEP,U,1)
 D SETLIST^APCM24E1
 Q
 ;
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
HASMMR(V) ;does patient have a m-mr ON this visit in v updated/reviewed
 ;
 NEW X,Y,Z
 S Z=""
 S X=0 F  S X=$O(^AUPNVRUP("AD",V,X)) Q:X'=+X!(Z)  D
 .S Y=0 F  S Y=$O(^AUPNVRUP(X,26,Y)) Q:Y'=+Y!(Z)  D
 ..I $P($G(^AUPNVRUP(X,26,Y,0)),U,1)=428191000124101 S Z=1
 Q Z
PR ;EP - patient reminders
 ;if patinet seen 2 or more times in 24 months prior to bd and still alive on last day of reporting period
 ;exclude deceased, and inactive charts
 ;if so, then check to see if they have icare notice ocumented any time before end of report period
 NEW APCMP
 S (APCMD1,APCMN1)=0
 I APCMRPTT=1 S APCMP=0 F  S APCMP=$O(APCMPRV(APCMP)) Q:APCMP'=+APCMP  D
 .I $D(APCM24BR(APCMP)) S F=$P(^APCM24OB(APCMIC,0),U,11) D  Q
 ..D S^APCM24E1(APCMRPT,APCMIC,"Provider is excluded from this measure as the EP did not have any office visits in 24 months before report period.",APCMP,APCMRPTT,APCMTIME,F,1) Q
 .;set denominator value into field
 .S G=0
PR1 .;IS CHART ACTIVE OR DECEASED
 .S X=$$DOD^AUPNPAT(DFN)
 .I X,X'>APCMEDAT Q
 .Q:'$O(^AUPNPAT(DFN,41,0))  ;no charts
 .S X=$P($G(^AUPNPAT(DFN,41,DUZ(2),0)),U,3)
 .I X,X'>APCMEDAT Q
 .;2 visits w/EP in 24 months before EHR reporting period?
 .Q:'$$HADV(DFN,APCMP,$$FMADD^XLFDT(APCMBD,-(24*30.5)),$$FMADD^XLFDT(APCMBD,-1))  ;DIDN'T HAVE 2 VISITS
 .S F=$P(^APCM24OB(APCMIC,0),U,8)  ;denom field for this measure
 .D S^APCM24E1(APCMRPT,APCMIC,1,APCMP,APCMRPTT,APCMTIME,F)
 .S APCMVALU=""
 .;numerator?
 .S APCMEP=$$HASRM(DFN,APCMBDAT,APCMEDAT)
 .S APCMVALU="|||"_"NOTIFICATION: "_$P(APCMEP,U,2)_"|||"_$P(APCMEP,U,1)
 .S F=$P(^APCM24OB(APCMIC,0),U,9)
 .D S^APCM24E1(APCMRPT,APCMIC,$P(APCMEP,U,1),APCMP,APCMRPTT,APCMTIME,F)
 .D SETLIST^APCM24E1
 Q
HADV(P,R,BD,ED) ;EP - had visit of A, O, R, S with provider R in time frame BD-ED
 ;PATCH 1 excludes ER and case management clinics
 ;patch 1 provider must be primary only
 ; so, in summary, the patient must have at least 1 A,O,R,M, non-ER, non-case man visit
 ; where this provider is the primary provider
 I '$G(P) Q ""
 I '$G(R) Q ""
 I '$G(BD) Q ""
 I '$G(ED) Q ""
 I '$D(^AUPNPAT(P,0)) Q ""
 I '$D(^VA(200,R,0)) Q ""
 NEW V,X,Y,G,VSTS
 D ALLV^APCLAPIU(P,BD,ED,"VSTS")
 S G=0
 S X=0 F  S X=$O(VSTS(X)) Q:X'=+X!(G>1)  D
 .S V=$P(VSTS(X),U,5)
 .I '$D(^AUPNVSIT(V,0)) Q
 .I $P(^AUPNVSIT(V,0),U,11) Q  ;deleted
 .I "AOSM"'[$P(^AUPNVSIT(V,0),U,7) Q  ;not correct service category
 .S C=$$CLINIC^APCLV(V,"C")
 .I C=30 Q  ;no ER per Carmen patch 1
 .I C=77 Q  ;no case management clinic 77 per Chris
 .I C=76 Q  ;no lab
 .I C=63 Q  ;no radiology
 .I C=39 Q  ;no pharmacy
 .S Y=$$PRIMPROV^APCLV(V,"I")
 .I 'Y Q
 .I Y'=R Q  ;not this provider
 .S G=G+1
 I G>1 Q 1  ;2 or more?
 Q 0
 ;
HASRM(P,BD,ED) ;
 ;
 NEW A,B,C,NOTIF,N
 S NOTIF=""
 S A=0 F  S A=$O(^BQI(90509.4,"B",P,A)) Q:A'=+A!(NOTIF)  D
 .S N=$G(^BQI(90509.4,A,0))
 .I N="" Q  ;BAD XREF
 .S B=$P($P(N,U,4),".")
 .Q:B<BD  ;before time period
 .Q:B>ED  ;after time period
 .S C=$P(N,U,2)  ;preferred method
 .I C="" S NOTIF=1_U_$$GET1^DIQ(90509.4,A,.09)_" "_$$FMTE^XLFDT(B) Q
 .I C'=$P(N,U,3)  ;preferred doesn't match notificaton type so don't count it
 .S NOTIF=1_U_$$GET1^DIQ(90509.4,A,.09)_" "_$$FMTE^XLFDT(B)
 Q NOTIF
SC ;EP - TRANSITION OF CARE SUMMARY
 ;for each provider count each Visit that HAS a v referral
 K ^TMP($J,"TRANS")
 NEW APCMLABS,MMR
 D TOCSUMC
 NEW APCMP,N,F,O,Y
 S (APCMD1,APCMN1)=0
 I APCMRPTT=1 S APCMP=0 F  S APCMP=$O(APCMPRV(APCMP)) Q:APCMP'=+APCMP  D
 .I $P($G(MMR(APCMP)),U,1)<100 D
 ..S F=$P(^APCM24OB(APCMIC,0),U,11) D S^APCM24E1(APCMRPT,APCMIC,"Provider is excluded from this measure as he/she had less than 100 referrals during the EHR reporting period.",APCMP,APCMRPTT,APCMTIME,F,1)
 ..;now get all related measures
 ..S O=0 F  S O=$O(^APCM24OB(APCMIC,29,O)) Q:O'=+O  S Y=$P(^APCM24OB(APCMIC,29,O,0),U,1),Y=$O(^APCM24OB("B",Y,0)) I Y D
 ...S F=$P(^APCM24OB(Y,0),U,11) D S^APCM24E1(APCMRPT,Y,"X",APCMP,APCMRPTT,APCMTIME,F,1)
 .;set value for measure 3
 .S Y=$O(^APCM24OB("B","S2.023.2.EP",0))
 .S F=$P(^APCM24OB(Y,0),U,8) D S^APCM24E1(APCMRPT,Y,APCMATTE("S2.023.EP",APCMP),APCMP,APCMRPTT,APCMTIME,F)
 .;set denominator value into field FOR measure 1
 .S F=$P(^APCM24OB(APCMIC,0),U,8)  ;denom field for this measure
 .S N=$P($G(MMR(APCMP)),U,1)  ;returns # of transS^# with mmr
 .D S^APCM24E1(APCMRPT,APCMIC,N,APCMP,APCMRPTT,APCMTIME,F)
 .;now set patient list for this provider
 .S P=0 F  S P=$O(^TMP($J,"TRANS",APCMP,P)) Q:P'=+P  D
 ..I $P(^TMP($J,"TRANS",APCMP,P),U,1)=$P(^TMP($J,"TRANS",APCMP,P),U,2) S APCMVALU="# referrals: "_$P(^TMP($J,"TRANS",APCMP,P),U,1)_"|||"_" # w/TOCS: "_+$P(^TMP($J,"TRANS",APCMP,P),U,2)_" "_$P(^TMP($J,"TRANS",APCMP,P),U,3)_"|||1" D  Q
 ...S DFN=P D SETLIST^APCM24E1 Q
 ..S DFN=P,APCMVALU="# referrals: "_$P(^TMP($J,"TRANS",APCMP,P),U,1)_"|||"_" # w/TOCS: "_+$P(^TMP($J,"TRANS",APCMP,P),U,2)_" "_$P(^TMP($J,"TRANS",APCMP,P),U,3)_"|||0" D SETLIST^APCM24E1
 .;numerator?
 .S F=$P(^APCM24OB(APCMIC,0),U,9)
 .S N=$P($G(MMR(APCMP)),U,2)
 .D S^APCM24E1(APCMRPT,APCMIC,N,APCMP,APCMRPTT,APCMTIME,F)
 .;NOW SET VALUES FOR MEASURE 2
 .S Y=$O(^APCM24OB("B","S2.023.1.EP",0))
 .S F=$P(^APCM24OB(Y,0),U,8) D S^APCM24E1(APCMRPT,Y,$P($G(MMR(APCMP)),U,1),APCMP,APCMRPTT,APCMTIME,F)
 .S F=$P(^APCM24OB(Y,0),U,9)
 .S N=$P($G(MMR(APCMP)),U,5)
 .D S^APCM24E1(APCMRPT,APCMIC,N,APCMP,APCMRPTT,APCMTIME,F)
 I APCMRPTT=2 S APCMP=APCMFAC  D
 .I '$P($G(MMR(APCMP)),U,1) D  Q
 ..S F=$P(^APCM24OB(APCMIC,0),U,11) D S^APCM24E1(APCMRPT,APCMIC,"Facility is excluded from this measure as there were no referrals during the EHR reporting period.",APCMP,APCMRPTT,APCMTIME,F,1)
 ..;now get all related measures
 ..S O=0 F  S O=$O(^APCM24OB(APCMIC,29,O)) Q:O'=+O  S Y=$P(^APCM24OB(APCMIC,29,O,0),U,1),Y=$O(^APCM24OB("B",Y,0)) I Y D
 ...S F=$P(^APCM24OB(Y,0),U,11) D S^APCM24E1(APCMRPT,Y,"X",APCMP,APCMRPTT,APCMTIME,F,1)
 .;set value for measure 3
 .S Y=$O(^APCM24OB("B","S2.021.2.H",0))
 .S F=$P(^APCM24OB(Y,0),U,8) D S^APCM24E1(APCMRPT,Y,APCMATTE("S2.021.H",APCMP),APCMP,APCMRPTT,APCMTIME,F)
 .;set denominator value into field FOR measure 1
 .S F=$P(^APCM24OB(APCMIC,0),U,8)  ;denom field for this measure
 .S N=$P($G(MMR(APCMP)),U,1)  ;returns # of transS^# with mmr
 .D S^APCM24E1(APCMRPT,APCMIC,N,APCMP,APCMRPTT,APCMTIME,F)
 .;now set patient list for this provider
 .S P=0 F  S P=$O(^TMP($J,"TRANS",APCMP,P)) Q:P'=+P  D
 ..I $P(^TMP($J,"TRANS",APCMP,P),U,1)=$P(^TMP($J,"TRANS",APCMP,P),U,2) S APCMVALU="# referrals: "_$P(^TMP($J,"TRANS",APCMP,P),U,1)_"|||"_" # w/TOCS: "_+$P(^TMP($J,"TRANS",APCMP,P),U,2)_" "_$P(^TMP($J,"TRANS",APCMP,P),U,3)_"|||1" D  Q
 ...S DFN=P D SETLIST^APCM24E1 Q
 ..S DFN=P,APCMVALU="# referrals: "_$P(^TMP($J,"TRANS",APCMP,P),U,1)_"|||"_" # w/TOCS: "_+$P(^TMP($J,"TRANS",APCMP,P),U,2)_" "_$P(^TMP($J,"TRANS",APCMP,P),U,3)_"|||0" D SETLIST^APCM24E1
 .;numerator?
 .S F=$P(^APCM24OB(APCMIC,0),U,9)
 .S N=$P($G(MMR(APCMP)),U,2)
 .D S^APCM24E1(APCMRPT,APCMIC,N,APCMP,APCMRPTT,APCMTIME,F)
 .;NOW SET VALUES FOR MEASURE 2
 .S Y=$O(^APCM24OB("B","S2.021.1.H",0))
 .S F=$P(^APCM24OB(Y,0),U,8) D S^APCM24E1(APCMRPT,Y,$P($G(MMR(APCMP)),U,1),APCMP,APCMRPTT,APCMTIME,F)
 .S F=$P(^APCM24OB(Y,0),U,9)
 .S N=$P($G(MMR(APCMP)),U,5)
 .D S^APCM24E1(APCMRPT,APCMIC,N,APCMP,APCMRPTT,APCMTIME,F)
 K ^TMP($J,"TRANS")
 Q
TOCSUMC ;EP - ep toc
 ;SET ARRAY MMR to MMR(prov ien)=denom^numer
 ;DENOM=# VISITS W/REFERRAL
 ;NUMER=# W/TOC DOCUMENT IN 600 MULTIPLE
 ;IF DENOM =0 THEN PROVIDER EXCLUSION
 NEW T,C,PAT,N,APCMX,R,C,G,Z,S,B,E,J,K
 S C=0,N=0,PAT=""
 S T=$O(^APCMMUCN("B","INTERIM STAGE 2 2014",0))
 ;GO THROUGH EACH PATIENT WHO HAS VISITS
 S PAT=0 F  S PAT=$O(^AUPNVSIT("AA",PAT)) Q:PAT'=+PAT  D TOCSUMC1
 Q
TOCSUMC1 ;
 NEW APCMLAB
 S APCMLAB="APCMLAB"
 D ALLV^APCLAPIU(PAT,APCMBDAT,APCMEDAT,APCMLAB)  ;get all visits for this patient in time period
 S APCMX=0 F  S APCMX=$O(APCMLAB(APCMX)) Q:APCMX'=+APCMX  D
 .S V=$P(APCMLAB(APCMX),U,5)  ;VISIT IEN
 .Q:'$D(^AUPNVSIT(V,0))  ;NO VISIT??
 .I APCMRPTT=2,APCMMETH="E" Q:'$$HOSER^APCM24E6(V,APCMFAC)  S R=APCMFAC G TOCS2
 .I APCMRPTT=2,APCMMETH="O" Q:"OH"'[$P(^AUPNVSIT(V,0),U,7)  Q:$P(^AUPNVSIT(V,0),U,6)'=APCMFAC  S R=APCMFAC G TOCS2
 .S R=$$PRIMPROV^APCLV(V,"I")  ;primary provider IEN
 .Q:'R
 .I '$D(APCMPRV(R)) Q  ;not a provider of interest for this report
 .Q:"AOSM"'[$P(^AUPNVSIT(V,0),U,7)
 .S C=$$CLINIC^APCLV(V,"C")
 .Q:C=30
 .Q:C=77
 .Q:C=76
 .Q:C=63
 .Q:C=39
TOCS2 .;IS THERE A V REFERAL THAT MEETS DENOM DEFINITION
 .S Z=0 F  S Z=$O(^AUPNVREF("AD",V,Z)) Q:Z'=+Z  D
 ..Q:'$D(^AUPNVREF(Z,0))  ;??
 ..S S=$P(^AUPNVREF(Z,0),U,6)  ;REFERRAL IEN
 ..Q:'S  ;no referral??
 ..Q:'$D(^BMCREF(S,0))  ;bad pointer
 ..Q:$P(^BMCREF(S,0),U,4)="N"  ;NO INHOUSE
 ..Q:$P($G(^BMCREF(S,11)),U,5)=""  ;MUST HAVE AN EXPECTED BEGIN DOS
 ..S D=$P($G(^BMCREF(S,13)),U,5)  ;approval date
 ..Q:D=""  ;NO APPROVAL DATE
 ..Q:D>APCMEDAT  ;AFTER TP
 ..Q:D<APCMBDAT  ;BEFORE TP
SUMNUM ..;
 ..I '$D(MMR(R)) S MMR(R)=""
 ..S $P(MMR(R),U,1)=$P(MMR(R),U,1)+1 D
 ...S $P(^TMP($J,"TRANS",R,PAT),U,1)=$P($G(^TMP($J,"TRANS",R,PAT)),U,1)+1
 ...S $P(^TMP($J,"TRANS",R,PAT),U,3)=$P(^TMP($J,"TRANS",R,PAT),U,3)_" "_$$VD^APCLV(V,"S")_"-"_$P(^BMCREF(S,0),U,2)
 ..;now check numerator, FIELD 600
 ..S G=0,T=0
 ..;FIRST LOOK FOR A TX AND ACKNOWLEDGED IF FOUND, USE IT
 ..;NEXT LOOK FOR A TX, IF FOUND, USE IT
 ..;THEN LOOK FOR PRINTED.
 ..S B=0 F  S B=$O(^BMCREF(S,6,B)) Q:B'=+B!(G)  D
 ...S (A,E)=""
 ...I $P(^BMCREF(S,6,B,0),U,4)'="CT" Q
 ...S E=$P($P(^BMCREF(S,6,B,0),U,6),".")
 ...S M=$$CD(E,D,APCMEDAT)
 ...I 'M S E=$P($P(^BMCREF(S,6,B,0),U,1),".") S M=$$CD(E,D,APCMEDAT) Q:'M  ;dates aren't good
 ...S A=$P($P(^BMCREF(S,6,B,0),U,3),".")  ;tx acknowledged
 ...I A,A'<D,A'>APCMEDAT S G=1,T="CT"
 ...Q
 ..I G D SN Q
 ..;CHECK FOR TX BUT NO ACKNOWLEDGE
 ..S (G,A,T)=""
 ..S B=0 F  S B=$O(^BMCREF(S,6,B)) Q:B'=+B!(G)  D
 ...S (A,E)=""
 ...I $P(^BMCREF(S,6,B,0),U,4)'="CT" Q
 ...S E=$P($P(^BMCREF(S,6,B,0),U,6),".")
 ...S M=$$CD(E,D,APCMEDAT)
 ...I 'M S E=$P($P(^BMCREF(S,6,B,0),U,1),".") S M=$$CD(E,D,APCMEDAT) Q:'M  ;dates aren't good
 ...;S A=$P($P(^BMCREF(S,6,B,0),U,3),".")  ;tx acknowledged
 ...S G=1,A=0,T="CT"
 ...Q
 ..I G D SN Q
 ..;NOW PRINTED
 ..S (G,A,T)=""
 ..S B=0 F  S B=$O(^BMCREF(S,6,B)) Q:B'=+B!(G)  D
 ...S (A,E)=""
 ...I $P(^BMCREF(S,6,B,0),U,4)'="CP" Q
 ...S E=$P($P(^BMCREF(S,6,B,0),U,6),".")
 ...S M=$$CD(E,D,APCMEDAT)
 ...I 'M S E=$P($P(^BMCREF(S,6,B,0),U,1),".") S M=$$CD(E,D,APCMEDAT) Q:'M  ;dates aren't good
 ...S G=1,A=0,T="CP"
 ...Q
 ..I G D SN Q
 ..;
SUMAPCC ..;CHECK APCC DOCUMENT FILE
 ..S J=0 F  S J=$O(^APCCDPL(V,1,J)) Q:J'=+J!(G)  D
 ...Q:$P($G(^APCCDPL(V,1,J,0)),U,4)'=2  ;TOC ONLY
 ...Q:$P($P(^APCCDPL(V,1,J,0),U,1),".")'=$$VD^APCLV(V)  ;DATE MUST EQUAL VISIT DATE
 ...S G=1
 ...S $P(MMR(R),U,2)=$P(MMR(R),U,2)+1 D
 ....S $P(^TMP($J,"TRANS",R,PAT),U,2)=$P($G(^TMP($J,"TRANS",R,PAT)),U,2)+1
 ....S $P(^TMP($J,"TRANS",R,PAT),U,3)=$P(^TMP($J,"TRANS",R,PAT),U,3)_";YES APCC TOCS"
 ..I 'G S $P(^TMP($J,"TRANS",R,PAT),U,3)=$P(^TMP($J,"TRANS",R,PAT),U,3)_";NO TOCS" Q
 Q
SN ;
 S $P(MMR(R),U,2)=$P(MMR(R),U,2)+1 D  Q
 .S $P(^TMP($J,"TRANS",R,PAT),U,2)=$P($G(^TMP($J,"TRANS",R,PAT)),U,2)+1
 .S $P(^TMP($J,"TRANS",R,PAT),U,3)=$P(^TMP($J,"TRANS",R,PAT),U,3)_";YES "_T I T="CT" S $P(^TMP($J,"TRANS",R,PAT),U,3)=$P(^TMP($J,"TRANS",R,PAT),U,3)_$S(A:" TX",1:"")
 .I T="CT" S $P(MMR(R),U,4)=$P(MMR(R),U,4)+1 I A S $P(MMR(R),U,5)=$P(MMR(R),U,5)+1
 Q
CD(E,D,APCMEDAT) ;
 I E="" Q 0  ;NO DATE TRANSMITTED
 I E<D Q 0  ;BEFORE APPROVAL DATE
 I E>APCMEDAT Q 0  ;AFTER TIME PERIOD
 Q 1
