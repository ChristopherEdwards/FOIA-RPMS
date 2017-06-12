APCM14E5 ;IHS/CMI/LAB - IHS MU; 
 ;;1.0;IHS MU PERFORMANCE REPORTS;**5,6**;MAR 26, 2012;Build 65
 ;
PATEDUC ;EP - CALCULATE PAT ED
 ;if so, then check to see if they have PAT ED LITERATURE documented anytime from report period begin date to DT
 NEW APCMP
 S (APCMD1,APCMN1)=0
 I APCMRPTT=1 D  Q
 .S APCMP=0 F  S APCMP=$O(APCMPRV(APCMP)) Q:APCMP'=+APCMP  D
 ..Q:'$D(APCMHVTP(APCMP))
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
 S F=$P(^APCM14OB(APCMIC,0),U,8)
 D S^APCM14E1(APCMRPT,APCMIC,1,APCMP,APCMRPTT,APCMTIME,F)
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
 S F=$P(^APCM14OB(APCMIC,0),U,9)
 D S^APCM14E1(APCMRPT,APCMIC,$P(APCMEP,U,1),APCMP,APCMRPTT,APCMTIME,F)
 ;S APCMVALU=APCMVALU_"|||"_$P(APCMEP,U,2)_"|||"_$P(APCMEP,U,1)
 D SETLIST^APCM14E1
 Q
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
 ;
HASMMR(P,BDD,EDD) ;does patient have a m-mr ON this visit in v updated/reviewed
 ;
 NEW X,Y,Z,B,W,E,D,T
 ;V UPDATED REVIEWED SNOMED 2 WEEKS BEFORE REPORT PERIOD UP THROUGH TODAY
 S Z="",B=""
 S W=0 F  S W=$O(^AUPNVRUP("AC",P,W)) Q:W'=+W!(Z)  D
 .S Y=0 F  S Y=$O(^AUPNVRUP(W,26,Y)) Q:Y'=+Y!(Z)  D
 ..I $P($G(^AUPNVRUP(W,26,Y,0)),U,1)'=428191000124101 Q
 ..S E=""
 ..S D=$P($$GET1^DIQ(9000010.54,W,1201,"I"),".")
 ..I D<BDD Q
 ..I D>EDD Q
SNN ..S Z=1
 Q Z
PR ;EP - patient reminders
 ;for each provider or for the facility find out if this
 ;if patient is <=5 or >=65 count them
 ;exclude deceased, and inactive charts
 ;if so, then check to see if they have icare notice ocumented any time before end of report period
 NEW APCMP
 S (APCMD1,APCMN1)=0
 I APCMRPTT=1 S APCMP=0 F  S APCMP=$O(APCMPRV(APCMP)) Q:APCMP'=+APCMP  D
 .I APCMN565(APCMTIME) S F=$P(^APCM14OB(APCMIC,0),U,11) D  Q
 ..D S^APCM14E1(APCMRPT,APCMIC,"Facility is excluded from this measure as the database does not have any patients <=5 or >=65 years old.",APCMP,APCMRPTT,APCMTIME,F,1) Q
 .;set denominator value into field
 .S G=0
 .I APCMAGEB<5 G PR1
 .I APCMAGEB<65 Q
 .Q:$$DOB^AUPNPAT(DFN)>APCMBDAT
