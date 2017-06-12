APCM25E0 ;IHS/CMI/LAB - IHS MU; 
 ;;1.0;MU PERFORMANCE REPORTS;**8**;MAR 26, 2012;Build 22
 ;;;;;;Build 3
SC ;EP - TRANSITION OF CARE SUMMARY
 ;new logic for patch 8, keep old logic in case need to revert based on testing
 ;for each provider count each referral entry in ^BMCREF
 K ^TMP($J,"TRANS")
 NEW APCMLABS,MMR
 D TOCSUMC
 NEW APCMP,N,F,O,Y
 S (APCMD1,APCMN1)=0
 I APCMRPTT=1 S APCMP=0 F  S APCMP=$O(APCMPRV(APCMP)) Q:APCMP'=+APCMP  D
 .I $P($G(MMR(APCMP)),U,1)<100 D
 ..S F=$P(^APCM25OB(APCMIC,0),U,11) D S^APCM25E1(APCMRPT,APCMIC,"Provider is excluded from this measure as he/she had less than 1 referrals during the EHR reporting period.",APCMP,APCMRPTT,APCMTIME,F,1)
 .S F=$P(^APCM25OB(APCMIC,0),U,8)  ;denom field for this measure
 .S N=$P($G(MMR(APCMP)),U,1)  ;returns # of transS^# with mmr
 .D S^APCM25E1(APCMRPT,APCMIC,N,APCMP,APCMRPTT,APCMTIME,F)
 .;now set patient list for this provider
 .S P=0 F  S P=$O(^TMP($J,"TRANS",APCMP,P)) Q:P'=+P  D
 ..I $P(^TMP($J,"TRANS",APCMP,P),U,1)=$P(^TMP($J,"TRANS",APCMP,P),U,2) S APCMVALU="# referrals: "_$P(^TMP($J,"TRANS",APCMP,P),U,1)_"|||"_" # w/TOCS: "_+$P(^TMP($J,"TRANS",APCMP,P),U,2)_" "_$P(^TMP($J,"TRANS",APCMP,P),U,3)_"|||1" D  Q
 ...S DFN=P D SETLIST^APCM25E1 Q
 ..S DFN=P,APCMVALU="# referrals: "_$P(^TMP($J,"TRANS",APCMP,P),U,1)_"|||"_" # w/TOCS: "_+$P(^TMP($J,"TRANS",APCMP,P),U,2)_" "_$P(^TMP($J,"TRANS",APCMP,P),U,3)_"|||0" D SETLIST^APCM25E1
 .S Y=APCMIC
 .S F=$P(^APCM25OB(Y,0),U,9)
 .S N=$P($G(MMR(APCMP)),U,2)
 .D S^APCM25E1(APCMRPT,APCMIC,N,APCMP,APCMRPTT,APCMTIME,F)
 I APCMRPTT=2 S APCMP=APCMFAC  D
 .;I '$P($G(MMR(APCMP)),U,1) D  Q
 .;.S F=$P(^APCM25OB(APCMIC,0),U,11) D S^APCM25E1(APCMRPT,APCMIC,"Facility is excluded from this measure as there were no referrals during the EHR reporting period.",APCMP,APCMRPTT,APCMTIME,F,1)
 .;set denominator value into field FOR measure 1
 .S F=$P(^APCM25OB(APCMIC,0),U,8)  ;denom field for this measure
 .S N=$P($G(MMR(APCMP)),U,1)  ;returns # of transS^# with mmr
 .D S^APCM25E1(APCMRPT,APCMIC,N,APCMP,APCMRPTT,APCMTIME,F)
 .;now set patient list for this provider
 .S P=0 F  S P=$O(^TMP($J,"TRANS",APCMP,P)) Q:P'=+P  D
 ..I $P(^TMP($J,"TRANS",APCMP,P),U,1)=$P(^TMP($J,"TRANS",APCMP,P),U,2) S APCMVALU="# referrals: "_$P(^TMP($J,"TRANS",APCMP,P),U,1)_"|||"_" # w/TOCS: "_+$P(^TMP($J,"TRANS",APCMP,P),U,2)_" "_$P(^TMP($J,"TRANS",APCMP,P),U,3)_"|||1" D  Q
 ...S DFN=P D SETLIST^APCM25E1 Q
 ..S DFN=P,APCMVALU="# referrals: "_$P(^TMP($J,"TRANS",APCMP,P),U,1)_"|||"_" # w/TOCS: "_+$P(^TMP($J,"TRANS",APCMP,P),U,2)_" "_$P(^TMP($J,"TRANS",APCMP,P),U,3)_"|||0" D SETLIST^APCM25E1
 .;numerator?
 .;NOW SET VALUES FOR NUMERATOR
 .S Y=APCMIC
 .;S F=$P(^APCM25OB(Y,0),U,8) D S^APCM25E1(APCMRPT,Y,$P($G(MMR(APCMP)),U,1),APCMP,APCMRPTT,APCMTIME,F)
 .S F=$P(^APCM25OB(Y,0),U,9)
 .S N=$P($G(MMR(APCMP)),U,2)
 .D S^APCM25E1(APCMRPT,APCMIC,N,APCMP,APCMRPTT,APCMTIME,F)
 K ^TMP($J,"TRANS")
 Q
