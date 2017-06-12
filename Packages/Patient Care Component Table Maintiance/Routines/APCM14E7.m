APCM14E7 ;IHS/CMI/LAB - IHS MU; 
 ;;1.0;IHS MU PERFORMANCE REPORTS;**5,6**;MAR 26, 2012;Build 65
 ;
LAB ;EP - CALCULATE LAB
 ;for each provider or for the facility count all labs that meet criteria and if it is not written it meets numerator
 K ^TMP($J,"PATSRX")
 K APCMLABS
 D TOTLAB
 NEW APCMP,N,F
 S (APCMD1,APCMN1)=0
 I APCMRPTT=2 S APCMP=APCMFAC  D
 .;I '$P($G(APCMLABS(APCMP)),U,1) S F=$P(^APCM14OB(APCMIC,0),U,11) D S^APCM14E1(APCMRPT,APCMIC,"Provider is excluded from this measure as he/she did not order any lab tests with results during the time period.",APCMP,APCMRPTT,APCMTIME,F,1) Q
 .;set denominator value into field
 .S F=$P(^APCM14OB(APCMIC,0),U,8)  ;denom field for this measure
 .S N=$P($G(APCMLABS(APCMP)),U,1)  ;returns # of LABS^# not Structured data
 .D S^APCM14E1(APCMRPT,APCMIC,+N,APCMP,APCMRPTT,APCMTIME,F)
 .;now set patient list for this provider
 .S P=0 F  S P=$O(^TMP($J,"PATSRX",APCMP,P)) Q:P'=+P  D
 ..;Q:'$P(^TMP($J,"PATSRX",APCMP,P),U,1)
 ..I $P(^TMP($J,"PATSRX",APCMP,P),U,1)=$P(^TMP($J,"PATSRX",APCMP,P),U,2) S APCMVALU="# Labs: "_$P(^TMP($J,"PATSRX",APCMP,P),U,1)_"|||"_" # w/structured result: "_+$P(^TMP($J,"PATSRX",APCMP,P),U,2)_"|||1" D  Q
 ...S DFN=P D SETLIST^APCM14E1 Q
 ..S S="",APCMVALU="No Structured Result: "
 ..F  S S=$O(^TMP($J,"PATSRX",APCMP,P,"SCRIPTS",S)) Q:S=""  D
 ...I '$D(^TMP($J,"PATSRX",APCMP,P,"ELEC",S)) D
 ....S APCMVALU=APCMVALU_S_";"
 ..S DFN=P,APCMVALU="# of Labs: "_$P(^TMP($J,"PATSRX",APCMP,P),U,1)_" # w/structured results: "_+$P(^TMP($J,"PATSRX",APCMP,P),U,2)_"|||"_APCMVALU,$P(APCMVALU,"|||",3)=0 D SETLIST^APCM14E1
 .;numerator?
 .S F=$P(^APCM14OB(APCMIC,0),U,9)
 .S N=$P($G(APCMLABS(APCMP)),U,2)
 .D S^APCM14E1(APCMRPT,APCMIC,+N,APCMP,APCMRPTT,APCMTIME,F)
 K ^TMP($J,"PATSRX")
 Q
TOTLAB ;EP - ep LAB
 ;SET ARRAY APCMLABS to APCMLABS(prov ien)=denom^numer
 ;IF DENOM =0 THEN PROVIDER EXCLUSION
 NEW ID,C,Y,X,D,S,N,A,B,R,PAT,ED,APCMLAB,APCMX,APCML,PAR
 S ED=9999999-APCMBDAT,ED=ED_".9999"
 S SD=9999999-APCMEDAT
 S C=0,N=0,PAT=""
 S LABSNO=""
 S T=$O(^ATXLAB("B","BGP PAP SMEAR TAX",0))
 S PAT="" F  S PAT=$O(^AUPNVSIT("AA",PAT)) Q:PAT'=+PAT  D TOTLAB1
 Q
TOTLAB1 ;
 NEW APCMLAB,APCMLAB1
 S APCMLAB="APCMLAB"
 D ALLLAB^APCM24EB(PAT,APCMBDAT,APCMEDAT,,,,.APCMLAB)
 ;reorder by IEN of v lab
 K APCMLAB1
 S APCMX=0 F  S APCMX=$O(APCMLAB(APCMX)) Q:APCMX'=+APCMX  D
 .S V=$P(APCMLAB(APCMX),U,5)  ;VISIT IEN
 .S Y=$P(APCMLAB(APCMX),U,4)  ;V LAB IEN
 .Q:'$D(^AUPNVSIT(V,0))  ;NO VISIT??
 .Q:$P(^AUPNVSIT(V,0),U,6)'=APCMFAC
 .I APCMMETH="E" I '$$HOSER^APCM14E6(V,APCMFAC),$P(^AUPNVSIT(V,0),U,7)'="I" Q  ;not a H or 30 or I
 .I APCMMETH="O" Q:"IOH"'[$P(^AUPNVSIT(V,0),U,7)
 .S A=$P(^AUPNVLAB(Y,0),U,1)  ;test pointer
 .I T,$D(^ATXLAB(T,21,"B",A)) Q   ;it's a pap smear
 .I $$UP^XLFSTR($$VAL^XBDIQ1(9000010.09,Y,.01))="PAP SMEAR" Q  ;it's a pap smear
 .I $$UP^XLFSTR($P(^AUPNVLAB(Y,0),U,4))="CANC" Q
 .I $O(^LAB(60,A,2,0)) Q  ;this is the v lab for the panel
 .I '$D(APCMLABS(APCMFAC)) S APCMLABS(APCMFAC)=""
 .S $P(APCMLABS(APCMFAC),U,1)=$P(APCMLABS(APCMFAC),U,1)+1 D
 ..S $P(^TMP($J,"PATSRX",APCMFAC,PAT),U,1)=$P($G(^TMP($J,"PATSRX",APCMFAC,PAT)),U,1)+1,^TMP($J,"PATSRX",APCMFAC,PAT,"SCRIPTS",$$VAL^XBDIQ1(9000010.09,Y,1201)_" "_$$VAL^XBDIQ1(9000010.09,Y,.01))=""
 .;now check numerator
 .Q:$P($G(^AUPNVLAB(Y,11)),U,9)'="R"  ;if status not resulted it doesn't make the numerator
 .I $$UP^XLFSTR($P(^AUPNVLAB(Y,0),U,4))="COMMENT",'$$HASCOM(Y) Q
 .S $P(APCMLABS(APCMFAC),U,2)=$P(APCMLABS(APCMFAC),U,2)+1 D
 ..S $P(^TMP($J,"PATSRX",APCMFAC,PAT),U,2)=$P($G(^TMP($J,"PATSRX",APCMFAC,PAT)),U,2)+1 S ^TMP($J,"PATSRX",APCMFAC,PAT,"ELEC",$$VAL^XBDIQ1(9000010.09,Y,1201)_" "_$$VAL^XBDIQ1(9000010.09,Y,.01))=""  ;S N=N+G Q  ;S N=N+G
 Q
 ;
HASCOM(L) ;ARE THERE ANY COMMENTS
 I '$D(^AUPNVLAB(L,21)) Q 0
 NEW B,G
 S G=0
 S B=0 F  S B=$O(^AUPNVLAB(L,21,B)) Q:B'=+B  I ^AUPNVLAB(L,21,B,0)]"" S G=1  ;has comment
 Q G
