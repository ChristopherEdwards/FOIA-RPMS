APCM2AEB ;IHS/CMI/LAB - IHS MU;  ; 30 Jul 2013  8:15 AM
 ;;1.0;MU PERFORMANCE REPORTS;**7**;MAR 26, 2012;Build 15
EPRES ;EP - CALCULATE EPRESCRIBING
 ;for each provider or for the facility count all prescriptions that meet criteria and if it is not written it meets numerator
 K ^TMP($J,"PATSRX")
 K APCMRXS
 D TOTRX
 NEW APCMP,N,F
 S (APCMD1,APCMN1)=0
 I APCMRPTT=1 S APCMP=0 F  S APCMP=$O(APCMPRV(APCMP)) Q:APCMP'=+APCMP  D
 .I $D(APCM100R(APCMP,APCMTIME)) S F=$P(^APCM25OB(APCMIC,0),U,11) D  G D
 ..D S^APCM2AE1(APCMRPT,APCMIC,"Provider is excluded from this measure as he/she had < 100 prescriptions issued during the EHR reporting period.",APCMP,APCMRPTT,APCMTIME,F,1)
 .I $G(APCMADDQ("ANS",APCMIC,24,APCMP))="No",$G(APCMADDQ("ANS",APCMIC,25,APCMP))="No" S F=$P(^APCM25OB(APCMIC,0),U,11) D
 ..D S^APCM2AE1(APCMRPT,APCMIC,"Provider may be eligible for an exclusion on this measure as they not have an onsite pharmacy and do not have a pharmacy within 10 miles accepting electronic prescriptions.",APCMP,APCMRPTT,APCMTIME,F,1)
D .;set denominator value into field
 .S F=$P(^APCM25OB(APCMIC,0),U,8)  ;denom field for this measure
 .S N=$P($G(APCMRXS(APCMP)),U,1)  ;returns # of prescriptions^# not written by nature of order
 .D S^APCM2AE1(APCMRPT,APCMIC,N,APCMP,APCMRPTT,APCMTIME,F)
 .;now set patient list for this provider
 .S P=0 F  S P=$O(^TMP($J,"PATSRX",APCMP,P)) Q:P'=+P  D
 ..;Q:'$P(^TMP($J,"PATSRX",APCMP,P),U,1)
 ..I $P(^TMP($J,"PATSRX",APCMP,P),U,1)=$P(^TMP($J,"PATSRX",APCMP,P),U,2) S APCMVALU="# Prescriptions: "_$P(^TMP($J,"PATSRX",APCMP,P),U,1)_"|||"_" # transmitted electronically: "_+$P(^TMP($J,"PATSRX",APCMP,P),U,2)_"|||1" D  Q
 ...S DFN=P D SETLIST^APCM2AE1 Q
 ..S S="",APCMVALU="Not transmitted electronically: "
 ..F  S S=$O(^TMP($J,"PATSRX",APCMP,P,"SCRIPTS",S)) Q:S=""  D
 ...I '$D(^TMP($J,"PATSRX",APCMP,P,"ELEC",S)) D
 ....S APCMVALU=APCMVALU_S_";"
 ..S DFN=P,APCMVALU="# of Prescriptions: "_$P(^TMP($J,"PATSRX",APCMP,P),U,1)_" # transmitted electronically: "_+$P(^TMP($J,"PATSRX",APCMP,P),U,2)_"|||"_APCMVALU,$P(APCMVALU,"|||",3)=0 D SETLIST^APCM2AE1
 .;numerator?
 .S F=$P(^APCM25OB(APCMIC,0),U,9)
 .S N=$P($G(APCMRXS(APCMP)),U,2)
 .D S^APCM2AE1(APCMRPT,APCMIC,N,APCMP,APCMRPTT,APCMTIME,F)
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
 ..Q:$$GET1^DIQ(52,X,9999999.28)="YES"  ;MUST NOT BE A DISCHARGE MED
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
 ....I $P(^PSRX(X,"A",A,0),U,5)["eRx" S B=1
 ...S $P(APCMRXS(R),U,2)=$P(APCMRXS(R),U,2)+B,$P(^TMP($J,"PATSRX",R,PAT),U,2)=$P($G(^TMP($J,"PATSRX",R,PAT)),U,2)+B I B S ^TMP($J,"PATSRX",R,PAT,"ELEC",$P(^PSRX(X,0),U,1))=""
 Q
ALLLAB(P,BD,ED,T,LT,LN,A) ;EP
 ;P - patient
 ;BD - beginning date
 ;ED - ending date
 ;T - lab taxonomy
 ;LT - loinc taxonomy
 ;LN - lab test name
 ;return all lab tests that match in array A
 ;FORMAT:  DATE^TEST NAME^RESULT^V LAB IEN^VISIT IEN
 I '$G(LT) S LT=""
 S LN=$G(LN)
 S T=$G(T)
 NEW D,V,G,X,J,B,E,C
 S B=9999999-BD,C=0,E=9999999-ED  ;get inverse date and begin at edate-1 and end when greater than begin date
 S D=E-1,D=D_".9999" S G=0 F  S D=$O(^AUPNVLAB("AE",P,D)) Q:D'=+D!($P(D,".")>B)  D
 .S X=0 F  S X=$O(^AUPNVLAB("AE",P,D,X)) Q:X'=+X  D
 ..S Y=0 F  S Y=$O(^AUPNVLAB("AE",P,D,X,Y)) Q:Y'=+Y  D
 ...I 'T,'LT,LN="" D SETLAB Q
 ...I T,$D(^ATXLAB(T,21,"B",X)) D SETLAB Q
 ...I LN]"",$$VAL^XBDIQ1(9000010.09,Y,.01)=LN D SETLAB Q
 ...Q:'LT
 ...S J=$P($G(^AUPNVLAB(Y,11)),U,13) Q:J=""
 ...Q:'$$LOINC(J,LT)
 ...D SETLAB Q
 ...Q
 ..Q
 .Q
 Q