TOCSUMC ;EP - ep toc
 ;SET ARRAY MMR to MMR(prov ien)=denom^numer
 ;DENOM=# VISITS W/REFERRAL
 ;NUMER=# W/TOC DOCUMENT IN 600 MULTIPLE
 ;IF DENOM =0 THEN PROVIDER EXCLUSION
 NEW T,C,PAT,N,APCMX,R,C,G,Z,S,B,E,J,K,APCMED,APCMBD
 S C=0,N=0,PAT=""
 S T=$O(^APCMMUCN("B","MODIFIED STAGE 2 2015",0))
 S APCMBD=$$FMADD^XLFDT(APCMBDAT,-1)
 S APCMED=APCMEDAT
 ;loop all referrals initiated in the time period
 F  S APCMBD=$O(^BMCREF("B",APCMBD)) Q:APCMBD'=+APCMBD!(APCMBD>APCMED)  D
 .S APCMX=0 F  S APCMX=$O(^BMCREF("B",APCMBD,APCMX)) Q:APCMX'=+APCMX  D
 ..;check .06 to make sure it is provider we are running the report for in APCMPRV array
 ..S R=$$VALI^XBDIQ1(90001,APCMX,.06)
 ..I APCMRPTT=1 I 'R Q  ;IN EP AND NO PROVIDER
 ..I APCMRPTT=1 I '$D(APCMPRV(R)) Q  ;IN EP AND NOT CORRECT PROVIDER
 ..I APCMRPTT=2 Q:$$VALI^XBDIQ1(90001,APCMX,.05)'=APCMFAC
 ..Q:$P(^BMCREF(APCMX,0),U,4)="N"  ;NO INHOUSE
 ..S D=$P($G(^BMCREF(APCMX,13)),U,5)  ;approval date
 ..Q:D=""  ;NO APPROVAL DATE
 ..Q:D>APCMEDAT  ;AFTER TP APPROVAL DATE MUST BE IN TIME PERIOD
 ..Q:D<APCMBDAT  ;BEFORE TP
 ..Q:$$VAL^XBDIQ1(90001,APCMX,.13)="DIAGNOSTIC IMAGING"
 ..Q:$$VAL^XBDIQ1(90001,APCMX,.13)="PATHOLOGY AND LABORATORY"
 ..Q:$$VAL^XBDIQ1(90001,APCMX,.13)="TRANSPORTATION"
 ..Q:$$VAL^XBDIQ1(90001,APCMX,.13)="DURABLE MEDICAL EQUIPMENT"
 ..;get visit and exclude clinic 30 and H for EP report
 ..;do hoser for inpatient
 ..S V=$$VALI^XBDIQ1(90001,APCMX,1303)  ;V REF IEN
 ..I 'V Q  ;NO V REFERRAL???
 ..S V=$$VALI^XBDIQ1(9000010.59,V,.03)
 ..I 'V Q  ;;WHY WOULD THERE BE NO VISIT??
 ..Q:'$D(^AUPNVSIT(V,0))  ;NO VISIT??
 ..I APCMRPTT=2,APCMMETH="E" Q:'$$HOSER^APCM25E6(V,APCMFAC)  S R=APCMFAC G TOCS2
 ..I APCMRPTT=2,APCMMETH="O" Q:"OH"'[$P(^AUPNVSIT(V,0),U,7)  Q:$P(^AUPNVSIT(V,0),U,6)'=APCMFAC  S R=APCMFAC G TOCS2
 ..I APCMRPTT=2 Q
 ..Q:$P(^AUPNVSIT(V,0),U,7)="H"  ;Q:$P(^AUPNVSIT(V,0),U,7)="O"
 ..S C=$$CLINIC^APCLV(V,"C")
 ..Q:C=30