PR1 .;IS CHART ACTIVE OR DECEASED
 .S X=$$DOD^AUPNPAT(DFN)
 .I X,X'>APCMEDAT Q
 .Q:'$O(^AUPNPAT(DFN,41,0))  ;no charts
 .S X=$P($G(^AUPNPAT(DFN,41,DUZ(2),0)),U,3)
 .I X,X'>APCMEDAT Q
 .;did they have a visit ever to the EP?
 .;K APCMPRVT
 .;D ALLV^APCLAPIU(DFN,$$DOB^AUPNPAT(DFN),APCMEDAT,"APCMPRVT")
 .I '$$HADV^APCM13E5(DFN,APCMP,$$DOB^AUPNPAT(DFN),APCMEDAT) Q
 .S F=$P(^APCM14OB(APCMIC,0),U,8)
 .D S^APCM14E1(APCMRPT,APCMIC,1,APCMP,APCMRPTT,APCMTIME,F)
 .S APCMVALU=""
 .;numerator?
 .S APCMEP=$$HASRM(DFN,APCMBDAT,APCMEDAT,APCMP,.APCMVSTS)  ;return # of visits^# w/pwh
 .S APCMVALU="Patient age: "_$$AGE^AUPNPAT(DFN,APCMBDAT)_"|||"_"NOTIFICATION: "_$P(APCMEP,U,2)_"|||"_$P(APCMEP,U,1)
 .S F=$P(^APCM14OB(APCMIC,0),U,9)
 .D S^APCM14E1(APCMRPT,APCMIC,$P(APCMEP,U,1),APCMP,APCMRPTT,APCMTIME,F)
 .D SETLIST^APCM14E1
 Q
HASRM(P,BD,ED,R,VSTS) ;
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
 NEW APCMP,N,F
 S (APCMD1,APCMN1)=0
 I APCMRPTT=1 S APCMP=0 F  S APCMP=$O(APCMPRV(APCMP)) Q:APCMP'=+APCMP  D
 .I '$P($G(MMR(APCMP)),U,1) D
 ..S F=$P(^APCM14OB(APCMIC,0),U,11) D S^APCM14E1(APCMRPT,APCMIC,"Provider is excluded from this measure as he/she did not have any referrals during the EHR reporting period.",APCMP,APCMRPTT,APCMTIME,F,1) Q
 .;set denominator value into field
 .S F=$P(^APCM14OB(APCMIC,0),U,8)  ;denom field for this measure
 .S N=$P($G(MMR(APCMP)),U,1)  ;returns # of transS^# with mmr
 .D S^APCM14E1(APCMRPT,APCMIC,N,APCMP,APCMRPTT,APCMTIME,F)
 .;now set patient list for this provider
 .S P=0 F  S P=$O(^TMP($J,"TRANS",APCMP,P)) Q:P'=+P  D
 ..I $P(^TMP($J,"TRANS",APCMP,P),U,1)=$P(^TMP($J,"TRANS",APCMP,P),U,2) S APCMVALU="# referrals: "_$P(^TMP($J,"TRANS",APCMP,P),U,1)_"|||"_" # w/TOCS: "_+$P(^TMP($J,"TRANS",APCMP,P),U,2)_" "_$P(^TMP($J,"TRANS",APCMP,P),U,3)_"|||1" D  Q
 ...S DFN=P D SETLIST^APCM14E1 Q
 ..S DFN=P,APCMVALU="# referrals: "_$P(^TMP($J,"TRANS",APCMP,P),U,1)_"|||"_" # w/TOCS: "_+$P(^TMP($J,"TRANS",APCMP,P),U,2)_" "_$P(^TMP($J,"TRANS",APCMP,P),U,3)_"|||0" D SETLIST^APCM14E1
 .;numerator?
 .S F=$P(^APCM14OB(APCMIC,0),U,9)
 .S N=$P($G(MMR(APCMP)),U,2)
 .D S^APCM14E1(APCMRPT,APCMIC,N,APCMP,APCMRPTT,APCMTIME,F)
 I APCMRPTT=2 S APCMP=APCMFAC  D
 .I '$P($G(MMR(APCMP)),U,1) D  Q
 ..S F=$P(^APCM14OB(APCMIC,0),U,11) D S^APCM14E1(APCMRPT,APCMIC,"Facility is excluded from this measure as he/she did not have any referrals during the EHR reporting period.",APCMP,APCMRPTT,APCMTIME,F,1) Q
 .;set denominator value into field
 .S F=$P(^APCM14OB(APCMIC,0),U,8)  ;denom field for this measure
 .S N=$P($G(MMR(APCMP)),U,1)  ;returns # of transS^# with mmr
 .D S^APCM14E1(APCMRPT,APCMIC,N,APCMP,APCMRPTT,APCMTIME,F)
 .;now set patient list for this provider
 .S P=0 F  S P=$O(^TMP($J,"TRANS",APCMP,P)) Q:P'=+P  D
 ..I $P(^TMP($J,"TRANS",APCMP,P),U,1)=$P(^TMP($J,"TRANS",APCMP,P),U,2) S APCMVALU="# referrals: "_$P(^TMP($J,"TRANS",APCMP,P),U,1)_"|||"_" # w/TOCS: "_+$P(^TMP($J,"TRANS",APCMP,P),U,2)_" "_$P(^TMP($J,"TRANS",APCMP,P),U,3)_"|||1" D  Q
 ...S DFN=P D SETLIST^APCM14E1 Q
 ..S DFN=P,APCMVALU="# referrals: "_$P(^TMP($J,"TRANS",APCMP,P),U,1)_"|||"_" # w/TOCS: "_+$P(^TMP($J,"TRANS",APCMP,P),U,2)_" "_$P(^TMP($J,"TRANS",APCMP,P),U,3)_"|||0" D SETLIST^APCM14E1
 .;numerator?
 .S F=$P(^APCM14OB(APCMIC,0),U,9)
 .S N=$P($G(MMR(APCMP)),U,2)
 .D S^APCM14E1(APCMRPT,APCMIC,N,APCMP,APCMRPTT,APCMTIME,F)
 K ^TMP($J,"TRANS")
 Q
