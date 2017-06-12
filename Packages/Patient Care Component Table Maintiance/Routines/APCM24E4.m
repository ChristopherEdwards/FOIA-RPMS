APCM24E4 ;IHS/CMI/LAB - IHS MU;  ; 30 Jul 2013  8:15 AM
 ;;1.0;IHS MU PERFORMANCE REPORTS;**5,6**;MAR 26, 2012;Build 65
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
 S F=$P(^APCM24OB(APCMIC,0),U,8)  ;denom field for this measure
 D S^APCM24E1(APCMRPT,APCMIC,1,APCMP,APCMRPTT,APCMTIME,F)
 S APCMVALU="VISIT: "_$$DATE^APCM1UTL(APCMHVTP(APCMP))
 ;numerator?
 S APCMEP=$$HASAL(DFN,APCMBDAT,APCMEDAT)
 S APCMVALU=APCMVALU_"|||"_$P(APCMEP,U,2)_"|||"_$P(APCMEP,U,1)
 S F=$P(^APCM24OB(APCMIC,0),U,9)
 D S^APCM24E1(APCMRPT,APCMIC,$P(APCMEP,U,1),APCMP,APCMRPTT,APCMTIME,F)
 D SETLIST^APCM24E1
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
 G EPRES^APCM24EB
VS ;EP - CALCULATE VITAL SIGNS
 ;for each provider or for the facility find out if this
 ;patient had a visit of A, O, R, S to this provider or facility
 ;if so, then check to see if they have vital signs documented anytime before end of report period
 NEW APCMP,APCMFIED,APCMFIEN
 S APCMFIED=$P(^APCM24OB(APCMIC,0),U,8)
 S APCMFIEN=$P(^APCM24OB(APCMIC,0),U,9)
 S APCMBPON=0,APCMNOHW=0
 S (APCMD1,APCMN1)=0
 I APCMRPTT=1 D  Q
 .S APCMP=0 F  S APCMP=$O(APCMPRV(APCMP)) Q:APCMP'=+APCMP  D
 ..;S F=$P(^APCM24OB(APCMIC,0),U,18),APCMNP=$P(^DD(9001303.0311,F,0),U,4),N=$P(APCMNP,";"),P=$P(APCMNP,";",2)
 ..;S APCME=$$V^APCM24ER(1,APCMRPT,N,P,APCMP,"I",APCMRPTT) Q:APCME="X"  ;don't bother as this one is excluded
 ..;D S^APCM24E1(APCMRPT,APCMIC,1,APCMP,APCMRPTT,APCMTIME,F,1)
 ..S APCMFIED=$P(^APCM24OB(APCMIC,0),U,8)
 ..S APCMFIEN=$P(^APCM24OB(APCMIC,0),U,9)
 ..S APCMBPON=0,APCMNOHW=0
 ..I $G(APCMADDQ("ANS",APCMIC,24,APCMP))="Yes" D  Q
 ...;SET EXCLUSION
 ...S F=$P(^APCM24OB(APCMIC,0),U,11) D S^APCM24E1(APCMRPT,APCMIC,"Yes",APCMP,APCMRPTT,APCMTIME,F,1)
 ...;SET SKIP
 ...S F=$P(^APCM24OB(APCMIC,0),U,18)
 ...D S^APCM24E1(APCMRPT,APCMIC,"X",APCMP,APCMRPTT,APCMTIME,F,1)
 ...;set associated measures with skip "X"
 ...S X=0 F  S X=$O(^APCM24OB(APCMIC,29,X)) Q:X'=+X  D
 ....S Y=$P(^APCM24OB(APCMIC,29,X,0),U,1)
 ....S Y=$O(^APCM24OB("B",Y,0))
 ....S F=$P(^APCM24OB(Y,0),U,18)
 ....D S^APCM24E1(APCMRPT,Y,"X",APCMP,APCMRPTT,APCMTIME,F,1)
 ..I $G(APCMADDQ("ANS",APCMIC,25,APCMP))="Yes"!($G(APCMADDQ("ANS",APCMIC,27,APCMP))="Yes") D  G VSC
 ...S Z=$O(^APCM24OB("B","S2.008.EP.2",0)),APCMFIED=$P(^APCM24OB(Z,0),U,8),APCMFIEN=$P(^APCM24OB(Z,0),U,9)
 ...S APCMNOBP=1  ;no BP use S2.008.EP.2
 ...F Z="S2.008.EP.1","S2.008.EP" S Y=$O(^APCM24OB("B",Z,0)) D
 ....S F=$P(^APCM24OB(Y,0),U,18)
 ....D S^APCM24E1(APCMRPT,Y,"X",APCMP,APCMRPTT,APCMTIME,F,1)
 ....I Z="S2.008.EP" Q
 ....S F=$P(^APCM24OB(Y,0),U,11)
 ....D S^APCM24E1(APCMRPT,Y,"Yes",APCMP,APCMRPTT,APCMTIME,F,1)
 ...S Y=$O(^APCM24OB("B","S2.008.EP.2",0))
 ...S F=$P(^APCM24OB(Y,0),U,11)
 ...D S^APCM24E1(APCMRPT,Y,"N/A",APCMP,APCMRPTT,APCMTIME,F,1)
 ..I $G(APCMADDQ("ANS",APCMIC,28,APCMP))="Yes" D  G VSC
 ...S APCMNOHW=1  ;no BP use S2.008.EP.1
 ...S Z=$O(^APCM24OB("B","S2.008.EP.1",0)),APCMFIED=$P(^APCM24OB(Z,0),U,8),APCMFIEN=$P(^APCM24OB(Z,0),U,9)
 ...F Z="S2.008.EP","S2.008.EP.2" S Y=$O(^APCM24OB("B",Z,0)) D
 ....S F=$P(^APCM24OB(Y,0),U,18)
 ....D S^APCM24E1(APCMRPT,APCMIC,"X",APCMP,APCMRPTT,APCMTIME,F,1)
 ....I Z="S2.008.EP" Q
 ....S F=$P(^APCM24OB(Y,0),U,11)
 ....D S^APCM24E1(APCMRPT,Y,"Yes",APCMP,APCMRPTT,APCMTIME,F,1)
 ...S Y=$O(^APCM24OB("B","S2.008.EP.1",0))
 ...S F=$P(^APCM24OB(Y,0),U,11)
 ...D S^APCM24E1(APCMRPT,Y,"N/A",APCMP,APCMRPTT,APCMTIME,F,1)
 ..I $G(APCMADDQ("ANS",APCMIC,24,APCMP))="No" D  G VSC
 ...F Z="S2.008.EP.1","S2.008.EP.2" S Y=$O(^APCM24OB("B",Z,0)) D
 ....S F=$P(^APCM24OB(Y,0),U,18)
 ....D S^APCM24E1(APCMRPT,APCMIC,"X",APCMP,APCMRPTT,APCMTIME,F,1)