SETLAB ;
 S C=C+1
 S @A@(C)=(9999999-$P(D,"."))_"^"_$$VAL^XBDIQ1(9000010.09,Y,.01)_"^"_$$VAL^XBDIQ1(9000010.09,Y,.04)_"^"_Y_"^"_$P(^AUPNVLAB(Y,0),U,3)
 Q
LOINC(A,LT,LI) ;
 I '$G(LT),'$G(LI) Q ""  ;no ien or taxonomy
 S LI=$G(LI)
 I A,LI,A=LI Q 1
 NEW %
 S %=$P($G(^LAB(95.3,A,9999999)),U,2)
 I %]"",LT,$D(^ATXAX(LT,21,"B",%)) Q 1
 S %=$P($G(^LAB(95.3,A,0)),U)_"-"_$P($G(^LAB(95.3,A,0)),U,15)
 I $D(^ATXAX(LT,21,"B",%)) Q 1
 Q ""
LTAP ;EP - CALCULATE LTAP
 K ^TMP($J,"PATSLAB")
 K APCMLABS
 D LTAP1
 NEW APCMP,N,F
 S (APCMD1,APCMN1)=0
 S APCMP=APCMFAC
 S F=$P(^APCM25OB(APCMIC,0),U,8)  ;denom field for this measure
 S N=$P($G(APCMLABS(APCMFAC)),U,1)  ;returns # of lab orders^# not written by nature of order
 D S^APCM2AE1(APCMRPT,APCMIC,N,APCMFAC,APCMRPTT,APCMTIME,F)
 ;now set patient list for this FACILITY
 S P=0 F  S P=$O(^TMP($J,"PATSLAB",APCMFAC,P)) Q:P'=+P  D
 .S D=$P(^TMP($J,"PATSLAB",APCMFAC,P),U,1),N=$P(^TMP($J,"PATSLAB",APCMFAC,P),U,2) S APCMVALU="# Orders: "_D_"|||"_"# RESULTED: "_N_" # NOT RESULTED: "_(D-N)
 .S DFN=P D SETLIST^APCM2AE1
 ;numerator?
 S F=$P(^APCM25OB(APCMIC,0),U,9)
 S N=$P($G(APCMLABS(APCMFAC)),U,2)
 D S^APCM2AE1(APCMRPT,APCMIC,N,APCMFAC,APCMRPTT,APCMTIME,F)
 K ^TMP($J,"PATSLAB"),^TMP($J,"ORDERSPROCESSED")
 Q