TOCSUMC ;EP - ep toc
 ;SET ARRAY MMR to MMR(prov ien)=denom^numer
 ;DENOM=# VISITS W/REFERRAL
 ;NUMER=# W/TOC DOCUMENT IN 600 MULTIPLE
 ;IF DENOM =0 THEN PROVIDER EXCLUSION
 NEW T,C,PAT,N,APCMX,R,C,G,Z,S,B,E,J,K
 S C=0,N=0,PAT=""
 S T=$O(^APCMMUCN("B","INTERIM STAGE 1 2014",0))
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
 ..S B=0 F  S B=$O(^BMCREF(S,6,B)) Q:B'=+B!(G)  D
 ...S (A,E)=""
 ...I $P(^BMCREF(S,6,B,0),U,4)'="CT" G SUMNUM1
 ...S E=$P($P(^BMCREF(S,6,B,0),U,6),".")
 ...I E="" G SUMNUM1  ;NO DATE TRANSMITTED
 ...I E<D G SUMNUM1  ;BEFORE APPROVAL DATE
 ...I E>APCMEDAT G SUMNUM1  ;AFTER TIME PERIOD
 ...S A=$P($P(^BMCREF(S,6,B,0),U,3),".")  ;tx date
 ...I A,A'<D,A'>APCMEDAT S A=1
 ...S G=1,T="CT" Q  ;got a transmitted go set numerator
