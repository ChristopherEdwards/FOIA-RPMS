BGP7D21A ; IHS/CMI/LAB - measure 6 ;
 ;;17.0;IHS CLINICAL REPORTING;;AUG 30, 2016;Build 16
 ;
LOINC(A,B) ;EP
 NEW %
 S %=$P($G(^LAB(95.3,A,9999999)),U,2)
 I %]"",$D(^ATXAX(B,21,"B",%)) Q 1
 S %=$P($G(^LAB(95.3,A,0)),U)_"-"_$P($G(^LAB(95.3,A,0)),U,15)
 I $D(^ATXAX(B,21,"B",%)) Q 1
 Q ""
BLINDPL(P,EDATE) ;EP
 NEW X,T,G,R,L,Y,C
 S X=$$PLTAXND^BGP7DU(P,"BGP BILATERAL BLINDNESS DXS",EDATE)
 I X Q 1
 S X=$$IPLSNOND^BGP7DU(P,"PXRM BGP BILAT BLINDNESS",EDATE)
 I X Q 1
 S T="PXRM BGP BLINDNESS UNSPECIFIED"  ;CODE WITH LATERALITY=BILATERAL
 ;LOOP PROBLEM LIST
 S (X,G,R,L)=""
 F  S X=$O(^AUPNPROB("APCT",P,X)) Q:X=""!(G)  D
 .S Y=0 F  S Y=$O(^AUPNPROB("APCT",P,X,Y)) Q:Y'=+Y!(G)  D
 ..Q:'$D(^AUPNPROB(Y,0))
 ..Q:$P(^AUPNPROB(Y,0),U,12)="D"  ;deleted
 ..Q:'$D(^XTMP("BGPSNOMEDSUBSET",$J,T,X))
 ..I EDATE,$P(^AUPNPROB(Y,0),U,13)>EDATE Q  ;if there is a doo and it is after report period skip
 ..I $P(^AUPNPROB(Y,0),U,13)="",EDATE,$P(^AUPNPROB(Y,0),U,8)>EDATE Q  ;no doo, entered after report period, skip
 ..;IS LATERALITY BILATERAL:
 ..S C=$$VAL^XBDIQ1(9000011,Y,.22)
 ..I $$UP^XLFSTR(C)["BILATERAL" S G=1_U_"Problem List: "_X Q  ;$$CONCPT^AUPNVUTL(X)
 ..I $$UP^XLFSTR(C)["LEFT" S L=1
 ..I $$UP^XLFSTR(C)["RIGHT" S R=1
 I G Q G
 I R,L Q 1_U_"Problem List: "_X
 ;NOW CHECK RIGHT AND LEFT SNOMED SUBSETS
 NEW TR,TL
 I 'R D
 .S TR="PXRM BGP RIGHT EYE BLIND"
 .;LOOP PROBLEM LIST
 .S (X,G)=""
 .F  S X=$O(^AUPNPROB("APCT",P,X)) Q:X=""!(G)  D
 ..S Y=0 F  S Y=$O(^AUPNPROB("APCT",P,X,Y)) Q:Y'=+Y!(G)  D
 ...Q:'$D(^AUPNPROB(Y,0))
 ...Q:$P(^AUPNPROB(Y,0),U,12)="D"  ;deleted
 ...Q:'$D(^XTMP("BGPSNOMEDSUBSET",$J,TR,X))
 ...I EDATE,$P(^AUPNPROB(Y,0),U,13)>EDATE Q  ;if there is a doo and it is after report period skip
 ...I $P(^AUPNPROB(Y,0),U,13)="",EDATE,$P(^AUPNPROB(Y,0),U,8)>EDATE Q  ;no doo, entered after report period, skip
 ...S R=1
 I R,L Q 1_U_"Problem List: "_X
 I 'L D
 .S TL="PXRM BGP LEFT EYE BLIND"
 .;LOOP PROBLEM LIST
 .S (X,G)=""
 .F  S X=$O(^AUPNPROB("APCT",P,X)) Q:X=""!(G)  D
 ..S Y=0 F  S Y=$O(^AUPNPROB("APCT",P,X,Y)) Q:Y'=+Y!(G)  D
 ...Q:'$D(^AUPNPROB(Y,0))
 ...Q:$P(^AUPNPROB(Y,0),U,12)="D"  ;deleted
 ...Q:'$D(^XTMP("BGPSNOMEDSUBSET",$J,TL,X))
 ...I EDATE,$P(^AUPNPROB(Y,0),U,13)>EDATE Q  ;if there is a doo and it is after report period skip
 ...I $P(^AUPNPROB(Y,0),U,13)="",EDATE,$P(^AUPNPROB(Y,0),U,8)>EDATE Q  ;no doo, entered after report period, skip
 ...S L=1
 I R,L Q 1_U_"Problem List: "_X
 Q ""
CHDPL(P,EDATE)  ;EP - is dx on problem list as either active or inactive?
 NEW T,T1,T2,T3,SN1,SN2,SN3,SN4
 S T=$O(^ATXAX("B","BGP CHD DXS",0))
 S T1=$O(^ATXAX("B","BGP AMI DXS PAMT",0))
 S T2=$O(^ATXAX("B","BGP IVD DXS",0))
 S T3=$O(^ATXAX("B","BGP TIA DXS",0))
 S SN1="PXRM ISCHEMIC HEART DISEASE"
 S SN2="PXRM BGP AMI"
 S SN3="PXRM BGP IVD"
 S SN4="PXRM BGP ISCHEMIC STROKE TIA"
PL ;
 NEW X,Y,I,S
 S (X,Y,I)=0
 F  S X=$O(^AUPNPROB("AC",P,X)) Q:X'=+X!(I)  D
 .Q:'$D(^AUPNPROB(X,0))
 .Q:$P(^AUPNPROB(X,0),U,12)="D"
 .Q:$P(^AUPNPROB(X,0),U,12)="I"
 .S Y=$P(^AUPNPROB(X,0),U)
 .I EDATE,$P(^AUPNPROB(X,0),U,13)>EDATE Q  ;if there is a doo and it is after report period skip
 .I $P(^AUPNPROB(X,0),U,13)="",EDATE,$P(^AUPNPROB(X,0),U,8)>EDATE Q  ;no doo, entered after report period, skip
 .S S=$$VAL^XBDIQ1(9000011,X,80001) I S]"",$D(^XTMP("BGPSNOMEDSUBSET",$J,SN1,S)) S I=1 Q
 .I S]"",$D(^XTMP("BGPSNOMEDSUBSET",$J,SN2,S)) S I=1 Q
 .I S]"",$D(^XTMP("BGPSNOMEDSUBSET",$J,SN3,S)) S I=1 Q
 .I S]"",$D(^XTMP("BGPSNOMEDSUBSET",$J,SN4,S)) S I=1 Q
 .I $$ICD^BGP7UTL2(Y,T,9) S I=1 Q  ;_U_"Problem List: "_$$VAL^XBDIQ1(9000011,X,.01)
 .I $$ICD^BGP7UTL2(Y,T1,9) S I=1 Q  ;_U_"Problem List: "_$$VAL^XBDIQ1(9000011,X,.01)
 .I $$ICD^BGP7UTL2(Y,T2,9) S I=1 Q  ;_U_"Problem List: "_$$VAL^XBDIQ1(9000011,X,.01)
 .I $$ICD^BGP7UTL2(Y,T3,9) S I=1 Q  ;_U_"Problem List: "_$$VAL^XBDIQ1(9000011,X,.01) 
 .Q
 Q I