VSC ..;
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
 I $$AGE^AUPNPAT(DFN,APCMHVTP(APCMP))<3,$G(APCMADDQ("ANS",APCMIC,28,APCMP))="Yes" Q
 S F=APCMFIED ;$P(^APCM24OB(APCMIC,0),U,8)  ;denom field for this measure
 D S^APCM24E1(APCMRPT,APCMIC,1,APCMP,APCMRPTT,APCMTIME,F)
 S APCMVALU="VISIT: "_$$DATE^APCM1UTL(APCMHVTP(APCMP))
 ;numerator?
 I APCMRPTT=1 S APCMEP=$$HASVSEP(DFN,$$DOB^AUPNPAT(DFN),APCMEDAT,APCMHVTP(APCMP))
 I APCMRPTT=2 S APCMEP=$$HASVS(DFN,$$DOB^AUPNPAT(DFN),APCMEDAT,APCMHVTP(APCMP))
 S APCMVALU=APCMVALU_"|||"_$P(APCMEP,U,2)_"|||"_$P(APCMEP,U,1)
 S F=APCMFIEN ;$P(^APCM24OB(APCMIC,0),U,9)
 D S^APCM24E1(APCMRPT,APCMIC,$P(APCMEP,U,1),APCMP,APCMRPTT,APCMTIME,F)
 D SETLIST^APCM24E1
 Q