SUMNUM1 ...;
 ...I $P(^BMCREF(S,6,B,0),U,4)'="CP" Q
 ...S E=$P($P(^BMCREF(S,6,B,0),U,1),".")  ;DATE/TIME PRINTED
 ...I E="" Q  ;NO DATE SENT/PRINTED
 ...I E<D Q  ;BEFORE APPROVAL DATE
 ...I E>APCMEDAT Q  ;AFTER TIME PERIOD
 ...S G=1,T="CP"
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
MEDREC ;EP
 ;for each provider count each Visit that is a new patient visit and of those # with snomed in v updated/reviewed
 K ^TMP($J,"TRANS")
 NEW APCMLABS,MMR
 D TOTMEDR
 NEW APCMP,N,F
 S (APCMD1,APCMN1)=0
 I APCMRPTT=1 S APCMP=0 F  S APCMP=$O(APCMPRV(APCMP)) Q:APCMP'=+APCMP  D
 .I '$P($G(MMR(APCMP)),U,1) D
 ..S F=$P(^APCM14OB(APCMIC,0),U,11) D S^APCM14E1(APCMRPT,APCMIC,"Provider is excluded from this measure as he/she did not have any transitions during the EHR reporting period.",APCMP,APCMRPTT,APCMTIME,F,1) Q
 .;set denominator value into field
 .S F=$P(^APCM14OB(APCMIC,0),U,8)  ;denom field for this measure
 .S N=$P($G(MMR(APCMP)),U,1)  ;returns # of transS^# with mmr
 .D S^APCM14E1(APCMRPT,APCMIC,N,APCMP,APCMRPTT,APCMTIME,F)
 .;now set patient list for this provider
 .S P=0 F  S P=$O(^TMP($J,"TRANS",APCMP,P)) Q:P'=+P  D
 ..I $P(^TMP($J,"TRANS",APCMP,P),U,1)=$P(^TMP($J,"TRANS",APCMP,P),U,2) S APCMVALU="# transitions: "_$P(^TMP($J,"TRANS",APCMP,P),U,1)_"|||"_" # w/mmr: "_+$P(^TMP($J,"TRANS",APCMP,P),U,2)_" "_$P(^TMP($J,"TRANS",APCMP,P),U,3)_"|||1" D  Q
 ...S DFN=P D SETLIST^APCM14E1 Q
 ..S DFN=P,APCMVALU="# transitions: "_$P(^TMP($J,"TRANS",APCMP,P),U,1)_"|||"_" # w/mmr: "_+$P(^TMP($J,"TRANS",APCMP,P),U,2)_" "_$P(^TMP($J,"TRANS",APCMP,P),U,3)_"|||0" D SETLIST^APCM14E1
 .;numerator?
 .S F=$P(^APCM14OB(APCMIC,0),U,9)
 .S N=$P($G(MMR(APCMP)),U,2)
 .D S^APCM14E1(APCMRPT,APCMIC,N,APCMP,APCMRPTT,APCMTIME,F)
 K ^TMP($J,"TRANS")
 Q
TOTMEDR ;EP - ep MR
 ;SET ARRAY MMR to MMR(prov ien)=denom^numer
 ;IF DENOM =0 THEN PROVIDER EXCLUSION
 NEW T,C,PAT,N,APCMX,R,C,G
 S C=0,N=0,PAT=""
 S T=$O(^APCMMUCN("B","INTERIM STAGE 1 2014",0))
 ;GO THROUGH EACH PATIENT WHO HAS VISITS
 S PAT=0 F  S PAT=$O(^AUPNVSIT("AA",PAT)) Q:PAT'=+PAT  D TOTMEDR1
 Q
TOTMEDR1 ;
 NEW APCMLAB
 S APCMLAB="APCMLAB"
 D ALLV^APCLAPIU(PAT,APCMBDAT,APCMEDAT,APCMLAB)  ;get all visits for this patient in time period
 S APCMX=0 F  S APCMX=$O(APCMLAB(APCMX)) Q:APCMX'=+APCMX  D
 .S V=$P(APCMLAB(APCMX),U,5)  ;VISIT IEN
 .Q:'$D(^AUPNVSIT(V,0))  ;NO VISIT??
 .S R=$$PRIMPROV^APCLV(V,"I")  ;primary provider IEN
 .Q:'R
 .I '$D(APCMPRV(R)) Q
 .Q:"AOSM"'[$P(^AUPNVSIT(V,0),U,7)
 .S C=$$CLINIC^APCLV(V,"C")
 .Q:C=30
 .I C]"",T,$D(^APCMMUCN(T,14,"B",C)) Q  ;don't count these clinics
 .;IS THERE A V CPT OR IMAGE
 .;S G=$$CPT(V)
 .;I G G NUM
 .;S G=$$IMAGE(V,R)
 .;I 'G Q