TOCS2 ..;
 ..S PAT=$$VALI^XBDIQ1(90001,APCMX,.03)
SUMNUM ..;
 ..I '$D(MMR(R)) S MMR(R)=""
 ..S $P(MMR(R),U,1)=$P(MMR(R),U,1)+1 D
 ...S $P(^TMP($J,"TRANS",R,PAT),U,1)=$P($G(^TMP($J,"TRANS",R,PAT)),U,1)+1
 ...S $P(^TMP($J,"TRANS",R,PAT),U,3)=$P(^TMP($J,"TRANS",R,PAT),U,3)_" "_$$VAL^XBDIQ1(90001,APCMX,.01)_"-"_$P(^BMCREF(APCMX,0),U,2)
 ..;now check numerator, FIELD 600
 ..S G=0,T=0
 ..;FIRST LOOK FOR A TX AND ACKNOWLEDGED IF FOUND, USE IT
 ..;NEXT LOOK FOR A TX, IF FOUND, USE IT
 ..S B=0 F  S B=$O(^BMCREF(APCMX,6,B)) Q:B'=+B!(G)  D
 ...S (A,E)=""
 ...I $P(^BMCREF(APCMX,6,B,0),U,4)'="CT" Q
 ...S E=$P($P(^BMCREF(APCMX,6,B,0),U,1),".")
 ...I E="" Q  ;NO .01
 ...S M=$$CD(E,APCMBD)
 ...I 'M Q  ;NOT IN REPORTING YEAR
 ...;I 'M S E=$P($P(^BMCREF(APCMX,6,B,0),U,1),".") S M=$$CD(E) Q:'M  ;dates aren't good
 ...S A=$P($P(^BMCREF(APCMX,6,B,0),U,3),".")  ;tx acknowledged
 ...I A,$$CD(A,APCMBD) D SN S G=1
 Q
SN ;
 S $P(MMR(R),U,2)=$P(MMR(R),U,2)+1 D  Q
 .S $P(^TMP($J,"TRANS",R,PAT),U,2)=$P($G(^TMP($J,"TRANS",R,PAT)),U,2)+1
 .S $P(^TMP($J,"TRANS",R,PAT),U,3)=$P(^TMP($J,"TRANS",R,PAT),U,3)_";YES TX AND ACK"
 .;S $P(MMR(R),U,5)=$P(MMR(R),U,5)+1
 Q
CD(E,BD) ;
 I E="" Q 0  ;NO DATE TRANSMITTED
 NEW %
 S %=$E(BD,1,3)_"0101"
 I $P(E,".")<% Q 0
 Q 1