HASVS(P,BD,ED,VD) ;does patient have a problem entered before end of report period
 ;
 NEW A,B,C,D,E,HT,WT,BP
 S C=0
 S (HT,WT,BP)=""
 S HT=$$LASTITEM^APCLAPIU(P,"HT","MEASUREMENT",BD,ED)
 S WT=$$LASTITEM^APCLAPIU(P,"WT","MEASUREMENT",BD,ED)
 S BP=$$LASTITEM^APCLAPIU(P,"BP","MEASUREMENT",BD,ED)
 I BP]"" S BP="BP"
 I BP="",$$AGE^AUPNPAT(P,VD)<3 S BP="N/A <3 yrs"
 I HT]"",WT]"",BP]"" Q 1_U_"Has: HT, WT, "_BP
 Q 0_U_"Has: "_$S(HT]"":"HT ",1:"")_$S(WT]"":"WT ",1:"")_$S(BP]"":"BP ",1:"")
HASVSEP(P,BD,ED,VD) ;does patient have a HT/WT/BP entered before end of report period
 ;
 NEW A,B,C,D,E,HT,WT,BP,M
 S M=$O(^APCM24OB("B","S2.008.EP",0))
 S C=0
 S (HT,WT,BP)=""
 S HT=$$LASTITEM^APCLAPIU(P,"HT","MEASUREMENT",BD,ED)
 S WT=$$LASTITEM^APCLAPIU(P,"WT","MEASUREMENT",BD,ED)
 S BP=$$LASTITEM^APCLAPIU(P,"BP","MEASUREMENT",BD,ED)
 I BP]"" S BP="BP"
 I BP="",$$AGE^AUPNPAT(P,VD)<3 S BP="BP not relevant <3"
 I $G(APCMADDQ("ANS",M,24,APCMP))="No",HT]"",WT]"",BP]"" Q 1_U_"Has: HT, WT, "_BP
 I $G(APCMADDQ("ANS",M,25,APCMP))="Yes",HT]"",WT]"" Q 1_U_"Has: HT, WT, BP not relevant"
 I $G(APCMADDQ("ANS",M,27,APCMP))="Yes",HT]"",WT]"" Q 1_U_"Has: HT, WT, BP not relevant"
 I $G(APCMADDQ("ANS",M,28,APCMP))="Yes",BP]"" Q 1_U_"Has: BP, HT&WT not relevant"
 I $G(APCMADDQ("ANS",M,24,APCMP))="Yes",HT]"",WT]"",BP]"" Q 1_U_"Has: HT, WT, BP"
 Q 0_U_"Has: "_$S(HT]"":"HT ",1:"")_$S(WT]"":"WT ",1:"")_$S(BP]"":"BP ",1:"")
 ;
 ;
 ;