LTAP1 ;EP - 
 ;between BD and ED
 ;SET ARRAY APCMLABS to APCMLABS(prov ien)=denom^numer
 K ^TMP($J,"PATSLAB")
 NEW ID,C,Y,X,D,S,N,A,B,R,PAT,G,SPECNO,ORPFILE,ORPTST,ORNS,PATLOC,ORACT0,ORORD,ORDEB,LRPAT
 S ID=$$FMADD^XLFDT(APCMBDAT,-1),ID=ID_".9999"
 F  S ID=$O(^LRO(69,ID)) Q:ID'=+ID!($P(ID,".")>APCMEDAT)  D
 .;GET FIRST SPECIMEN IN MULTIPLE
 .S SPECNO=0 F  S SPECNO=$O(^LRO(69,ID,1,SPECNO)) Q:SPECNO'=+SPECNO  D
 ..;S ^TMP($J,"ORDERSPROCESSED",SPECNO)=""
 ..S LRPAT=+$P($G(^LRO(69,ID,1,SPECNO,0)),U,1) ;GET Patient lRDFN
 ..;GET DFN
 ..S A=$P($G(^LR(LRPAT,0)),U,2) Q:A'=2
 ..S PAT=$P($G(^LR(LRPAT,0)),U,3)
 ..Q:$$DEMO^APCLUTL(PAT,APCMDEMO)  ;Quit if demo patient
 ..S PATLOC=+$P($G(^LRO(69,ID,1,SPECNO,0)),U,9) ;FILE 44 IEN
 ..S C="" I PATLOC,$D(^SC(PATLOC,0)) S C=$P(^SC(PATLOC,0),U,7) I C Q:$P($G(^DIC(40.7,C,0)),U,2)=30  ;IF ER LOC Q
 ..;quit if there is a ward on the file 44 entry
 ..Q:$P($G(^SC(PATLOC,42)),U,1)  ;HAS A WARD POINTER
 ..;SET DENOM COUNT
 ..S $P(APCMLABS(APCMFAC),U,1)=$P($G(APCMLABS(APCMFAC)),U,1)+1,$P(^TMP($J,"PATSLAB",APCMFAC,PAT),U,1)=$P($G(^TMP($J,"PATSLAB",APCMFAC,PAT)),U,1)+1
 ..;
 ..;now check to see if it has a RESULT, IF NOT, quit and don't set numerator
 ..;USE FIRST TEST ONLY
 ..S A=0 S A=$O(^LRO(69,ID,1,SPECNO,2,A)) Q:'A  D
 ...S T=A  ;$P(^LRO(69,ID,1,SPECNO,2,A,0),U,1) ;TEST IEN
 ...S B=$$RESULT(ID,SPECNO,T)
 ...Q:$P(B,U)="-1"
 ...S $P(APCMLABS(APCMFAC),U,2)=$P(APCMLABS(APCMFAC),U,2)+1,$P(^TMP($J,"PATSLAB",APCMFAC,PAT),U,2)=$P($G(^TMP($J,"PATSLAB",APCMFAC,PAT)),U,2)+1
 Q
 ;
 ; ^LRO(69,LRODT,1,LRSP,2,LRAT)
 ;      LRODT = DATE ORDERED
 ;      LRSP = SPECIMEN #
 ;      LRAT = TEST
RESULT(LRODT,LRSP,LRAT) ; EP - Return the RESULT of a "CH" subscripted test given Order data
 ;NEW (DILOCKTM,DISYS,DT,DTIME,DUZ,IEN,IO,IOBS,IOF,IOM,ION,IOS,IOSL,IOST,IOT,IOXY,LRODT,LRSP,LRAT,U,XPARSYS,XQXFLG)
 NEW LROIENS,LRAA,LRAD,LRAN,F6OPTR,F6ODN,LRAIENS,LRDFN,LRIDT,RESULT
 ;
 S LROIENS=LRAT_","_LRSP_","_LRODT
 S LRAA=$$GET1^DIQ(69.03,LROIENS,"ACCESSION AREA","I")
 S LRAD=$$GET1^DIQ(69.03,LROIENS,"ACCESSION DATE","I")
 S LRAN=$$GET1^DIQ(69.03,LROIENS,"ACCESSION NUMBER","I")
 ;
 S F60PTR=$$GET1^DIQ(69.03,LROIENS,"TEST/PROCEDURE","I")
 S F60DN=$$GET1^DIQ(60,F60PTR,"DATA NAME","I")
 ;
 S LRAIENS=LRAN_","_LRAD_","_LRAA
 S LRDFN=$$GET1^DIQ(68.02,LRAIENS,"LRDFN","I")
 S LRIDT=$$GET1^DIQ(68.02,LRAIENS,"INVERSE DATE","I")
 ;
 S RESULT=$$GET1^DIQ(63.04,LRIDT_","_LRDFN,F60DN)
 Q $S($L(RESULT):RESULT,1:"-1^MISSING RESULT")