NUM .;
 .I '$D(MMR(R)) S MMR(R)=""
 .S $P(MMR(R),U,1)=$P(MMR(R),U,1)+1 D
 ..S $P(^TMP($J,"TRANS",R,PAT),U,1)=$P($G(^TMP($J,"TRANS",R,PAT)),U,1)+1
 ..S $P(^TMP($J,"TRANS",R,PAT),U,3)=$P(^TMP($J,"TRANS",R,PAT),U,3)_" "_$$VD^APCLV(V,"S")
 .;now check numerator
 .S G=$$HASMMR(PAT,APCMBDAT,APCMEDAT)
 .I 'G S $P(^TMP($J,"TRANS",R,PAT),U,3)=$P(^TMP($J,"TRANS",R,PAT),U,3)_";NO MMR" Q
 .S $P(MMR(R),U,2)=$P(MMR(R),U,2)+1 D
 ..S $P(^TMP($J,"TRANS",R,PAT),U,2)=$P($G(^TMP($J,"TRANS",R,PAT)),U,2)+1
 ..S $P(^TMP($J,"TRANS",R,PAT),U,3)=$P(^TMP($J,"TRANS",R,PAT),U,3)_";YES MMR"
 Q
 ;
CPT(V) ;was there a 99201-99205 or 99381-99387 on this visit
 NEW X,C,A
 S A=""
 S X=0 F  S X=$O(^AUPNVCPT("AD",V,X)) Q:X'=+X!(A)  D
 .S C=$$GET1^DIQ(9000010.18,X,.01)
 .I C>99200,C<99206 S A=1 Q
 .I C>99380,C<99388 S A=1 Q
 Q A
IMAGE(V,R) ;WAS THERE AN IMAGE BEFORE VISIT DATE AND IF SO WAS THIS THE FIRST VISIT AFTER THE IMAGE DATE
 NEW D,A,B,C,P,X,Y,T,G,Z,VST
 S P=$P(^AUPNVSIT(V,0),U,5)
 I '$D(^MAG(2005,"AC",P)) Q 0
 S G=""
 S D=$$VDTM^APCLV(V)  ;fileman visit date/time
 S B=0 F  S B=$O(^MAG(2005,"AC",P,B)) Q:B'=+B!(G)  D
 .Q:$$UP^XLFSTR($$GET1^DIQ(2005,B,42))'="CCD-SUMMARY"
 .S C=$$GET1^DIQ(2005,B,7,"I")
 .Q:C>D  ;image save after visit date/time
 .;is this the first visit after the image date/time to the EP?
 .S X=C
 .S T=$O(^APCMMUCN("B","INTERIM STAGE 1 2014",0))
 .K VST
 .D ALLV^APCLAPIU(P,$P(C,"."),$$FMADD^XLFDT($P(D,"."),1),"VST")
 .;now reorder by visit/date time
 .S X=0 F  S X=$O(VST(X)) Q:X'=+X  S VST("DTM",$$VDTM^APCLV($P(VST(X),U,5)),X)=$P(VST(X),U,5)
 .S Y=0 F  S Y=$O(VST("DTM",Y)) Q:Y'=+Y!(G)  D
 ..S B=0 F  S B=$O(VST("DTM",Y,B)) Q:B'=+B!(G)  D
 ...S Z=VST("DTM",Y,B)
 ...Q:'$D(^AUPNVSIT(Z,0))
 ...Q:$$PRIMPROV^APCLV(Z,"I")'=R
 ...Q:"AOSM"'[$P(^AUPNVSIT(Z,0),U,7)
 ...S C=$$CLINIC^APCLV(Z,"C")
 ...Q:C=30
 ...I C]"",T,$D(^APCMMUCN(T,14,"B",C)) Q  ;don't count these clinics
 ...Q:Z'=V
 ...S G=1
 Q G