ST ;EP - CALCULATE SMOKING STATUS
 ;for each provider or for the facility find out if this
 ;patient had a visit of A, O, R, S to this provider or facility
 ;if so, then check to see if they have SMOKING STATUS documented anytime before end of report period
 NEW APCMP
 S (APCMD1,APCMN1)=0
 I APCMRPTT=1 D  Q
 .S APCMP=0 F  S APCMP=$O(APCMPRV(APCMP)) Q:APCMP'=+APCMP  D
 ..I $D(APCM24ON(APCMP,APCMTIME)) S F=$P(^APCM24OB(APCMIC,0),U,11) D S^APCM24E1(APCMRPT,APCMIC,"Provider is excluded from this measure as he/she did not see anyone over 13 during the EHR reporting period.",APCMP,APCMRPTT,APCMTIME,F,1) Q
 ..Q:$$AGE^AUPNPAT(DFN,APCMBDAT)<13
 ..Q:'$D(APCMHVTP(APCMP))  ;no visits to this provider for this patient so don't bother, the patient is not in the denominator
 ..D ST1
 I APCMRPTT=2 D
 .S APCMP=APCMFAC
 .I $D(APCM24ON(APCMP,APCMTIME)) S F=$P(^APCM24OB(APCMIC,0),U,11) D S^APCM24E1(APCMRPT,APCMIC,"Hospital is excluded from this measure as did not admit anyone over 13 during the EHR reporting period.",APCMP,APCMRPTT,APCMTIME,F,1) Q
 .Q:$$AGE^AUPNPAT(DFN,APCMBDAT)<13
 .Q:'$D(APCMHVTP(APCMP))
 .D ST1
 .Q
 Q
ST1 ;set denominator value into field
 S F=$P(^APCM24OB(APCMIC,0),U,8)  ;denom field for this measure
 D S^APCM24E1(APCMRPT,APCMIC,1,APCMP,APCMRPTT,APCMTIME,F)
 S APCMVALU="VISIT: "_$$DATE^APCM1UTL(APCMHVTP(APCMP))
 ;numerator?
 S APCMEP=$$HASST(DFN,$$DOB^AUPNPAT(DFN),APCMEDAT)
 S APCMVALU=APCMVALU_"|||"_$P(APCMEP,U,2)_"|||"_$P(APCMEP,U,1)
 S F=$P(^APCM24OB(APCMIC,0),U,9)
 D S^APCM24E1(APCMRPT,APCMIC,$P(APCMEP,U,1),APCMP,APCMRPTT,APCMTIME,F)
 D SETLIST^APCM24E1
 Q
HASST(P,BD,ED) ;does patient have a SMOKING STATUS
 ;
 NEW A,B,C,D,E,HF
 S C=0
 S HF=""
 ;S HF=$$LASTHF^APCLAPIU(P,"TOBACCO (SMOKING)",,ED,"A")
 F A="F002","F004","F108","F109","F110","F111","F121","F122" S B=$$LASTITEM^APCLAPIU(P,A,"HEALTH",,ED,"A") I B]"" S D($P(B,U,1))=$P(B,U,2)
 ;ZW D
 I '$D(D) Q 0
 S HF=$O(D(999999999),-1) Q 1_U_$$DATE^APCM1UTL(HF)_" "_$P(D(HF),U,1)
 Q 0
CS ;EP - CLINICAL SUMMARIES ON EACH VISIT
 NEW APCMP
 S (APCMD1,APCMN1)=0
 I APCMRPTT=1 S APCMP=0 F  S APCMP=$O(APCMPRV(APCMP)) Q:APCMP'=+APCMP  D
 .I $D(APCMOFFV(APCMP,APCMTIME)) S F=$P(^APCM24OB(APCMIC,0),U,11) D
 ..D S^APCM24E1(APCMRPT,APCMIC,"Provider is excluded from this measure as he/she did not have any office visits during the EHR Reporting Period.",APCMP,APCMRPTT,APCMTIME,F,1) Q
 .Q:'$D(APCMHVTP(APCMP))  ;no visits to this provider for this patient so don't bother, the patient is not in the denominator
 .;set denominator value into field
 .S APCMEP=$$HASCS(DFN,APCMP,APCMBDAT,APCMEDAT,.APCMVSTS)  ;RETURNS # OF VISIT^# THAT HAD CS GIVEN W/IN 3 BUS DAYS
 .S F=$P(^APCM24OB(APCMIC,0),U,8)  ;denom field for this measure
 .D S^APCM24E1(APCMRPT,APCMIC,$P(APCMEP,U),APCMP,APCMRPTT,APCMTIME,F)
 .;S APCMVALU="VISIT: "_$$DATE^APCM1UTL(APCMHVTP(APCMP))
 .I $P(APCMEP,U,1) S APCMVALU="# visits: "_$P(APCMEP,U,1)_" - # w/CS: "_$P(APCMEP,U,2)_"|||"_$P(APCMEP,U,3)_"|||"_$S('(+$P(APCMEP,U,1)):0,$P(APCMEP,U,1)=$P(APCMEP,U,2):1,1:0)
 .;numerator?
 .S F=$P(^APCM24OB(APCMIC,0),U,9)
 .D S^APCM24E1(APCMRPT,APCMIC,$P(APCMEP,U,2),APCMP,APCMRPTT,APCMTIME,F)
 .I APCMVALU]"" D SETLIST^APCM24E1
 Q
HASCS(P,R,BD,ED,VSTS) ;does patient have a SMOKING STATUS
 ;
 NEW A,B,C,D,E,X,Y,V,PWH,J,EDUC
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
 .S $P(PWH,U,1)=$P(PWH,U,1)+1
 .;is there a yes in phr access field on or before visit date?
 .S A=0,B="" F  S A=$O(^AUPNPAT(P,88,A)) Q:A'=+A!(A>$$VD^APCLV(V))  S B=A
 .I B]"",$P(^AUPNPAT(P,88,B,0),U,2) D  Q  ;meets numerator as had phr access on visit date
 ..S $P(PWH,U,2)=$P(PWH,U,2)+1
 ..S $P(PWH,U,3)=$P(PWH,U,3)_$S($P(PWH,U,3)]"":";",1:"")_"VD: "_$$DATE^APCM1UTL($$VD^APCLV(V))_"-"_"PHR ACCESS YES on "_$$DATE^APCM1UTL(B)
 .S E=$$BD($$VD^APCLV(V),1)
 .;GET DATES OF PRINT AND MAKE SURE 1 IS ON OR BEFORE VALUE IN E
 .S A=0,G=0 F  S A=$O(^APCCDPL(V,1,"B",A)) Q:A'=+A!(G)  D
 ..S B=0 F  S B=$O(^APCCDPL(V,1,"B",A,B)) Q:B'=+B!(G)  D
 ...I $P(A,".")>E Q  ;greater than 1 business days
 ...I $P(A,".")<$$VD^APCLV(V)  ;before visit date??
 ...Q:$P(^APCCDPL(V,1,B,0),U,4)'=1  ;CLINICAL SUMMARY ONLY
 ...;Q:$P(^APCCDPL(V,1,B,0),U,2)'="P"  ;printed only
 ...S G=1
 ...S $P(PWH,U,2)=$P(PWH,U,2)+1
 ...S $P(PWH,U,3)=$P(PWH,U,3)_$S($P(PWH,U,3)]"":";",1:"")_"VD: "_$$DATE^APCM1UTL($$VD^APCLV(V))_"-"_"Document printed on "_$$DATE^APCM1UTL($P(A,"."))
 .Q:G
 .;IF NONE OF THESE CHECK FOR REFUSAL ON VISIT DATE
 .S A=0,G="" F  S A=$O(^AUPNPREF("AC",P,A)) Q:A'=+A!(G)  D
 ..Q:$$GET1^DIQ(9000022,A,.01)'="SNOMED"
 ..Q:$$GET1^DIQ(9000022,A,.03,"I")'=$$VD^APCLV(V)  ;must be refused on visit date
 ..Q:$$GET1^DIQ(9000022,A,1301,"I")'=422735006
 ..S G=1
 .I G D
 ..S $P(PWH,U,2)=$P(PWH,U,2)+1
 ..S $P(PWH,U,3)=$P(PWH,U,3)_$S($P(PWH,U,3)]"":";",1:"")_"VD: "_$$DATE^APCM1UTL($$VD^APCLV(V))_"-"_"Declined CS on "_$$DATE^APCM1UTL($$VD^APCLV(V))
 Q PWH
BD(D,N) ;EP n business days from this date
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
